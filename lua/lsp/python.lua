local M = {}
local deps = require("deps")
local utils = require("utils")
local root_markers = {"pyproject.toml", ".git"}

deps.add({
    source = "microsoft/python-type-stubs",
    lazy_opts = {}
})

M.basedpyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { "python" },
    root_markers = root_markers,
    settings = {
        python = {
            pythonPath = utils.get_py()
        },
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
                diagnosticSeverityOverrides = {
                    reportUnusedImport = false
                }
            },
        }
    }
}
M.ruff = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = root_markers,
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
