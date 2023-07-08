$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | UWP apps removal module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Blue
	Write-Host "UWP apps removal module" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}
Show-Branding

Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "This process will spit out A LOT of errors, and that is normal. It will start in 5 seconds."
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "In addition, if you are sensitive to flashes, please minimize or do not look at this window."
Write-Host " " 

Start-Sleep -Seconds 5
Get-AppxPackage | Remove-AppxPackage
Get-AppxPackage -AllUsers | Remove-AppxPackage
Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Removal complete"
Start-Sleep -Seconds 10
