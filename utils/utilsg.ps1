$host.UI.RawUI.WindowTitle = "Project YuumeiDKU - (c) Bionic Butter | Utilites fetcher module - DO NOT CLOSE THIS WINDOW"
$uexists = Test-Path -Path "$PSScriptRoot\WinXShell.zip" -PathType Leaf
if ($uexists) {exit}
function Show-Branding {
	Clear-Host
	Write-Host 'Project YuumeiDKU - A New era for IDKUs' -ForegroundColor White -BackgroundColor Magenta
	Write-Host "Utilites fetcher module" -ForegroundColor Magenta -BackgroundColor Gray
	Write-Host " "
}
Show-Branding
Import-Module BitsTransfer

# IMPORTANT SECTION
#$utag = "100_b1"
$unum = 1

for ($u = 1; $u -le $unum; $u++) {
	while ($true) {
		#Start-BitsTransfer -DisplayName "Getting the Utilites package" -Description "Downloading file $u out of $unum" -Source "https://github.com/Bionic-OSE/YuumeiDKU-utils/releases/download/$utag/utils.7z.00$u" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		
		# Still in early development, I don't wanna push things to GitHub yet. Using BioniCDN instead for now.
		Start-BitsTransfer -DisplayName "Getting the Utilites package" -Description "Downloading file $u out of $unum" -Source "https://github.com/Bionic-OSE/BioniCDN/raw/main/YuumeiDKU/utilsrels/utils.7z.00$u" -Destination $PSScriptRoot -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$PSScriptRoot\utils.7z.00$u" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor Black -BackgroundColor Red "Uhhhhhhh"
			Write-Host -ForegroundColor Red "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
}
Start-Process $PSScriptRoot\..\core\7za.exe -Wait -NoNewWindow -ArgumentList "e $PSScriptRoot\utils.7z.001 -o$PSScriptRoot -y"
Expand-Archive -Path $PSScriptRoot\ViVeTool.zip -DestinationPath $PSScriptRoot\ViVeTool
