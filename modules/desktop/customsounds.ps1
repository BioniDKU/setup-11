$workdir = "$PSScriptRoot\..\.."

$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | Custom sound installer module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Custom sound installer module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Show-Branding

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Installing Custom system sounds"

function Remove-SystemFile($item) {
	takeown /f $item /r
	icacls $item /grant Administrators:F /t
	Remove-Item -Path $item -Force -Recurse -ErrorAction SilentlyContinue
}

Write-Host -ForegroundColor Cyan "Removing old system sounds with 5 passes, starting in 3 seconds"
Start-Sleep -Seconds 3
for ($count = 1; $count -le 5; $count++) {
	Remove-SystemFile $env:SYSTEMDRIVE\Windows\Media
	if ($count -lt 5) {Write-Host -ForegroundColor Cyan "Pass $count/5 complete, next in 3 seconds" -n; Write-Host -ForegroundColor White " (you may see errors and that's normal)"} else {Write-Host -ForegroundColor Cyan "Pass 5/5 complete, now placing new sounds in 3 seconds"}
	Start-Sleep -Seconds 3
}

$newmedia = (Test-Path -Path "$env:SYSTEMDRIVE\Windows\Media")
if ($newmedia -eq $false) {New-Item -Path "$env:SYSTEMDRIVE\Windows" -Name "Media" -ItemType directory}
Expand-Archive -Path $workdir\utils\Media8.zip -DestinationPath $env:SYSTEMDRIVE\Windows\Media
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Custom system sounds have been installed"
Start-Sleep -Seconds 3
