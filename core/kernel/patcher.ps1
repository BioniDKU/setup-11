function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "OS modification mode" -ForegroundColor Magenta -BackgroundColor Gray
	Write-Host " "
}
function Grant-Ownership($item) {
	takeown /f $item /r
	icacls $item /grant Administrators:F /t
}
$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | OS modification mode"
Show-Branding
$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
#$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Performing critical modifications"

Write-Host -ForegroundColor Cyan "Installing Explorer Patcher..."
Start-Process $workdir\dls\ep_setup.exe -Wait
Start-Sleep -Seconds 5
Stop-Process -Name explorer

switch ($build) {
	{$_ -ge 22621} {
		Write-Host -ForegroundColor Cyan "Setting ViVeTool IDs..."
		Start-Process $workdir\utils\ViVeTool\ViVeTool.exe -Wait -NoNewWindow -ArgumentList "/disable /id:26008830,37634385,39145991,36354489,36302090,41655236"
	}
	{$_ -eq 22000} {
		Write-Host -ForegroundColor Cyan "Swapping Theme files..."
		Grant-Ownership $env:SYSTEMDRIVE\Windows\Resources
		Rename-Item -Path $env:SYSTEMDRIVE\Windows\Resources\Themes\aero\aero.msstyles -NewName aura.msstyles -Force
		Copy-Item -Path $workdir\utils\aero.msstyles -Destination $env:SYSTEMDRIVE\Windows\Resources\Themes\aero\aero.msstyles -Force
	}
}
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
shutdown -r -t 0
