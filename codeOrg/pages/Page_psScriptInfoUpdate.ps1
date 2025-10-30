Add-PodeWebPage -Name 'PSCodeInfoUpdate' -DisplayName 'PS Script Information Update' -Hide -ScriptBlock {
    modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'PSScriptEntryUpdate' -Content @(

            New-PodeWebText -Value 'Update your PS script information below and click save. If you do not choose new Catagories, Environment or Versions then the 
            current entries will be used. ' -InParagraph -CssClass 'brightWhite'

                $getPSCacheName = Get-PodeCache -Key 'PSSCRIPT'
                $getPSMetaName = $getPSCacheName + ".json"
                $getPSMetaData = Get-Content "./files/powershell/scriptsMeta/$getPSMetaName" | ConvertFrom-Json
                
                    $psMetaCats = $getPSMetaData.Cats
                    $psMetaCats = $psMetaCats -replace ",", ", "
                    $psMetaDesc = $getPSMetaData.Desc
                    $psMetaEnv = $getPSMetaData.Env
                    $psMetaVers = $getPSMetaData.Vers
                    $psMetaVers = $psMetaVers -replace ",", ", "
                    $psMetaName = $getPSMetaData.Name
                    $scMetaSys = $getPSMetaData.Sys
                    $scMetaNotes = $getPSMetaData.Note

                    $catOptions = Import-CSV -Path "./files/configs/formCatagories.csv"
                    $envOptions = Import-CSV -Path "./files/configs/formEnvironments.csv"
                    $verOptions = Import-CSV -Path "./files/configs/formPSVersions.csv"

                    New-PodeWebTextBox -Name 'psUpdateName' -DisplayName '*Name: ' -Value $psMetaName -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'psUpdateDesc' -DisplayName '*Description: ' -Multiline -Value $psMetaDesc -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'psCurrentCats' -DisplayName 'Current Catagories:' -Value $psMetaCats -ReadOnly

                    New-PodeWebText -Value 'Due to form limitations, you must re-choose your Catagories before saving.' -InParagraph -Alignment Center -CssClass 'coral'

                    New-PodeWebSelect -Name 'updateCatOptions' -DisplayName '*Catagories: ' -Options $catOptions.name -Multiple -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'psCurrentEnv' -DisplayName 'Current Environment:' -Value $psMetaEnv -ReadOnly

                    New-PodeWebSelect -Name 'updateEnvOptions' -DisplayName '*Environment: ' -Options $envOptions.env -CssClass 'brightWhite'
        
                    New-PodeWebTextBox -Name 'psCurrentVers' -DisplayName 'Current PS Versions:' -Value $psMetaVers -ReadOnly

                    New-PodeWebText -Value 'Due to form limitations, you must re-choose your PS Versions before saving.' -InParagraph -Alignment Center -CssClass 'coral'

                    New-PodeWebSelect -Name 'updateVerOptions' -DisplayName '*PS Versions: ' -Options $verOptions.versions -Multiple -CssClass 'brightWhite' -Required

                    New-PodeWebTextbox -Name 'updateSystemOption' -DisplayName 'System On: ' -Value $scMetaSys -CssClass 'brightWhite'

                    New-PodeWebTextbox -Name 'updateNotesOption' -DisplayNAme 'Notes/Instructions: ' -Value $scMetaNotes -Multiline -CssClass 'brightWhite'

            ) -ScriptBlock {

                    $getPSCacheName = Get-PodeCache -Key 'PSSCRIPT'

                        if ($getPSCacheName -eq $WebEvent.Data['psUpdateName']) {

                        } else {
                            $psNameExist = Get-ChildItem -Path "./files/powershell/scripts" -File | ForEach-Object {$_.BaseName} 
                            if ($WebEvent.Data['psUpdateName'] -in $psNameExist )  {
                                Out-PodeWebValidation -Name 'psUpdateName' -Message "That name is already used, please choose a new name..."
                                RETURN
                                }
                            }

                        if (($WebEvent.Data['psUpdateName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                            Out-PodeWebValidation -Name 'psUpdateName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                            RETURN
                        }

                        $newCatChk = $WebEvent.Data['updateCatOptions']
                        if ([string]::IsNullOrEmpty($newCatChk)) {
                            $udCatsFin = $psMetaCats
                        } else { 
                            $udCatsFin = $WebEvent.Data['updateCatOptions']
                        }

                        $newEnvChk = $WebEvent.Data['updateEnvOptions']
                        if ([string]::IsNullOrEmpty($newEnvChk)) {
                            $udEnvFin = $WebEvents.Data['psCurrentEnv']
                        } else { 
                            $udEnvFin = $WebEvent.Data['updateEnvOptions']
                        }

                        $newVerChk = $WebEvent.Data['updateVerOptions']
                        if ([string]::IsNullOrEmpty($newVerChk)) {
                            $udVerFin = $WebEvents.Data['psCurrentVers']
                        } else { 
                            $udVerFin = $WebEvent.Data['updateVerOptions']
                        }

                        $newSysChk = $WebEvent.Data['updateSystemOption']
                         if ([string]::IsNullOrEmpty($newSysChk)) {
                            $udSysFin = "None"
                        } else { 
                            $udsysFin = $WebEvent.Data['updateSystemOption']
                        }

                        $newNoteChk = $WebEvent.Data['updateNotesOption']
                         if ([string]::IsNullOrEmpty($newNoteChk)) {
                            $udNoteFin = "None"
                        } else { 
                            $udNoteFin = $WebEvent.Data['updateNotesOption']
                        }

                        #update file names if the script is renamed in the form above
                        
                        if ($getPSCacheName -ne $WebEvent.Data['psUpdateName']) {
                        
                            $oldScrName = $getPSCacheName + ".ps1"
                            $oldHTMLName = $getPSCacheName + ".html"
                            $oldMetaName = $getPSCacheName + ".json"
                    
                            $newBase = $WebEvent.Data['psUpdateName']
                            $newScrName = $newBase + ".ps1"
                            $newHTMLName = $newBase + ".html"
                            $newMetaName = $newBase + ".json"
                            
                            $renameName = Move-Item -Path "./files/powershell/scripts/$oldScrName" -Destination "./files/powershell/scripts/$newScrName" -Force
                            $renameName | Out-Null
                            $renameHTML = Move-Item -Path "./files/powershell/scriptsHTML/$oldHTMLName" -Destination "./files/powershell/scriptsHTML/$newHTMLName" -Force
                            $renameHTML | Out-Null
                            $renameMeta = Move-Item -Path "./files/powershell/scriptsMeta/$oldMetaName" -Destination "./files/powershell/scriptsMeta/$newMetaName" -Force
                            $renameMeta | Out-Null
                        } else {
                            $newMetaName = $WebEvent.Data['psUpdateName'] + '.json'
                            }

                        
                        $psUpdateMetaData =  @{
                            Name = $WebEvent.Data['psUpdateName']
                            Desc = $WebEvent.Data['psUpdateDesc']
                            Cats = $udCatsFin
                            Env = $udEnvFin
                            Vers = $udVerFin
                            Sys = $udSysFin
                            Note = $udNoteFin
                            }
                        
                        $psUpdateMetaData | ConvertTo-Json | Set-Content "./files/powershell/scriptsMeta/$newMetaName"
                        
                        Reset-PodeWebForm -Name 'PSScriptEntryUpdate'

                        Move-PodeWebPage -Name 'CodeHub'

                        Move-PodeWebTab -Name 'PS Snippets'
                    
        }#End form scriptblock

    )#End container
    
}#End page scriptblock