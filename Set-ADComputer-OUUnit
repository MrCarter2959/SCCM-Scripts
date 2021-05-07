<#
.NAME
    Set-ADComputer-OUUnit.ps1
.Author
    CSema2959
.Revision
    2.0 - ReWritten to Reflect Better Code Design and Layout
.UPDATED
   2.0 - 5/6/2020 - Refresh Due To Script Additions and Changes

   1.0 - 8/9/2019 - Inital Creation
.RESOURCES
    https://mickitblog.blogspot.com/2014/08/sccm-moving-computer-to-different-ous.html
    https://github.com/MicksITBlogs/PowerShell/blob/master/MoveComputerToOU.ps1
#>

###################################################################################
# Set Credentials
$Desc_Username = "domain\username"
$Desc_Password = "password"
$DC = "domain_controller"
$Desc_Secure = (ConvertTo-SecureString -String $Desc_Password -AsPlainText -Force)
$Desc_Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Desc_Username, $Desc_Secure

###################################################################################
# Set Variables
Set-Variable -Name CurrentOU -Scope Global -Force  
Set-Variable -Name NewOU -Scope Global -Force  

###################################################################################
# Start Try/Catch Loop
    Try {
        ###################################################################################
        # Import Required Modules
        Import-Module ActiveDirectory
        ###################################################################################
        # Start TS Variables
        $TSEnv = New-Object -ComObject Microsoft.SMS.TSEnvironment
        ###################################################################################
        # Pull Required Variables
        $OSDComputerName = $TSEnv.Value("OSDComputerName")
        $NewOU = $TSEnv.Value("OUUnit") # Enter your new OU Here, can be static, can be dynamic, This current pulls from a TS Variable
        ###################################################################################
        # Find Current OU Unit
        $CurrentOU = Get-ADComputer $OSDComputerName -Credential $Desc_Credential -Server $DC | Select -ExpandProperty DistinguishedName
        #$CurrentOU = $CurrentOU.split(",")[1,2,3] -join ","
        ###################################################################################
        # Write OU's to Console Window When Testing
            Write-Host "Computer Name:"$OSDComputerName -BackgroundColor DarkCyan -ForegroundColor White
            #$OSDComputerName
            Write-Host "Current OU:"$CurrentOU -BackgroundColor DarkCyan -ForegroundColor White
            Write-Host "Target OU:"$NewOU -BackgroundColor DarkCyan -ForegroundColor White
        ###################################################################################
        # Move Computer Object To OU
        Move-ADObject -identity $CurrentOU -TargetPath "$NewOU" -Credential $Desc_Credential -Server $DC -Verbose
        $CurrentOU = Get-ADComputer $OSDComputerName -Credential $Desc_Credential -Server $DC | Select -ExpandProperty DistinguishedName
        $CurrentOU = $CurrentOU.split(",")[1,2,3] -join ","
        ###################################################################################
        # Write New OU To Console Window When Testing
            Write-Host "New OU:"$CurrentOU -BackgroundColor DarkCyan -ForegroundColor White
        }
    Catch {
        $_.Exception.Message ; Exit 1
    }
