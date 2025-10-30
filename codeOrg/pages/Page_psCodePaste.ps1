Add-PodeWebPage -Name 'PSCodePaste' -DisplayName 'PS Code Paste' -Hide -ScriptBlock {
    modals_funk
    New-PodeWebContainer -Content @(
        
        New-PodeWebForm -Name 'newPSScriptPaste' -SubmitText 'Submit' -Content @(

            New-PodeWebText -Value 'Choose a name for the script.' -InParagraph -CssClass 'brightWhite'
            New-PodeWebText -Value 'Give a detailed description, not only will it help you remember what the script is for, but it can be used in advanced searches.' -InParagraph -CssClass 'brightWhite'
            New-PodeWebText -Value "The Catagories and Versions options are one/multiple choice (hold down the CTRL key to select multiple). 
            The Environment is single select. System and notes are not required, but if left empty the word 'none' will be added." -InParagraph -CssClass 'brightWhite'

            New-PodeWebTextbox -Name 'newPSPasteName' -DisplayName '*Script Name: ' -Required

            New-PodeWebTextbox -Name 'newPSPasteDesc' -DisplayName '*Description: ' -Multiline -Required

            $catOptions = Import-CSV -Path "./files/configs/formCatagories.csv"
            $envOptions = Import-CSV -Path "./files/configs/formEnvironments.csv"
            $verOptions = Import-CSV -Path "./files/configs/formPSVersions.csv"

            New-PodeWebSelect -Name 'newPSPasteCatOpts' -DisplayName '*Catagories: ' -Options $catOptions.name -Multiple -Required

            New-PodeWebSelect -Name 'newPSPasteEnvOpts' -DisplayName '*Environment: ' -Options $envOptions.env -Required

            New-PodeWebSelect -Name 'newPSPasteVerOpts' -DisplayName '*PS Versions: ' -Options $verOptions.versions -Multiple -Required

            New-PodeWebTextbox -Name 'newPSPasteSystem' -DisplayName 'System On: ' 

            New-PodeWebTextbox -NAme 'newPSPasteNotes' -DisplayNAme 'Notes/Instructions: ' -Multiline
            
            New-PodeWebCodeEditor -Name 'Editor' -Language 'powershell' -upload {
        
                $pasteScriptText = $WebEvent.Data | Select-Object Value
                $pasteScriptText = $pasteScriptText.Value
                Set-PodeCache -Key 'PsPaste' -InputObject $pasteScriptText
                }
            
            ) -ScriptBlock {

                $psNameExist = Get-ChildItem -Path "./files/powershell/scripts" -File | ForEach-Object {$_.BaseName} 
                $pasteChk = Get-PodeCache -Key 'PsPaste'

                if (($WebEvent.Data['newPSPasteName']) -contains $psNameExist ) {
                    Out-PodeWebValidation -Name 'newPSPasteName' -Message "That name is already used, please choose a new name..."
                    Return
                } elseif (($WebEvent.Data['newPSPasteName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                    Out-PodeWebValidation -Name 'newPSPasteName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                    Return
                } elseif (([string]::IsNullOrEmpty($pasteChk))) {
                    Update-PodeWebText -Id 4002 -Value 'Script text entry is blank...'
                    Update-PodeWebText -Id 4005 -Value 'Before hitting submit on the form, please paste your script and hit the upload button 
                    at the top of the editor.'
                    Show-PodeWebModal -Id 4001 -DataValue $WebEvent.Data.Value
                    Return
                } else {}

            #Upload the script to a server folder
            $scriptFullName = ($WebEvent.Data['newPSPasteName']) + ".ps1"

            $scriptUploadPath = "./files/powershell/scripts/$scriptFullName"

             New-Item -Path $scriptUploadPath -ItemType File -Value $pasteChk | Out-Null

            #Create a metadata file for that script
            if(!$WebEvent.Data['newPSPasteSystem']) {
                $WebEvent.Data['newPSPasteSystem'] = 'none'
            } else {}
            if(!$WebEvent.Data['newPSPasteNotes']) {
                $WebEvent.Data['newPSPasteNotes'] = 'none'
            } else {}

            $psScriptMetaData =  @{
                Name = ($WebEvent.Data['newPSPasteName'])
                Desc = ($WebEvent.Data['newPSPasteDesc'])
                Cats = ($WebEvent.Data['newPSPasteCatOpts'])
                Env = ($WebEvent.Data['newPSPasteEnvOpts'])
                Vers = ($WebEvent.Data['newPSPasteVerOpts'])
                Sys = ($WebEvent.Data['newPSPasteSystem'])
                Note = ($WebEvent.Data['newPSPasteNotes'])
                }

            $scriptFullMeta = ($WebEvent.Data['newPSPasteName']) + ".json"
            $psScriptMetaData | ConvertTo-Json | Set-Content "./files/powershell/scriptsMeta/$scriptFullMeta"

            $convScriptHtml = ConvPS1ToHTML -htmlInPath $scriptUploadPath -htmlInName ($WebEvent.Data['newPSPasteName'])
            $convScriptHtml | Out-Null
            
            Show-PodeWebModal -Id 1002
            
            Clear-PodeWebCodeEditor -Name 'Editor'
            Reset-PodeWebForm -Name 'newPSScriptPaste'

        }#End form 'newPSScriptPaste'
    )#End container Paste Scripts

}#end page scriptblock