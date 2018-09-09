Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue 
#Site URL variable 
$SiteUrl ="http://mysite.statoilfuelretail.com/personal/vaia" 
#Get site object 
$web = Get-SPWeb $siteUrl 
#Set Locale setting 
$culture=[System.Globalization.CultureInfo]::CreateSpecificCulture("en-GB") 
$web.Locale=$culture 
#Set Timezone 
# 59 (GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius
# 3 (GMT+01:00) Brussels, Copenhagen, Madrid, Paris
# 4 (GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna
$TimezoneID = 4
$web.RegionalSettings.TimeZone.ID = $TimezoneID 
$web.RegionalSettings.Time24=$True 
$web.RegionalSettings.FirstDayOfWeek=1 #Monday
#Update settings 
$web.Update()

#Read more: http://www.sharepointdiary.com/2014/11/change-regional-settings-time-zone-locale-in-sharepoint-2013-using-powershell.html#ixzz5CuuEV61U