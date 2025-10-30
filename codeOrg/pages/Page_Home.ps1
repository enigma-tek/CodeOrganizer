  #Page information: Home page for Enigma-Tek Code Organizer
     
Set-PodeWebHomePage -NoTitle -Layouts @(

      New-PodeWebHero -Title $SiteName -Message 'by Enigma-Tek' -Content @(
            
            New-PodeWebContainer -Content @(

                  #Update line. Hide unless an update is available, then fill in line on home page load
                  New-PodeWebText -Id 0000 -Value '' -CssClass 'gold'

                  New-PodeWebLine

                  New-PodeWebHeader -Value 'PowerShell, KQL and SQL Code Organizer' -Size 5 -Secondary ''
                  New-PodeWebText -Value "A space for you or your team's automation/data scripts and queries" -InParagraph -CssClass 'brightWhite'
                  New-PodeWebText -Value "Organize PowerShell, KQL (Kusto Query Language), and SQL in a centralized repository.
                  Keep your essential scripts, snippets, commands, and queries well-organized and accessible—for personal use or team collaboration." -InParagraph -CssClass 'brightWhite'
                  
                  New-PodeWebLine

                  New-PodeWebGrid -Cells @(
                        New-PodeWebCell -Content @(
                              New-PodeWebTile -Name 'PS script count:' -NoRefresh -ScriptBlock {
                              RETURN (Get-ChildItem -Path "./files/powershell/scripts" -File | Measure-Object | Select-Object -ExpandProperty Count)
                              }
                        )
                        New-PodeWebCell -Content @(
                              New-PodeWebTile -Name 'PS snippet count:' -NoRefresh -ScriptBlock {
                              RETURN (Get-ChildItem -Path "./files/powershell/snippets" -File | Measure-Object | Select-Object -ExpandProperty Count)
                              }
                        )     
                        New-PodeWebCell -Content @(
                              New-PodeWebTile -Name 'KQL code count:' -NoRefresh -ScriptBlock {
                                    RETURN (Get-ChildItem -Path "./files/kql/kqlCode" -File | Measure-Object | Select-Object -ExpandProperty Count)
                              } 
                        )
                        New-PodeWebCell -Content @(
                              New-PodeWebTile -Name 'SQL code count:' -NoRefresh -ScriptBlock {
                                    RETURN (Get-ChildItem -Path "./files/sql/sqlCode" -File | Measure-Object | Select-Object -ExpandProperty Count)    
                              }
                        )
                        New-PodeWebCell -Content @(
                              New-PodeWebTile -Name 'Commands count:' -NoRefresh -ScriptBlock {
                                    RETURN (Get-ChildItem -Path "./files/commands/tbl" -File | Measure-Object | Select-Object -ExpandProperty Count)
                              }  
                        )

                  )#End grid

                  New-PodeWebLine

                  New-PodeWebHeader -Value 'WARNING - NEVER STORE CREDENTIALS IN CODE!!' -Size 6 -Secondary 'Storing credentials in your code is a bad habit, and a really bad security
                  practice. Doing so can expose your environment. You have been warned.'

            )#End container

      )#End Hero

) -PassThru | Register-PodeWebPageEvent -Type Load -ScriptBlock {
            $chkUpdate = Get-Content "./files/configs/codeOrg.json" | ConvertFrom-Json
            $updateVersion = $chkUpdate.Vers

            $rawUrl = "https://raw.githubusercontent.com/enigma-tek/PSCodeOrganizer/refs/heads/main/version.txt"
            $GitVerNum = (Invoke-WebRequest -Uri $rawUrl).Content

            $updateVersion = [System.Version]$updateVersion
            $GitVerNum = [System.Version]$GitVerNum

            if ($updateVersion -lt $GitVerNum) {
                  Update-PodeWebText -Id 0000 -Value '!! There is an update available for Code Organizer. Use the Update page located under Settings on the left sidebar. !! '
            } Else {}

}#End page scriptblock and passthru code block