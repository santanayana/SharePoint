##################################################################### 
# Name: Add-SPUsertoMultipleWebs.ps1 
# Desciption: This script assign multiple domain users specified permissions 
#             on multiple SharePoint sites. This is different from other 
#             add admin scripts in the sense that you can mention the 
#             perm level of the domain users.
#             This script is backwards compatible with SharePoint 2007.  
# Version: 1.0 
# Written by: Mohit Goyal 
##################################################################### 

# For SharePoint 2007 compatibility
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

# Specify the domain user login name and permission level here
$newpermissions = @{}
$newpermissions["contoso\jbravo"] = "Full Control"
$newpermissions["contoso\mhessey"] = "Contribute"
$newpermissions["contoso\sjenny"] = "Contribute"
$newpermissions["contoso\mphade"] = "Read"

# Specifies path for text file containing SharePoint sites url's 
$SitesList = Get-Content -Path "D:\Solutions\SitesList.txt" 
 
# Runs for each site
foreach ($Siteurl in $SitesList) {

    # Informs user about site being worked on and get site from SharePoint
    Write-Output ""
    Write-Output "Working on site $Siteurl"
    $Site = new-object Microsoft.SharePoint.SPSite($Siteurl)
    $Web = $site.OpenWeb()

    # Proceed to add user if the website is having unique permissions
    if ($Web.HasUniqueRoleAssignments) {   
        # run for every domain user
        foreach ($hash in $newpermissions.GetEnumerator()) {
            Write-Output "$($hash.Key) -> $($hash.Value).. "
            $RoleAssignments = New-Object Microsoft.SharePoint.SPRoleAssignment($hash.Key, "", "", "")
            $RoleDefinitions = $Web.RoleDefinitions[$hash.Value]
            $RoleAssignments.RoleDefinitionBindings.Add($RoleDefinitions)
            $Web.RoleAssignments.Add($RoleAssignments)
            Write-Output "Added"
        }
                
    }
    # Else informs that website is inherting perms from its top-site
    else {
        Write-Host "This website is inheriting permissions from its top site"
    }

    $Web.Dispose()
}

Write-Output ""  
Write-Output "Script Execution finished" 
 
##################################################################### 
# End of Script 
#####################################################################