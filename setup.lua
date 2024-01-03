local path = vim.fn.stdpath("config"):gsub("\\", "/")
local settings = require("core.settings")
local alacritty_config = ([[
working_directory = "%s"

import = ["%s"]
]])
local win_special = [[

[shell]
program = "cmd"
args = ["/k clink inject"]
]]
local clink_config = ([[
$include %s
]]):format(path .. "/clink_inputrc")

local function write_alacritty_config()
    local dest_dir = nil
    if settings.is_Windows then
        alacritty_config = alacritty_config:format(
            vim.fn.getenv("USERPROFILE"):gsub("\\", "/"),
            path .. "/alacritty.toml"
        )
        alacritty_config = alacritty_config .. win_special
        dest_dir = vim.fn.getenv("APPDATA") .. "/alacritty"
    else
        local home_dir = vim.fn.getenv("HOME")
        alacritty_config = alacritty_config:format(
            home_dir,
            path .. "/alacritty.toml"
        )
        dest_dir = home_dir .. "/.config/alacritty"
    end
    assert(vim.fn.exists("*mkdir") == 1)
    if vim.fn.isdirectory(dest_dir) == 0 then
        vim.fn.mkdir(dest_dir, "pR")
        vim.print(("directory `%s` not exists, create it"):format(dest_dir))
    end
    local dest_path = dest_dir .. "/alacritty.toml"
    local file = io.open(dest_path, "w")
    assert(file ~= nil)
    file:write(alacritty_config)
    file:close()
    vim.print(("alacritty config successfully write to `%s`"):format(dest_path))
end

local function write_clink_config()
    local home_dir = vim.fn.getenv("HOME")
    assert(home_dir ~= nil)
    local dest_path = home_dir .. '/.inputrc'
    local file = io.open(dest_path, "w")
    assert(file ~= nil)
    file:write(clink_config)
    file:close()
    vim.print(("clink config successfully write to `%s`"):format(dest_path))
end

local function setup()
    if not settings.is_wsl then
        write_alacritty_config()
    end
    if settings.is_Windows then
        write_clink_config()
        local output = vim.fn.system("python setup.py build_ext -i")
        vim.print(output)
    end
end

setup()
