# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
set term=xterm-256color

# For docker-compose completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

if [ -f ~/.zsh/work ]; then
    source ~/.zsh/work
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

stty -ixon -ixoff
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_NDK=/usr/local/Cellar/android-ndk/r10e


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
plugins=(git)

# User configuration

# I guess zsh setup looked at my current PATH to generate the following line.
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:/usr/local/go/bin

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
alias master_latest='git checkout master && git pull origin master && remove_branches'
alias htop='sudo htop'
alias l='less'
alias ll='ls -lah'
alias pro='cd ~/projects/'
alias remove_branches='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'
alias src='source ~/.zshrc'
alias td='vim ~/note:todo'
alias tmx='tmux new -s'
alias tmxa='tmux attach-session -t'
alias tmxl='tmux list-sessions'
alias tmxk='tmux kill-session -t'
alias vi='vim'
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

# Google calendar
alias gca='gcalcli add --calendar "joe.meissler@gmail.com" '
alias gcw='gcalcli calw 1'

# Search history
bindkey "^R" history-incremental-search-backward

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
    du -hs "$@" | gsort -hr
}

wrc()
{
    vim ~/.zsh/work
}

precmd() {
eval 'if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history | tail -n 1)" >>! ~/Logs/zsh-history-$(date "+%Y-%m-%d").log; fi'
}

PATH="/Users/joe/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/joe/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/joe/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/joe/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/joe/perl5"; export PERL_MM_OPT;
export PATH="/usr/local/sbin:$PATH"
HOSTNAME=$(hostname)
PROMPT='%{$fg_bold[cyan]%}$ZSH_THEME_CLOUD_PREFIX  $HOST%{$fg_bold[green]%}%p %{$fg[green]%}%c %{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
