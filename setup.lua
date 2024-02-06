local settings = require("core.settings")
local config_dir = vim.fn.stdpath("config")
local home_dir = nil
local clink_config_path = nil
local alacritty_config_dir = nil
local kitty_config_dir = nil
if settings.is_Windows then
    home_dir = os.getenv("USERPROFILE"):gsub("\\", "/")
    alacritty_config_dir = os.getenv("APPDATA"):gsub("\\", "/") .. "/alacritty"
    clink_config_path = home_dir .. "/.inputrc"
    local file = nil
    -- write clink config
    file = io.open(clink_config_path, "w")
    assert(file ~= nil)
    file:write(("$include %s\n"):format(config_dir .. "/clink_inputrc"))
    file:close()
    vim.print(("clink config successfully write to `%s`"):format(clink_config_path))
    -- write alacritty config
    if vim.fn.isdirectory(alacritty_config_dir) == 0 then
        vim.fn.mkdir(alacritty_config_dir, "pR")
        vim.print(("directory `%s` not exists, create it"):format(alacritty_config_dir))
    end
    file = io.open(alacritty_config_dir .. "/alacritty.toml", "w")
    assert(file ~= nil)
    file:write(('working_directory = "%s"\n\n'):format(home_dir))
    file:write(('import = ["%s"]\n\n'):format(config_dir .. "/alacritty.toml"))
    file:write("[shell]\n")
    file:write('program = "cmd"\n')
    file:write('args = ["/k", "clink", "inject"]\n')
    file:close()
    vim.print(("alacritty config successfully write to `%s`"):format(alacritty_config_dir))
    -- build python extension
    local output = vim.fn.system("python setup.py build_ext -i")
    vim.print(output)
else
    home_dir = os.getenv("HOME")
    alacritty_config_dir = home_dir .. "/.config/alacritty"
    kitty_config_dir = home_dir .. "/.config/kitty"
    local file = nil
    vim.print("alacritty or kitty(default: alacritty):")
    local terminal = io.read()
    if terminal == "" then
        terminal = "alacritty"
    end
    if terminal == "alacritty" then
        -- write alacritty config
        if vim.fn.isdirectory(alacritty_config_dir) == 0 then
            vim.fn.mkdir(alacritty_config_dir, "pR")
            vim.print(("directory `%s` not exists, create it"):format(alacritty_config_dir))
        end
        file = io.open(alacritty_config_dir .. "/alacritty.toml", "w")
        assert(file ~= nil)
        file:write(('working_directory = "%s"\n\n'):format(home_dir))
        file:write(('import = ["%s"]\n'):format(config_dir .. "/alacritty.toml"))
        file:close()
        vim.print(("alacritty config successfully write to `%s`"):format(alacritty_config_dir))
    elseif terminal == "kitty" then
        -- write kitty config
        if vim.fn.isdirectory(kitty_config_dir) == 0 then
            vim.fn.mkdir(kitty_config_dir, "pR")
            vim.print(("directory `%s` not exists, create it"):format(kitty_config_dir))
        end
        file = io.open(kitty_config_dir .. "/kitty.conf", "w")
        assert(file ~= nil)
        file:write(('include %s\n'):format(config_dir .. "/kitty.conf"))
        file:close()
        vim.print(("kitty config successfully write to `%s`"):format(kitty_config_dir))
    else
        vim.print("invalid input")
    end
end
