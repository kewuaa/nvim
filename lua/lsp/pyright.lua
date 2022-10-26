local pyright = {}
local settings = require("core.settings")
local path = settings:getpy('pyright') .. '/../'
local envs_path = settings:getpy('envs')
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'pyrightconfig.json'
rootmarks[#rootmarks+1] = 'pyproject.toml'


pyright.rootmarks = rootmarks
pyright.filetypes = {'python'}
pyright.cmd = {
    path .. 'pyright-langserver',
    '--stdio',
}
pyright.settings = {
    python = {
        analysis = {
            -- logLevel = 'track',
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            stubPath = envs_path .. '/../src/python-type-stubs',
            -- typeCheckingMode = 'off',
        },
        venvPath = envs_path,
    }
}

return pyright
