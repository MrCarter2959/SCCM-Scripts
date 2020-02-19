###################################################################################
# Initialize Array's
$diskArray = New-Object System.Collections.Generic.List[object]
$diskGet = New-Object System.Collections.Generic.List[object]
$diskSelect = New-Object System.Collections.Generic.List[object]

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

###################################################################################
# Start the Form
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$DiskSelector                    = New-Object system.Windows.Forms.Form
$DiskSelector.ClientSize         = '659,390'
$DiskSelector.text               = "DiskSelector"
$DiskSelector.TopMost            = $true

###################################################################################
# Find Available Disks
$availableDisks = foreach ($disk in Get-PhysicalDisk| Where-Object -FilterScript {$_.BusType -ne 'USB'}) {
[string]$name = $disk.FriendlyName
[string]$type = $disk.MediaType
[string]$unqiueID = $disk.UniqueID
[string]$diskNumber = Get-PhysicalDisk -UniqueId "*$unqiueID*" | Get-Disk | Select -ExpandProperty Number 
[string]$numberName = "($diskNumber) $name"
[int]$capacity = ($disk.size / 1GB)
#-UniqueId $unqiueID | Select -ExpandProperty Number
###################################################################################
# Add to the Array for DiskGrid
$diskArray.Add(
    [PSCUSTOMOBJECT] @{DiskNumber=$DiskNumber;Name=$name;Type=$type;Capacity_GB="$capacity"}
    )

###################################################################################
# Add To Disk Array For DropDownSelectors
$diskSelect.Add(
    [PSCUSTOMOBJECT] @{Name=$numberName}
    )
}
$DiskGridSource = $diskArray | Sort-Object -Property $diskArray.DiskNumber 
###################################################################################
# Set Rest of PowerShell Form

$DiskGridLabel                   = New-Object system.Windows.Forms.Label
$DiskGridLabel.Text              = 'Click on Disk Number For Which More Information Is Needed, Then Select "Disk Info":'
$DiskGridLabel.AutoSize          = $true
$DiskGridLabel.Width             = 35
$DiskGridLabel.Height            = 10
$DiskGridLabel.Location          = New-Object System.Drawing.Point(95,10)
$DiskGridLabel.Font              = 'Microsoft Sans Serif,10'


$DiskGrid                        = New-Object system.Windows.Forms.DataGridView
$DiskGrid.Name                   = "DiskGrid"
$DiskGrid.width                  = 489
$DiskGrid.height                 = 182
$DiskGrid.location               = New-Object System.Drawing.Point(105,31)
$DiskGrid.ColumnHeadersVisible   = $true
$DiskGrid.ReadOnly               = $true
$DiskGrid.DataSource             = $diskArray 
$DiskGrid.add_MouseHover($ShowHelp)

$Disks                           = New-Object system.Windows.Forms.Label
$Disks.text                      = "Disks: "
$Disks.AutoSize                  = $true
$Disks.width                     = 35
$Disks.height                    = 10
$Disks.location                  = New-Object System.Drawing.Point(19,100)
$Disks.Font                      = 'Microsoft Sans Serif,10'

$Select                          = New-Object system.Windows.Forms.Button
$Select.Name                     = "Select"
$Select.text                     = "Select"
$Select.width                    = 75
$Select.height                   = 30
$Select.location                 = New-Object System.Drawing.Point(314,328)
$Select.Font                     = 'Microsoft Sans Serif,10'
$Select.add_MouseHover($ShowHelp)
$Select.Enabled                  = 0

$DiskInfo                        = New-Object system.Windows.Forms.Button
$DiskInfo.Name                   = "DiskInfo"
$DiskInfo.text                   = "Disk Info"
$DiskInfo.width                  = 90
$DiskInfo.height                 = 30
$DiskInfo.location               = New-Object System.Drawing.Point(3,130)
$DiskInfo.Font                   = 'Microsoft Sans Serif,10'
$DiskInfo.add_MouseHover($ShowHelp)

$OSLabel                         = New-Object System.Windows.Forms.Label
$OSLabel.Text                    = "OS Drive: "
$OSLabel.AutoSize                = $True
$OSLabel.Width                   = 35
$OSLabel.Height                  = 10
$OSLabel.Location                = New-Object System.Drawing.Point(105,250)
$OSLabel.Font                    = 'Microsoft Sans Serif,10'

$OSDropDown                      = New-Object System.Windows.Forms.ComboBox
$OSDropDown.Name                 = "OSDriveSelector"
$OSDropDown.Location             = New-Object System.Drawing.Point(195,250)
$OSDropDown.Size                 = New-Object System.Drawing.Size(120,45)
$OSDropDown.DropDownStyle        = "DropDownList"
$OSDropDown.add_MouseHover($ShowHelp)

###################################################################################
# Add Items to OS Drop Down Selector
Foreach ($item in ($diskSelect.Name)) {
    $OSDropDown.Items.Add($item) | Out-Null
    }

$DataLabel                       = New-Object System.Windows.Forms.Label
$DataLabel.Text                  = "Data Drive: "
$DataLabel.AutoSize              = $True
$DataLabel.Width                 = 35
$DataLabel.Height                = 10
$DataLabel.Location              = New-Object System.Drawing.Point(385,250)
$DataLabel.Font                  = 'Microsoft Sans Serif,10'

$DataDropDown                    = New-Object System.Windows.Forms.ComboBox
$DataDropDown.Name               = "DataDriveSelector"
$DataDropDown.Location           = New-Object System.Drawing.Point(485,250)
$DataDropDown.Size               = New-Object System.Drawing.Size(120,20)
$DataDropDown.DropDownStyle      = "DropDownList"
$DataDropDown.add_MouseHover($ShowHelp)

###################################################################################
# Add Items to Data Drop Down Selector
Foreach ($item in ($diskSelect.name)) {
    $DataDropDown.Items.Add($item) | Out-Null
    }

###################################################################################
# Check to ensure, the disks selected are different in Name/DiskNumber
$handler_OSDriveDropDown_KeyUp = {
        If (($OSDropDown.Text) -ine ($DataDropDown.Text)) 
        {
            $Select.Enabled = 1
        }
        Else 
        {
            $Select.Enabled = 0
        }
    }

$OSDropDown.add_KeyUp($handler_OSDriveDropDown_KeyUp)

function CheckSelectedDrives(){
     if(($DataDropDown.Text -ine $OSDropDown.Text)){
           $Select.Enabled = 1
     }
     else{
           $Select.Enabled = 0
    }
}

$OSDropDown.Add_SelectedIndexChanged({CheckSelectedDrives})

$DataDropDown.add_SelectedIndexChanged({CheckSelectedDrives})

###################################################################################
# Set DiskInfo Form and DiskGrids
$DiskInfo.Add_Click({  
    
    $diskGet.Clear()
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $DiskInformation                 = New-Object system.Windows.Forms.Form
    $DiskInformation.ClientSize      = '729,460'
    $DiskInformation.text            = "DiskInformation"
    $DiskInformation.TopMost         = $true
    $DiskInformation.add_MouseHover($ShowHelp)

    $getDisk = Get-Disk -Number $DiskGrid.SelectedCells.Value
    #-FriendlyName $DiskGrid.SelectedCells.Value
    
    $diskGet.Add(
        [PSCUSTOMOBJECT] @{Number=$getdisk.DiskNumber;Name=$getDisk.FriendlyName;SerialNumber=$getDisk.SerialNumber;HeathStatus=$getDisk.HealthStatus;Status=$getDisk.OperationalStatus;PartitionType=$getDisk.PartitionStyle}
    )

    $DiskGridInfo                    = New-Object system.Windows.Forms.DataGridView
    $DiskGridInfo.text               = "DiskGridInfo"
    $DiskGridInfo.width              = 683
    $DiskGridInfo.height             = 354
    $DiskGridInfo.location           = New-Object System.Drawing.Point(28,14)
    $DiskGridInfo.ColumnHeadersVisible   = $true
    $DiskGridInfo.ReadOnly               = $true
    $DiskGridInfo.DataSource             = $diskGet
    $DiskGridInfo.add_MouseHover($ShowHelp)
    $DiskGridInfo.ClearSelection()

    $Close                           = New-Object system.Windows.Forms.Button
    $Close.text                      = "Close!"
    $Close.width                     = 60
    $Close.height                    = 30
    $Close.location                  = New-Object System.Drawing.Point(303,402)
    $Close.Font                      = 'Microsoft Sans Serif,10'
    $Close.add_MouseHover($ShowHelp)

    $Close.Add_Click({
        $diskGet.Clear()
        $DiskInformation.Close()
     })

    $DiskInformation.controls.AddRange(@($DiskGridInfo,$Close))
    
    $DiskInformation.ShowDialog()
    $DiskInformation.Activate()
})

###################################################################################
# Add Select Button's Click Functions
$Select.Add_Click({  

    $TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    #$TSEnv.Value("SMSTSAssignUsersMode") = "Auto"
    $tsOSD = $OSDropDown.Text.Split(" ")[0].Trim('()')
    $tsDTD = $DataDropDown.Text.Split(" ")[0].Trim('()')
    #Write-Host $tsOSD
    #Write-Host $tsDTD 

    $TSEnv.Value("OSDDiskIndex") = $tsOSD
    $TSEnv.Value("DataDrive") = $tsDTD
    Write-Host "OS Drive = $tsOSD"
    Write-Host "Data Drive = $tsDTD"

    $DiskSelector.Close()

})

###################################################################################
# Set the Form Controls
$DiskSelector.controls.AddRange(@($Label1,$Disks,$Select,$DiskInfo,$DiskGrid,$OSLabel,$DataLabel,$OSDropDown,$DataDropDown,$DiskGridInfo,$Close,$DiskGridLabel))

[void]$DiskSelector.ShowDialog()
[void]$DiskSelector.Activate()
