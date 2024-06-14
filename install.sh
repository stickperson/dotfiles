#!/usr/bin/env bash
set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Must install homebrew first"
  fi
  # shellcheck disable=SC2046
  brew install $(cat brew.txt)

  # Bluetooth audio settings
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
  defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
  defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
  defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
  defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
  defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get dist-upgrade -y
  sudo apt-get install -y ack
  # Add in mounting stuff
  # sudo vim /etc/fstab //192.168.0.1/share /home/pi/SHARE cifs username=joe,password=<pass>,vers=1.0 0 0
fi
