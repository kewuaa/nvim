local M = {}
local python = require("utils.python")
local rootmarks = {".git", 'pyproject.toml'}

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
                stubPath = string.format("%s/../python-type-stubs/stubs", python.venv_root),
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
}

return M
