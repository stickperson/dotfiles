set -o vi
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export EDITOR=vim
set term=xterm-256color

# Can't remember why this is here.
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
stty -ixon -ixoff

# For docker-compose completion
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit && compinit -i

# Work-specific stuff
if [ -f ~/.zsh/work ]; then
    source ~/.zsh/work
fi

# Set name of the theme to load.
ZSH_THEME="cloud"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
plugins=(git zsh-autosuggestions)

# I guess zsh setup looked at my current PATH to generate the following line.
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh

source "$HOME/.aliases"

# vim bindings
bindkey -v
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1

bindkey "^R" history-incremental-search-backward

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
    du -hs "$@" | gsort -hr
}

precmd() {
eval 'if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history | tail -n 1)" >>! ~/Logs/zsh-history-$(date "+%Y-%m-%d").log; fi'
}

export PATH="/usr/local/sbin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/10/bin:$PATH"

# Fuzzy recursive search. For some reason this only works if added at the bottom.
if [ -f ~/.fzf.zsh ]; then
    #source ~/.fzf.zsh
fi
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
