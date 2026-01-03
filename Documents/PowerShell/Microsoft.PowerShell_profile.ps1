# Import visually pleasing icons (requires NerdFonts)
Import-Module Terminal-Icons

# Load any PS1 file in designated folder into Session
$ProfileDir = "${env:USERPROFILE}/Documents/PowerShell/PROFILE"
(Get-ChildItem $ProfileDir -Filter '*.ps1').Fullname) | % { . $_ }

# General Quality of Life (QoL) Features
function Get-PublicIP { Invoke-RestMethod https://ifconfig.me/ip }
function fetch        { fastfetch -l 'Windows' }
