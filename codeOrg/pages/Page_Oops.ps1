#Recycle Bin page - When you delete anything in the code hub, it gets copied into a folder under the arc folder as to hold it in case the deletion
#was an accident. This page allows for restoring the deleted entry OR purging the entire Recycle Bin. IF you have gotten far enough to read this and the code below,
#you may realize that the purge function also does not delete the files but zips them all up and places them in a purged folder. It would be a manual restore from here but,
#atleast you dont lose your hard work.

Add-PodeWebPage -Name 'RecycleBin' -DisplayName 'Recycle Bin' -Group 'Settings' -Icon 'recycle' -ScriptBlock {
modals_funk
    New-PodeWebContainer -Content @(

        New-PodeWebText -Value "Use the dropdown to choose one of the code types and then choose 'View Recycle Bin' to get a table of deleted items for that code type. 
        You can restore an entry from the table Action button. This will restore the entry back to the Code Hub, but the name will be appended with (Restored). 
        You will notice that there is no delete per entry, if you are confident that all deleted entries are trash, use the Purge button below to clear the Recycle Bin." -InParagraph

        New-PodeWebForm -Name 'oopsForm' -SubmitText 'Get Deleted Items' -Content @(

            New-PodeWebLine -CssStyle @{ Visibility = 'Hidden'}

            New-PodeWebSelect -Name 'oopsSelectReturn' -DisplayName 'Select Code Type: ' -Options 'PS Script', 'PS Snippet', 'KQL', 'SQL', 'Commands' 

        ) -ScriptBlock {

            if ($WebEvent.Data['oopsSelectReturn'] -eq 'PS Script') {
                
                $oopsPSNameArray = @()
                
                $oopsPSList = Get-ChildItem -Path "./arc/pss"

                foreach ($oopsPS in $oopsPSList) {
                    
                    $oopsPSFullName = $oopsPS.Name
                    $oopsPSName = $oopsPS.Name.Substring(20)
                    $DeletionDate = $oopsPS.Name.Substring(0, [System.Math]::Min(16, $oopsPS.Name.Length))
                    $oopsPSNameArray += [PSCustomObject]@{
                        Name = $oopsPSName
                        Date = $DeletionDate
                        Full = $oopsPSFullName
                    }
                }
                Set-PodeCache -Key 'oopsType' -InputObject 'PS Script'
                Set-PodeCache -Key 'oops' -InputObject $oopsPSNameArray
                Sync-PodeWebTable -Name 'oopsDisplayTable'
            }

            if ($WebEvent.Data['oopsSelectReturn'] -eq 'PS Snippet') {

                $oopsSnipNameArray = @()
                
                $oopsSnipList = Get-ChildItem -Path "./arc/pssnip"

                foreach ($oopsSnip in $oopsSnipList) {
                    
                    $oopsSnipFullName = $oopsSnip.Name
                    $oopsSnipName = $oopsSnip.Name.Substring(20)
                    $DeletionDate = $oopsSnip.Name.Substring(0, [System.Math]::Min(16, $oopsSnip.Name.Length))
                    $oopsSnipNameArray += [PSCustomObject]@{
                        Name = $oopsSnipName
                        Date = $DeletionDate
                        Full = $oopsSnipFullName
                    }
                }
                Set-PodeCache -Key 'oopsType' -InputObject 'PS Snippet'
                Set-PodeCache -Key 'oops' -InputObject $oopsSnipNameArray
                Sync-PodeWebTable -Name 'oopsDisplayTable'
            }

            if ($WebEvent.Data['oopsSelectReturn'] -eq 'KQL') {

                $oopsKQLNameArray = @()
                
                $oopsKQLList = Get-ChildItem -Path "./arc/kql"

                foreach ($oopsKQL in $oopsKQLList) {
                
                    $oopsKQLFullName = $oopsKQL.Name
                    $oopsKQLName = $oopsKQL.Name.Substring(20)
                    $DeletionDate = $oopsKQL.Name.Substring(0, [System.Math]::Min(16, $oopsKQL.Name.Length))
                    $oopsKQLNameArray += [PSCustomObject]@{
                        Name = $oopsKQLName
                        Date = $DeletionDate
                        Full = $oopsKQLFullName
                    }
                }
                Set-PodeCache -Key 'oopsType' -InputObject 'KQL'
                Set-PodeCache -Key 'oops' -InputObject $oopsKQLNameArray
                Sync-PodeWebTable -Name 'oopsDisplayTable'
            }

            if ($WebEvent.Data['oopsSelectReturn'] -eq 'SQL') {

                $oopsSQLNameArray = @()
                
                $oopsSQLList = Get-ChildItem -Path "./arc/sql"

                foreach ($oopsSQL in $oopsSQLList) {
                    
                    $oopsSQLFullName = $oopsSQL.Name
                    $oopsSQLName = $oopsSQL.Name.Substring(20)
                    $DeletionDate = $oopsSQL.Name.Substring(0, [System.Math]::Min(16, $oopsSQL.Name.Length))
                    $oopsSQLNameArray += [PSCustomObject]@{
                        Name = $oopsSQLName
                        Date = $DeletionDate
                        Full = $oopsSQLFullName
                    }
                }
                Set-PodeCache -Key 'oopsType' -InputObject 'SQL'
                Set-PodeCache -Key 'oops' -InputObject $oopsSQLNameArray
                Sync-PodeWebTable -Name 'oopsDisplayTable'
            }

            if ($WebEvent.Data['oopsSelectReturn'] -eq 'Commands') {

                $oopsCMDNameArray = @()
                
                $oopsCMDList = Get-ChildItem -Path "./arc/cmd"

                foreach ($oopsCMD in $oopsCMDList) {
                    
                    $oopsCMDFullName = $oopsCMD.Name
                    $oopsCMDName = $oopsCMD.Name.Substring(20)
                    $DeletionDate = $oopsCMD.Name.Substring(0, [System.Math]::Min(16, $oopsCMD.Name.Length))
                    $oopsCMDNameArray += [PSCustomObject]@{
                        Name = $oopsCMDName
                        Date = $DeletionDate
                        Full = $oopsCMDFullName
                    }
                }
                Set-PodeCache -Key 'oopsType' -InputObject 'Command'
                Set-PodeCache -Key 'oops' -InputObject $oopsCMDNameArray
                Sync-PodeWebTable -Name 'oopsDisplayTable'
            }

        }#End form scriptblock

        New-PodeWebTable -Name 'oopsDisplayTable' -DisplayName 'Recycle Bin' -DataColumn Name -NoExport -NoRefresh -Paginate -PageSize 30 -ScriptBlock {

                $tableNameOopsInfo = Get-PodeCache -Key 'oops'
                $tableNameOopsType = Get-PodeCache -Key 'oopsType'
                
                foreach ($oopsNameTab in $tableNameOopsInfo) {
                    Write-Host $oopsNameTab
                        [Ordered]@{
                            Type = $tableNameOopsType
                            Name =  $oopsNameTab.Name
                            Deleted_On = $oopsNameTab.Date
                            FullName = $oopsNameTab.Full
                            Actions = @(
                                New-PodeWebButton -Name 'restore' -DataValue $oopsNameTab.Full -Icon 'backup-restore' -IconOnly -ScriptBlock {   
                                    $restoreType = Get-PodeCache -Key 'oopsType'
                                    $sendRestoreCommand = restoreDelFile -restoreType $restoreType -restoreFullName $WebEvent.Data.Value
                                    $sendRestoreCommand | Out-Null
                                    Sync-PodeWebTable -Name 'oopsDisplayTable'
                                }

                            )#End actions

                        }#End ordered

                }#End foreach in table

                 
            } -Columns @(
                    Initialize-PodeWebTableColumn -Key 'Type' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'Name' -Alignment Center -Width 20
                    Initialize-PodeWebTableColumn -Key 'Deleted_On' -Alignment Center
                    Initialize-PodeWebTableColumn -Key 'FullName' -Hide
                ) 

    )#End container

    New-PodeWebContainer -Content @(

        New-PodeWebText -Value "The 'Purge All' button will....well, you know what that does.." -InParagraph

        New-PodeWebButton -Name 'purgeAll' -DisplayName 'Purge All' -Colour Red -ScriptBlock {

            $anyFilesChk = (Get-ChildItem -Path "./arc" -Recurse -File | Measure-Object).Count

            if ($anyFilesChk -ge 1) {
                
                Show-PodeWebModal -Id 2020 -DataValue $WebEvent.Data.Value

            } else {
                
                Update-PodeWebText -Id 4003 -Value "NO FILES"
                Update-PodeWebText -Id 4005 -Value 'There are no files to purge and the purge funtion has been stopped.' 
                Show-PodeWebModal -Id 4001
            }
        }

    )#End container

}#End page scriptblock