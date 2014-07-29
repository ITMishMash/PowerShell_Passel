# BEGIN FUNCTION CheckServices
Function CheckServices
# NAME: Check for non-running services
# PURPOSE:  Check multiple services to see if any service is not running. Return a value of $true if a service is down
# Remove the switch block if no custom actions need to be performed for each service
{
	$result = $false
    $servicesToCheck = ("<Service1>","<Service1>","<Service1>","<Service1>")
    foreach ($service in $servicesToCheck)
    {
        $myResult = Get-Service | Where-Object {$_.Name -eq $service -and $_.Status -ne "Running"}
        if ($myResult.Name.Length -gt 0)
        {
            $myResultName = $myResult.ServiceName
            $result =  $true
            switch ($myResultName)
            {
                "<Service1>" {} #Do something in the brackets like add to a custom alert message using a $global:alertbody variable
                "<Service1>"
                "<Service1>"
                "<Service1>"
            }
        }
    }
	Return $result
}
# END FUNCTION CheckServices
