#!/usr/bin/env bash

# Directory of this script
CONFIG_ROOT=$(cd `dirname $0` && pwd)

# Store location of config root
echo "CONFIG_ROOT='${CONFIG_ROOT}'" > ${HOME}/.config_root

# Determine OS
source ${CONFIG_ROOT}/determine_os

# Handle Windows
function _link() {
  if $OS_WINDOWS ; then
    cp -a $1 $2
    echo "Copied $1 -> $2"
  else
    if $OS_OSX ; then
      ln -sfh $1 $2
    else
      ln -sf $1 $2
    fi
    echo "Linked $1 -> $2"
  fi
}

# TODO: iterate over certain directories instead of adding a line per-file
# Link
_link ${CONFIG_ROOT}/aliases/.aliases ${HOME}/.aliases
_link ${CONFIG_ROOT}/git/.gitconfig ${HOME}/.gitconfig
_link ${CONFIG_ROOT}/postgres/.psqlrc ${HOME}/.psqlrc
_link ${CONFIG_ROOT}/tmux/.tmux.conf ${HOME}/.tmux.conf
_link ${CONFIG_ROOT}/vim/.vimrc ${HOME}/.vimrc
_link ${CONFIG_ROOT}/zsh/.zprofile ${HOME}/.zprofile
_link ${CONFIG_ROOT}/zsh/.zshrc ${HOME}/.zshrc
