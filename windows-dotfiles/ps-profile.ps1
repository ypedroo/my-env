#Locaiton scripts
function devf {Set-Location -Path "C:\users\ynoap\dev"}
#Aliases
Set-Alias g git
Set-Alias vim neovim
function add {git add .}
function st {git status}
function push {git push}
function pull {git pull}
function diff {git diff}
function co {git checkout}
function new {git checkout -b}
function clone {git clone}
function gcommit {git commit -a}
#docker
function containers {docker ps -a}
#Imports
Import-Module oh-my-posh
Import-Module posh-git
#by being in onedrive it will alway be synced on windows
Set-PoshPrompt -Theme C:\Users\ynoap\OneDrive\Docs\oh-my-posh-main\themes\star.omp.json
Import-Module Terminal-Icons
Invoke-Expression (&starship init powershell)
