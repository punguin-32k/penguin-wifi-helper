-- zmtd-brusque
-- Penguin WiFi Assistant Flasher V2.1
--
-- Copyright (C) 2025-2026 Punguin
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License.
-- If not, see <https://www.gnu.org/licenses/>.
--
-- Contact: 3618679658@qq.com
-- Created with assistance from ChatGPT

-- Set window variables
os.execute("title Penguin WiFi Assistant  MTD Flasher V2.1")
os.execute("mode con: cols=80 lines=32")

-- Load external libraries
local colors = require("lua\\colors") -- ANSI color codes library
local delay = require("lua\\sleep")   -- countdown operations

-- Terminal and command execution
local function exec(cmd)
    --print("[Executing command] " .. cmd)
    local f = io.popen(cmd .. " 2>&1")
    local res = f:read("*a")
    f:close()
    --print("[Command output] " .. res)
    return res
    -- Uncomment the print statements above if you need to debug
end

-- Check if an ADB device is connected
local function is_adb_device_connected()
    local check = io.popen("bin\\adb get-state")
    local state = check:read("*a")
    check:close()

    if not state:match("device") then -- Output when no device is detected
        print()
        print(colors.red .."[Error] No ADB device detected. Please connect a device and try again.".. colors.reset)
        print(colors.green .."Tip: If the device is connected but offline, ADB cannot communicate with it.".. colors.reset)
        print()
        print("Press any key to exit...")
        io.read()  -- Wait for user input
        os.exit(1)  -- Non-zero exit indicates error
    end
end

local function copy_to_workdir(src_path)
    local filename = src_path:match("([^\\/]+)$")
    exec(string.format('copy /Y "%s" "mtd.bin"', src_path))
    return "mtd.bin"
end

local function get_local_md5(file)
    local output = exec(string.format('bin\\md5sum.exe "%s"', file))
    local md5 = output:match("^(%x+)")
    if not md5 then
        error("[!] Failed to parse local MD5, output: " .. output)
    end
    return md5
end

local function adb_push(local_file, device_file)
    local cmd = string.format('bin\\adb push "%s" "%s"', local_file, device_file)
    exec(cmd)
end

local function get_device_md5(device_file)
    local output = exec(string.format('bin\\adb shell md5sum "%s"', device_file))
    local md5 = output:match("^(%x+)")
    if not md5 then
        error("[!] Failed to parse device MD5, output: " .. output)
    end
    return md5
end

local function compare_md5(local_md5, device_md5)
    print("\n" .. colors.cyan .. colors.bright .."------------------ ".. colors.blue .. colors.bright .."File Transfer Verification".. colors.reset .. colors.cyan .. colors.bright .." ------------------")
    print(string.format(colors.cyan .. colors.bright .."[".. colors.blue .. colors.bright .."*".. colors.cyan .. colors.bright .."]".. colors.blue .." Local file :    ".. colors.reset .. colors.green .."%s", local_md5))
    print(string.format(colors.cyan .. colors.bright .."[".. colors.blue .. colors.bright .."*".. colors.cyan .. colors.bright .."]".. colors.blue .." Device file :   ".. colors.reset .. colors.green .."%s", device_md5))
    if local_md5:lower() == device_md5:lower() then
        print(colors.cyan .. colors.bright .."[".. colors.green .."√".. colors.cyan .. colors.bright .."]".. colors.green ..  colors.bright .." Verification passed, file transfer successful")
        print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
    else
        print(colors.cyan .. colors.bright .."[".. colors.red .."!".. colors.cyan .. colors.bright .."]".. colors.red .. colors.bright .." Verification failed, file may be corrupted. Aborting flash, please restart the device and try again")
        print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
        os.execute("pause")
        os.exit(1)
    end
end

local function prepare_device_environment()
    exec('bin\\adb shell mount -t tmpfs rw,remount /tmp')
    adb_push('file\\busybox', '/tmp/')
    exec('bin\\adb shell ln -s /tmp/busybox /tmp/dd')
    exec('bin\\adb shell ln -s /tmp/busybox /tmp/sh')
    exec('bin\\adb shell ln -s /tmp/busybox /tmp/reboot')
    exec('bin\\adb shell chmod +x /tmp/busybox /tmp/dd /tmp/sh /tmp/reboot')
end

local function optional_backup()
    print(colors.blue .. colors.bright .."Do you want to backup the current partition".. colors.cyan .. colors.bright .." (".. colors.red .."backup may take a long time".. colors.cyan .. colors.bright ..")".. colors.yellow .. colors.bright .." [type 'yes', press Enter to skip]")
    local choice = io.read()
    print(colors.reset)
    if choice:lower() == "yes" then
        local timestamp = os.date("%Y%m%d%H%M")
        local userprofile = os.getenv("USERPROFILE")
        local backup_folder = userprofile .. "\\Desktop\\MTD_Backup"
        local filename = string.format("MTD4_Backup_%s.bin", timestamp)
        local desktop_path = backup_folder .. "\\" .. filename

        os.execute('mkdir "' .. backup_folder .. '" 2>nul')

        local readme_path = backup_folder .. "\\readme.txt"
        local readme_file = io.open(readme_path, "w")
        if readme_file then
            readme_file:write("This folder was generated by Penguin Assistant MTD Flasher. You chose to backup MTD files.\nMultiple backups are supported without overwriting existing files.\n\nYou can restore these MTD files to your device.")
            readme_file:close()
        end

        local command = string.format('bin\\adb pull /dev/mtd4 "%s" > NUL 2>&1', desktop_path)
        os.execute(command)

        print(colors.cyan .. colors.bright .."[".. colors.green .."√".. colors.cyan .. colors.bright .."]".. colors.blue .. colors.bright .." Backup complete. Saved to desktop:\n".. colors.yellow .. colors.bright .. desktop_path .. colors.reset)
        print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
        
    else
        print(colors.cyan .. colors.bright .."[".. colors.red .."!".. colors.cyan .. colors.bright .."]".. colors.red .." Backup skipped as chosen".. colors.reset)
        print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
    end
end

local function upload_flash_files()
    exec('bin\\adb shell killall -9 zte_ufi')
    exec('bin\\adb shell killall -9 zte_mifi')
    exec('bin\\adb shell killall -9 zte_cpe')
    exec('bin\\adb shell killall -9 goahead')
    adb_push('mtd.bin', '/tmp/mtd4.bin')
    exec('bin\\adb shell mkdir -p /mnt/userdata/temp/')
end

local function write_flash_script()
    adb_push("file\\flash.sh", "/mnt/userdata/temp/flash.sh")
    exec('bin\\adb shell chmod +x /mnt/userdata/temp/flash.sh')
end

local function final_confirmation()
    print()
    print(colors.yellow .. colors.bright .."All files have been ".. colors.green .."pushed successfully".. colors.yellow .. colors.bright ..", file verification complete")
    print()
    print(colors.yellow .. colors.bright .."Please double-check the files you provided".. colors.red .." - this is your last chance.")
    print(colors.yellow .. colors.bright .."If correct, press Enter 5 times consecutively".. colors.yellow .. colors.bright ..". ".. colors.red .."Otherwise, unplug the device immediately!".. colors.reset)
    for i = 1, 5 do io.read() end
end

local function execute_flash()
    print(colors.red .. colors.bright .."Warning:".. colors.green .." Flashing will begin soon".. colors.yellow .. colors.bright ..", this window will be occupied by ADB.".. colors.reset)
    print(colors.red .. colors.bright .."Do NOT use the keyboard to avoid incorrect commands!!!".. colors.reset)
    print(colors.green .. colors.bright .."Read this, then press Enter twice. Thank you!".. colors.reset)
    for i = 1, 2 do io.read() end
    print(colors.cyan .. colors.bright .."[".. colors.green .."√".. colors.cyan .. colors.bright .."]".. colors.green ..  colors.bright .." Flashing in progress, do not close this window. Please wait for device reboot...".. colors.reset)
    os.execute("bin\\adb shell /mnt/userdata/temp/flash.sh")
    print()
    print(colors.cyan .. colors.bright .."[".. colors.red .."!".. colors.cyan .. colors.bright .."]".. colors.green ..  colors.bright .." Device flash complete. Wait for device startup. Thank you.".. colors.reset)
    print(colors.green .. colors.bright .."If the device blinks and shuts down, it may brick. Use a programmer to recover!".. colors.reset)
    os.execute("pause")
end

local function print_flash()
    print(colors.cyan .. colors.bright .."[".. colors.blue .. colors.bright .."$".. colors.cyan .. colors.bright .."]".. colors.blue .." Please wait while files and variables are pushed to the device...".. colors.reset)
end

local function print_tip()
    print(colors.cyan .. colors.bright .."---------------------------------------------------".. colors.reset)
end

------------------ Main Flow ------------------
is_adb_device_connected()

print(colors.yellow .. colors.bright .."Drag the file you want to flash into this window and press Enter:".. colors.red)
local user_path = io.read()
print(colors.reset)
copy_to_workdir(user_path)

local local_md5 = get_local_md5("mtd.bin")
adb_push("mtd.bin", "/tmp/mtd4.bin")
local device_md5 = get_device_md5("/tmp/mtd4.bin")
compare_md5(local_md5, device_md5)

prepare_device_environment()
optional_backup()
print_flash()
upload_flash_files()
print_tip()
write_flash_script()
final_confirmation()
execute_flash()
