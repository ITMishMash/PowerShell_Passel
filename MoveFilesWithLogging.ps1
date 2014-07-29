#This will move files and folders
#Add the PSIsContainer to filter out folders

Set-Location 'C:\Windows\Temp'
$sourceFolder = 'C:\MySourceFolder\'
Set-Location $sourceFolder

$destFolder = 'C:\MyDestinationFolder\'

$fileList = Get-ChildItem $sourceFolder

if($fileList){
    foreach($file in $fileList) {
        Move-Item $file.FullName $destFolder
        #Add logging here if required
    }
}
