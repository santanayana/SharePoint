## ------------------------------------------------
## CREATED   : 2018.06.18
## MODIFIED  :
## AUTHOR    : Maciej Stasiak 
## EMAIL     : maciej.grzegorz.stasiak@gmail.com 
##
## DESCRIPTION
## ------------------------------------------------
## Script to loop through a set of SharePoint Subsites and add
## a new Content Editor webpart at each sub site ended with with Default.aspx page
## 
## 
## EXPLAINATION
## ------------------------------------------------
## This script  illustrates how to dynamically loop
## through a set of sub sites and add a Content Editor wbepart
## to each sub site with HTML text inside.
##
## BEGIN
## ------------------------------------------------
## Load up the snapin so Powershell can work with SharePoint
## if the snapin was already loaded don't push notification to the user
Add-PSSnapin microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
## Clear any errors or output to the screen
Clear-Host
## Set variables
## This variable will be the site collection where I want to start
#$parentSite = "https://confidential.statoilfuelretail.com/sites/Project-SFR-CFO-PROC-ICT-Shakespeare"
$parentSite = "https://partners.statoilfuelretail.com/sites/FC-BC/ICFR"

$webPartProperty_Title = "After Migration Information"
$webPartProperty_ZoneName = "Left"
$webPartProperty_Height = ""
$webPartProperty_Width = ""
$webPartProperty_Visible = $true
# Contact to decision person
$contact = "Uģis Nerets - "
$contactmail = "UGINE@statoilfuelretail.com"
# Contact to technical person
$technicalcontact = "Maciej Stasiak - "
$technicalcontactmail = "macsta@statoilfuelretail.com"
# Migration Date
$MigrationDate = "02-07-2018"

## All content editor web parts will point link to file with this script
#$webPartProperty_Link = "/sites/Project-SFR-CFO-PROC-ICT-Shakespeare/SiteAssets/InfoOnPage.txt"

Start-SPAssignment -Global
$site = Get-SPWeb $parentSite
$webSites = $site.Webs
foreach($webSite in $webSites)
{
    $order = $webSite.Name
    $page = $webSite.GetFile("/sites/FC-BC/ICFR/$order/Default.aspx") 
    # Destination site collection URL
    $DestUrl = "https://acteurope.sharepoint.com/teams/CKE-IA-EU-Internal-Audit-01/ICFR/$order"
    $webPartManager = $webSite.GetLimitedWebPartManager($page, [System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)
 foreach($webPart in $webPartManager.WebParts)
 {
  $listOfAllWebParts = $webPart.Title
 }
 ## Check the page to see if the web part was already on it
 if($listOfAllWebParts -eq $webPartProperty_Title)
 {
  Write-Host "$webSite already had web part on it."
 }
 ## Create the web part and set some of it's properties
 else
 {
  $cewp = New-Object Microsoft.SharePoint.WebPartPages.ContentEditorWebPart
  #$cewp.ContentLink = $webPartProperty_Link
     $cewp.Title = $webPartProperty_Title
     $cewp.Height = $webPartProperty_Height
     $cewp.Width = $webPartProperty_Width
  $cewp.Visible = $webPartProperty_Visible
  $cewp.ChromeType = "None"
     $cewp.HorizontalAlign = "Center" 
     ## The AddWebPart takes 3 arguments, first is the web part name, 
     ## then the zone id 
     ## and finally the order number where you want the web part to show in the zone
     $webPartManager.AddWebPart($cewp, $webPartProperty_ZoneName, 0)
     $HtmlContent = "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd""><html xmlns=""http://www.w3.org/1999/xhtml"" xmlns:mso=""urn:schemas-microsoft-com:office:office"" xmlns:msdt=""uuid:C2F41010-65B3-11d1-A29F-00AA00C14882""><head><meta http-equiv=""Content-Language"" content=""en-us"" /><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" /><title>Untitled 1</title><style type=""text/css"">.style1 {font-size: x-large;color: #FF0000;}</style></head><body><p class=""style1"">Hello , this page is currently migrated to SharePoint Online and from $MigrationDate is available only in Read Mode. </p><h2>New location for this content is provided here: <a href=""$DestUrl"">$DestUrl</a> </h2><hr /><p>In case of any organizational questions please contact $contact <a href=""$contactmail"">$contactmail</a> -&nbsp; In case of any technical questions please contact $technicalcontact<a href=""$technicalcontactmail"">$technicalcontactmail</a> </p></body></html>"
     $XmlDoc = New-Object System.Xml.XmlDocument
                $contentXml = $xmlDoc.CreateElement("content") 
                $contentXml.InnerText = $HtmlContent
    #Set content and Save
    $cewp.Content = $contentXml 
     $webPartManager.SaveChanges($cewp)
     $webSite.Dispose()
  Write-Host "Webpart CEWP with text was created for site $order"
 }
}