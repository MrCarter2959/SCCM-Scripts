###################################################
# Function found from TechNet Blog below
# https://gallery.technet.microsoft.com/scriptcenter/Dump-OU-structure-visually-c057453c
function Recurse-OU ([string]$dn, $level = 1) 
{ 
    if ($level -eq 1) { $dn } 
    Get-ADOrganizationalUnit -filter * -SearchBase $dn -SearchScope OneLevel |  
        Sort-Object -Property distinguishedName |  
        ForEach-Object { 
            $components = ($_.distinguishedname)
            "$('--' * $level) $($components)" 
            Recurse-OU -dn $_.distinguishedname -level ($level+1) 
        } 
} 

###################################################################################
# Set ToolTips and their Help
$tooltip = New-Object System.Windows.Forms.ToolTip
$ShowHelp={
    Switch ($this.name) 
    {
        "DiskInfo"  {$tip = "Shows More Infomration About Selected Disk When Disk Name Is Highlighted"}
        "OSDriveSelector" {$tip = "Select Operating System Drive
*** (DiskNumber) Drive Name"}
        "DataDriveSelector" {$tip = "Select System Data Drive
*** (DiskNumber) Drive Name"}
        "DiskGrid" {$tip = "Shows Available Drives"}
        "Select" {$tip = "Sends The Drive Selections to TS Variable.
         *** If Select Is Unavailable, Ensure, Each Drop Down Is Unique.
         *** If Drop Down's Aren't Unique, Re-Select Unique Options"}
        "DiskGridInformation" {$tip = "Shows More Details About Selected Drive"}
        "DiskGridInfo" {$tip = "Available Details About Selected Drive"}
        "Close!" {$tip = "Closes Out DiskGridInformation Window"}
        
    }
    $tooltip.SetToolTip($this,$tip)
} 

                Add-Type -AssemblyName System.Windows.Forms
                [System.Windows.Forms.Application]::EnableVisualStyles()
                $ADOUUnit                        = New-Object system.Windows.Forms.Form
                $ADOUUnit.ClientSize             = '723,193'
                $ADOUUnit.text                   = "ADOUUnit"
                $ADOUUnit.TopMost                = $false
                $ADOUUnit.AutoSize               = $True
                #$ADOUUnit.AutoSizeMode           = "GrowAndShrink"

                $ADOUSearch                      = New-Object System.Windows.Forms.ComboBox
                $ADOUSearch.Name                 = "ADOUSearch"
                $ADOUSearch.text                 = "Find OU Unit"
                $ADOUSearch.width                = 549
                $ADOUSearch.height               = 41
                $ADOUSearch.Location             = New-Object System.Drawing.Point(113,50)
                $ADOUSearch.Font                 = 'Microsoft Sans Serif,10'
                $ADOUSearch.DropDownStyle        = 'DropDownList'
                $ADOUSearch.AutoSize             = $true

                $ADOUSearchText                  = New-Object System.Windows.Forms.TextBox
                $ADOUSearchText.Name             = "ADOUSearchText"
                $ADOUSearchText.Multiline        = $false
                $ADOUSearchText.Width            = 182
                $ADOUSearchText.Height           = 20
                $ADOUSearchText.Location         = New-Object System.Drawing.Point(113,25)
                $ADOUSearchText.Font             = 'Microsoft Sans Serif,10'

                $ADOUSearchLabel                 = New-Object System.Windows.Forms.Label
                $ADOUSearchLabel.Name            = "ADOUSearchLabel"
                $ADOUSearchLabel.Text            = "Search Text:"
                $ADOUSearchLabel.AutoSize        = $True
                $ADOUSearchLabel.Width           = 25
                $ADOUSearchLabel.Height          = 10
                $ADOUSearchLabel.Location        = New-Object System.Drawing.Point(10,27)
                $ADOUSearchLabel.Font            = 'Microsoft Sans Serif,10' 

                $ADOUSearchButton                = New-Object System.Windows.Forms.Button
                $ADOUSearchButton.Name           = "ADOUSearchButton"
                $ADOUSearchButton.Text           = "Search!"
                $ADOUSearchButton.Width          = 75
                $ADOUSearchButton.Height         = 30
                $ADOUSearchButton.Location       = New-Object System.Drawing.Point(325,19)
                $ADOUSearchButton.Font           = 'Microsoft Sans Serif,10'
                
                $ADOUSearchButton.Add_Click({
                    $ADOUSearch.Items.Clear()
                    $ADOUSearchButton_Search = Get-ADOrganizationalUnit -Filter "name -like '$($ADOUSearchText.Text)'" | Select -ExpandProperty DistinguishedName
                    #-Filter "UserPrincipalName -eq '$($newUser.UPN)'"
                    Foreach ($SearchOU in $ADOUSearchButton_Search) 
                        {
                            $ADOUSearch.Items.Add($SearchOU) | Out-Null
                        }
                                
                })

                $ADOUTreeLabel                  = New-Object System.Windows.Forms.Label
                $ADOUTreeLabel.Name             = "ADOUTreeLabel"
                $ADOUTreeLabel.Text             = "AD OU Tree: "
                $ADOUTreeLabel.AutoSize         = $True
                $ADOUTreeLabel.Width            = 25
                $ADOUTreeLabel.Height           = 10
                $ADOUTreeLabel.Location         = New-Object System.Drawing.Point(10,100)
                $ADOUTreeLabel.Font             = 'Microsoft Sans Serif,10'

                $ADOUUnitCombo                       = New-Object system.Windows.Forms.ComboBox
                $ADOUUnitCombo.Name                  = "ADOUUnitCombo"
                $ADOUUnitCombo.text                  = "ADOUUnit"
                $ADOUUnitCombo.width                 = 549
                $ADOUUnitCombo.height                = 41
                $ADOUUnitCombo.location              = New-Object System.Drawing.Point(113,100)
                $ADOUUnitCombo.Font                  = 'Microsoft Sans Serif,10'
                $ADOUUnitCombo.DropDownStyle         = 'DropDownList'
                
                $AD_OU = Recurse-OU -dn "OU_PATH"

                foreach ($OU in $AD_OU) {
                $ADOUUnitCombo.Items.Add($OU) | Out-Null
                }

                $Continue                        = New-Object system.Windows.Forms.Button
                $Continue.Name                   = "Continue"
                $Continue.text                   = "Continue"
                $Continue.width                  = 101
                $Continue.height                 = 30
                $Continue.location               = New-Object System.Drawing.Point(322,150)
                $Continue.Font                   = 'Microsoft Sans Serif,10,style=Bold'

                $ADOUUnit.Controls.AddRange(@($Continue,$ADOUUnitCombo,$ADOUSearch,$ADOUSearchLabel,$ADOUSearchText,$ADOUSearchButton, $ADOUUnitCombo, $ADOUTreeLabel))
                 
                $TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment

                $Continue.Add_Click({
                     If ($ADOUUnitCombo.SelectedItem -ne "")
                        {
                            If ($ADOUUnitCombo.SelectedItem -like "-*")
                                {
                                    $ChosenOU = $ADOUUnitCombo.SelectedItem.Replace("-","")
                                    $ChosenOU = $ChosenOU.Replace(" ","")
                                    $TSEnv.Value("OUUnit") = $ChosenOU
                                    Write-Host $ChosenOU
                                }
                            Else
                                {
                                    $ChosenOU = $ADOUUnitCombo.SelectedItem
                                }
                        }
                    If ($ADOUSearch.SelectedItem -ne "")
                        {
                            $ChosenOU = $ADOUSearch.SelectedItem
                            $TSEnv.Value("OUUnit") = $ChosenOU
                            Write-Host $ChosenOU
                        }
                    If ($ADOUUnitCombo.SelectedItem -eq $null -and $ADOUSearch.SelectedItem -eq $null)
                            {
                                $TSEnv.Value("OUUnit") = "OU_PATH"
                                Write-Host "OU_PATH"
                            }
                        
                $ADOUUnit.Close()
                })
                  
                [void]$ADOUUnit.ShowDialog()
                [void]$ADOUUnit.Activate()
