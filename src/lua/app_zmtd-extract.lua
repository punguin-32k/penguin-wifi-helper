-- Extract_MTD4.lua
-- Extract device MTD system partition and rename/save as file
--
-- Copyright (C) 2025-2026 Punguin
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
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

-- Set window title and size
os.execute("title Penguin WiFi Assistant - MTD Extract Tool")
os.execute("mode con: cols=66 lines=35")

-- Import external libraries
local path = require("lua\\path")   -- Tool path library
local colors = require("lua\\colors") -- ANSI color codes
local delay = require("lua\\sleep") -- Countdown/delay functions

-- Get absolute path of the script directory
local function get_script_dir()
    local path = io.popen("cd"):read("*l")
    return path .. "\\"
end
local script_dir = get_script_dir()

-- Define target folder path
local qt_folder = script_dir .. "TQ\\"

-- Extract partition
print(colors.blue .. colors.bright .. "Searching for device..." .. colors.reset)
delay.sleep(4) -- Wait for device to be ready
os.execute("bin\\adb pull /dev/mtd4 draw.tmp")   -- Pull MTD firmware partition
print()
print()
print(colors.green .. "Extraction attempted" .. colors.reset)

-- Get user input for new filename
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
io.write("Enter a new filename (without extension): ")
local new_file_name = io.read()
new_file_name = new_file_name:gsub('^%"', ''):gsub('%"$', '') -- Remove quotes if any
new_file_name = new_file_name .. ".bin" -- Append .bin extension

-- Construct full file paths
local old_file_path = script_dir .. "draw.tmp"
local new_file_path = script_dir .. new_file_name

-- Rename file
local success, err = os.rename(old_file_path, new_file_path)
if success then
    print(colors.green .. "File successfully renamed to: " .. new_file_name .. colors.reset)
else
    print(colors.red .. "Rename failed: " .. err .. colors.reset)
end

-- Ensure target folder exists
local function ensure_directory_exists(path)
    local ok, err, code = os.rename(path, path)
    if not ok then
        if code == 2 then
            os.execute('mkdir "' .. path .. '"')
        else
            print(colors.red .. "Cannot check or create directory: " .. err .. colors.reset)
        end
    end
end

ensure_directory_exists(qt_folder)

-- Construct target file path
local target_file_path = qt_folder .. new_file_name

-- Move file to target folder
local success, err = os.rename(new_file_path, target_file_path)
if success then
    print(colors.green .. "File successfully moved to QT folder" .. colors.reset)
    os.execute("explorer TQ")
    print(colors.green .. colors.bright .. "Script executed correctly, window will close in 5 seconds" .. colors.reset)
    delay.sleep(5)
else
    print(colors.red .. "Failed to move file: " .. err .. colors.reset)
    os.execute("pause")
end
