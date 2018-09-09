#Add SharePoint PowerShell Snap-In
Add-PSSnapin Microsoft.SharePoint.PowerShell -erroraction SilentlyContinue

$servers = @("SFRFIDCSHDB001P","SFRFIDCSHDB002P","SFRFIDCSHDB003P","SFRFIDCSHDB004P","SFRFIDCSHDB005P","SFRFIDCSHDB006P")
$ReportDate = Get-Date |select Day , DayOfWeek, Month , Year | ConvertTo-Html -Fragment

$CPU = Get-WmiObject -Class Win32_Processor -ComputerName $servers | 
Select SystemName , DeviceID , LoadPercentage , Status | ConvertTo-Html -Fragment

$Memory = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $servers| 
Select CsName , FreePhysicalMemory  , TotalVisibleMemorySize , Status | 
ConvertTo-Html -Fragment

$CompStatus = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $servers |
Select Name , Bootupstate , Status | ConvertTo-Html -Fragment

$ServerOS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $servers | 
Select Path , caption , Version , OSArchitecture , Status |ConvertTo-Html -Fragment

$FarmUpTime = Get-WmiObject -class Win32_OperatingSystem -ComputerName $servers | 
Select-Object __SERVER,@{label='LastRestart';expression={$_.ConvertToDateTime($_.LastBootUpTime)}} | ConvertTo-Html -Fragment

$ping = Test-Connection -Count 1 -ComputerName $servers | 
Select Address , IPV4Address , Statuscode | ConvertTo-Html -Fragment 

$SPServers = Get-SPServer | 
select Address , Status , Farm | ConvertTo-Html -Fragment

$SPFarm = Get-SPFarm | 
select Name , NeedsUpgrade , Status , BuildVersion |ConvertTo-Html -Fragment

$SPSolutions = Get-SPSolution | 
Select Name , Deployed , Status | ConvertTo-Html -Fragment


$SystemProcessor = Get-WmiObject -Class Win32_Processor -ComputerName $servers | 
select SystemName , Name , MaxClockSpeed , Manufacturer , status |ConvertTo-Html -Fragment

$SPTimeZones = Get-WmiObject -Class Win32_TimeZone -ComputerName $servers |
Select __Server , Caption | ConvertTo-Html -Fragment

$WebApplication = Get-SPWebApplication | 
Select Name , Url , ContentDatabases , NeedsUpgrade , Status | ConvertTo-Html -Fragment

$ServiceAppplication = Get-SPServiceApplication | 
Select DisplayName , ApplicationVersion , Status , NeedsUpgrade | Convertto-Html -Fragment

$DBCheck = Get-SPDatabase | 
Select Name , Status , NeedsUpgrade , @{Name=”size(GB)”;Expression={“{0:N1}” -f($_.Disksizerequired/1gb)}} | 
ConvertTo-Html -Fragment

$AppPool = Get-SPServiceApplicationPool |
Select Name , ProcessAccountName , status | ConvertTo-Html -Fragment

$AppPoolWebApplication = Get-SPWebApplication |
Select Name , ProcessAccountName , status | ConvertTo-Html -Fragment

$css = "<style>body { font-family:Calibri; font-size:10pt;} th { background-color:black; color:white;} td { background-color:#19fff0; color:black;} </style>" 

ConvertTo-Html -Body "<font color = blue><H4><B>Report Executed On</B></H4></font>$ReportDate

<font color = blue><H4><B>CPU Utilization</B></H4></font>$CPU
<font color = blue><H4><B>Memory Utilization</B></H4></font>$Memory
<font color = blue><H4><B>Machine Status</B></H4></font>$CompStatus
<font color = blue><H4><B>Application Pool Status</B></H4>$AppPool
<font color = blue><H4><B>Web Application Pool Status</B></H4>$AppPoolWebApplication
<font color = blue><H4><B>Operating System Check</B></H4></font>$ServerOS
<font color = blue><H4><B>Farm Status</B></H4></font>$SPFarm
<font color = blue><H4><B>SharePoint Solution Status</B></H4></font>$SPSolutions
<font color = blue><H4><B>NIC Status : Enabled</B></H4></font>$NIC
<font color = blue><H4><B>Web Application Status Check</B></H4>$WebApplication
<font color = blue><H4><B>Service Application Status Check</B></H4>$ServiceAppplication
<font color = blue><H4><B>Time Zone Settings</B></H4></font>$SPTimeZones
<font color = blue><H4><B>Processor Check</B></H4></font>$SystemProcessor
<font color = blue><H4><B>Server Health Report</B></H4></font>$SPServers
<font color = blue><H4><B>Servers Ping Response (0=Success)</B></H4></font>$ping
<font color = blue><H4><B>Server Last Reboot Status</B></H4></font>$Farmuptime
<font color = blue><H4><B>Database Check</B></H4></font>$DBCheck" -Title "SharePoint Farm Capacity and Load Check Report" -head $css | Out-File D:\Script\SMA_Prod_SharePointHealthStatus.html

$smtpServer = "sfrfidcexch001p.statoilfuelretail.com"
$file = "D:\SFR_Prod_SharePointCapacity.html"
$att = new-object Net.Mail.Attachment($file)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "SharePointAdmin@statoilfuelretail.com"
$msg.To.Add("deepak.dhiman@capgemini.com")
$msg.ReplyTo = "deepak.dhiman@capgemini.com"
$msg.Cc.Add("deepak.dhiman@capgemini.com")
$msg.Cc.Add("deepak.dhiman@capgemini.com")
$msg.subject = "SharePoint Farm Capacity and Load Check Report"
$msg.body = "
Hello Team

This Report is generated every day to keep track of SharePoint Farm Health Check . Please contact im-germany-sharepoint.in@capgemini.com  in case of any queries or suggestions

Best Regards
SharePoint Administrator
"
$msg.Attachments.Add($att)
$smtp.Send($msg)
exit        
