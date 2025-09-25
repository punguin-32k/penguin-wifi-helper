-- start_helper.lua
-- Provides initialization and update detection services for the Penguin WIFI Helper main program
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
os.execute("title Penguin WIFI Helper Current Version: 5.2 , Checking for Updates")
os.execute("mode con: cols=60 lines=15")

-- Import external libraries
local path = require("lua\\path") -- Utility path variable library
local colors = require("lua\\colors") -- ANSI color code library
local delay = require("lua\\sleep") -- Countdown operation

-- Get the directory of the current script
local script_path = debug.getinfo(1, "S").source:sub(2)
local script_dir = script_path:match("(.*/)") or script_path:match("(.+\\)") or "./"

-- Define the flag file path
local flag_file = script_dir .. "dyc"

-- Check if this is the first run
local file = io.open(flag_file, "r")
if file then
    file:close()
    
    -- Open the configuration file with Notepad
    print("First run detected")
    print("Opening configuration file. Please edit manually...")
    delay.sleep(4)
    os.execute('start notepad.exe helper.ini')
    -- Remove the flag file to avoid repeated prompts
    os.remove(flag_file)
    delay.sleep(2)
end

local function print_tips()
   print(colors.green .."Checking for the latest cloud version of the helper. Please wait a few seconds...\n\n" .. colors.reset)
end

local function print_start()
   print()
   print()
   print(colors.green .."Processing startup parameters and launching the helper. Please wait a few seconds......\n" .. colors.reset)
end

-- Wait for user to press any key
local function wait_for_user_input()
    print()
    print(colors.yellow .. "New version detected. Press any key to continue..." .. colors.reset)
    os.execute("pause >nul")  -- Wait for any key press on Windows
    print()
    delay.sleep(1)
    print()
    print(colors.red .. "Each update includes exciting new features—upgrading is highly recommended!" .. colors.reset)
    delay.sleep(5)
end

-- New: Detect Build version channel
local function get_version_path()
    local default_path = "helper"  -- Default path
    local file = io.open("helper.ini", "r")
    if not file then
        return default_path  -- Config file not found; use default
    end
    for line in file:lines() do
        -- Detect uncommented [Build version channel]
        if line:match("^%s*%[Build version channel%]%s*$") then
            file:close()
            return "helper-build"  -- Use Build channel path
        -- Detect commented #[Build version channel]
        elseif line:match("^%s*#%s*%[Build version channel%]%s*$") then
            file:close()
            return default_path  -- Use default path
        end
    end
    file:close()
    return default_path  -- No relevant config found; use default
end

-- Fetch cloud version information
local function check_version()
    -- Read refresh cycle (in days) from helper.ini
    local function read_refresh_cycle(file_path)
        local file = io.open(file_path, "r")
        if not file then
            print("helper.ini not found. Proceeding with immediate version check.")
            return nil
        end
        for line in file:lines() do
            local cycle = line:match("refresh cycle%s*=%s*(%d+)")
            if cycle then
                file:close()
                return tonumber(cycle)
            end
        end
        file:close()
        print("No 'refresh cycle' parameter found in helper.ini. Proceeding with immediate version check.")
        return nil
    end

    -- Read last check time from version.ini (format: review time: YYYY-MM-DD)
    local function read_last_check_time(file_path)
        local file = io.open(file_path, "r")
        if not file then
            print("version.ini not found. Proceeding with immediate version check.\n")
            return nil
        end
        for line in file:lines() do
            local y, m, d = line:match("review time:%s*(%d+)%-(%d+)%-(%d+)")
            if y then
                file:close()
                return os.time{year=tonumber(y), month=tonumber(m), day=tonumber(d), hour=0, min=0, sec=0}
            end
        end
        file:close()
        print("No 'review time' record found in version.ini. Proceeding with immediate version check.")
        return nil
    end

    -- Determine whether to perform an update check
    local function should_check_update()
        local cycle = read_refresh_cycle("helper.ini") -- in days
        local last_time = read_last_check_time("version.ini")
        if not cycle or not last_time then
            return true -- Missing file/parameter/time → force check
        end
        local now = os.time()
        local diff_days = os.difftime(now, last_time) / (60 * 60 * 24) -- Convert seconds to days
        if diff_days >= cycle then
            return true
        else
            if diff_days < 1 then
                print("Last check was today. Skipping version check.")
            else
                print(string.format("Last check was %.1f days ago. Update cycle is %d days.", diff_days, cycle))
                print("Skipping version check.")
            end
            -- Calculate next check date
            local next_time = last_time + cycle * 24 * 60 * 60
            local next_date = os.date("%Y-%m-%d", next_time)
            print("Next check scheduled for: " .. next_date)
            return false
        end
    end

    -- If update check is not needed, return early
    if not should_check_update() then
        delay.sleep(2)
        return
    end

    -- Use get_version_path() to determine actual fetch path
    local version_path = get_version_path()
    local version_urls = {
        "https://punguin.pages.dev/" .. version_path,      -- Append path
        --"http://47.239.84.169/" .. version_path,         -- Append path
        "http://127.0.0.1:0721/" .. version_path           -- Append path
    } -- Server list
    local local_version = "5.2" -- Replace with local version number
    local temp_version_file = "version.ini" -- Temporary version file
    local cloud_version = nil  -- Note: IP should be encrypted separately at compile time

    -- Extract cloud version from downloaded file
    local function get_version_from_html(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return nil
        end
        for line in file:lines() do
            local version = line:match("%d+%.%d+[%w%-]*") -- Version format: X.X (numeric)
            if version then
                file:close()
                return version
            end
        end
        file:close()
        return nil
    end

    -- Validate downloaded file
    local function is_file_valid(file_path)
        local file = io.open(file_path, "r")
        if not file then
            return false
        end
        local content = file:read("*a")
        file:close()
        return content and #content > 0 and not content:find("404") -- Check for 404 error
    end

    -- Attempt to download version file from each server
    for _, url in ipairs(version_urls) do
        -- Use curl to download the version file
        os.execute(string.format('"%s" -l -o %s %s >nul 2>nul', path.curl, temp_version_file, url))
        
        if is_file_valid(temp_version_file) then
            cloud_version = get_version_from_html(temp_version_file)
            if cloud_version then
                break -- Successfully retrieved cloud version; exit loop
            end
        end
    end

    -- Write current check time into version file
    if cloud_version then
        local function write_check_time(file_path)
            local time_str = os.date("\n\nreview time: %Y-%m-%d") -- Format: review time: YYYY-MM-DD
            local file = io.open(file_path, "a") -- Append mode
            if file then
                file:write(time_str)
                file:close()
            end
        end
        write_check_time(temp_version_file)

        print(colors.bright .. "Latest Version: " .. cloud_version .. "  Current Version: " .. local_version .. colors.reset .. "\n")
        print(colors.blue .. colors.bright .. "If a new version is available, enter 'new' in the helper to download it.\n" .. colors.reset)
        print()
        print("Joke: Some people are still using Penguin Helper v1.2")
        print()

        -- Prompt user only if cloud version is newer
        if cloud_version > local_version then
            wait_for_user_input()
        end
    else
        print(colors.bright .. "Failed to retrieve cloud version\n" .. colors.reset)
    end
end

print_tips()
check_version()
print_start()
delay.sleep(2)
os.execute("bin\\lua54 lua\\helper.lua")
