Add-PodeWebPage -Name 'PSOptions' -DisplayName 'Form Options' -Icon 'typewriter' -Group 'Settings' -ScriptBlock {

    New-PodeWebHeader -Value 'Form Options' -Size 4 -Secondary 'Add or remove Catagories, Environments and PS Versions below. These will reflect as choices PS Script input.'

    New-PodeWebLine

    New-PodeWebTabs -Tabs @(

        New-PodeWebTab -Name 'Catagories' -Layouts @(

            New-PodeWebContainer -Content @(

                New-PodeWebForm -Name 'PSCatInput' -Content @(

                    New-PodeWebTextbox -Name 'psCatInput' -DisplayName 'New Catagory: '

                    ) -ScriptBlock {

                    $psCatNew = ($WebEvent.Data['psCatInput'])

                    $chkCatExist = Import-Csv -Path "./files/configs/formCatagories.csv"

                        if($chkCatExist.name -eq $psCatNew) {
                            Out-PodeWebValidation -Name 'psCatInput' -Message "Catagory name already exists."
                            RETURN
                        } else {
                            $psCatNew | Add-Content -Path "./files/configs/formCatagories.csv"
                            Sync-PodeWebTable -Name 'psCatOptionTable'
                            Reset-PodeWebForm -Name 'PSCatInput'
                        }

                }#End form 'PSCatInput'
            )#End container

            New-PodeWebContainer -Content @(

                New-PodeWebTable -Name 'psCatOptionTable' -DisplayName 'Catagory Options' -Compact -DataColumn 'Name' -NoExport -NoRefresh -ScriptBlock {

                    $currentCatOptions = Import-Csv -Path "./files/configs/formCatagories.csv"
                    
                        foreach ($cat in $currentCatOptions) {
                            $catName = $cat.Name
                            [ordered]@{
                                Name = $catName
                                Remove = @(
                                    New-PodeWebButton -Name 'Remove' -Icon 'select-remove' -DataValue $catName -IconOnly -ScriptBlock {
                                        $catToRemove = $WebEvent.Data.Value
                                        $delCat = Import-CSV -Path "./files/configs/formCatagories.csv"
                                        $filterCat = $delCat | Where-Object { $_.Name -ne "$catToRemove"}
                                        $filterCat | Export-Csv -Path "./files/configs/formCatagories.csv" -NoTypeInformation
                                        Sync-PodeWebTable -Name 'psCatOptionTable'
                                    }
                                )
                            }
                        }

                }#End catagory options table
            )#End container
        )#End tab 'Catagories'


        New-PodeWebTab -Name 'Environments' -Layouts @(

            New-PodeWebContainer -Content @(

                New-PodeWebForm -Name 'PSEnvInput' -Content @(

                    New-PodeWebTextbox -Name 'psEnvInput' -DisplayName 'New Environment: '

                    ) -ScriptBlock {

                    $psEnvNew = ($WebEvent.Data['psEnvInput'])

                    $chkEnvExist = Import-Csv -Path "./files/configs/formEnvironments.csv"

                        if($chkEnvExist.env -eq $psEnvNew) {
                            Out-PodeWebValidation -Name 'psEnvInput' -Message "Environment name already exists."
                            RETURN
                        } else {
                            $psEnvNew | Add-Content -Path "./files/configs/formEnvironments.csv"
                            Sync-PodeWebTable -Name 'psEnvOptionTable'
                            Reset-PodeWebForm -Name 'PSEnvInput'
                        }

                }#End form 'PSCatInput'

            )#End container 
            
            New-PodeWebContainer -Content @(

                New-PodeWebTable -Name 'psEnvOptionTable' -DisplayName 'Environment Options' -Compact -DataColumn 'Environment' -NoExport -NoRefresh -ScriptBlock {

                    $currentEnvOptions = Import-Csv -Path "./files/configs/formEnvironments.csv"
                    
                        foreach ($env in $currentEnvOptions) {
                            $envName = $env.env
                            [ordered]@{
                                Environment = $envName
                                Remove = @(
                                    New-PodeWebButton -Name 'Remove' -Icon 'select-remove' -DataValue $envName -IconOnly -ScriptBlock {
                                        $envToRemove = $WebEvent.Data.Value
                                        $delEnv = Import-CSV -Path "./files/configs/formEnvironments.csv"
                                        $filterEnv = $delEnv | Where-Object { $_.env -ne "$envToRemove"}
                                        $filterEnv | Export-Csv -Path "./files/configs/formEnvironments.csv" -NoTypeInformation
                                        Sync-PodeWebTable -Name 'psEnvOptionTable'
                                    }
                                )
                            }
                        }

                }#End version options table
            )#End container

        )#End tab 'Environments'


        New-PodeWebTab -Name 'PS Versions' -Layouts @(

            New-PodeWebContainer -Content @(  
        
                New-PodeWebForm -Name 'PSVerInput' -Content @(

                    New-PodeWebTextbox -Name 'psVerInput' -DisplayName 'New PS Version: '

                    ) -ScriptBlock {

                        $psVerNew = ($WebEvent.Data['psVerInput'])

                        $chkVerExist = Import-Csv -Path "./files/configs/formPSVersions.csv"
    
                            if($chkVerExist.versions -eq $psVerNew) {
                                Out-PodeWebValidation -Name 'psVerInput' -Message "Version already exists."
                                RETURN
                            } else {
                                $psVerNew | Add-Content -Path "./files/configs/formPSVersions.csv"
                                Sync-PodeWebTable -Name 'psVerOptionTable'
                                Reset-PodeWebForm -Name 'PSVerInput'
                            }
                    
                }
            )#End container 
            
            New-PodeWebContainer -Content @(

                New-PodeWebTable -Name 'psVerOptionTable' -DisplayName 'Version Options' -Compact -DataColumn 'PS_Version' -NoExport -NoRefresh -ScriptBlock {

                    $currentVerOptions = Import-Csv -Path "./files/configs/formPSVersions.csv"
                    
                        foreach ($ver in $currentVerOptions) {
                            $verName = $ver.versions
                            [ordered]@{
                                PS_Version = $verName
                                Remove = @(
                                    New-PodeWebButton -Name 'Remove' -Icon 'select-remove' -DataValue $verName -IconOnly -ScriptBlock {
                                        $verToRemove = $WebEvent.Data.Value
                                        $delVer = Import-CSV -Path "./files/configs/formPSVersions.csv"
                                        $filterVer = $delVer | Where-Object { $_.versions -ne "$verToRemove"}
                                        $filterVer | Export-Csv -Path "./files/configs/formPSVersions.csv" -NoTypeInformation
                                        Sync-PodeWebTable -Name 'psVerOptionTable'
                                    }
                                )
                            }
                        }

                }#End version options table
            )#End container
        )#End tab 'Versions'

    )#End tabs
}#End page scriptblock