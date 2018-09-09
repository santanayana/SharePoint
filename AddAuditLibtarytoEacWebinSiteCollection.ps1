$WebapplicationValue = "http://sfrfidcshp001t:39649/"
$webapp = Get-SPWebApplication $WebapplicationValue  
foreach($site in $webapp.Sites)    
{ 
   
         Write-host $site
	 $web =  $site.OpenWeb( );
         $template = [Microsoft.SharePoint.SPListTemplateType]::DocumentLibrary;
         $web.Lists.Add("Audit","Audit Log Repository",$template);
         $web.Update( );
}