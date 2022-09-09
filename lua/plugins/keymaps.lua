local map = vim.keymap.set
local opt = {
    noremap = true,
    silent = true,
}

local function telescope(option)
    return function()
        local cmd = string.format('Telescope %s cwd=%s', option, require('plugins').get_cwd())
        vim.cmd(cmd)
    end
end
---------------------------------------------------------------------------------------------------

map('n', '<F5>', '<cmd>AsyncTask file-run<CR>', opt)

map('n', '<leader><leader>w', '<cmd>HopWord<CR>', opt)
map('n', '<leader><leader>j', '<cmd>HopLine<CR>', opt)
map('n', '<leader><leader>k', '<cmd>HopLine<CR>', opt)
map('n', '<leader><leader>f', '<cmd>HopChar1<CR>', opt)
map('n', '<leader><leader>c', '<cmd>HopChar2<CR>', opt)
map('n', '<leader><leader>/', '<cmd>HopPattern<CR>', opt)

map('n', '<leader>nf', '<cmd>Neogen func<CR>', opt)
map('n', '<leader>nc', '<cmd>Neogen class<CR>', opt)

map('n', '<leader>sw', '<cmd>ISwapWith<CR>', opt)

map('n', '<leader>bb', '<cmd>JABSOpen<CR>', opt)

map('n', '<leader>tt', '<cmd>NvimTreeToggle<CR>', opt)

map('n', '<leader>ff', telescope('find_files'), opt)
map('n', '<leader>fg', telescope('live_grep'), opt)
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opt)
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opt)
map('n', '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opt)
map('n', '<leader>fm', '<cmd>Telescope keymaps<CR>', opt)
map('n', '<leader>fc', '<cmd>Telescope commands<CR>', opt)

map('n', '<leader>bd', '<cmd>Bdelete<CR>', opt)

---------------------------------------------------------------------------------------------------
