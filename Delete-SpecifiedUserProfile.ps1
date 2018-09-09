#Add SharePoint PowerShell SnapIn if not already added
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {Add-PSSnapin "Microsoft.SharePoint.PowerShell"}

#Enumerate all users under the CONTOSO Corporate Users OU
#Note: This requires the AD PowerShell Module from RSAT to be installed
$CorpUsers = Get-ADUser -SearchBase "OU=CONTOSO CORP Users, DC=Contoso,DC=local" -filter * 

#Uncomment to get a report of AD users in your OU
#$CorpUsers | Export-Csv E:\Scripts\CONTOSO_CorpUsers_OU_011215.csv

#Get UserProfileManager from the My Site Host Site context
$site = new-object Microsoft.SharePoint.SPSite("http://YourCentralAdmin:PortNumber/"); 
$ServiceContext = [Microsoft.SharePoint.SPServiceContext]::GetContext($site); 
$ProfileManager = new-object Microsoft.Office.Server.UserProfiles.UserProfileManager($ServiceContext) 
$AllProfiles = $ProfileManager.GetEnumerator() 

#Uncomment to get a report of Profiles in your User Profile DB
#$AllProfiles2 = $ProfileManager.GetEnumerator() 
#$AllProfiles2 | Export-Csv E:\Scripts\SPProd_Profiles_011215.csv

#Loop through each profile in SharePoint User Profile Database
foreach($profile in $AllProfiles) 
    { 
    $DisplayName = $profile.DisplayName 
    $AccountName = $profile[[Microsoft.Office.Server.UserProfiles.PropertyConstants]::AccountName].Value 
    #Strip the domain so we can compare SAM account names 
    # Trim the first 8 characters from account name (remove "CONTOSO\") 
    $UserProfileSAMName = $accountname.substring(8) 
    write-host $Displayname "(AccountName: " $AccountName ", SAM Name: " $UserProfileSAMName ")" 

    #If a user profile exists but does not reside in the CONTOSO Corporate Users OU, then it must be removed. 
    If (-not ($CorpUsers.SamAccountName.contains($UserProfileSAMName))) 
        {write-host "---> " $UserProfileSAMName " (" $AccountName ") does not exist under CONTOSO Corp Users OU." 
        #Do not delete setup (admin) account from user profiles. Please enter the account name below 
        if($AccountName -ne "Contoso\sp_installer") 
            { 
            #For this example, the actual command to delete the profile has been commented out. We are reporting only. 
            # Uncomment if you want to actually delete profiles
            # $ProfileManager.RemoveUserProfile($AccountName); 
            #write-host "---> Profile for account " $Displayname "(AccountName: " $AccountName ", SAM Name: " $UserProfileSAMName ") has been deleted" 
            write-host "---> Profile for account " $Displayname "(AccountName: " $AccountName ", SAM Name: " $UserProfileSAMName ") would be deleted" 
            } 
        }
    } 
write-host "Finished."
$site.Dispose()
