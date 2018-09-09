# Completely deletes the specified Web (including all subsites)

function RemoveSPWebRecursively(
    [Microsoft.SharePoint.SPWeb] $web)
{
    Write-Debug "Removing site ($($web.Url))..."
    
    $subwebs = $web.GetSubwebsForCurrentUser()
    
    foreach($subweb in $subwebs)
    {
        RemoveSPWebRecursively($subweb)
        $subweb.Dispose()
    }
    
    $DebugPreference = "SilentlyContinue"
    Remove-SPWeb $web -Confirm:$false
    $DebugPreference = "Continue"
}

$DebugPreference = "SilentlyContinue"
$web = Get-SPWeb "http://foobar/Test"
$DebugPreference = "Continue"

If ($web -ne $null)
{
    RemoveSPWebRecursively $web
    $web.Dispose()
}