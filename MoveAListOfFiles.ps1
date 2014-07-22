################################################################# 
# SCRIPT UPDATE  : Luke Taylor
# DATE           : 5-1-2014  
# COMMENT        : Move a list of files
#################################################################

#----------------------------------------------------------------
#STATIC VARIABLES
#----------------------------------------------------------------

#Location of file list
$fileList = ".\FileList.lst"
#Desination folder
$destFolder = ".\"
#Souce folder
$sourceFolder = ".\"
#Parse file list into an array
$resourceFiles = (Get-Content $fileList)
#Location of log folder
$logFile = "%USERPROFILE%\Desktop\FileMoves.log"
#TimeStamp
$timeToday = Date
$dateEntry = "Process began on:  $timeToday"
$dateEntry >> $logFile

#----------------------------------------------------------------
#MOVE FILES
#----------------------------------------------------------------
#NOTES: Update this to check for the presence of the destination directory and a file in the directory to prevent overwriting
$totalFiles = $resourceFiles.count
$i = 1
ForEach ($file In $resourceFiles)
{
	$fileToMove = $sourceFolder + "\" + $file
    if (Test-Path $fileToMove)
    {
	  Move-Item $fileToMove $destFolder
 	  Echo "Moved file: $fileToMove to: $destFolder     File $i of $totalFiles" >> $logFile
    }
    else
    {
      Echo "FAILED TO MOVE FILE: $fileToMove to: $destFolder     File $i of $totalFiles - FILE NOT FOUND" >> $logFile
    }
	$i = $i+1
}
Echo "FINISHED" >> $logFile
#Finished

