local M = {}
local map = vim.keymap.set

function M.init()
    vim.g.mapleader = ' '
    local opts = { silent = true, noremap = true }

    map('n', '<leader>rc', '<cmd>e $MYVIMRC<CR>', opts)
    -- map('n', '<leader>rr', ':source $MYVIMRC<CR>', opts)

    map('n', '[b', '<cmd>bp<CR>', opts)
    map('n', ']b', '<cmd>bn<CR>', opts)
    map('n', '<leader>bd', '<cmd>bdelete<CR>', opts)

    map('t', '<A-q>', [[<c-\><c-n>]], opts)
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

    map('n', '<A-q>', function() require("utils").run_file() end, opts)
    map('n', '<leader><A-q>', function() require("utils").run_file({build = true}) end, opts)
    map('n', '<leader><leader><A-q>', function() require("utils").run_file({debug = true}) end, opts)
    map(
        "n", "<leader>ot",
        function()
            local utils = require("utils")
            local cmd = utils.is_win and "where clink >nul 2>nul && if \\%errorlevel\\% equ 0 (cmd.exe /k clink inject) else (cmd.exe)" or "$SHELL"
            utils.run_in_terminal(cmd)
        end, opts
    )
    map(
        "n", "<leader>rr",
        function()
            vim.uv.chdir(require("utils").get_cwd())
            local cmd = vim.fn.input("command to run: ", "", "shellcmd")
            if cmd == "" then
                vim.notify("empty command", vim.log.levels.WARN)
                return
            end
            require("utils").run_in_terminal(cmd)
        end, opts
    )

    map("n", "<leader>lsp", function() require("utils.lsp").toggle() end, opts)
    map("n", "<leader>tim", function() require("utils.im").toggle() end, opts)

    map("i", "<C-f>", "<Right>", opts)
    map("i", "<C-b>", "<Left>", opts)

    map({"n", "v"}, "<leader><leader>y", '"+y', opts)
    map({"n", "v"}, "<leader><leader>p", '"+p', opts)

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
