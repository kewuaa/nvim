local M = {}
local settings = require('core.settings')
local rootmarks = vim.list_extend(settings.get_rootmarks(), {'pyproject.toml'})

M.pyright = {
    rootmarks = rootmarks,
    filetypes = {"python"},
    cmd = {
        'pyright-langserver',
        '--stdio',
    },
    settings = {
        python = {
            disableOrganizeImports = true,
            analysis = {
                -- logLevel = 'track',
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                stubPath = string.format("%s/../python-type-stubs/stubs", settings.pyvenv_path),
                -- typeCheckingMode = 'off',
            },
            venvPath = settings.pyvenv_path,
            venv = "default",
        }
    }
}
-- M.jedi_language_server = {
--     rootmarks = rootmarks,
--     filetypes = {"python", "cython"},
--     cmd = {'jedi-language-server'},
--     init_options = {
--         diagnostics = {
--             enable = false,
--         },
--         jediSettings = {
--             autoImportModules = {
--                 'numpy',
--                 'pandas',
--                 'torch',
--             }
--         },
--         workspace = {
--             -- extraPaths = {},
--             environmentPath = require("core.utils.python").get_current_env().path,
--             symbols = {
--                 ignoreFolders = {
--                     '.git',
--                     '__pycache__',
--                     '.venv',
--                     'build',
--                     'dist',
--                     '.venv',
--                     '.pytest_cache',
--                     '.mypy_cache'
--                 },
--                 maxSymbols = 10,
--             }
--         }
--     }
-- }
M.ruff_lsp = {
    rootmarks = rootmarks,
    filetypes = {'python'},
    cmd = {'ruff-lsp'},
    on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
    init_options = {
        args = {
            '--line-length=80',
            '--ignore=E402',
            '--exclude=.git,**/__pycache__,build,dist,.venv,.pytest_cache,.mypy_cache',
        }
    }
}
M.pylsp = {
    rootmarks = rootmarks,
    filetypes = {"python", "cython"},
    cmd = {'pylsp'},
    settings = {
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
                    enabled = false,
                    exclude = {
                        '.git',
                        '**/__pycache__',
                        'build',
                        'dist',
                        '.venv',
                        '.pytest_cache',
                        '.mypy_cache'
                    },
                    ignore = {'E402'},
                    lineLength = 80,
                },
                pylsp_mypy = {
                    enabled = true,
                },
                jedi = {
                    -- environment = '',
                    -- extra_paths = {},
                    auto_import_modules = {'numpy', 'pandas'}
                },
                jedi_completion = {
                    include_params = false,
                    resolve_at_most = 15,
                    fuzzy = true,
                    cache_for = {
                        'numpy',
                        'matplotlib',
                        'pandas',
                        'torch',
                    },
                },
                preload = {
                    enabled = true,
                    modules = {},
                }
            },
        },
    },
    on_new_config = function(new_config, new_root)
        local venv = require("core.utils.python").get_current_env().path
        venv = vim.fn.fnamemodify(venv, ':h:h')
        new_config.settings.pylsp.plugins.jedi.environment = venv
        -- local src = new_root .. '/src'
        -- if vim.loop.fs_stat(src) then
        --     new_config.settings.pylsp.plugins.jedi.extra_paths = {src}
        -- else
        --     new_config.settings.pylsp.plugins.jedi.extra_paths = {}
        -- end
        return new_config
    end
}

return M
