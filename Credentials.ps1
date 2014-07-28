#TODO: Store creds in a reg key
#These functions can be used with email scripts (for instance) in order to store passwords and login info locally without exposing and information.
#
#Sources:
#http://stackoverflow.com/questions/12460950/how-to-pass-credentials-to-the-send-mailmessage-command-for-sending-emails
#https://www.interworks.com/blogs/trhymer/2013/07/08/powershell-how-encrypt-and-store-credentials-securely-use-automation-script
#http://technet.microsoft.com/en-us/library/hh849814.aspx
#http://technet.microsoft.com/en-us/library/hh849815.aspx


Function StoreCredential($pathToCredFile)
  {
  #Pass the full path to the credential file as a parameter.
  #The encryped password will be stored in the file.
  $credential = Get-Credential
  $credential.Password | ConvertFrom-SecureString | Set-Content $pathToCredFile
  }

Function GetStoredCredential($userName, $pathToCredFile)
  {
  #Set variable equal to the GetStoredCredential function 
  $encryptedPasscodeFile = Get-Content $pathToCredFile | ConvertTo-SecureString
  New-Object System.Net.NetworkCredential($userName, $encryptedPasscodeFile); 
  }
