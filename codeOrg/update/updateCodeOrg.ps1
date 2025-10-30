Function close_codeOrganizer {

    try {
    $FormPID = Get-Content "C:\Program Files\Enigma-Tek\codeOrg\files\configs\pid.txt" -Verbose
    taskkill /pid $FormPID

        Start-Sleep -Seconds 4
                software_download
            } catch {
                Write-Output 'Taskkill failed to stop site. Exiting updater'
                exit_updateScript
            }
}

Function software_download {

}

Function exit_updateScript {

    $scriptStopDateTime = Get-Date -Format HH.mm-MM.dd.yyyy
        
    Write-Output "Script stopped at " $scriptStopDateTime
    Stop-Transcript

    EXIT
}




#-----Code Organizer update script starts here-----#

#Start transcript (log file)
$updateStartDateTime = Get-Date -Format HH.mm-MM.dd.yyyy
Start-Transcript -Path "C:\Program Files\Enigma-Tek\ASPC\Logs\Updater\ASPC_Updater_Log_$updateStartDateTime.log"
Write-Host "Starting script at " $scriptStartDateTime
#Calling first function
Close_Configurator
startDisplay