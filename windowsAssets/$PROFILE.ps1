function devf {Set-Location -Path "C:\users\ynoap\dev"}
#git context scripts
Set-Alias grep findstr
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
#ides
function rider {rider64.exe}

Import-Module oh-my-posh
Import-Module posh-git
Set-PoshPrompt -Theme C:\Users\ynoap\OneDrive\Docs\oh-my-posh-main\themes\star.omp.json
Invoke-Expression (&starship init powershell)
