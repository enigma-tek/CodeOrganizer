Add-PodeWebPage -Name 'PSCodeUpdate' -DisplayName 'PS Script Code Update' -Hide -ScriptBlock {

    New-PodeWebContainer -Content @(
        $getScriptName = Get-PodeCache -Key 'PSSCRIPT'
        $getScriptNameU = $getScriptName + '.ps1'
        $getPSScript = Get-Content "./files/powershell/scripts/$getScriptNameU" -Raw

        New-PodeWebText -Value 'Make changes to your code below and then click the blue upload button in the top left to save your changes.' -CssClass 'brightWhite' -InParagraph

        New-PodeWebCodeEditor -Name 'UpdateScriptEditor' -Language 'powershell' -Value $getPSScript -upload {
            $pasteScriptTextUD = $WebEvent.Data | Select-Object Value
            $pasteScriptTextUD = $pasteScriptTextUD.Value
            
            $getScriptName2 = Get-PodeCache -Key 'PSSCRIPT'
            $getScriptNameU2 = $getScriptName2 + '.ps1'
            $scriptUploadPath = "./files/powershell/scripts/$getScriptNameU2"

            New-Item -Path $scriptUploadPath -ItemType File -Value $pasteScriptTextUD -Force | Out-Null

            $convScriptHtml = ConvPS1ToHTML -htmlInPath $scriptUploadPath -htmlInName $getScriptName2
            $convScriptHtml | Out-Null
               
            Clear-PodeWebCodeEditor -Name 'UpdateScriptEditor'
            Clear-PodeCache
            Move-PodeWebPage -Name 'CodeHub'
        }

    )#End container
}#End page