$webApp = Get-SPWebApplication "http://dubtel-s-070:90"

Foreach ($site in $webApp.Sites) {
    Write-Host $site -ForegroundColor Green
    New-SPUser -UserAlias "Topazenergy\maciej.stasiak-a" -DisplayName "Maciej Stasiak IT" -Web $site.URL 
    $usr = Get-SPUser "Topazenergy\maciej.stasiak-a" -Web $site.URL
    Set-SPSite -Identity $site -SecondaryOwnerAlias $usr
    $usr.IsSiteAdmin = $true
    $usr.Update()
}