Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Configuring Hikaru-chan"

reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg"
$hkreg = Test-Path -Path 'HKCU:\SOFTWARE\Hikaru-chan'
if ($hkreg -eq $false) {
	New-Item -Path 'HKCU:\SOFTWARE' -Name Hikaru-chan
}
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "ProductName" -Value "YuumeiDKU" -Type String -Force
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "StartupSoundVariant" -Value 4 -Type DWord -Force

# Hikarun on-demand customization section
$hkrdelwwa = "del $env:SYSTEMDRIVE\Windows\System32\WWAHost.exe"
$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
$hkrbuildkey = "BuildLab"
if ($desktopversion) {
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Value 1 -Type DWord -Force
}

# Write the customized values to the on-demand batch file
@"
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v $hkrbuildkey /t REG_SZ /d "?????.????_release.??????-????" /f
$hkrdelwwa
"@ | Out-File -FilePath "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarun.bat" -Encoding ascii

# Install HikaruQM and pre-apply system restrictions (set restrictions but at disabled state)

$WScriptObj = New-Object -ComObject ("WScript.Shell")
$hkQML = "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
$hkQMLS = "$env:AppData\Microsoft\Windows\Start Menu\Programs\YuumeiDKU Quick Menu Tray.lnk"
$hkQMLSh = $WscriptObj.CreateShortcut($hkQMLS)
$hkQMLSh.TargetPath = $hkQML
$hkQMLSh.Save()
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "YuumeiDKU Quick Menu Tray" -Value "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe" -Type String -Force

$hkF5action = New-ScheduledTaskAction -Execute "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe"
$hkF5trigger = @(
	$(New-ScheduledTaskTrigger -AtLogon),
	$(New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At 8am)
)
$hkF5settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew
$hkF5 = New-ScheduledTask -Action $hkF5action -Trigger $hkF5trigger -Settings $hkF5settings
Register-ScheduledTask 'BioniDKU Quick Menu Update Checker' -InputObject $hkF5

Copy-Item -Path $env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe -Destination "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.exe"
Copy-Item -Path $coredir\7za.exe -Destination "$env:SYSTEMDRIVE\Windows\7za.exe"
Copy-Item -Path $coredir\7zxa.dll -Destination "$env:SYSTEMDRIVE\Windows\7zxa.dll"
taskkill /f /im ApplicationFrameHost.exe
takeown /f "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
icacls "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe" /grant Administrators:F
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
[System.Environment]::SetEnvironmentVariable('HikaruToken','3', 'Machine')
reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
$cmd = Test-Path -Path "HKCU:\Software\Microsoft\Command Processor"
if ($cmd -eq $false) {
	New-Item -Path "HKCU:\Software\Microsoft" -Name "Command Processor"
}
