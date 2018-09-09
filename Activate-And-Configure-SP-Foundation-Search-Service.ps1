[string]$farmAcct = "DOMAIN\service_Account"
[string]$serviceAppName = "Search Service Application"

Function WriteLine
{
    Write-Host -ForegroundColor White "--------------------------------------------------------------"
}

# ---------------------------------------------------------------------
Function ActivateAndConfigureSearchService
{
	Try
	{
		# Based on this script : http://blog.falchionconsulting.com/index.php/2013/02/provisioning-search-on-sharepoint-2013-foundation-using-powershell/

		Write-Host -ForegroundColor White " --> Configure the SharePoint Foundation Search Service -", $env:computername
		Start-SPEnterpriseSearchServiceInstance $env:computername
		Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $env:computername
		$appPool = Get-SPManagedAccount -Identity $farmAcct
		
		New-SPServiceApplicationPool -Name SeachApplication_AppPool -Account $appPool -Verbose
		$saAppPool = Get-SPServiceApplicationPool -Identity SeachApplication_AppPool
		$svcPool = $saAppPool
		$adminPool = $saAppPool
		
		$searchServiceInstance = Get-SPEnterpriseSearchServiceInstance $env:computername
		$searchService = $searchServiceInstance.Service
		$bindings = @("InvokeMethod", "NonPublic", "Instance")
		$types = @([string],
			[Type],
			[Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool],
			[Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool])

		$values = @($serviceAppName,
			[Microsoft.Office.Server.Search.Administration.SearchServiceApplication],
			[Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool]$svcPool,
			[Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool]$adminPool)

		$methodInfo = $searchService.GetType().GetMethod("CreateApplicationWithDefaultTopology", $bindings, $null, $types, $null)
		$searchServiceApp = $methodInfo.Invoke($searchService, $values)
		$searchProxy = New-SPEnterpriseSearchServiceApplicationProxy -Name "$serviceAppName - Proxy" -SearchApplication $searchServiceApp
		$searchServiceApp.Provision()
		
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> Activate And Configure Search Service caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

ActivateAndConfigureSearchService
