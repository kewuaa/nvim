local python = require('lsp.python')
local pyright = vim.deepcopy(python.base_settings)
local envs_path = require('core.settings').pyenv_path

pyright.cmd = {
    'pyright-langserver.cmd',
    '--stdio',
}
pyright.settings = {
    python = {
        analysis = {
            -- logLevel = 'track',
            autoImportCompletions = true,
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            stubPath = 'python-type-stubs',
            -- typeCheckingMode = 'off',
        },
        venvPath = envs_path,
    }
}

return pyright
