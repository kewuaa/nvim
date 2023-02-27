local M = {}
local current_env = nil

function M.parse_pyenv(root)
    local venv = 'default'
    local environ = vim.g.asynctasks_environ
    local config_file = string.format(
        '%s%s%s',
        root,
        string.match(root, '[\\/]$') and '' or '/',
        'pyproject.toml'
    )
    if vim.fn.filereadable(config_file) == 1 then
        local config = require('core.utils').read_toml(config_file)
        if config and config.tool then
            venv = config.tool.jedi and config.tool.jedi.venv or venv
        end
    end
    venv = require('core.settings'):getpy(venv)
    environ.pyenv = venv
    vim.g.asynctasks_environ = environ
    local env = vim.fn.fnamemodify(venv, ':h:h')
    current_env = {
        name = vim.fn.fnamemodify(env, ':t'),
        path = env,
    }
    return venv
end

function M.get_current_env()
    return current_env
end

local function set_env(env)
    local client = vim.lsp.get_active_clients()[1]
    if client then
        client.workspace_did_change_configuration({
            settings = {
                pylsp = {
                    plugins = {
                        jedi = {
                            environment = env.path
                        }
                    }
                }
            }
        })
        current_env = env
    end
end

local function get_envs()
    ---@diagnostic disable-next-line: param-type-mismatch
    local envs = vim.fn.globpath(require('core.settings').pyenv_path, '*', true, true)
    ---@diagnostic disable-next-line: param-type-mismatch
    for i, env in ipairs(envs) do
        envs[i] = {
            name = vim.fn.fnamemodify(env, ':t'),
            path = env,
        }
    end
    return envs
end

function M.pick_env()
    vim.ui.select(get_envs(), {
        prompt = 'Select python venv',
        format_item = function(item) return string.format('%s (%s)', item.name, item.path) end,
    }, function (choice)
        if not choice then
            return
        end
        set_env(choice)
    end)
end

function M.init()
    local map = vim.keymap.set
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'python',
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            map('n', '<leader>sv', M.pick_env, {buffer = bufnr})
        end
    })
end

return M
