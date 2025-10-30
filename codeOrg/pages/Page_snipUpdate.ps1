Add-PodeWebPage -Name 'SnipUpdate' -DisplayName 'PS Snippet Update' -Hide -ScriptBlock {
    modals_funk

        New-PodeWebContainer -Content @(

         New-PodeWebForm -Name 'snipEntryUpdate' -Content @(

            New-PodeWebText -Value 'Update your Snippet information below and click save. If you are only changing the name or the description then once your
            changes have been made, click save at the bottom of the page. IF you are changing the Snippet code, then make sure to click the blue upload button
            at the top of the editor window prior to saving the page else you will lose your edits.' -InParagraph -CssClass 'brightWhite'

                $getSNIPCacheName = Get-PodeCache -Key 'PSSNIPP'
                $getSNIPMetaName = $getSNIPCacheName + ".json"
                $getSNIPMetaData = Get-Content "./files/powershell/snippetsMeta/$getSNIPMetaName" | ConvertFrom-Json
                        
                    $snipID = $getSNIPMetaData.ID
                    $snipDescription = $getSNIPMetaData.Desc
                    $snipCat = $getSNIPMetaData.Cat
                    $snipNote = $getSNIPMetaData.Note

                    New-PodeWebTextBox -Name 'snipIDRO' -DisplayName 'ID: ' -Value $snipID -CssClass 'brightWhite' -ReadOnly -HelpText 'Read Only'

                    New-PodeWebTextBox -Name 'snipUpdateDesc' -DisplayName 'Description: ' -Multiline -Value $snipDescription -CssClass 'brightWhite' -Required -HelpText 'Update Description'

                    New-PodeWebTextBox -Name 'snipUpdateCat' -DisplayName 'Catagory: ' -Value $snipCat -CssClass 'brightWhite' -Required -HelpText 'No list, manually update catagory if changing'

                    New-PodeWebTextBox -Name 'snipUpdateNote' -DisplayName 'Note: ' -Multiline -Value $snipNote -CssClass 'brightWhite' -Required -HelpText 'Update Note'

                    $getSNIPCacheName = Get-PodeCache -Key 'PSSNIPP'
                    $getSNIPCode = $getSNIPCacheName + ".txt"
                    $snipCodeDiplayEditor = Get-Content "./files/powershell/snippets/$getSNIPCode" -Raw
                    
                    New-PodeWebCodeEditor -Name 'SnippetUpdateView' -Language 'powershell' -Value $snipCodeDiplayEditor -Upload {
                        $pasteSNIPTextUD = $WebEvent.Data | Select-Object Value
                        $pasteSNIPTextUD = $pasteSNIPTextUD.Value
                        Set-PodeCache -Key 'newSnipValue' -InputObject $pasteSNIPTextUD
                        }

              

        ) -ScriptBlock {

                $snipIDWr = Get-PodeCache -Key 'PSSNIPP'
                $snipIDFin = $SNIPIDWr + ".json"
                $snipCodeID = $SNIPIDWr + ".txt"

                $snipUpdateMetaDatafull =  @{
                    ID = $WebEvent.Data['snipIDRO']
                    Desc = $WebEvent.Data['snipUpdateDesc']
                    Cat = $WebEvent.Data['snipUpdateCat']
                    Note = $WebEvent.Data['snipUpdateNote']
                    }
                $snipUpdateMetaDatafull | ConvertTo-Json | Set-Content "./files/powershell/snippetsMeta/$snipIDFin" | Out-Null

                
                $pasteNewSNIPCode = Get-PodeCache -Key 'newSnipValue'

                if (([string]::IsNullOrEmpty($pasteNewSNIPCode))) {
                #do nothing
                } else { 
                $pasteNewSNIPCode | Set-Content -Path "./files/powershell/snippets/$snipCodeID"
                }

                Reset-PodeWebForm -Name 'snipEntryUpdate'

                Move-PodeWebPage -Name 'CodeHub'

        }#End form scriptblock

            New-PodeWebButton -Name 'ReturnTosnipTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
                
                Remove-PodeCache -Key 'PSSNIPP'
                Remove-PodeCache -Key 'newSnipValue'
                        
                Move-PodeWebPage -Name 'CodeHub'
                
            }#End button 'ReturnTosnipTable' scriptblock

    )#End container

}#End snippet update page