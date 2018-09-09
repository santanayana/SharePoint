Add-PSSnapin Microsoft.SharePoint.PowerShell -erroraction SilentlyContinue

# ---------------------------------------------------------------------
Function WriteLine
{
    Write-Host -ForegroundColor White "--------------------------------------------------------------"
}

# ---------------------------------------------------------------------
Function AddSearchLocalContentSource
{
	Try
	{
		# Create the Local Content Source
		# Cf. http://sharepoint-community.net/profiles/blogs/sharepoint-2013-configure-content-source-and-search-result-source
		
		[string]$serviceAppName = "Search Service Application" #Give the Search App Name
		[string]$ContentSourceName = "Another Search Content"
		[string]$ContentSiteurl = "http://mySiteURLToCrawl"
		[string]$ContentSourceType = "SharePoint" #specify the Type (Web, File, ….)

        WriteLine
		Write-Host "Add the new content source : $ContentSourceName - $ContentSiteurl"

		$SearchServiceApplication = Get-SPEnterpriseSearchServiceApplication -Identity $serviceAppName -ErrorAction SilentlyContinue
		$ContentSources = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $SearchServiceApplication
		$ContentSources | ForEach-Object {
			if ($_.Name.ToString() -eq $ContentSourceName)    
			{
				Write-Host "Content Source : $ContentSourceName already exist. Deleting the Content source..."
				Remove-SPEnterpriseSearchCrawlContentSource -SearchApplication $SearchServiceApplication -Identity $ContentSourceName -Confirm:$false    
			}
		}
		$SPContentSource = New-SPEnterpriseSearchCrawlContentSource -SearchApplication $SearchServiceApplication -Type $ContentSourceType -name $ContentSourceName -StartAddresses $ContentSiteurl -MaxSiteEnumerationDepth 0
		if($SPContentSource.CrawlState -eq "Idle")
		{
			Write-Host "Starting the FullCrawl for the content source : $ContentSourceName"
			$SPContentSource.StartFullCrawl()    
			do {Start-Sleep 2; Write-Host "." -NoNewline}
			While ( $SPContentSource.CrawlState -ne "CrawlCompleting")
			Write-Host ""
			Write-Host "FullCrawl for the content source : $ContentSourceName completed."
		}
        WriteLine
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> Add the New Content Source caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}
# ---------------------------------------------------------------------

AddSearchLocalContentSource

#Start Central Administration 
WriteLine
Write-Output "Starting Central Administration"
& 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\BIN\psconfigui.exe' -cmd showcentraladmin 
  
Write-Output "Farm build complete."
WriteLine

