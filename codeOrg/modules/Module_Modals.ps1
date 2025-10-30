Function modals_funk {

#Modals for the hub pages---------------------------------------------------------------------------------------------------Start

    #This modal is used for the delete powershell script entries from both the table and the entry view
    New-PodeWebModal -Id 1001 -Name 'DelPSScript' -DisplayName "Delete PS Script and Info" -SubmitText 'Delete' -Content @(

        New-PodeWebText -Value "Are you sure you want to DELETE the script and its information?" -CssClass 'brightRed'
        
        ) -ScriptBlock {

            $actScript = $WebEvent.Data.Value
            $actScriptName = $actScript + ".ps1"
            $actScriptHTML = $actScript + ".html"
            $actScriptMeta = $actScript + ".json"

            $arcDateTime = Get-Date -Format "MM.dd.yyyy_HH.mm.ss"
            $arcSave = $arcDateTime + "_" + $actScript
            $arcSavePath = "./arc/pss/$arcSave"
            
            New-Item -Path $arcSavePath -ItemType Directory | Out-Null
            #[System.IO.Directory]::CreateDirectory("$arcSavePath")

            Move-Item -Path "./files/powershell/scripts/$actScriptName" -Destination $arcSavePath
            Move-Item -Path "./files/powershell/scriptsMeta/$actScriptMeta" -Destination $arcSavePath
            Move-Item -Path "./files/powershell/scriptsHTML/$actScriptHTML" -Destination $arcSavePath
            
            Sync-PodeWebTable -Name 'ScriptTable'

            Hide-PodeWebModal
        
        }#End Modal 'DelPSScript'

    #This modal is used for returning to code table page or keep adding to code
    New-PodeWebModal -Id 1002 -Name 'codeComplete' -DisplayName "Code Submitted" -SubmitText 'Go To Code Table' -CloseText 'Add More' -Content @(

        New-PodeWebText -Value "Your code has been submitted to the system and is now available in the Code Hub" -CssClass 'brighWhite'
        
            ) -ScriptBlock {

                Move-PodeWebPage -Name 'CodeHub'

        }#End modal 'codeComplete'


      #This modal is used for the delete command entries from both the table and the entry view
    New-PodeWebModal -Id 1003 -Name 'DelCommand' -DisplayName "Delete Command Info" -SubmitText 'Delete' -Content @(

        New-PodeWebText -Value "Are you sure you want to DELETE the command and all its information?" -CssClass 'brightRed'
        
        ) -ScriptBlock {

            $actCMD = $WebEvent.Data.Value
            $actCMDInfo = $actCMD + '.json'

            $CMDDateTime = Get-Date -Format "MM.dd.yyyy_HH.mm.ss"
            $CMDSave = $CMDDateTime + "_" + $actCMD
            $CMDSavePath = "./arc/cmd/$CMDSave"
            
            New-Item -Path $CMDSavePath -ItemType Directory | Out-Null

            Move-Item -Path "./files/commands/full/$actCMDInfo" -Destination $CMDSavePath
            Remove-Item -Path "./files/commands/tbl/$actCMDInfo" -Force | Out-Null

            Sync-PodeWebTable -Name 'CommandTable'

            Hide-PodeWebModal
        
        }#End Modal 'DelPSScript'

    #This modal is used for returning to commands table page or keep adding to CMD
    New-PodeWebModal -Id 1004 -Name 'cmdComplete' -DisplayName "Command Submitted" -SubmitText 'Go To CMD Table' -CloseText 'Add More' -Content @(

        New-PodeWebText -Value "Your command has been submitted to the system and is now available in the Code Hub" -CssClass 'brighWhite'
        
            ) -ScriptBlock {

                Move-PodeWebPage -Name 'CodeHub'

        }#End modal 'cmdComplete'

    #This modal is used for returning to sql table page or keep adding to SQL  
    New-PodeWebModal -Id 1005 -Name 'sqlComplete' -DisplayName "SQL Submitted" -SubmitText 'Go To SQL Table' -CloseText 'Add More' -Content @(

    New-PodeWebText -Value "Your SQL has been submitted to the system and is now available in the Code Hub" -CssClass 'brighWhite'
    
        ) -ScriptBlock {

            Move-PodeWebPage -Name 'CodeHub'

    }#End modal 'cmdComplete'

    
    #This modal is used for returning to commands table page or keep adding to KQL   
    New-PodeWebModal -Id 1006 -Name 'kqlComplete' -DisplayName "KQL Submitted" -SubmitText 'Go To KQL Table' -CloseText 'Add More' -Content @(

    New-PodeWebText -Value "Your KQL has been submitted to the system and is now available in the Code Hub" -CssClass 'brighWhite'
    
        ) -ScriptBlock {

            Move-PodeWebPage -Name 'CodeHub'

    }#End modal 'cmdComplete'


    New-PodeWebModal -Id 1007 -Name 'DelKQL' -DisplayName "Delete KQL Info" -SubmitText 'Delete' -Content @(

        New-PodeWebText -Value "Are you sure you want to DELETE the KQL and all its information?" -CssClass 'brightRed'
        
        ) -ScriptBlock {
	            $actKQL = $WebEvent.Data.Value
                
                $actKQLInfo = $actKQL + ".json"
                $actKQLCode = $actKQL + ".txt"

                $KQLDateTime = Get-Date -Format "MM.dd.yyyy_HH.mm.ss"
                $KQLSave = $KQLDateTime + "_" + $actKQL
                $KQLSavePath = "./arc/kql/$KQLSave"
                
                New-Item -Path $KQLSavePath -ItemType Directory | Out-Null

                Move-Item -Path "./files/kql/kqlMeta/$actKQLInfo" -Destination $KQLSavePath
                Remove-Item -Path "./files/kql/kqlMeta/$actKQLInfo" -Force | Out-Null
                
                Move-Item -Path "./files/kql/kqlCode/$actKQLCode" -Destination $KQLSavePath
                Remove-Item -Path "./files/kql/kqlCode/$actKQLCode" -Force | Out-Null 

                Sync-PodeWebTable -Name 'KQLTable'

                Hide-PodeWebModal
        
    }#End Modal 'DelKQL'

    New-PodeWebModal -Id 1008 -Name 'DelSQL' -DisplayName "Delete SQL Info" -SubmitText 'Delete' -Content @(

        New-PodeWebText -Value "Are you sure you want to DELETE the SQL entry and all its information?" -CssClass 'brightRed'
        
        ) -ScriptBlock {

            $actSQL = $WebEvent.Data.Value
            
            $actSQLInfo = $actSQL + ".json"
			$actSQLCode = $actSQL + ".txt"

            $SQLDateTime = Get-Date -Format "MM.dd.yyyy_HH.mm.ss"
            $SQLSave = $SQLDateTime + "_" + $actSQL
            $SQLSavePath = "./arc/sql/$SQLSave"
            
            New-Item -Path $SQLSavePath -ItemType Directory | Out-Null

            Move-Item -Path "./files/sql/sqlMeta/$actSQLInfo" -Destination $SQLSavePath
            Remove-Item -Path "./files/sql/sqlMeta/$actSQLInfo" -Force | Out-Null
			
			Move-Item -Path "./files/sql/sqlCode/$actSQLCode" -Destination $SQLSavePath
            Remove-Item -Path "./files/sql/sqlCode/$actSQLCode" -Force | Out-Null

            Sync-PodeWebTable -Name 'SQLTable'

            Hide-PodeWebModal
        
        }#End Modal 'DelSQL'

    New-PodeWebModal -Id 1009 -Name 'DelSnip' -DisplayName "Delete Snippet Info" -SubmitText 'Delete' -Content @(

        New-PodeWebText -Value "Are you sure you want to DELETE the Snippet entry and all its information?" -CssClass 'brightRed'
        
        ) -ScriptBlock {

            $actSnip = $WebEvent.Data.Value
            
            $actSnipInfo = $actSnip + ".json"
			$actSnipCode = $actSnip + ".txt"

            $SnipDateTime = Get-Date -Format "MM.dd.yyyy_HH.mm.ss"
            $SnipSave = $SnipDateTime + "_" + $actSnip
            $SnipSavePath = "./arc/pssnip/$SnipSave"
            
            New-Item -Path $SnipSavePath -ItemType Directory | Out-Null

            Move-Item -Path "./files/powershell/snippetsMeta/$actSnipInfo" -Destination $SnipSavePath
            Remove-Item -Path "./files/powershell/snippetsMeta/$actSnipInfo" -Force | Out-Null
			
			Move-Item -Path "./files/powershell/snippets/$actSnipCode" -Destination $SnipSavePath
            Remove-Item -Path "./files/powershell/snippets/$actSnipCode" -Force | Out-Null

            Sync-PodeWebTable -Name 'SnipTable'

            Hide-PodeWebModal
        
        }#End Modal 'DelSQL'

#Modals for the hub pages---------------------------------------------------------------------------------------------------Stop

#Modals Generic / reusable---------------------------------------------------------------------------------------------------Start

     #Action complete modal allows for 3 sentences of standard text and/or a line of red text
     New-PodeWebModal -Id 3001 -Name '** Action Complete **' -Content @(
        New-PodeWebText -Id 3002 -Value '' -InParagraph -Alignment Center -CssClass 'brighWhite'
        New-PodeWebText -Id 3003 -Value '' -InParagraph -Alignment Center -CssClass 'brighWhite'
        New-PodeWebText -Id 3004 -Value '' -InParagraph -Alignment Center -CssClass 'brighWhite'
        New-PodeWebText -Id 3005 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
            )
    
        #Action failed modal allows for 3 sentences of red text and/or a line of standard text
    New-PodeWebModal -Id 4001 -Name 'Xx Action Failed xX' -Content @(
        New-PodeWebText -Id 4002 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
        New-PodeWebText -Id 4003 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
        New-PodeWebText -Id 4004 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
        New-PodeWebText -Id 4005 -Value '' -InParagraph -Alignment Center -CssClass 'brighWhite'
            )
    
        #Action is not allowed modal allows for 3 sentences of red text and/or a line of standard text
    New-PodeWebModal -Id 5001 -Name '!!Action Is Not Allowed!!' -Content @(
            New-PodeWebText -Id 5002 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
            New-PodeWebText -Id 5003 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
            New-PodeWebText -Id 5004 -Value '' -InParagraph -Alignment Center -CssClass 'brightRed'
            New-PodeWebText -Id 5005 -Value '' -InParagraph -Alignment Center -CssClass 'bisque'
            )

#Modals Generic / reusable---------------------------------------------------------------------------------------------------Stop

#Modals for Recycle Bin / Oops---------------------------------------------------------------------------------------------------Start

    New-PodeWebModal -Id 2020 -Name 'Purge All - Recycle Bin' -SubmitText 'Purge' -Icon 'alert' -Content @(
        New-PodeWebText -Value "You are about to Purge all files from the Recycle Bin? Are you sure you want to do this? If so Click the Purge button"

        ) -ScriptBlock {
            Show-PodeWebModal -Id 2021
            Hide-PodeWebModal
        }

    New-PodeWebModal -Id 2021 -Name 'Are you SURE your SURE?' -SubmitText 'YES - PURGE' -Icon 'nuke' -Content @(
         New-PodeWebText -Value 'Second check to make sure you are ABSOLUTELY sure you want to purge the Recycle Bin?' -InParagraph -Alignment Center -CssClass 'brightRed'
        
         ) -ScriptBlock {

            Move-Item -Path "./arc/cmd/*" -Destination "./arc/purged/temp" | Out-Null
            Move-Item -Path "./arc/pss/*" -Destination "./arc/purged/temp" | Out-Null
            Move-Item -Path "./arc/pssnip/*" -Destination "./arc/purged/temp" | Out-Null
            Move-Item -Path "./arc/kql/*" -Destination "./arc/purged/temp" | Out-Null
            Move-Item -Path "./arc/sql/*" -Destination "./arc/purged/temp" | Out-Null

            $SourceDirectory = "./arc/purged/temp"
            $purgeDate = Get-Date -Format "MM.dd.yyyy_HH.mm.ss"
            $DestinationZipFile = "./arc/purged/" + $purgeDate + "_Purged.zip"

            # Get all subdirectories within the source directory
            $FoldersToZip = Get-ChildItem -Path $SourceDirectory -Directory

            Compress-Archive -Path $FoldersToZip.FullName -DestinationPath $DestinationZipFile -CompressionLevel Optimal

            Remove-Item -Path "./arc/purged/temp/*" -Recurse -Force

            Clear-PodeWebTable -Name 'oopsDisplayTable'

            Hide-PodeWebModal

         }#End modal scriptblock

#Modals for Recycle Bin / Oops---------------------------------------------------------------------------------------------------Stop


}#End modals function