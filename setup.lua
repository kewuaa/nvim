local path = vim.fn.stdpath("config")
local settings = require("core.settings")
local alacritty_config = string.format([[
import:
 - %s
]], path .. "/alacritty.yml")
local clink_config = string.format([[
$include %s
]], path .. "/clink_inputrc")

local function write_alacritty_config()
    local dest_path = nil
    if settings.is_Windows then
        dest_path = vim.fn.getenv("APPDATA") .. "/alacritty"
    else
        dest_path = vim.fn.getenv("HOME") .. "/.config/alacritty"
    end
    assert(vim.fn.exists("*mkdir") == 1)
    if not vim.fn.isdirectory(dest_path) then
        vim.fn.mkdir(dest_path, "pR")
    end
    local file = io.open(dest_path .. "/alacritty.yml", "w")
    assert(file ~= nil)
    io.output(file)
    io.write(alacritty_config)
    io.close(file)
end

local function write_clink_config()
    local dest_path = vim.fn.getenv("HOME")
    assert(dest_path ~= nil)
    local file = io.open(dest_path .. "/.inputrc", "w")
    assert(file ~= nil)
    io.output(file)
    io.write(clink_config)
    io.close(file)
end

local function setup()
    if not settings.is_wsl then
        write_alacritty_config()
    end
    if settings.is_Windows then
        write_clink_config()
    end
    local output = vim.fn.system("python setup.py build_ext -i")
    vim.print(output)
end

setup()
