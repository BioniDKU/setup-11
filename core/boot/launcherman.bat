@echo off
title YuumeiDKU is starting...

:#############################################################
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:#############################################################

:PSBoot
powershell Set-ExecutionPolicy -Force Unrestricted
powershell .\nana.ps1
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v Denied  ^|findstr /ri "REG_DWORD"') do set "ban=%%a"
if %ban%==0x1 exit
goto YuumeiDKU

:PSRestartS
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v RebootScript  ^|findstr /ri "REG_DWORD"') do set "re=%%a"
if %re%==0x1 title YummeiDKU is restarting... - DO NOT CLOSE THIS WINDOW
if %re%==0x3 title Please wait...
if %re%==0x1 echo Time for the launcher to restart the script...
if %re%==0x1 goto YuumeiDKU
if %re%==0x3 goto YuumeiDKU
echo https://youtu.be/zry4zeN0SHw
exit

:Hikarupdate
timeout 1 /nobreak > nul
powershell ..\servicing\hikarupdate.ps1
goto PSRestartS

:DownloadMode
timeout 1 /nobreak > nul
powershell ..\servicing\downloader.ps1
goto PSRestartS

:PatchMode
timeout 1 /nobreak > nul
powershell ..\kernel\patcher.ps1
goto PSRestartS

:YuumeiDKU
for /f "tokens=3" %%a in ('reg query "HKCU\Software\AutoIDKU" /v HikaruMode  ^|findstr /ri "REG_DWORD"') do set "hku=%%a"
if %hku%==0x2 goto Hikarupdate
if %hku%==0x4 goto DownloadMode
if %hku%==0x5 goto PatchMode
timeout 1 /nobreak > nul
powershell ..\kernel\main.ps1
goto PSRestartS

echo Something went wrong and the script couldn't boot. Please contact Bionic. Press any key to exit.
pause > nul
