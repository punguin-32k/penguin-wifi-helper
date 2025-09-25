-- web.lua
-- Simple JFFS2 readable and writable device flashing web backend
--
-- Copyright (C) 2025-2026 Penguin Punguin
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
-- You should have received a copy of the GNU Affero General Public License. If not, see <https://www.gnu.org/licenses/>.
--
-- Contact: 3618679658@qq.com
-- Assisted in writing by ChatGPT

local colors = require("lua\\colors") -- ANSI color code library
local delay = require("lua\\sleep") -- Countdown operation

-- Set terminal title and define window size
os.execute("title Penguin WIFI Assistant_WEB Flash Tool")
os.execute("mode con: cols=66 lines=35")
print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)

-- Define executeADBCommand function to call adb commands via os.execute and capture results, used to check if device is writable and capture output
local function executeADBCommand(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- Define check_file function
local function check_file()
    print(colors.blue .. colors.bright .. "Searching for devices..." .. colors.reset)
    delay.sleep(4)
    os.execute("cls")
    -- Run adb devices command and capture output
    local adbDevicesCommand = "bin\\adb devices"
    local devicesOutput = executeADBCommand(adbDevicesCommand)

    -- Check if any device is connected
    if not string.find(devicesOutput, "\tdevice") then
        print(colors.red .. "No devices currently connected" .. colors.reset)
		os.execute("pause")
        os.exit(1)
    end

    -- Run adb touch command and capture output
    local adbCommand = "bin\\adb shell touch /etc_ro/web/test_file"
    local output = executeADBCommand(adbCommand)

    -- Check if output contains "Read-only file system"
    if string.find(output, "Read") then
        print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
        print(colors.red .. "This device has a read-only file system (squashfs)" .. colors.reset)
        print(colors.blue .. colors.bright .. "Forcibly flashing may cause loss of backend on your device" .. colors.reset)
        os.execute("pause")
        os.exit(1)
    else
        print(colors.green .. colors.bright .."This device has a writable file system, supports file upload (possibly JFFS2)" .. colors.reset)
        print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
    end
end

-- Fix 5.1-Build-250816
folderPath = nil -- Declare global nil variable first
-- End

local function file()
-- Get folder path dragged in by user
print(colors.yellow .."Please drag the folder into this window, then press Enter:" ..colors.red)
  -- Fix 5.1-Build-250816
  -- Remove local, make it global variable
  folderPath = io.read("*l") -- Read user input folder path
  -- End

-- Remove possible quotes
folderPath = folderPath:gsub("\"", "")

-- Check if folder path is valid
local checkCommand = string.format("if exist \"%s\" (echo ok) else (echo not found)", folderPath)
local handle = io.popen(checkCommand)
local result = handle:read("*a")
handle:close()

if not result:find("ok") then
    print(colors.red .. "Invalid folder path!")
	os.execute("pause")
    os.exit(1)
end
end

-- Get current Lua script directory
local function getScriptDirectory()
    local str = arg[0]
    return str:match("(.*/)") or str:match("(.*\\??") or ".\\"
end

-- Create directory
local function createDirectory(path)
    os.execute("mkdir \"" .. path .. "\"")
end

-- Execute ADB command and return result
local function executeADBCommand(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- Backup /etc_ro/web folder to specified directory
local function backupWebFolder(tempBackupPath)
    print()
    print(colors.green .. "Backing up device backend WEB folder..." .. colors.blue)
    local backupCommand = "bin\\adb pull /etc_ro/web \"" .. tempBackupPath .. "\""
    return executeADBCommand(backupCommand)
end

-- Move and rename backup folder
local function moveBackupFolder(tempBackupPath, backupDir)
    -- Ask user for folder name
	print()
    print(colors.yellow .. "Please enter the name of the backup folder:" .. colors.red)
    local folderName = io.read()
	print(colors.blue)

    -- Move and rename folder
    local moveCommand = "move /Y \"" .. tempBackupPath .. "\" \"" .. backupDir .. folderName .. "\""
    local moveResult = os.execute(moveCommand)
    print(colors.reset)
	
    -- Check move result
    if moveResult then
	    print()
        print(colors.green .. "Backup completed, files saved to: " .. backupDir .. folderName .. colors.reset)
		os.execute("explorer TQ")
    else
	    print()
        print(colors.red .. "Failed to move files, please check permissions." .. colors.reset)
    end
end

-- Encapsulate the entire backup process
local function Backup_web()
    local scriptDir = getScriptDirectory()

    -- Set backup save path
    local tempBackupPath = scriptDir .. "web_backup" -- Backup directly to script directory
    local backupDir = scriptDir .. "TQ\\"

    -- Ask user if they want to backup /etc_ro/web folder
	print()
    print(colors.yellow .. colors.bright .. "Do you want to backup the device original backend? (y/n)" .. colors.reset)
    local userInput = io.read()

    if userInput == "y" or userInput == "Y" then
        -- User chooses backup, perform backup
        local backupResult = backupWebFolder(tempBackupPath)
        
        -- Check backup result
        if backupResult and backupResult:find("error") then
		    print()
            print(colors.red .. "Backup failed, please check device connection and permissions." .. colors.reset)
        else
            moveBackupFolder(tempBackupPath, backupDir)
        end
    else
        -- User chooses not to backup
		print()
        print(colors.blue .. "Backup skipped" .. colors.reset)
    end

    print(colors.cyan .. colors.bright .. "═════════════════════════════════════════════" .. colors.reset)
end

local function up_web()
-- Delete original /etc_ro/web folder on device
local deleteCommand = "bin\\adb shell rm -rf /etc_ro/web"
os.execute(deleteCommand)

-- Upload entire folder to device
local uploadCommand = string.format("bin\\adb push \"%s\" /etc_ro/web", folderPath)
os.execute(uploadCommand)
print()
print(colors.green .. colors.bright .."Upload complete, device web replaced!"..colors.reset)
end

os.execute("bin\\adb shell mount -o remount,rw /")
check_file() -- Check if device allows read/write
file() -- Let user drag in folder
Backup_web() -- Perform backend backup
up_web() -- Delete device's original WEB and upload new files
os.execute("pause")
