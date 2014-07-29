# BEGIN FUNCTION CheckFolder
Function CheckFolder
{
# NAME: CheckFolder
# PURPOSE:  To check a folder and subfolders for the presence of files.
# If any files are found in this folder, then the function returns a value of $true
    #The name of the Folder to look at
    $unsuccessfulFolder = 'C:\Temp\'
    #Get all of the filesystem objects in the folder (including subdirectories) where the object type is not a folder and count them
    $unsuccessfulFiles = Get-ChildItem $unsuccessfulFolder -Recurse #There is a simpler way to do this in newer versions of PowerShell
    $numFiles = 0
    foreach ($file in $unsuccessfulFiles)
    {
        if (-Not($file.PSIsContainer))
        {
            #Write-Host $file.Name
            $numFiles += 1
        }
    }
    if ($numFiles -gt 0)
    {
        Return $true
    }
}
# END FUNCTION CheckFolder
