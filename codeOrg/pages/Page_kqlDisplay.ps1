Add-PodeWebPage -Name 'KQLDisplay' -DisplayName 'KQL Information' -Hide -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        $getKQLCacheName = Get-PodeCache -Key 'KQLC'
        $getKQLMetaName = $getKQLCacheName + ".json"
        $getKQLMetaData = Get-Content "./files/kql/kqlMeta/$getKQLMetaName" | ConvertFrom-Json
        
            $kqlMetaName = $getKQLMetaData.QName
            $kqlMetadesc = $getKQLMetaData.Desc

        New-PodeWebParagraph -Elements @(
            New-PodeWebText -Value "Quick Name: " -CssClass 'brightWhite' -InParagraph
            New-PodeWebText -Value $kqlMetaName -CssClass 'orange'
            )
        New-PodeWebParagraph -Elements @(
            New-PodeWebText -Value "Description: " -CssClass 'brightWhite' -InParagraph
            New-PodeWebText -Value $kqlMetadesc -CssClass 'orange'
            )
        
        New-PodeWebButton -Name 'ReturnToKQLTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
        Remove-PodeCache -Key 'KQLC'
        Move-PodeWebPage -Name 'CodeHub'
        }

        New-PodeWebLine

        $getKQLCacheName = Get-PodeCache -Key 'KQLC'
        $getKQLCode = $getKQLCacheName + ".txt"
        $KQLCodeDiplayEditor = Get-Content "./files/kql/kqlCode/$getKQLCode" -Raw
        
        New-PodeWebCodeEditor -Name 'Editor View (read only)' -Language 'sql' -ReadOnly -Value $KQLCodeDiplayEditor -AsCard

    )#End container

}#End page scriptblock