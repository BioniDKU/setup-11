# YuumeiDKU software downloader - (c) Bionic Butter
# The purpose is to save bandwidth, and later to allow you to have the main stage running completely offline without any problems

function Start-DownloadLoop($link,$destfile,$name) {
	while ($true) {
		Start-BitsTransfer -DisplayName "Downloading $name" -Description " " -Source $link -Destination $workdir\dls\$destfile -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$workdir\dls\$destfile" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Ehhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
}


$WinaeroTweaker = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").WinaeroTweaker
$OpenShell      = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").OpenShell
$Firefox        = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").Firefox
$NPP            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").NPP
$ShareX         = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").ShareX
$PDN            = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").PDN
$PENM           = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").PENM
$ClassicTM      = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").ClassicTM
$DesktopInfo    = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Apps").DesktopInfo
$essentialnone  = $false
function Write-AppsList($action) {
	Write-Host -ForegroundColor Cyan "The following programs will be $action"
	switch (1) {
		$WinaeroTweaker {Write-Host -ForegroundColor Cyan "- Winaero Tweaker"} #dl1
		$OpenShell      {Write-Host -ForegroundColor Cyan "- Open-Shell" -n; Write-Host " (4.4.170)"} #dl2
		$Firefox        {Write-Host -ForegroundColor Cyan "- Mozilla Firefox ESR"} #dl6
		$NPP            {Write-Host -ForegroundColor Cyan "- Notepad++" -n; Write-Host " (8.5)"} #dl8
		$ShareX         {Write-Host -ForegroundColor Cyan "- ShareX" -n; Write-Host " (13.1.0)"} #dl9
		$PDN            {Write-Host -ForegroundColor Cyan "- Paint.NET"} #dl10
		$PENM           {Write-Host -ForegroundColor Cyan "- PENetwork Manager"} #dl5
		$ClassicTM      {Write-Host -ForegroundColor Cyan "- Classic Task Manager & Classic System Configuration"} #dl11 but same as dl5
		$DesktopInfo    {Write-Host -ForegroundColor Cyan "- DesktopInfo" -n; Write-Host " (2.10.2, with custom configuration)"}
		default {
			Write-Host -ForegroundColor Red "You selected NONE, are you kidding me???"
			$essentialnone = $true
		}
	}
	if ($essentialnone -ne $true) {Write-Host "Some of these might not be on their latest releases. You can update them on your own later."}
}
$hkm = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).HikaruMode
if ($hkm -eq 0) {
	Write-Host "Installing essential programs" -ForegroundColor Cyan -BackgroundColor DarkGray
	Write-AppsList "installed:"
	exit
}

$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | Download mode - DO NOT CLOSE THIS WINDOW OR DISCONNECT INTERNET"
function Stop-DownloadMode($nhkm) {
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootScript" -Value 1 -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "HikaruMode" -Value $nhkm -Type DWord -Force
	Stop-Process -Name "FFPlay" -Force -ErrorAction SilentlyContinue
	Stop-Process -Name "SndVol" -Force -ErrorAction SilentlyContinue
	exit
}
function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "Download mode" -ForegroundColor Magenta -BackgroundColor Gray
	Write-Host " "
}
Show-Branding
$workdir = Split-Path(Split-Path "$PSScriptRoot")
$coredir = Split-Path "$PSScriptRoot"

# Create downloads folder
$dlfe = Test-Path -Path "$workdir\dls"
if ($dlfe -eq $false) {
	New-Item -Path $workdir -Name dls -itemType Directory | Out-Null
}
$hkau = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").HikaruMusic
if ($hkau -eq 1) {
	$n = Get-Random -Minimum 1 -Maximum 3
	Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $coredir\ambient\ChillWait$n.mp3 -nodisp -loglevel quiet -loop 0 -hide_banner"
	Start-Process "$env:SYSTEMDRIVE\Windows\SysWOW64\SndVol.exe"
	Write-Host -ForegroundColor White "For more information on the currently playing music, refer to $coredir\ambient\ChillWaitInfo.txt"
	Write-Host -ForegroundColor Yellow "DO NOT adjust the volume of FFPlay! It will affect your music experience later on!"
}
Start-Sleep -Seconds 3

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting Utilities package"
Start-Process powershell -Wait -ArgumentList "-Command $workdir\utils\utilsg.ps1" -WorkingDirectory $workdir\utils

if ($hkau -eq 1) {
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Getting music packages"
	Start-Process powershell -Wait -ArgumentList "-Command $workdir\music\musicn.ps1" -WorkingDirectory $workdir\music
}

$esapps = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).EssentialApps
if ($esapps -eq 1) {
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Downloading essential programs"
	Write-AppsList "downloaded:"
	if ($essentialnone -ne $true) {
		Import-Module BitsTransfer
		# Download links
		$dl1 = "https://winaerotweaker.com/download/winaerotweaker.zip"
		$dl2 = "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.170/OpenShellSetup_4_4_170.exe"
		$dl6 = "https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"
		$dl8 = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5/npp.8.5.Installer.x64.exe"
		$dl9 = "https://github.com/ShareX/ShareX/releases/download/v13.1.0/ShareX-13.1.0-setup.exe"
		$dl10 = "https://github.com/Bionic-OSE/YuumeiDKU-utils/raw/utils/active/paintdotnet.exe"
		
		# Download'em all
		switch (1) {
			$WinaeroTweaker {Start-DownloadLoop $dl1 winaero.zip "Winaero Tweaker"}
			$OpenShell {Start-DownloadLoop $dl2 openshellinstaller.exe "Open-Shell"}
			$Firefox {Start-DownloadLoop $dl6 firefoxesr.exe "Firefox ESR"}
			$NPP {Start-DownloadLoop $dl8 npp.exe "Notepad++"}
			$ShareX {Start-DownloadLoop $dl9 sharex462.exe "ShareX"}
		}
	}
}
$dlep = "https://github.com/valinet/ExplorerPatcher/releases/latest/download/ep_setup.exe"
Start-DownloadLoop $dlep ep_setup.exe "Explorer Patcher"

$wu = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU" -ErrorAction SilentlyContinue).WUmode
if ($wu -eq 1) {
	Start-DownloadLoop "https://github.com/Bionic-OSE/BioniDKU/raw/main/PATCHME.ps1" "PATCHME.ps1" "UBR information file"
	Write-Host " "
	Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Downloading and installing PSWindowsUpdate"
	Install-PackageProvider -Name "NuGet" -Verbose -Force
	Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
	Add-Type -AssemblyName presentationCore
	Install-Module PSWindowsUpdate -Verbose
	Stop-DownloadMode 2
}

Stop-DownloadMode 5
