#!/bin/bash

sudo apt update && sudo apt full-upgrade -y

./scripts/aptinstall.sh
./scripts/snapinstall.sh


# Run all scripts in programs/
for f in apps/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

figlet "... Hello again Master Pedro !!!" | lolcat
