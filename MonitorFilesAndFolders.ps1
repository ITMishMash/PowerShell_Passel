#By BigTeddy 05 September 2011 
 
#This script uses the .NET FileSystemWatcher class to monitor file events in folder(s). 
#The advantage of this method over using WMI eventing is that this can monitor sub-folders. 
#The -Action parameter can contain any valid Powershell commands.  I have just included two for example. 
#The script can be set to a wildcard filter, and IncludeSubdirectories can be changed to $true. 
#You need not subscribe to all three types of event.  All three are shown for example. 
# Version 1.1 

#To run this script from the command line, enter the following:
#powershell -noexit -noprofile -command "C:\Scripts\MonitorFilesAndFolders.ps1"

#To run this script as a scheduled task, use the following:
#Scheduled tasks configuration 
#Monitor for TYPE config changes 
#Run whether user is logged on or not ( as domain\administrator ) 
#Scheduled to run daily at 6:00AM 
#Actions 
#Start a program: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 
#Add arguments: -noexit -noprofile -command C:\Scripts\MonitorFilesAndFolders.ps1
#
#Settings 
#Run task as soon as possible after a scheduled start is missed 
#UNCHECK: Stop the task if it runs longer than: 
#If the task is already running...: Do not start a new instance


#Attempted to use the following within the script to create a persistant instace of the script.
#Was not able to get it to work
    <#
    param ( $Show )
    if ( !$Show ) 
    {
        PowerShell -NoExit -File $MyInvocation.MyCommand.Path 1
        return
    }
    #>

$folder = 'C:\Scripts\Test' # Enter the root path you want to monitor. 
$filter = '*.*'  # You can enter a wildcard filter here. 
$logPath = "C:\Scripts\filechange\outlog.txt"
 
# In the following line, you can change 'IncludeSubdirectories to $true if required.                           
$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $true;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'} 
 
# Here, all three events are registerd.  You need only subscribe to events that you need: 
 
Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action { 
    $name = $Event.SourceEventArgs.Name
    $type = [System.IO.Path]::GetExtension($name)
    $changeType = $Event.SourceEventArgs.ChangeType 
    $timeStamp = $Event.TimeGenerated 
    Write-Host "The file '$name' of type '$type' was $changeType at $timeStamp" -fore green 
    #[System.Windows.Forms.MessageBox]::Show("The file '$name' was $changeType at $timeStamp")
    #Out-File -FilePath $logPath -Append -InputObject "The file '$name' was $changeType at $timeStamp"
    } 
 
Register-ObjectEvent $fsw Deleted -SourceIdentifier FileDeleted -Action { 
    $name = $Event.SourceEventArgs.Name 
    $changeType = $Event.SourceEventArgs.ChangeType 
    $timeStamp = $Event.TimeGenerated 
    Write-Host "The file '$name' was $changeType at $timeStamp" -fore red
    #[System.Windows.Forms.MessageBox]::Show("The file '$name' was $changeType at $timeStamp")
    #Out-File -FilePath $logPath -Append -InputObject "The file '$name' was $changeType at $timeStamp"
    } 
 
Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action { 
    $name = $Event.SourceEventArgs.Name 
    $changeType = $Event.SourceEventArgs.ChangeType 
    $timeStamp = $Event.TimeGenerated 
    Write-Host "The file '$name' was $changeType at $timeStamp" -fore white 
    #[System.Windows.Forms.MessageBox]::Show("The file '$name' was $changeType at $timeStamp")
    #Out-File -FilePath $logPath -Append -InputObject "The file '$name' was $changeType at $timeStamp"
    } 


<#
# To stop the monitoring, run the following commands: 
Unregister-Event FileDeleted 
Unregister-Event FileCreated 
Unregister-Event FileChanged
#>
