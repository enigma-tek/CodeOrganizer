Add-PodeWebPage -Name 'CMDUpdate' -Hide -DisplayName 'Update Command Entry' -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'cmdEntryUpdate' -Content @(

            New-PodeWebText -Value 'Update your Command information below and click save.' -InParagraph -CssClass 'brightWhite'

                $getCMDCacheName = Get-PodeCache -Key 'CMDC'
                $getCMDMetaName = $getCMDCacheName + ".json"
                $getcmdMetaData = Get-Content "./files/commands/full/$getCMDMetaName" | ConvertFrom-Json
                
                    $cmdMetaCommand = $getcmdMetaData.Command
                    $cmdMetaRef = $getcmdMetaData.Ref
                    $cmdMetaOpt = $getcmdMetaData.Opt
                    $cmdMetaParent = $getcmdMetaData.Parent
                    $cmdMetaLang = $getcmdMetaData.Lang
                    $cmdMetaEx = $getcmdMetaData.Ex
                    $cmdMetaNotes = $getcmdMetaData.Note

                    New-PodeWebTextBox -Name 'cmdUpdateCommand' -DisplayName '*Command: ' -Value $cmdMetaCommand -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'cmdUpdateRef' -DisplayName '*Description: ' -Multiline -Value $cmdMetaRef -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'cmdUpdateOpt' -DisplayName '*Options/Parameters:' -Value $cmdMetaOpt -Required -HelpText "If the command doesnt have 
                    any required option or parameters then type 'None' in the box"

                    New-PodeWebTextBox -Name 'cmdUpdateParent' -DisplayName 'Parent Module(PS):' -Value $cmdMetaParent  
                    
                    New-PodeWebSelect -Name 'cmdUpdateLang' -DisplayName '*Language: ' -Options 'PowerShell' , 'PowerShell/.NET' , 'KQL' , 'SQL' -SelectedValue $cmdMetaLang -Required                   

                    New-PodeWebTextbox -Name 'cmdUpdateEx' -DisplayNAme 'Examples: ' -Value $cmdMetaEx -Multiline -CssClass 'brightWhite'

                    New-PodeWebTextbox -Name 'cmdUpdateNotes' -DisplayNAme 'Notes: ' -Value $cmdMetaNotes -Multiline -CssClass 'brightWhite'

            ) -ScriptBlock {

                    $getCMDCacheName = Get-PodeCache -Key 'CMDC'

                        if ($getCMDCacheName -eq $WebEvent.Data['cmdUpdateCommand']) {

                            } else {
                                $cmdNameExist = Get-ChildItem -Path "./files/commands/tbl" -File | ForEach-Object {$_.BaseName} 
                                if ($WebEvent.Data['cmdUpdateCommand'] -in $cmdNameExist )  {
                                    Out-PodeWebValidation -Name 'cmdUpdateCommand' -Message "That name is already used, please choose a new name..."
                                    RETURN
                                    }
                                }

                        if (($WebEvent.Data['cmdUpdateCommand']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                            Out-PodeWebValidation -Name 'cmdUpdateCommand' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                            RETURN
                        }

                        #update file names if the script is renamed in the form above
                        
                        if ($getCMDCacheName -ne $WebEvent.Data['cmdUpdateCommand']) {
                        
                            $oldMetaName = $getCMDCacheName + ".json"
                    
                            $newBase = $WebEvent.Data['cmdUpdateCommand']
                            $newMetaName = $newBase + ".json"
                            
                            $renameNametbl = Move-Item -Path "./files/commands/full/$oldMetaName" -Destination "./files/commands/full/$newMetaName" -Force
                            $renameNametbl | Out-Null
                            $renameNamefull = Move-Item -Path "./files/commands/tbl/$oldMetaName" -Destination "./files/commands/tbl/$newMetaName" -Force
                            $renameNamefull | Out-Null
                    
                        } else {
                            $newMetaName = $WebEvent.Data['cmdUpdateCommand'] + '.json'
                            }

                        $cmdUpdateMetaDatafull =  @{
                            Command = $WebEvent.Data['cmdUpdateCommand']
                            Lang = $WebEvent.Data['cmdUpdateLang']
                            Note = $WebEvent.Data['cmdUpdateNotes']
                            Ref = $WebEvent.Data['cmdUpdateRef']
                            Parent = $WebEvent.Data['cmdUpdateParent']
                            Ex = $WebEvent.Data['cmdUpdateEx']
                            Opt = $WebEvent.Data['cmdUpdateOpt']
                            }

                        $cmdUpdateMetaDatafull | ConvertTo-Json | Set-Content "./files/commands/full/$newMetaName"

                        $cmdUpdateMetaDatatbl =  @{
                            Command = $WebEvent.Data['cmdUpdateCommand']
                            Lang = $WebEvent.Data['cmdUpdateLang']
                            Ref = $WebEvent.Data['cmdUpdateRef']
                            }
                        
                        $cmdUpdateMetaDatatbl | ConvertTo-Json | Set-Content "./files/commands/tbl/$newMetaName"
                        
                        Reset-PodeWebForm -Name 'cmdEntryUpdate'

                        Move-PodeWebPage -Name 'CodeHub'
                    
        }#End form scriptblock

        New-PodeWebButton -Name 'ReturnTocmdTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
                
            Remove-PodeCache -Key 'CMDC'
                    
            Move-PodeWebPage -Name 'CodeHub'
            }#End button scriptblock

    )#End container

}#End page scriptblock