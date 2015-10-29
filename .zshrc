# Path to your oh-my-zsh installation.
export ZSH=/Users/joe/.oh-my-zsh
set term=xterm-256color

# Source external files 
if [ -f ~/.zsh/mongo ]; then
    source ~/.zsh/mongo
fi

if [ -f ~/.zsh/work ]; then
    source ~/.zsh/work
fi

stty -ixon -ixoff
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh


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
alias bim='vim'
alias c='clear'
alias dps='docker ps -a'
alias de='docker exec -it'
alias dl='docker logs -f'
alias ez='vim ~/.zshrc'
alias htop='sudo htop'
alias l='less'
alias ll='ls -la'
alias src='source ~/.zshrc'
alias tmx='tmux new -s'
alias tmxa='tmux attach-session -t'
alias tmxl='tmux list-sessions'
alias tmxk='tmux kill-session -t'
alias vi='vim'

# Google calendar
alias gcala='gcalcli add --calendar "joe.meissler@gmail.com" '
alias gcw='gcalcli calw 1'

# Search history
bindkey "^R" history-incremental-search-backward

dec(){
    command docker exec -it $1 /bin/bash;
}

dps(){
    command docker ps | perl -ne '@cols = split /\s{2,}/, $_; printf "$cols[0]     $cols[6]\n"';
}

gdf()
{
    git diff "$@" | less; 
}
