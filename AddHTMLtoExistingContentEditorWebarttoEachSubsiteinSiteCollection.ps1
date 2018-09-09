
#This powershell is to modify Content Editor webpart for each of subsites for selected Site Collection
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

 

#Get the Site collection

$site = Get-SPSite "https://confidential.statoilfuelretail.com/sites/Project-SFR-CFO-PROC-ICT-Shakespeare"
#Loop throgh each subsite in the site collection

foreach ($web in $Site.AllWebs)
{

    #Get the Default.aspx file

    $file = $web.GetFile($web.Url + "/default.aspx")

 

    if ($file.Exists)
    {

        #Web Part Manager to get all web parts from the file

        $WebPartManager = $web.GetLimitedWebPartManager( $file, [System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)

  

        #Iterate through each web part

        foreach ($webPart in $WebPartManager.WebParts) 
        {
            # Get the Content Editor web part with specific Title
            if ( ($webPart.title -eq "Information") -and ($webPart.GetType() -eq [Microsoft.SharePoint.WebPartPages.ContentEditorWebPart]) )
            {
                #Content to be Placed inside CEWP
                $HtmlContent = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"><head><meta http-equiv="Content-Language" content="en-us" /><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Untitled 1</title><style type="text/css">.style1 {font-size: x-large;color: #FF0000;}</style></head><body><p class="style1">Hello , this page is currently migrated to SharePoint Online and from 15-06-2018 is available only in Read Mode. </p><h2>New location for this content is provided here: <a href="https://acteurope.sharepoint.com/sites/CKE-Partners-SFR-BASR-NO-RSO-09/">https://acteurope.sharepoint.com/sites/CKE-Partners-SFR-BASR-NO-RSO-09</a> </h2><hr /><p>In case of any organizational questions please contact Elisabeth Vallen <a href="mailto:elisabeth.valen@circlekeurope.com">elisabeth.valen@circlekeurope.com</a> -&nbsp; In case of any technical questions please contact Maciej Stasiak <a href="mailto:maciej.stasiak2@circlekeurope.com">maciej.stasiak2@circlekeurope.com</a> </p></body></html>'

                $XmlDoc = New-Object System.Xml.XmlDocument
                $contentXml = $xmlDoc.CreateElement("content") 
                $contentXml.InnerText = $HtmlContent
                #Set content and Save
                $webpart.Content = $contentXml    
                $webPartManager.SaveChanges($webPart);

            }

        }

    }

} 


#Read more: http://www.sharepointdiary.com/2013/06/set-cewp-content-with-powershell.html#ixzz5IiRYTDpN
