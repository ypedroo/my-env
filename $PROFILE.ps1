#goto Scripts for general projects take path and use it here
#function gotoMoneyWeb {cd -Path "C:\Users\ynoa_mota\Documents\dev\money-admin-api"}
#function gotoApolo {cd -Path "C:\Users\ynoa_mota\Documents\dev\apolo"}

function devFolder {cd -Path "C:\dev"}

#git context scripts
function add { git add .}
function git st {git status}
function push {git push}
function pull {pull --rebase origin}
function git co {git checkout}
function git new {git checkout -b}
function containers {docker ps -a}

#Modules
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
Import-Module oh-my-posh
#Theme
Set-Theme Robbyrussell
