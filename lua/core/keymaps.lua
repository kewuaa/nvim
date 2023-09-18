local keymaps = {}
local map = vim.keymap.set
local opts = {
    silent = true,
}

---------------------------------------------------------------------------------------------------
local function telescope(option)
    return function()
        local cmd = string.format('Telescope %s cwd=%s', option, require('core.utils').get_cwd())
        vim.cmd(cmd)
    end
end

local function todo_comments(command)
    return function()
        local cmd = string.format('%s cwd=%s', command, require("core.utils").get_cwd())
        vim.cmd(cmd)
    end
end

keymaps.asynctasks = {
    {'n', '<A-q>', '<cmd>AsyncTask file-run<CR>'},
    {'n', '<leader><A-q>', '<cmd>AsyncTask file-build<CR>'},
    {'n', '<F5>', '<cmd>AsyncTask project-run<CR>'},
    {'n', '<leader><F5>', '<cmd>AsyncTask project-build<CR>'},
}

keymaps.hop = {
    {'n', '<leader><leader>w', '<cmd>HopWord<CR>'},
    {'n', '<leader><leader>j', '<cmd>HopLine<CR>'},
    {'n', '<leader><leader>k', '<cmd>HopLine<CR>'},
    {'n', '<leader><leader>f', '<cmd>HopChar1<CR>'},
    {'n', '<leader><leader>c', '<cmd>HopChar2<CR>'},
    {'n', '<leader><leader>/', '<cmd>HopPattern<CR>'},
}

keymaps.windows = {
    {'n', '<c-w>z', '<cmd>WindowsMaximize<CR>'},
    {'n', '<c-w>_', '<cmd>WindowsMaximizeVertically<CR>'},
    {'n', '<c-w>|', '<cmd>WindowsMaximizeHorizontally<CR>'},
    {'n', '<c-w>=', '<cmd>WindowsEqualize<CR>'},
}

keymaps.telescope = {
    {'n', '<leader>ff', telescope('find_files')},
    {'n', '<leader>fg', telescope('live_grep')},
    {'n', '<leader>fb', '<cmd>Telescope buffers<CR>'},
    {'n', '<leader>fh', '<cmd>Telescope help_tags<CR>'},
    {'n', '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<CR>'},
    {'n', '<leader>fm', '<cmd>Telescope keymaps<CR>'},
    {'n', '<leader>fc', '<cmd>Telescope commands<CR>'},
}

keymaps.diffview = {
    {'n', '<leader>gg', '<cmd>DiffviewOpen<CR>'},
    {'n', '<leader>gc', '<cmd>DiffviewClose<CR>'},
    {{'n', 'v'}, '<leader>gh', '<cmd>DiffviewFileHistory<CR>'},
}

keymaps.dap = {
    {'n', '<F6>', function() require('dap').continue() end},
    {'n', '<F7>', function() require('dap').terminate() require('dapui').close() end},
    {'n', '<F8>', function() require('dap').toggle_breakpoint() end},
    {'n', '<F9>', function() require("dap").step_into() end},
    {'n', '<F10>', function() require("dap").step_out() end},
    {'n', '<F11>', function() require("dap").step_over() end},
    {'n', '<leader>db', function () require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end},
    {'n', '<leader>dc', function () require('dap').run_to_cursor() end},
    {'n', '<leader>dl', function () require('dap').run_last() end},
    {'n', '<leader>do', function () require('dap').repl.open() end},
}

keymaps.todo_comments = {
    {'n', '<leader>ftd', todo_comments('TodoTelescope')}
}

---------------------------------------------------------------------------------------------------

function keymaps.init()
    local opts_ = {
        noremap = true,
        silent = true,
    }
    vim.g.mapleader = ','

    map('n', '<leader>rc', '<cmd>e $MYVIMRC<CR>', opts_)
    -- map('n', '<leader>rr', ':source $MYVIMRC<CR>', opts_)

    map('n', '<leader>bp', '<cmd>bp<CR>', opts_)
    map('n', '<leader>bn', '<cmd>bn<CR>', opts_)
    map('n', '<leader>bd', '<cmd>bdelete<CR>', opts_)

    map('n', '<leader>tp', '<cmd>tabprevious<CR>', opts_)
    map('n', '<leader>tn', '<cmd>tabnext<CR>', opts_)
    map('n', '<leader>td', '<cmd>tabclose<CR>', opts_)

    map('t', '<A-q>', [[<c-\><c-n>]], opts_)

    -- map('n', '<C-w>=', '<cmd>vertical resize+5<CR>', opts_)
    -- map('n', '<C-w>-', '<cmd>vertical resize-5<CR>', opts_)
    -- map('n', '<C-w>]', '<cmd>resize+5<CR>', opts_)
    -- map('n', '<C-w>[', '<cmd>resize-5<CR>', opts_)

    -- vim.cmd [[
    -- " 多行应用宏
    -- xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
    -- function! ExecuteMacroOverVisualRange()
    -- echom "@".getcmdline()
    -- execute ":'<,'>normal @".nr2char(getchar())
    -- endfunction
    -- ]]
end

function keymaps:load(name)
    return function()
        local km = self[name]
        if km then
            for _, item in ipairs(km) do
                map(item[1], item[2], item[3], opts)
            end
        else
            vim.notify('error during add keymaps: no keymaps of ' .. name)
        end
    end
end

return keymaps
