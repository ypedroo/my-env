#goto Scripts for general projects take path and use it here
function devFolder {cd -Path "C:\dev"}
function gotoDrop {cd -Path "C:\dev\drop-csharp"}
function gotoPlural {cd -Path "C:\dev\pluraL\pluralsight-exercises"}
function gotoCli {cd -Path "C:\Dev\remote-cli\"}
function gotoApiContracts {cd -Path "C:\Dev\contracts-api"}

#git context scripts
function add { git add .}
function status {git status}
function push {git push}
function pull {git pull}
function diff {git diff}
function co {git checkout}
function new {git checkout -b}
function containers {docker ps -a}
function jp {jupyter notebook}
#Modules
Import-Module posh-git
Import-Module oh-my-posh
#Theme
Set-Theme Powerlevel10k-Classic 
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
