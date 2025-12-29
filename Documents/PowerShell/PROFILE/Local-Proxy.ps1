function Local-Proxy {
#.SYNOPSIS
# PowerShell wrapper for netsh for easy port forwarding.
# Arbitrary Version Number: v1.0.0
# Author: Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# Lazy wrapper for creating proxies via netsh.  Predominately
# utilized to forward traffic from the host OS to WSL instances.
#
# Parameters:
#   -List        Display curent proxy configurations
#   -Add         Add a new proxy        (requires -TargetIP and -TargetPort)
#   -Del         Remove existing proxy  (requires -LocalPort or -TargetPort)
#   -TargetIP    Destination proxy host
#   -TargetPort  Destination proxy port 
#   -LocalIP     Source proxy host      (default: 0.0.0.0)
#   -LocalPort   Source proxy port      (default: -TargetPort value)
#
# Example Usage:
#  ____________________________________________________
# |                                                    |
# |  # Show current proxies                            |
# |  PS> Local-Proxy -List                             |
# |                                                    |
# |  # Create a proxy to a WSL instance                |
# |  WSL> ip -br a                                     |
# |  PS>  Local-Proxy -Add <wsl_address> <target_port> |
# |____________________________________________________|
#
#.LINK
# TBD

    Param(
        [switch]$List,
        [switch]$Add,
        [switch]$Del,
        [string]$TargetIP,
        [int]$TargetPort,
        [string]$LocalIP  = '0.0.0.0',
        [int]$LocalPort   = $TargetPort,
        [switch]$Help
    )

    # Return Get-Help information
    if ($Help) { return (Get-Help Local-Proxy) }

    # Error Correction
    if (($Add) -and (!$TargetIP -and !$TargetPort))  { return (Write-Host "[-] This paramater requires -TargetIP and -TargetPort." -ForegroundColor Red) }
    if (($Del) -and (!$TargetPort -and !$LocalPort)) { return (Write-Host "[-] This paramater requires -LocalPort or -TargetPort." -ForegroundColor Red) }
    if (!$Add -and !$Del)                            { $List = $TRUE }

    # Main Functions wrapping netsh
    if ($List)    { 
        Write-Host "[!] Listing current port proxies..." -ForegroundColor Yellow
        $ProxyList = netsh interface portproxy show all
        if (($ProxyList -join "`n") -eq "") { Write-Host " o  N/A" }
        else                                { $ProxyList -join "`n" }
    }

    else {
        # Validate Elevated Privileges
        $User    = [Security.Principal.WindowsIdentity]::GetCurrent();
        $isAdmin = (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        if (!$isAdmin) { return (Write-Host '[-] This function requires elevated privileges.' -ForegroundColor Red) }

        if ($Add) {
            Write-Host "[!] Adding port proxy: '" -ForegroundColor Yellow -NoNewLine
            Write-Host "${LocalIP}:${LocalPort}" -ForegroundColor Green -NoNewLine
            Write-Host "' --> '" -ForegroundColor Yellow -NoNewLine
            Write-Host "${TargetIP}:${TargetPort}" -ForegroundColor Green -NoNewLine
            Write-Host "'..." -ForegroundColor Yellow
                
            $ProxyOutput = netsh interface portproxy add v4tov4 listenaddress=$LocalIP listenport=$LocalPort connectaddress=$TargetIP connectport=$TargetPort
            if (($ProxyOutput -join "`n") -like "*cannot find the file*") { return (Write-Host "[-] Error! ${ProxyOutput}" -ForegroundColor Red) }
            Write-Host " o  Done."
        }

        elseif ($Del) {
            Write-Host "[!] Removing port proxy: '" -ForegroundColor Yellow -NoNewLine
            Write-Host "${LocalIP}:${LocalPort}" -ForegroundColor Green -NoNewLine
            Write-Host "'..." -ForegroundColor Yellow

            $ProxyOutput = netsh interface portproxy del v4tov4 listenaddress=$LocalIP listenport=$LocalPort
            if (($ProxyOutput -join "`n") -like "*cannot find the file*") { return (Write-Host "[-] Error! ${ProxyOutput}" -ForegroundColor Red) }
            Write-Host " o  Done."
        }
    }
}
