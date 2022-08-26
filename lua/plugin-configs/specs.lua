local M = {}
local specs = require("specs")
local map = vim.keymap.set
local opt = {noremap = true, silent = true}

function M.config()
    specs.setup({
        show_jumps = true,
        min_jump = 10,
        popup = {
            delay_ms = 0, -- delay before popup displays
            inc_ms = 10, -- time increments used for fade/resize effects
            blend = 20, -- starting blend, between 0-100 (fully transparent), see :h winblend
            width = 20,
            winhl = "PMenu",
            fader = specs.pulse_fader,
            resizer = specs.shrink_resizer,
        },
        ignore_filetypes = {},
        ignore_buftypes = { nofile = true },
    })
    map('n', '<C-F>', '<C-F>:lua require("specs").show_specs()<CR>', opt)
    map('n', '<C-B>', '<C-B>:lua require("specs").show_specs()<CR>', opt)
    map('n', 'n', 'n:lua require("specs").show_specs()<CR>', opt)
    map('n', 'N', 'N:lua require("specs").show_specs()<CR>', opt)
end

return M

