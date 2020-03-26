#goto Scripts for general projects take path and use it here
#function gotoMoneyWeb {cd -Path "C:\Users\ynoa_mota\Documents\dev\money-admin-api"}
#function gotoApolo {cd -Path "C:\Users\ynoa_mota\Documents\dev\apolo"}
function add { git add .}
function status {git status}
function push {git push}
function pull {git pull}
function containers {docker ps -a}

Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
Import-Module oh-my-posh
Set-Theme Avit
