function Invoke-Debloat {
#.SYNOPSIS
# WIP Debloating Script (mostly a lame wrapper)
#
#.DESCRIPTION
# Bruh.
#
#.LINK
# <TBD>


    Param(
        [switch]$Help
    )


    # Return Get-Help Information
    if ($Help) { return (Get-Help Invoke-Debloat) }

    # Validate Using Legacy PowerShell (AI debloat script does not work with PowerShell Core :sadge:)
    if ($PSVersionTable.PSEdition -eq 'Core') { return (Write-Host '[!] Error! This script does not support PowerShell Core (pwsh).' -ForegroundColor Red) }

    # Validate Elevated Privileges
    $User    = [Security.Principal.WindowsIdentity]::GetCurrent();
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (!$isAdmin) { return (Write-Host '[!] Error! This script requires elevated privileges.' -ForegroundColor Red) }


    # Internal Function(s) 
    function Harden-WindowsUpdates {
        <#
          Source: https://github.com/ChrisTitusTech/winutil/blob/main/functions/public/Invoke-WPFUpdatessecurity.ps1 
  
          1. Disables driver offering through Windows Update
          2. Disables Windows Update automatic restart
          3. Sets Windows Update to Semi-Annual Channel (Targeted)
          4. Defers feature updates for 365 days
          5. Defers quality updates for 4 days
        #>

        Write-Host " o  Disabling driver offering through Windows Update..."
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value 1
    
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -Type DWord -Value 0
    
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1
    
        Write-Host " o  Setting cumulative updates back by 1 year and security updates by 4 days..."
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "BranchReadinessLevel" -Type DWord -Value 20
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferFeatureUpdatesPeriodInDays" -Type DWord -Value 365
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferQualityUpdatesPeriodInDays" -Type DWord -Value 4
    
        Write-Host " o  Disabling Windows Update automatic restart..."
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0
    }
    

    ### Main ###

    # (1) Remove AI Garbage (via https://github.com/zoicware/RemoveWindowsAI)
    Write-Host '[!] Removing all garbage Windows AI features...' -ForegroundColor Yellow
    & ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/zoicware/RemoveWindowsAI/main/RemoveWindowsAi.ps1'))) -nonInteractive -AllOptions
    Write-Host "[!] Done." -ForegroundColor Yellow


    # (2) Debloat via WinUtil Tweaks (via https://github.com/ChrisTitusTech/winutil)
    Write-Host '[!] Debloating Windows with custom WinUtil configuration...' -ForegroundColor Yellow
    $WinUtilConfig = "${PSScriptRoot}/winutil_rice.json"
    if (!(Test-Path -LiteralPath $WinUtilConfig 2>$NULL)) { Write-Host '[!] Error! WinUtil configuration not found. Skipping...' -ForegroundColor Red }
    else { iex "& { $(irm christitus.com/win) } -Config $WinUtilConfig -Run" }
    Write-Host "[!] Done." -ForegroundColor Yellow


    # (3) Enhance Windows Update settings
    Write-Host '[!] Enhancing Windows Update scheduling for less invasive updates...' -ForegroundColor Yellow
    Harden-WindowsUpdates
    Write-Host "[!] Done." -ForegroundColor Yellow
}