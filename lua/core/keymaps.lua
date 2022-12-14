local map = vim.keymap.set
local opts = {
    noremap = true,
    silent = true,
}

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
---------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------

map('n', '<F5>', '<cmd>AsyncTask file-run<CR>', opts)

map('n', '<leader><leader>w', '<cmd>HopWord<CR>', opts)
map('n', '<leader><leader>j', '<cmd>HopLine<CR>', opts)
map('n', '<leader><leader>k', '<cmd>HopLine<CR>', opts)
map('n', '<leader><leader>f', '<cmd>HopChar1<CR>', opts)
map('n', '<leader><leader>c', '<cmd>HopChar2<CR>', opts)
map('n', '<leader><leader>/', '<cmd>HopPattern<CR>', opts)

map('n', '<leader>sw', '<cmd>ISwapWith<CR>', opts)

map('n', '<leader>bb', '<cmd>JABSOpen<CR>', opts)

map('n', '<leader>tt', '<cmd>NvimTreeToggle<CR>', opts)

map('n', '<leader>ff', telescope('find_files'), opts)
map('n', '<leader>fg', telescope('live_grep'), opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
map('n', '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
map('n', '<leader>fm', '<cmd>Telescope keymaps<CR>', opts)
map('n', '<leader>fc', '<cmd>Telescope commands<CR>', opts)

map('n', '<leader>bd', '<cmd>Bdelete<CR>', opts)

map('t', '<ESC>', [[<c-\><c-n>]], opts)
map({'n', 't'}, '<M-=>', toggleterm(), opts)
map({'n', 'x'}, '<M-->', '<cmd>ToggleTermSendCurrentLine<CR>', opts)

map('n', '<leader>ftd', todo_comments('TodoTelescope'), opts)

map('n','<leader>gs', ':GscopeFind s <C-R><C-W><cr>', opts)
map('n','<leader>gg', ':GscopeFind g <C-R><C-W><cr>', opts)
map('n', '<leader>gc', ':GscopeFind c <C-R><C-W><cr>', opts)
map('n', '<leader>gt', ':GscopeFind t <C-R><C-W><cr>', opts)
map('n', '<leader>ge', ':GscopeFind e <C-R><C-W><cr>', opts)
map('n', '<leader>gf', ':GscopeFind f <C-R>=expand("<cfile>")<cr><cr>', opts)
map('n', '<leader>gi', ':GscopeFind i <C-R>=expand("<cfile>")<cr><cr>', opts)
map('n', '<leader>gd', ':GscopeFind d <C-R><C-W><cr>', opts)
map('n', '<leader>ga', ':GscopeFind a <C-R><C-W><cr>', opts)
map('n', '<leader>gz', ':GscopeFind z <C-R><C-W><cr>', opts)

---------------------------------------------------------------------------------------------------
