Add-PodeWebPage -Name 'SQLDisplay' -DisplayName 'SQL Information' -Hide -ScriptBlock {

    New-PodeWebContainer -Content @(

        $getSQLCacheName = Get-PodeCache -Key 'SQLC'
        $getsqlMetaName = $getSQLCacheName + ".json"
        $getsqlMetaData = Get-Content "./files/sql/sqlMeta/$getsqlMetaName" | ConvertFrom-Json
        
            $sqlMetaName = $getsqlMetaData.QName
            $sqlMetadesc = $getsqlMetaData.Desc

        New-PodeWebParagraph -Elements @(
            New-PodeWebText -Value "Quick Name: " -CssClass 'brightWhite' -InParagraph
            New-PodeWebText -Value $sqlMetaName -CssClass 'orange'
            )
        New-PodeWebParagraph -Elements @(
            New-PodeWebText -Value "Description: " -CssClass 'brightWhite' -InParagraph
            New-PodeWebText -Value $sqlMetadesc -CssClass 'orange'
            )
        
        New-PodeWebButton -Name 'ReturnToSQLTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
        Remove-PodeCache -Key 'SQLC'
        Move-PodeWebPage -Name 'CodeHub'
        }

        New-PodeWebLine

        $getSQLCacheName = Get-PodeCache -Key 'SQLC'
        $getsqlCode = $getSQLCacheName + ".txt"
        $sqlCodeDiplayEditor = Get-Content "./files/sql/sqlCode/$getsqlCode" -Raw
        
        New-PodeWebCodeEditor -Name 'Editor View (read only)' -Language 'sql' -ReadOnly -Value $sqlCodeDiplayEditor -AsCard

    )#End container

}#End page scriptblock

