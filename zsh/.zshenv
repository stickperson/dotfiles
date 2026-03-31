. "$HOME/.cargo/env"

# Locale
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Editors
if hash nvim 2>/dev/null; then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
else
  export EDITOR=vim
fi

export RIPGREP_CONFIG_PATH=~/.ripgreprc
export NVM_DIR="$HOME/.nvm"

# PATH — deduplicate automatically
typeset -aU path
path=(
  /opt/homebrew/bin
  $HOME/.local/bin
  $HOME/.local/scripts
  $HOME/bin
  /Applications/Postgres.app/Contents/Versions/latest/bin
  /usr/local/go/bin
  /opt/homebrew/opt/openssl/bin
  $path
)
