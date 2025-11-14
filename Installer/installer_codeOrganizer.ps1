#check if the software is installed and what version its on
#IF installed, ask if they would like to uninstall, or exit
#>Run uninstall routine if asked / stop service / Remove service / Zip all files and place on desktop as a backup.
#IF not installed ask if want install or exit
#install pre-check - Check if there are pode and podeweb folders in the powershell directory / Check if they are in the users directory>
##IF they are in user, ask if they want them to be copied to? IF non are found, ask if you would like to install. If install, recheck the directories
##before moving forward
#Install > GRab zip file from repo> Create Enigma-tek folder and unzip the codeOrg folder into / Create service / Create shortcut to start stop


Function preChkInstall {

    $preChkPath = "C:\Program Files\Enigma-Tek\codeOrg"
    $preChk = Test-Path -Path $preChkPath

    If ($preChk -eq "True") {
        Clear-Host
        uninstallChk
    }
    
    If ($preChk -ne "True") {
        Clear-Host
        installFunk
    }

}

Function installFunk {

    $rawUrl = "https://raw.githubusercontent.com/enigma-tek/PSCodeOrganizer/refs/heads/main/version.txt"
    $GitVerNum = (Invoke-WebRequest -Uri $rawUrl).Content.Trim()
    Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
    Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"

    $InstallQuest = Read-Host "Would you like to Install Code Organizer? (Type 'YES')`n         OR you can exit (Type 'EXIT')"
        Switch ($InstallQuest){
            Yes{
                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
                Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"
                Write-Host "Creating Directory Structure..."
                New-Item -Path "C:\Program Files\" -Name "Enigma-Tek" -ItemType "directory"
                New-Item -Path "C:\Program Files\Enigma-Tek\" -Name "codeOrg" -ItemType "directory"
                Start-Sleep -seconds 2

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
                Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"
                Write-Host "Directory Structure complete..."
                Write-Host "Downloading Files..."
                New-Item -Name "temp" -Path "C:\Program Files\Enigma-Tek\" -ItemType Directory
                Invoke-WebRequest -Uri "https://raw.githubusercontent.com/enigma-tek/CodeOrganizer/refs/heads/main/Files/codeOrg.zip" -OutFile "C:\Program Files\Enigma-Tek\temp\codeOrg.zip"
                Expand-Archive -Path "C:\Program Files\Enigma-Tek\temp\codeOrg.zip" -DestinationPath "C:\Program Files\Enigma-Tek\codeOrg\"
                Start-Sleep -Seconds 2

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
                Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"
                Write-Host "Files downloaded..."
                Write-Host "Creating desktop shortcut..."
                $DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
                $ShortcutLocation = Join-Path -Path $DesktopPath -ChildPath "StartStop-CodeOrg.lnk"

                $WshShell = New-Object -comObject WScript.Shell
                $Shortcut = $WshShell.CreateShortcut($ShortcutLocation)
                $Shortcut.TargetPath = "C:\Program Files\PowerShell\7\pwsh.exe"
                $Shortcut.Arguments = "-ExecutionPolicy Bypass -File ""C:\Program Files\Enigma-Tek\codeOrg\service\startStopService.ps1"""
                $Shortcut.RelativePath = "C:\Program Files\PowerShell\7\pwsh.exe"
                $shortcut.IconLocation = "filemgmt.dll,0"
                $Shortcut.Save()

                $bytes = [System.IO.File]::ReadAllBytes($ShortcutLocation)
                $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
                [System.IO.File]::WriteAllBytes($ShortcutLocation, $bytes)
                Start-Sleep -Seconds 2

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
                Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"
                Write-Host "Shortcut created..."
                Write-Host "Registering service..."
                sc.exe create codeOrganizer binPath= "C:\Program Files\Enigma-Tek\codeORg\service\codeOrg.exe" displayname= "CodeORganizer" start= auto
                Start-Sleep -Seconds 2
                sc.exe description codeOrganizer "Code Organizer by Enigma-Tek service."
                sc.exe start codeOrganizer
                Start-Sleep -Seconds 2

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
                Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"
                Write-Host "Service Registered and started"
                Start-Sleep -Seconds 2

                Remove-Item -Path "C:\Program Files\Enigma-Tek\temp" -Recurse -Force

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Installer ============"
                Write-Host -foregroundColor Yellow "       Utility will install Enigma-Tek Code Organizer Version: $GitVerNum`n`n"
                Write-Host "Code Organizer has been installed. Press Enter to exit installer `n `n"
                Pause
                exitFunk
            }
            EXIT {exitFunk}
            Default {
                Clear-Host
                Write-Host -foregroundColor Red "`n `n You must type a valid choice, please try again... `n"
                installFunk
            }
        }
}
Function uninstallChk {

    $verChk = Get-Content -Path "C:\Program Files\Enigma-Tek\codeOrg\files\configs\codeOrg.json" | ConvertFrom-Json
    $verDisp = $verChk.Vers
    Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Uninstaller ============"
    Write-Host -foregroundColor Yellow "       It looks like you already have Code Organizer installed. "
    Write-Host -foregroundColor Yellow "                     Code Organizer Version: $verDisp "
    Write-Host "`n"

     $uninstallQuest = Read-Host "`n    Would you like to uninstall Code Organizer (Type 'YES') `n      OR You can exit (Type 'EXIT')"
        Switch ($uninstallQuest) {
            YES {
                Clear-Host
                uninstallWork}
            EXIT {exitFunk}
            Default {
                Clear-Host
                Write-Host -foregroundColor Red "`n `n You must type a valid choice, please try again... `n"
                uninstallChk
            }
        }  
}

Function uninstallWork {

    Write-Host  -foregroundColor Magenta "`n `n        ============ Code Organizer Uninstaller ============`n`n"
    $dblChkUninstall = Read-Host "`n ARE YOU SURE YOU WANT TO UNNSTALL Code Organizer?? (Type 'YES')`n        OR You can exit (Type 'EXIT)"
        Switch ($dblChkUninstall) {
            YES {        
                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Uninstaller ============`n`n"
                Write-Host "`n Uninstalling..."
                sc.exe stop "CodeOrganizer"
                Write-Host "`n Stopping Service..."
                Start-Sleep -Seconds 2
                sc.exe delete "CodeOrganizer"
                Write-Host "`n Removing Service..."
                Start-Sleep -Seconds 2

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Uninstaller ============`n`n"
                Write-Host "`n Service Removed..."
                Write-Host "`n Removing Files..."
                Remove-Item -Path "C:\Program Files\Enigma-Tek\codeOrg" -Recurse -Force
                Start-Sleep -Seconds 2
                
                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Uninstaller ============`n`n"
                Write-Host "`n All files removed..."
                Write-Host "`n Removing desktop shortcut..."
                $DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
                $ShortcutLocation = Join-Path -Path $DesktopPath -ChildPath "StartStop-CodeOrg.lnk"
                Remove-Item $ShortcutLocation -Force

                Clear-Host
                Write-Host -foregroundColor Magenta "`n `n        ============ Code Organizer Uninstaller ============`n`n"
                Write-Host "`n Uninstall Complete..."
                Write-Host "`n Exiting in 5 seconds..."
                Start-Sleep -Seconds 5
                exitFunk
            }
        EXIT {exitFunk}
        Default {
            Clear-Host
            Write-Host -foregroundColor Red "`n `n You must type a valid choice, please try again... `n"
            uninstallWork 
            }
        }
}

Function exitFunk {
    Clear-Host
    exit
}

###----SCRIPT STARTS HERE---###

#Set the Title
$Title = "Code Organizer Installer/Uninstaller"
$host.UI.RawUI.WindowTitle = $Title

#Set the windows size
Function Set-WindowSize {
Param([int]$ConWidth=$host.ui.rawui.windowsize.width,
      [int]$ConHeight=$host.ui.rawui.windowsize.heigth)

    $size=New-Object System.Management.Automation.Host.Size($ConWidth,$ConHeight)
    $host.ui.rawui.WindowSize=$size  
}
Set-WindowSize 199 80 *>$null

Clear-Host
preChkInstall