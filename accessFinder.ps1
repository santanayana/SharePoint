$Logfile = "D:\accessemail.csv"
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring -whatif:$false
$logstring
}
LogWrite "SiteURL;PermissionType;AccessEmail"

if ( (Get-PSSnapin -Name "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null )  
{  
    Add-PsSnapin "Microsoft.SharePoint.PowerShell"  
}  
  
$WebapplicationValue = Read-Host "Enter web application URL"   
Write-Host $WebapplicationValue  
  
$webapp = Get-SPWebApplication $WebapplicationValue  
#$newEmail = Read-Host "Enter Email address to whom Access request will be sent : "   
  
foreach($site in $webapp.Sites)  
{  
   Write-Host "Site URL is" $site  
   foreach($web in $site.AllWebs)  
   {  
     $url = $web.url
	 $email=$web.RequestAccessEmail
	 $type = Inherited
     #Write-host "Site URl:"$url  
     if (!$web.HasUniquePerm)  
     {  
           $type= unique;  
		   #Write-Host "Access Request Settings is inherited from parent."  
     } 
	 
	 
     else  
     { 
		$type = Inherited	 
       <# if($web.RequestAccessEnabled)  
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
      } #>
	 }
	 LogWrite "$url;$type;$email"
   }  
   
}