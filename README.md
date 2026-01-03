# winrice

> **Windows rice utilizing GlazeWM, Zebar, and Wezterm.**
> 
> _(Note: this is intended to use a minimal amount of third party applications to reduce configuration complexity & launch latency)_

<img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/b2a37970-3571-443f-a31d-447615994480" />

## Keybindings

All keybindings can be found/edited within `~/.glzr/glazewm/config.yaml` and `~/.wezterm.lua`.

**Primary keybindings include:**

| Keybind | Function |
| --- | --- |
| Alt + Enter | `Launch Terminal (wezterm).` |
| Alt + W | `Launch Web Browser (Brave).` |
| Alt + B | `Launch File Browser (Explorer).` |
| Alt + Q | `Kill currently focused window.` |
| Alt + F | `Fullscreen currently focused window.` |
| Alt + Arrow | `Change focus to different window.` |
| Alt + Num | `Change current workspace.` |
| Alt + Shift + Arrow | `Move currently focused window in arrow direction.` |
| Alt + Shift + Num | `Move currently focused window to specific Workspace.` |
| Alt + Shift + Space | `Toggle focus between centered and tiled.` |
| Alt + H / V | `Toggle tiling direction between horizontal and vertical.` |
| Alt + Shift + P | `Toggle terminal color scheme.` |
| Alt + Shift + O | `Toggle terminal opacity.` |

## Requirements

Eventually, I'll write some Windows debloating & auto-configuration scripts, but until now I'm just gonna leave it in the README.

```powershell
# Install required dependencies via winget
$Packages = @(
    'DEVCOM.JetBrainsMonoNerdFont', # One of the only NerdFonts you can easily install via winget
    'Microsoft.PowerShell', # PowerShell Core v7+ (cross platform)
    'wez.wezterm', # Cross platform terminal emulator
    'glzr.io.glazewm', # Window manager, also includes Zebar taskbar
    'Brave.Brave', # Default web browser
    'Fastfetch-cli.Fastfetch' # Not a real dependency, just classic rice
)
$Packages | % { winget install $_ --accept-package-agreements --accept-source-agreements }
```
```powershell
# Configure PowerShell-specific prerequisites
# (Note: this is within PowerShell Core / pwsh)
Install-Module Terminal-Icons -Force
New-Item $PROFILE -Force
```
```powershell
# Copy repo configuration files over (assuming in "winrice" directory)
$PwshFiles = "${PWD}/Documents/PowerShell"
$GlzrFiles = "${PWD}/.glzr"
$ZebarConf = "${PWD}/AppData"
$WezConfig = "${PWD}/.wezterm.lua
Copy-Item -LiteralPath $PwshFiles -Destination "${env:USERPROFILE}/Documents/." -Recurse -Force
Copy-Item -LiteralPath $GlzrFiles -Destination "${env:USERPROFILE}/." -Recurse -Force
Copy-Item -LiteralPath $ZebarConf -Destination "${env:USERPROFILE}/." -Recurse -Force
Copy-Item -LiteralPath $WezConfig -Destination "${env:USERPROFILE}/." -Force
```
```powershell
# Enable taskbar auto-hide for cleaner desktop experience
$RegPath  = 'HKCU:SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/StuckRects3'
$RegValue = (Get-ItemProperty -Path $RegPath).Settings
$RegValue[8] = 3 # Autohide Taskbar
Set-ItemProperty -Path $RegPath -Name Settings -Value $RegValue
Stop-Process -Name Explorer -Force
```
```powershell
# Set GlazeWM (& Zebar) to launch on startup:
$GlazePath = 'C:\Program Files\glzr.io\GlazeWM\glazewm.exe'
$RegRunKey = 'Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
Set-ItemProperty -Path $RegRunKey -Name 'GlazeWM Launcher' -Value $GlazePath
```

## Features

- Window Manager: [GlazeWM](https://github.com/glzr-io/glazewm)
- Taskbar: [Zebar](https://github.com/glzr-io/zebar)
- Terminal: [Wezterm](https://wezterm.org/)
  - Shell: [PowerShell Core](https://github.com/powershell/powershell)
  - Font: [JetBrainsMono Nerd Font](https://winget.ragerworks.com/package/DEVCOM.JetBrainsMonoNerdFont)
  - Terminal Color Scheme (Primary): [s3r0 modified](https://wezterm.org/colorschemes/s/index.html#s3r0-modified-terminalsexy)
  - Terminal Color Scheme (Secondary): [Dark+](https://wezterm.org/colorschemes/d/index.html#dark)
- Web Browser: [Brave Browser](https://brave.com/)

## Gallery

<img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/9735d810-356a-4ef1-9b84-9b442278eccf" />
<img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/0752cd42-7801-447d-b635-e5bda31f58a4" />
<img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/b2a37970-3571-443f-a31d-447615994480" />


