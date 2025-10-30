Add-PodeWebPage -Name 'CMDDisplay' -Hide -DisplayName 'Command Information' -ScriptBlock {

        New-PodeWebContainer -Content @(
        #Pull info to page
        $getCMDCacheName = Get-PodeCache -Key 'CMDC'
        $getcmdMetaName = $getCMDCacheName + ".json"
        $getcmdMetaData = Get-Content "./files/commands/full/$getcmdMetaName" | ConvertFrom-Json
        
            $cmdMetaRef = $getcmdMetaData.Ref
            $cmdMetaLang = $getcmdMetaData.Lang
            $cmdMetaNote = $getcmdMetaData.Note
            $cmdMetaCommand = $getcmdMetaData.Command
            $cmdMetaParent = $getcmdMetaData.Parent
            $cmdMetaEx = $getcmdMetaData.Ex
            $cmdMetaOpt = $getcmdMetaData.Opt

                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Command: " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebText -Value  $cmdMetaCommand -CssClass 'orange'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Description: " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebText -Value $cmdMetaRef -CssClass 'orange'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Options/Parameters: " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebText -Value $cmdMetaOpt -CssClass 'orange'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Language: " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebText -Value $cmdMetaLang  -CssClass 'orange'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Parent Module(If PS): " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebText -Value $cmdMetaParent -CssClass 'orange'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Examples: " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebText -Value $cmdMetaEx -CssClass 'orange'
                    )
                New-PodeWebParagraph -Elements @(
                    New-PodeWebText -Value "Notes: " -CssClass 'brightWhite' -InParagraph
                    New-PodeWebTextBox -Name 'dispNoteCMD' -Value $cmdMetaNote -CssClass 'orange'-ReadOnly -Multiline -Preformat -NoForm -DisplayName ''
                    )

            New-PodeWebButton -Name 'ReturnTocmdTable' -DisplayName 'Code Hub' -Colour Grey -ScriptBlock {
                Remove-PodeCache -Key 'CMDC'
                Move-PodeWebPage -Name 'CodeHub'
                }
              
    )#End container




}

