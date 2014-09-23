# List all local users on the local or a remote computer  
  
$computerName = Read-Host 'Enter computer name or press <Enter> for localhost'  
  
if ($computerName -eq "") {$computerName = "$env:computername"}  
$computer = [ADSI]"WinNT://$computerName,computer"  
$users = $computer.psbase.Children | Where-Object { $_.psbase.schemaclassname -eq 'user' }

foreach ($user in $users) {
   Write-Host ($user.Name).PadRight(30) ($user.Description).PadRight(100) (((New-Object System.Security.Principal.NTAccount($user.Name)).Translate([System.Security.Principal.SecurityIdentifier])).Value)
}
