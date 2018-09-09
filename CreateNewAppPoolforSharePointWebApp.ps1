$WebAppURL = "archive.statoilfuelretail.com"
$NewAppPoolName = "ArchiveRMApppoolNew"
$NewAppPoolIdentity = "SFR\SA-SFR-SPPL-06"
$Password = Read-Host -Prompt "Passw0rd123#" -AsSecureString
$Service = [Microsoft.SharePoint.Administration.SPWebService]::ContentService
$NewAppPool = New-Object Microsoft.SharePoint.Administration.SPApplicationPool($NewAppPoolName,$Service)
$NewAppPool.CurrentIdentityType = "SpecificUser"
$NewAppPool.Username = $NewAppPoolUserName
$NewAppPool.SetPassword($Password)
$NewAppPool.Provision()
$NewAppPool.Update($true)
$NewAppPool.Deploy()