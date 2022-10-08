
" 改变字体和字体大小
exe 'Guifont! JetBrainsMono NFM:h12'
set guifont=JetBrainsMono\ NFM:h12

" 图形自适应
" exe 'GuiAdaptiveColor 1'

" 修改Tab栏
exe 'GuiTabline 0'

" 修改弹出菜单样式
exe 'GuiPopupmenu 0'

" 隐藏鼠标
call GuiMousehide(1)

" 全屏进入
call GuiWindowFullScreen(1)

nmap <F11> :call GuiWindowFullScreen(!GuiWindowFullScreen)<CR>
vmap <F11> <ESC>:call GuiWindowFullScreen(!GuiWindowFullScreen)<CR>
imap <F11> <ESC>:call GuiWindowFullScreen(!GuiWindowFullScreen)<CR>
