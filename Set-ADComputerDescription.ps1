#Sets AD Computer Description During OSD
#
#8/8/2019

#Description
[string]$Description = $args[0]
#
$Desc_Username = "username"
$Desc_Password = "password"
$DC = "domain_controller"
$Desc_Secure = (ConvertTo-SecureString -String $Desc_Password -AsPlainText -Force)
$Desc_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Desc_Username, $Desc_Secure
    #
    Try {
        Import-Module ActiveDirectory
        $TSEnv = New-Object -ComObject Microsoft.SMS.TSEnvironment
        $ComputerName = $TSEnv.Value("OSDComputerName")
        $Description = $TSEnv.Value("Description")
        Set-ADComputer -Identity $ComputerName -Description "$Description" -Credential $Desc_Credential -Server $DC
        }
    Catch {
        $_.Exception.Message ; Exit 1
    }
