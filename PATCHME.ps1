## YuumeiDKU - Update Build Revision numbers and ViVeTool velocity IDs listing file

## The purpose of this file is so I can update the UBRs and the IDs every month without having to update the whole script package.

# UBRs list
. $workdir\modules\lib\GetEdition.ps1
switch ($edition) {
	
	# Consumer and any other editions
	default {$latest = @(
		<# ======= EOL builds ======= #>
		<# ====== Alive builds ====== #>
		<# 21H2 #>          "22000.2057"
		<# 22H2 #>          "22621.1848"
	)}
	
	# Commerical editions
	{$_ -like "Enterprise" -or $_ -like "Education"} {$latest = @(
		<# ======= EOL builds ======= #>
		<# ====== Alive builds ====== #>
		<# 21H2 #>          "22000.2057"
		<# 22H2 #>          "22621.1848"
	)}
	
}

# ViVeTool velocity IDs list
switch ($build) {
	
	{$_ -eq 22000} {
		$viveids = ""
	}
	
	{$_ -eq 22621} {
		$viveids = "26008830,37634385,39145991,36354489,36302090,41655236"
	}
	
}
