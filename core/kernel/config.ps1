## Project YuumeiDKU - A New era for IDKUs
## Script configuration file

#! The only things you should modify in this file are values under the 'Switch' column, with '$true' meaning 
#! True/ON and '$false' meaning False/OFF. I've made this layout in the most user-friendly way possible, so
#! you should have no problem understanding what does which, given that you ignore the "weird" stuffs you see
#! and only focus on changing the lines to True or False.

## -------------------- Friendly name --------------------- | ------ Variable name ------- | ------ Switch ------ |

## ================================================ MODULE SWITCHES ===============================================
## These are most of the things the script will do during its execution. The configuration presented here is the
## recommended default.

<# Enable .NET 3.5 #>                                         $dotnet35 =                    $false
<# Hide system icons from the taskbar #>                      $hidetaskbaricons =            $true
<# Remove Microsoft Edge Shortcuts #>                         $removeedgeshortcut =          $true
<# Create desktop shortcuts #>                                $desktopshortcuts =            $true
<# Disable Wake timers #>                                     $removewaketimers =            $true
<# Remove all UWP apps possible #>                            $removeUWPapps =               $true
<# Use script's Open-Shell config* #>                         $openshellconfig =             $true
<# Remove taskbar pins #>                                     $taskbarpins =                 $true
<# Replace seguiemj.ttf with Windows 11 22H2's #>             $replaceemojifont =            $true 
<# Set default apps #>                                        $defaultapps =                 $true 
<# Remove Explorer address bar #>                             $disableaddressbar =           $true
<# Remove Microsoft OneDrive #>                               $removeonedrive =              $true
<# Defaults Explorer to This PC #>                            $explorerstartfldr =           $true
<# Use classic battery flyout #>                              $oldbatteryflyout =            $true
<# Install custom system sound #>                             $customsounds =                $false
<# Disable some system apps #>                                $removesystemapps =            $true
<# Replace SlideToShutDown.exe background #>                  $sltoshutdownwall =            $true
<# Don't touch Edge Chromium** #>                             $keepedgechromium =            $false

<#  *Essential Apps required #>
<# **Affects $removeedgeshortcut and $removesystemapps #>

## ================================================ REGISTRY SWICHES ===============================================
## Below are registry-applied tweaks. You can enable/disable all of them, or toggle individual options.

<# Enable registry tweaks #>                                  $registrytweaks =              $true # Master switch for the rest below

<# Disable Defender startup entry #>                          $disabledefenderstart =        $true
<# Disable Toast notifications #>                             $disablenotifs =               $true 
<# Disale Game Bar #>                                         $disablegamebar =              $true 
<# Disale AutoPlay #>                                         $disableautoplay =             $true 
<# Disale multi-monitor taskbar #>                            $disablemultitaskbar =         $false
<# Disale Transparency #>                                     $disabletransparency =         $false 
<# Disale window animations #>                                $disableanimations =           $true 
<# Disale Windows Ink Workspace #>                            $disablewinink =               $true 
<# Remove Downloads folder #>                                 $removedownloads =             $false
<# Disable "Look for this app in Store" #>                    $applookupinstore =            $true
<# Tune the Context menu #>                                   $contextmenuentries =          $true
<# Remove Quick Access #>                                     $removequickaccess =           $true
<# Disable Location icon*** #>                                $disablelocationicon =         $true 
<# Activate Windows Photos viewer #>                          $activatephotoviewer =         $true 
<# Set Registered owner #>                                    $registeredowner =             $true 
<# Disable Edge prelaunch on startup #>                       $disableedgeprelaunch =        $true
<# Disable automatic update of UWPs #>                        $disablestoreautoupd =         $true
<# Enable classic ballon notifications #>                     $balloonnotifs =               $true 
<# Show all icons in taskbar tray #>                          $showalltrayicons =            $false 
<# Show hidden system files and folders #>                    $showsuperhidden =             $false 
<# Disable Lock screen #>                                     $disablelockscrn =             $true
<# Use classic Alt+Tab #>                                     $classicalttab =               $false
<# Use classic volume control #>                              $oldvolcontrol =               $false
<# Set system colors to the script's #>                       $defaultcolor =                $true
<# Hide Bluetooth icon #>                                     $hidebluetoothicon =           $true
<# Disable Login screen background #>                         $disablelogonbg =              $false
<# Remove Network icon from login screen #>                   $removelckscrneticon =         $true
<# Reduce the amount of svchost.exes #>                       $svchostslimming =             $true
<# Enable ?????.???? desktop version #>                       $desktopversion =              $false

## OwO