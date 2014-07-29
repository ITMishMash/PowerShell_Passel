#Check to see if a computer is online

Function IsOnline($myComputer)
{
  Test-Connection -Computer $myComputer -Quiet
}

$ComputerName = "xyz"

If (-Not(IsOnline $computerName))
{
  #Do Something if it is offline
}
