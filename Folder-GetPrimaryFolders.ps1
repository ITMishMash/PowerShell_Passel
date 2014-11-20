cls
#Get a list of primary folders under a main folder

$mainFolder = Get-Item '\\server\folder\'
$emailRecipient = "email1@email.server", "email2@email.server"
$emailSender = "emailsender@email.server"
$smtpServer = "localhost"

Function MakeMessageBody
{
    $Global:msgBodyHead  = "<!DOCTYPE html>`r`n"
    $Global:msgBodyHead  += "<!-- saved from url=(0014)about:internet -->`r`n"
    $Global:msgBodyHead += "<html lang=`"en-US`">`r`n"
    $Global:msgBodyHead += " <head>`r`n"
    $Global:msgBodyHead += "  <title>`r`n"
    $Global:msgBodyHead += "   FOLDER REPORT`r`n"
    $Global:msgBodyHead += "  </title>`r`n"
    $Global:msgBodyHead += "  <style>`r`n"
    $Global:msgBodyHead += "  thead {`r`n"
    $Global:msgBodyHead += "   background-color: #99CCFF;`r`n"
    $Global:msgBodyHead += "  }`r`n"
    $Global:msgBodyHead += "  td {`r`n"
    $Global:msgBodyHead += "   padding: 0px 10px 0px 0px;white-space:nowrap;`r`n"
    $Global:msgBodyHead += "  }`r`n"
    $Global:msgBodyHead += "  </style>`r`n"
    $Global:msgBodyHead += " </head>`r`n"

    $Global:msgBodyHead += " <body>`r`n"
    $Global:msgBodyHead += "   <p>`r`n"
    $Global:msgBodyHead += "    NAS Folder Report for $mainFolder`r`n"
    $Global:msgBodyHead += "   </p>`r`n"
    $Global:msgBodyHead += "   <br />`r`n"
    $Global:msgBodyHead += "   <table padding=`"10`" id=`"FolderTable`">`r`n"
    $Global:msgBodyHead += "    <thead>`r`n"
    $Global:msgBodyHead += "     <tr id=`"tableHeader`">`r`n"
    $Global:msgBodyHead += "      <th>FOLDER NAME</th>`r`n"
    $Global:msgBodyHead += "     </tr>`r`n"
    $Global:msgBodyHead += "    </thead>`r`n"
    $Global:msgBodyHead += "    <tbody>`r`n"

    $Global:msgBodyMain = ""

    $Global:msgBodyFoot = "    </tbody>`r`n"
    $Global:msgBodyFoot += "   </table>`r`n"
    $Global:msgBodyFoot += " </body>`r`n"
    $Global:msgBodyFoot += "</html>`r`n"
}

Function GetFolders
{
    foreach ($primaryFolder in $primaryFolders)
    {
        Write-Host $primaryFolder.Name
        $Global:custCount += 1
        if ($Global:custCount % 2 -eq 0) {
            $Global:msgBodyMain += "     <tr  id=`"row$Global:custCount`">`r`n"
        }
        else{
            $Global:msgBodyMain += "     <tr BGCOLOR=`"#D6E0FF`"  id=`"row$Global:custCount`">`r`n"
        }
        $Global:msgBodyMain += "      <td>`r`n"
        $Global:msgBodyMain += $primaryFolder.Name
        $Global:msgBodyMain += "      </td>`r`n"
        $Global:msgBodyMain += "     </tr>`r`n"
    }
    Write-Host "$Global:custCount Folders Found."
}

Function SendEmail
{
    $msgSubject = "$Global:custCount Folders in $mainFolder."
    $msgBody = $Global:msgBodyHead + $Global:msgBodyMain + $Global:msgBodyFoot
    #Write-Host $msgBody
    Send-MailMessage -To $emailRecipient -From $emailSender -Subject $msgSubject -Body $msgBody -BodyAsHtml -SmtpServer $smtpServer
    Write-Host "Email sent."
}

#Work Is Done Here
$primaryFolders = Get-ChildItem $mainFolder | Where-Object {$_.PSIsContainer -eq $True}

$Global:msgBodyHead = ""
$Global:msgBodyMain = ""
$Global:msgBodyFoot = ""
$Global:custCount = 0

MakeMessageBody
GetFolders
SendEmail
