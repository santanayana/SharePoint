<#
.SYNOPSIS
  Script to get sites(webs) title from csv with URL's file
.DESCRIPTION
  This script uses as input csv file SiteAddress column (site url)
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   Provide file name in $InvFile variable and put this file into the same folder as script located.
#>

if ( (Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) { 
    Add-PsSnapin Microsoft.SharePoint.PowerShell 
} 

$InvFile = "sites.csv" 

# Get Data from Inventory CSV File and check if file exist.
$FileExists = (Test-Path $InvFile -PathType Leaf) 
if ($FileExists) { 
    "Loading $InvFile for processing..." 
    $tblData = Import-CSV $InvFile -Delimiter ";"
}
else { 
    "$InvFile not found - stopping import!" 
    exit 
}

# Loop through input table (URL, Title, Error) and looking for site title and put error on true if site not exist
$tblData | % {$_.Title = (Get-SPWeb -Identity $_.URL).Title; $_.Error = (!$?)} 
$tblData | ? { !$_.Title } | % {  $_.Error = $true }
$tblData | Export-Csv -Path "e:\temp\WebUrlwithTitle.csv" -Encoding UTF8 -Delimiter ";" -NoTypeInformation
<# {
    "Getting Web for " + $row.'SiteAddress'.ToString()
    $WebSite = Get-SPWeb -Limit All -Identity $row.'URL' | Select-Object URL, Title  | ConvertTo-Csv -Delimiter ";"  -NoTypeInformation | Select-Object -Skip 1 | Out-File -Append -Encoding utf8 -FilePath e:\temp\WebUrlwithTitle.csv ;
    Write-Host "URL $($tblData.URL) Title $($tblData.Title)"

    
} #>
#$WebSite.Dispose()
