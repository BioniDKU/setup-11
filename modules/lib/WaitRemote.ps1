$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | Startup interrupter"
function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Blue
	Write-Host "Startup interrupter" -ForegroundColor Blue -BackgroundColor Gray
	Write-Host " "
}

Write-Host "Waiting 30 seconds for you to connect via your remote desktop solution." -ForegroundColor Cyan -BackgroundColor DarkGray
Write-Host "Once you have connected, you can press CTRL+C to continue." -ForegroundColor Black -BackgroundColor Cyan
for ($wt = 30; $wt -ge 1; $wt--) {
	$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | Startup interrupter - $wt seconds remaining..."
	Start-Sleep -Seconds 1
}
