Add-PodeWebPage -Name 'SnipDisplay' -Hide -DisplayName 'Snippet Information' -ScriptBlock {

    New-PodeWebContainer -Content @(
        #Pull info to page
        $getSnipID = Get-PodeCache -Key 'PSSNIPP'
        $getSnipMetaName = $getSnipID + ".json"
        $getSnipMetaData = Get-Content "./files/powershell/snippetsMeta/$getSnipMetaName" | ConvertFrom-Json
        
            $snipMetaCat = $getSnipMetaData.Cat
            $snipMetaDesc = $getSnipMetaData.Desc
            $snipMetaNotes = $getSnipMetaData.Note

                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "ID: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $getSnipID  -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Snippet Description: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $snipMetaDesc -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Catagory: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $snipMetaCat -CssClass 'coral'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Notes or Instructions for the script: " -CssClass 'brightWhite'
                    New-PodeWebText -Value $snipMetaNotes -CssClass 'coral '
                    )

            New-PodeWebButton -Name 'ReturnToPSTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
                Remove-PodeCache -Key 'PSSNIPP'
                Move-PodeWebPage -Name 'CodeHub'
                }

        New-PodeWebLine

        $getSnipNameU = $getSnipID + '.txt'
        $snipCodeDiplayEditor = Get-Content "./files/powershell/snippets/$getSnipNameU" -Raw
        
        New-PodeWebCodeEditor -Name 'Editor View (read only)' -Language powershell -ReadOnly -Value $snipCodeDiplayEditor -AsCard
              
    )#End container

}#End page PSDisplay