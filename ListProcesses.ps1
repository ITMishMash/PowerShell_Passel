#Use this to list select running processes and store them to a txt file.
#Good for older Windows versions where task manager does not list many details.
#The if ((($proc.ProcessName -eq "obclnt.exe") is optional. I used to to list only processes with a certain string in the command line
#Comment out the if ((($proc.ProcessName -eq "obclnt.exe") and ending brace if not required.

$process = "wscript.exe", "cscript.exe", "obclnt32.exe", "powershell.exe"
$procJobs = (Get-WmiObject win32_process | where{If($process -match '$_.ProcessName'){$TRUE}}) 
$numJobs = ($procJobs | Measure-Object).count
if ($numJobs -gt 0) {
  foreach ($proc in $procJobs) {
    if ((($proc.ProcessName -eq "obclnt.exe") -and ($proc.commandline.ToLower().Contains("ODBC".ToLower()))) -or ($proc.ProcessName -ne "obclnt.exe")) {
      $myOutput = "USER         : "
      $myOutput += $proc.getowner().domain
      $myOutput += "\"
      $myOutput += $proc.getowner().user
      $myOutput += "`r`n"
      $myOutput += "COMMAND LINE : "
      $myOutput += $proc.commandline
      $myOutput += "`r`n"
      $myOutput += "CREATION DATE: "
      $myOutput += ([WMI]'').ConvertToDateTime($proc.creationdate)
      $myOutput += "`r`n"
      $myOutput += "PROCESS ID   : "
      $myOutput += $proc.ProcessId
      $myOutput += "`r`n"
      write-host $myOutput
      Out-File ([Environment]::GetFolderPath("Desktop") + '\Processes.txt') -inputobject $myOutput -Append -Encoding "Default"
    }
  }
}
Write-Host "$numJobs jobs found..." 
$out = Read-Host 'Press Enter...'
