#!/bin/sh

symlink() {
  ln -sfv $(grealpath $1) "$HOME/$1"
}

echo "Creating symlinks ..."

pushd ./dots
symlink .aliases
symlink .tmux.conf
symlink .zshrc
symlink .zsh_plugins.txt
