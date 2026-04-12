local keymaps = require("user.keymaps")
local mini_pick = require("mini.pick")

vim.ui.select = mini_pick.ui_select

mini_pick.setup({
    -- Keys for performing actions. See `:h MiniPick-actions`.
    mappings = {
        caret_left  = '<c-b>',
        caret_right = '<c-f>',

        choose            = '<CR>',
        choose_in_split   = '<C-s>',
        choose_in_tabpage = '<C-t>',
        choose_in_vsplit  = '<C-v>',
        choose_marked     = '<M-CR>',

        delete_char       = '<C-h>',
        delete_char_right = '<Del>',
        delete_left       = '<C-u>',
        delete_word       = '<C-w>',

        mark     = '<C-CR>',
        mark_all = '<C-a>',

        move_down  = '<C-n>',
        move_start = '<C-g>',
        move_up    = '<C-p>',

        paste = '<C-r>',

        refine        = '<C-Space>',
        refine_marked = '<M-Space>',

        scroll_down  = '<C-S-f>',
        scroll_left  = '<C-,>',
        scroll_right = '<C-.>',
        scroll_up    = '<C-S-b>',

        stop = '<Esc>',

        toggle_info    = '<S-Tab>',
        toggle_preview = '<Tab>',
    },
})

keymaps.set("n", "<leader>fr", mini_pick.builtin.resume)
keymaps.set("n", "<leader>ff", mini_pick.builtin.files)
keymaps.set("n", "<leader>fg", mini_pick.builtin.grep_live)
keymaps.set("n", "<leader>fb", mini_pick.builtin.buffers)
keymaps.set("n", "<leader>fc", function() require("mini.extra").pickers.commands() end)
keymaps.set("n", "<leader>fd", function() require("mini.extra").pickers.diagnostic() end)
keymaps.set("n", "<leader>fh", function() require("mini.extra").pickers.git_hunks() end)
keymaps.set("n", "<leader>fO", function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end)
keymaps.set("n", "<leader>fs", function() require("mini.extra").pickers.lsp({ scope = "workspace_symbol" }) end)
