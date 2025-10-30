Add-PodeWebPage -Name 'SQLUpdate' -DisplayName 'Update SQL Entry' -Hide -ScriptBlock {
    modals_funk
    
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'sqlEntryUpdate' -Content @(

            New-PodeWebText -Value 'Update your SQL information below and click save. If you are only chaning the name or the description then once your
            changes have been made, click save at the bottom of the page.' -InParagraph -CssClass 'brightWhite'
            
            New-PodeWebText -Value 'If you are changing the SQL code, then make sure to click the blue upload button
            at the top of the editor window prior to saving the page else you will lose your edits.' -InParagraph -CssClass 'brightWhite' -Style Italics

                $getSQLCacheName = Get-PodeCache -Key 'SQLC'
                $getsqlMetaName = $getSQLCacheName + ".json"
                $getsqlMetaData = Get-Content "./files/sql/sqlMeta/$getsqlMetaName" | ConvertFrom-Json
                        
                    $sqlQName = $getsqlMetaData.QName
                    $sqlDescription = $getsqlMetaData.Desc

                    New-PodeWebTextBox -Name 'sqlUpdateQName' -DisplayName '*Quick Name: ' -Value $sqlQName -CssClass 'brightWhite' -Required

                    New-PodeWebTextBox -Name 'sqlUpdateDesc' -DisplayName '*Description: ' -Multiline -Value $sqlDescription -CssClass 'brightWhite' -Required

                    $getSQLCacheName = Get-PodeCache -Key 'SQLC'
                    $getsqlCode = $getSQLCacheName + ".txt"
                    $sqlCodeDiplayEditor = Get-Content "./files/sql/sqlCode/$getsqlCode" -Raw
                    
                    New-PodeWebCodeEditor -Name 'SQL Editor View' -Language 'sql' -Value $sqlCodeDiplayEditor -Upload {
                        $pasteSQLTextUD = $WebEvent.Data | Select-Object Value
                        $pasteSQLTextUD = $pasteSQLTextUD.Value
                        Set-PodeCache -Key 'newSQLValue' -InputObject $pasteSQLTextUD
                        }

            ) -ScriptBlock {

                $getSQLCacheName = Get-PodeCache -Key 'SQLC'

                    if ($getSQLCacheName -eq $WebEvent.Data['sqlUpdateQName']) {

                        } else {
                            $sqlNameExist = Get-ChildItem -Path "./files/sql/sqlMeta" -File | ForEach-Object {$_.BaseName} 
                            if ($WebEvent.Data['sqlUpdateQName'] -in $sqlNameExist )  {
                                Out-PodeWebValidation -Name 'sqlUpdateQName' -Message "That name is already used, please choose a new name..."
                                RETURN
                                }
                            }

                    if (($WebEvent.Data['sqlUpdateQName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                        Out-PodeWebValidation -Name 'sqlUpdateQName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                        RETURN
                        }


                if ($getSQLCacheName -ne $WebEvent.Data['sqlUpdateQName']) {
                        
                    $oldMetaName = $getSQLCacheName + ".json"
                    $oldCodeName = $getSQLCacheName + ".txt"
            
                    $newBase = $WebEvent.Data['sqlUpdateQName']
                    $newMetaName = $newBase + ".json"
                    $newCodeName = $newBase + ".txt"
                    
                    $renameNameSQLCode = Move-Item -Path "./files/sql/sqlCode/$oldCodeName" -Destination "./files/sql/sqlCode/$newCodeName" -Force
                    $renameNameSQLCode | Out-Null
                    $renameNameSQLMeta = Move-Item -Path "./files/sql/sqlMeta/$oldMetaName" -Destination "./files/sql/sqlMeta/$newMetaName" -Force
                    $renameNameSQLMeta | Out-Null
            
                } else {
                    $newMetaName = $WebEvent.Data['sqlUpdateQName'] + '.json'
                    $newCodeName = $WebEvent.Data['sqlUpdateQName'] + ".txt"
                    }
                
                $sqlUpdateMetaDatafull =  @{
                    QName = $WebEvent.Data['sqlUpdateQName']
                    Desc = $WebEvent.Data['sqlUpdateDesc']  
                    }
                    $sqlUpdateMetaDatafull | ConvertTo-Json | Set-Content "./files/sql/sqlMeta/$newMetaName"

                $pasteNewSQLCode = Get-PodeCache -Key 'newSQLValue'

                if (([string]::IsNullOrEmpty($pasteNewSQLCode))) {
                #do nothing
                } else { 
                $pasteNewSQLCode | Set-Content -Path "./files/sql/sqlCode/$newCodeName"
                }

                Reset-PodeWebForm -Name 'sqlEntryUpdate'

                Move-PodeWebPage -Name 'CodeHub'

            }#End form scriptblock

        New-PodeWebButton -Name 'ReturnToSQLTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
            
            Remove-PodeCache -Key 'SQLC'
            Remove-PodeCache -Key 'newSQLValue'
                    
            Move-PodeWebPage -Name 'CodeHub'
        }#End button scriptblock

    )#End container

}#End page scriptblock