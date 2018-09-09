<#
.SYNOPSIS
    Identify unused SharePoint groups and delete them
	
.DESCRIPTION
    Identify unused SharePoint groups and delete them.
	
.NOTES
    File Name: Delete-UnusedGroups.ps1
    Author   : Bart Kuppens
    Version  : 1.0
	
.PARAMETER Site
    Specifies the URL of the site collection to cleanup.

.PARAMETER ViewOnly
    If included, obsolete groups are outputted to the screen and NOT deleted (SIMULATION mode).
    If omitted, obsolete groups are deleted (EXECUTION mode).

.EXAMPLE
    PS > .\Get-UnusedGroups.ps1 -Site http://partners.statoilfuelretail.com  -ViewOnly
#>
[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$false,HelpMessage="Specifies the URL of the site collection to cleanup.")] 
    [string]$Site,
    [Parameter(Position=1,Mandatory=$false,ValueFromPipeline=$false,HelpMessage="If true, obsolete groups are outputted to the screen and NOT deleted.")] 
    [switch]$ViewOnly
)
cls
if ( (Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )
{ 
    Write-Host "Loading SharePoint cmdlets..."
    Add-PsSnapin Microsoft.SharePoint.PowerShell
}

$SPSite = Get-SPSite $site
if ($SPSite -eq $null)
{
    Write-Host "There's no site at URL $site. Halting execution!"
    break
}

if ($ViewOnly)
{
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "Running in SIMULATION mode!!!"
}
else
{
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "Running in EXECUTION mode!!!"
}

$groups = $SPSite.RootWeb.SiteGroups
$groupsToDelete = @()

$nbrGroups = $groups.Count
$percGroups = 100 / $nbrGroups
$compGroups = 0
$nbrObsoleteGroups = 0

foreach ($group in $groups)
{
    $hasAccess = $false
    $compGroups += $percGroups
    Write-Progress -Activity "Checking obsolete groups ($nbrObsoleteGroups/$nbrGroups found)" -Status $group.Name -PercentComplete $compGroups
    # Check if this group has been given access to a subsite
    $webs = $SPSite.AllWebs
    if ($webs.Count -gt 0)
    {
        foreach ($web in $webs)
        {
            if ($web.Groups["$group"] -ne $null)
            {
                $hasAccess = $true
            }
            $web.Dispose()
        }
    }
    if ($hasAccess -eq $false)
    {
        $groupsToDelete += $group
        $nbrObsoleteGroups++
    }
}

if ($ViewOnly)
{
    Write-Host "$($groupsToDelete.Count) groups were found."
    if ($nbrObsoleteGroups -gt 0)
    {
        Write-Host "Following groups would be removed in DELETE mode"
        $groupsToDelete | Select Name
    }
}
else
{
    $nbrGroups = $groupsToDelete.Count
    $percGroups = 100 / $nbrGroups
    $compGroups = 0
    $i = 1
    foreach ($item in $groupsToDelete)
    {
        $compGroups += $percGroups
        Write-Progress -Activity "Deleting group $i/$nbrGroups" -Status $item.Name -PercentComplete $compGroups
        $SPSite.RootWeb.SiteGroups.Remove($item)
        $i++
    }
}
$SPSite.Dispose()