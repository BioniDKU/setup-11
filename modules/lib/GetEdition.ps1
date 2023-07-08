# YuumeiDKU Windows Edition grabber
# This is for the script to print out the exact name of the corresponding Windows 11 editions.

$edition = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID

switch ($edition) {
	default {$editiontype = "11"}
	{$_ -like "ServerStandard" -or $_ -like "ServerDatacenter" -or $_ -like "ServerStandardEval" -or $_ -like "ServerDatacenterEval"} {$editiontype = "Server"}
}
switch ($edition) {
	default {$editiond = "$edition"}
	{$_ -like "Core"} {$editiond = "Home"}
	{$_ -like "Professional"} {$editiond = "Pro"}
	{$_ -like "EnterpriseS"} {$editiond = "LTSC"}
}
