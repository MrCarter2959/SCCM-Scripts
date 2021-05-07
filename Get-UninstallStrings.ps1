Function Get-AppUninstallString {
####################################
# Set Parameters
param (

####################################
# Parameter Name
    [Parameter(
        Mandatory = $true,
        ParameterSetName = "ByName",
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true
    )]
    [String[]]
    $ApplicationName
)

begin {
    try {
        if (Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node") {
            $installedPrograms = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction Stop
        }
        $installedPrograms += Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction Stop
        $installedPrograms += Get-ItemProperty -Path "Registry::\HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue
    } catch {
        Write-Error $_
        break
    }
}

process {
    Foreach ($name in $ApplicationName)
        {
            Write-Host $name

            $installedPrograms = $installedPrograms.Where({$_.DisplayName -eq $name})
            Write-Host $installedPrograms
            $output = $installedPrograms.ForEach({
            [PSCustomObject]@{
                Name = $_.DisplayName
                Version = $_.DisplayVersion
                Guid = $_.PSChildName
                UninstallString = $_.UninstallString
            }
        })
        Write-Output $output

        }
}
}
Get-AppUninstallString -ApplicationName 'SQL Server Management Studio'
