#http://ss64.com/ps/syntax-dateformats.html
#Get-ChildItem *.zip | Foreach {"$($_.DirectoryName)\$($_.BaseName) $(get-date -f yyyy-MM-dd)$($_.extension)"}

$fileName = Get-Item('C:\Temp\myFile.txt')
$fileBase = $fileName.BaseName
$fileExt = $fileName.Extension
$timeStampFileName = $fileBase + $(get-date -f yyyy-MM-dd_hh.mm.ss.m.fff) + $fileExt
$timeStampFileName
