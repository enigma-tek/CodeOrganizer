function updateCodeOrg {

Write-Host  -foregroundColor Magenta "`n `n      ============ TS2 Site Cert install/update tool ============ `n"
Write-Host  -foregroundColor Yellow "    This tool is for installing or updating the site certificate for Truststore2"
Write-Host "`n"



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

Clear-Host
updateCodeOrg