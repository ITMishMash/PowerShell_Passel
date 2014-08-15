# Written by Luke Taylor 8/15/2014
#
#
# TODO: Add params to groups
# TODO: Add upload switch
# TODO: Add failure checking and notifications
# TODO: Test for existing cred file on both write and read
# TODO: Store the SshHostKeyFingerprint somewhere
# SOURCE: http://winscp.net/eng/docs/library_powershell
# PURPOSE: To download files via SFTP using WinSCP .NET assembly and encrypted credential file
#
# DEPENDENCIES: This file depends on WinSCPnet.dll available here: http://winscp.net
# DEPENDENCIES: In order to load the assembly, this script must run with administrator priveleges
# DEPENDENCIES: If an issue arises when loading the assembly, go to the assembly properties and unblock the file
#
# CONSIDERATIONS:  A key fingerprint is required to connect to the server over SFTP. Should the fingerprint change, it will need to be updated withing this script
# CONSIDERATIONS:  An explanation of the key fingerprint requirement is here:  http://winscp.net/eng/docs/faq_script_hostkey
# CONSIDERATIONS:  The password file requires the username for the key. The username entered for the SFTP connection is stored as part of the hashed password keyfile name.
# CONSIDERATIONS:  This script uses the keyfile name as decryption for the password file. If the file name should change, the decryption will fail.
#
# SAMPLE USAGE:
#  Store Credentials:
#   powershell -file winscp.ps1 -SetCred -CredPath <FolderName>
#   powershell -file winscp.ps1 -SetCred -CredPath C:\Temp
#  Download Files:
#   powershell -file winscp.ps1 -CredPath <FolderName> -Host <IP address> -Local <Local folder> -Remote <Remote Folder>
#   
#
Param(
    [Alias("SetCred")]
    [parameter(Mandatory=$false)]
    [Switch] 
    $myOption
, 
    [Alias("CredPath")]
    [parameter(Mandatory=$true)]
    [String] 
    $myCredPath 
, 
    [Alias("Host")]
    [parameter(Mandatory=$false)]
    [String] 
    $myHost
,
    [Alias("Local")]  # Do not include \
    [parameter(Mandatory=$false)]
    [String] 
    $myLocalFolder
,
    [Alias("Remote")] # Include /* or somewildcard to DL files e.g. "/home/user/sysbatch/*"
    [parameter(Mandatory=$false)]
    [String] 
    $myRemoteFolder
) 


Function StoreCredential ($pathToCredFile)
{
    # Pass the full path to the credential file as a parameter.
    # The encryped credentials will be stored in the file.
    $credential = Get-Credential
    $userName = $credential.UserName
    $pathToCredFile = Join-Path $pathToCredFile -ChildPath ($userName + '.cred')
    $credential.Password | ConvertFrom-SecureString | Set-Content $pathToCredFile
    $myCredPath | % {$_.BaseName}
}

Function GetStoredCredential ($userName, $pathToCredFile)
{
    #Set variable equal to the GetStoredCredential function 
    $encryptedPasscodeFile = Get-Content $pathToCredFile | ConvertTo-SecureString
    New-Object System.Net.NetworkCredential($userName, $encryptedPasscodeFile)
    # This can also been used
    # New-Object System.Management.Automation.PsCredential($userName, $encryptedPasscodeFile)
}

If ($myOption)
{
    StoreCredential($myCredPath)
}
Else
{
    Try
    {
        # Get the username from the credential file name
        $myUserName = ($myCredPath.Split('[\/]')[-1]).Split('.')[0]
        # Get stored credentials
        $credential = GetStoredCredential -userName $myUserName -pathToCredFile $myCredPath
        # Load WinSCP .NET assembly
        Add-Type -Path "WinSCPnet.dll"
        # This can also be used
        # [Reflection.Assembly]::LoadFrom("WinSCPnet.dll") | Out-Null 
        # Use read credentials
        $sessionOptions = New-Object WinSCP.SessionOptions
        $sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
        $sessionOptions.HostName = $myHost
        $sessionOptions.UserName = $credential.UserName
        $sessionOptions.Password = $credential.Password
        $sessionOptions.SshHostKeyFingerprint = "ssh-rsa 1024"
        $session = New-Object WinSCP.Session
 
        try
        {
            # Connect
            $session.Open($sessionOptions)
            # Upload files
            $transferOptions = New-Object WinSCP.TransferOptions
            $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
            # Set third option to $True to delete files after successful transfer
            $transferResult = $session.GetFiles($myRemoteFolder, $myLocalFolder, $True, $transferOptions)
            # Throw on any error
            $transferResult.Check()
 
            # Print results
            foreach ($transfer in $transferResult.Transfers)
            {
                Write-Host ("Upload of {0} succeeded" -f $transfer.FileName)
            }
        }
        finally
        {
            # Disconnect, clean up
            $session.Dispose()
        }
 
        exit 0
    }
    catch [Exception]
    {
        Write-Host $_.Exception.Message
        exit 1
    }
}
