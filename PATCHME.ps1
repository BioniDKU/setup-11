# YuumeiDKU Windows Update mode - Update Build Revision numbers

# The purpose of this file is so I can update the UBRs every month without having to update the whole script package.

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
