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
    local dest_dir = nil
    if settings.is_Windows then
        dest_dir = vim.fn.getenv("APPDATA") .. "/alacritty"
    else
        dest_dir = vim.fn.getenv("HOME") .. "/.config/alacritty"
    end
    assert(vim.fn.exists("*mkdir") == 1)
    if not vim.fn.isdirectory(dest_dir) then
        vim.fn.mkdir(dest_dir, "pR")
        vim.print(("directory `%s` not exists, create it"):format(dest_dir))
    end
    local dest_path = dest_dir .. "/alacritty.yml"
    local file = io.open(dest_path)
    assert(file ~= nil)
    io.output(file)
    io.write(alacritty_config)
    io.close(file)
    vim.print(("alacritty config successfully write to `%s`"):format(dest_path))
end

local function write_clink_config()
    local home_dir = vim.fn.getenv("HOME")
    assert(home_dir ~= nil)
    local dest_path = home_dir .. '/.inputrc'
    local file = io.open(dest_path)
    assert(file ~= nil)
    io.output(file)
    io.write(clink_config)
    io.close(file)
    vim.print(("clink config successfully write to `%s`"):format(dest_path))
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
