-- so.lua
-- A simple MTD flashing tool (work in progress)
-- 
-- Copyright (C) 2025-2026 Penguin Punguin
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
-- You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
--
-- Contact us: 3618679658@qq.com
-- Assisted by ChatGPT in development and writing

-- Set terminal title and window size
os.execute("title Penguin PINGUIN_run Block Flashing Tool     Current Version: 1.0 Beta")
os.execute("mode con: cols=66 lines=35")

-- Import external libraries
local path = require("lua\\path") -- Utility path variable library
local colors = require("lua\\colors") -- ANSI color code library
local delay = require("lua\\sleep") -- Countdown operation

-- Print warning message
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
print(colors.red .. 'Warning! Any file you input will be directly transferred to /tmp/ on the device.' .. colors.reset)
print(colors.red .. "Please ensure the file size does not exceed 3.19 MB." .. colors.reset)
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)

-- Get the script's directory
local script_dir = debug.getinfo(1).source:match("@?(.*/)")   -- Define a parameter named "script_dir"
if not script_dir then                                        -- Loop to get the "./" path
    script_dir = "."
end

-- Prompt user to input file path or drag a file into the window
io.write("Please enter the file path or drag a file into this window: ")  -- Pause execution to allow user input
local file_path = io.read()                                               -- Assign the dragged file to the "file_path" variable
file_path = file_path:gsub('^%"', ''):gsub('%"$', '')                     -- Remove surrounding double quotes from the file path (if any)

-- Check if the file exists
local function file_exists(path)                                          -- Use the previously set file variable
    local file = io.open(path, "rb")                                      -- Open the file the user just entered
    if file then                                                          -- Remaining code checks file existence
        file:close()
        return true
    else
        return false
    end
end

if not file_exists(file_path) then                                        -- If file doesn't exist, notify user
    print(colors.red .. "File does not exist: " .. file_path .. ". Script exited." .. colors.reset)
    os.execute("pause")
    return
end

-- Copy and rename the file
local destination_path = script_dir .. "/mtds.new"                        -- Set the renamed file as "mtds.new"
local input_file = io.open(file_path, "rb")                               -- Set copy mode to "rb"
local output_file = io.open(destination_path, "wb")                       -- Set write mode to "wb"

if input_file and output_file then                                        -- Perform copy and rename
    output_file:write(input_file:read("*all"))
    input_file:close()
    output_file:close()
    print("File copied and renamed to: " .. destination_path)             -- Print result
else
    print("File copy failed.")                                            -- Print result
    os.execute("pause")
    return                                                                -- Exit script
end

-- Check if busybox file exists
local busybox_path = script_dir .. "\\file\\busybox"                      -- Set the file to check
if not file_exists(busybox_path) then                                     -- Print result
    print("busybox file not found: " .. busybox_path)                     -- Print result
    os.execute("pause")
    return                                                                -- Exit script
end

-- Use adb push to transfer files to the connected device's /tmp directory
os.execute('adb push "' .. destination_path .. '" /tmp/')                 -- Upload file via ADB
os.execute('adb push "' .. busybox_path .. '" /tmp/')                     -- Upload busybox via ADB
print(colors.green .. "File and busybox have been transferred to the device's /tmp directory." .. colors.reset)
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)

-- Delete temporary file
os.execute("del mtds.new")                                                -- Delete "mtds.new", the temporary file created from user input

-- Ask user to confirm critical operation
print(colors.red .. 'Warning! The next step involves critical MTD block flashing.' .. colors.reset)
print(colors.red .. colors.bright .. 'Flashing failure may render your device unbootable!' .. colors.reset)
print(colors.green .. 'Please confirm whether you want to proceed with the MTD block update.' .. colors.reset)
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
io.write("Type 'yes' to continue: ")                                      -- Pause execution for user input
local input = io.read()                                                   -- Store user input in variable "input"
if input ~= "yes" then                                                    -- Compare input to "yes"
    print("You declined. Exiting program.")
    print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
    os.execute("pause")
    os.exit() -- Exit program
else
    print(colors.green .. "Confirmed. Continuing execution." .. colors.reset)
    print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
end

print(colors.red .. '!Main flashing thread will activate in 5 seconds! You have 5 seconds to reconsider!' .. colors.reset)
delay.sleep(5) -- Delay 5 seconds
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)

-- Perform MTD block flashing
print(colors.cyan .. colors.bright .. "Attempting to grant critical permissions to busybox..." .. colors.reset)
os.execute("adb shell chmod +x /tmp/busybox")
print(colors.green .. "busybox has been granted execute permissions." .. colors.reset)
print(" ")
print(colors.cyan .. colors.bright .. "Attempting to flash MTD4 using dd..." .. colors.reset)
os.execute("adb shell /tmp/busybox nohup dd if=/tmp/mtds.new of=/dev/mtd4 &")
print(colors.red .. "Device will automatically reboot a few seconds after partition write completes." .. colors.reset)
print(colors.bright .. "(==0%)" .. colors.reset)
delay.sleep(10) -- Delay 10 seconds
print(colors.bright .. "(=======20%)" .. colors.reset)
print(colors.bright .. "(=============30%)" .. colors.reset)
print(colors.bright .. "(===================40%)" .. colors.reset)
print(colors.bright .. "(=========================50%)" .. colors.reset)
print(colors.bright .. "(===============================66%)" .. colors.reset)
delay.sleep(10) -- Delay 10 seconds
print(colors.bright .. "(======================================79%)" .. colors.reset)
delay.sleep(9) -- Delay 9 seconds
print(colors.bright .. "(===========================================83%)" .. colors.reset)
delay.sleep(12) -- Delay 12 seconds
print(colors.bright .. "(=================================================96%)" .. colors.reset)
delay.sleep(6) -- Delay 6 seconds
print(colors.bright .. "(=======================================================99%)" .. colors.reset)
delay.sleep(60) -- Delay 60 seconds
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
print(colors.green .. "Flashing completed. Your device should boot normally." .. colors.reset)
print(colors.red .. "If it doesn't power on, wait two minutes before unplugging." .. colors.reset)
print(colors.red .. "Actual flashing time may differ from our estimate." .. colors.reset)
os.execute("pause")
