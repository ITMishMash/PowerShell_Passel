cls

$parentFolder = Get-Item 'C:\Temp'
#Get all files in a folder
$fileList = Get-ChildItem $parentFolder -recurse | Where-Object {$_.PSIsContainer -eq $False}
#Get all empty folders in a folder
$emptyFolderList = Get-ChildItem $parentFolder -recurse | Where-Object {$_.PSIsContainer -eq $True -and $_.GetFiles().Count -eq 0}

#Cycle through all the files and see if they have been modified
#If they have been modified, move or delete them if they were modified more than 15 minutes ago
Write-Host "FILE LIST"
foreach ($file in $fileList)
{
    if ($file.CreationTime -lt $file.LastWriteTime.AddSeconds(-30))
    {
        Write-Host "File $($file.Name) has been modified"
            "`tCreated:  $($file.CreationTime) `r`n`tModified: $($file.LastWriteTime)"
        if ($file.LastWriteTime -lt $(Get-Date).AddMinutes(-15))
            {
                Write-Host "`t`tFile $($file.Name) was modified more than 15 minutes ago"
            }
    }
}

#Cycle through the empty folders
#If the folder has been empty for more than 15 minutes, delete it
Write-Host "`r`n`r`n`r`nEMPTY FOLDERS"
foreach ($emptyFolder in $emptyFolderList)
{
    if ($emptyFolder.LastWriteTime -lt $(Get-Date).AddMinutes(-15))
    {
        Write-Host "$($emptyFolder.Name) will be deleted."
            "`tLast Modified $($emptyFolder.LastWriteTime)"
    }
}
