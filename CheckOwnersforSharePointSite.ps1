<# The below PowerShell script enumerates through all sites with unique permissions and fetches users with Full Control Permission granted directly to the site
or through group membership.#>
#Load SharePoint PowerShell Snapin
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}
#Collection of user permission objects
$SiteOwners = @();
#Define all the properties for the user permission object
$Properties = @{Title = ''; SiteID = ''; WebID = ''; WebSiteUrl = ''; AccessRequestEmail = ''; Scope = ''; Login = ''; UserID = ''; User = ''; Email = ''; LastItemModified = ''; };
#Site Url
$WebUrl = "";
#Web Application URL
$WebApplicationURL = "https://partners.statoilfuelretail.com";
#Enumerate through all Site Collections and Sites
Get-SPWebApplication -Identity $WebApplicationURL | Get-SPSite -limit all | % {
    $siteID = $_.ID;
    #Enumerate through all sites within the site collection
    Get-SPWeb -limit all -Site $_| % {
        $web = $_;
        #Check if the site has unique permissions
        if (($web.HasUniqueRoleAssignments -eq "True" -or $web.IsRootWeb -eq "True")) {
            $WebUrl = $web.Url;
            #Full Control Role Definition
            $FullControl = $web.RoleDefinitions["Full Control"];
            #Collection of Groups with Full Control permissions
            $OwnerGroups = @();
            #Get all Owner groups with Full Control permission
            $web.Groups|? {$_.Name -match "Owners"}| % {
                $IsGroupFullControl = $_.Roles|? {$_.Name -eq $FullControl.Name; }
                $OwnerGroups += $_;
            }
            try {
                <#SPWeb.Users:
This represents the collection of users or user objects who have been explicitly assigned permissions in  the Web site . This does not return users who have access through a group.
SPWeb.AllUsers:
This gives us the collection of user objects who are either members of the site collection or who have atleast navigated to the site as  authenticated members of a domain group in the site.#>
                #Enumerate through all Users in the Web
                Write-Host "Checking $($web.url) that has $($web.allusers.count) users"
                $web.AllUsers|? {$_.LoginName -ne "SHAREPOINT\System" -and $_.Email.Length -gt 0 -and $_.LoginName -ne "SFR\g-office365" }| % {
                    Write-Host "found user $($_.LoginName) "
                    #Check User Effective Permissions
                    if ($web.DoesUserHavePermissions($_.LoginName, [Microsoft.SharePoint.SPBasePermissions]::FullMask)) {
                        $user = $_;
                        Write-Host "if entered for $($_.LoginName) "
                        #Full Control Permission could have been granted directly or through group membership. Scope will represent these details.
                        $Scopes = @();
                        try {
                            $UserRoleAssignments = $web.RoleAssignments.GetAssignmentByPrincipal($user);
                        }
                        catch {}
                        #Check if user has Full Control Permissions
                        if ($UserRoleAssignments.RoleDefinitionBindings.Contains($FullControl))
                         {
                            $Scopes += "Site";
                            #Check for group membership of user in Owners group i.e. groups with Full Control permission
                            $user.Groups| % {
                                $Group = $_;
                                $IsOwnerGroup = $OwnerGroups|? {$_.Name -eq $Group.Name};
                                if ($IsOwnerGroup) {
                                    $Scopes += $Group.Name;
                                }
                          } 
                            #Create an object for the user permission record
                            $Owner = New-Object PSObject -Property $Properties;
                            $Owner.Title = $web.Title;
                            $Owner.WebID = $web.ID;
                            $Owner.SiteID = $siteID;
                            $Owner.WebSiteURL = $web.URL;
                            $Owner.AccessRequestEmail = $web.RequestAccessEmail;
                            $Owner.Scope = ($Scopes -join ",");
                            $Owner.UserID = $user.LoginName.Split("\")[1];
                            $Owner.Login = $user.LoginName;
                            $Owner.User = $user.Name;
                            $Owner.Email = $user.Email;
                            $Owner.LastItemModified = $web.LastItemModifiedDate.ToString("dd/MM/yyyy");
                            $SiteOwners += $Owner;
                        }
                    }
                }
                $web.Dispose();
                $_.Dispose();
            }
            catch [System.Exception] {
                Write-Host ($WebUrl + ":" + $_.Exception.Message + ":" + $_.Exception.StackTrace);
            }
        }
    }
    #Dispose SPSite
    $_.Dispose();
}
$SiteOwners|Export-CSV "e:\temp\SiteOwners.csv" -NoTypeInformation;