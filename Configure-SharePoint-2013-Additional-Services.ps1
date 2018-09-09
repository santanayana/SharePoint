# --------------------------------------------------------------------------------------------
# This script configure the additional services based on two Blog Posts :
#  - CF. http://sharepointengineer.com/2012/11/18/sharepoint-2013-create-and-configure-the-sharepoint-2013-farm-using-powershell/
#  - CF.http://melcher.it/2013/01/powershell-create-the-bdc-service-application-for-sharepoint-2013/
# --------------------------------------------------------------------------------------------

[string]$AliasName = "SQLServer.Alias.Used.In.Your.Farm"
[string]$farmAcct = "DOMAIN\SharePointServiceAccount"
[string]$ContentdatabasePrefix = "YourDataBasePrefix_"

# ---------------------------------------------------------------------
Function ActivateUsageHealthDataCollection
{
	Try
	{
		Write-Host -ForegroundColor White " --> Configure the SharePoint Foundation Usage Health Data Collection "
		[string]$usageSAName = "Usage and Health Data Collection Service"
		[string]$stateSAName = "State Service"
		[string]$stateServiceDatabaseName = $ContentdatabasePrefix +"SP2013_State"
		[string]$UsageServiceDatabaseName = $ContentdatabasePrefix +"SP2013_Usage"
		[string]$UsageLogPath = "C:\SPLogs\"

		Set-SPUsageService -LoggingEnabled 1 -UsageLogLocation $UsageLogPath -UsageLogMaxSpaceGB 2
		$serviceInstance = Get-SPUsageService
		New-SPUsageApplication -Name $usageSAName -DatabaseServer $AliasName -DatabaseName $UsageServiceDatabaseName -UsageService $serviceInstance > $null
		$stateServiceDatabase = New-SPStateServiceDatabase -Name $stateServiceDatabaseName
		$stateSA = New-SPStateServiceApplication -Name $stateSAName -Database $stateServiceDatabase
		New-SPStateServiceApplicationProxy -ServiceApplication $stateSA -Name "$stateSAName - Proxy" -DefaultProxyGroup
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> Activate Usage Health Data Collection caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

Function ActivateBDCService
{
	Try
	{
		Write-Host -ForegroundColor White " --> Configure the SharePoint Foundation BDC "
		[string]$BDCDatabaseName = $ContentdatabasePrefix +"SP2013_BDC_DB"
		[string]$BDCApplicationName = "BDC Service Application"
		$BDCappPool = Get-SPManagedAccount -Identity $farmAcct
		
		New-SPServiceApplicationPool -Name BDCApplication_AppPool -Account $BDCappPool -Verbose
		$saBDCAppPool = Get-SPServiceApplicationPool -Identity BDCApplication_AppPool
		$ServiceApplication = New-SPBusinessDataCatalogServiceApplication -Name $BDCApplicationName -ApplicationPool $saBDCAppPool -DatabaseName $BDCDatabaseName -DatabaseServer $AliasName 
		New-SPBusinessDataCatalogServiceApplicationProxy -Name "$BDCApplicationName - Proxy" -ServiceApplication $ServiceApplication
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> Activate BDC caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

Function ActivateSecureStoreService
{
	Try
	{
		Write-Host -ForegroundColor White " --> Configure the SharePoint Foundation Secure Store Service "
		[string]$SecureStDatabaseName = $ContentdatabasePrefix +"SP2013_SECURE_STORE_DB"
		[string]$SecureStApplicationName = "Secure Store Service Application"
		$SecureStappPool = Get-SPManagedAccount -Identity $farmAcct
		
		New-SPServiceApplicationPool -Name SecureStApplication_AppPool -Account $SecureStappPool -Verbose
		$saSecureStAppPool = Get-SPServiceApplicationPool -Identity SecureStApplication_AppPool

		$ServiceApplication = New-SPSecureStoreServiceApplication -ApplicationPool $saSecureStAppPool -AuditingEnabled:$false -DatabaseServer $AliasName -DatabaseName $SecureStDatabaseName -Name $SecureStApplicationName
		New-SPSecureStoreServiceApplicationProxy -ServiceApplication $ServiceApplication -Name "$SecureStApplicationName - Proxy" 
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> Activate Activate Secure Store Service caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

ActivateUsageHealthDataCollection
ActivateBDCService
ActivateSecureStoreService
