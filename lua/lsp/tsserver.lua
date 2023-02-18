local tsserver = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {
    'package,json',
    'tsconfig.json',
    'jsconfig.json',
})


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
    'typescript-language-server.cmd',
    '--stdio',
}
tsserver.init_options = {
    hostInfo = "neovim"
}


return tsserver
