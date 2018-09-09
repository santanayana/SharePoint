## ------------------------------------------------
## CREATED   : 2018.06.18
## MODIFIED  :
## AUTHOR    : Maciej Stasiak 
## EMAIL     : macsta@statoilfuelretail.com
##
## DESCRIPTION
## ------------------------------------------------
## Script to loop through a set of SharePoint Subsites and add
## a new Content Editor webpart at each sub site ended with with Default.aspx 
## plus PublishingPages
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
$parentSite = "http://partners.statoilfuelretail.com/sites/SFR-BACE-LV-01/"

$webPartProperty_Title = "After Migration Information"
$webPartProperty_ZoneName = "Left"
$webPartProperty_Height = ""
$webPartProperty_Width = ""
$webPartProperty_Visible = $true
# Contact to decision person
$contact = "Gunta Jēkabsone - "
$contactmail = "Gunta.Jekabsone@circlekeurope.com"
# Contact to technical person
$technicalcontact = "Maciej Stasiak - "
$technicalcontactmail = "macsta@statoilfuelretail.com"
# Migration Date
$MigrationDate = "31-08-2018"

## All content editor web parts will point link to file with this script
#$webPartProperty_Link = "/sites/Project-SFR-CFO-PROC-ICT-Shakespeare/SiteAssets/InfoOnPage.txt"

Start-SPAssignment -Global
$site = Get-SPWeb $parentSite
$webSites = $site.Webs
foreach($webSite in $webSites)
{
    $order = $webSite.Name
    $page = $webSite.GetFile("/sites/SFR-BACE-LV-01/$order/Default.aspx")
    #$page =  [Microsoft.SharePoint.Publishing.PublishingWeb]::GetPublishingWeb($webSites)
    #$PubWeb.GetPublishingPages($Page)
    # Destination site collection URL after migration - Link to site
    $DestUrl = "https://acteurope.sharepoint.com/sites/CKE-Partners-SFR-BASR-NO-FUEL-01/$order"
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
     #$HtmlContent = "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd""><html xmlns=""http://www.w3.org/1999/xhtml"" xmlns:mso=""urn:schemas-microsoft-com:office:office"" xmlns:msdt=""uuid:C2F41010-65B3-11d1-A29F-00AA00C14882""><head><meta http-equiv=""Content-Language"" content=""en-us"" /><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" /><title>Untitled 1</title><style type=""text/css"">.style1 {font-size: x-large;color: #FF0000;}</style></head><body><p class=""style1"">This teamsite has been selected for deletion  and is scheduled to deleted. It will be retained in read-only mode until 31.08.2018 and permanently deleted after that. Now it is available only in Read Mode. </p><h2>New location for this content is provided here: <a href=""$DestUrl"">$DestUrl</a> </h2><hr /><p>In case of any organizational questions please contact $contact <a href=""$contactmail"">$contactmail</a> -&nbsp; In case of any technical questions please contact $technicalcontact<a href=""$technicalcontactmail"">$technicalcontactmail</a> </p></body></html>"
     $HtmlContent = "<h1 style=""color: #4485b8;"">This team site is migrated to Office 365 location</h1> <p>It will be retained in read-only mode until <strong>$MigrationDate</strong> and permanently deleted after that. From now it is available only in Read Mode for possibility to compare new and old content.</p> <hr /> <h2>New team site location after migration is here:&nbsp;<a href=""$DestUrl"" title=""Link to new location"">&gt;&gt;&gt;Link&lt;&lt;</a></h2> <p>In case of any organizational questions please $contact <a href=""$contactmail"">$contactmail</a> -&nbsp; &nbsp;-&nbsp; In case of any technical questions please contact Maciej Stasiak -&nbsp;<a href=""macsta@statoilfuelretail.com"">macsta@statoilfuelretail.com</a></p> <p><em>&copy; CircleK 2018</em></p>"
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
Stop-SPAssignment -Global