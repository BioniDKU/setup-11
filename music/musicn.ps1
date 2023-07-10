$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | Music fetcher module"
function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "Music fetcher module" -ForegroundColor Magenta -BackgroundColor Gray
	Write-Host " "
}
$mexists = Test-Path -Path "$PSScriptRoot\normal"
if ($mexists -eq $true) {exit}

Show-Branding
Import-Module BitsTransfer

for ($c = 1; $c -le 3; $c++) {
	$cv = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU\Music").$c
	if ($cv -eq 1) {
		Write-Host "Downloading category $c..." -ForegroundColor White
		for ($n = 1; $n -le 9; $n++) {
			Start-BitsTransfer -DisplayName "Downloading category $c" -Description "Attempt $n out of 9" -Source "https://github.com/Bionic-OSE/YuumeiDKU-music/raw/music/normal$c.7z.00$n" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		}
		Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\normal$c.7z.001 -o$PSScriptRoot\normal -pYuumeiDKU"
	}
}

Write-Host " "
Write-Host -ForegroundColor Green -BackgroundColor DarkGray "Extraction complete!" -n; Write-Host " (If you see warnings, ignore them. The files should be fine)"
Write-Host -ForegroundColor Yellow "Some of the songs featured in this collection might be copyrighted. If you are planning to record and upload this run to public platforms, please beware of that. You can view this collection in $PSScriptRoot\normal"
Write-Host -ForegroundColor Yellow "Continuing in 10 seconds" -n; Write-Host " (or you can skip by pressing Ctrl+C)"
Start-Sleep -Seconds 10
