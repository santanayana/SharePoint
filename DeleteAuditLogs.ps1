<#
.SYNOPSIS
    Delete audit logs from Sharepoint content database dbo.auditdata table
.DESCRIPTION
    This script will delete a Sharepoint site  audits logs from input file. We have to check size of audit logs on SQl Server by run
    disk space report from SQL Server Management studio (Right click the database, choose Reports >> Standard Reports >> Disk Usage by Table)
    Script must be run on the Sharepoint server.
.PARAMETER Surce
    Full URL of the site you want to report on.
    for example e:\temp\input.txt  
.PARAMETER RootSite
    $date.AddDays(-1) means delete audit logs to yesterday
    Site urls should exist in Input file.
.PARAMETER ExportPath
    
.INPUTS
    txt file with Sites urls
.OUTPUTS
   Deletes entries from Audit table in SharePoint
.EXAMPLE
    .\DeleteAuditLogs.ps1
How to trim audit log in SharePoint 2007? 
In MOSS 2007 (after sp2), We have to manually do this trimming with: STSADM -o trimaudtilog.
After executing the above stsadm command, Shrink the database manually to regain the disk space.

stsadm -o trimauditlog –enddate 20120101 –databasename WSS_Content_Func_Finance
.NOTES
    Author:            Maciej Stasiak
.LINK 
http://www.sharepointdiary.com/2012/06/trim-audit-log-to-improve-performance.html
#>

if ( (Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) {
    Add-PSSnapin Microsoft.SharePoint.Powershell
}

Get-Content -Path e:\temp\input2.txt | ForEach-Object {
    $site = Get-SPSite -Identity "$_"
    Write-Host $_  -ForegroundColor Yellow
    #To Get Yesterday
    $date = Get-Date
    $date = $date.AddDays(-1)
    #Delete Audit logs
    $site.Audit.DeleteEntries($date)
    $site.Dispose
}
$site.Dispose()