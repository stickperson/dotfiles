#!/bin/sh

# Is this on my raspberry pi or not?
if test -f /etc/os-release; then
  symlink() {
    ln -sfv $(realpath $1) "$HOME/$1"
  }
else
  symlink() {
    ln -sfv $(grealpath $1) "$HOME/$1"
  }
fi

echo "Creating symlinks ..."

pushd ./dots
symlink .aliases
symlink .tmux.conf
symlink .vimrc
symlink .zshrc
