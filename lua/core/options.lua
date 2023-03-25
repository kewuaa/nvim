vim.g.python3_host_prog = require('core.settings'):getpy('default')
vim.g.c_syntax_for_h = 1

local options = {
    splitright = true,
    splitbelow = true,
    clipboard = 'unnamedplus',
    mouse = 'a',
    termguicolors = true,
    background = 'dark',
    encoding = 'utf-8',
    fileformat = 'dos',
    showmode = true,
    number = true,
    -- relativenumber = true,
    ruler = true,
    noundofile = true,
    nobackup = true,
    noswapfile = true,
    autochdir = true,
    autoread = true,
    showcmd = true,
    expandtab = true,
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    autoindent = true,
    smartindent = true,
    showmatch = true,
    scrolloff = 6,
    sidescrolloff = 16,
    nowrap = true,
    laststatus = 3,
    list = true,
    listchars = 'tab:--,trail:·,eol:↴',
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    shortmess = 'aoOTIcF',
    updatetime = 200,
    pumheight = 16,
    completeopt = 'menu,menuone,noselect,noinsert',
    foldlevelstart = 9,
    wildmenu = true,
    wildignorecase = true,
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
    signcolumn = 'yes',
}
if vim.fn.exists("g:nvy") then
    -- options.guifont = 'JetbrainsMono NFM:h10:Consolas'
    options.guifont = 'FiraCode NFM:h10:Consolas'
else if vim.fn.exists("g:neovide") then
        -- Put anything you want to happen only in Neovide here
        options.guifont = 'FiraCode NFM,Consolas:h10'
        vim.g.neovide_hide_mouse_when_typing = true
        vim.keymap.set('n', '<M-ENTER>', function()
            vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
        end)
    end
end
for key, value in pairs(options) do
    vim.o[key] = value
end

return options
