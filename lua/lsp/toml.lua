local M = {}
local settings = require('core.settings')
local rootmarks = settings.get_rootmarks()
rootmarks[#rootmarks+1] = '*.toml'


M.taplo = {
    rootmarks = rootmarks,
    filetypes = {'toml'},
    cmd = {'taplo', 'lsp', 'stdio'}
}

return M
