# List all local users on the local or a remote computer  
  
$computerName = Read-Host 'Enter computer name or press <Enter> for localhost'  
  
if ($computerName -eq "") {$computerName = "$env:computername"}  
$computer = [ADSI]"WinNT://$computerName,computer"  
$users = $computer.psbase.Children | Where-Object { $_.psbase.schemaclassname -eq 'user' }

foreach ($user in $users) {
   Write-Host ($user.Name).PadRight(30) ($user.Description).PadRight(100) (((New-Object System.Security.Principal.NTAccount($user.Name)).Translate([System.Security.Principal.SecurityIdentifier])).Value)
}

<#

#Domain User to SID

#This will give you a Domain User's SID

$objUser = New-Object System.Security.Principal.NTAccount("DOMAIN_NAME", "USER_NAME") 
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
$strSID.Value
  

#SID to Domain User

#This will allow you to enter a SID and find the Domain User

$objSID = New-Object System.Security.Principal.SecurityIdentifier ` 
 ("ENTER-SID-HERE") 
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount]) 
$objUser.Value 
  
#LOCAL USER to SID

$objUser = New-Object System.Security.Principal.NTAccount("LOCAL_USER_NAME") 
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
$strSID.Value

#>
