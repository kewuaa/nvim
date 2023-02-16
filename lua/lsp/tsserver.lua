local tsserver = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, { 'package,json', 'tsconfig.json', 'jsconfig.json' })


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
    settings.javascript_path .. 'npm/node_modules/.bin/typescript-language-server.cmd',
    '--stdio',
}
tsserver.init_options = {
    hostInfo = "neovim"
}


return tsserver
