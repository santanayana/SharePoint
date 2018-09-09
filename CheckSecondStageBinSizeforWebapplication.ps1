if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {Add-PSSnapin "Microsoft.SharePoint.PowerShell"}
 
$WebApp=get-spwebapplication "http://mysite.statoilfuelretail.com"
 
    foreach ($SPSite in $WebApp.Sites)
    {      
     # SPRecycleBinQuery to Query Reycle bin   
     $SPRecycleBinQuery=new-object Microsoft.SharePoint.SPRecycleBinQuery
     $SPRecycleBinQuery.OrderBy = [Microsoft.SharePoint.SPRecycleBinOrderBy]::DeletedDate;
     $SPRecycleBinQuery.IsAscending = $false;
     $SPRecycleBinQuery.RowLimit = 2000
     $SPRecycleBinQuery.ItemState = [Microsoft.SharePoint.SPRecycleBinItemState]::SecondStageRecycleBin
    
     $SPRecycleBinItemCollection  = $SPSite.GetRecycleBinItems($SPRecycleBinQuery)
      
       $Size=0
        
        for ($i=$SPRecycleBinItemCollection.Count-1; $i -GE 0;  $i--)
            {
                        $guid = $SPRecycleBinItemCollection[$i].ID;
                        #$SPRecycleBinItemCollection.Restore($guid);
                        #$SPRecycleBinItemCollection.Delete($guid);
                        $Size+=$SPRecycleBinItemCollection[$i].Size
                     
            }
          write-host "Recycle bin Size in" $SPSite.RootWeb.Title "-"  $SPSite.RootWeb.URL ":" ($size/1MB)  
       }


#Read more: http://www.sharepointdiary.com/2012/08/get-sharepoint-recycle-bin-storage-size.html#ixzz4xwflWfQ7