$ADK10SourcePath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment"
$x86Path = "C:\WinPEx86"
$x64Path = "C:\WinPEx64"
$WinPEPackage = @("winpe-wmi.cab","winpe-scripting.cab","winpe-wds-tools.cab","WinPE-PowerShell.cab","WinPE-SecureBootCmdlets.cab")
 
 
New-Item -ItemType Directory -Path "$x86Path\Mount"
New-Item -ItemType Directory -Path "$x64Path\Mount"
 
Copy-Item "$ADK10SourcePath\x86\en-us\winpe.wim" "$x86Path\boot.wim" -Verbose
Copy-Item "$ADK10SourcePath\amd64\en-us\winpe.wim" "$x64Path\boot.wim" -Verbose
 
 
#Create x86 Image
Write-Host "Mounting x86 Image" -ForegroundColor Green
Mount-WindowsImage -ImagePath "$x86Path\boot.wim" -Path "$x86Path\mount" -Index 1 -Optimize
 
Write-Host "Adding WinPE Packages" -ForegroundColor Green
 
Foreach ($PEPackage in $WinPEPackage){
Write-Host "Importing $PEPackage" -ForegroundColor Green
Start-Process -FilePath Dism.exe -ArgumentList "/image:$x86Path\mount /add-package /packagepath:'$ADK10SourcePath\x86\WinPE_OCs\$PEPackage'" -Wait
}
 
Write-Host "Committing changes to Image" -ForegroundColor Green
Dismount-WindowsImage -Path "$x86Path\mount" -save
 
#Create x64 Image
Write-Host "Mounting x64 Image" -ForegroundColor Green
Mount-WindowsImage -ImagePath "$x64Path\boot.wim" -Path "$x64Path\mount" -Index 1 -Optimize
 
Write-Host "Adding WinPE Packages" -ForegroundColor Green
 
Foreach ($PEPackage in $WinPEPackage){
Write-Host "Importing $PEPackage" -ForegroundColor Green
Start-Process -FilePath Dism.exe -ArgumentList "/image:$x64Path\mount /add-package /packagepath:'$ADK10SourcePath\amd64\WinPE_OCs\$PEPackage'" -Wait
}
 
Write-Host "Committing changes to Image" -ForegroundColor Green
Dismount-WindowsImage -Path "$x64Path\mount" -Save
