# Music picker module, part of the main menu - Still in the works

Show-Branding clear

Write-Host -ForegroundColor Yellow "This feature is currently in development. Stay tuned for future updates!"
Write-Host "For now, if you want to customize your music selection, follow these steps:"
Write-Host "- Navigate to" -n; Write-Host " HKCU\SOFTWARE\AutoIDKU\Music " -ForegroundColor White
Write-Host "- You should see five REG_DWORD values inside the" -n; Write-Host ' "Music" ' -ForegroundColor White -n; Write-Host "key, going from 1 to 3"
Write-Host "- Those values correspond to these categories below. Refer to this list to adjust your selection."
Write-Host "  (Set to the value 1 to select the category, or 0 to unselect)"
Write-Host -ForegroundColor Green "  1. Featured Artists"
Write-Host -ForegroundColor Green "  2. Touhou OSTs"
Write-Host -ForegroundColor Green "  3. Genshin Impact OSTs"
Write-Host "- FYI, categories from 2 and 3 are game sound tracks. You can look up on the internet about those games. As for category 1, it features works from independent composers or artists groups that I hand-picked. I will be providing detailed information about 2 and 3 in a future update, stay tuned for that too!"
Write-Host "- The selected categories will be downloaded during script execution, and all songs within all collections will be played in shuffle."
Write-Host " "
Write-Host -ForegroundColor Yellow "Press Enter to return to the previous menu."
Read-Host
