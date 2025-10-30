Add-PodeWebPage -Name 'KQLUpdate' -DisplayName 'Update KQL Entry' -Hide -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'kqlEntryUpdate' -Content @(

            New-PodeWebText -Value 'Update your KQL information below and click save. If you are only chaning the name or the description then once your
            changes have been made, click save at the bottom of the page.' -InParagraph -CssClass 'brightWhite'
            
            New-PodeWebText -Value 'If you are changing the KQL code, then make sure to click the blue upload button
            at the top of the editor window prior to saving the page else you will lose your edits.' -InParagraph -CssClass 'brightWhite' -Style Italics

                $getKQLCacheName = Get-PodeCache -Key 'KQLC'
                $getkqlMetaName = $getKQLCacheName + ".json"
                $getkqlMetaData = Get-Content "./files/kql/kqlMeta/$getkqlMetaName" | ConvertFrom-Json
                        
                    $kqlQName = $getkqlMetaData.QName
                    $kqlDescription = $getkqlMetaData.Desc

                    New-PodeWebTextBox -Name 'kqlUpdateQName' -DisplayName '*Quick Name: ' -Value $kqlQName -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'kqlUpdateDesc' -DisplayName '*Description: ' -Multiline -Value $kqlDescription -CssClass 'brightWhite' -Required

                    $getKQLCacheName = Get-PodeCache -Key 'KQLC'
                    $getkqlCode = $getKQLCacheName + ".txt"
                    $kqlCodeDiplayEditor = Get-Content "./files/kql/kqlCode/$getkqlCode" -Raw
                    
                    New-PodeWebCodeEditor -Name 'KQL Editor View' -Language powershell -Value $kqlCodeDiplayEditor -Upload {
                        $pasteKQLTextUD = $WebEvent.Data | Select-Object Value
                        $pasteKQLTextUD = $pasteKQLTextUD.Value
                        Set-PodeCache -Key 'newKQLValue' -InputObject $pasteKQLTextUD
                        }

            ) -ScriptBlock {

                $getKQLCacheName = Get-PodeCache -Key 'KQLC'

                    if ($getKQLCacheName -eq $WebEvent.Data['kqlUpdateQName']) {

                        } else {
                            $kqlNameExist = Get-ChildItem -Path "./files/kql/kqlMeta" -File | ForEach-Object {$_.BaseName} 
                            if ($WebEvent.Data['kqlUpdateQName'] -in $kqlNameExist )  {
                                Out-PodeWebValidation -Name 'kqlUpdateQName' -Message "That name is already used, please choose a new name..."
                                RETURN
                                }
                            }

                    if (($WebEvent.Data['kqlUpdateQName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                        Out-PodeWebValidation -Name 'kqlUpdateQName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                        RETURN
                        }


                if ($getKQLCacheName -ne $WebEvent.Data['kqlUpdateQName']) {
                        
                    $oldMetaName = $getKQLCacheName + ".json"
                    $oldCodeName = $getKQLCacheName + ".txt"
            
                    $newBase = $WebEvent.Data['kqlUpdateQName']
                    $newMetaName = $newBase + ".json"
                    $newCodeName = $newBase + ".txt"
                    
                    $renameNameKQLCode = Move-Item -Path "./files/kql/kqlCode/$oldCodeName" -Destination "./files/kql/kqlCode/$newCodeName" -Force
                    $renameNameKQLCode | Out-Null
                    $renameNameKQLMeta = Move-Item -Path "./files/kql/kqlMeta/$oldMetaName" -Destination "./files/kql/kqlMeta/$newMetaName" -Force
                    $renameNameKQLMeta | Out-Null
            
                } else {
                    $newMetaName = $WebEvent.Data['kqlUpdateQName'] + '.json'
                    $newCodeName = $WebEvent.Data['kqlUpdateQName'] + '.txt'
                    }
                
                $kqlUpdateMetaDatafull =  @{
                    QName = $WebEvent.Data['kqlUpdateQName']
                    Desc = $WebEvent.Data['kqlUpdateDesc']  
                    }
                    $kqlUpdateMetaDatafull | ConvertTo-Json | Set-Content "./files/kql/kqlMeta/$newMetaName"

                $pasteNewKQLCode = Get-PodeCache -Key 'newKQLValue'

                if (([string]::IsNullOrEmpty($pasteNewKQLCode))) {
                #do nothing
                } else { 
                $pasteNewKQLCode | Set-Content -Path "./files/kql/kqlCode/$newCodeName"
                }

                Reset-PodeWebForm -Name 'cmdEntryUpdate'

                Move-PodeWebPage -Name 'CodeHub'

        }#End form scriptblock

        New-PodeWebButton -Name 'ReturnTocmdTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
            
            Remove-PodeCache -Key 'KQLC'
            Remove-PodeCache -Key 'newKQLValue'
                    
            Move-PodeWebPage -Name 'CodeHub'
            }#End button scriptblock

    )#End container

}#End page scriptblock

