function Local-Proxy {
#.SYNOPSIS
# PowerShell wrapper for netsh for easy port forwarding.
# Arbitrary Version Number: v1.0.1
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
#   -Clear       Remove ALL existing 0.0.0.0 proxies
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
# |  PS> $wsl_addr = wsl hostname -I                   |
# |  PS> Local-Proxy -Add $wsl_addr <target_port>      |
# |____________________________________________________|
#
#.LINK
# TBD

    Param(
        [switch]$List,
        [switch]$Add,
        [switch]$Remove,
        [switch]$ClearAll,

        [string]$TargetIP,
        [int]$TargetPort,
        [string]$LocalIP  = '0.0.0.0',
        [int]$LocalPort   = $TargetPort,

        [switch]$Help
    )

    # Return Get-Help information
    if ($Help) { return (Get-Help Local-Proxy) }

    # Error Correction
    if (!$Add -and !$Remove -and !$ClearAll)                      { $List = $TRUE }
    if (($Add) -and (!$TargetIP -and !$TargetPort))               { return (Write-Host "[!] Error! This paramater requires -TargetIP and -TargetPort." -ForegroundColor Red) }
    if (($Remove) -and (!$TargetPort -and !$LocalPort))           { return (Write-Host "[!] Error! This paramater requires -LocalPort or -TargetPort." -ForegroundColor Red) }
    if (($TargetIP) -and ($TargetIP -notmatch "\d+.\d+.\d+.\d+")) { return (Write-Host '[!] Error! Target IP has an invalid format.' -ForegroundColor Red) }
    if (($LocalIP) -and ($LocalIP -notmatch "\d+.\d+.\d+.\d+"))   { return (Write-Host '[!] Error! Local IP has an invalid format.' -ForegroundColor Red) }

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
        if (!$isAdmin) { return (Write-Host '[!] Error! This function requires elevated privileges.' -ForegroundColor Red) }

        if ($Add) {
            Write-Host "[!] Adding port proxy..." -ForegroundColor Yellow
            Write-Host " o  " -NoNewLine
            Write-Host "${LocalIP}:${LocalPort}" -ForegroundColor Green -NoNewLine
            Write-Host " --> " -NoNewLine
            Write-Host "${TargetIP}:${TargetPort}" -ForegroundColor Green
                
            $ProxyOutput = netsh interface portproxy add v4tov4 listenaddress=${LocalIP} listenport=${LocalPort} connectaddress=${TargetIP} connectport=${TargetPort}
            if (($ProxyOutput -join "`n") -like "*cannot find the file*") { return (Write-Host "[!] Error! ${ProxyOutput}" -ForegroundColor Red) }
            Write-Host " o  Done."
        }

        elseif ($Remove) {
            Write-Host "[!] Removing port proxy..." -ForegroundColor Yellow
            Write-Host " o  " -NoNewLine
            Write-Host "${LocalIP}:${LocalPort}" -ForegroundColor Green

            $ProxyOutput = netsh interface portproxy del v4tov4 listenaddress=${LocalIP} listenport=${LocalPort}
            if (($ProxyOutput -join "`n") -like "*cannot find the file*") { return (Write-Host "[!] Error! ${ProxyOutput}" -ForegroundColor Red) }
            Write-Host " o  Done."
        }

        elseif ($ClearAll) {
            Write-Host "[!] Removing ALL 0.0.0.0 proxies..." -ForegroundColor Yellow
            $LocalProxies = netsh interface portproxy show all
            $ProxyData    = $LocalProxies.Split(' ') | ? { $_ -match "^\d+" }
            $ProxiedPorts = $ProxyData | ? { $_ -notmatch '\d+.\d+.\d+.\d+' } | sort -Unique
            
            foreach ($ProxPort in $ProxiedPorts) {
                Write-Host " o  " -NoNewLine
                Write-Host "${LocalIP}:${ProxPort}" -ForegroundColor Green
                netsh interface portproxy del v4tov4 listenaddress=$LocalIP listenport=$ProxPort > $NULL
            }
            Write-Host " o  Done."
        }
    }
}
