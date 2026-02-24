function Install-Packages {
#.SYNOPSIS
# Installer of some commonly required packages.
# Arbitrary Version Number: v0.9.9
# Author: Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# <TBD>
# 
#.LINK
# <TBD>

    Param(
        [switch]$Help
    )

    # Return Get-Help Information
    if ($Help) { return (Get-Help Install-Packages) }

    # Winget Packages
    $Packages = @(
        # Baseline
        'Microsoft.PowerShell',
        'Git.Git',
        'Neovim.Neovim',
        'Brave.Brave',
        'DEVCOM.JetBrainsMonoNerdFont',
    
        # Rice
        'glzr-io.glazewm',
        'wez.wezterm',
        'Fastfetch-cli.Fastfetch',
    
        # Entertainment (need to cleanup startup properties tho)
        'Discord.Discord',
        'Valve.Steam',
        'Spotify.Spotify',
    
        # Development
        'Python.Python.3.14',
        'Rustlang.Rustup',
        'Golang.Go',
        'OpenJS.NodeJS.LTS',
        'BrechtSanders.WinLibs.POSIX.UCRT.LLVM',
        'Microsoft.VisualStudio.Community',
        'Microsoft.VisualStudio.BuildTools',
        'Microsoft.Dotnet.SDK.10'
    )
    $Packages | % { winget install --id $_ --accept-package-agreements --accept-source-agreements --disable-interactivity }
    
    # Fix missing "link.exe" when compiling Rust projects
    rustup toolchain install stable-x86_64-pc-windows-gnu
    rustup default stable-x86_64-pc-windows-gnu
    
    # Rust Packages
    $Packages = @(
        'ripgrep',
        'tree-sitter-cli',
        'bottom',
        'bat'
    )
    $Packages | % { cargo install $_ }
}
