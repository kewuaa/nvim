if has('win32') || has('win64') || has('win16') || has('win95')
    finish
endif

function! asyncrun#runner#external#run(opts)
    return asyncrun#runner#st#run(a:opts)
endfunction
