local M = {}
local python = require("utils.python")
local deps = require("deps")
local rootmarks = {".git", 'pyproject.toml'}

deps.add({
    source = "microsoft/python-type-stubs",
    lazy_opts = {}
})

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
                stubPath = deps.package_path .. "opt/python-type-stubs/stubs",
                typeCheckingMode = 'standard',
            },
        },
        python = {
            venvPath = python.venv_root,
            -- pythonPath = python.get_venv("default")
        }
    }
}
M.ruff = {
    rootmarks = rootmarks,
    on_attach = function(client, _)
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            lineLength = 88
        }
    },
}

return M
