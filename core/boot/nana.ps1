# Nana, the BioniDKU/YuumeiDKU bootloader - (c) Bionic Butter

function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "Starting up..." -ForegroundColor Magenta -BackgroundColor Gray
	Write-Host " "
}
Show-Branding

# Set working directory first before anything else
$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"

# Script build number
$releasetype = "Beta Release"
$releaseid = "23010.100_beta4a"
$releaseidex = "23010.100_b4a.oseprod_betarel.230710-1126"

# Is the bootstrap process already completed?
$booted = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).BootStrapped
$remote = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).RunningThisRemotely
if ($booted -eq 1) {
	# Play the script startup sound
	Show-Branding
	if ($remote -eq 1) {
		Start-Process powershell -Wait -ArgumentList "-Command $workdir\modules\lib\WaitRemote.ps1"
	}
	Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	exit
}

# Create registry folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU | Out-Null
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "BootStrapped" -Value 0 -Type DWord -Force
}

# Find the build number, UBR of the system
# This script only works with General Availability builds of Windows 11, which are currently 22000 and 22621. Modify the lines below for running on any other builds is STRONGLY DISENCOURAGED, as velocity IDs are different across builds, thus may make modifications fail.
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Checking your PC"
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$buildsp = 22000,22621
switch ($build) {
	{$buildsp.Contains($_)} {
		Write-Host "Supported stable build of Windows 11 detected" -ForegroundColor Green -BackgroundColor DarkGray
	}
	default {
		Write-Host "You're not running a supported build of Windows for this script. Press Enter to exit." -ForegroundColor Red -BackgroundColor DarkGray
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "Denied" -Value 1 -Type DWord -Force
		Read-Host
		exit
	}
}
. $workdir\modules\lib\getedition.ps1
Write-Host -ForegroundColor White "You're running Windows $editiontype $editiond, OS build"$build"."$ubr

# Continue setting up Registry Folder
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting up environment"
function Set-AutoIDKUValue($type,$value,$data) {
	if ($type -like "d") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data -Type DWord -Force
	} elseif ($type -like "str") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name $value -Value $data
	} elseif ($type -like "app") {
		Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps" -Name $value -Value $data -Type DWord -Force
	}
}
Set-AutoIDKUValue str "ReleaseType" $releasetype
Set-AutoIDKUValue str "ReleaseID" $releaseid
Set-AutoIDKUValue str "ReleaseIDEx" $releaseidex
New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Music
for ($m = 1; $m -le 3; $m++) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music" -Name $m -Value 1 -Type DWord -Force
}
New-Item -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name Apps
Set-AutoIDKUValue app WinaeroTweaker 1
Set-AutoIDKUValue app OpenShell 1
Set-AutoIDKUValue app Firefox 1
Set-AutoIDKUValue app NPP 1
Set-AutoIDKUValue app ShareX 1
Set-AutoIDKUValue app PDN 0
Set-AutoIDKUValue app PENM 0
Set-AutoIDKUValue app ClassicTM 1
Set-AutoIDKUValue app DesktopInfo 0

Remove-Item -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -ErrorAction SilentlyContinue
$meeter = Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$meetor = Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
$meesys = Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies'
switch ($false) {
	{$meeter -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'Explorer'
	}
	{$meetor -eq $_} {
		New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer'
	}
	{$meesys -eq $_} {
		New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies' -Name 'System'
	}
}

Set-AutoIDKUValue d "Pwsh" 7
Set-AutoIDKUValue d "ConfigSet" 0
Set-AutoIDKUValue d "ConfigEditing" 0 
Set-AutoIDKUValue d "ConfigEditingSub" 0 
Set-AutoIDKUValue d "ChangesMade" 0
Set-AutoIDKUValue d "Denied" 0
Set-AutoIDKUValue d "HikaruMode" 0
Set-AutoIDKUValue d "SetWallpaper" 1
Set-AutoIDKUValue d "HikaruMusic" 1
Set-AutoIDKUValue d "EssentialApps" 1
Set-AutoIDKUValue d "WUmodeSwitch" 1
Set-AutoIDKUValue d "EdgeKilled"  0
Set-AutoIDKUValue d "PendingRebootCount" 0
Set-AutoIDKUValue d "RunningThisRemotely" 0
Set-AutoIDKUValue d "ClearBootMessage" 0
Set-AutoIDKUValue d "DarkSakura" 0
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

if ($edition -like "Core") {
	Write-Host " "
	Write-Host "Home edition detected" -ForegroundColor Black -BackgroundColor Yellow
	Write-Host "Beware that certain system restrictions, like blocking Feature updates in Windows Update will NOT work with this edition." -ForegroundColor Yellow -BackgroundColor DarkGray
	Start-Sleep -Seconds 3
	Write-Host " "
}
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue

# Get Hikaru
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Getting dependencies ready"
Start-Process powershell -Wait -ArgumentList "-Command $workdir\utils\hikarug.ps1" -WorkingDirectory $workdir\utils

# Immediately install the ambient sound package and play the script startup sound
Expand-Archive -Path $workdir\utils\ambient.zip -DestinationPath $coredir\ambient
Start-Process "$coredir\ambient\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\SpiralAbyss.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
Set-AutoIDKUValue d "BootStrapped" 1
exit
