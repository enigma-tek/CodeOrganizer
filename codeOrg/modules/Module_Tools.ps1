#Function ConvPS1ToHTML Converts full PS1 file to corresponding html file so that they can be displayed in the Code Hub pages
Function ConvPS1ToHTML {

        param (
            [string] $htmlInPath,
            [string] $htmlInName
        )

        $scriptPath = $htmlInpath
        $HTMLName = $htmlInName + ".html"
        $htmlPath = "./files/powershell/scriptsHTML/$HTMLName"

            $scriptContent = Get-Content $scriptPath -Raw
            $escapedContent = $scriptContent -replace "&", "&amp;" -replace "<", "&lt;" -replace ">", "&gt;"

$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>PowerShell Script</title>
</head>
<body>
    <pre><code style="white-space: pre-wrap;">
$escapedContent
    </code></pre>
</body>
</html>
"@

        $htmlContent | Out-File $htmlPath -Force

    RETURN

}#End ConvPS1ToHTML function

#restoreDelFile function pull in input from the Recycle Bin and based on the name of the file and the code type, it restores the files back to the 
#code hub, but with (Restored) appended to the file name and its meta data. Opening the code in one of the editors per the code hub, the restored can be removed from the name
Function restoreDelFile {

    param (
        [string] $restoreType,
        [string] $restoreFullName
    )

        $restoreRealName = $restoreFullName.Substring(20)
        $restoreFinalName = $restoreRealName + "(Restored)"

        if ($restoreType -eq 'PS Script') {
            Move-Item -Path "./arc/pss/$restoreFullName/$restoreRealName.ps1" -Destination "./files/powershell/scripts/$restoreFinalName.ps1" | Out-Null
            Move-Item -Path "./arc/pss/$restoreFullName/$restoreRealName.html" -Destination "./files/powershell/scriptsHTML/$restoreFinalName.html" | Out-Null
            Move-Item -Path "./arc/pss/$restoreFullName/$restoreRealName.json" -Destination "./files/powershell/scriptsMeta/$restoreFinalName.json" | Out-Null

            $updateJsonName = Get-Content -Raw "./files/powershell/scriptsMeta/$restoreFinalName.json" | ConvertFrom-Json
            $updateJsonName.Name = $restoreFinalName
            $updateJsonName | ConvertTo-Json -Depth 10 | Set-Content "./files/powershell/scriptsMeta/$restoreFinalName.json"

            Remove-Item -Path ./arc/pss/$restoreFullName -Recurse -Force | Out-Null

            Clear-PodeCache
        }

          if ($restoreType -eq 'PS Snippet') {
            Move-Item -Path "./arc/pssnip/$restoreFullName/$restoreRealName.ps1" -Destination "./files/powershell/snippets/$restoreFinalName.txt" | Out-Null
            Move-Item -Path "./arc/pssnip/$restoreFullName/$restoreRealName.json" -Destination "./files/powershell/snippetsMeta/$restoreFinalName.json" | Out-Null

            $updateJsonName = Get-Content -Raw "./files/powershell/snippetsMeta/$restoreFinalName.json" | ConvertFrom-Json
            $updateJsonName.Name = $restoreFinalName
            $updateJsonName | ConvertTo-Json -Depth 10 | Set-Content "./files/powershell/snippetsMeta/$restoreFinalName.json"

            Remove-Item -Path ./arc/pssnip/$restoreFullName -Recurse -Force | Out-Null

            Clear-PodeCache
        }

          if ($restoreType -eq 'KQL') {
            Move-Item -Path "./arc/kql/$restoreFullName/$restoreRealName.txt" -Destination "./files/kql/kqlCode/$restoreFinalName.txt" | Out-Null
            Move-Item -Path "./arc/kql/$restoreFullName/$restoreRealName.json" -Destination "./files/kql/kqlMeta/$restoreFinalName.json" | Out-Null

            $updateJsonName = Get-Content -Raw "./files/kql/kqlMeta/$restoreFinalName.json" | ConvertFrom-Json
            $updateJsonName.QName = $restoreFinalName
            $updateJsonName | ConvertTo-Json -Depth 10 | Set-Content "./files/kql/kqlMeta/$restoreFinalName.json"

            Remove-Item -Path ./arc/kql/$restoreFullName -Recurse -Force | Out-Null

            Clear-PodeCache
        }

          if ($restoreType -eq 'SQL') {
            Move-Item -Path "./arc/sql/$restoreFullName/$restoreRealName.txt" -Destination "./files/sql/sqlCode/$restoreFinalName.txt" | Out-Null
            Move-Item -Path "./arc/sql/$restoreFullName/$restoreRealName.json" -Destination "./files/sql/sqlMeta/$restoreFinalName.json" | Out-Null

            $updateJsonName = Get-Content -Raw "./files/sql/sqlMeta/$restoreFinalName.json" | ConvertFrom-Json
            $updateJsonName.QName = $restoreFinalName
            $updateJsonName | ConvertTo-Json -Depth 10 | Set-Content "./files/sql/sqlMeta/$restoreFinalName.json"

            Remove-Item -Path ./arc/sql/$restoreFullName -Recurse -Force | Out-Null

            Clear-PodeCache
        }

          if ($restoreType -eq 'Command') {
    
            Move-Item -Path "./arc/cmd/$restoreFullName/$restoreRealName.json" -Destination "./files/commands/full/$restoreFinalName.json" | Out-Null

            $updateJsonName = Get-Content -Raw "./files/commands/full/$restoreFinalName.json" | ConvertFrom-Json
            $updateJsonName.Command = $restoreFinalName
            $updateJsonName | ConvertTo-Json -Depth 10 | Set-Content "./files/commands/full/$restoreFinalName.json"
			
			$genTblFile = Get-Content -Raw "./files/commands/full/$restoreFinalName.json" | ConvertFrom-Json
			$genTblFile.Opt = $null
			$genTblFile.Ex = $null
			$genTblFile.Note = $null
			$genTblFile.Parent = $null
			$updateJsonName | ConvertTo-Json -Depth 10 | Set-Content "./files/commands/tbl/$restoreFinalName.json"
			
            Remove-Item -Path ./arc/cmd/$restoreFullName -Recurse -Force | Out-Null

            Clear-PodeCache
        }
    
    RETURN

}

#The randomID function generates a random ID to use as the folder names for the PS Snippets
Function randomID {

    $PullCurrentNames = Get-ChildItem -Path "./files/powershell/snippets" -File | ForEach-Object {$_.BaseName} 
    
        if ([string]::IsNullOrEmpty($PullCurrentNames)) {
            $CharacterSet = @{
            Uppercase  = (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_}
            Lowercase  = (65..90)  | Get-Random -Count 30 | ForEach-Object {[char]$_}
            }
        $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase
        $nNAme = -join(Get-Random -Count 5 -InputObject $StringSet)

    RETURN $nNAme

        } else {
        do {
            $CharacterSet = @{
                Uppercase  = (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_}
                Lowercase  = (65..90)  | Get-Random -Count 30 | ForEach-Object {[char]$_}
            }
        $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase
        $nNAme = -join(Get-Random -Count 5 -InputObject $StringSet)
        } until (!($PullCurrentNames.Contains($nName)))

    RETURN $nNAme
    
    }
}