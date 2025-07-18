local M = {}
local utils = require("utils")
local options = {
    splitright = true,
    splitbelow = true,
    -- clipboard = 'unnamedplus',
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
    completeopt = 'menu,menuone,noselect,noinsert,fuzzy',
    concealcursor = "niv",
    foldenable = true,
    foldlevelstart = 99,
    wildmenu = true,
    wildignorecase = true,
    wildoptions = "fuzzy,pum,tagfile",
    wildmode = 'noselect:lastused,full',
    wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
    signcolumn = 'yes',
    cursorline = true,
    foldmethod = 'expr',
    foldexpr = 'v:lua.vim.treesitter.foldexpr()'
}

if vim.fn.has("gui_running") then
    options.guifont = "FiraCode Nerd Font:h12"
end

if vim.env.SSH_TTY then
    options.clipboard = nil
    local function paste(reg)
        return function(lines)
            local content = vim.fn.getreg('"')
            return vim.split(content, '\n')

        end
    end
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = paste("+"),
            ['*'] = paste("*"),
            -- ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
            -- ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
        },
    }
end

if utils.is_wsl then
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
elseif utils.is_mac then
    vim.g.clipboard = {
        name = "macOS-clipboard",
        copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
        paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
        cache_enabled = 0,
    }
end

if utils.has("rg") then
  options.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  options.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

M.init = function()
    -- vim.g.c_syntax_for_h = 1
    vim.g.zig_fmt_autosave = false
    for key, value in pairs(options) do
        vim.o[key] = value
    end
    vim.ui.input = function(opts, on_confirm)
        require("utils.input").input(opts or {}, on_confirm)
    end
end


return M
