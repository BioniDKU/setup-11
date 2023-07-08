Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "EdgeKilled" -Value 1 -Type DWord -Force
Write-Host -ForegroundColor Cyan -BackgroundColor DarkGray "Let's get manually-only things out of the way!"
Write-Host " "

Write-Host -ForegroundColor Cyan "First, Explorer stuffs."
Write-Host -ForegroundColor Yellow "1. Right click taskbar > Properties > About > Import settings and point to $workdir\utils\ep_settings.reg, then accept everything that pops up and restart Explorer using the (*) link at the bottom left."
Write-Host -ForegroundColor Yellow "2. Then, disable as many icons on the taskbar in Settings as possible. (Make sure Windows is activated)."
Write-Host -ForegroundColor Yellow '3. While still in Settings, head over to Lock screen Settings and switch the background type to "Picture"'
Write-Host -ForegroundColor Yellow "4. Finally, unpin every pinned icons on your taskbar to prevent empty icons later on."
#if ($build -eq 22000) {
#	Write-Host -ForegroundColor Black -BackgroundColor Yellow 'IMPORTANT: On Windows 11 21H2, due to theme file swapping, launching UWP apps (including Settings) MIGHT not show any windows until you click on its taskbar icon a few times, or use Alt+Tab to switch to it.'
#}
Write-Host -ForegroundColor Cyan "Press Enter once you have done with those."
Read-Host

Write-Host " "
Write-Host -ForegroundColor Cyan "Secondly, turning off the startup sound" -n; Write-Host " (so you won't get 2 different chimes on every startup)"
Write-Host -ForegroundColor Yellow '- The good old Sound Control Panel aplet will open in a moment, after which switch to the Sounds tab.'
Write-Host -ForegroundColor Yellow '- Uncheck "Play Windows Startup sound", and click "Apply".'
Write-Host -ForegroundColor Cyan 'Close the window and the script should automatically continue.'
Start-Sleep -Seconds 2
Start-Process rundll32.exe -Wait -ArgumentList "shell32.dll,Control_RunDLL mmsys.cpl,,sounds"

Write-Host " "
Write-Host -ForegroundColor Cyan "Lastly, disabling Windows Update."
Expand-Archive -Path $workdir\utils\Wu10Man.zip -DestinationPath $workdir\utils\Wu10Man
Start-Process $workdir\utils\Wu10Man\Wu10Man.exe -WorkingDirectory $workdir\utils\Wu10Man
Write-Host 'In order to completely disable Windows Update, a program called "Wu10Man" will soon appear on your screen.'
Write-Host -ForegroundColor Black -BackgroundColor Cyan "FOLLOW THESE STEPS CLOSELY once it's opened:"
Write-Host -ForegroundColor Yellow '- You are now in the first tab: "Windows Services". Click "Disable All Services" and wait for it to complete.'
Write-Host -ForegroundColor Yellow '- Now go to the Settings app > Windows Update and click Pause Updates (ignore this and the next step if the button is grayed out, you are out of luck).'
Write-Host -ForegroundColor Yellow '- Then, come back to Wu10Man and come over to the second tab: "Pause updates" and type your desired pause limit date in mm/dd/yyyy into both fields (I would recommend around 10 years from now XD). Then click Save and move on.'
Write-Host -ForegroundColor Yellow '- Then, in the last tab: "BETA - Scheduled Tasks". Click "Disable All Tasks" and wait for it to complete.'
Write-Host -ForegroundColor White 'For the first and last tabs, if it appears to freeze for too long, close or kill the program, reopen it, and disable the items one by one.'
Write-Host " "

Write-Host "That will be the last step of the manually-done series."

Write-Host -ForegroundColor Cyan "Once you press Enter, everything else should be automated!"
Read-Host
