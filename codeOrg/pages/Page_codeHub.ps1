Add-PodeWebPage -Name 'CodeHub' -DisplayName 'Code Hub' -Icon 'file-code-outline' -Layouts @(

    #Include modals
    modals_funk
           
    New-PodeWebTabs -Tabs @(

        #Tab that has the scripts table
        New-PodeWebTab -Name 'PS Scripts' -Layouts @(
                    
            New-PodeWebContainer -Content @(

                New-PodeWebHeader -Value 'PowerShell Scripts' -Size 5 -Secondary ''

                New-PodeWebText -Value "The Table below holds all of your script information. Action buttons are Show Code, Update Entry Information, 
                Update Entry Code, Download and Delete. Click the 'Upload OR Paste Button' to add more scripts." -InParagraph -CssClass 'brightWhite'

                New-PodeWebButton -Name 'uLoadPSButton' -DisplayName 'Upload PS Script' -Colour Grey -ScriptBlock {
                    Move-PodeWebPage -Name 'PSCodeUpload'
                    }
                New-PodeWebButton -Name 'uPasteButton' -DisplayName 'Paste PS Script' -Colour Grey -ScriptBlock {
                     
                    'PSCodePaste'
                    }
                      
                New-PodeWebLine

                New-PodeWebText -Value 'Filtering evaluates typed text against all text in the entry.' -Inparagraph -CSSClass 'brightWhite' -Style Italics

                New-PodeWebTable -Name 'ScriptTable' -NoExport -NoRefresh -Paginate -DataColumn Name -PageSize 30 -Filter -ScriptBlock {
                    
                    $scriptMetaDataFiles = Get-ChildItem -Path "./files/powershell/scriptsMeta" -File
                    $myArray = @()
                    foreach ($smdf in $scriptMetaDataFiles) {
                        
                        $importMetaFileName = $smdf.name
                        $myArray += Get-Content "./files/powershell/scriptsMeta/$importMetaFileName" | ConvertFrom-Json
                        }
                        
                        $filter = $WebEvent.Data.Filter
                        if (![string]::IsNullOrWhiteSpace($filter)) {
                            $filter = "*$($filter)*"
                            $myArray1 = @($myArray | Where-Object { ($_.psobject.properties.value -ilike $filter).length -gt 0 })
                        } else { $myArray1 = $myArray}
                        
                    
                        foreach ($importMetaData in $myArray1 ) {
                        $scMetaCats = $importMetaData.Cats
                        $scMetaCats = $scMetaCats -replace ",", ", "
                        $scMetaDesc = $importMetaData.Desc
                        $scMetaEnv = $importMetaData.Env
                        $scMetaVers = $importMetaData.Vers
                        $scMetaVers = $scMetaVers -replace ",", ", "
                        $scMetaName = $importMetaData.Name
                        $scMetaSys = $importMetaData.Sys
                        $scMetaNote = $importMetaData.Note

                        [Ordered]@{
                            Script_Name = $scMetaName
                            Description = $scMetaDesc
                            Catagories = $scMetaCats
                            Environment = $scMetaEnv
                            PS_Versions = $scMetaVers
                            System_Applied = $scMetaSys
                            Note = $scMetaNote
                                Actions = @(
                                    New-PodeWebButton -Name 'Show Code' -Icon 'code-braces' -DataValue $scMetaName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'PSSCRIPT' -InputObject $WebEvent.Data.Value
                                        Move-PodeWebPage -Name 'PSDisplay'
                                        }
                                    New-PodeWebButton -Name 'Update Entry Information' -Icon 'update' -DataValue $scMetaName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'PSSCRIPT' -InputObject $WebEvent.Data.Value
                                        Move-PodeWebPage -Name 'PSCodeInfoUpdate'
                                        }
                                     New-PodeWebButton -Name 'Update Entry Code' -Icon 'code-brackets' -DataValue $scMetaName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'PSSCRIPT' -InputObject $WebEvent.Data.Value
                                        Move-PodeWebPage -Name 'PSCodeUpdate'
                                        }
                                    New-PodeWebButton -Name 'Download PS1 File' -Icon 'arrow-down-bold-circle-outline' -DataValue $scMetaName -IconOnly -ScriptBlock {
                                        $psFileDownload = $WebEvent.Data.Value + ".ps1"
                                        $psDownloadPath = "./files/powershell/scripts/$psFileDownload"
                                        Set-PodeResponseAttachment -Path $psDownloadPath
                                        }
                                    New-PodeWebButton -Name 'Delete Entry' -Icon 'trash-can-outline' -DataValue $scMetaName -IconOnly -ScriptBlock {
                                        Show-PodeWebModal -Id 1001 -DataValue $WebEvent.Data.Value
                                        }
                                    )#end actions
                        }#End ordered
                    }#end foreach

                } -Columns @(
                    Initialize-PodeWebTableColumn -Key 'Script_Name' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Description' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Catagories' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Environment' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'PS_Versions' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'System_Applied' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Actions' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Note' -Alignment Center -Width 20
                ) 

            )#End container for PS Scripts
        
        )#End tab 'PS Scripts'

        #Tab that has the PS snippets table
        New-PodeWebTab -Name 'PS Snippets' -Layouts @(

            New-PodeWebContainer -Content @(

                New-PodeWebHeader -Value 'PowerShell Snippets' -Size 5 -Secondary ''

                New-PodeWebText -Value "The Table below holds all of your snippet information. Action buttons are Show Code, Update Entry Information, 
                Update Entry Code, Download and Delete. Click the 'Upload OR Paste Button' to add more scripts." -InParagraph -CssClass 'brightWhite'

                New-PodeWebButton -Name 'uPastePSSnipButton' -DisplayName 'Paste PS Snippet' -Colour Grey -ScriptBlock {
                    Set-PodeCache -Key 'HubTab' -InputObject 501
                    Move-PodeWebPage -Name 'PSSnipCodePaste'
                    }
                      
                New-PodeWebLine

                New-PodeWebText -Value 'Filtering evaluates typed text against all text in the entry.' -Inparagraph -CSSClass 'brightWhite' -Style Italics

                New-PodeWebTable -Name 'SnipTable' -NoExport -NoRefresh -Paginate -DataColumn Name -PageSize 30 -Filter -ScriptBlock {
                    
                    $snipMetaDataFiles = Get-ChildItem -Path "./files/powershell/snippetsMeta" -File
                    $myArraySnip = @()
                    foreach ($snip in $snipMetaDataFiles) {
                        
                        $importSnipMetaFileName = $snip.name
                        $myArraySnip += Get-Content "./files/powershell/snippetsMeta/$importSnipMetaFileName" | ConvertFrom-Json
                        }
                        
                        $filter = $WebEvent.Data.Filter
                        if (![string]::IsNullOrWhiteSpace($filter)) {
                            $filter = "*$($filter)*"
                            $myArray2 = @($myArraySnip| Where-Object { ($_.psobject.properties.value -ilike $filter).length -gt 0 })
                        } else { $myArray2 = $myArraySnip}
                        
                    
                        foreach ($importSnipMetaData in $myArray2 ) {
                        $scMetaCats = $importSnipMetaData.Cat
                        $scMetaDesc = $importSnipMetaData.Desc
                        $scMetaID = $importSnipMetaData.ID
                        $scMetaNote = $importSnipMetaData.Note

                        [Ordered]@{
                            ID = $scMetaID
                            Description = $scMetaDesc
                            Catagory = $scMetaCats
                            Note = $scMetaNote
                                Actions = @(
                                    New-PodeWebButton -Name 'Show Code' -Icon 'code-braces' -DataValue $scMetaID -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'PSSNIPP' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 501
                                        Move-PodeWebPage -Name 'SnipDisplay'
                                        }
                                    New-PodeWebButton -Name 'Update Entry Information' -Icon 'update' -DataValue $scMetaID -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'PSSNIPP' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 501
                                        Move-PodeWebPage -Name 'SnipUpdate'
                                        }
                                    New-PodeWebButton -Name 'Delete Entry' -Icon 'trash-can-outline' -DataValue $scMetaID -IconOnly -ScriptBlock {
                                        Show-PodeWebModal -Id 1009 -DataValue $WebEvent.Data.Value
                                        }
                                    )#end actions

                        }#End ordered

                    }#end foreach

                } -Columns @(
                    Initialize-PodeWebTableColumn -Key 'ID' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Description' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Catagories' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Note' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Actions' -Alignment Center     
                ) 

            )#End container for PS Snipps

        )#End tab 'PS Snippets'
        
        #Tab that has the KQL table
        New-PodeWebTab -Name 'KQL' -Layouts @(

           New-PodeWebContainer -Content @(
                
                New-PodeWebText -Value 'Store all your KQL commands and queries.' -InParagraph

                New-PodeWebButton -Name 'uKQLButton' -DisplayName 'Input KQL' -Colour Grey -ScriptBlock {
                    Set-PodeCache -Key 'HubTab' -InputObject 502
                    Move-PodeWebPage -Name 'KQLInput'
                }

                New-PodeWebLine

                New-PodeWebText -Value 'Filtering evaluates typed text against all text in the entry.' -Inparagraph -CSSClass 'brightWhite' -Style Italics

                New-PodeWebTable -Name 'KQLTable' -DataColumn Command -NoExport -NoRefresh -Paginate -PageSize 30 -SimpleSort -Filter -ScriptBlock {
                    
                    $kqlDataFiles = Get-ChildItem -Path "./files/kql/kqlMeta" -File
            
                    $kqlArray = @()
                    foreach ($kqls in $kqlDataFiles) {
                        
                        $importKQLFileName = $kqls.Name
                        $kqlArray += Get-Content "./files/kql/kqlMeta/$importKQLFileName" | ConvertFrom-Json
                        }
                        $filter = $WebEvent.Data.Filter
                        if (![string]::IsNullOrWhiteSpace($filter)) {
                            $filter = "*$($filter)*"
                            $kqlArray1 = @($kqlArray | Where-Object { ($_.psobject.properties.value -ilike $filter).length -gt 0 })
                        } else {$kqlArray1 = $kqlArray}
                        
                    
                        foreach ($importKQLData in $kqlArray1 ) {
                        $kqlQName = $importKQLData.QName
                        $kqlDesc = $importKQLData.Desc
            
                        [Ordered]@{
                            Quick_Name =  $kqlQName
                            Description = $kqlDesc
                                Actions = @(
                                    New-PodeWebButton -Name 'Full KQL information' -Icon 'code-braces' -DataValue $kqlQName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'KQLC' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 502
                                        Move-PodeWebPage -Name 'KQLDisplay'
                                        }
                                    New-PodeWebButton -Name 'Update KQL Information' -Icon 'update' -DataValue $kqlQName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'KQLC' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 502
                                        Move-PodeWebPage -Name 'KQLUpdate'
                                        }
                                    New-PodeWebButton -Name 'Delete Entry' -Icon 'trash-can-outline' -DataValue $kqlQName -IconOnly -ScriptBlock {
                                        Show-PodeWebModal -Id 1007 -DataValue $WebEvent.Data.Value
                                        }

                                )#end actions

                        }#End ordered

                    }#end foreach

                } -Columns @(
                    Initialize-PodeWebTableColumn -Key 'Quick_Name' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Description' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Actions' -Alignment Center
                ) 
          
            )#End conatiner for KQL
        )#End tab 'KQL'


        #Tab that has the SQL table
        New-PodeWebTab -Name 'SQL' -Layouts @(
                    
            New-PodeWebContainer -Content @(
                
                New-PodeWebText -Value 'Store all your SQL commands, statements, queries or scripts.' -InParagraph

                New-PodeWebButton -Name 'uSQLButton' -DisplayName 'Input SQL' -Colour Grey -ScriptBlock {
                    Set-PodeCache -Key 'HubTab' -InputObject 503
                    Move-PodeWebPage -Name 'SQLInput'
                }

                New-PodeWebLine

                New-PodeWebText -Value 'Filtering evaluates typed text against all text in the entry.' -Inparagraph -CSSClass 'brightWhite' -Style Italics

                New-PodeWebTable -Name 'SQLTable' -DataColumn Command -NoExport -NoRefresh -Paginate -PageSize 30 -SimpleSort -Filter -ScriptBlock {
                    
                    $sqlDataFiles = Get-ChildItem -Path "./files/sql/sqlMeta" -File
            
                    $sqlArray = @()
                    foreach ($sqls in $sqlDataFiles) {
                        
                        $importSQLFileName = $sqls.Name
                        $sqlArray += Get-Content "./files/sql/sqlMeta/$importSQLFileName" | ConvertFrom-Json
                        }
                        $filter = $WebEvent.Data.Filter
                        if (![string]::IsNullOrWhiteSpace($filter)) {
                            $filter = "*$($filter)*"
                            $sqlArray1 = @($sqlArray | Where-Object { ($_.psobject.properties.value -ilike $filter).length -gt 0 })
                        } else {$sqlArray1 = $sqlArray}
                        
                    
                        foreach ($importSQLData in $sqlArray1 ) {
                        $sqlQName = $importSQLData.QName
                        $sqlDesc = $importSQLData.Desc
            
                        [Ordered]@{
                            Quick_Name =  $sqlQName
                            Description = $sqlDesc
                                Actions = @(
                                    New-PodeWebButton -Name 'Full SQL information' -Icon 'code-braces' -DataValue $sqlQName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'SQLC' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 503
                                        Move-PodeWebPage -Name 'SQLDisplay'
                                        }
                                    New-PodeWebButton -Name 'Update SQL Information' -Icon 'update' -DataValue $sqlQName -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'SQLC' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 503
                                        Move-PodeWebPage -Name 'SQLUpdate'
                                        }
                                    New-PodeWebButton -Name 'Delete Entry' -Icon 'trash-can-outline' -DataValue $sqlQName -IconOnly -ScriptBlock {
                                        Show-PodeWebModal -Id 1008 -DataValue $WebEvent.Data.Value
                                        }

                                )#end actions

                        }#End ordered

                    }#end foreach

                } -Columns @(
                    Initialize-PodeWebTableColumn -Key 'Quick_Name' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Description' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Actions' -Alignment Center
                ) 
          
            )#End conatiner for SQL

        )#End tab 'SQL'

          #Tab that has the commands table
          New-PodeWebTab -Name 'Commands' -Layouts @(

            New-PodeWebContainer -Content @(
                
                New-PodeWebText -Value "We all use commands from time to time that we forget or forget the syntax on how to use it." -InParagraph -Style Bold
                
                New-PodeWebText -Value "Store and retrieve those PowerShell Cmdlets, KQL, and SQL commands that somehow always slip your mind. 
                Create a helpful reference table for your team and for members who are just starting out or aren't yet familiar with all the commands." -InParagraph

                New-PodeWebButton -Name 'uCMDButton' -DisplayName 'Input Commands' -Colour Grey -ScriptBlock {
                    Set-PodeCache -Key 'HubTab' -InputObject 504
                    Move-PodeWebPage -Name 'CommandsInput'
                }

                New-PodeWebLine

                New-PodeWebText -Value 'Filtering evaluates typed text against all text in the entry.' -Inparagraph -CSSClass 'brightWhite' -Style Italics

                New-PodeWebTable -Name 'CommandTable' -DataColumn Command -NoExport -NoRefresh -Paginate -PageSize 30 -SimpleSort -Filter -ScriptBlock {
                    
                    $commandDataFiles = Get-ChildItem -Path "./files/commands/tbl" -File
            
                    $cmdArray = @()
                    foreach ($cmds in $commandDataFiles) {
                        
                        $importCMDFileName = $cmds.Name
                        $cmdArray += Get-Content "./files/commands/tbl/$importCMDFileName" | ConvertFrom-Json
                        }
                        $filter = $WebEvent.Data.Filter
                        if (![string]::IsNullOrWhiteSpace($filter)) {
                            $filter = "*$($filter)*"
                            $cmdArray1 = @($cmdArray | Where-Object { ($_.psobject.properties.value -ilike $filter).length -gt 0 })
                        } else { $cmdArray1 = $cmdArray}
                        
                    
                        foreach ($importcmdData in $cmdArray1 ) {
                        $cmdDesc = $importcmdData.Command
                        $cmd = $importcmdData.Ref
                        $cmdNote = $importcmdData.Lang
            
                        [Ordered]@{
                            Command = $cmdDesc
                            Description = $cmd
                            Language = $cmdNote
                                Actions = @(
                                    New-PodeWebButton -Name 'Full CMD information' -Icon 'code-braces' -DataValue $cmdDesc -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'CMDC' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 504
                                        Move-PodeWebPage -Name 'CMDDisplay'
                                        }
                                    New-PodeWebButton -Name 'Update CMD Information' -Icon 'update' -DataValue $cmdDesc -IconOnly -ScriptBlock {
                                        Set-PodeCache -Key 'CMDC' -InputObject $WebEvent.Data.Value
                                        Set-PodeCache -Key 'HubTab' -InputObject 504
                                        Move-PodeWebPage -Name 'CMDUpdate'
                                        }
                                    New-PodeWebButton -Name 'Delete Entry' -Icon 'trash-can-outline' -DataValue $cmdDesc -IconOnly -ScriptBlock {
                                        Show-PodeWebModal -Id 1003 -DataValue $WebEvent.Data.Value
                                        }
                                    )#end actions
                        }#End ordered
                    }#end foreach

                } -Columns @(
                    Initialize-PodeWebTableColumn -Key 'Command' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Description' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Language' -Alignment Center
                ) 
          
            )#End conatiner for Commands

      )#End tab 'Commands'

    )#End tabs

#Code below creates an on load page event that checks to see if a tab number has been set in cache and then
#switches to that tab. This is for when a page returns to the hub, it returns to the last set tab that was used
) -PassThru | Register-PodeWebPageEvent -Type Load -ScriptBlock {
        
        $lastTab = Get-PodeCache -Key 'HubTab'

        if ($lastTab -eq 501) {
            Move-PodeWebtab -Name 'PS Snippets'
        } elseif ($lastTab -eq 502) {
            Move-PodeWebtab -Name 'KQL'
        } elseif ($lastTab -eq 503) {
            Move-PodeWebtab -Name 'SQL'
        } elseif ($lastTab -eq 504) {
            Move-PodeWebtab -Name 'Commands'
        } else {}

        #Clear all cache when page is finished loading
        Clear-PodeCache
}
