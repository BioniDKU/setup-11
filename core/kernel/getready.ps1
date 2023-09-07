# This module prepares the system for the next restart to download mode, and then WU mode/normal mode

function Set-AutoIDKUValue($type,$value,$data) {
	if ($type -like "d") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data -Type DWord -Force
	} elseif ($type -like "str") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data
	} elseif ($type -like "app") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps" -Name $value -Value $data -Type DWord -Force
	}
}

Show-WindowTitle noclose
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

Write-Host " "
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Hooking the script to the startup sequence"
Copy-Item "$coredir\ambient\FFPlay.exe" -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru"
Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value 1 -Type DWord -Force
& $coredir\kernel\hikaru.ps1

switch ($true) {
	{$keepedgechromium} {Set-AutoIDKUValue d "EdgeNoMercy" 1}
	#{$keepsearch} {Set-AutoIDKUValue d "SearchNoMercy" 1}
	{$explorerstartfldr} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Explorer to open on This PC" -n; Write-Host " (will take effect next time Explorer starts)"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 1 -Type DWord -Force
	}
	{$remotesw -eq 1} {Set-AutoIDKUValue d "RunningThisRemotely" 1} else {Set-AutoIDKUValue d "RunningThisRemotely" 0}
}

$windowsupdatesw = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").WUmodeSwitch
if ($windowsupdatesw -eq 1) {
	# Take control over Windows Update so it doesn't do stupid, unless if it's Home.
	if ($edition -notlike "Core") {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Taking control over Windows Update" -n; Write-Host " (so it doesn't do stupid)" -ForegroundColor White
		$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
		$wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
		if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force
		$msrtdir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MRT)
		if ($msrtdir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name 'MRT'}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name 'DontOfferThroughWUAU' -Value 1 -Type DWord -Force
		$noau = Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
		if ($noau -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AU}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AllowAutoUpdate -Value 5 -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AUOptions -Value 2 -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1 -Type DWord -Force
	}
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WUmode" -Value 1 -Type DWord -Force
} else {Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "WUmode" -Value 0 -Type DWord -Force}


Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling UAC and applying some tweaks to the system"
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 0 -Force
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Type String -Value '0'
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -Value 0 -Type DWord -Force
if ($build -ge 22621) {
	Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'EnableSnapBar' -Value 0 -Type DWord -Force
}
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DontUsePowerShellOnWinX' -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -Name "DisableStartupSound" -Value 1 -Type DWord -Force
Set-AutoIDKUValue d "HikaruMode" 4
Set-AutoIDKUValue d "ChangesMade" 1

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Restarting your device in 5 seconds... The script will start doing its job after the restart."
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder"
Start-Sleep -Seconds 1

$setwallpaper = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").SetWallpaper
if ($setwallpaper -eq 1) {
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Wallpapers") -eq $false) {New-Item -Path "$env:SYSTEMDRIVE\Bionic" -Name "Wallpapers" -ItemType directory}
	Copy-Item $workdir\utils\YuumeiDKUL.jpg -Destination "$env:SYSTEMDRIVE\Bionic\YuumeiDKUL.jpg"
	Copy-Item $workdir\utils\YuumeiDKUD.jpg -Destination "$env:SYSTEMDRIVE\Bionic\YuumeiDKUD.jpg"
	& $workdir\modules\desktop\wallpaper.ps1
}


Start-Sleep -Seconds 2
shutdown -r -t 0
Start-Sleep -Seconds 30
exit
