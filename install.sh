#!/usr/bin/env bash
set -e

if [[ "${1}" != "-i" ]]; then
  echo "Installing packages and setting some defaults."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &>/dev/null; then
      echo "Must install homebrew first"
      return 1
    fi
    # shellcheck disable=SC2046
    brew install $(cat brew.txt)

    # shellcheck disable=SC2046
    brew install --cask $(cat brew_casks.txt)

    # Bluetooth audio settings
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
    defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
    defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80
    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show full POSIX path in Finder title bar
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    # Change screenshot location
    defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
    # Enable key repeat (instead of press-and-hold for special characters)
    defaults write -g ApplePressAndHoldEnabled -bool false

    # Set fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

  else
    echo "Packages are only included for OSX"
  fi
fi

if ! command -v stow &>/dev/null; then
  echo "stow must be installed"
  return 1
fi

stow aliases git nvim psql ripgrep tmux wezterm zsh
