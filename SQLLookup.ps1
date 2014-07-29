# BEGIN FUNCTION SQLLookup
Function SQLLookup
# NAME: Perform a SQL lookup
# PURPOSE:  Lookup in SQL
{
    $DBServer = "MACHINE\SQLEXPRESS"
    $databasename = "MyDB"
	  $myUID = "<myusername>"
  	$myPwd = "<mypassword>"
    $Connection = new-object system.data.sqlclient.sqlconnection #Set new object to connect to sql database
    $Connection.ConnectionString ="server=$DBServer;uid=$myUID;pwd=$myPwd;;database=$databasename" # Connectiongstring setting for local machine database with window authentication
    Write-host "Connection Information:"  -foregroundcolor yellow -backgroundcolor black
    $Connection #List connection information
    ### Connect to Database and Run Query
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand #setting object to use sql commands
    $SqlQuery = @" 
SELECT * FROM <myTable>
"@	#Make sure this line is not tabbed in and has no spaces at the left margin
    $Connection.open()
    Write-host "Connection to database successful." -foregroundcolor green -backgroundcolor black
    $SqlCmd.CommandText = $SqlQuery
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $SqlCmd
    $SqlCmd.Connection = $Connection
    $DataSet = New-Object System.Data.DataSet
    $SqlAdapter.Fill($DataSet)
    $Connection.Close()
    $DataSet.Tables[0]
}
#END FUNCTION SQLLookup
