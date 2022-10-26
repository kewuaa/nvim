local pyright = {}
local settings = require("core.settings")
local path = settings:getpy('pyright') .. '/../'
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
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
        },
        venvPath = settings:getpy('envs'),
    }
}

return pyright
