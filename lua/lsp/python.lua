local M = {}
local settings = require('core.settings')
local utils = require('core.utils')
---@diagnostic disable-next-line: missing-parameter
local rootmarks = vim.list_extend(settings.get_rootmarks(), {'pyproject.toml'})
local find_root = utils.find_root_by(rootmarks)
local _parse_pyenv = require('core.utils.python').parse_pyenv
local filetypes = {'python'}

local base_settings = {
    rootmarks = rootmarks,
    filetypes = filetypes
}
local parse_pyenv = function(root)
    if not root then
        local startpath = vim.fn.expand('%:p:h')
        root = find_root(startpath)
    end
    return _parse_pyenv(root)
end
-- M.pyright = vim.tbl_extend('error', base_settings, {
--     cmd = {
--         'pyright-langserver.cmd',
--         '--stdio',
--     },
--     settings = {
--         python = {
--             analysis = {
--                 -- logLevel = 'track',
--                 autoImportCompletions = true,
--                 autoSearchPaths = true,
--                 diagnosticMode = "workspace",
--                 useLibraryCodeForTypes = true,
--                 stubPath = 'python-type-stubs',
--                 -- typeCheckingMode = 'off',
--             },
--             venvPath = settings.pyenv_path,
--         }
--     }
-- })
-- M.jedi_language_server = vim.tbl_extend('error', base_settings, {
--     cmd = {'jedi-language-server.exe'},
--     init_options = {
--         diagnostics = {
--             enable = false,
--         },
--         jediSettings = {
--             autoImportModules = {
--                 'numpy',
--                 'pandas',
--                 -- 'torch',
--             }
--         },
--         workspace = {
--             -- extraPaths = {},
--             environmentPath = parse_pyenv(),
--             symbols = {
--                 ignoreFolders = {
--                     '.git',
--                     '__pycache__',
--                     '.venv',
--                 }
--             }
--         }
--     }
-- })
-- M.ruff_lsp = vim.tbl_extend('error', base_settings, {
--     cmd = {'ruff-lsp.exe'},
--     on_attach = function() end,
--     init_options = {
--         args = {
--             '--line-length=80',
--             '--ignore=E402',
--             '--exclude=.git,**/__pycache__,build,dist',
--         }
--     }
-- })
M.pylsp = vim.tbl_extend('error', base_settings, {
    cmd = {'pylsp.exe'},
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
                    resolve_at_most = 15,
                    fuzzy = true,
                    cache_for = {'numpy', 'matplotlib', 'pandas', 'torch'},
                },
                preload = {
                    enabled = true,
                    modules = {},
                }
            },
        },
    },
    on_new_config = function(new_config, new_root)
        local venv = parse_pyenv(new_root)
        venv = vim.fn.fnamemodify(venv, ':h:h')
        new_config.settings.pylsp.plugins.jedi.environment = venv
        local src = new_root .. '/src'
        if vim.loop.fs_stat(src) then
            new_config.settings.pylsp.plugins.jedi.extra_paths = {src}
        else
            new_config.settings.pylsp.plugins.jedi.extra_paths = {}
        end
        -- local client = vim.lsp.get_active_clients()[1]
        -- if client then
        --     local ok = client.notify('workspace/didChangeWorkspaceFolders', {
        --         added = {
        --             uri = vim.uri_from_fname(new_root),
        --             name = string.format('%s', new_root),
        --         }
        --     })
        --     if not ok then
        --         vim.notify('"workspace/didChangeWorkspaceFolders" notify failed')
        --     end
        --     -- client.workspace_did_change_configuration(new_config.settings)
        -- end
        return new_config
    end
})

return M
