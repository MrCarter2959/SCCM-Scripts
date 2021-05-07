Import-Module ActiveDirectory


$adComputer = Get-ADComputer -Identity "COMPUTERNAME"
$BitLocker = Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $adComputer.DistinguishedName -Properties 'msFVE-RecoveryPassword'

#$BitLocker
Write-Host $BitLocker.'msFVE-RecoveryPassword'
$passwordID = $BitLocker.Name.Split("{")[1]
$passwordID = $passwordID -replace '[}]',''


Write-Host $passwordID
