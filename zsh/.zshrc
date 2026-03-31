autoload -U colors && colors

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cloud"
plugins=(git zsh-autosuggestions docker-compose gh aws macos)
source $ZSH/oh-my-zsh.sh

# vi mode
bindkey -v
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1
bindkey "^R" history-incremental-search-backward
stty -ixon -ixoff

# Prompt
RPROMPT='%{$fg[cyan]%}%n%{$reset_color%}'

# Sources
source "$HOME/.aliases"
source ~/.zsh/functions 2>/dev/null
source ~/.zsh/work 2>/dev/null

# Vi cursor shape
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() { zle -K viins; echo -ne "\e[5 q"; }
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

# Functions
todo() { cat ~/note:todo; }
gdf() { git diff "$@" | less; }
folder_sizes() { du -d 1 -h | gsort -hr; }
precmd() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history | tail -n 1)" >>! ~/Logs/zsh-history-$(date "+%Y-%m-%d").log
  fi
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Completions
fpath+=${ZDOTDIR:-~}/.zsh_functions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  for dump in ~/.zcompdump(N.mh+24); do compinit; done
  compinit -C
fi

# Syntax highlighting (must be near end)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# z
. /opt/homebrew/etc/profile.d/z.sh 2>/dev/null

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Edit command line with ctrl-x e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
