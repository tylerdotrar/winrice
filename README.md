# winrice

> **Windows rice utilizing GlazeWM, Zebar, and Wezterm.**
> 
> _(Note: this is intended to use a minimal amount of third party applications to reduce configuration complexity & launch latency)_


<img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/634dc9d6-7b73-41af-aae3-2954dad5436d" />


## Keybindings

**Primary keybindings include:**

| Keybind | Function |
| --- | --- |
| Alt + Enter | `Launch Terminal (default: wezterm).` |
| Alt + W | `Launch Web Browser (default: Brave Browser).` |
| Alt + B | `Launch File Browser (default: Windows Explorer).` |
| Alt + Q | `Kill currently focused window.` |
| Alt + F | `Fullscreen currently focused window.` |
| Alt + Arrow | `Change focus to different window.` |
| Alt + Num | `Change current workspace.` |
| Alt + Shift + Arrow | `Move currently focused window in arrow direction.` |
| Alt + Shift + Num | `Move currently focused window to specific Workspace.` |
| Alt + Shift + Space | `Toggle focus between centered and tiled.` |
| Alt + H / V | `Toggle tiling direction between horizontal and vertical.` |
| Alt + U / P | `Resize currently focused window left/right.` |
| Alt + I / O | `Resize currently focused window up/down.` |
| Alt + Shift + P | `Toggle terminal color scheme.` |
| Alt + Shift + O | `Toggle terminal opacity.` |
| Alt + Shift + R | `Refresh GlazeWM configuration.` |
| Alt + Shift + E | `Exit GlazeWM and Zebar.` |

_Note: All other keybindings can be found/edited within `~/.glzr/glazewm/config.yaml` and `~/.wezterm.lua`._

## Requirements

Eventually, I'll write some Windows debloating & auto-configuration scripts, but until now I'm just gonna leave it in the README.

```powershell
# Install required dependencies via winget
$Packages = @(
    'glzr-io.glazewm',              # Window manager (also includes Zebar taskbar)
    'DEVCOM.JetBrainsMonoNerdFont', # One of the only NerdFonts you can easily install via winget
    'Microsoft.PowerShell',         # PowerShell Core v7+ (cross platform)
    'wez.wezterm',                  # Cross platform terminal emulator
    'Brave.Brave',                  # Default web browser
    'Fastfetch-cli.Fastfetch'       # Not a real dependency, just classic rice
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
# Enable taskbar auto-hide for cleaner desktop experience
$RegPath     = 'HKCU:SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/StuckRects3'
$RegValue    = (Get-ItemProperty -Path $RegPath).Settings
$RegValue[8] = 3 # Autohide Taskbar (= 2 to Show Taskbar)
Set-ItemProperty -Path $RegPath -Name Settings -Value $RegValue
Stop-Process -Name Explorer -Force
```
```powershell
# Copy repo configuration files over (assuming in "winrice" directory)
$PwshFiles = "${PWD}/Documents/PowerShell"
$GlzrFiles = "${PWD}/.glzr"
$ZebarConf = "${PWD}/AppData"
$WezConfig = "${PWD}/.wezterm.lua"
Copy-Item -LiteralPath $PwshFiles -Destination "${env:USERPROFILE}/Documents/." -Recurse -Force
Copy-Item -LiteralPath $GlzrFiles -Destination "${env:USERPROFILE}/." -Recurse -Force
Copy-Item -LiteralPath $ZebarConf -Destination "${env:USERPROFILE}/." -Recurse -Force
Copy-Item -LiteralPath $WezConfig -Destination "${env:USERPROFILE}/." -Force
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

### Terminal Color Schemes

> **Left** : `s3r0 modified (terminal.sexy)` - Default Color Scheme, Default Opacity
> 
> **Right** : `Default (dark) (terminal.sexy)` - Alternate Color Scheme (`Alt + Shift + P`), Alternate Opacity (`Alt + Shift + O`)
>
>> Settings modified within --> `~/.wezterm.lua`
> 
> <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/cab8bd74-68f6-48f1-aecb-01cdf6d1009b" />

### Wallpapers

> `gruvbox_forest_4k.png` : 4K upscaled inner forest with rustic gruvbox theme.
> 
> <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/49725b1a-7587-46c2-b081-2e6370c9bdc2" />
---
> `forest_faded.png` : Misty forest with yellow-green gruvbox color grading.
> 
> <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/12a1213e-d45d-4027-baa7-a7cdc85e5bdd" />
---
> `firewatch_flipped_left.png` : 5120x1440p Firewatch themed image split in half for dual monitor setups.
>
> <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/6603ad98-4944-4b5b-b315-576726c53956" />

### Zebar Configuration

> Example settings of **blaiyz**'s highly configurable [neosoft-zebar](https://github.com/blaiyz/neosoft-zebar) Zebar taskbar.
>> Settings modified within --> `%AppData%\zebar\downloads\blaiyz.neosoft-zebar@1.2.7\config.json`
> 
> <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/8f0259ab-fc5a-4f46-b10e-f9518caf152d" />
