
# -----------------------------------------------------------------------------
# Script	: SharePoint 2010 FARM  Monitoring
# Author	: Dipti Chhatrapati
# Version	: 1.0
# Date		: January 12 2015
# -----------------------------------------------------------------------------

#Add SharePoint PowerShell Snap-In
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {  
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"  
}

#####################################  Monitoring Script Start #####################################################

#Get Reporting Date
$ReportDate = Get-Date |select Day , DayOfWeek , Year | ConvertTo-Html -Fragment

#Get Start Time
$StartDate = Get-Date
$StartDateTime = $StartDate.ToUniversalTime()

#region Color code variables and functions

#Get Color code for all the status

#########################################  SharePoint Status Results   ###########################################

#Disabled Status
$DisabledStatus='<td>Disabled</td>'
$DisabledColorStyle='<td style="background-color:#C55A11 !important;color:white !important" >Disabled</td>'

#Offline Status
$OfflineStatus='<td>Offline</td>'
$OfflineColorStyle='<td style="background-color:#FF0000 !important;color:white !important" >Offline</td>'

#Unprovisioning Status
$UnprovisioningStatus='<td>Unprovisioning</td>'
$UnprovisioningColorStyle='<td style="background-color:#FFC000 !important;color:white !important" >Unprovisioning</td>'

#Provisioning Status
$ProvisioningStatus='<td>Provisioning</td>'
$ProvisioningColorStyle='<td style="background-color:#92D050 !important;color:white !important" >Provisioning</td>'

#Upgrading Status
$UpgradingStatus='<td>Upgrading</td>'
$UpgradingColorStyle='<td style="background-color:#00B0F0 !important;color:white !important" >Upgrading</td>'

#########################################  System Status Result   #################################################

#Error Status
$ErrorStatus='<td>Error</td>'
$ErrorColorStyle='<td style="background-color:#FF0000 !important;color:white !important" >Error</td>'

#Degraded Status
$DegradedStatus='<td>Degraded</td>'
$DegradedColorStyle='<td style="background-color:#C00000 !important;color:white !important" >Degraded</td>'

#Unknown Status
$UnknownStatus='<td>Unknown</td>'
$UnknownColorStyle='<td style="background-color:#7030A0 !important;color:white !important" >Unknown</td>'

#Pred Fail Status
$PredFailStatus='<td>Pred Fail</td>'
$PredFailColorStyle='<td style="background-color:#CC0066 !important;color:white !important" >Pred Fail</td>'

#Starting Status
$StartingStatus='<td>Starting</td>'
$StartingColorStyle='<td style="background-color:#92D050 !important;color:white !important" >Starting</td>'

#Stopping Status
$StoppingStatus='<td>Stopping</td>'
$StoppingColorStyle='<td style="background-color:#C55A11 !important;color:white !important" >Stopping</td>'

#Service Status
$ServiceStatus='<td>Service</td>'
$ServiceColorStyle='<td style="background-color:#548235 !important;color:white !important" >Service</td>'

#Stressed Status
$StressedStatus='<td>Stressed</td>'
$StressedColorStyle='<td style="background-color:#CC0066 !important;color:white !important" >Stressed</td>'

#NonRecover Status
$NonRecoverStatus='<td>NonRecover</td>'
$NonRecoverColorStyle='<td style="background-color:#FF0000 !important;color:white !important" >NonRecover</td>'

#NoContact Status
$NoContactStatus='<td>NoContact</td>'
$NoContactColorStyle='<td style="background-color:#FFC000 !important;color:white !important" >NoContact</td>'

#LostCom Status
$LostComStatus='<td>LostCom</td>'
$LostComColorStyle='<td style="background-color:#C55A11 !important;color:white !important" >LostCom</td>'

######################################### Windows Service Status   ##############################################

#Pending Status
$PendingStatus='<td>Pending</td>'
$PendingColorStyle='<td style="background-color:#92D050 !important;color:white !important" >Pending</td>'

#Paused Status
$PausedStatus='<td>Paused</td>'
$PausedColorStyle='<td style="background-color:#C55A11 !important;color:white !important" >Paused</td>'

#Stopped Status
$StoppedStatus='<td>Stopped</td>'
$StoppedColorStyle='<td style="background-color:#FF0000 !important;color:white !important" >Stopped</td>'

########################################  IIS App Pool Status  ##################################################

#starting Status
$startingPoolStatus='<td>1</td>'
$startingPoolColorStyle='<td style="background-color:#92D050 !important;color:white !important" >1</td>'

#stopping Status
$stoppingPoolStatus='<td>3</td>'
$stoppingPoolColorStyle='<td style="background-color:#C55A11 !important;color:white !important" >3</td>'

#Stopped Status
$StoppedPoolStatus='<td>4</td>'
$StoppedPoolColorStyle='<td style="background-color:#FF0000 !important;color:white !important" >4</td>'

########################################   Set Status Color Code Functions  #######################################

function SetSystemStatusColor
{
  $SystemStatushtml = $args[0]
    
  #Error
  $SystemStatushtml=$SystemStatushtml -replace $ErrorStatus,$ErrorColorStyle
  
  #Degraded
  $SystemStatushtml=$SystemStatushtml -replace $DegradedStatus,$DegradedColorStyle
  
  #Unknown
  $SystemStatushtml=$SystemStatushtml -replace $UnknownStatus,$UnknownColorStyle
  
  #Pred Fail
  $SystemStatushtml=$SystemStatushtml -replace $PredFailStatus,$PredFailColorStyle
  
  #Starting
  $SystemStatushtml=$SystemStatushtml -replace $StartingStatus,$StartingColorStyle
  
  #Stopping
  $SystemStatushtml=$SystemStatushtml -replace $StoppingStatus,$StoppingColorStyle
  
  #Service
  $SystemStatushtml=$SystemStatushtml -replace $ServiceStatus,$ServiceColorStyle
  
  #Stressed
  $SystemStatushtml=$SystemStatushtml -replace $StressedStatus,$StressedColorStyle
  
  #NonRecover
  $SystemStatushtml=$SystemStatushtml -replace $NonRecoverStatus,$NonRecoverColorStyle
  
  #NoContact
  $SystemStatushtml=$SystemStatushtml -replace $NoContactStatus,$NoContactColorStyle
  
  #LostCom 
  $SystemStatushtml=$SystemStatushtml -replace $LostComStatus,$LostComColorStyle
    
  $SystemStatushtml
}

function SetSharePointStatusColor
{
  $SharePointStatushtml = $args[0]
    
  #Disabled
  $SharePointStatushtml=$SharePointStatushtml -replace $DisabledStatus,$DisabledColorStyle
  
  #Offline
  $SharePointStatushtml=$SharePointStatushtml -replace $OfflineStatus,$OfflineColorStyle
  
  #Unprovisioning
  $SharePointStatushtml=$SharePointStatushtml -replace $UnprovisioningStatus,$UnprovisioningColorStyle
  
  #Provisioning
  $SharePointStatushtml=$SharePointStatushtml -replace $ProvisioningStatus,$ProvisioningColorStyle
  
  #Upgrading
  $SharePointStatushtml=$SharePointStatushtml -replace $UpgradingStatus,$UpgradingColorStyle
  
  $SharePointStatushtml
}

function SetWinServiceStatusColor
{
  $WinServiceStatushtml = $args[0]
      
  #Pending
  $WinServiceStatushtml=$WinServiceStatushtml -replace $PendingStatus,$PendingColorStyle
  
  #Paused
  $WinServiceStatushtml=$WinServiceStatushtml -replace $PausedStatus,$PausedColorStyle
  
  #Stopped
  $WinServiceStatushtml=$WinServiceStatushtml -replace $StoppedStatus,$StoppedColorStyle  
    
  $WinServiceStatushtml
}

function SetAppPoolStatusColor
{
  $AppPoolStatushtml = $args[0]
      
  #1 - starting
  $AppPoolStatushtml=$AppPoolStatushtml -replace $startingPoolStatus,$startingPoolColorStyle
  
  #3 - stopping
  $AppPoolStatushtml=$AppPoolStatushtml -replace $stoppingPoolStatus,$stoppingPoolColorStyle
  
  #4 - stopped
  $AppPoolStatushtml=$AppPoolStatushtml -replace $StoppedPoolStatus,$StoppedPoolColorStyle  
    
  $AppPoolStatushtml
}

#endregion

########################################  Variable  Declaration  ###################################################

#Define servers
$SPAppservers = @("SERVER 1","SERVER 2") # only SharePoint Servers
$ServersinFarm = @("SERVER 1","SERVER 2","SERVER 3","SERVER 4") #  SharePoint Servers including database and load balancing server
$Allservers = @("SERVER 1","SERVER 2","SERVER 4","SERVER 3","SERVER 5") #  SharePoint Servers including database and load balancing server + Mobile App Server

#Get SERVER 5 machine access details
$Computer = "SERVER 5" 
$Domain = "mydomain"                                                                               
$adminaccount = $Domain + "\SERVER5admin"
$PASSWORD = ConvertTo-SecureString "SERVER5Password" -AsPlainText -Force
$UNPASSWORD = New-Object System.Management.Automation.PsCredential $adminaccount, $PASSWORD

#region	CPU, Memory and Disk Utilization of Servers

#######################################  CPU Utilization Status Details  ##################################################

$CPUDataCol = Get-WmiObject -Class Win32_Processor -ComputerName $ServersinFarm | Select @{Name='Server Name';Expression={$_.SystemName}}, DeviceID , LoadPercentage , Status 
$CPUDataCol += Get-WmiObject -Class Win32_Processor -ComputerName $Computer -Credential $UNPASSWORD | Select @{Name='Server Name';Expression={$_.SystemName}} , DeviceID , LoadPercentage , Status  

$CPU = $CPUDataCol | ConvertTo-Html -Fragment
$CPU = SetSystemStatusColor $CPU
write-host Received CPU Utilization Status Details -foregroundcolor "green"

#######################################  Memory Utilization Status Details  #################################################

$MemoryCol = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ServersinFarm | Select @{Name='Server Name';Expression={$_.CsName}} , FreePhysicalMemory  , TotalVisibleMemorySize , Status 
$MemoryCol += Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -Credential $UNPASSWORD | Select @{Name='Server Name';Expression={$_.CsName}} , FreePhysicalMemory  , TotalVisibleMemorySize , Status 

$Memory = $MemoryCol | ConvertTo-Html -Fragment
$Memory = SetSystemStatusColor $Memory
write-host Received Memory Utilization Status Details -foregroundcolor "green"

#######################################  Disk Utilization Status Details  ##################################################

$DiskCol = Get-WmiObject -Class Win32_LogicalDisk -Filter DriveType=3 -ComputerName $ServersinFarm| Select @{Name='Server Name';Expression={$_.SystemName}} , DeviceID , @{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}}, @{Name="freespace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}
$DiskCol += Get-WmiObject -Class Win32_LogicalDisk -Filter DriveType=3 -ComputerName $Computer -Credential $UNPASSWORD | Select @{Name='Server Name';Expression={$_.SystemName}} , DeviceID , @{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}}, @{Name="freespace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}
$Disk = $DiskCol | ConvertTo-Html -Fragment

write-host Received Disk Status Details -foregroundcolor "green"

#endregion

#region SharePoint Farm and Servers Information

########################################  SharePoint Farm Configuration Status  ######################################

$SPFarm = Get-SPFarm | select Name , NeedsUpgrade , Status , BuildVersion |ConvertTo-Html -Fragment
$SPFarm = SetSharePointStatusColor $SPFarm
write-host Received SharePoint Farm Status Details -foregroundcolor "green"

########################################  SharePoint Farm License Details  ###########################################

# get the current folder
$0 = $myInvocation.MyCommand.Definition
$scriptDir = [System.IO.Path]::GetDirectoryName($0)
 
# load the version and licenses lookup data
[xml]$xml = Get-Content $scriptDir"\SharePointLicenses.xml" 
$farm = Get-SPFarm 
$installedProducts =  $farm | select Products
$installedLicences = $xml.SPSD.SharePoint.Licenses.License | Where-Object { $installedProducts.Products -icontains $_.Guid}
$installedLicences | ForEach-Object {Write-Host -ForegroundColor White "Installed SP license:"$_.Name}

$SPFarmLicenseDetails = $installedLicences | Select Name,Type,Guid|ConvertTo-Html -Fragment
write-host Received SharePoint Farm License Details -foregroundcolor "green"

########################################  SharePoint Server Status Details  ###########################################

$SPServersInfo = Get-SPServer | Select Name,Role,Status,CanUpgrade,NeedsUpgrade | ConvertTo-Html -Fragment
$SPServersInfo = SetSharePointStatusColor $SPServersInfo
write-host Received SharePoint Server Status Farm Details -foregroundcolor "green"

########################################  All Server Status Details  ##################################################

#SharePoint servers Status Details 
function get-SPServersDetails  
{

 
	[CmdletBinding()]

	[OutputType([int])]

	Param 
	 
	(
	 
	# Param1 help description

	[Parameter(Mandatory=$true,

	ValueFromPipeLine = $true,

	ValueFromPipelineByPropertyName=$true,

	Position=0)]

	[String[]]$ComputerName )

		Begin 
		 
		{

		}

		 
		Process 
		 
		{
		   if ( $ComputerName -eq "SERVER 5")
		   {
		        $Domain = "mydomain"                                                                               
				$adminaccount = $Domain + "\SERVER5admin"
				$PASSWORD = ConvertTo-SecureString "Cohe!2Sion" -AsPlainText -Force
				$UNPASSWORD = New-Object System.Management.Automation.PsCredential $adminaccount, $PASSWORD
				
				$OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName -Credential $UNPASSWORD

				$CS = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName -Credential $UNPASSWORD

				$data = @{

				'MachineName' = ($ComputerName) -join ';'

				'Operating System' = $OS.Caption

				'Model' = $CS.Model
				
				'OS Version' = $OS.Version
				
				'OS Architecture' = $OS.OSArchitecture
				
				'BootUp Status' = $CS.Bootupstate
				
				'Last Restart Time' = $OS.ConvertToDateTime($OS.LastBootUpTime)
				
				'Status' = $CS.Status			

			}
			 
			$Information = New-Object -TypeName PSObject -Property $data

			$Information
				
		   }
		   else
		   {
			$OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName

			$CS = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName

			$data = @{

			'MachineName' = ($ComputerName) -join ';'

			'Operating System' = $OS.Caption

			'Model' = $CS.Model
			
			'OS Version' = $OS.Version
			
			'OS Architecture' = $OS.OSArchitecture
			
			'BootUp Status' = $CS.Bootupstate
			
			'Last Restart Time' = $OS.ConvertToDateTime($OS.LastBootUpTime)
			
			'Status' = $CS.Status			

		}
		 
		$Information = New-Object -TypeName PSObject -Property $data

		$Information	
}		
		 
		}

		 
		End 
		{

		}

}

$SPServerDetails = $Allservers | %{get-SPServersDetails -ComputerName $_ } | ConvertTo-Html -Fragment
$SPServerDetails = SetSystemStatusColor $SPServerDetails
write-host Received All servers Details -foregroundcolor "green"

#endregion

#region Web Applications Status

########################################  SharePoint Web Application Status Details  ###################################

$WebApplication = Get-SPWebApplication | Select Name , Url ,   Status | ConvertTo-Html -Fragment
$WebApplication = SetSharePointStatusColor $WebApplication
write-host Received Web Application Status Details -foregroundcolor "green"

########################################  Site Response Status Details  ################################################

#Get existing web apps url
[Array]$webApps = Get-SPWebApplication | Select Url
$webAppItems = @()
foreach($site in $webApps)
{
$webAppItems += $site.Url
}
$webAppItems += "http://mobileapp.mydomain.com"

#get site collection response
function Get-SiteResponse
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [system.String[]]
        $sites
    )

    Begin
    {
    }
    Process
    {
      
            foreach($site in $sites)
                {
                    
                    try
                    {
                    $request = [System.Net.WebRequest]::Create($site)
                    $request.UseDefaultCredentials = $true
                    $response = $request.GetResponse()
                    $response | Select @{Name='Web URL';Expression={$_.ResponseUri}} , StatusCode 
                    $response.Close()
                    }
                    catch{$_.Exception | Select ErrorRecord , stacktrace ; continue;}
             
               }
    }
    End
    {
    }
}

#Get site collection response for SPServers
function Get-RemoteSiteResponse
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [system.String[]]
        $sites
    )

    Begin
    {
    }
    Process
    {
      
            foreach($site in $sites)
                {
                    Invoke-Command -ComputerName $SPAppservers -ScriptBlock ${function:Get-SiteResponse} -ArgumentList $site
             
               }
    }
    End
    {
    }
}

$SiteResponses = Get-RemoteSiteResponse -sites $webAppItems | ConvertTo-Html -Fragment
$SiteResponses = SetSystemStatusColor $SiteResponses
write-host Received web app response status details -foregroundcolor "green"

########################################  Site Response Time Details  ##################################################

#Site Collection Response Time
function Get-SPWebApplicationResponseTime
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $WebApplications    
    )

    Begin
    {
       
    }
    Process
    {
				foreach($WebApplication in $WebApplications)
                {	
					try
                    {			    
						$Request = New-Object System.Net.WebClient
						$Request.UseDefaultCredentials = $true
						$Start = Get-Date
						$PageRequest = $Request.DownloadString($WebApplication)
						$TimeTaken = ((Get-Date) - $Start).Totalseconds
						$Request | Select @{Name='Web URL';Expression={$WebApplication}} , @{Name='Response Time in seconds';Expression={$TimeTaken}}
						$Request.Dispose()											 
					}
                    
					catch{$_.Exception | Select ErrorRecord , stacktrace ; continue;}
             
				}		
	}
    
    End
    {
        
    }
}

#Get site collection response for SPServers
function Get-RemoteWebResponseTime
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [system.String[]]
        $sites
    )

    Begin
    {
    }
    Process
    {
      
            foreach($site in $sites)
                {
                    Invoke-Command -ComputerName $SPAppservers -ScriptBlock ${function:Get-SPWebApplicationResponseTime} -ArgumentList $site
             
               }
    }
    End
    {
    }
}


$WebResponseTime = Get-RemoteWebResponseTime -sites $webAppItems | ConvertTo-Html -Fragment
$WebResponseTime = SetSystemStatusColor $WebResponseTime
write-host Received web app response time status details -foregroundcolor "green"

#endregion

#region GATE Usage and Users Information

#######################################  Usage Report of GATE #################################################################
 
Function Get-WASummaryReport($Context,$DaysToGoBack){ 
    Add-PSSnapin Microsoft.SharePoint.PowerShell -ea 0; 
    [System.Reflection.Assembly]::Load("Microsoft.Office.Server.WebAnalytics, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c") | Out-Null; 
    [System.Reflection.Assembly]::Load("Microsoft.Office.Server.WebAnalytics.UI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c") | Out-Null; 
     
    Function DateTimeToDateId ([System.DateTime]$dt){ 
        if (![System.String]::IsNullOrEmpty($dt.ToString())){ 
            return [System.Int32]::Parse($dt.ToString("yyyyMMdd", [System.Globalization.CultureInfo]::InvariantCulture), [System.Globalization.CultureInfo]::InvariantCulture); 
        }else{ 
            return 0; 
        } 
    } 
     
    #Not used in this report but other report types require it. 
    Function GetSortOrder([String]$sortColumn,[Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.OrderType]$order){ 
        $SortOrders = New-Object System.Collections.Generic.List[Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.SortOrder]; 
        $sortOrders.Add((New-Object Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.SortOrder($sortColumn, $order))); 
        return ,$SortOrders 
    } 
     
    $AggregationContext = [Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.AggregationContext]::GetContext($Context); 
    if (!$?){throw "Cant get the Aggregation Context";} 
     
    $viewParamsList = New-Object System.Collections.Generic.List[Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.ViewParameterValue] 
    $viewParamsList.Add((New-Object Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.ViewParameterValue("PreviousStartDateId", (DateTimeToDateId([System.DateTime]::UtcNow.AddDays(-($DaysToGoBack * 2))))))); 
    $viewParamsList.Add((New-Object Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.ViewParameterValue("CurrentStartDateId", (DateTimeToDateId([System.DateTime]::UtcNow.AddDays(-($DaysToGoBack))))))); 
    $viewParamsList.Add((New-Object Microsoft.Office.Server.WebAnalytics.ProcessedDataRetriever.ViewParameterValue("Duration", $DaysToGoBack))); 
 
    $dataPacket = [Microsoft.Office.Server.WebAnalytics.Reporting.FrontEndDataRetriever]::QueryData($AggregationContext, $null, "fn_WA_GetSummary", $viewParamsList, $null, $null, 1, 25000, $False); 
    if (!$?){throw "Unable to get the Data. Try running the script as the Farm Account. If that doesnt work, make sure that the Web Analytics Service Application is connected to the Web Application and that the Site Web Analytics reports work through the browser.";} 
     
    return $dataPacket.DataTable 
} 
 
$WebApp = Get-SPWebApplication http://portal.mydomain.com
$UsageReports = Get-WASummaryReport -Context $WebApp -DaysToGoBack 1 | Select propertyname, currentvalue ,previousvalue, percentagechange  | ConvertTo-Html -Fragment

write-host Received GATE usage report -foregroundcolor "green"

#######################################  Users Report of GATE #################################################################

$siteUrl = "http://mysite.mydomain.com/"
$userInfoCollection = @()
$netbiosNames = @("Mydomain1","Mydomain2","Mydomain3")

foreach ($netbios in $netbiosNames) 
{
	# Get User Profile Context
	$serviceContext = Get-SPServiceContext -Site $siteUrl
	$profileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($serviceContext);
	$profiles = $profileManager.GetEnumerator()
	$userCollection = @()

	foreach ($profile in $profiles) 
	{
		#Define Profile Data
		$userData = "" |	select "AccountName"

		#Get Domain Name
		$string = $profile["AccountName"].ToString().Split('\')[0]
		
		#Extract user If domain name matches
		if ($netbios -contains $string)
		{			
			$userData.AccountName = $profile["AccountName"]		
			$userCollection += $userData
		}
		
	}

$userInfoData = "" |  select "DomainName","TotalUsersCount"
$userInfoData.TotalUsersCount = $userCollection.Length	
$userInfoData.DomainName = $netbios	
$userInfoCollection += $userInfoData

}

$GATEUserInfo =  $userInfoCollection | ConvertTo-Html -Fragment
write-host Received GATE Users Report -foregroundcolor "green"

#endregion

#region SharePoint Windows Services and App-Pools status

########################################  Windows sharePoint Services Status Details  ##################################

$SPServices = invoke-command -computername $SPAppservers {get-Service -DisplayName 'SharePoint 2010 Administration','SharePoint 2010 Timer','SharePoint 2010 Tracing','SharePoint Server Search 14','Forefront Identity Manager Service','Forefront Identity Manager Synchronization Service' | Select DisplayName,Status,PSComputerName } | Sort-Object Status | ConvertTo-Html -Fragment
$SPServices = SetWinServiceStatusColor $SPServices
write-host Received SharePoint Windows Service Status -foregroundcolor "green"

#######################################  IIS Application Pool Status Details  ##########################################


$IISAppPoolCol = Get-WmiObject -Authentication PacketPrivacy -Impersonation Impersonate -ComputerName $SPAppservers  -namespace "root/MicrosoftIISv2" -class IIsApplicationPoolSetting | Select @{Name='SharePoint Server';Expression={$_.__SERVER}} ,@{Name='App Pool Name';Expression={$_.Name}},@{Name='AppPool Identity';Expression={$_.WAMUserName}},@{Name='AppPool Status';Expression={$_.AppPoolState}}
$IISAppPoolCol += Get-WmiObject -Authentication PacketPrivacy -Impersonation Impersonate -ComputerName $Computer -Credential $UNPASSWORD   -namespace "root/MicrosoftIISv2" -class IIsApplicationPoolSetting | Select @{Name='SharePoint Server';Expression={$_.__SERVER}} ,@{Name='App Pool Name';Expression={$_.Name}},@{Name='AppPool Identity';Expression={$_.WAMUserName}},@{Name='AppPool Status';Expression={$_.AppPoolState}}
$IISAppPool = $IISAppPoolCol | ConvertTo-Html -Fragment
$IISAppPool = SetAppPoolStatusColor $IISAppPool 
write-host Received IIS AppPool Status -foregroundcolor "green"

#endregion

#region SharePoint Service Applications Status

#######################################  SharePoint Service Application Status Details  ##################################

$ServiceAppplications = Get-SPServiceApplication | Select DisplayName , ApplicationVersion , Status , NeedsUpgrade | Convertto-Html -Fragment
$ServiceAppplications = SetSharePointStatusColor $ServiceAppplications
write-host Received Service Application Status Details -foregroundcolor "green"

#######################################  SharePoint Service Application Proxy Status Details  ###########################

$ApplicationProxies = Get-SPServiceApplicationProxy | Select TypeName ,Status , NeedsUpgrade | ConvertTo-Html -Fragment
$ApplicationProxies = SetSharePointStatusColor $ApplicationProxies
write-host Received Application Proxy Status Details -foregroundcolor "green"

#######################################  SharePoint Service Instances Status Details  ###################################

$SPServiceInstanceCol = @()
foreach($server in $SPAppservers)
{
$SPServiceInstanceCol += Get-SPServiceInstance -Server $server | Select Server,TypeName,Status,NeedsUpgrade | Sort-Object Status
}
$SPServiceInstances = $SPServiceInstanceCol | Convertto-Html -Fragment
$SPServiceInstances = SetSharePointStatusColor $SPServiceInstances
write-host Received Service Instances Status  Details -foregroundcolor "green"

#endregion

#region SharePoint Custom Solution Status

#######################################  SharePoint Custom Solution Status Details  ######################################

$SPSolutions = Get-SPSolution | Select Name , Deployed , Status | ConvertTo-Html -Fragment
$SPSolutions = SetSharePointStatusColor $SPSolutions
write-host Received SharePoint Custom Solution Status Details -foregroundcolor "green"

#endregion

#region SharePoint Databases status

#######################################  SharePoint Database Status Details  #############################################

$DBCheck = Get-SPDatabase | Select Name ,WebApplication,CurrentSiteCount, Status , NeedsUpgrade , @{Label ="Size in MB"; Expression = {$_.disksizerequired/1024/1024}} 
$SPDBReport = $DBCheck | ConvertTo-Html -Fragment
$SPDBReport = SetSharePointStatusColor $SPDBReport

#Get Database Information
$DatabaseCol = "" |  select "NoOfDatabase","TotalDatabaseSize"
$DatabaseCol.NoOfDatabase = ($DBCheck | Measure-Object).Count
$DatabaseCol.TotalDatabaseSize = ($DBCheck | Measure-Object "Size in MB" -Sum).Sum
$DatabaseColReport =  $DatabaseCol | ConvertTo-Html -Fragment
$DatabaseColReport = SetSharePointStatusColor $DatabaseColReport

write-host Received Database Status Details -foregroundcolor "green"

#endregion

#region SharePoint Failed Timer Jobs details

#######################################  Failed Timer Jobs since last day Status Details  ###################################

$YesterdayStartDateTime = (Get-Date).AddDays(-1).ToString('MM-dd-yyyy') + " 00:00:00"
$YesterdayEndDateTime = (Get-Date).AddDays(-1).ToString('MM-dd-yyyy') + " 24:00:00"

$FailedSPTimerJobs = Get-SPTimerJob | % { $_.HistoryEntries } | Where-Object {($_.StartTime -gt $YesterdayStartDateTime) -and ($_.To -lt $YesterdayEndDateTime) -and ($_.Status -eq 'Failed')} 
write-host Received Failed Timer Jobs -foregroundcolor "green"

if($FailedSPTimerJobs){
		$TimerJobBody=$FailedSPTimerJobs | Select JobDefinitionTitle,WebApplicationName,ServerName,Status,StartTime,EndTime,ErrorMessage | ConvertTo-Html -Fragment
}else{
    $TimerJobBody='There are no recorded Failed Jobs' |ConvertTo-Html -Fragment
}

write-host Received Failed Timer Jobs -foregroundcolor "green"

#endregion

#######################################  Calculate End time ####################################################################

#Get End Time
$EndDate = Get-Date
$EndDateTime = $EndDate.ToUniversalTime()

#Get Reporting Execution Time 
$ReportTimeDataCol = "" |  select "StartDateTime","EndDateTime"
$ReportTimeDataCol.StartDateTime = $StartDateTime	
$ReportTimeDataCol.EndDateTime = $EndDateTime

$ReportTimeData =  $ReportTimeDataCol | ConvertTo-Html -Fragment

#######################################  Convert Report to HTML #################################################################

ConvertTo-Html -Body "

<font color = blue><H4><B>Reporting Date</B></H4></font>$ReportDate
<font color = blue><H4><B>Reporting Execution Time</B></H4></font>$ReportTimeData

<font color = blue><H4><B>CPU Utilization</B></H4></font>$CPU
<font color = blue><H4><B>Memory Utilization</B></H4></font>$Memory
<font color = blue><H4><B>Disk Utilization</B></H4></font>$Disk

<font color = blue><H4><B>SharePoint Farm Status</B></H4></font>$SPFarm
<font color = blue><H4><B>SharePoint License Details</B></H4></font>$SPFarmLicenseDetails

<font color = blue><H4><B>SharePoint servers status</B></H4></font>$SPServersInfo
<font color = blue><H4><B>All Server Details</B></H4></font>$SPServerDetails

<font color = blue><H4><B>SharePoint Web Application Status</B></H4>$WebApplication
<font color = blue><H4><B>All Alive Web Applications</B></H4></font>$SiteResponses
<font color = blue><H4><B>All Web Applications Response Time</B></H4></font>$WebResponseTime

<font color = blue><H4><B>GATE Usage Details</B></H4></font>$UsageReports
<font color = blue><H4><B>GATE Users Details</B></H4></font>$GATEUserInfo

<font color = blue><H4><B>SharePoint Windows Services Status</B></H4></font>$SPServices
<font color = blue><H4><B>IIS Application Pool Status - AppPoolState will return 1=starting, 2=started, 3=stopping, 4=stopped</B></H4>$IISAppPool

<font color = blue><H4><B>SharePoint Service Application Status</B></H4>$ServiceAppplications
<font color = blue><H4><B>SharePoint Service Application Proxy Status</B></H4>$ApplicationProxies
<font color = blue><H4><B>SharePoint Service Instances Status</B></H4>$SPServiceInstances

<font color = blue><H4><B>SharePoint Custom Solution Status</B></H4></font>$SPSolutions
<font color = blue><H4><B>SharePoint Content Database Status</B></H4></font>$SPDBReport
<font color = blue><H4><B>SharePoint Content Database Information</B></H4></font>$DatabaseColReport

<font color = blue><H4><B>Failed Timer Jobs</B></H4></font>$TimerJobBody" -Title "SharePoint Farm Status Report" -CssUri C:\style.CSS | Out-File "C:\Reports\FarmReport.html" -Encoding ascii

#######################################  Send Email ###########################################################################
$caWebApp=(Get-SPWebApplication -IncludeCentralAdministration) | ? {$_.IsAdministrationWebApplication -eq $true}
$SMTP=$caWebApp.OutboundMailServiceInstance.Server.Address
$Subject = "SharePoint Farm Report"
$Body = "Please find enclosed Monitoring Report."
$To = "user1@mydomain.com"," user2@mydomain.com"," user3@mydomain.com"
$From = "Administrator@mydomain.com" 
$Report = Get-Content "C:\Reports\FarmReport.html"
$mailBody = Get-Content "C:\Reports\emailBody.html"

send-mailmessage -from $From -to $To -subject $Subject -BodyAsHtml "$mailBody"-Attachments "C:\Reports\FarmReport.html" -priority High -dno onSuccess, onFailure -smtpServer $SMTP

#######################################  Monitoring Script End #################################################################

