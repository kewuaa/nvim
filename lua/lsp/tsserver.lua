local tsserver = {}
local settings = require("core.settings")
local path = vim.fn.expand('$AppData') .. '/npm/'
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'package.json'
rootmarks[#rootmarks+1] = 'tsconfig.json'
rootmarks[#rootmarks+1] = 'jsconfig.json'


tsserver.rootmarks = rootmarks
tsserver.filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
}
tsserver.cmd = {
    path .. 'typescript-language-server.cmd',
    '--stdio',
}
tsserver.init_options = {
    hostInfo = "neovim"
}


return tsserver
