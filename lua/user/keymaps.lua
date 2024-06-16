local M = {}
local map = vim.keymap.set

M.CR = function()
    local complete_info = vim.fn.complete_info()
    if complete_info.pum_visible == 1 then
        local idx = complete_info.selected
        local keys = "<C-y>"
        if idx == -1 then
            keys = "<C-n>" .. keys
        end
        vim.schedule(function()
            vim.api.nvim_exec_autocmds("User", {pattern = "CompleteDone", modeline = false})
        end)
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

    map('n', '[b', '<cmd>bp<CR>', opts)
    map('n', ']b', '<cmd>bn<CR>', opts)
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

    map("n", "<C-w>z", function() require("utils.window").zoom() end, opts)
    map("n", "<leader>lsp", function() require("utils.lsp").toggle() end, opts)
    map("n", "<leader>tim", function() require("utils.im").toggle() end, opts)

    map("i", "<C-l>", "<Right>", opts)

    local expr_opts = vim.tbl_extend("error", opts, {expr = true})
    map('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   expr_opts)
    map('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr_opts)
    map(
        {"i", "s"},
        "<C-j>",
        function()
            return vim.snippet.active({direction = 1}) and "<CMD>lua vim.snippet.jump(1)<CR>" or "<C-j>"
        end,
        expr_opts
    )
    map(
        {"i", "s"},
        "<C-k>",
        function()
            return vim.snippet.active({direction = -1}) and "<CMD>lua vim.snippet.jump(-1)<CR>" or "<C-k>"
        end,
        expr_opts
    )
    map('i', '<CR>', M.CR, expr_opts)

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
