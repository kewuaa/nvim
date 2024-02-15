function! asyncrun#runner#st#run(opts)
    if !executable('st')
        return asyncrun#utils#errmsg('st executable not find !')
    endif
    let cmds = []
    let cmds += ['cd ' . shellescape(getcwd()) ]
    let cmds += [a:opts.cmd]
    let cmds += ['echo ""']
    let cmds += ['read -n1 -rsp "press any key to continue ..."']
    let text = shellescape(join(cmds, ";"))
    let command = 'st -f "FiraCode Nerd Font:pixelsize=17.5:antialias=true:autohint=true" -e bash -c ' . text
    call system(command . ' &')
endfunction
