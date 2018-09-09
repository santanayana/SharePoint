[system.reflection.assembly]::LoadWithPartialName("Microsoft.Sharepoint")

$site = New-Object Microsoft.SharePoint.SPSite("http://SP2010")

$root = $site.allwebs[0]

$folder = $root.GetFolder("My Document Library")

#============================================================

# Function Set-CheckInFolderItems is a recursive function 

# that will CheckIn all items in a list recursively

#============================================================

function Set-CheckInFolderItems([Microsoft.SharePoint.SPFolder]$folder)

{

    # Create query object

    $query = New-Object Microsoft.SharePoint.SPQuery

     $query.Folder = $folder



    # Get SPWeb object

    $web = $folder.ParentWeb



    # Get SPList

    $list = $web.Lists[$folder.ParentListId]

    # Get a collection of items in the specified $folder

    $itemCollection = $list.GetItems($query)

    # If the folder is the root of the list, display information

    if ($folder.ParentListID -ne $folder.ParentFolder.ParentListID)

    {

        Write-Host("Recursively checking in all files in " + $folder.Name)

    }

    # Iterate through each item in the $folder 

    foreach ($item in $itemCollection)

    {

        # If the item is a folder

        if ($item.Folder -ne $null)

        {

            # Write the Subfolder information

            Write-Host("Folder: " + $item.Name + " Parent Folder: " + $folder.Name)


            # Call the Get-Items function recursively for the found sub-solder

            Set-CheckInFolderItems $item.Folder

        }


        # If the item is not a folder

        if ($item.Folder -eq $null)

        {

            if ($item.File.CheckOutType -ne "None")

            {

                if ($item.File.Versions.Count -eq 0)

                {

                    # Check in the file

Write-Host "Check in File: "$item.Name" Version count " $item.File.Versions.Count -foregroundcolor Green

                    $item.File.CheckIn("Checked in By Administrator")

                }

            }

        }

    }

    $web.dispose()

    $web = $null

}

　

Set-CheckInFolderItems $folder