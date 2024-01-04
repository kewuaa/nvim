local M = {}
local current_env = nil

function M.parse_pyenv(root)
    local venv = nil
    local subpath = require('core.settings').is_Windows and '/Scripts/python.exe' or '/bin/python'
    local local_venv = string.format(
        '%s%s%s',
        root,
        string.match(root, '[\\/]$') and '' or '/',
        '.venv' .. subpath
    )
    if vim.loop.fs_stat(local_venv) then
        venv = local_venv
    else
        venv = nil
        local config_file = string.format(
            '%s%s%s', root,
            string.match(root, '[\\/]$') and '' or '/',
            'pyproject.toml'
        )
        if vim.loop.fs_stat(config_file) then
            local lines = vim.fn.readfile(config_file)
            local find = false
            for _, line in ipairs(lines) do
                if not find then
                    if string.match(line, '[tool.pyright]') then
                        find = true
                    end
                else
                    venv = string.match(line, 'venv%s*=%s*[\'\"](.*)[\'\"]')
                    if venv or string.match(line, '^[.*]') then
                        break
                    end
                end
            end
        end
        if venv then
            venv = require('core.settings'):getpy(venv)
        else
            local env = os.getenv("VIRTUAL_ENV")
            if env then
                venv = env:gsub("\\", "/") .. subpath
            else
                venv = require("core.settings"):getpy("default")
            end
        end
    end
    vim.cmd(string.format('let g:asynctasks_environ["pyenv"] = "%s"', venv))
    current_env = {
        name = vim.fn.fnamemodify(venv, ':h:h:t'),
        path = venv,
    }
    return venv
end

function M.get_current_env()
    return current_env
end

return M
