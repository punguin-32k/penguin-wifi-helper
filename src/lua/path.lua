-- path.lua
-- A module providing common tool paths
-- 
-- Copyright (C) 2025-2026 Penguin Punguin
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
-- You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
--
-- Contact us: 3618679658@qq.com
-- Assisted by ChatGPT in development and writing

local path = {}

-- Unified management of the bin directory
local base_bin = "bin"

-- Tool paths
path.lua = base_bin .. "\\lua54.exe"
path.curl = base_bin .. "\\curl.exe"
path.adb  = base_bin .. "\\adb.exe"

-- To obtain absolute paths, you could do this:
-- local lfs = require("lfs")
-- LuaFileSystem (optional)
-- path.abs_lua = lfs.currentdir() .. "/" .. path.lua


-- Provide a function-based access method
function path.get(tool)
    return path[tool]
end

return path
