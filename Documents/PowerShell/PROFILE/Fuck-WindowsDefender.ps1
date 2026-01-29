function Fuck-WindowsDefender {
#.SYNOPSIS
# Simple PowerShell script to temporarily disable Windows Defender features.
# Arbitrary Version Number: v1.0.0
# Author: Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# PowerShell script to intentionally disable Windows Defender -- utilized predominately
# for offensive tool development and testing; not intended for general users.  Modern
# Windows will re-enable most features (predominately Real-Time Protection) auto-magically
# after a period of time, hence why this script was written.
#
# Note: this script requires elevated privileges to run.
#
# Parameters:
#   -Undo  -->  Re-enable previously disabled Windows Defender features.
#   -Help  -->  Return help information.
#
#.LINK
# TBD

    Param(
        [switch]$Undo,
        [switch]$Help
    )

    # Return Get-Help Information
    if ($Help) { return (Get-Help Fuck-WindowsDefender) }

    # Validate Elevated Privileges
    $User    = [Security.Principal.WindowsIdentity]::GetCurrent();
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (!$isAdmin) { return (Write-Host '[!] Error! This script requires elevated privileges.' -ForegroundColor Red) }
    
    if (!$Undo) {
        # Disable scanning of all downloaded files and attachments
        Set-MpPreference -DisableIOAVProtection $TRUE

        # Disable Real-Time Monitoring
        Set-MpPreference -DisableRealtimeMonitoring $TRUE
        
        # Disable Script Scanning (predominately AMSI)
        Set-MpPreference -DisableScriptScanning $TRUE

        return (Write-Host '[!] Windows Defender has been fucked.' -ForegroundColor Yellow)
    }
    else {
        # Re-enable Windows Defender features
        Set-MpPreference -DisableIOAVProtection $FALSE -DisableRealtimeMonitoring $FALSE -DisableScriptscanning $FALSE
        return (Write-Host '[!] Windows Defender has been (un)fucked.' -ForegroundColor Yellow)
    }
}
