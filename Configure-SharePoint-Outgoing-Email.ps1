[string]$SMTPServer = "MySMTP-Server.com"
[string]$emailAddress = "EmailAddress@myCompany.com"
[string]$replyToEmail = "EmailAddress@myCompany.com"

Function WriteLine
{
    Write-Host -ForegroundColor White "--------------------------------------------------------------"
}

Function ConfigureOutgoingEmail
{
    Try
    {
		WriteLine
        Write-Host -ForegroundColor White " - Configuring Outgoing Email..."
        $loadasm = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
        $spGlobalAdmin = New-Object Microsoft.SharePoint.Administration.SPGlobalAdmin
        $spGlobalAdmin.UpdateMailSettings($SMTPServer, $emailAddress, $replyToEmail, 65001)
 	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> ConfigureOutgoingEmail caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

ConfigureOutgoingEmail

#Start Central Administration 
WriteLine
Write-Output "Starting Central Administration"
& 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\BIN\psconfigui.exe' -cmd showcentraladmin 
  
Write-Output "Farm build complete."
WriteLine