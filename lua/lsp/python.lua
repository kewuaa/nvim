local M = {}
local deps = require("deps")
local utils = require("utils")
local rootmarks = {"pyproject.toml", ".git"}

deps.add({
    source = "microsoft/python-type-stubs",
    lazy_opts = {}
})

M.pyright = {
    rootmarks = rootmarks,
    settings = {
        python = {
            disableOrganizeImports = true,
            analysis = {
                -- logLevel = 'track',
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                stubPath = deps.package_path .. "opt/python-type-stubs/stubs",
                typeCheckingMode = 'standard',
                diagnosticSeverityOverrides = {
                    reportUnusedImport = false
                }
            },
            pythonPath = utils.get_py()
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
