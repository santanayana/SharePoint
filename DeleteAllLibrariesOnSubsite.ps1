cls

#Delete SP Online Document Libraries with no content INSIDE (eq = 0 )
$url = "https://acteurope.sharepoint.com/teams/CKE-EU-FC_AND_AC_IRL_communication/CircleK_Ireland"


if ($cred -eq $null)
{
    $cred = Get-Credential
    Connect-PnPOnline $url -Credentials $cred
}

$CSOM_context = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$CSOM_credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($cred.UserName, $cred.Password)
$CSOM_context.Credentials = $CSOM_credentials

$lists = $CSOM_context.Web.Lists
$CSOM_context.Load($lists)
$CSOM_context.ExecuteQuery()

$ignoreList = "Composed Looks", "Access Requests", "Site Pages", "Site Assets", "Style Library", "_catalogs/hubsite", "Translation Packages" , "Content Organizer Rules", "Drop Off Library", "Master Page Gallery" ,"MicroFeed"

$lists  | Where-Object { $_.ItemCount -eq 0 -and $_.BaseTemplate -eq 101 -and $_.Title -inotin $ignoreList}  | ForEach-Object {

    Write-Host "- " $_.Title -NoNewline

    try {
        Remove-PnPList -Identity $_.Title -Force 

        Write-Host -ForegroundColor Green "   [deleted] "  `n  
    }
    catch  {
        Write-Host -ForegroundColor Red   "   [FAILURE] - " $_.Exception.Message `n  
    }
}