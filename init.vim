if exists("g:neovide")
    let g:neovide_fullscreen=v:true
    set guifont=JetBrains\ Mono\ NF:h12
endif

" 主题选择
" colorscheme industry

" 分割出来的窗口位于当前窗口下边/右边
set splitbelow
set splitright

" 共享剪切板
set clipboard^=unnamedplus

" 兼容鼠标
set mouse=a

" 开启真彩色
set termguicolors

set background=dark

" 编码设置
set encoding=utf-8

" 修改文件格式
set fileformat=dos " doc -> windows, unix -> linux

" 显示模式
set showmode

" 行号显示
set number

" 相对行号
set relativenumber

" 显示光标位置
set ruler

" 备份文件
set noundofile                         "取消生成undo备份文件
set nobackup                           "取消生成备份文件
set noswapfile                         "取消生成交换备份文件

" 自动切换工作目录
set autochdir

" 打开文件监视。
" 如果在编辑过程中文件发生外部改变,比如被别的编辑器编辑了,就会发出提示
set autoread

" 显示输入的命令(右下角)
set showcmd

" 将缩进设置为空格
set expandtab

" 设Tab宽度为4个空格
set tabstop=4

" 表示每一级缩进的长度，一般设置成跟softtabstop一样
set shiftwidth=4

" 编辑模式的时候按退格键的时候退回缩进的长度
set softtabstop=4

" 自动缩进
set autoindent

" 设置智能自动对齐
set smartindent

" 开启代码折叠
set foldmethod=indent
set foldlevel=99

" 匹配括号
set showmatch

" 垂直滚动时，光标距离顶部/底部的位置
set scrolloff=6

" 水平滚动时，光标距离行首或行尾的位置
set sidescrolloff=16

" 关闭自动折行
set nowrap

" 状态栏设置
set laststatus=2  "显示状态栏

" 在空行末显示$
set list

" 渲染Tab和空格
set listchars=tab:--,trail:·,eol:↴

set incsearch 								"输入搜索模式时,每输入一个字符,就自动跳到第一个匹配的结果
set ignorecase 								"搜索时忽略大小写

set smartcase 								"如果同时打开了ignorecase,那么对于只有一个大写字母的搜索词,将大小写敏感
											"其他情况都是大小写不敏感
											"比如,搜索Test时,将不匹配test；搜索test时,将匹配Test"

" Dont' pass messages to |ins-completin menu|
set shortmess+=c
set pumheight=16

" 自动补全不自动选中
set completeopt=menu,menuone,noselect,noinsert

" 命令模式下,底部操作指令按下Tab键自动补全。
" 第一次按下Tab,会显示所有匹配的操作指令的清单;第二次按下Tab,会依次选择各个指令
set wildmenu
" set wildmode=longest:list,full

" 显示左侧图标指示列
set signcolumn=yes

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:mapleader = ","

nnoremap <silent> <leader>rc :e $MYVIMRC<CR>
nnoremap <silent> <leader>rr :source $MYVIMRC<CR>

" 映射切换buffer的键位
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bd :bdelete<CR>

" 映射切换tab的键位
nnoremap <silent> <leader>tp :tabprevious<CR>
nnoremap <silent> <leader>tn :tabnext<CR>
nnoremap <silent> <leader>td :tabclose<CR>

nnoremap <silent> <C-w>= :vertical resize+5<CR>
nnoremap <silent> <C-w>- :vertical resize-5<CR>
nnoremap <silent> <C-w>] :resize+5<CR>
nnoremap <silent> <C-w>[ :resize-5<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua vim.g.python3_host_prog = require('settings').nvim_py3

let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_clipboard_provider = 1

function! s:load_clipboard()
    unlet g:loaded_clipboard_provider
    exe 'source ' . $VIMRUNTIME . '/autoload/provider/clipboard.vim'
endfunction

augroup setup
    au!
    au CursorMoved * ++once call s:load_clipboard()
    au BufRead * ++once set statusline=%!v:lua.require'statusline'.setup()
augroup END

lua require('plugins')

