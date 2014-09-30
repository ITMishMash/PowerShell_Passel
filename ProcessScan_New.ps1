#Use this to list select running processes and store them to a txt file.
#Good for older Windows versions where task manager does not list many details.
#The if ((($proc.ProcessName -eq "obclnt.exe") is optional. I used to to list only processes with a certain string in the command line
#Comment out the if ((($proc.ProcessName -eq "obclnt.exe") and ending brace if not required.

function regConvert ($convertThis) {
    for ($i = 0; $i -le $convertThis.Length - 1; $i++) {
        $esc += [Regex]::Escape($convertThis[$i])
    }
    return $esc
}

$sortVal = 0
$sortVal = Read-Host "`r`n`r`n<1> Process Name `r`n<2> Creation Date `r`n<3> PID`r`n<4> User Name`r`n`r`nChoose sort option"
if (-not($sortVal -ge 1 -and $sortVal -le 4)) {
    $sortVal = 0
}

Write-Host "`r`n-------------------------------------------------------`r`n"

$process = "wscript.exe", "cscript.exe", "obclnt32.exe", "powershell.exe", "conhost.exe", "notepad++.exe"

$procJobs = (Get-WmiObject win32_process | where{If($process -match $(regConvert($_.ProcessName))){$TRUE}})

$numJobs = ($procJobs | Measure-Object).count
if ($numJobs -gt 0) {
  $colProcesses = @()
  $fileOutput = Join-Path ([Environment]::GetFolderPath("Desktop")) -ChildPath 'ProcessScanner.txt'
  Out-File $fileOutput -inputobject "$(Get-Date) RESULTS`r`n`r`n" -Encoding "Default"
  foreach ($proc in $procJobs) {
    #if ((($proc.ProcessName -eq "obclnt.exe") -and ($proc.commandline.ToLower().Contains("ODBC".ToLower()))) -or ($proc.ProcessName -ne "obclnt.exe")) {
      $objProc = New-Object System.Object
      $objProc | Add-Member -type NoteProperty -name ProcessName -value $proc.ProcessName
      $objProc | Add-Member -type NoteProperty -name User -value $($proc.getowner().domain + "\" + $proc.getowner().user)
      $objProc | Add-Member -type NoteProperty -name CommandLine -value $proc.commandline
      $objProc | Add-Member -type NoteProperty -name CreationDate -value ([WMI]'').ConvertToDateTime($proc.creationdate)
      $objProc | Add-Member -type NoteProperty -name ProcessID -value $proc.ProcessId
      
      $colProcesses += $objProc
      $objProc
    #}
  }
  $colProcesses | Sort-Object `
    {switch ($sortVal) {
        0 {'ProcessID'}
        1 {'ProcessName'}
        2 {'CreationDate'}
        3 {'ProcessID'}
        4 {'User'}
    }} | `
    Format-Table -auto | `
    Out-File $fileOutput -Encoding "Default" -Append
}
Write-Host "$numJobs jobs found..."
Write-Host "Results written to $fileOutput"
$out = Read-Host 'Press Enter...'
