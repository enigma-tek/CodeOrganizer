Add-PodeWebPage -Name 'PSCodeUpload' -DisplayName 'PS Code Upload' -Hide -ScriptBlock {
    modals_funk
    New-PodeWebContainer -Content @(
        
        New-PodeWebForm -Name 'newPSScript' -SubmitText 'Submit' -Content @(

            New-PodeWebText -Value 'Choose a name for the script. The stored name will be the one you type in below, not the name of the uploaded script.' -InParagraph -CssClass 'brightWhite'
            New-PodeWebText -Value 'Give a detailed description, not only will it help you remember what the script is for, but it can be used in advanced searches.' -InParagraph -CssClass 'brightWhite'
            New-PodeWebText -Value "The Catagories and Versions options are one/multiple choice (hold down the CTRL key to select multiple). 
            The Environment is single select. System and notes are not required, but if left empty the word 'none' will be added." -InParagraph -CssClass 'brightWhite'

            New-PodeWebTextbox -Name 'newPSSName' -DisplayName '*Script Name: ' -Required

            New-PodeWebTextbox -Name 'newPSSDesc' -DisplayName '*Description: ' -Multiline -Required

            New-PodeWebFileUpload -Name 'newPSSPS1' -DisplayName '*Script File: ' -Accept '.ps1' -Required

            $catOptions = Import-CSV -Path "./files/configs/formCatagories.csv"
            $envOptions = Import-CSV -Path "./files/configs/formEnvironments.csv"
            $verOptions = Import-CSV -Path "./files/configs/formPSVersions.csv"

            New-PodeWebSelect -Name 'newPSSCatOpts' -DisplayName '*Catagories: ' -Options $catOptions.name -Multiple -Required

            New-PodeWebSelect -Name 'newPSSEnvOpts' -DisplayName '*Environment: ' -Options $envOptions.env -Required

            New-PodeWebSelect -Name 'newPSSVerOpts' -DisplayName '*PS Versions: ' -Options $verOptions.versions -Multiple -Required

            New-PodeWebTextbox -Name 'newPSSSystem' -DisplayName 'System On: ' 

            New-PodeWebTextbox -NAme 'newPSNotes' -DisplayNAme 'Notes/Instructions: ' -Multiline

            
            ) -ScriptBlock {

                $psNameExist = Get-ChildItem -Path "./files/powershell/scripts" -File | ForEach-Object {$_.BaseName}
               
                if ($psNameExist -Contains $WebEvent.Data['newPSSName']) {
                    Out-PodeWebValidation -Name 'newPSSName' -Message "That name is already used, please choose a new name..."
                    RETURN
                } elseif (($WebEvent.Data['newPSSName']).IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
                    Out-PodeWebValidation -Name 'newPSSName' -Message "A Filename cannot have certain characters in it. Remove invalid characters..."
                    RETURN
                } else {}

            #Upload the script to a server folder
            $scriptFullName = ($WebEvent.Data['newPSSName']) + ".ps1"

            $scriptUploadPath = "./files/powershell/scripts/$scriptFullName"

            Save-PodeRequestFile -Key 'newPSSPS1' -Path $scriptUploadPath

            #Create a metadata file for that script

            if(!$WebEvent.Data['newPSSSystem']) {
                $WebEvent.Data['newPSSSystem'] = 'none'
            } else {}
            if(!$WebEvent.Data['newPSNotes']) {
                $WebEvent.Data['newPSNotes'] = 'none'
            } else {}

            $psScriptMetaData =  @{
                Name = ($WebEvent.Data['newPSSName'])
                Desc = ($WebEvent.Data['newPSSDesc'])
                Cats = ($WebEvent.Data['newPSSCatOpts'])
                Env = ($WebEvent.Data['newPSSEnvOpts'])
                Vers = ($WebEvent.Data['newPSSVerOpts'])
                Sys = ($WebEvent.Data['newPSSSystem'])
                Note = ($WebEvent.Data['newPSNotes'])
                }

            $scriptFullMeta = ($WebEvent.Data['newPSSName']) + ".json"
            $psScriptMetaData | ConvertTo-Json | Set-Content "./files/powershell/scriptsMeta/$scriptFullMeta"

            $convScriptHtml = ConvPS1ToHTML -htmlInPath $scriptUploadPath -htmlInName ($WebEvent.Data['newPSSName'])
            $convScriptHtml | Out-Null
            
            Show-PodeWebModal -Id 1002

            Reset-PodeWebForm -Name 'newPSScript'
    
        }#End form 'PSCatInput'
    )#End container Upload Scripts
}#End page scriptblock