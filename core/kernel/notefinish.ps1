# This is the note message that gets printed at the end of script execution

Write-Host "But before you do that..." -ForegroundColor Yellow
Write-Host "Due to the script's limited ability, the following stuffs might have not been setup properly as planned:" -ForegroundColor Yellow -BackgroundColor DarkGray

switch ($build) {
	default {}
	{$_ -ge 22000} {
		Write-Host "- Toast Notification won't be disabled completely " -n; Write-Host -ForegroundColor Yellow "until you turn on Focus Assist (Do Not Distrub) in Settings, without exceptions (Alarms only and uncheck all checkboxes)."
		Write-Host "- The Lock screen might not be disabled. If that's the case, " -n; Write-Host -ForegroundColor Yellow 'please use Winaero Tweaker to disable it instead.'
	}
}

Write-Host "If you do find more stuffs or problems, please do or fix them manually and report back to me. I appreciate all feedbacks!" -ForegroundColor White
