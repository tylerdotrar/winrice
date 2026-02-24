# Toggle Custom Windows Color Theme
Invoke-Expression ${env:LOCALAPPDATA}/Microsoft/Windows/Themes/GruvboxGang.theme
while (!(Get-Process -Name SystemSettings 2>$NULL)) { continue }
Get-Process -Name SystemSettings | Stop-Process -Force
