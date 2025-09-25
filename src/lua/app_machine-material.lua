-- machine_material.lua
-- Obtain device NV parameters through adb and display them clearly to the user after localization
-- 
-- Copyright (C) 2025-2026 Penguin Punguin
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
-- You should have received a copy of the GNU Affero General Public License. If not, see <https://www.gnu.org/licenses/>.
--
-- Contact us: 3618679658@qq.com
-- Written with assistance from ChatGPT

-- Set title and window size
os.execute("title Device Information (By Penguin punguin)")
os.execute("mode con: cols=57 lines=35")

-- Import external libraries
local path = require("lua\\path")   -- Tool path variable library
local colors = require("lua\\colors") -- ANSI color code library
local delay = require("lua\\sleep") -- Countdown operations

-- Let user wait
print(colors.cyan .. colors.bright .. "Fetching..." .. colors.reset)
print() -- Print a blank line to make the UI look nicer

-- Check if an adb device is connected
...
	if not state:match("device") then -- If no device is detected
	    print()
		print(colors.red .."[Error] No ADB device detected, please connect a device and try again.".. colors.reset)
		print(colors.green .."Tip: If the device is connected but offline, adb will also be unavailable.".. colors.reset)
		print()
		print("Press any key to exit...")
...
end

-- Set NV query command (with connection check)
...
	is_adb_device_connected()  -- Check device; exits if not connected
...

-- Define corresponding parameters (too many to annotate)
...

-- Clear screen
os.execute("cls")

-- Display results
...
	print(colors.green .. colors.bright .. "Device Type: " .. intype .. "          Platform: " .. fota_platform .. colors.reset)
...
	print(colors.yellow .. colors.bright .. "Software Version: " .. remo_web_sw_version .. colors.reset)
...
	print(colors.yellow .. colors.bright .. "Hardware Version: " .. hw_version .. colors.reset)
...
	print("Manufacturer Website: " .. os_url)
...
	print(colors.green .. colors.bright .. "Device Language: " .. Language .. "            Manufacturer: " .. fota_oem .. colors.reset)
...
	print(colors.cyan .. colors.bright .. "══════ Network Info ════════════════════════════════════════" .. colors.reset)
...
	print(colors.yellow .. colors.bright .. "APN Mode: " .. apn_mode .. "            Current APN: " .. default_apn .. colors.reset)
...
	print(colors.yellow .. colors.bright .. "DMZ Status: " .. DMZEnable .. "               UPNP Status: " .. upnpEnabled .. colors.reset)
...
print(colors.cyan .. colors.bright .. "══════ WIFI Info ═══════════════════════════════════════════" .. colors.reset)
...
	print(colors.green .. colors.bright .. "WIFI Enabled: " .. wifiEnabled .. "              Max Connections: " .. max_station_num .. colors.reset)
...
	print(colors.yellow .. colors.bright .. "Current WIFI Name: " .. SSID1 .. "   Multiple WIFI Names: " .. m_SSID .. colors.reset)
...
print(colors.cyan .. colors.bright .. "══════ Network Info ════════════════════════════════════════" .. colors.reset)
...
	print(colors.bright .. "Backend Address: " .. dhcpDns .. colors.reset)
...
	print(colors.yellow .. colors.bright .. "Backend Password: " .. admin_Password .. colors.reset)
...
    print(colors.cyan .. colors.bright .. "══════ Password Info ═══════════════════════════════════════" .. colors.reset)
	print(colors.yellow .. colors.bright .. "SIM Unlock Code: " .. sim_unlock_code .. colors.reset)
...
    print(colors.cyan .. colors.bright .. "══════ Password Info ═══════════════════════════════════════" .. colors.reset)
	print(colors.yellow .. colors.bright .. "SIM Mode: " .. remo_sim_select .. colors.reset)
	print(colors.yellow .. colors.bright .. "SIM Unlock Code: " .. remo_sim_admin_password .. colors.reset)
...
print(colors.cyan .. colors.bright .. "══════ Remote Control ═══════════════════════════════════════" .. colors.reset)

-- tr069 display
	print(colors.yellow .. colors.bright .. "tr069(acs) Switch: " .. tr069_enable .. "            tr069 Address：" .. tr069_acs_url .. colors.reset)

-- Auto-update display
		print(colors.yellow .. colors.bright .. "Auto Update: Off" .. colors.reset)
		print(colors.yellow .. colors.bright .. "Auto Update: On" ..
		      "       Check Interval: " .. fota_updateIntervalDay .. " days" .. colors.reset)

-- Speed limit display
		print(colors.yellow .. colors.bright .. "Speed Limit: Off" .. colors.reset)
		print(colors.yellow .. colors.bright .. "Speed Limit: On" ..
		      "       Upload Speed: " .. tc_uplink ..
		      "       Download Speed: " .. tc_downlink .. colors.reset)

-- Remo-specific remote server display
	print(colors.yellow .. colors.bright .. "Main Server: " .. remo_root_server_url .. colors.reset)
	print(colors.yellow .. colors.bright .. "Backup Server: " .. remo_root_server_url2 .. colors.reset)
	print(colors.yellow .. colors.bright .. "Backup Server: " .. url3 .. colors.reset)
	print(colors.yellow .. colors.bright .. "Config Server: " .. remo_config_server_url .. "/" .. remo_config_server_path .. colors.reset)
	print(colors.yellow .. colors.bright .. "LED Control Server: " .. remo_led_server_url .. "/" .. remo_led_server_path .. colors.reset)
	print(colors.yellow .. colors.bright .. "Flow Report Server: " .. remo_flow_server_url .. "/" .. remo_flow_server_path .. colors.reset)
	print(colors.yellow .. colors.bright .. "Info Report Server: " .. remo_info_server_url .. "/" .. remo_info_server_path .. colors.reset)

print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════════════════" .. colors.reset)
print()

-- Press any key to exit the program
os.execute("pause")
