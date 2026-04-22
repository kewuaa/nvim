local mini_misc = require("mini.misc")

mini_misc.safely("filetype:qf", function()
    vim.cmd.packadd("nvim-bqf")

    require("bqf").setup({
        func_map = {
            drop = 'o',
            openc = 'O',
            split = '<C-s>',
            tabdrop = '<C-t>',
            -- set to empty string to disable
            tabc = '',
            ptogglemode = 'z,',
        },
    })
end)
