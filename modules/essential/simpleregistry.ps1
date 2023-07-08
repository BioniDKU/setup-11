function Set-SystemColors($redi,$grei,$blui) {
	#SuwakoColorsLite
	$red = [int32]$redi
	$gre = [int32]$grei
	$blu = [int32]$blui
	$redx = ([System.Convert]::ToString($red,16)).PadLeft(2,'0')
	$grex = ([System.Convert]::ToString($gre,16)).PadLeft(2,'0')
	$blux = ([System.Convert]::ToString($blu,16)).PadLeft(2,'0')
	$clrx = "${redx}${grex}${blux}ff"
	$rlcx = "ff${blux}${grex}${redx}"
	$rlc0 = "00${blux}${grex}${redx}"
	Write-Host " "
	Write-Host "These color values will set on your Active title bar color and Highlight color:" -ForegroundColor Cyan
	Write-Host "RGB Dec color: $red, $gre, $blu, 255"
	Write-Host "RGB Hex color: $clrx"
	Write-Host "BGR Hex color: $rlcx"
	Write-Host "RGB Hex array: $bite"
	$dsat = 0.6
	$lumi = $red*0.3 + $gre*0.6 + $blu*0.1
	$redd = [Math]::Round($red + $dsat*($lumi-$red))
	$gred = [Math]::Round($gre + $dsat*($lumi-$gre))
	$blud = [Math]::Round($blu + $dsat*($lumi-$blu))
	$rddx = ([System.Convert]::ToString($redd,16)).PadLeft(2,'0')
	$grdx = ([System.Convert]::ToString($gred,16)).PadLeft(2,'0')
	$bldx = ([System.Convert]::ToString($blud,16)).PadLeft(2,'0')
	$cldx = "${rddx}${grdx}${bldx}ff"
	$dlcx = "ff${bldx}${grdx}${rddx}"
	Write-Host " "
	Write-Host "These color values will set on your Inactive title bar color:" -ForegroundColor Cyan
	Write-Host "60% Desaturated RGB Dec color: $redd, $gred, $blud, 255"
	Write-Host "60% Desaturated RGB Hex color: $cldx"
	Write-Host "60% Desaturated BGR Hex color: $dlcx"
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name AccentColorInactive -Value "0x$dlcx" -Type DWord -Force
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name HotTrackingColor -Value "0x$rlc0" -Type DWord -Force
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name Hilight -Value "0x$rlc0" -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name AccentColorMenu -Value "0x$rlcx" -Type DWord -Force
	Write-Host "SUCCESS" -ForegroundColor Green
}

switch ($true) {
	
	$applookupinstore {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling App Lookup in Microsoft Store"
		$ifexist = (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer')
		if ($ifexist -eq $false) {New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name "Explorer" -ItemType Directory}
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name "NoUseStoreOpenWith" -Value 1 -Type DWord -Force
	}

	$showsuperhidden {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Unhiding hidden system files and folders"
		Write-Host -ForegroundColor White "For these to show, you must first show normal hidden files and folders"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Value 1 -Type DWord -Force
	}
	
	{$removequickaccess -and $explorerstartfldr} {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing Quick Access"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'HubMode' -Value 1 -Type DWord -Force
	}
	
	$disabledefenderstart {
		Write-Host  -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Windows Defender on startup"
		Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run' -Name 'SecurityHealth' -Value ([byte[]](0x33,0x32,0xFF))
	}
	
	$disablenotifs {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Toast Notifications" 
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0 -Type DWord -Force
	}
	
	$disablegamebar {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Game Bar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -Type DWord -Force
	}
	
	$disableautoplay {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling AutoPlay"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun' -Value 255 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Value 1 -Type DWord -Force
	}
	
	$disablemultitaskbar {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Multi-monitor taskbar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarEnabled' -Value 0 -Type DWord -Force
	}
	
	$disabletransparency {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Transparency"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 0 -Type DWord -Force
	}
	
	$disablewinink {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Windows Ink Workspace"
		New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'WindowsInkWorkspace' -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace' -Name 'AllowWindowsInkWorkspace' -Value 0 -Type DWord -Force
	}
	
	$removedownloads {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing Downloads Folder"
		$dlhasfiles = Test-Path -Path "$env:USERPROFILE\Downloads\*"
		if ($dlhasfiles -eq $true) {
			Write-Host "DELETING YOUR DOWNLOADS FOLDER as you specified." -ForegroundColor Red -BackgroundColor DarkGray
			Import-Module -Name $PSScriptRoot\..\lib\Remove-ItemWithProgress.psm1
			Remove-ItemWithProgress -Path "$env:USERPROFILE\Downloads"
		} else {
			Remove-Item -Path "$env:USERPROFILE\Downloads" -Force -Recurse
		}
		Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
		Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force 
		Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
		Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force
	}
	
	$contextmenuentries {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Tuning the Context Menu"
		New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
		$modernsharexists = Test-Path -LiteralPath "HKCR:\*\ShellEx\ContextMenuHandlers\ModernSharing"
		$idkwhattocallthis = Test-Path -Path "HKCR:\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}"
		switch ($true) {
			$modernsharexists {Remove-Item -LiteralPath "HKCR:\*\ShellEx\ContextMenuHandlers\ModernSharing" -Force -Recurse}
			$idkwhattocallthis {Remove-Item -Path "HKCR:\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" -Force -Recurse}
		}
	}
	
	$defaultcolor {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting the Accent color to Rose"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'AccentColor' -Value 4289827839 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorizationAfterglow' -Value 3305083825 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorizationColor' -Value 3305083825 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorPrevalence' -Value 1 -Type DWord -Force
		Set-SystemColors 255 127 162
	}
	
	$hidebluetoothicon {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Hiding Bluetooth Icon"
		Set-ItemProperty -Path 'HKCU:\Control Panel\Bluetooth' -Name 'Notification Area Icon' -Value 0 -Type DWord -Force
	}
	
	$activatephotoviewer {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Activating Windows Photo Viewer"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".bmp" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".dib" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".gif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jfif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpe" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpeg" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpg" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jxr" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".png" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".tif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".tiff" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
	}
	
	$registeredowner {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting Registered owner"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOwner' -Value 'Project YuumeiDKU - (c) Bionic Butter' -Type String -Force
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOrganization' -Value "$butter" -Type String -Force
	}
	
	$disablestoreautoupd {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling Microsoft Store Automatic App Updates"
		New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'WindowsStore'
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' -Name 'AutoDownload' -Value 2 -Type DWord -Force
	}
	
	$oldvolcontrol {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling old volume control"
		New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'MTCUVC'
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC' -Name 'EnableMtcUvc' -Value 0 -Type DWord -Force
	}
	
	$balloonnotifs {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling Balloon notificatons"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 1 -Type DWord -Force
	}
	
	$showalltrayicons {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Showing all tray icons in the taskbar"
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Value 0 -Type DWord -Force
	}
	
	$disablelockscrn {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling LogonUI's Clock screen (aka the Lock Screen)"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData' -Name 'AllowLockScreen' -Value 0 -Type DWord -Force
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsSpotlightFeatures -Value 1 -Type DWord -Force
	}
	
	$classicalttab {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Enabling Classic Alt+Tab"
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'AltTabSettings' -Value 1 -Type DWord -Force
	}
	
	$disablelocationicon {
		$located = Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location'
		if ($located) {
			Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling the Location icon"
			Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name Value -Value "Deny" -Type String -Force
		}
	}
	
	$disablelogonbg {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Disabling LogonUI's background image"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name "DisableLogonBackgroundImage" -Value 1 -Type DWord -Force
	}
	
	$removelckscrneticon {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Removing the network icon from LogonUI"
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name "DontDisplayNetworkSelectionUI" -Value 1 -Type DWord -Force
	}
	
	$svchostslimming {
		Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Setting svchost.exe to max RAM"
		$svchostvalue = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1kb
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name "SvcHostSplitThresholdInKB" -Value $svchostvalue -Type DWord -Force
	}
	
}
