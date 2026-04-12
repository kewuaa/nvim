local mini_splitjoin = require("mini.splitjoin")

mini_splitjoin.setup({
    mappings = {
        toggle = vim.g.mapleader..'j',
        split = '',
        join = '',
    },
    detect = {
        separator = '[,;]'
    }
})
