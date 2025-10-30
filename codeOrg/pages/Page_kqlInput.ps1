Add-PodeWebPage -Name 'KQLInput' -DisplayName 'Add KQL' -Hide -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'kqlInputForm' -SubmitText 'Save' -Content @(

            New-PodeWebTextbox -Name 'kqlQName' -DisplayName '*Quick Name: ' -Required -HelpText "A quick reference name."

            New-PodeWebTextBox -Name 'kqlDesc' -DisplayName '*Description: ' -Required -Multiline

            New-PodeWebCodeEditor -Name 'KQLEditor' -Language 'sql' -upload {
    
            $pasteKQLText = $WebEvent.Data | Select-Object Value
            $pasteKQLText = $pasteKQLText.Value
            Set-PodeCache -Key 'KQLPaste' -InputObject $pasteKQLText
            }

        ) -ScriptBlock {

            $kqlNameExist = Get-ChildItem -Path "./files/kql/kqlMeta" -File | ForEach-Object {$_.BaseName}

                if ($WebEvent.Data['kqlQName'] -in $kqlNameExist )  {
                    Out-PodeWebValidation -Name 'kqlQName' -Message "That name is already used, please choose a new name..."
                    RETURN
                    }

                if (($WebEvent.Data['kqlQName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                    Out-PodeWebValidation -Name 'kqlQName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                    RETURN
                    }

                $kqlpasteChk = Get-PodeCache -Key 'KQLPaste'
                if (([string]::IsNullOrEmpty($kqlpasteChk))) {
                    Update-PodeWebText -Id 4002 -Value 'KQL editor entry is blank...'
                    
                    Update-PodeWebText -Id 4005 -Value 'Before hitting submit on the form, please paste your KQL and hit the upload button 
                    at the top of the editor.'
                    
                    Show-PodeWebModal -Id 4001 -DataValue $WebEvent.Data.Value
                    RETURN
                }

            $KQLMetaDataFull =  @{
                QName = ($WebEvent.Data['kqlQName'])
                Desc = ($WebEvent.Data['kqlDesc'])
                }

            $kqlFullMeta = ($WebEvent.Data['kqlQName']) + ".json"
            $KQLMetaDataFull| ConvertTo-Json | Set-Content "./files/kql/kqlMeta/$kqlFullMeta"

            $kqlGetPaste = Get-PodeCache -Key 'KQLPaste'
            $kqlFullCode = ($WebEvent.Data['kqlQName']) + ".txt"
            $kqlUploadPath = "./files/kql/kqlCode/$kqlFullCode"

            New-Item -Path $kqlUploadPath -ItemType File -Value $kqlGetPaste| Out-Null
            
            Show-PodeWebModal -Id 1006

            Reset-PodeWebForm -Name 'kqlInputForm'
            
        }#End form scriptblock

    )#End container

}#End page scriptblock