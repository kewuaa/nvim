local M = {}
local map = vim.keymap.set
local opt = {noremap = true, silent = true}

function M.setup()
    map('n', '<leader><leader>w', ':HopWord<CR>', opt)
    map('n', '<leader><leader>j', ':HopLine<CR>', opt)
    map('n', '<leader><leader>k', ':HopLine<CR>', opt)
    map('n', '<leader><leader>f', ':HopChar1<CR>', opt)
    map('n', '<leader><leader>c', ':HopChar2<CR>', opt)
    map('n', '<leader><leader>/', ':HopPattern<CR>', opt)
end

function M.config()
    require('hop').setup({
        keys = 'etovxqpdygfblzhckisuran'
    })
end

return M

