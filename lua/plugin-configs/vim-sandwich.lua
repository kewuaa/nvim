local M = {}
local map = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true}

function M.setup()
    vim.g.sandwich_no_default_key_mappings = 1
end

function M.config()
    map('n', '<c-s>a', '<Plug>(sandwich-add)', opt)
    map('x', '<c-s>a', '<Plug>(sandwich-add)', opt)
    map('o', '<c-s>a', '<Plug>(sandwich-add)', opt)
    map('n', '<c-s>d', '<Plug>(sandwich-delete)', opt)
    map('x', '<c-s>d', '<Plug>(sandwich-delete)', opt)
    map('n', '<c-s>db', '<Plug>(sandwich-delete-auto)', opt)
    map('n', '<c-s>r', '<Plug>(sandwich-replace)', opt)
    map('x', '<c-s>r', '<Plug>(sandwich-replace)', opt)
    map('n', '<c-s>rb', '<Plug>(sandwich-replace-auto)', opt)
end

return M

