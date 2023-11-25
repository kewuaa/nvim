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
    fileformats = 'unix,mac,dos',
    showmode = true,
    number = true,
    relativenumber = true,
    ruler = true,
    undofile = true,
    swapfile = false,
    backup = false,
    backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
    writebackup = false,
    wrap = false,
    wrapscan = true,
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
    laststatus = 3,
    list = true,
    listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←,eol:↴",
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    shortmess = 'aoOTIcF',
    updatetime = 200,
    pumheight = 16,
    completeopt = 'menu,menuone,noselect,noinsert',
    concealcursor = "niv",
    foldenable = true,
    foldlevelstart = 99,
    wildmenu = true,
    wildignorecase = true,
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
    signcolumn = 'yes',
    cursorline = true,
}
if vim.fn.executable('rg') == 1 then
  options.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  options.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

if vim.fn.exists("g:nvy") == 1 then
    options.guifont = 'FiraCode Nerd Font Mono:h10:Consolas'
end

if vim.fn.exists("g:neovide") == 1 then
    options.guifont = 'FiraCode Nerd Font Mono,Consolas:h10'
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_theme = 'auto'
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_profiler = false
    vim.keymap.set(
        "n",
        "<a-Enter>",
        function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end,
        {silent = true}
    )
end

M.init = function()
    vim.filetype.add({
        extension = {
            pyx = "cython",
            pxd = "cython",
            pxi = "cython",
            pyxdep = "python",
            pyxbld = "python",
            resx = "xml",
        }
    })

    vim.g.python3_host_prog = require('core.settings'):getpy('default')
    -- vim.g.c_syntax_for_h = 1
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
