local M = {}
local settings = require('core.settings')
local rootmarks = settings.get_rootmarks('pyproject.toml')

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
M.ruff = {
    rootmarks = rootmarks,
    on_attach = function(client, _)
        client.server_capabilities.hoverProvider = false
    end,
}

return M
