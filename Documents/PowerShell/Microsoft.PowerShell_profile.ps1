# Import visually pleasing icons (requires NerdFonts)
Import-Module Terminal-Icons

# Load any PS1 file in designated folder into Session
# Note: may need to adjust Execution Policy.
$ProfileDir = "${env:USERPROFILE}/Documents/PowerShell/PROFILE"
(Get-ChildItem $ProfileDir -Filter '*.ps1').Fullname | % { . $_ }

# Small custom functions
# - Manually insert functions here...
# - ... or within the above $ProfileDir directory.

# function Example () { echo 'bruh' }

# General Quality of Life (QoL) Features
function Get-PublicIP { Invoke-RestMethod https://ifconfig.me/ip }
function fetch        { fastfetch -l 'Windows' }
New-Alias -Name 'Open-SoundSettings' -Value 'mmsys.cpl' -Description 'Shortcut launcher for the Windows Sound control panel.'
New-Alias -Name 'Open-VolumeMixer' -Value 'sndvol.exe' -Description 'Shortcut launcher for the Windows Volume Mixer.'
New-Alias -Name 'Open-NetworkAdapters' -Value 'ncpa.cpl' -Description 'Shortcut launcher for Windows Network Adapter settings.'
New-Alias -Name 'Open-DisplaySettings' -Value 'desk.cpl' -Description 'Shortcut launcher for Windows Display settings.'
New-Alias -Name 'Open-PowerOptions' -Value 'powercfg.cpl' -Description 'Shortcut launcher for power plans.'
New-Alias -Name 'Open-Firewall' -Value 'firewall.cpl' -Description 'Shortcut launcher for Windows Defender Firewall.'
