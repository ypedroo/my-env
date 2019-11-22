#!/bin/bash

./symlink.sh
./aptinstall.sh
./programs.sh
# Get all upgrades
sudo apt upgrade -y
# See our bash changes
source ~/.bashrc
# Fun hello
figlet "... Hello again bro !!!" | lolcat
