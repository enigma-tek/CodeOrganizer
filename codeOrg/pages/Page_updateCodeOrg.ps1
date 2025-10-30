#Update page. Checks to see if there is an update and then displays that at the top of the page. If update is available, show update button and update text.
Add-PodeWebPage -Name 'Update' -DisplayName 'Update' -Group 'Settings' -Icon 'update' -Layouts @(

    New-PodeWebContainer -Content @(

        New-PodeWebParagraph -Elements @(
        New-PodeWebText -Value 'Current Installed Version:  ' -CssClass 'brightWhite' -Style Bold
        New-PodeWebText -Id 0051 -Value '' -CssClass 'orange'
        )

        New-PodeWebParagraph -Elements @(
        New-PodeWebText -Value 'Current Available Version:  ' -CssClass 'brightWhite' -Style Bold
        New-PodeWebText -Id 0052 -Value '' -CssClass 'orange'
        )
        
        New-PodeWebText -Id 0050 -Value '' -CssClass 'lawnGreen'
        New-PodeWebText -Id 0053 -Value '' -CssClass 'gold' -InParagraph
        New-PodeWebText -Id 0055 -Value "" -CssClass 'brightWhite' -InParagraph

    )#End container

#This section checks the online version info against the local version info and if the version online is higher, un-greys the update button and allows the 
#user to update Code Organizer. It also displays the versions and updates screen text based on the version evaluation

#This passthrough is what allows the page event to trigger. The page event is a page 'load' event that executes the scriptblock below.
) -PassThru | Register-PodeWebPageEvent -Type Load -ScriptBlock {
            
    #Get the local version number
    $chkUpdate = Get-Content "./files/configs/codeOrg.json" | ConvertFrom-Json
    $updateVersion = $chkUpdate.Vers

    #Get the online version number
    $rawUrl = "https://raw.githubusercontent.com/enigma-tek/PSCodeOrganizer/refs/heads/main/version.txt"
    $GitVerNum = (Invoke-WebRequest -Uri $rawUrl).Content

    #convert both versions into system versions to be able to compare
    $updateVersion = [System.Version]$updateVersion
    $GitVerNum = [System.Version]$GitVerNum

    #If the online version is higher, then say on screen and un grey the update button built in the page layouts above. Displays the versions and next steps to update.
    if ($updateVersion -lt $GitVerNum) {
        Update-PodeWebText -Id 0051 -Value $updateVersion
        Update-PodeWebText -Id 0052 -Value $GitVerNum
        Update-PodeWebText -Id 0053 -Value 'There is an update available for Code Organizer.'
        Update-PodeWebText -Id 0055 -Value "To update Code Organizer, you will need to run the updater from the bin folder. Instructions are in the Wiki. Click the 
        Project Repo button in the top Nav Bar. Go to the Wiki and follow the 'How to Update' instructions."
       
    
    #If the versions are the same then display the versions, let the user know that everything is up to date
    } else {
        Update-PodeWebText -Id 0051 -Value $updateVersion
        Update-PodeWebText -Id 0052 -Value $GitVerNum
        Update-PodeWebText -Id 0050 -Value 'Code organizer is up to date.'
    }

    #The following section gets the version number of the update script and compares it with the local version number. If the online version of the script is greater
    #than the local version, then update script is automatically updated.

    #Get the local version number of the update scripts
    $chkUUpdate = Get-Content "./update/updater.json" | ConvertFrom-Json
    $UupdateVersion = $chkUUpdate.Vers

    #Get the online version number of the update script
    $rawUrl = "https://raw.githubusercontent.com/enigma-tek/PSCodeOrganizer/refs/heads/main/uversion.txt"
    $UGitVerNum = (Invoke-WebRequest -Uri $rawUrl).Content

    #convert both versions into system versions to be able to compare
    $UupdateVersion = [System.Version]$UupdateVersion
    $UGitVerNum = [System.Version]$UGitVerNum

    if ($updateVersion -lt $GitVerNum) {
        Remove-Item -Path "./update/updateCodeOrg.ps1" -Verbose
        Remove-Item -Path "./update/updater.json" -Verbose
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/enigma-tek/CodeOrganizer/refs/heads/main/update/updateCodeOrg.ps1" -OutFile "./update/updateCodeOrg.ps1"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/enigma-tek/CodeOrganizer/refs/heads/main/update/updater.json" -OutFile "./update/updater.json"
    }    




}#End page scriptblock