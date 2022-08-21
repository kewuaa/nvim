local M = {}
local settings = require('settings')

function M.setup()
    vim.g.asyncrun_mode = 4
    vim.g.asyncrun_save = 2
    vim.g.asyncrun_bell = 1
    vim.g.asyncrun_rootmarks = settings.rootmarks
    vim.g.asynctasks_term_focus = 0
    vim.g.asynctasks_term_pos = 'external'
    vim.g.asynctasks_template = 0

    vim.api.nvim_set_keymap('n', '<F5>', ':AsyncTask file-run<CR>', {noremap = true, silent = true})
end

return M

