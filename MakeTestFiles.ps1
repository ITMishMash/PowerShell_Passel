#Used for creating test files on an interval currently set to one second
#Will create an empty text file for testing file transfers, folder watching, etc. scripts
#TO DO: Create and handle limiting the number of iterations

$destFolder = 'C:\DestinationFolder\'   #Destination folder of empty files
$timeInterval = 1                       #In seconds

$timeStamp = Get-Date -Format o | foreach {$_ -replace ":", "."}

$i=0

While(1) {
  $i++
  $destFile = $timeInterval + "s_Transfer_"+$timeStamp+"_"+$i+"_.txt"
  $dest = Join-Path $destFolder -ChildPath $destFile
  $stream = [System.IO.StreamWriter] $dest
  $stream.close()
  Start-Sleep -s $timeInterval
}
