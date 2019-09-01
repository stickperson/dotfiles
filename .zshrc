set -o vi
# Path to your oh-my-zsh installation.
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export ZSH=$HOME/.oh-my-zsh
export EDITOR=vim
set term=xterm-256color

# Go stuff
export GOROOT=$HOME/go

# For docker-compose completion
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit && compinit -i

if [ -f ~/.zsh/work ]; then
    source ~/.zsh/work
fi

if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi



stty -ixon -ixoff
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export PROJECT_HOME=$HOME/Devel
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_NDK=/usr/local/Cellar/android-ndk/r10e
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi



# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloud"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
plugins=(git zsh-autosuggestions)

# User configuration

# I guess zsh setup looked at my current PATH to generate the following line.
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:$GOROOT/bin
export PATH="$PATH:/anaconda3/bin"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# vim bindings
bindkey -v
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1

# Aliases
alias acl='ack'
alias bim='vim'
alias c='clear'
alias cll='clear & ls -lah'
alias curlJson='curl -H "Content-Type: application/json" -X POST'
alias dev_latest='git checkout dev && git pull origin dev && remove_branches'
alias dl='cd ~/Downloads'
alias doc='cd ~/Documents'
# gd alias is for `git diff`
alias ggd='cd ~/Google\ Drive'
alias master_latest='git checkout master && git pull origin master && remove_branches'
alias htop='sudo htop'
alias l='less'
alias ll='ls -lah'
alias opem='open'
alias pro='cd ~/projects/'
alias remove_branches='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'
alias sa='source activate'
alias sd='source deactivate'
alias src='source ~/.zshrc'
alias td='vim ~/note:todo'
alias tmx='tmux new -s'
alias tmxa='tmux attach-session -t'
alias tmxl='tmux list-sessions'
alias tmxk='tmux kill-session -t'
alias vi='vim'
alias wrc='vim ~/.zsh/work'
alias zrc='vim ~/.zshrc'

# Docker aliases
alias de='docker exec'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dr='docker run'
alias drmi='docker rmi'
# remove stopped containers
alias drms='docker rm $(docker ps -aq)'

# K8s
alias kaf='kubectl apply -f '
alias kd='kubectl get deployment --all-namespaces'
alias kdf='kubectl delete -f '
alias kp='kubectl get pods --all-namespaces'
alias ks='kubectl get svc '
alias ksa='kubectl get svc --all-namespaces'

# Google calendar
alias gca='gcalcli add --calendar "joe.meissler@gmail.com" '
alias gcw='gcalcli calw 1'

# Search history
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

HOSTNAME=$(hostname)
PROMPT='%{$fg_bold[cyan]%}$ZSH_THEME_CLOUD_PREFIX  %{$fg[green]%}%c %{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

eval $(thefuck --alias)

# Fuzzy recursive search. For some reason this only works if added at the bottom.
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
