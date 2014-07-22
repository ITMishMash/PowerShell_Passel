# Written by Luke Taylor#
# 
# Newer 3.0 and newer versions of PowerShell should simply use the Send-MailMessage cmdlet:
# http://technet.microsoft.com/en-us/library/hh849925.aspx
#
# TODO: Add multiple recipient handling
#
# The purpose of this script is to 
# 1. Send an email
# 2. Attachment is optional

# Sample usage:
# powershell.exe -file "SendEmail.ps1" -MailServer smtp.xxxx.com -From fromID@xxxx.com -To replyto@xxxx.com -Subject "My Subject" -Body "This is the email Body."
# powershell.exe -file "SendEmail.ps1" -MailServer smtp.xxxx.com -From fromID@xxxx.com -To replyto@xxxx.com -Subject "My Subject" -Body "This is the email Body." -Attachment "C:\SomeAttachment.txt"

Param(
    [Alias("MailServer")]
    [parameter(Mandatory=$true)] 
    [String] 
    $smtpServer
, 
    [Alias("From")]
    [parameter(Mandatory=$true)]
    [String] 
    $fromEmail
, 
    [Alias("To")]
    [parameter(Mandatory=$true)]
    [String] 
    $toEmail
,
    [Alias("Subject")]
    [parameter(Mandatory=$true)]
    [String] 
    $msgSubject
,
    [Alias("Body")]
    [parameter(Mandatory=$true)]
    [String] 
    $msgBody
,
    [Alias("Attachment")]
    [parameter(Mandatory=$false)]
    [String] 
    $msgAttachment
) 

function sendMail{
 
    #Creating a Mail object
    $msg = new-object Net.Mail.MailMessage
 
    #Creating SMTP server object
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
 
    #Email structure 
    $msg.From = $fromEmail
    $msg.ReplyTo = $fromEmail
    $msg.To.Add("$toEmail")

    #$msg.To.Add("toID@xxxx.com")
    $msg.subject = $msgSubject
    $msg.body = $msgBody
    if ($msgAttachment)
    {
        $msg.Attachments.Add($msgAttachment)
    }
    #Sending email 
    $smtp.Send($msg)
  
}
 
#Calling function

sendMail

##The Following section may be needed if credentials are required.
##$cred = get-credential
## 
##send-mailMessage -to "" -subject "test" -from "" -body "" -SmtpServer "" #-credential $cred
