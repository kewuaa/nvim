local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {
    "runtime",
    "nvim",
    "autoload",
    "plugin",
})

M.vimls = {
    rootmarks = rootmarks,
    filetypes = {'vim'},
    cmd = {
        'vim-language-server',
        '--stdio',
    },
    init_options = {
        diagnostic = {
            enable = true
        },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = rootmarks,
            runtimepath = true
        },
        isNeovim = true,
        iskeyword = "@,48-57,_,192-255,-#",
        runtimepath = "",
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true
        },
        vimruntime = ""
    }
}

return M
