vim.cmd [[
function! s:load_clipboard()
    unlet g:loaded_clipboard_provider
    exe 'source ' . $VIMRUNTIME . '/autoload/provider/clipboard.vim'
endfunction

augroup setup
    au!
    au CursorMoved * ++once call s:load_clipboard()
augroup END
au! filetype qf,lspsagaoutline,OverseerList,OverseerForm,notify,DressingSelect,startuptime nnoremap <silent><buffer> q <cmd>q<CR>
]]
