# zmodload zsh/zprof
autoload -U colors && colors
set -o vi
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
set term=xterm-256color

# Can't remember why this is here.
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
stty -ixon -ixoff

# Functions etc
source ~/.zsh/functions 2>/dev/null

# Work-specific stuff
source ~/.zsh/work 2>/dev/null

ZSH_THEME="cloud"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
plugins=(git zsh-autosuggestions docker docker-compose gh aws macos)

typeset -aU path
path=(/Applications/Postgres.app/Contents/Versions/latest/bin $path /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/local/go/bin /usr/local/sbin $HOME/bin $HOME/.local/bin /opt/homebrew/opt/openssl/bin)
# export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/usr/local/sbin:/opt/homebrew/opt/openssl/bin"

source $ZSH/oh-my-zsh.sh

source "$HOME/.aliases"

# vim bindings
bindkey -v
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1

bindkey "^R" history-incremental-search-backward

RPROMPT='%{$fg[cyan]%}%n%{$reset_color%}'

todo()
{
    cat ~/note:todo;
}

gdf()
{
    git diff "$@" | less; 
}

# Need to brew install coreutils on mac for gsort
# Usage: folder_sizes ./*
folder_sizes()
{
    du -d 1 -h | gsort -hr
}

precmd() {
eval 'if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history | tail -n 1)" >>! ~/Logs/zsh-history-$(date "+%Y-%m-%d").log; fi'
}

# Fuzzy recursive search. For some reason this only works if added at the bottom.
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# End vi cursor stuff

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null


fpath+=${ZDOTDIR:-~}/.zsh_functions
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export RIPGREP_CONFIG_PATH=~/.ripgreprc

# completions. brew install zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  for dump in ~/.zcompdump(N.mh+24); do
    compinit
  done
  compinit -C
fi

# Better cd https://github.com/rupa/z
. /opt/homebrew/etc/profile.d/z.sh 2>/dev/null


if hash nvim 2>/dev/null; then
  export EDITOR=nvim

  # Use nvim as manpager `:h Man`
  export MANPAGER='nvim +Man!'
else
  export EDITOR=vim
fi

# zprof

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
