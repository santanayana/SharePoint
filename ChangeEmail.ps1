$Logfile = "C:\accessemail.csv"
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring -whatif:$false
$logstring
}
LogWrite "SiteURL;PermissionType;SiteAccessEmail;SubsiteAccessEmail"

if ( (Get-PSSnapin -Name "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null )  
{  
    Add-PsSnapin "Microsoft.SharePoint.PowerShell"  
}  
  
$WebapplicationValue = "http://sfrfidcshp001t:39649/"   
Write-Host $WebapplicationValue  
  
$webapp = Get-SPWebApplication $WebapplicationValue  
$newEmail = "ajit.a.sharma@capgemini.com"   
  
foreach($site in $webapp.Sites)  
{  
   Write-Host "Site URL is" $site  
   foreach($web in $site.AllWebs)  
   {  
     $url = $web.url
	 $email=$web.RequestAccessEmail
	 $type = "NA"
     Write-host "Site URl:"$url  
     if (!$web.HasUniquePerm)  
     {  
           $type= "Inherited"
		  
		   #Write-Host "Access Request Settings is inherited from parent."  
     } 
	 
	 
     else  
     { 
		$type = "Unique"	 
        if($web.RequestAccessEnabled)  
       {  
	   
            Write-Host "Access Request Settings is enabled."  
            Write-Host "Email needs to be updated."  
            $web.RequestAccessEmail = $newEmail  
            $web.Update()  
            Write-Host "Email changed successfully!"  
        } 
         else  
      {  
            Write-Host "Access Request Settings not enabled."  
      } 
	 }
	 LogWrite "$url;$type;$email"
   }  
   
}