Add-PodeWebPage -Name 'PSSnipCodePaste' -DisplayName 'PS Snippet Paste' -Hide -ScriptBlock {
    modals_funk
    New-PodeWebContainer -Content @(
        
        New-PodeWebForm -Name 'newPSSnipPaste' -SubmitText 'Submit' -Content @(

            New-PodeWebText -Value 'Give a detailed description, not only will it help you remember what the snippet is for, but it can be used in advanced searches.' -InParagraph -CssClass 'brightWhite'
            New-PodeWebText -Value "The Catagory options are one/multiple choice (hold down the CTRL key to select multiple). 
            The Environment is single select. Notes are not required, but if left empty the word 'none' will be added." -InParagraph -CssClass 'brightWhite'

            New-PodeWebTextbox -Name 'newSnipDesc' -DisplayName '*Description: ' -Multiline -Required  -HelpText 'Give a detailed description of what the snippet is used for/does'

            $catOptions = Import-CSV -Path "./files/configs/formCatagories.csv"
            
            New-PodeWebSelect -Name 'newSnipPasteCat' -DisplayName '*Catagory: ' -Options $catOptions.name -Required

            New-PodeWebTextbox -NAme 'newSnipNotes' -DisplayNAme 'Notes/Instructions: ' -Multiline
            
            New-PodeWebCodeEditor -Name 'SnipEditor' -Language 'powershell' -upload {
        
                $pasteSnipText = $WebEvent.Data | Select-Object Value
                $pasteSnipText = $pasteSnipText.Value
                Set-PodeCache -Key 'PsSnipPaste' -InputObject $pasteSnipText
                }
            
            ) -ScriptBlock {

                $pasteChk = Get-PodeCache -Key 'PsSnipPaste'

                $getNewID = randomID

                if (([string]::IsNullOrEmpty($pasteChk))) {
                    Update-PodeWebText -Id 4002 -Value 'Script text entry is blank...'
                    Update-PodeWebText -Id 4005 -Value 'Before hitting submit on the form, please paste your script and hit the upload button 
                    at the top of the editor.'
                    Show-PodeWebModal -Id 4001 -DataValue $WebEvent.Data.Value
                    Return
                }

            #Upload the script to a server folder
            $snippFullName = $getNewID + ".txt"

            $snippUploadPath = "./files/powershell/snippets/$snippFullName"

            New-Item -Path $snippUploadPath -ItemType File -Value $pasteChk | Out-Null

            #Create a metadata file for that script
            if(!$WebEvent.Data['newSnipNotes']) {
                $WebEvent.Data['newSnipNotes'] = 'none'
            } else {}

            $psSnipMetaData =  @{
                ID = $getNewID
                Desc = ($WebEvent.Data['newSnipDesc'])
                Cat = ($WebEvent.Data['newSnipPasteCat'])
                Note = ($WebEvent.Data['newSnipNotes'])
                }

            $sFullMeta = $getNewID + ".json"
            $psSnipMetaData | ConvertTo-Json | Set-Content "./files/powershell/snippetsMeta/$sFullMeta"
            
            Show-PodeWebModal -Id 1002
            
            Clear-PodeWebCodeEditor -Name 'SnipEditor'
            Reset-PodeWebForm -Name 'newPSSnipPaste'

        }#End form 'newPSSnipPaste'

    )#End container Paste snippet

}#end page scriptblock