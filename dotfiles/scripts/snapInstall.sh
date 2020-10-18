#!/bin/bash

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo snap install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install postman
install spotify
install discord
install slack --classic
install webstorm --classic
install code --classic
install code-insiders --classic
install telegram-desktop
install gitkraken --classic
install robo3t-snap
install bitwarden
install dbeaver-ce\