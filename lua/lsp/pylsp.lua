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
                exclude = {'.git', '**/__pycache__', '.venv'},
                ignore = {'E402'},
                linelength = 80,
            },
            jedi = {
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
    new_config.settings.pylsp.plugins.jedi.environment = venv
    new_config.settings.pylsp.plugins.jedi.extra_paths = {new_root}
    return new_config
end

return pylsp
