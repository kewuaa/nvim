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

local function toggleterm(option)
    return function()
        if not option then
            option = 'horizontal'
        end
        local cmd = string.format('ToggleTerm dir=%s direction=%s', require('core.utils').get_cwd(), option)
        vim.cmd(cmd)
    end
end

local function todo_comments(command)
    return function()
        local cmd = string.format('%s cwd=%s', command, require("core.utils").get_cwd())
        vim.cmd(cmd)
    end
end

local function windows_cmd(command)
   return table.concat({ '<Cmd>', command, '<CR>' })
end

keymaps.asynctasks = {
    {'n', '<F5>', ':AsyncTask file-run<CR>'},
    {'n', '<F6>', ':AsyncTask file-build<CR>'},
    {'n', '<F7>', ':AsyncTask run-test<CR>'},
}

keymaps.hop = {
    {'n', '<leader><leader>w', ':HopWord<CR>'},
    {'n', '<leader><leader>j', ':HopLine<CR>'},
    {'n', '<leader><leader>k', ':HopLine<CR>'},
    {'n', '<leader><leader>f', ':HopChar1<CR>'},
    {'n', '<leader><leader>c', ':HopChar2<CR>'},
    {'n', '<leader><leader>/', ':HopPattern<CR>'},
}

keymaps.windows = {
    {'n', '<c-w>z', windows_cmd('WindowsMaximize')},
    {'n', '<c-w>_', windows_cmd('WindowsMaximizeVertically')},
    {'n', '<c-w>|', windows_cmd('WindowsMaximizeHorizontally')},
    {'n', '<c-w>=', windows_cmd('WindowsEqualize')},
}

keymaps.telescope = {
    {'n', '<leader>ff', telescope('find_files')},
    {'n', '<leader>fg', telescope('live_grep')},
    {'n', '<leader>fb', ':Telescope buffers<CR>'},
    {'n', '<leader>fh', ':Telescope help_tags<CR>'},
    {'n', '<leader>f/', ':Telescope current_buffer_fuzzy_find<CR>'},
    {'n', '<leader>fm', ':Telescope keymaps<CR>'},
    {'n', '<leader>fc', ':Telescope commands<CR>'},
}

keymaps.toggleterm = {
    {'t', '<ESC>', [[<c-\><c-n>]]},
    {{'n', 't'}, '<M-=>', toggleterm()},
    {{'n', 'x'}, '<M-->', ':ToggleTermSendCurrentLine<CR>'},
}

keymaps.todo_comments = {
    {'n', '<leader>ftd', todo_comments('TodoTelescope')}
}

keymaps.search_replace = {
    {"v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>"},
    {"v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>"},
    {"v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>"},
    {"n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>"},
    {"n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>"},
    {"n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>"},
    {"n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>"},
    {"n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>"},
    {"n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>"},
    {"n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>"},
    {"n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>"},
    {"n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>"},
    {"n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>"},
    {"n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>"},
    {"n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>"},
}

---------------------------------------------------------------------------------------------------

function keymaps.init()
    local opts_ = {
        noremap = true,
        silent = true,
    }
    vim.g.mapleader = ','

    map('n', '<leader>rc', ':e $MYVIMRC<CR>', opts_)
    -- map('n', '<leader>rr', ':source $MYVIMRC<CR>', opts_)

    map('n', '<leader>bp', ':bp<CR>', opts_)
    map('n', '<leader>bn', ':bn<CR>', opts_)
    map('n', '<leader>bd', ':bdelete<CR>', opts_)

    map('n', '<leader>tp', ':tabprevious<CR>', opts_)
    map('n', '<leader>tn', ':tabnext<CR>', opts_)
    map('n', '<leader>td', ':tabclose<CR>', opts_)

    -- map('n', '<C-w>=', ':vertical resize+5<CR>', opts_)
    -- map('n', '<C-w>-', ':vertical resize-5<CR>', opts_)
    -- map('n', '<C-w>]', ':resize+5<CR>', opts_)
    -- map('n', '<C-w>[', ':resize-5<CR>', opts_)

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
