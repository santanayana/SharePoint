## CONTACT INFO
## ------------------------------------------------
## CREATED   : 2018.06.18
## MODIFIED  :
## AUTHOR    : Maciej Stasiak 
## EMAIL     : maciej.grzegorz.stasiak@gmail.com 
##
## DESCRIPTION
## ------------------------------------------------
## Script to loop through a set of SharePoint Subsites and  create
## a new Content Editor webpart at each sub site named 
## with Default.aspx
## 
## EXPLAINATION
## ------------------------------------------------
## This example illustrates how to dynamically loop
## through a set of sub sites and add a Content Editor wbepart
## to each sub site and populate it with a web part page.
##
## BEGIN
## ------------------------------------------------
## Load up the snapin so Powershell can work with SharePoint
## if the snapin was already loaded don't alert the user
Add-PSSnapin microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
## Clear any errors or output to the screen
CLS
## Set variables
## This variable will be the site where I want to start
$parentSite = "https://confidential.statoilfuelretail.com/sites/Project-SFR-CFO-PROC-ICT-Shakespeare"

$webPartProperty_Title = "Information"
$webPartProperty_ZoneName = "Header"
$webPartProperty_Height = ""
$webPartProperty_Width = ""
$webPartProperty_Visible = $true
## All content editor web parts will point to this script
$webPartProperty_Link = "https://confidential.statoilfuelretail.com/sites/Project-SFR-CFO-PROC-ICT-Shakespeare/SiteAssets/InfoOnPage.txt"

Start-SPAssignment -Global
$site = Get-SPWeb $parentSite
$webSites = $site.Webs
foreach($webSite in $webSites)
{
    $order = $webSite.Name
    $page = $webSite.GetFile("/Project-SFR-CFO-PROC-ICT-Shakespeare/$order/Default.aspx") 
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
  $cewp.ContentLink = $webPartProperty_Link
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
     $webPartManager.SaveChanges($cewp)
     $webSite.Dispose()
  Write-Host "Webpart was created for site $order"
 }
}

