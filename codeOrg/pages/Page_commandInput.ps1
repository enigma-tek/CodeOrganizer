Add-PodeWebPage -Name 'CommandsInput' -DisplayName 'Add Commands' -Hide -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebForm -Name 'cmdInputForm' -SubmitText 'Save' -Content @(

            New-PodeWebTextbox -Name 'theCmd' -DisplayName '*Command: ' -Required

            New-PodeWebTextBox -Name 'cmdRef' -DisplayName '*What this command does: ' -Required

            New-PodeWebTextBox -Name 'cmdOption' -DisplayName '*Required Options/Parameters: ' -Required -Multiline -HelpText "If the command doesnt have 
            any required option or parameters then type 'None' in the box"

            New-PodeWebTextBox -Name 'cmdParent' -DisplayName 'Parent Module (PS)'

            New-PodeWebTextbox -Name 'cmdExample' -DisplayName 'Command Example(s): ' -Multiline

            New-PodeWebSelect -Name 'cmdType' -DisplayName '*Language: ' -Options 'PowerShell' , 'PowerShell/.NET' , 'KQL' , 'SQL' -Required

            New-PodeWebTextBox -Name 'cmdNotes' -DisplayName 'Notes: ' -Multiline


        ) -ScriptBlock {

            $psNameExist = Get-ChildItem -Path "./files/commands/tbl" -File | ForEach-Object {$_.BaseName}

            if (($WebEvent.Data['theCmd']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                Out-PodeWebValidation -Name 'theCmd' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                RETURN
                }
               
            if ($psNameExist -Contains $WebEvent.Data['theCmd']) {
                Out-PodeWebValidation -Name 'theCmd' -Message "That Command was found in the files. Please look for it in the Commands table in the Code Hub."
                RETURN
                }

            $cmdMetaDataFull =  @{
                Command = ($WebEvent.Data['theCmd'])
                Ref = ($WebEvent.Data['cmdRef'])
                Opt = ($WebEvent.Data['cmdOption'])
                Parent = ($WebEvent.Data['cmdParent'])
                Ex = ($WebEvent.Data['cmdExample'])
                Lang = ($WebEvent.Data['cmdType'])
                Note = ($WebEvent.Data['cmdNotes'])
                }

            $cmdFullMeta = ($WebEvent.Data['theCmd']) + ".json"
            $cmdMetaDataFull| ConvertTo-Json | Set-Content "./files/commands/full/$cmdFullMeta"

            $cmdMetaDataTBL =  @{
                Command = ($WebEvent.Data['theCmd'])
                Ref = ($WebEvent.Data['cmdRef'])
                Lang = ($WebEvent.Data['cmdType'])
                }

            $cmdTBLMeta = ($WebEvent.Data['theCmd']) + ".json"
            $cmdMetaDataTBL| ConvertTo-Json | Set-Content "./files/commands/tbl/$cmdTBLMeta"
            
            Show-PodeWebModal -Id 1004

            Reset-PodeWebForm -Name 'cmdInputForm'
            
        }#End form scriptblock

    )#End container

}#End page scriptblock