-- sleep.lua
-- A simple blocking countdown function (supports disabling via ini configuration)
-- 
-- Copyright (C) 2025-2026 Penguin Punguin
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
-- You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
--
-- Contact us: 3618679658@qq.com
-- Assisted by ChatGPT in development and writing

local delay = {}

-- Attempt to read the 'off-all_sleep' parameter from helper.ini
local skip_delay = false
local ini_file = io.open("helper.ini", "r")
if ini_file then
    for line in ini_file:lines() do
        local key, value = line:match("^%s*(.-)%s*=%s*(.-)%s*$")
        if key == "off-all_sleep" and value == "1" then
            skip_delay = true
            break
        end
    end
    ini_file:close()
end

--- Blocks the current program for the specified number of seconds (returns immediately if disabled in helper.ini)
-- @param seconds number Delay duration in seconds
function delay.sleep(seconds)
    if skip_delay then
        return
    end

    local start = os.clock()
    while os.clock() - start < seconds do end
end

return delay
