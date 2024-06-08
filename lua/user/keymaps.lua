local M = {}
local map = vim.keymap.set
local window = require("utils.window")
local lsp = require("utils.lsp")
local im = require("utils.im")

CR = function()
    local complete_info = vim.fn.complete_info()
    if complete_info.pum_visible == 1 then
        local idx = complete_info.selected
        local selected_item
        local keys
        if idx > -1 then
            selected_item = complete_info.items[idx + 1]
        else
            selected_item = complete_info.items[1]
            keys = "<C-n>"
        end
        if vim.tbl_contains({"Function", "Method"}, selected_item.kind) then
            local cursor = vim.api.nvim_win_get_cursor(0)
            local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2] - 1, cursor[1] - 1, cursor[2], {})[1]
            if vim.fn.mode() ~= "s" and prev_char ~= "(" and prev_char ~= ")" then
                vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(
                        "()<left>",
                        true,
                        false,
                        true
                    ), "i", false
                )
            end
            keys = keys and keys .. "<C-y>" or "<C-y>"
        else
            local cp_item = vim.tbl_get(selected_item, "user_data", "nvim", "lsp", "completion_item")
            if selected_item.kind == "Snippet"
                or cp_item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet then
                local body = (cp_item.textEdit and cp_item.textEdit.newText) or cp_item.insertText or cp_item.data.body
                vim.schedule(function()
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    vim.api.nvim_buf_set_text(0, line - 1, col - #selected_item.word, line - 1, col, {})
                    vim.snippet.expand(body)
                end)
                keys = keys or "<Ignore>"
            end
        end
        return keys
    else
        return "<CR>"
    end
end

function M.init()
    vim.g.mapleader = '\\'
    local opts = { silent = true, noremap = true }

    map('n', '<leader>rc', '<cmd>e $MYVIMRC<CR>', opts)
    -- map('n', '<leader>rr', ':source $MYVIMRC<CR>', opts)

    map('n', '<leader>bp', '<cmd>bp<CR>', opts)
    map('n', '<leader>bn', '<cmd>bn<CR>', opts)
    map('n', '<leader>bd', '<cmd>bdelete<CR>', opts)

    map('t', '<leader><ESC>', [[<c-\><c-n>]], opts)
    for i = 1, 6 do
        map(
            {"n", "t"},
            ("<A-%d>"):format(i),
            ("<CMD>tabnext %d<CR>"):format(i),
            opts
        )
    end
    map({'n', 't'}, '<A-j>', '<cmd>tabnext<CR>', opts)
    map({'n', 't'}, '<A-k>', '<cmd>tabprevious<CR>', opts)
    map({'n', 't'}, '<A-TAB>', '<cmd>tabnext #<CR>', opts)
    map({'n', 't'}, '<M-S-c>', '<cmd>tabclose<CR>', opts)

    map('n', '<leader>tq', function()
        local fn = vim.fn
        if fn.empty(fn.filter(fn.getwininfo(), 'v:val.quickfix')) == 1 then
            vim.cmd [[copen]]
        else
            vim.cmd [[cclose]]
        end
    end)

    map('n', '<C-w>=', '<cmd>vertical resize+5<CR>', opts)
    map('n', '<C-w>-', '<cmd>vertical resize-5<CR>', opts)
    map('n', '<C-w>]', '<cmd>resize+5<CR>', opts)
    map('n', '<C-w>[', '<cmd>resize-5<CR>', opts)

    map("n", "<C-w>z", window.zoom, opts)
    map("n", "<leader>lsp", lsp.toggle, opts)
    map("n", "<leader>tim", im.toggle_imtoggle, opts)

    map("i", "<C-l>", "<Right>", opts)

    local expr_opts = vim.tbl_extend("error", opts, {expr = true})
    map('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   expr_opts)
    map('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr_opts)
    map('i', '<CR>', CR, expr_opts)

    -- vim.cmd [[
    -- " 多行应用宏
    -- xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
    -- function! ExecuteMacroOverVisualRange()
    -- echom "@".getcmdline()
    -- execute ":'<,'>normal @".nr2char(getchar())
    -- endfunction
    -- ]]
end

return M
