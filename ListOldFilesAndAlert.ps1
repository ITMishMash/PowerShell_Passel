Param(
    [Alias("Folder")] 
    [parameter(Mandatory=$false)] 
    [String]  
    $FolderName
,
    [parameter(Mandatory=$false)] 
    [int]  
    $Days
,
    [parameter(Mandatory=$false)] 
    [int]  
    $Minutes 
,
    [parameter(Mandatory=$false)] 
    [int]  
    $Hours   
)

Function CheckFolderDates {
    # NAME: CheckFolder
    # PURPOSE:  To check a folder and subfolders for the presence of files.
    # If any files are found in this folder, then the function returns a value of $true
    Param(
        [Alias("FolderName")] 
        [parameter(Mandatory=$true)] 
        [String]  
        $myFolderName
    ,
        [Alias("Days")] 
        [parameter(Mandatory=$true)] 
        [int]  
        $myDays
    ,
        [Alias("Minutes")] 
        [parameter(Mandatory=$true)] 
        [int]  
        $myMinutes 
    ,
        [Alias("Hours")] 
        [parameter(Mandatory=$true)] 
        [int]  
        $myHours   
    )

    #Get all of the filesystem objects in the folder (including subdirectories) where the object type is not a folder and count them
    $myFileList = Get-ChildItem ($myFolderName) -Recurse
    $Global:numFiles = 0
    $Global:fileResults = "<style>td {padding: 0px 5px 0px 0px;}</style><table padding=`"10`">"
    foreach ($file in $myFileList)
    {
        if (-Not($file.PSIsContainer))
        {
            #Write-Host $file.Name
            if ($file.CreationTime -lt ((Get-Date).AddDays(-$myDays).AddHours(-$myHours).AddMinutes(-$myMinutes)))
            {
                $Global:fileResults += "<tr><td>"+($file.FullName)+"</td><td>"+$file.CreationTime+"</td></tr>"
                Write-Host ($file.FullName).padright(150) $file.CreationTime
                $Global:numFiles += 1
            }
        }
    }
    $Global:fileResults += "</table>"
    #Write-Host "$numFiles old files found."
    if ($Global:numFiles -gt 0)
    {
        Return $true
    }
    else
    {
        Return $false
    }
}
# END FUNCTION CheckFolder


$Global:fileResults = ""


If ($days -eq $null) {
    $days    = 0 }
If ($hours -eq $null) {
    $hours   = 0 }
If ($minutes -eq $null) { 
    $minutes = 0 }

$subject = "Old files found in $myFolderName"
$mailFrom = "an@emailaddress.com"
$mailTo= "an@emailaddress.com","another@emailaddress.com"

If (CheckFolderDates -FolderName $FolderName -Days $days -Minutes $minutes -Hours $hours) 
{
    $msgBody = "$Global:numFiles Files Older Than $days Days $hours Hours $minutes Minutes Found in $FolderName <br><br>"
    $msgBody += $Global:fileResults
    Send-MailMessage -to $mailTo -from $mailFrom -subject $subject -body $msgBody -smtpserver "localhost" -BodyAsHtml -Priority High
    Write-Host "Email sent!"
    Write-host $msgBody
}
Else
{
    Write-Host "No old files found!"
}
