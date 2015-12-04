#Use this to list select running processes and store them to a txt file.
#Good for older Windows versions where task manager does not list many details.
#The if ((($proc.ProcessName -eq "obclnt.exe") is optional. I used to to list only processes with a certain string in the command line
#Comment out the if ((($proc.ProcessName -eq "obclnt.exe") and ending brace if not required.

#TODO: Add wildcard matching to process names

$process = "wscript.exe", "cscript.exe", "powershell.exe", "winscp.exe"
$timeToStale = 60 #In minutes

$Global:msgBody = "<style>td {padding: 0px 10px 0px 0px;white-space:nowrap;}</style>"
$Global:msgBody += "<p>Found processes matching: "+$process+"</p>"
$Global:msgBody += "<p>Please determine whether or not these processes should still be running.</p>"
$Global:msgBody += "<br></br><br></br>"
$Global:msgBody += "<table padding=`"10`">"
$Global:msgBody += "<tr BGCOLOR=`"#99CCFF`"><td>PROCESS NAME</td><td>AGE</td><td>CREATION DATE</td><td>PID</td><td>USER</td><td>COMMAND LINE</td></tr>"

function regConvert ($convertThis) {
    for ($i = 0; $i -le $convertThis.Length - 1; $i++) {
        $esc += [Regex]::Escape($convertThis[$i])
    }
    return $esc
}

Write-Host "`r`n-------------------------------------------------------`r`n"

$procJobs = (Get-WmiObject win32_process | where{If($process -match $(regConvert($_.ProcessName))){$TRUE}})

$numJobs = ($procJobs | Measure-Object).count
$oldJobs = 0
if ($numJobs -gt 0) {
  foreach ($proc in $($procJobs|Sort-Object -Property ProcessName, CreationDate)) {
    Write-Host $proc
    if (([WMI]'').ConvertToDateTime($proc.creationdate)-lt ((Get-Date).AddMinutes(-$timeToStale))) {
      $oldJobs += 1
      if ($oldJobs % 2 -eq 0) {
        $Global:msgBody += "<tr>"
      }
      else{
        $Global:msgBody += "<tr BGCOLOR=`"#D6E0FF`">"
      }
      $procAge = (New-TimeSpan -Start ([WMI]'').ConvertToDateTime($proc.creationdate) -End $(Get-Date))
      
      $Global:msgBody += "<td>"
      $Global:msgBody += $proc.ProcessName
      $Global:msgBody += "</td>"
      $Global:msgBody += "<td>"
      $Global:msgBody += "$($procAge.Days)d $($procAge.Hours)h $([int]$procAge.Minutes)m"
      $Global:msgBody += "</td>"
      $Global:msgBody += "<td>"
      $Global:msgBody += ([WMI]'').ConvertToDateTime($proc.creationdate)
      $Global:msgBody += "</td>"
      $Global:msgBody += "<td>"
      $Global:msgBody += $proc.ProcessId
      $Global:msgBody += "</td>"
      $Global:msgBody += "<td>"
      $Global:msgBody += $($proc.getowner().domain 
      $Global:msgBody += "\"
      $Global:msgBody += $proc.getowner().user)
      $Global:msgBody += "</td>"
      $Global:msgBody += "<td>"
      $Global:msgBody += $($proc.commandline).Replace("//","")
      $Global:msgBody += "</td>"
      $Global:msgBody += "</tr>"
    }
  }
}

$Global:msgBody += "</table>"
$numJobs
$oldJobs
if ($oldJobs -gt 0) {
    $mailFrom = "email@email.com" 
    $mailTo= "email@email.com", "anotheremail@email.com"

    $msgSubject =  "$oldJobs jobs older than $timeToStale minutes found on $([System.Net.Dns]::GetHostName())"

    Send-MailMessage -to $mailTo -from $mailFrom -subject $msgSubject -body $Global:msgBody -smtpserver "localhost" -BodyAsHtml -Priority High 
    Write-Host "Email sent!" 

    #$msgSubject
    #$Global:msgBody
}
