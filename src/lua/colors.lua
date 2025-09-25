-- colors.lua
-- ANSI color code library, supporting multiple colors and styles
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

-- Load color configuration from helper.ini
-- Supports #[Enable_Colors] to disable color output

local function load_color_config()
    local config = { enable = false, reverse = false }
    local f = io.open("helper.ini", "r")
    if not f then return config end

    local in_section = false
    local section_enabled = false

    for line in f:lines() do
        line = line:match("^%s*(.-)%s*$")  -- Trim leading/trailing whitespace

        if line:lower() == "[enable_colors]" then
            in_section = true
            section_enabled = true
        elseif line:lower() == "#[enable_colors]" then
            in_section = false
            section_enabled = false
        elseif line:match("^%[.-%]$") then
            in_section = false
        elseif in_section and section_enabled then
            local key, val = line:match("^(.-)=(.-)$")
            if key and val then
                key = key:lower():gsub("%s+", "")
                val = val:match("^%s*(.-)%s*$")
                if key == "reverse-color" then
                    config.enable = true
                    config.reverse = (val == "1")
                end
            end
        end
    end

    f:close()
    return config
end

local config = load_color_config()

local function color_code(code, reverse_code)
    if not config.enable then return "" end
    if config.reverse and reverse_code then
        return reverse_code
    end
    return code
end

local colors = {
    reset = "\27[0m",

    black = color_code("\27[30m", "\27[97m"),
    red = color_code("\27[31m", "\27[91m"),
    green = color_code("\27[32m", "\27[92m"),
    yellow = color_code("\27[33m", "\27[93m"),
    blue = color_code("\27[34m", "\27[94m"),
    magenta = color_code("\27[35m", "\27[95m"),
    cyan = color_code("\27[36m", "\27[96m"),
    white = color_code("\27[37m", "\27[30m"),

    bright = color_code("\27[1m"),
    bright_black = color_code("\27[90m", "\27[37m"),
    bright_red = color_code("\27[91m", "\27[31m"),
    bright_green = color_code("\27[92m", "\27[32m"),
    bright_yellow = color_code("\27[93m", "\27[33m"),
    bright_blue = color_code("\27[94m", "\27[34m"),
    bright_magenta = color_code("\27[95m", "\27[35m"),
    bright_cyan = color_code("\27[96m", "\27[36m"),
    bright_white = color_code("\27[97m", "\27[30m"),

    bold = color_code("\27[1m"),
    bold_black = color_code("\27[1;30m", "\27[1;97m"),
    bold_red = color_code("\27[1;31m", "\27[1;91m"),
    bold_green = color_code("\27[1;32m", "\27[1;92m"),
    bold_yellow = color_code("\27[1;33m", "\27[1;93m"),
    bold_blue = color_code("\27[1;34m", "\27[1;94m"),
    bold_magenta = color_code("\27[1;35m", "\27[1;95m"),
    bold_cyan = color_code("\27[1;36m", "\27[1;96m"),
    bold_white = color_code("\27[1;37m", "\27[1;30m"),

    underline_black = color_code("\27[4;30m", "\27[4;97m"),
    underline_red = color_code("\27[4;31m", "\27[4;91m"),
    underline_green = color_code("\27[4;32m", "\27[4;92m"),
    underline_yellow = color_code("\27[4;33m", "\27[4;93m"),
    underline_blue = color_code("\27[4;34m", "\27[4;94m"),
    underline_magenta = color_code("\27[4;35m", "\27[4;95m"),
    underline_cyan = color_code("\27[4;36m", "\27[4;96m"),
    underline_white = color_code("\27[4;37m", "\27[4;30m"),

    bg_black = color_code("\27[40m", "\27[107m"),
    bg_red = color_code("\27[41m", "\27[101m"),
    bg_green = color_code("\27[42m", "\27[102m"),
    bg_yellow = color_code("\27[43m", "\27[103m"),
    bg_blue = color_code("\27[44m", "\27[104m"),
    bg_magenta = color_code("\27[45m", "\27[105m"),
    bg_cyan = color_code("\27[46m", "\27[106m"),
    bg_white = color_code("\27[47m", "\27[40m"),

    bg_bright_black = color_code("\27[100m", "\27[47m"),
    bg_bright_red = color_code("\27[101m", "\27[41m"),
    bg_bright_green = color_code("\27[102m", "\27[42m"),
    bg_bright_yellow = color_code("\27[103m", "\27[43m"),
    bg_bright_blue = color_code("\27[104m", "\27[44m"),
    bg_bright_magenta = color_code("\27[105m", "\27[45m"),
    bg_bright_cyan = color_code("\27[106m", "\27[46m"),
    bg_bright_white = color_code("\27[107m", "\27[40m"),
}

return colors
