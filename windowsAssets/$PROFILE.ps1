#goto Scripts for general projects take path and use it here
#function gotoMoneyWeb {cd -Path "C:\Users\ynoa_mota\Documents\dev\money-admin-api"}
function qwkin {Set-Location -Path "C:\users\ynoap\dev\qwkin-api"}
function devf {Set-Location -Path "C:\users\ynoap\dev"}

#git functions
function add { git add .}
function status {git status}
function push {git push}
function pull {git pull}
function clone {git clone}
#docker functions
function dps {docker ps -a}
function dropImages{docker image rm $(docker-image ls -aq)}
function startDB{docker-compose up -d db}


Import-Module 'C:\Users\ynoap\OneDrive\Docs\Documentos\WindowsPowerShell\Modules\oh-my-posh\2.0.399\oh-my-posh.psd1'
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
Import-Module oh-my-posh
Set-Theme robbyrussell

Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
