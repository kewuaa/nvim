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
    {'n', '<F5>', '<cmd>AsyncTask file-run<CR>'},
    {'n', '<F6>', '<cmd>AsyncTask file-build<CR>'},
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
    {'n', '<c-w>z', windows_cmd('WindowsMaximize')},
    {'n', '<c-w>_', windows_cmd('WindowsMaximizeVertically')},
    {'n', '<c-w>|', windows_cmd('WindowsMaximizeHorizontally')},
    {'n', '<c-w>=', windows_cmd('WindowsEqualize')},
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

keymaps.toggleterm = {
    {'t', '<ESC>', [[<c-\><c-n>]]},
    {{'n', 't'}, '<M-=>', toggleterm()},
    {{'n', 'x'}, '<M-->', '<cmd>ToggleTermSendCurrentLine<CR>'},
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

keymaps.vim_gutentags = {
    {'n','<leader>gs', ':GscopeFind s <C-R><C-W><cr>'},
    {'n','<leader>gg', ':GscopeFind g <C-R><C-W><cr>'},
    {'n', '<leader>gc', ':GscopeFind c <C-R><C-W><cr>'},
    {'n', '<leader>gt', ':GscopeFind t <C-R><C-W><cr>'},
    {'n', '<leader>ge', ':GscopeFind e <C-R><C-W><cr>'},
    {'n', '<leader>gf', ':GscopeFind f <C-R>=expand("<cfile>")<cr><cr>'},
    {'n', '<leader>gi', ':GscopeFind i <C-R>=expand("<cfile>")<cr><cr>'},
    {'n', '<leader>gd', ':GscopeFind d <C-R><C-W><cr>'},
    {'n', '<leader>ga', ':GscopeFind a <C-R><C-W><cr>'},
    {'n', '<leader>gz', ':GscopeFind z <C-R><C-W><cr>'},
}

---------------------------------------------------------------------------------------------------

function keymaps.init()
    local opts_ = {
        noremap = true,
        silent = true,
    }
    vim.g.mapleader = ','

    map('n', '<leader>rc', '<cmd>e $MYVIMRC<CR>', opts_)
    -- map('n', '<leader>rr', '<cmd>source $MYVIMRC<CR>', opts_)

    map('n', '<leader>bp', '<cmd>bp<CR>', opts_)
    map('n', '<leader>bn', '<cmd>bn<CR>', opts_)
    map('n', '<leader>bd', '<cmd>bdelete<CR>', opts_)

    map('n', '<leader>tp', '<cmd>tabprevious<CR>', opts_)
    map('n', '<leader>tn', '<cmd>tabnext<CR>', opts_)
    map('n', '<leader>td', '<cmd>tabclose<CR>', opts_)

    -- map('n', '<C-w>=', '<cmd>vertical resize+5<CR>', opts_)
    -- map('n', '<C-w>-', '<cmd>vertical resize-5<CR>', opts_)
    -- map('n', '<C-w>]', '<cmd>resize+5<CR>', opts_)
    -- map('n', '<C-w>[', '<cmd>resize-5<CR>', opts_)

    -- 多行应用宏
    map('x', '@', function()
        vim.api.nvim_command("'<,'>normal @" .. vim.fn.nr2char(vim.fn.getchar()))
    end, opts_)
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
