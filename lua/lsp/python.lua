local M = {}
local utils = require("utils")
local rootmarks = {".git", 'pyproject.toml'}

M.jedi_language_server = {
    rootmarks = rootmarks,
    init_options = {
        diagnostics = {
            enable = false,
        },
        completion = {
            resolveEagerly = false
        },
        jediSettings = {
            autoImportModules = {"numpy", "pandas"},
            caseInsensitiveCompletion = true
        },
        workspace = {
            extraPaths = {},
            environmentPath = utils.get_py(),
            symbols = {
                ignoreFolders = {
                    ".venv",
                    "__pycache__",
                    "build",
                    "dist"
                },
                maxSymbols = 20
            }
        },
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
