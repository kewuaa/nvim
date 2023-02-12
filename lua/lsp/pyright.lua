local pyright = {}
local settings = require("core.settings")
local envs_path = settings:getpy('envs')
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'pyproject.toml'


pyright.rootmarks = rootmarks
pyright.filetypes = {'python'}
pyright.cmd = {
    settings.python_path .. 'npm/node_modules/.bin/pyright-langserver.cmd',
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
            stubPath = settings.python_path .. 'python-type-stubs',
            -- typeCheckingMode = 'off',
        },
        venvPath = envs_path,
    }
}

return pyright
