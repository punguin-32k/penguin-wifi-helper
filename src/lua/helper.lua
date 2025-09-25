-- helper.lua
-- Penguin WIFI Helper: an integrated toolbox for convenient device management
-- 
-- Copyright (C) 2025-2026 Penguin
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
-- You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
--
-- Contact us: 3618679658@qq.com
-- Assisted by ChatGPT in development and writing
-- Set terminal title and window size
os.execute("title Penguin WIFI Helper (Assisted by ChatGPT)                      Current Version: 5.2        Author QQ:3618679758, Official QQ Group:725700912 ")
os.execute("mode con: cols=113 lines=32")
-- Import external libraries
local path = require("lua\\path") -- Utility path variable library
local colors = require("lua\\colors") -- ANSI color code library
local delay = require("lua\\sleep") -- Countdown operation
-- Get current script directory
local script_dir = debug.getinfo(1, "S").source:match("@(.*[/\\])")
-- Execute ADB command and return result
local function exec_command(cmd)       -- Define command type label, similar to cmd
    local file = io.popen(cmd)         -- Handle returned cmd type
    local output = file:read("*all")   -- Read all output
    file:close()                       -- Close file handle
    return output                      -- Return output
end
-- Check ADB connection status
local function check_adb_status()
    local adb_path = path.adb -- Call adb.exe
    -- Run adb devices command to get connected device list
    local adb_output = exec_command(adb_path .. " devices 2>nul")
    -- Check if output contains valid device info
    local has_device = false        -- Match "device"
    local is_offline = false        -- Match "offline"
    for line in adb_output:gmatch("[^\r\n]+") do   -- Set output line matching
        if line:match("device$") then      -- Match "device"
            has_device = true              -- If matched, mark as connected
        elseif line:match("offline") then  -- Match "offline"
            is_offline = true              -- If matched, mark as offline
        end
    end
    -- Output result with color formatting
    if has_device and not is_offline then
        print(colors.yellow .. colors.bright .. "Device Status: " .. colors.reset .. colors.green .. colors.bright .."Connected" .. colors.reset)
    elseif is_offline then
        print(colors.yellow .. colors.bright .. "Device Status: " .. colors.reset .. colors.green ..  colors.bright .."Connected (".. colors.reset .. colors.red .."Offline" .. colors.reset .. colors.green ..  colors.bright ..")".. colors.reset)
    else
        print(colors.yellow .. colors.bright .. "Device Status: " .. colors.reset .. colors.red .. "No Device" .. colors.reset)
    end
end
-- NV query command
function get_nv_value(param)
	local command = "bin\\adb shell nv get " .. param
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	local value = result:gsub("%s+", "")
	return value
end
-- Encapsulated function to check serial port connection
function check_serial()
    -- Detect if any serial port is available on the system
    local function is_serial_port_connected()
        for i = 1, 256 do
            local com_port = "\\\\.\\COM" .. i
            local file = io.open(com_port, "r")
            if file then
                file:close()
                return true -- If opened successfully, serial port exists
            end
        end
        return false -- If none opened, no serial port
    end
    -- Output result
    if is_serial_port_connected() then
	    print(colors.yellow .. colors.bright .. "Serial Port Status (AT etc.): " .. colors.reset .. colors.green .. colors.bright .."Connected" .. colors.reset)
    else
	    print(colors.yellow .. colors.bright .. "Serial Port Status (AT etc.): " .. colors.reset .. colors.red .. "No Device" .. colors.reset)
    end
end
-- Function to fetch cloud version info
local function check_version()
    local local_version = "5.2"  -- Replace with local version number
    local temp_version_file = "version.ini" -- Temporary version file
    -- Extract cloud version from version file
    local function get_version_from_html(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return nil
        end
        for line in file:lines() do
            local version = line:match("%d+%.%d+[%w%-]*") -- "%d.%d" is version format, e.g., X.X (numeric)
            if version then
                file:close()
                return version
            end
        end
        file:close()
        return nil
    end
    local cloud_version = get_version_from_html(temp_version_file)
    --os.remove(temp_version_file) -- Delete temporary version file (disabled since v4.5)
    -- Output version info
    if cloud_version then
        print(colors.bright .."Latest Version: " .. cloud_version .. "  Current Version: " .. local_version .. colors.reset)
    else
        print(colors.bright .."Failed to retrieve cloud version" .. colors.reset)
    end
end
-- Check if an ADB device is connected
local function is_adb_device_connected()
	local check = io.popen("bin\\adb get-state")
	local state = check:read("*a")
	check:close()
	if not state:match("device") then -- Output if no device
	    print()
		print(colors.red .."[Error] No ADB device detected. Please connect a device and try again.".. colors.reset)
		print(colors.green .."Tip: If the device is connected but offline, ADB will be unavailable.".. colors.reset)
		print()
		io.read()  -- Wait for user input
		os.execute("bin\\lua54 lua\\helper.lua")
		io.read()  -- Wait for user input
	end
end
local function mtd_check() -- Display device MTD mount status
        print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
        print("Below is your device's MTD mount status")
        print()
        os.execute("bin\\adb shell cat /proc/mtd")
        print()
		print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
        print("Normally, mtd4:'rootfs'")
		print(" A few devices use mtd4:'imagefs'")
		print(" This toolbox currently only supports devices with mtd4:'rootfs'")
		print(" Support for mtd5 devices may be added later")
		print()
		os.execute("pause")
end
local function install_drive() -- Triple-in-one driver installer
  print(colors.cyan .. colors.bright .. "════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
  print("Please select the driver to install (if never installed, it's recommended to install all):")
  print()
  print(colors.cyan .. colors.bright .. "           1. Universal Android ADB Driver      2. ZTE ZXIC Driver      3. Quectel ASR Dedicated Driver       4. UNISOC SPD Universal Driver" .. colors.reset)
  print()
  print(colors.red .. colors.bright .."Tip: The ZTE driver is a quick-install driver; installation only shows a CMD window. If successful, it closes automatically.".. colors.reset)
  print()
  io.write(colors.green .. "Enter a number and press Enter: " .. colors.reset)
  local drive_selection = io.read()
    if drive_selection == "1" then
     os.execute("start file\\drive\\vivo-drive.exe")
    elseif drive_selection == "2" then
     os.execute("start file\\drive\\ZXIC_Develop_Driver.exe")
	 print()
	 io.write(colors.green .. "Press any key to start installing supplementary driver......" .. colors.reset)
	 io.read()
     os.execute("start file\\drive\\zxicser.exe")
    elseif drive_selection == "3" then
     os.execute("start file\\drive\\Quectel_LTE_Windows_USB_Driver.exe")
    elseif drive_selection == "4" then
     os.execute("start file\\drive\\SPD_Driver\\DriverSetup.exe")
    end
end
local function set_adb()   -- Set device ADB (code from v3.21, integrated in v4.0)
  print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
  print()
  -- Prompt user to enter IP address and store as temporary variable ipAddress
  print(colors.red .. colors.bright .. "Warning! Please connect to the device's Wi-Fi or network first, otherwise the program will hang [smiley]" .. colors.reset)
  print()
  print()
  io.write(colors.green .. "Device WEB address (e.g., 192.168.100.1): "  .. colors.red .. colors.bright)
  local ipAddress = io.read()
  print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
  -- Print operation menu
  print()
  print(colors.cyan .. colors.bright .."Tips:".. colors.reset .. colors.green .. " Some manufacturers remove the adbd backend, so even after enabling ADB, the device remains unusable (offline mode). See device status on the helper homepage.")
  print()
  print(colors.cyan .. colors.bright .." =------".. colors.magenta .. colors.bright .."Select Mode" .. colors.cyan .. colors.bright .."------------------------------------------------------------------------------------------------=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."1. Debug Mode (ADB+AT+Network)     2. Factory Port Mode (AT Only)       3. System Mode Only (Use with Caution)        4. Disable All Modes       ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."5. Remo Dedicated Debug Mode (ADB+AT+Network)                                                                          ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =--------------------------------------------------------------------------------------------------------------=")
  print()
  -- Let user select operation and store in temporary variable
  io.write(colors.green .. "Enter a number and press Enter: ".. colors.red .. colors.bright)
  local adb_selection = io.read()
  -- Filter input and execute corresponding action
    if adb_selection == "1" then
      print(colors.blue .. colors.bright)
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=2"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=1"')
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1"')
	  -- Integrated Qrzl password in v5.1
	  print()
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1&password=coolfish666@Qiruizhilian20241202"')
	  print()
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1&password=xscmadmin888@Qiruizhilian20241202"')
	  print()
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1&password=MM888@Qiruizhilian20241202"')
	  print()
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1&password=159258@Qiruizhilian20241202"')
	  print(colors.green .. colors.bright .."
Rebooting device in 5 seconds....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."
Operation completed, returning shortly" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "2" then
      print(colors.blue .. colors.bright)
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=2"')
      print(colors.green .. colors.bright .."
Rebooting device in 5 seconds....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."
Operation completed, returning shortly" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "3" then
      print(colors.blue .. colors.bright) 
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=3"')
      print(colors.green .. colors.bright .."
Rebooting device in 5 seconds....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."
Operation completed, returning shortly" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "4" then
      print(colors.blue .. colors.bright)
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=SET_DEVICE_MODE&debug_enable=0"')
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=ID_SENDAT&at_str_data=AT%2BZMODE%3D0"')
	  print(colors.green .. colors.bright .."
Rebooting device in 5 seconds....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REBOOT_DEVICE"')
      os.execute('bin\\curl "http://'..ipAddress..'/goform/goform_set_cmd_process?goformId=REBOOT_DEVICE"')
      print(colors.green .. colors.bright .."
Operation completed, returning shortly" .. colors.reset)
      delay.sleep(3)
    elseif adb_selection == "5" then -- This part copied from ufitool
	  print(colors.red .. colors.bright .."
Warning: This method comes from Remo internal staff" .. colors.blue .. colors.bright)
	  print(colors.red .. colors.bright .."Only applicable to 4th-gen devices and earlier (i.e., before June 2024). Other versions may encounter errors." .. colors.blue .. colors.bright)
	  print("
")
	  print(colors.green .. colors.bright .."
Sending request to system....." .. colors.blue .. colors.bright)
	  delay.sleep(2)
	  print(colors.blue .. colors.bright)
	  os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=LOGIN&password=cmVtb19zdXBlcl9hZG1pbl8yMjAx"')
	  os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=LOGIN&password=YWRtaW4%3D"')
	  print(colors.green .. colors.bright .."
Block detected, bypassing....." .. colors.blue .. colors.bright)
	  delay.sleep(3)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=REMO_SIM_SELECT_R1865&isTest=false&sim_option_id=3&select_sim_mode=1"')
	  print(colors.green .. colors.bright .."
Temporary API found, hijacking debug mode in reverse....." .. colors.blue .. colors.bright)
	  delay.sleep(2)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SysCtlUtal&action=System_MODE&debug_enable=1"')
	  delay.sleep(2)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=ID_SENDAT&at_str_data=AT%2BZMODE%3D1"')
	  delay.sleep(2)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?goformId=SET_DEVICE_MODE&debug_enable=1"')
      print(colors.green .. colors.bright .."
Rebooting device in 5 seconds....." .. colors.blue .. colors.bright)
      delay.sleep(5)
      os.execute('bin\\curl "http://'..ipAddress..'/reqproc/proc_post?isTest=false&goformId=RESTORE_FACTORY_SETTINGS"')
      print(colors.green .. colors.bright .."
Operation completed, returning shortly" .. colors.reset)
      delay.sleep(3)
	elseif About_stealing == "stealing" then
	  A = "I admit the Remo code segment was stolen from Ufitool"
	  B = "I can't stand the limited usage times per month anymore"
	  C = "Hope Brother Su can forgive me, please understand"
	  D = "Stealing is indeed uncivilized; I feel uneasy doing this"
	  E = "Anyway, hope Brother Su forgives me—please contact me if you see this code"
	  print ("Test, remo adbd By ufitool")
    end
 end
 local intype = get_nv_value("zcgmi")
 local fota_platform = get_nv_value("fota_platform")
 local function ufi_nv_set() -- Optimize device by setting standard NV parameters
  print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
  print()
  if intype ~= "" then
	  print(colors.yellow .. colors.bright .. "Device Type: ".. colors.blue .. intype .. colors.reset)
      print()
	else
	  print()
  end
  print(colors.cyan .. colors.bright .."Tips:".. colors.reset .. colors.green .. " When removing remote control, if the device uses jffs2 or similar systems, the tool will attempt to remove remote control programs.")
  print()
  print(colors.cyan .. colors.bright .." =------".. colors.magenta .. colors.bright .."Select Mode" .. colors.cyan .. colors.bright .."------------------------------------------------------------------------------------------------=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."     1. SZXF Universal Optimization       2. ZTE Native Optimization (SZXK)      3. YiLian Universal Optimization (ALK)       4. Gehang V1.3 Downgrade to V1.2          ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                                                              =")
  print(colors.cyan .. colors.bright .." =    ".. colors.reset .. colors.yellow .."                                                                                                          ".. colors.cyan ..colors.bright .."=")
  print(colors.cyan .. colors.bright .." =                                                                      More devices will be supported via OTA updates—stay tuned!    =")
  print(colors.cyan .. colors.bright .." =--------------------------------------------------------------------------------------------------------------=")
  print()
  -- Let user select operation and store in temporary variable
  io.write(colors.green .. "Enter a number and press Enter: ".. colors.red .. colors.bright)
  local selection = io.read()
  print(colors.reset)
  -- Filter input and execute corresponding action
    if selection == "1" then
	is_adb_device_connected()
	print()
	print("Mounting as read-write")
	os.execute("bin\\adb shell mount -o remount,rw /")
	print()
	print("Disabling and tampering with OTA updates")
	os.execute("bin\\adb shell nv set fota_updateMode=0")
	os.execute("bin\\adb shell nv set fota_updateIntervalDay=365")
	os.execute("bin\\adb shell nv set fota_platform=Punguin")
	os.execute("bin\\adb shell nv set fota_token_rs=0")
	os.execute("bin\\adb shell nv set fota_version_delta_id=")
	os.execute("bin\\adb shell nv set fota_version_delta_url=")
	os.execute("bin\\adb shell nv set fota_version_name=")
	os.execute("bin\\adb shell nv set fota_upgrade_result_internal=")
	os.execute("bin\\adb shell nv set fota_oem=QEJ")
	print("Tampering with remote control config")
	os.execute("bin\\adb shell rm -rf /bin/terminal_mgmt")
	os.execute("bin\\adb shell rm -rf /sbin/ip_ratelimit.sh")
	os.execute("bin\\adb shell nv set traffic_mgmt_enable=0")
	os.execute("bin\\adb shell nv set terminal_mgmt_enable=0")
	os.execute("bin\\adb shell nv set tr069_enable=0")
	os.execute("bin\\adb shell nv set enable_lpa=0")
	os.execute("bin\\adb shell nv set lpa_trigger_host=info.punguin.cn")
	os.execute("bin\\adb shell nv set os_url=http://punguin.cn/")
	os.execute("bin\\adb shell nv set TM_SERVER_NAME=reportinfo.punguin.cn")
	os.execute("bin\\adb shell nv set HOST_FIELD=reportinfo.punguin.cn")
	print("Enhancing features")
	os.execute("bin\\adb shell nv set sim_auto_switch_enable=0")
	os.execute("bin\\adb shell nv set sim_switch=1")
	os.execute("bin\\adb shell nv set sim_unlock_code=az952#")
	os.execute("bin\\adb shell nv set sim_default_type=1")
	os.execute("bin\\adb shell nv set band_select_enable=1")
	os.execute("bin\\adb shell nv set dns_manual_func_enable=1")
	os.execute("bin\\adb shell nv set tr069_func_enable=1")
	os.execute("bin\\adb shell nv set ussd_enable=1")
	os.execute("bin\\adb shell nv set pdp_type=IPv4v6")
	os.execute("bin\\adb shell nv set zcgmi=SZXF-Punguin")
	print("Saving NV settings")
	os.execute("bin\\adb shell nv save")
	print(colors.green .. colors.bright .."NV Editor: Parameters saved".. colors.reset)
	print()
	print(colors.blue .."Adding watermark to device".. colors.reset)
	os.execute([[bin\\adb shell "echo 'copyright = Device software modified by &copy; Penguin Punguin' >> /etc_ro/web/i18n/Messages_zh-cn.properties"]])
	os.execute([[bin\\adb shell "echo 'copyright = Software by: &copy; Penguin Revise' >> /etc_ro/web/i18n/Messages_en.properties"]])
	os.execute([[bin\\adb shell "echo 'nv set cr_version=SZXF-Punguin_P001-20250601 &' >> /etc/rc"]])
	print(colors.green .. colors.bright .."'Read-only file system' is normal".. colors.reset)
	print()
	print()
	print()
	print()
	print()
	print(colors.red .."Modification complete. Changes will be lost after factory reset—do not reset.".. colors.reset)
	print()
	os.execute("pause")  -- Wait for user keypress
	elseif selection == "2" then
	  is_adb_device_connected()
	        print(colors.blue .. colors.bright .."Mounting as read-write..." .. colors.reset)
            os.execute("bin\\adb shell mount -o remount,rw /")
            -- Try creating test file in /sbin/
		    print()
	     	print(colors.blue .. colors.bright .."Checking filesystem..." .. colors.reset)
            local createFileCmd = "bin\\adb shell touch /sbin/test 2>&1" -- Capture error output
            local handle = io.popen(createFileCmd)
            local result = handle:read("*a")
            handle:close()
            -- Check if output contains "Read-only"
            if result:find("Read") then
		       print(colors.red .. "Your device system is read-only. Please try using a programmer." .. colors.reset)
			   print()
			   os.execute("pause")
            else
            -- Modify device
			--os.execute("pause") -- For debugging, prevents erroneous modification
			print(colors.green .. colors.bright .."Root mounted as read-write. Stopping manufacturer services...".. colors.reset)
			os.execute("bin\\adb shell killall fota_Update")
			os.execute("bin\\adb shell killall fota_upi")
			os.execute("bin\\adb shell killall zte_mqtt_sdk &")
			print()
			print(colors.green .. colors.bright .."Multiple processes stopped".. colors.reset)
			print()
			print(colors.yellow .."Optimizing device NV config...".. colors.reset)
			os.execute("bin\\adb shell nv set mqtt_syslog_level=0")
			os.execute("bin\\adb shell nv set dm_enable=0")
			os.execute("bin\\adb shell nv set mqtt_enable=0")
			os.execute("bin\\adb shell nv set tc_enable=0")
			os.execute("bin\\adb shell nv set tc_downlink=")
			os.execute("bin\\adb shell nv set tc_uplink=")
			os.execute("bin\\adb shell nv set tr069_enable=0")
			os.execute("bin\\adb shell nv set fota_updateMode=0")
			os.execute("bin\\adb shell nv set fota_version_delta_id=")
			os.execute("bin\\adb shell nv set fota_version_delta_url=")
			os.execute("bin\\adb shell nv set fota_version_name=")
			os.execute("bin\\adb shell nv set fota_upgrade_result_internal=")
			os.execute("bin\\adb shell nv save")
			print(colors.green .. colors.bright .."NV Editor: Parameters saved".. colors.reset)
			print()
	        print(colors.blue .."Adding watermark to device".. colors.reset)
			os.execute([[bin\\adb shell "echo 'copyright = Device software modified by &copy; Penguin Punguin' >> /etc_ro/web/i18n/Messages_zh-cn.properties"]])
			os.execute([[bin\\adb shell "echo 'copyright = Software by: &copy; Penguin Revise' >> /etc_ro/web/i18n/Messages_en.properties"]])
			os.execute([[bin\\adb shell "echo 'nv set cr_version=SZXK-Punguin_P049U-20250601 &' >> /etc/rc"]])
			print(colors.green .. colors.bright .."'Read-only file system' is normal".. colors.reset)
			print()
			print(colors.yellow .."Modifying device files...".. colors.reset)
			os.execute("bin\\adb push file\\gsmtty /bin")
			os.execute('bin\\adb shell "chmod +x /bin/gsmtty"')
			os.execute("bin\\adb shell gsmtty AT+ZCARDSWITCH=0")
			os.execute("bin\\adb push file\\hosts /etc/hosts")
			os.execute("bin\\adb shell chmod +x /etc/hosts")
			os.execute("bin\\adb shell rm -r -rf /sbin/tc_tbf.sh")
			os.execute("bin\\adb push file\\tc_tbf.sh /sbin/tc_tbf.sh")
            os.execute("bin\\adb shell rm -rf /sbin/start_update_app.sh")
            os.execute("bin\\adb shell rm -rf /bin/fota_Update")
            os.execute("bin\\adb shell rm -rf /bin/fota_upi")
			print()
			print(colors.yellow .."Adding kill commands to startup script...".. colors.reset)
			os.execute([[bin\\adb shell "echo 'killall zte_de &' >> /etc/rc"]])
            os.execute([[bin\\adb shell "echo 'killall ztede_timer &' >> /etc/rc"]])
            os.execute([[bin\\adb shell "echo 'killall zte_mqtt_sdk &' >> /etc/rc"]])
			print()
			print(colors.yellow .."Cleaning temporary files...".. colors.reset)
			os.execute("bin\\adb shell rm -r -rf /bin/miniupnp")
			os.execute("bin\\adb shell rm -r -rf /bin/gsmtty")
			os.execute("bin\\adb shell reboot")
			print()
			print(colors.green .. colors.bright .."Done. Please wait for device to boot up.".. colors.reset)
	        print()
	        print()
	        print()
	        print()
	        os.execute("pause")  -- Wait for user keypress
		end
	elseif selection == "3" then
		-- Simplified command execution wrapper
		local function run(cmd)
			os.execute(cmd)
		end
		local function adb(cmd)
			run("bin\\adb " .. cmd)
		end
		local function ateer(cmd)
			run("bin\\ATeer " .. cmd)
		end
		-- Check ADB state
		local function get_adb_state()
			local handle = io.popen("bin\\adb devices 2>nul")
			local result = handle:read("*a")
			handle:close()
			local serial, state = result:match("(%d+%S*)%s+(%S+)")
			if serial and state then
				return state
			else
				return nil
			end
		end
		-- Wake up adbd
		local function wake_adb()
			print("Attempting to wake up device ADB...")
			ateer("at+shell=adbd")
		end
		-- Check if system is read-only
		local function is_system_readonly()
			local tmp_output_file = "adb_tmp.txt"
			adb("shell mount -o remount,rw /")
			run('bin\\adb shell "touch /sbin/test" 2>&1 > ' .. tmp_output_file)
			local file = io.open(tmp_output_file, "r")
			if not file then
				print("Unable to read temporary output file.")
				return true -- Default to read-only on error
			end
			local output = file:read("*a")
			file:close()
			os.remove(tmp_output_file)
			return output:lower():match("read") ~= nil
		end
		-- Handle read-only system logic
		local function handle_readonly()
		  print()
			print(colors.green .. colors.bright .."System is read-only. Executing read-only specific code...".. colors.reset)
			print(colors.yellow .."Optimizing device NV config...".. colors.reset)
			adb("shell nv set dm_enable=0")
			adb("shell nv set mqtt_enable=0")
			adb("shell nv set tc_enable=0")
			adb("shell nv set tc_downlink=")
			adb("shell nv set tc_uplink=")
			adb("shell nv set fota_updateMode=0")
			adb("shell nv set fota_version_delta_id=")
			adb("shell nv set fota_version_delta_url=")
			adb("shell nv set fota_version_name=")
			adb("shell nv set fota_upgrade_result_internal=")
			adb("shell nv set fl_autoswitchsim=0")
			adb("shell nv set alk_sim_select=0")
			adb("shell nv set path_sh=/etc_rw/sbin")
			adb("shell nv save")
			print(colors.green .. colors.bright .."NV Editor: Parameters saved".. colors.reset)
			print()
			adb("shell mkdir -p /etc_rw/sbin")
			adb("shell cp /sbin/*.sh /etc_rw/sbin/")
			print(colors.yellow .."Modifying device files...".. colors.reset)
			adb([[shell "echo 'killall iccid_check' >> /etc_rw/sbin/global.sh"]])
			adb([[shell "echo 'killall mqtt_client' >> /etc_rw/sbin/global.sh"]])
			adb([[shell "echo 'killall vsim' >> /etc_rw/sbin/global.sh"]])
			adb([[shell "echo 'killall rmc' >> /etc_rw/sbin/global.sh"]])
			adb("shell reboot")
			print()
			print()
			print(colors.red .."Modification complete. Changes will be lost after factory reset—do not reset.".. colors.reset)
			os.execute("pause")  -- Wait for user keypress
		end
		-- Handle read-write system logic
		local function handle_rw()
			print(colors.green .. colors.bright .."System is read-write. Executing read-write specific code...".. colors.reset)
			print(colors.yellow .."Optimizing device NV config...".. colors.reset)
			adb([[shell "echo 'tc_enable=0' >> /etc_ro/default/default_parameter_sys"]])
			adb([[shell "echo 'alk_sim_select=0' >> /etc_ro/default/default_parameter_user"]])
			adb([[shell "echo 'fota_updateMode=0' >> /etc_ro/default/default_parameter_user"]])
			adb("shell nv set tc_enable=0")
			adb("shell nv setro alk_server=0.1.2.3")
			adb("shell nv save")
			print(colors.green .. colors.bright .."NV Editor: Parameters saved".. colors.reset)
			print(colors.blue .."Adding watermark to device".. colors.reset)
			adb([[shell "echo 'copyright = Device software modified by &copy; Penguin Punguin' >> /etc_ro/web/i18n/Messages_zh-cn.properties"]])
			adb([[shell "echo 'copyright = Software by: &copy; Penguin Revise' >> /etc_ro/web/i18n/Messages_en.properties"]])
			adb([[shell "echo 'nv set cr_version=ALK-Punguin_P049U-20250813 &' >> /etc/rc"]])
			print()
			print(colors.yellow .."Modifying device files...".. colors.reset)
			adb("shell rm -rf bin/iccid_check")
			adb("shell rm -rf bin/mqtt_client")
			adb("shell rm -rf bin/vsim")
			adb("shell rm -rf bin/rmc")
			adb("shell rm -rf /sbin/fl_set_iptables.sh")
			print(colors.red .."Modification complete. Changes are persistent—device can be factory reset safely.".. colors.reset)
			os.execute("pause")  -- Wait for user keypress
		end
		-- Check system read-write status and execute logic
		local function check_system_rw()
			print(colors.yellow .."Detecting if device system is read-only...".. colors.reset)
			if is_system_readonly() then
				print(colors.green .. colors.bright .."Result: System is read-only.".. colors.reset)
				print()
				handle_readonly()
			else
				print(colors.green .. colors.bright .."Result: System is read-write.".. colors.reset)
				print()
				handle_rw()
			end
		end
		-- Main execution logic
		local function main()
			local state = get_adb_state()
			if not state then
				print(colors.red .."No device detected. Please enable ADB or connect a device.".. colors.reset)
				run("pause")
				return
			end
			if state == "device" then
				print(colors.green .. colors.bright .."Device connected.".. colors.reset)
				print()
				check_system_rw()
				run("pause")
				return
			end
			if state == "offline" then
				print(colors.yellow .."Device state detected as offline.".. colors.reset)
				io.write(colors.cyan .. colors.bright .."Wake up device ADB? (y/n): ".. colors.reset)
				local choice = io.read()
				if choice:lower() == "y" then
					wake_adb()
					local new_state = get_adb_state()
					if new_state == "device" then
						print(colors.green .. colors.bright .."Device online successfully. ADB is ready.".. colors.reset)
						check_system_rw()
					else
						print(colors.red .."Device remains offline. Manual check or reboot may be needed.".. colors.reset)
					end
				else
					print(colors.yellow .."No modifications made to this device.".. colors.reset)
				end
				run("pause")
				return
			end
			print(colors.yellow .."Unknown device state: " .. state .. colors.reset)
			run("pause")
		end
		main()
	elseif selection == "4" then
	is_adb_device_connected()
	        print(colors.blue .. colors.bright .."Mounting as read-write..." .. colors.reset)
            os.execute("bin\\adb shell mount -o remount,rw /")
            -- Try creating test file in /sbin/
		    print()
	     	print(colors.blue .. colors.bright .."Checking filesystem..." .. colors.reset)
            local createFileCmd = "bin\\adb shell touch /sbin/test 2>&1" -- Capture error output
            local handle = io.popen(createFileCmd)
            local result = handle:read("*a")
            handle:close()
            -- Check if output contains "Read-only"
            if result:find("Read") then
		       print(colors.red .. "Your device system is read-only. Please try using a programmer." .. colors.reset)
			   print()
			   os.execute("pause")
            else
            -- Modify device
			print("
")
			print(colors.red .. colors.bright .."Usage Notes:")
			print()
			print("This version currently only supports Gehang GX009 power banks with built-in cables and fast charging,".. colors.reset .. " with SN starting with XFWP25")
			print()
			print(colors.red .. colors.bright .."Commercial bulk modification using this tool is prohibited. We provide no warranty for such usage.".. colors.reset)
			print()
			print("Although Gehang states device modification is forbidden, as owners of purchased devices, we have the right to modify our property.".. colors.reset .. " By doing so, we ".. colors.red .. colors.bright .."voluntarily waive all warranty rights. This tool is completely free and non-commercial.".. colors.reset)
			print("
")
			io.write(colors.green .. "Enter the SN printed on the device cover and press Enter: ".. colors.red .. colors.bright)
			io.read()
			print(colors.green .. colors.bright .."Root mounted as read-write. Stopping manufacturer services...".. colors.reset)
			os.execute("bin\\adb shell killall iccid_check")
			os.execute("bin\\adb shell killall goahead")
			os.execute("bin\\adb shell killall zte_mifi &")
			print()
			print(colors.green .. colors.bright .."Multiple processes stopped".. colors.reset)
			print()
	        print(colors.blue .."Changing system version...".. colors.reset)
			os.execute([[bin\\adb shell "echo 'nv set cr_version=ALK-Punguin_P012-20250814 &' >> /etc/rc"]])
			print()
			print(colors.yellow .."Modifying device files...".. colors.reset)
			os.execute("bin\\adb shell rm -rf /sbin/zte_mifi")
			os.execute("bin\\adb shell rm -rf /bin/iccid_check")
			os.execute("bin\\adb shell rm -rf /bin/goahead")
			os.execute("bin\\adb shell rm -rf -r /etc_ro/web")
			os.execute("bin\\adb shell rm -rf -r /etc_ro/mmi")
			os.execute("bin\\adb shell rm -r -rf /sbin/tc_tbf.sh")
            os.execute("bin\\adb shell rm -rf /sbin/start_update_app.sh")
			print(colors.red .."Device kernel has been removed. DO NOT power off the device.".. colors.reset)
			print(colors.red .."Device kernel has been removed. DO NOT power off the device.".. colors.reset)
			print(colors.red .."Device kernel has been removed. DO NOT power off the device.".. colors.reset)
			print()
			print(colors.green .."Installing new kernel files and patches...".. colors.reset)
			os.execute("bin\\adb push file\\gx009\\zte_mifi /sbin/zte_mifi")
			os.execute("bin\\adb push file\\gx009\\goahead /bin/goahead")
			os.execute("bin\\adb push file\\gx009\\web.zip /tmp/web.zip")
			os.execute("bin\\adb push file\\gx009\\mmi.zip /tmp/mmi.zip")
			os.execute("bin\\adb push file\\gsmtty /bin/gsmtty")
			os.execute("bin\\adb push file\\at_web\\at_server /bin/at_server")
			os.execute("bin\\adb push file\\tc_tbf.sh /sbin/tc_tbf.sh")
			print("
")
			print(colors.yellow .."File transfer complete. Proceeding with extraction...".. colors.reset)
			os.execute('bin\\adb shell "unzip /tmp/web.zip -d /etc_ro/"')
			os.execute('bin\\adb shell "unzip /tmp/mmi.zip -d /etc_ro/"')
			print("
")
			print(colors.blue .."Setting file permissions...".. colors.reset)
			os.execute('bin\\adb shell "chmod +x /sbin/zte_mifi"')
			os.execute('bin\\adb shell "chmod +x /bin/goahead"')
			os.execute('bin\\adb shell "chmod +x /etc_ro/web/*"')
			os.execute('bin\\adb shell "chmod +x /etc_ro/mmi/*"')
			os.execute('bin\\adb shell "chmod +x /bin/at_server"')
			os.execute('bin\\adb shell "chmod +x /bin/gsmtty"')
			print(colors.yellow .."Setting additional runtime backends...".. colors.reset)
			os.execute([[bin\\adb shell "echo 'at_server &' >> /etc/rc"]])
			print()
			print(colors.green .."Switching to external SIM slot...".. colors.reset)
			os.execute("bin\\adb shell gsmtty AT+ZCARDSWITCH=0")
			print()
			print(colors.yellow .."Cleaning temporary files...".. colors.reset)
			os.execute("bin\\adb shell rm -r -rf /bin/gsmtty")
			os.execute("bin\\adb shell reboot")
			print()
			print(colors.green .. colors.bright .."Done. Please wait for device to boot up.".. colors.reset)
	        print()
	        print()
	        print()
	        print()
	        os.execute("pause")  -- Wait for user keypress
	end
  end
end
-- Print options
local function uisoc()
    print(colors.cyan .. colors.bright .. "════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
    print("
")
	print()
    print(colors.yellow .. "       1. Query JuHuo SN" .. colors.reset) 
	print()
    print(colors.blue .. "          2. Modify Device Parameters" .. colors.reset) 
	print()
    print(colors.cyan .. "             3. ResearchDownload" .. colors.reset) 
	print()
    print(colors.green .. "                4. spd_dump" .. colors.reset) 
	print()
    print(colors.white .. "                   5. SIM Switch" .. colors.reset) 
	print()
	print("Press Enter to return")
	print()
	print()
	print()
	print()
	io.write(colors.green .. "Enter and press Enter: " .. colors.reset)
        local choice111 = io.read()
        if choice111 == "1" then
            os.execute("explorer file\\tool\\SN Query")
        elseif choice111 == "2" then
		    os.execute("explorer file\\tool\\Pandora_R22.20.1701")
        elseif choice111 == "3" then
		    os.execute("explorer file\\tool\\ResearchDownload")
        elseif choice111 == "4" then
		    os.execute("explorer file\\tool\\spd_dump")
        elseif choice111 == "5" then
		    print()
            print(colors.red .. colors.bright .. "Warning! Please connect to the device's Wi-Fi or network first, otherwise the program will hang [smiley]" .. colors.reset)
            print()
            print()
		    io.write(colors.green .. "Device WEB address (e.g., 192.168.100.1): "  .. colors.red .. colors.bright)
             local ipAddress = io.read()
			 os.execute('start "" "http://'..ipAddress..'//postesim?postesim=%7B%22esim%22:0%7D"')
		else
            os.execute("bin\\lua54 lua\\helper.lua")
        end
end
 local function mifi_Studio() -- Use MifiStudio to extract device files
    print(colors.cyan .. colors.bright .. "════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
	print()
	print()
	print(colors.green .. colors.bright .."Tips:".. colors.reset .. colors.green .. " 1. This tool directly runs MIFI Home's ZXIC-RomKit for extraction—a feature included since Helper v3.0")
	print()
	print()
	print()
	print()
	print(colors.red .. 'After extraction, your files will be in the ZXIC-RomKit root directory in a folder starting with "Z."'.. colors.reset)
	print()
	print(colors.bright .."Please select an action:")
    print()
    print(colors.cyan .. colors.bright .. "                      1. Open Tool           2. Open Extraction Directory          3. Return" .. colors.reset)
	print()
	io.write(colors.green .. "Enter a number and press Enter: " .. colors.reset)
    local user_Studio_selection = io.read()
        if user_Studio_selection == "1" then
        os.execute("start conhost.exe file\\ZXIC-RomKit\\_ADB一键提取固件.bat")
        elseif user_Studio_selection == "2" then
		os.execute("explorer file\\ZXIC-RomKit")
        end
 end
local function AD()  -- A small ad for livelihood.
os.execute('start "" "https://shimo.im/docs/RKAWMBJLgXu96aq8/"')
end
 local function set_wifi()  -- Set ZTE ZXIC Chinese Wi-Fi, v4.1 feature, 2024-11-14
    print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
    print()
	print(colors.red .. "Usage Notes:".. colors.blue .. colors.bright .." Current version does not support setting Wi-Fi password on your router—only SSID modification is supported, including Chinese characters.")
    print()
	print("         " .. "Supports some emojis and most Chinese characters. If Wi-Fi disappears or becomes unconnectable, long-press the factory reset button.")
	print()
	print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
	io.write(colors.green .. "Device WEB address (e.g., 192.168.100.1): "  .. colors.red .. colors.bright)
    local YOUR_IP = io.read()
    print()
    print(colors.blue .. colors.bright .."Please log into the device admin page on your PC first: http://".. YOUR_IP .."/".. colors.reset)
    print()
    io.write(colors.green .."Enter your SSID: ".. colors.red .. colors.bright)
    local YOUR_SSID = io.read()
    print(colors.reset)
    io.write(colors.green .."Max connected devices: ".. colors.red .. colors.bright)
    local MAX_Access = io.read()
    print(colors.reset)
    -- Prepare the POST data
    local DATA = "goformId=SET_WIFI_SSID1_SETTINGS&ssid=" .. YOUR_SSID ..
                "&broadcastSsidEnabled=0&MAX_Access_num=" .. MAX_Access ..
                "&security_mode=OPEN&cipher=2&NoForwarding=0&show_qrcode_flag=0&security_shared_mode=NONE"
    local TYPES = {
        'goform/goform_set_cmd_process',
        'reqproc/proc_post'
    }
    -- Function to perform the POST request
    local function requ(type)
        local command = "bin\\curl -s -X POST -d \"" .. DATA .. "\" \"http://" .. YOUR_IP .. "/" .. type .. "\" 1>nul 2>nul"
        os.execute(command)
    end
    -- Loop through the request types and execute
    for _, TYPE in ipairs(TYPES) do
        requ(TYPE)
    end
    -- Output result
    print(colors.green .."If Wi-Fi disconnects now, the setting succeeded.")
    print("Otherwise, it failed.")
    io.read(1)
end
local function xr_web()
	is_adb_device_connected()
	print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════════════════════════════════════════════════════════" .. colors.reset)
	print()
	print(colors.cyan .. colors.bright .. "Tips:" .. colors.reset .. colors.green .. " Devices using this program must run jffs2 or similar systems. squashfs read-only compressed filesystems are not supported.")
	print()
	print(colors.cyan .. colors.bright .. " =------" .. colors.magenta .. colors.bright .. "Select Write Mode" .. colors.cyan .. colors.bright .. "--------------------------------------------------------------------------------------------=")
	print(colors.cyan .. colors.bright .. " =                                                                                                              =")
	print(colors.cyan .. colors.bright .. " =" .. colors.reset .. colors.yellow .. "     1. Custom File        2. Universal ATweb Advanced Web                                                                   " .. colors.cyan .. colors.bright .. "=")
	print(colors.cyan .. colors.bright .. " =                                                                                                              =")
	print(colors.cyan .. colors.bright .. " =    " .. colors.reset .. colors.yellow .. "                                                                                                          " .. colors.cyan .. colors.bright .. "=")
	print(colors.cyan .. colors.bright .. " =--------------------------------------------------------------------------------------------------------------=")
	print()
  -- Let user select operation and store in temporary variable
	io.write(colors.green .. "Enter a number and press Enter: " .. colors.red .. colors.bright)
	local web_selection = io.read()
           -- Filter input and execute corresponding action
	print(colors.reset)
	if web_selection == "1" then
		os.execute("start conhost.exe bin\\lua54 lua\\app_zfile-web.lua")
	elseif web_selection == "2" then
		print()
		print(colors.blue .. colors.bright .. "Mounting as read-write..." .. colors.reset)
		os.execute("bin\\adb shell mount -o remount,rw /")
		print()
		print(colors.yellow .. colors.bright .. "Transferring files (hang means unsupported)..." .. colors.reset)
		--os.execute("bin\\adb push file\\at_web\\at_server /bin/at_server")
		--os.execute("bin\\adb shell chmod +x ./bin/at_server")
		--os.execute("bin\\adb push file\\at_web\\at_info.html /etc_ro/web/at_info.html")
		--os.execute("bin\\adb push file\\at_web\\css\\at.css /etc_ro/web/css/at.css")
		--os.execute("bin\\adb push file\\at_web\\js\\at.js /etc_ro/web/js/at.js")
		print()
		print(colors.magenta .. colors.bright .. "Setting auto-start..." .. colors.reset)
		--os.execute([[bin\\adb shell "echo 'at_server &' >> /sbin/rm_dev.sh"]])
		--os.execute("start /min bin\\adb shell at_server &")
		print("
")
		print("
")
		print(colors.green .. "Setup successful!!")
				-- Get device gateway IP
		local handle = io.popen("bin\\adb shell nv get lan_ipaddr")
		local ip = handle:read("*l")
		handle:close()
		if ip and ip:match("%d+%.%d+%.%d+%.%d+") then
			print()
			print(colors.cyan .. "Detected device IP: " .. colors.yellow .. ip .. colors.reset)
			io.write(colors.cyan .. "Open ATweb in browser? (y/n): ")
			local choice = io.read()
			if choice == "y" or choice == "Y" then
				os.execute("start http://" .. ip .. ":9090/at_info.html")
			else
				print("
")
				print(colors.green .."You can manually visit: http://" .. ip .. " on port 9090 and request at_info.html.")
			end
		else
		    print("Please manually visit your device's IP on port 9090 and request at_info.html.")
		end
		print("
")
		print(colors.reset)
		os.execute("pause")
	end
end
-- Print title
local function print_title1()
    os.execute("cls")  -- Clear screen
	print("(C) 2025-2026 Penguin. All rights reserved.".. colors.cyan .. colors.bright .. "                XZ. Uninstall        RE. Refresh Helper      EXIT. Exit Helper
".. colors.reset)
end
-- Print announcement
local function print_announcement()
    print()
    print(colors.blue .. colors.bright .. "Helper Announcement:".. colors.red .."This helper is now complete in the 4G community and will soon be discontinued!
" .. colors.reset)
    check_adb_status()  -- ADB status check
    check_serial() -- Serial port status check
	print(colors.green .. "
" .. "Tip: The official helper QQ group has upgraded to a 2000-member group. Welcome to join: " .. colors.underline_blue .. colors.bright .."725700912" .. colors.reset)
	print()
	check_version() -- Add version info check
	print(colors.blue .. colors.bright .. "If a new version is available in the cloud, type 'new' to download" .. colors.reset)
end
-- Print menu
local function print_menu()
	print()
	print()
    print(colors.yellow .. "            01. Device Info           02. Set Device ADB       03. Driver Install       04. ADB Terminal      05. Device Manager    " .. colors.reset)
    print(colors.cyan .. colors.bright .. "          =------ Operate Device Files-------------------------------------------------------------------------=" .. colors.reset)
    print(colors.cyan .. colors.bright .."          =                                                                                            =".. colors.reset)
    print(colors.cyan .. colors.bright .."          =".. colors.reset .. colors.yellow .."    A. Extract MTD4 Partition    B. Flash MTD4 via Dongle     C. Quick MTD Flash Tool      D. View Device MTD Type     ".. colors.reset .. colors.cyan ..colors.bright .."=" .. colors.reset)
    print(colors.cyan .. colors.bright .."          =                                                                                            =".. colors.reset)
	print(colors.cyan .. colors.bright .."          =".. colors.reset .. colors.yellow .."    E. Write WEB         F. Universal ZTE ZXIC Remote Control Removal     G. Firmware Extraction & Unpacking                           ".. colors.reset .. colors.cyan ..colors.bright .."=" .. colors.reset)
	print(colors.cyan .. colors.bright .."          =                                                                                            =".. colors.reset)
    print(colors.cyan .. colors.bright .. "          =--------------------------------------------------------------------------------------------=" .. colors.reset)
	print("
")
	print(colors.cyan .. colors.bright .. "     Tools & Navigation:" .. colors.reset)
    print()
	print(colors.yellow .. "         1. Serial Port Tool         2. YunXiaoFan Helper      3. 1869 Tool      4. Watermelon ASR Tool (Final)   5. Orz0000 Tool (Egg Sister)" .. colors.reset)
	print()
	print(colors.yellow .. "         6. ZTE ZXIC Set Wi-Fi     7. Data Disappearing Tool      ".. colors.underline_magenta .. "8. UNISOC Zone" .. colors.reset .."  ".. colors.underline_green .. colors.bright .."9. Need a Data SIM?" .. colors.reset)
	print()
	print()
end
-- User input handling loop
    while true do
    print_title1()            -- Title
    print_announcement()      -- Announcement
    print_menu()              -- Menu
    io.write(colors.green .. "Enter and press Enter: " .. colors.reset) -- Prompt user
    local choice = io.read() -- Capture input
    if choice == "A" then
        os.execute("start conhost.exe bin\\lua54 lua\\app_zmtd-extract.lua") -- Partition extraction script
    elseif choice == "B" then
		os.execute("cls")
		os.execute("start conhost.exe file\\dongle_fun\\dongle_fun.bat") -- Call dongle_fun batch
    elseif choice == "C" then
        os.execute("start conhost.exe bin\\lua54 lua\\app_zmtd-brusque.lua")
    elseif choice == "D" then
        mtd_check()
		os.execute("pause")
    elseif choice == "E" then
		xr_web()
	elseif choice == "F" then
        ufi_nv_set()
	elseif choice == "G" then
        os.execute("explorer file\\OpenZxicEditor-For-Windows")
	elseif choice == "H" then
        mifi_Studio()
	elseif choice == "01" then
	    os.execute("start conhost.exe bin\\lua54 lua\\app_machine-material.lua")
	elseif choice == "02" then
        set_adb()
	elseif choice == "03" then
        install_drive()
	elseif choice == "04" then
        os.execute("start bin\\openadb.bat")
	elseif choice == "05" then
        os.execute("start devmgmt.msc")
	elseif choice == "1" then
        os.execute('start "" "https://atmaster.netlify.app/#/"')
	elseif choice == "2" then
        os.execute("start file\\tool\\YXF_TOOL.exe")
	elseif choice == "3" then
        os.execute("start file\\tool\\ZTE_PATCH_1.1.exe")
	elseif choice == "4" then
        os.execute("start file\\tool\\Watermelon-ASR_Tools.exe")
	elseif choice == "5" then
        os.execute("start file\\tool\\UFITOOL_MTD4.exe")
	elseif choice == "6" then
        set_wifi()
	elseif choice == "7" then
        os.execute('start "" "https://net.arsn.cn/"')
	elseif choice == "8" then
        uisoc()
	elseif choice == "9" then
	    AD()
	elseif choice == "new" then
        os.execute('start "" "http://punguin.cn/web-helper"')
    elseif choice == "C" then
         os.execute("start conhost.exe bin\\lua54 lua\\so.lua")
	elseif choice == "RE" then
        os.execute("bin\\lua54 lua\\helper.lua")
	elseif choice == "XZ" then
        os.execute("start unins000.exe")
		break
    elseif choice == "EXIT" then
        print(colors.red .. "Exiting toolbox" .. colors.reset)
        break
    else
        print(colors.red .. "Invalid option. Please try again." .. colors.reset)
		os.execute("pause")
    end
end
