$WebAppURL = "http://mysite.statoilfuelretail.com"
 
$TemplateName ="PersonalSiteHighQuota"
 
$contentService = [Microsoft.SharePoint.Administration.SPWebService]::ContentService
$quotaTemplate = $contentService.QuotaTemplates[$TemplateName]
 
Get-SPWebApplication $WebAppURL | Get-spsite -limit all | Where-Object {$_.ServerRelativeUrl.StartsWith("/personal/")} |  ForEach-Object { $_.Quota = $quotaTemplate }


# Read more: http://www.sharepointdiary.com/2013/08/change-site-collection-quota-using-powershell.html#ixzz4xMlXUOSZ