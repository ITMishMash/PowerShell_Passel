#Use this to list select running processes and send an email along with an HTML attachment.
#The HTML attachment can be used to generate a taskkill process line that can be copy and pasted into the cmd
#NOTE: This script assumes the computer it is run from is the computer that is being reported on

#Good for older Windows versions where task manager does not list many details.

#The if ((($proc.ProcessName -eq "obclnt.exe") is optional. I used to to list only processes with a certain string in the command line

#Comment out the if ((($proc.ProcessName -eq "obclnt.exe") and ending brace if not required.


#TODO: Add wildcard matching to process names
#TODO: Add allprocess switch

cls




$process = "wscript.exe", "cscript.exe", "powershell.exe","winscp.exe", "cmd.exe", "winrar.exe"


#$process = "" #Uncomment and comment out the fist $process line to pull all jobs

$timeToStale = 60 #In minutes
$hostName = $([System.Net.Dns]::GetHostName()).ToUpper()



$Global:msgBodyHead  = "<!DOCTYPE html>`r`n"
$Global:msgBodyHead  += "<!-- saved from url=(0014)about:internet -->`r`n"
#$Global:msgBodyHead  += "<!-- saved from url=(0016)http://localhost -->`r`n"
$Global:msgBodyHead += "<html lang=`"en-US`">`r`n"
$Global:msgBodyHead += " <head>`r`n"
$Global:msgBodyHead += "  <title>`r`n"
$Global:msgBodyHead += "   Stale Process Report for $hostName`r`n"
$Global:msgBodyHead += "  </title>`r`n"
$Global:msgBodyHead += "  <style>`r`n"
$Global:msgBodyHead += "  thead {`r`n"
$Global:msgBodyHead += "   background-color: #99CCFF;`r`n"
$Global:msgBodyHead += "  }`r`n"
$Global:msgBodyHead += "  td {`r`n"
$Global:msgBodyHead += "   padding: 0px 10px 0px 0px;white-space:nowrap;`r`n"
$Global:msgBodyHead += "  }`r`n"
$Global:msgBodyHead += "  </style>`r`n"
$Global:msgBodyHead += "  <script type=`"text/javascript`">`r`n"
$Global:msgBodyHead += "   function taskKillAdd (checkRow) {`r`n"
$Global:msgBodyHead += "    var PIDS = document.getElementsByClassName(`"PID`");`r`n"
$Global:msgBodyHead += "    var strPIDS = `"`";`r`n"
$Global:msgBodyHead += "    for (var i = 0; i < PIDS.length; i++) {`r`n"
$Global:msgBodyHead += "     //alert (PIDS[i].value);`r`n"
$Global:msgBodyHead += "     if (PIDS[i].checked == 1) {`r`n"
$Global:msgBodyHead += "      strPIDS += `"/PID `" + PIDS[i].value + `" `";`r`n"
$Global:msgBodyHead += "     }`r`n"
$Global:msgBodyHead += "    }`r`n"
$Global:msgBodyHead += "    if (strPIDS > `"`") {`r`n"
$Global:msgBodyHead += "     document.getElementById(`"taskKillSuggestions`").value = `"taskkill /S $hostName `" + strPIDS + `"/F`";`r`n"
$Global:msgBodyHead += "    }`r`n"
$Global:msgBodyHead += "    else {`r`n"
$Global:msgBodyHead += "     document.getElementById(`"taskKillSuggestions`").value = `"`";`r`n"
$Global:msgBodyHead += "    }`r`n"
			
$Global:msgBodyHead += "   }`r`n"
$Global:msgBodyHead += "   function copyToClipboard() {`r`n"
$Global:msgBodyHead += "    var myText = document.getElementById(`"taskKillSuggestions`").value`r`n"
$Global:msgBodyHead += "    if (myText > `"`") {`r`n"
$Global:msgBodyHead += "     window.prompt(`"Copy to clipboard: Ctrl+C, Enter`", myText);`r`n"
$Global:msgBodyHead += "    }`r`n"
$Global:msgBodyHead += "   }`r`n"
$Global:msgBodyHead += "  </script>`r`n"
$Global:msgBodyHead += " </head>`r`n"

$Global:msgBodyHead += " <body>`r`n"
$Global:msgBodyHead += "  <form>`r`n"
$Global:msgBodyHead += "   <p>`r`n"
$Global:msgBodyHead += "   $hostName STALE JOB REPORT`r`n`r`n"
$Global:msgBodyHead += "    Found processes matching: wscript.exe cscript.exe powershell.exe winscp.exe cmd.exe`r`n"
$Global:msgBodyHead += "    <br />`r`n"
$Global:msgBodyHead += "    Please determine whether or not these processes should still be running.`r`n"
$Global:msgBodyHead += "   </p>`r`n"
$Global:msgBodyHead += "   <br />`r`n"
$Global:msgBodyHead += "   <table padding=`"10`" id=`"staleProcessTable`">`r`n"
$Global:msgBodyHead += "    <thead>`r`n"
$Global:msgBodyHead += "     <tr id=`"tableHeader`">`r`n"
$Global:msgBodyHead += "      <th></th>`r`n"
$Global:msgBodyHead += "      <th>PROCESS NAME</th>`r`n"
$Global:msgBodyHead += "      <th>AGE</th>`r`n"
$Global:msgBodyHead += "      <th>CREATION DATE</th>`r`n"
$Global:msgBodyHead += "      <th>PID</th>`r`n"
$Global:msgBodyHead += "      <th>USER</th>`r`n"
$Global:msgBodyHead += "      <th>COMMAND LINE</th>`r`n"
$Global:msgBodyHead += "     </tr>`r`n"
$Global:msgBodyHead += "     </thead>`r`n"
$Global:msgBodyHead += "    <tbody>`r`n"

$Global:msgBodyMain = ""

$Global:msgBodyFoot = "    </tbody>`r`n"
$Global:msgBodyFoot += "   </table>`r`n"
$Global:msgBodyFoot += "  <div>`r`n"
$Global:msgBodyFoot += "   <br />`r`n"
$Global:msgBodyFoot += "   Taskkill command: <input type=`"text`" id=`"taskKillSuggestions`" size = `"100%`" value=`"`">`r`n"
$Global:msgBodyFoot += "   <br />`r`n"
$Global:msgBodyFoot += "   <br />`r`n"
$Global:msgBodyFoot += "   Copy to clipboard: <button type = `"button`" id = `"copyToClip`" name=`"copy`" onclick=`"copyToClipboard()`">Copy</button>`r`n"
$Global:msgBodyFoot += "  </div>`r`n"
$Global:msgBodyFoot += " </form>`r`n"
$Global:msgBodyFoot += " <script>`r`n"
$Global:msgBodyFoot += " </script>`r`n"
$Global:msgBodyFoot += " </body>`r`n"
$Global:msgBodyFoot += "</html>`r`n"


function regConvert ($convertThis) {
    for ($i = 0; $i -le $convertThis.Length - 1; $i++) {
        $esc += [Regex]::Escape($convertThis[$i])
    }
    return $esc
}

Write-Host "`r`n-------------------------------------------------------`r`n"

if ($process -eq "")
{
    $procJobs = Get-WmiObject win32_process
}
else
{
    $procJobs = (Get-WmiObject win32_process | where{If($process -match $(regConvert($_.ProcessName))){$TRUE}})  
}

$numJobs = ($procJobs | Measure-Object).count
$oldJobs = 0
if ($numJobs -gt 0) {
  foreach ($proc in $($procJobs|Sort-Object -Property ProcessName, CreationDate)) {
    Write-Host $proc
    if (([WMI]'').ConvertToDateTime($proc.creationdate)-lt ((Get-Date).AddMinutes(-$timeToStale))) {
        $oldJobs += 1
        $procAge = (New-TimeSpan -Start ([WMI]'').ConvertToDateTime($proc.creationdate) -End $(Get-Date))
        $commandLine = $($proc.commandline).Replace("//","")
        $userName = $($proc.getowner().domain) + "\" +$($proc.getowner().user)
        if ($oldJobs % 2 -eq 0) {
            $Global:msgBodyMain += "     <tr  id=`"row$oldJobs`">`r`n"
        }
        else{
            $Global:msgBodyMain += "     <tr BGCOLOR=`"#D6E0FF`"  id=`"row$oldJobs`">`r`n"
        }
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       <input type=`"checkbox`" id=`"checkRow$oldJobs`" class = `"PID`" value = `"$($proc.ProcessId)`" onclick=`"taskKillAdd(checkRow1)`">`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       $($proc.ProcessName)`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       $($procAge.Days)d $($procAge.Hours)h $([int]$procAge.Minutes)m`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       $(([WMI]'').ConvertToDateTime($proc.creationdate))`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       $($proc.ProcessId)`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       $userName`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += "       $commandLine`r`n"
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "     </tr>`r`n"
        }
    }
}

$msgBody = $Global:msgBodyHead + $Global:msgBodyMain + $Global:msgBodyFoot
$numJobs
$oldJobs
if ($oldJobs -gt 0) {
    $htmlAttachment = Join-Path -Path $env:TEMP -ChildPath "StaleJobReport.html"
    $Global:msgBody | Out-File $htmlAttachment 
    $mailFrom = "deliveryemail@someemailaddress.com" 
    $mailTo= "myemail@someemailaddress.com", "anotheremail@someemailaddress.com"

    $msgSubject =  "$oldJobs jobs older than $timeToStale minutes found on $hostName"

    Send-MailMessage -to $mailTo -from $mailFrom -subject $msgSubject -body $Global:msgBody -smtpserver "localhost" -BodyAsHtml -Priority High -Attachments $htmlAttachment
    Write-Host "Email sent!" 

    $msgSubject
    $Global:msgBody
}
