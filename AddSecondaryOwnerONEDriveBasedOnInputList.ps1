#$orgName= "acteurope"
#Connect-SPOService -Url https://$orgName-admin.sharepoint.com

# Specifies path for text file containing OneDrivr site collection urls 
$OneDriveSitesList = Import-Csv -Path "C:\temp\OneDrive.csv" 

# Runs for every OneDrive site collection from List
    Foreach($i in $OneDriveSitesList)
    {
      $Site = Get-SPOSite -Identity $i.Site
      Write-Host $Site.URL -ForegroundColor Blue
      Set-SPOUser -Site $Site -LoginName "macsta@statoilfuelretail.com" -IsSiteCollectionAdmin $true
    }