local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {
    'package,json',
    'tsconfig.json',
    'jsconfig.json',
})


M.tsserver = {
    rootmarks = rootmarks,
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
    },
    cmd = {
        'typescript-language-server.cmd',
        '--stdio',
    },
    init_options = {
        hostInfo = "neovim"
    }
}

return M
