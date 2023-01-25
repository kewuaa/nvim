vim.cmd [[
function! s:load_clipboard()
    unlet g:loaded_clipboard_provider
    exe 'source ' . $VIMRUNTIME . '/autoload/provider/clipboard.vim'
endfunction

function! s:load_rplugin()
    unlet g:loaded_remote_plugins
    exe 'source ' . $VIMRUNTIME . '/plugin/rplugin.vim'
endfunction

function! s:load_later()
    call s:load_clipboard()
    call s:load_rplugin()
endfunction

augroup setup
    au!
    au CursorMoved * ++once call s:load_later()
augroup END
au! filetype qf,help,notify,DressingSelect,startuptime nnoremap <silent><buffer> q <cmd>q<CR>
]]
