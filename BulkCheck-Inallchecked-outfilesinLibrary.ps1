#Purpose of this script is to perform bulk check/discarded items in selected SharePoint library

#Add SharePoint PowerShell SnapIn if not already added
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {Add-PSSnapin "Microsoft.SharePoint.PowerShell"}


<# #provide a txt file with urls to document library 
Get-Content -Path "E:\Scripts\TestFarmURLtoDiscardCheckOut.txt" | ForEach-Object 
{
    $WebUrl = ($_ | Select-String -Pattern ".*(?=/.*/)").Matches.Value
    $LibraryName = ($_ | Select-String -Pattern "[^/]*(?=/$)").Matches.Value
} #>

#Variables
$WebURL="https://intranet.statoilfuelretail.com/sites/SFR-CSO-BC-FC-SE-01-Acc_Fin_Tax/transfer%20pricing"
$LibraryName="Document Library"


#Get Objects
$Web = Get-SPWeb $WebURL
$Folder = $web.GetFolder($LibraryName)
# Do not discard files not older than x days
$dateThreshold = (get-date).AddDays(-1033)

#Function to find all checked out files in a SharePoint library
Function Get-CheckedOutFiles($Folder)
{

  $Folder.Files | Where-Object { $_.CheckOutStatus -ne "None" -and $_.TimeLastModified -le $dateThreshold }  | ForEach-Object {
  write-host ($_.Name, " Checked Out by User - " ,$_.CheckedOutBy, $_.TimeLastModified ) -ForegroundColor Yellow | Measure-Object


  #To Check in uncomment line below - it is under name person who run script
  #$_.Checkin("Checked in by Administrator")
  #To undo check Out uncomment line below
  #$_.UndoCheckOut()
  }

 #Process all sub folders
 $Folder.SubFolders | ForEach-Object {
 Get-CheckedOutFiles $_
 }
}

#Call the function to find checkedout files
Write-Host ("Files(s) = ",(Get-CheckedOutFiles $Folder | measure | ForEach-Object {$_.Count})) -ForegroundColor Green

# http://www.sharepointdiary.com/2013/02/find-all-checked-out-files-and-check-in.html#ixzz4yUeAXpaX