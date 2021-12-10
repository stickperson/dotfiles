autoload -U colors && colors
set -o vi
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export EDITOR=vim
set term=xterm-256color

# Can't remember why this is here.
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
stty -ixon -ixoff

# Work-specific stuff
source ~/.zsh/work 2>/dev/null

ZSH_THEME="cloud"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
plugins=(git zsh-autosuggestions docker docker-compose)

# I guess zsh setup looked at my current PATH to generate the following line.
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:$PATH"
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

curl_timing(){
    curl -w "\n
    time_namelookup:  %{time_namelookup}
       time_connect:  %{time_connect}
    time_appconnect:  %{time_appconnect}
   time_pretransfer:  %{time_pretransfer}
      time_redirect:  %{time_redirect}
 time_starttransfer:  %{time_starttransfer}
                    ----------
         time_total:  %{time_total}\n" $@
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

export PATH="/usr/local/sbin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

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

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


if command -v thefuck 1>/dev/null 2>&1; then
    eval $(thefuck --alias)
fi
export PATH="/usr/local/opt/openssl/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
if command -v pyenv-virtualenv 1>/dev/null 2>&1; then
  eval "$(pyenv virtualenv-init -)"
fi
fpath+=${ZDOTDIR:-~}/.zsh_functions
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
unset PYENV_VERSION
