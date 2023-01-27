local keymaps = {}
local map = vim.keymap.set
local opts = {
    noremap = true,
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

keymaps.iswap = {
    {'n', '<leader>sw', '<cmd>ISwapWith<cr>'}
}

keymaps.JABS = {
    {'n', '<leader>bb', '<cmd>JABSOpen<CR>'}
}

keymaps.nvim_tree = {
    {'n', '<leader>tt', '<cmd>NvimTreeToggle<CR>'}
}

keymaps.treesj = {
    {'n', '<leader>j', '<cmd>TSJToggle<CR>'}
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

keymaps.bufdelete = {
    {'n', '<leader>bd', '<cmd>Bdelete<CR>'}
}

keymaps.toggleterm = {
    {'t', '<ESC>', [[<c-\><c-n>]]},
    {{'n', 't'}, '<M-=>', toggleterm()},
    {{'n', 'x'}, '<M-->', '<cmd>ToggleTermSendCurrentLine<CR>'},
}

keymaps.todo_comments = {
    {'n', '<leader>ftd', todo_comments('TodoTelescope')}
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
    vim.g.mapleader = ','

    map('n', '<leader>rc', '<cmd>e $MYVIMRC<CR>', opts)
    map('n', '<leader>rr', '<cmd>source $MYVIMRC<CR>', opts)

    map('n', '<leader>bp', '<cmd>bp<CR>', opts)
    map('n', '<leader>bn', '<cmd>bn<CR>', opts)
    map('n', '<leader>bd', '<cmd>bdelete<CR>', opts)

    map('n', '<leader>tp', '<cmd>tabprevious<CR>', opts)
    map('n', '<leader>tn', '<cmd>tabnext<CR>', opts)
    map('n', '<leader>td', '<cmd>tabclose<CR>', opts)

    map('n', '<C-w>=', '<cmd>vertical resize+5<CR>', opts)
    map('n', '<C-w>-', '<cmd>vertical resize-5<CR>', opts)
    map('n', '<C-w>]', '<cmd>resize+5<CR>', opts)
    map('n', '<C-w>[', '<cmd>resize-5<CR>', opts)

    vim.cmd [[
    " 多行应用宏
    xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

    function! ExecuteMacroOverVisualRange()
      echom "@".getcmdline()
      execute ":'<,'>normal @".nr2char(getchar())
    endfunction
    ]]
end

function keymaps:load(name)
    return function ()
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
