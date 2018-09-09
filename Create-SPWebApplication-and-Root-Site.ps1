[string]$farmAcct = "DOMAIN\serviceAccount"
[string]$AliasName = "SharePointSQLServerNameorAlias"
[string]$webAppName = "SharePoint - TeamSite80"
[string]$RootSiteCollectionName = "SharePoint - Root TeamSite"
[string]$appPool = "SharePoint - mySharePointWebApp"
[string]$Contentdatabase = "SharePoint_Content_DataBase"
[string]$url = "http://mySharePointWebAppUrl"
[string]$SiteTemplate = "STS#0" # Basic TeamSite
[string]$port = "80"
[int]$TimeZone = 4 # 4 = Amsterdam, Bern, ... / 3 = Paris, ...

Function WriteLine
{
    Write-Host -ForegroundColor White "--------------------------------------------------------------"
}

Function CreateWebApplication
{
	# Create the Web Application
	Try
	{
		WriteLine
		Write-Host $farmAcct
		Get-SPManagedAccount $farmAcct 

		Write-Host -ForegroundColor White " - Creating Web App "$webAppName""
		New-SPWebApplication -Name $webAppName -ApplicationPool $appPool -ApplicationPoolAccount (Get-SPManagedAccount $farmAcct) -DatabaseServer $AliasName -DatabaseName $Contentdatabase -Url $url -Port $port | Out-Null
				If (-not $?) { Throw " - Failed to create web application" }
		Get-SPWebApplication $url | Set-SPWebApplication -DefaultTimeZone $TimeZone
		
		New-SPSite -Name $RootSiteCollectionName -Url $url -Template $SiteTemplate -OwnerAlias $farmAcct -ContentDatabase $Contentdatabase -Verbose
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> Create Web Application caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

CreateWebApplication 
