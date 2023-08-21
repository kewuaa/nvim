local M = {}
local settings = require("core.settings")
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
if vim.fn.exists("g:nvy") == 1 then
    -- options.guifont = 'JetbrainsMono NFM:h10:Consolas'
    options.guifont = 'FiraCode NFM:h10:Consolas'
end

M.init = function()
    vim.filetype.add({
        extension = {
            pyx = "cython",
            pxd = "cython",
            pxi = "cython"
        }
    })

    vim.g.python3_host_prog = require('core.settings'):getpy('nvim')
    vim.g.c_syntax_for_h = 1
    vim.g.zig_fmt_autosave = 0
    if settings.is_wsl then
        vim.g.clipboard = {
            name = "win32yank-wsl",
            copy = {
                ["+"] = "win32yank.exe -i --crlf",
                ["*"] = "win32yank.exe -i --crlf",
            },
            paste = {
                ["+"] = "win32yank.exe -o --lf",
                ["*"] = "win32yank.exe -o --lf",
            },
            cache_enabled = 0,
        }
    elseif settings.is_mac then
        vim.g.clipboard = {
            name = "macOS-clipboard",
            copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
            paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
            cache_enabled = 0,
        }
    end

    for key, value in pairs(options) do
        vim.o[key] = value
    end
end


return M
