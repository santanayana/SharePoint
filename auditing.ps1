$WebapplicationValue = "http://sfrfidcshp001t:39649/"   
Write-Host $WebapplicationValue  
$webapp = Get-SPWebApplication $WebapplicationValue
$auditMask = [Microsoft.SharePoint.SPAuditMaskType]::all
foreach($site in $webapp.Sites)  
{ 
Write-Host $site 
$site.TrimAuditLog = $true
$site.Audit.AuditFlags = $auditmask
$site.Audit.Update()
$site.AuditLogTrimmingRetention = 50
[Microsoft.Office.RecordsManagement.Reporting.AuditLogTrimmingReportCallout]::SetAuditReportStorageLocation($site,"Audit")
}