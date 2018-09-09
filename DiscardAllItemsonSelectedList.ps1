#Purpose of this script is to perform bulk discard items from selected list input

#Add SharePoint PowerShell SnapIn if not already added
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {Add-PSSnapin "Microsoft.SharePoint.PowerShell"}

#provide a list with urls to document library 
Get-Content -Path "..." | ForEach-Object 
{
    $WebUrl = ($_ | Select-String -Pattern ".*(?=/.*/)").Matches.Value
    $LibraryName = ($_ | Select-String -Pattern "[^/]*(?=/$)").Matches.Value

    # Manual Variables
#$WebURL="http://partners.statoilfuelretail.com/sites/SFR-BDSO-BSO-01/dk"
#$LibraryName="Document Library"

#Get Objects
$Web = Get-SPWeb $WebURL
$Folder = $web.GetFolder($LibraryName)

#Function to find all checked out files in a SharePoint library
Function Get-CheckedOutFiles($Folder)
{

  $Folder.Files | Where-Object { $_.CheckOutStatus -ne "None" }  | ForEach-Object {
  write-host ($_.Name, " Checked Out bu User - " ,$_.CheckedOutBy) -ForegroundColor Yellow | Measure-Object


  #To Check in
  #$_.Checkin("Checked in by Administrator")
  #To undo check Out
  $_.UndoCheckOut()
  }

 #Process all sub folders
 $Folder.SubFolders | ForEach-Object {
 Get-CheckedOutFiles $_
 }
}

}

#Call the function to find checkedout files
Write-Host ("Files(s) = ",(Get-CheckedOutFiles $Folder | measure | ForEach-Object {$_.Count})) -ForegroundColor Green

# http://www.sharepointdiary.com/2013/02/find-all-checked-out-files-and-check-in.html#ixzz4yUeAXpaX