local python = require('lsp.python')
local pylsp = vim.deepcopy(python.base_settings)

pylsp.cmd = {'pylsp.exe'}
pylsp.settings = {
    pylsp = {
        configurationSources = {},
        plugins = {
            pyflakes = {enabled = false},
            pycodestyle = {enabled = false},
            autopep8 = {enabled = false},
            yapf = {enabled = false},
            flake8 = {enabled = false},
            mccabe = {enabled = false},
            ruff = {
                enabled = true,
                exclude = {'.git', '**/__pycache__', 'build', 'dist'},
                ignore = {'E402'},
                lineLength = 80,
            },
            jedi = {
                -- environment = '',
                -- extra_paths = {},
                auto_import_modules = {'numpy', 'pandas'}
            },
            jedi_completion = {
                include_params = true,
                fuzzy = true,
                cache_for = {'numpy', 'matplotlib', 'pandas', 'torch'},
            },
            preload = {
                enabled = true,
                modules = {},
            }
        },
    },
}
pylsp.on_new_config = function(new_config, new_root)
    local venv = python.parse_pyenv(new_root)
    venv = vim.fn.fnamemodify(venv, ':h:h')
    new_config.settings.pylsp.plugins.jedi.environment = venv
    local client = vim.lsp.get_active_clients()[1]
    if client then
        local ok = client.notify('workspace/didChangeWorkspaceFolders', {
            added = {
                uri = vim.uri_from_fname(new_root),
                name = string.format('%s', new_root),
            }
        })
        if not ok then
            vim.notify('"workspace/didChangeWorkspaceFolders" notify failed')
        end
        -- client.workspace_did_change_configuration(new_config.settings)
    end
    return new_config
end

return pylsp
