local M = {}
local default_opts = { silent = true, noremap = true }

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts vim.keymap.set.Opts|nil
function M.set(mode, lhs, rhs, opts)
    vim.keymap.set(
        mode,
        lhs,
        rhs,
        vim.tbl_extend("keep", opts or {}, default_opts)
    )
end

function M.init()
    vim.g.mapleader = ' '

    M.set('n', '<leader>eh', '<cmd>e $MYVIMRC<CR>')

    M.set('n', '<leader>bd', '<cmd>bdelete<CR>')

    M.set('t', '<A-q>', [[<c-\><c-n>]])
    for i = 1, 6 do
        M.set(
            {"n", "t"},
            ("<A-%d>"):format(i),
            ("<CMD>tabnext %d<CR>"):format(i)
        )
    end
    M.set({'n', 't'}, '<A-j>', '<cmd>tabnext<CR>')
    M.set({'n', 't'}, '<A-k>', '<cmd>tabprevious<CR>')
    M.set({'n', 't'}, '<A-TAB>', '<cmd>tabnext #<CR>')
    M.set({'n', 't'}, '<M-S-c>', '<cmd>tabclose<CR>')

    M.set('n', '<leader>tq', function()
        local fn = vim.fn
        if fn.empty(fn.filter(fn.getwininfo(), 'v:val.quickfix')) == 1 then
            vim.cmd [[copen]]
        else
            vim.cmd [[cclose]]
        end
    end)

    M.set('n', '<A-q>', function() require("utils").run_file() end)
    M.set('n', '<leader><A-q>', function() require("utils").run_file({build = true}) end)
    M.set('n', '<leader><leader><A-q>', function() require("utils").run_file({debug = true}) end)
    M.set(
        "n", "<leader>ot",
        function()
            local utils = require("utils")
            local cmd = utils.is_win and "where clink >nul 2>nul && if \\%errorlevel\\% equ 0 (cmd.exe /k clink inject) else (cmd.exe)" or ""
            utils.run_in_terminal(cmd)
        end
    )

    M.set(
        "n", "<leader>rc",
        function()
            local cmd = vim.fn.input("command to run: ", "", "shellcmd")
            if cmd == "" then
                vim.notify("empty command", vim.log.levels.WARN)
                return
            end
            require("utils").run_in_terminal(cmd)
        end
    )
    M.set("n", "<leader>rr", function()
        if vim.fn.histnr("input") == 0 then
            vim.notify("no cache command", vim.log.levels.WARN)
            return
        end
        require("utils").run_in_terminal(vim.fn.histget("input", -1))
    end)

    M.set("n", "<leader>lsp", function() require("utils.lsp").toggle() end)
    M.set("n", "<leader>tim", function() require("utils.im").toggle() end)

    M.set("i", "<C-f>", "<Right>")
    M.set("i", "<C-b>", "<Left>")

    M.set({"n", "v"}, "<leader><leader>y", '"+y')
    M.set({"n", "v"}, "<leader><leader>p", '"+p')
    M.set("n", "<leader><leader>Y", '"+y$')
    M.set("n", "<leader><leader>P", '"+P')

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
