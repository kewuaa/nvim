local M = {}
local map = vim.keymap.set
local window = require("core.utils.window")
local lsp = require("core.utils.lsp")
local im = require("core.utils.im")

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

    -- nvim-dap
    map('n', '<F6>', function() require('dap').continue() end, opts)
    map('n', '<F7>', function() require('dap').terminate() require('dapui').close() end, opts)
    map('n', '<F8>', function() require('dap').toggle_breakpoint() end, opts)
    map('n', '<F9>', function() require("dap").step_into() end, opts)
    map('n', '<F10>', function() require("dap").step_out() end, opts)
    map('n', '<F11>', function() require("dap").step_over() end, opts)
    map('n', '<leader>db', function () require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, opts)
    map('n', '<leader>dc', function () require('dap').run_to_cursor() end, opts)
    map('n', '<leader>dl', function () require('dap').run_last() end, opts)
    map('n', '<leader>do', function () require('dap').repl.open() end, opts)

    -- asynctasks
    map('n', '<A-q>', '<cmd>AsyncTask file-run<CR>', opts)
    map('n', '<leader><A-q>', '<cmd>AsyncTask file-build<CR>', opts)
    map('n', '<F5>', '<cmd>AsyncTask project-run<CR>', opts)
    map('n', '<leader><F5>', '<cmd>AsyncTask project-build<CR>', opts)
    map('n', '<leader>ot', '<cmd>AsyncTask open-terminal<CR>', opts)

    -- diffview
    map('n', '<leader>gg', '<cmd>DiffviewOpen<CR>', opts)
    map('n', '<leader>gc', '<cmd>DiffviewClose<CR>', opts)
    map({'n', 'v'}, '<leader>gh', '<cmd>DiffviewFileHistory<CR>', opts)

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
