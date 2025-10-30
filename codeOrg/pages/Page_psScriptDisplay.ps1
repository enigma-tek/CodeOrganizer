Add-PodeWebPage -Name 'PSDisplay' -Hide -DisplayName 'PS Script and script information' -ScriptBlock {

    New-PodeWebContainer -Content @(
        #Pull info to page
        $getPSCacheName = Get-PodeCache -Key 'PSSCRIPT'
        $getPSMetaName = $getPSCacheName + ".json"
        $getPSMetaData = Get-Content "./files/powershell/scriptsMeta/$getPSMetaName" | ConvertFrom-Json
        
            $psMetaCats = $getPSMetaData.Cats
            $psMetaCats = $psMetaCats -replace ",", ", "
            $psMetaDesc = $getPSMetaData.Desc
            $psMetaEnv = $getPSMetaData.Env
            $psMetaVers = $getPSMetaData.Vers
            $psMetaVers = $psMetaVers -replace ",", ", "
            $psMetaName = $getPSMetaData.Name
            $scMetaSys = $getPSMetaData.Sys
            $scMetaNotes = $getPSMetaData.Note

                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Script Name: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $psMetaName -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Script Description: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $psMetaDesc -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Code Applicable Catagories: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $psMetaCats -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Code Environment: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $psMetaEnv -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Compatible PS Versions: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $psMetaVers -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "System the script is on: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $scMetaSys -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Notes or Instructions for the script: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $scMetaNotes -CssClass 'coral '
                    )

            New-PodeWebButton -Name 'ReturnToPSTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
                Remove-PodeCache -Key 'PSSCRIPT'
                Move-PodeWebPage -Name 'CodeHub'
                }
            New-PodeWebButton -Name 'DownloadPsScripts' -DisplayName 'Download' -DataValue $psMetaName -Colour Dark -ScriptBlock {
                $psFileDownload = $WebEvent.Data.Value + ".ps1"
                $psDownloadPath = "./files/powershell/scripts/$psFileDownload"
                Set-PodeResponseAttachment -Path $psDownloadPath
                }

        New-PodeWebLine

        New-PodeWebCard -Name 'cvHTMLPs' -DisplayName 'Plain View' -Content @(
            $disFileName = $getPSCacheName + ".html"
            $rawScript = "./files/powershell/scriptsHTML/$disFileName"
            $HTMLContent = Get-Content $rawScript -Raw
            New-PodeWebRaw -Value $HTMLContent
            )

        $getScriptNameU = $psMetaName + '.ps1'
        $psCodeDiplayEditor = Get-Content "./files/powershell/scripts/$getScriptNameU" -Raw
        
        New-PodeWebCodeEditor -Name 'Editor View (read only)' -Language powershell -ReadOnly -Value $psCodeDiplayEditor -AsCard
              
    )#End container

}#End page PSDisplay