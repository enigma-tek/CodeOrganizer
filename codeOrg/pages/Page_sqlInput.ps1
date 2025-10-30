Add-PodeWebPage -Name 'SQLInput' -DisplayName 'Add SQL' -Hide -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'sqlInputForm' -SubmitText 'Save' -Content @(

            New-PodeWebTextbox -Name 'sqlQName' -DisplayName '*Quick Name: ' -Required -HelpText "A quick reference name."

            New-PodeWebTextBox -Name 'sqlDesc' -DisplayName '*Description: ' -Required -Multiline

            New-PodeWebCodeEditor -Name 'SQLEditor' -Language 'sql' -upload {
    
            $pasteSQLText = $WebEvent.Data | Select-Object Value
            $pasteSQLText = $pasteSQLText.Value
            Set-PodeCache -Key 'SqlPaste' -InputObject $pasteSQLText
            }

        ) -ScriptBlock {

            $sqlNameExist = Get-ChildItem -Path "./files/sql/sqlMeta" -File | ForEach-Object {$_.BaseName}

                if ($WebEvent.Data['sqlQName'] -in $sqlNameExist )  {
                    Out-PodeWebValidation -Name 'sqlQName' -Message "That name is already used, please choose a new name..."
                    RETURN
                    }

                if (($WebEvent.Data['sqlQName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                    Out-PodeWebValidation -Name 'sqlQName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                    RETURN
                    }

                $sqlpasteChk = Get-PodeCache -Key 'SqlPaste'
                if (([string]::IsNullOrEmpty($sqlpasteChk))) {
                    Update-PodeWebText -Id 4002 -Value 'SQL editor entry is blank...'
                    
                    Update-PodeWebText -Id 4005 -Value 'Before hitting submit on the form, please paste your SQL and hit the upload button 
                    at the top of the editor.'
                    
                    Show-PodeWebModal -Id 4001 -DataValue $WebEvent.Data.Value
                    RETURN
                }

            $SQLMetaDataFull =  @{
                QName = ($WebEvent.Data['sqlQName'])
                Desc = ($WebEvent.Data['sqlDesc'])
                }

            $sqlFullMeta = ($WebEvent.Data['sqlQName']) + ".json"
            $SQLMetaDataFull| ConvertTo-Json | Set-Content "./files/sql/sqlMeta/$sqlFullMeta"

            $sqlGetPaste = Get-PodeCache -Key 'SQLPaste'
            $sqlFullCode = ($WebEvent.Data['sqlQName']) + ".txt"
            $sqlUploadPath = "./files/sql/sqlCode/$sqlFullCode"

            New-Item -Path $sqlUploadPath -ItemType File -Value $sqlGetPaste | Out-Null

            Show-PodeWebModal -Id 1005

            Reset-PodeWebForm -Name 'sqlInputForm'
            
        }#End form scriptblock

    )#End container

}#End page scriptblock