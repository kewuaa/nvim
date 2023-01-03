local vimls = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks


vimls.rootmarks = rootmarks
vimls.filetypes = {'vim'}
vimls.cmd = {
    settings.vim_path .. 'npm/node_modules/.bin/vim-language-server.cmd',
    '--stdio',
}
vimls.init_options = {
    diagnostic = {
        enable = true
    },
    indexes = {
        count = 3,
        gap = 100,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
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


return vimls
