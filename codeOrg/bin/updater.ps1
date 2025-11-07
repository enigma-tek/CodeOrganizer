function preChk {

Write-Host  -foregroundColor Magenta "`n `n      ============ Code Organizer Update Utility ============"
Write-Host  -foregroundColor Yellow "    This utility is for updating the code organizer core software files. It should not "
Write-Host  -foregroundColor Yellow "    remove any of your current settings or files, but a backup of the current codeORg folder "
Write-Host  -foregroundColor Yellow "    is still recommended. Please follow the guide in the GitHub Repo Wiki.  "
Write-Host "`n"

  #run Version check to make sure that an update is needed.
  #Get the local version number
  $chkUpdate = Get-Content "../files/configs/codeOrg.json" | ConvertFrom-Json
  $updateVersion = $chkUpdate.Vers

  #Get the online version number
  $rawUrl = "https://raw.githubusercontent.com/enigma-tek/PSCodeOrganizer/refs/heads/main/version.txt"
  $GitVerNum = (Invoke-WebRequest -Uri $rawUrl).Content

  #convert both versions into system versions to be able to compare
  $updateVersion = [System.Version]$updateVersion
  $GitVerNum = [System.Version]$GitVerNum

  if ($updateVersion -lt $GitVerNum) {

    Write-Host -ForegroundColor Green "There is an update available. Press Enter to install update `n"
    Pause
    updateCodeOrg
  } else {
    Write-Host -ForegroundColor White " There is no update available. Press Enter to exit `n"
    Pause
    exitFunk
  }
}

Function updateCodeOrg {

  Clear-Host
  Write-Host  -foregroundColor Magenta "`n `n      ============ Code Organizer Update Utility ============ `n"

  Write-Host -ForegroundColor Yellow "  Creating temp directory...."
  Start-Sleep -Seconds 2
  New-Item -Name "updateTemp" -Path "../" -ItemType Directory
  Write-Host -ForegroundColor Yellow "  Temp Directory created...`n"

  Write-Host -ForegroundColor Yellow "  Downloading and unzipping files..."
  Start-Sleep -Seconds 2
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/enigma-tek/CodeOrganizer/refs/heads/main/update/codeOrgUpdate.zip" -OutFile "../updateTemp/codeOrgUpdate.zip"
  Expand-Archive -Path "../updateTemp/codeOrgUpdate.zip" -DestinationPath "../updateTemp/"
  Write-Host -ForegroundColor Yellow "  Files downloaded and unzipped...`n"

  Write-Host -ForegroundColor Yellow "  Removing old files..."
  Start-Sleep -Seconds 2
  Remove-Item -Path "../pages/*.ps1"
  Remove-Item -Path "../modules/*.ps1"
  Write-Host -ForegroundColor Yellow "  Old files removed. Copying new files..."
  Start-Sleep -Seconds 2
  Copy-Item -Path "../updateTemp/pages*" -Destination "../pages" -Recurse -Force
  Copy-Item -Path "../updateTemp/modules*" -Destination "../modules" -Recurse -Force

  $rawUrl = "https://raw.githubusercontent.com/enigma-tek/PSCodeOrganizer/refs/heads/main/version.txt"
  $GitVerNum = (Invoke-WebRequest -Uri $rawUrl).Content
  $verPath = "../files/configs/codeOrg.json"
  $verU = @{
    Vers = $GitVerNum
  }
  $verU | ConvertTo-Json | SEt-Content $verPath

  Write-Host -ForegroundColor Yellow "  Code Organizer has been updated. Cleanup on exit. Press Enter to continue to Exit...`n"
  Pause
  exitFunk

}

Function exitFunk {

  Clear-Host
  Write-Host  -foregroundColor Magenta "`n `n      ============ Code Organizer Update Utility ============ `n"

  Write-Host -ForegroundColor Yellow "  Cleaning up temp files..."
  Start-Sleep -Seconds 2

  if (Test-Path -Path "../updateTemp") {
  Remove-Item -Path "../updateTemp" -Recurse -Force
  Write-Host -ForegroundColor Yellow "  Temp items cleaned up...`n"
  } else { Write-Host -ForegroundColor Yellow "  No temp items to clean up...`n"}

  Write-Host -ForegroundColor Yellow "  Stopping transcript...`n"
  Stop-Transcript

  Write-Host -ForegroundColor Red "Script exiting in 5 seconds..."
  Start-Sleep -Seconds 5

  exit
}


###----SCRIPT STARTS HERE---###

#Set the Title
$Title = "Code Organizer Update Utility"
$host.UI.RawUI.WindowTitle = $Title

#Set the windows size
Function Set-WindowSize {
Param([int]$ConWidth=$host.ui.rawui.windowsize.width,
      [int]$ConHeight=$host.ui.rawui.windowsize.heigth)

    $size=New-Object System.Management.Automation.Host.Size($ConWidth,$ConHeight)
    $host.ui.rawui.WindowSize=$size  
}
Set-WindowSize 199 80 *>$null

$scriptStartDateTime = Get-Date -Format HH.mm-MM.dd.yyyy
Start-Transcript -Path "./update/Logs/codeOrg_Updater_Log_$scriptStartDateTime.log"

Clear-Host
preChk
