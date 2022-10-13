local map = vim.keymap.set
local opts = {
    noremap = true,
    silent = true,
}

local function telescope(option)
    return function()
        local cmd = string.format('Telescope %s cwd=%s', option, require('utils').get_cwd())
        vim.cmd(cmd)
    end
end

local function toggleterm(option)
    return function()
        if not option then
            option = 'horizontal'
        end
        local cmd = string.format('ToggleTerm dir=%s direction=%s', require('utils').get_cwd(), option)
        vim.cmd(cmd)
    end
end
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

---------------------------------------------------------------------------------------------------
