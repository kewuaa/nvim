local M = {}
local current_env = nil
local find_root = require("core.utils").find_root_by({".git", "pyproject.toml"})

function M.parse_pyenv(root)
    local venv = nil
    local environ = vim.g.asynctasks_environ or {}
    local local_venv = string.format(
        '%s%s%s',
        root,
        string.match(root, '[\\/]$') and '' or '/',
        '.venv/Scripts/python.exe'
    )
    if vim.loop.fs_stat(local_venv) then
        venv = local_venv
    else
        venv = 'default'
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
        venv = require('core.settings'):getpy(venv)
    end
    environ.pyenv = venv
    vim.g.asynctasks_environ = environ
    current_env = {
        name = vim.fn.fnamemodify(venv, ':h:h:t'),
        path = venv,
    }
    return venv
end

function M.get_current_env()
    return current_env
end

function M.init()
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'cython,python',
        once = true,
        callback = function()
            local start_path = vim.api.nvim_buf_get_name(0)
            local root = find_root(start_path)
            M.parse_pyenv(root)
        end
    })
end

return M
