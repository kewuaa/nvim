# base config
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch
bindkey -v

# completion config
autoload -U compinit; compinit
zstyle ':completion:*' completer _extensions _complete _approximate
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' file-list all
zstyle ':completion:*' file-sort change reverse
zstyle ':completion:*' complete-options true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# export environments
export LANG=en_US.UTF-8
export LANGUAGE=zh_CN:en_US
export EDITOR='nvim'
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export no_proxy=localhost,127.0.0.1,::1
export PP=/bin/fpc
export FPCDIR=/usr/lib/fpc/src
export FPCTARGET=linux
export FPCTARGETCPU=x86_64
export LAZARUSDIR=/usr/lib/lazarus
export PYVENV=~/Python/venvs

# do at the beginning
source $PYVENV/default/bin/activate
