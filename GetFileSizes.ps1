cls
Write-Host "Begin"

#$boolNewOutput = $false
$boolNewOutput = $true
$boolCSV = $true
#$boolCSV = $false
$header = '--SQL Inserts--'
$header = 'Name|Size'
$baseFolder = Get-Item('C:\Temp\')
$outputFolder = Get-Item('C:\Output\')

If ($boolCSV) {
    $outputFile = Join-Path $outputFolder -ChildPath ($baseFolder.Name + ".CSV")
}
Else {
    $outputFile = Join-Path $outputFolder -ChildPath ($baseFolder.Name + ".SQL")
}
$header | Set-Content $outputFile

function GetFiles($folder) {
    foreach ($file in $(Get-ChildItem -Path $folder | Where-Object {$_.PSIsContainer -eq $false})) {
        If ($boolCSV) {
            WriteCSV $file
        }
        Else {
            WriteSQL $file
        }
    }

    foreach ($subFolder in $(Get-ChildItem -Path $folder | Where-Object {$_.PSIsContainer -eq $true})) {
        Write-Host "Retrieving files from $($subFolder.FullName)"
        if ($boolNewOutput) {
            If ($boolCSV) {
                $outputFile = Join-Path $outputFolder -ChildPath ($subFolder.Name + ".CSV")
            }
            Else {
                $outputFile = Join-Path $outputFolder -ChildPath ($subFolder.Name + ".SQL")
            }
            $header | Set-Content $outputFile
        }
        GetFiles $subFolder.FullName
    }
}

function WriteSQL($file) {
    $updateStatement = "UPDATE [Database].[Schema].[Table] SET [Column1]='$($file.Length)' WHERE [Column2]='$($file.BaseName)'";
    $updateStatement | Add-Content $outputFile
    $updateStatement
}

function WriteCSV($file) {
    $csvLine = $($file.BaseName) + "|" + $($file.Length).ToString()
    $csvLine | Add-Content $outputFile
    $csvLine
}

GetFiles $baseFolder

Write-Host "Complete"
