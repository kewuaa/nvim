local utils = require("utils")

---@param path string: path of the file to write
---@param lines string[]: lines to write
local try_write = function(path, lines)
    if vim.loop.fs_stat(path) then
        vim.print(("%s exists, skipped"):format(path))
        return
    end
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
    local local_appdata_dir = os.getenv("LOCALAPPDATA"):gsub("\\", "/")

    local clink_config_path = home_dir .. "/.inputrc"
    try_write(
        clink_config_path,
        {
            ("$include %s"):format(config_dir .. "/clink_inputrc")
        }
    )
    local clink_profile_path = local_appdata_dir .. "/clink"
    if vim.fn.isdirectory(clink_profile_path) == 0 then
        vim.fn.mkdir(clink_profile_path, "pR")
        vim.print(("directory `%s` not exists, create it"):format(clink_profile_path))
    end
    try_write(
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
    try_write(
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
