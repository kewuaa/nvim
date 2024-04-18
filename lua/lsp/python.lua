local M = {}
local settings = require('core.settings')
local rootmarks = settings.get_rootmarks('pyproject.toml')
local exclude = {
    '.git',
    '**/__pycache__',
    'build',
    'dist',
    '.venv',
    '.pytest_cache',
    '.mypy_cache'
}

M.basedpyright = {
    rootmarks = rootmarks,
    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            analysis = {
                -- logLevel = 'track',
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                stubPath = string.format("%s/../python-type-stubs/stubs", settings.pyvenv_path),
                typeCheckingMode = 'standard',
            },
        },
        python = {
            venvPath = settings.pyvenv_path,
            pythonPath = require("core.settings"):getpy("default")
        }
    }
}
vim.print(M.basedpyright)
M.ruff_lsp = {
    rootmarks = rootmarks,
    on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
    init_options = {
        args = {
            '--line-length=80',
            '--ignore=E402',
            '--exclude=' .. vim.fn.join(exclude, ',')
        }
    }
}
-- M.pylsp = {
--     rootmarks = rootmarks,
--     filetypes = {"python"},
--     cmd = {'pylsp'},
--     settings = {
--         pylsp = {
--             configurationSources = {},
--             plugins = {
--                 pyflakes = {enabled = false},
--                 pycodestyle = {enabled = false},
--                 autopep8 = {enabled = false},
--                 yapf = {enabled = false},
--                 flake8 = {enabled = false},
--                 mccabe = {enabled = false},
--                 ruff = {
--                     enabled = false,
--                     exclude = vim.list_extend({}, exclude),
--                     ignore = {'E402'},
--                     lineLength = 80,
--                 },
--                 pylsp_mypy = {
--                     enabled = false,
--                     exclude = vim.list_extend({}, exclude),
--                     overrides = {}
--                 },
--                 jedi = {
--                     -- environment = '',
--                     -- extra_paths = {},
--                     auto_import_modules = {'numpy', 'pandas'}
--                 },
--                 jedi_completion = {
--                     include_params = true,
--                     resolve_at_most = 15,
--                     fuzzy = true,
--                     cache_for = {
--                         'numpy',
--                         'pandas',
--                         'sklearn',
--                         'seaborn',
--                         'matplotlib',
--                     },
--                 },
--                 preload = {
--                     enabled = false,
--                     modules = {},
--                 }
--             },
--         },
--     },
--     on_new_config = function(new_config, new_root)
--         local pyutils = require("core.utils.python")
--         pyutils.parse_pyenv(new_root)
--         local venv = pyutils.get_current_env().path
--         vim.list_extend(new_config.settings.pylsp.plugins.pylsp_mypy.overrides, {"--python-executable", venv, true})
--         new_config.settings.pylsp.plugins.jedi.environment = vim.fn.fnamemodify(venv, ':h:h')
--     end
-- }

return M
