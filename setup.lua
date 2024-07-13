local utils = require("utils")

---@param path string: path of the file to write
---@param lines string[]: lines to write
local write = function(path, lines)
    local file
    file = io.open(path, "w")
    assert(file ~= nil)
    file:write(vim.fn.join(lines, "\n"))
    file:close()
    vim.print(("%s successfully writed"):format(path))
end

if utils.is_win then
    local config_dir = vim.fn.stdpath("config"):gsub("\\", "/")
    local home_dir = os.getenv("USERPROFILE"):gsub("\\", "/")
    local appdata_dir = os.getenv("APPDATA"):gsub("\\", "/")

    local clink_config_path = home_dir .. "/.inputrc"
    write(
        clink_config_path,
        {
            ("$include %s"):format(config_dir .. "/clink_inputrc")
        }
    )
    local clink_profile_path = appdata_dir .. "/clink"
    write(
        clink_profile_path .. "/clink_start.cmd",
        {
            "@echo off",
            "%PYVENV%/default/Scripts/activate",
        }
    )

    local alacritty_config_dir = appdata_dir .. "/alacritty"
    if vim.fn.isdirectory(alacritty_config_dir) == 0 then
        vim.fn.mkdir(alacritty_config_dir, "pR")
        vim.print(("directory `%s` not exists, create it"):format(alacritty_config_dir))
    end
    write(
        alacritty_config_dir .. "/alacritty.toml",
        {
            ('working_directory = "%s"'):format(home_dir),
            '[shell]',
            'program = "cmd"',
            'args = ["/k", "clink", "inject"]'
        }
    )
    -- build python extension
    local output = vim.fn.system("python setup.py build_ext -i")
    vim.print(output)
end
