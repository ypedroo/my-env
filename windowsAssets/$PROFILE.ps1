function devf {Set-Location -Path "C:\users\ynoap\dev"}

#git functions
function add { git add .}
function st {git status}
function push {git push}
function pull {git pull}
function clone {git clone}
function co {git checkout $args}
function gcommit {git commit -a}
function newb {git checkout -b}
#docker functions
function dps {docker ps -a}
function dropImages{docker image rm $(docker image ls -aq)}
function startDB{docker-compose up -d db}


// TODO update path to relative paths

Import-Module 'C:\Users\ynoap\OneDrive\Docs\Documentos\WindowsPowerShell\Modules\oh-my-posh\2.0.399\oh-my-posh.psd1'
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
Import-Module oh-my-posh
Set-Theme robbyrussell

Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
