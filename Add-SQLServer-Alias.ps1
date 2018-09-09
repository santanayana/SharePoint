Function WriteLine
{
    Write-Host -ForegroundColor White "--------------------------------------------------------------"
}

Function AddSQLServerAlias
{
	# SQL Server client alias Based on this message
	# From Zach's post: http://habaneroconsulting.com/Insights/Create-a-SQL-Alias-with-a-PowerShell-Script.aspx
	
	Try
	{
		[string]$AliasName = "SQLServerForSharePoint"
		[string]$ServerName =  "MySQLServerFullQulifiedName"  #$env:computername

		#These are the two Registry locations for the SQL Alias locations 
		[string]$x86 = "HKLM:\Software\Microsoft\MSSQLServer\Client\ConnectTo"
		[string]$x64 = "HKLM:\Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo"
		   
		#We're going to see if the ConnectTo key already exists, and create it if it doesn't. 
		if ((test-path -path $x86) -ne $True) 
		{ 
			write-host "$x86 doesn't exist"
			New-Item $x86
		} 
		if ((test-path -path $x64) -ne $True) 
		{ 
			write-host "$x64 doesn't exist"
			New-Item $x64
		} 
		   
		#Adding the extra "fluff" to tell the machine what type of alias it is 
		$TCPAlias = ("DBMSSOCN," + $ServerName) 
		   
		#Creating our TCP/IP Aliases 
		WriteLine
		Write-Host -ForegroundColor White " - Create the SQL Alias..."

		$exists = Get-ItemProperty -Path "$x86" -Name "$AliasName" -ErrorAction SilentlyContinue
		Write-Host "  -> Alias in $x86 :", $exists.$AliasName
		if(($exists.$AliasName -eq $null) -or ($exists.$AliasName.Length -eq 0))
		{
			Write-Host "  -> New Alias created :", $AliasName, "- Value :", $TCPAlias
			New-ItemProperty -Path $x86 -Name $AliasName -PropertyType String -Value $TCPAlias
		}
		else
		{
			Write-Host "  -> Alias updated :", $AliasName, "- Value :", $TCPAlias
			Set-ItemProperty -Path $x86 -Name $AliasName -Value $TCPAlias
		}

		$exists = Get-ItemProperty -Path "$x64" -Name "$AliasName" -ErrorAction SilentlyContinue
		Write-Host "  -> Alias in $x64 :", $exists.$AliasName
		if(($exists.$AliasName -eq $null) -or ($exists.$AliasName.Length -eq 0))
		{
			Write-Host "  -> New Alias created :", $AliasName, "- Value :", $TCPAlias
			New-ItemProperty -Path $x64 -Name $AliasName -PropertyType String -Value $TCPAlias
		}
		else
		{
			Write-Host "  -> Alias updated :", $AliasName, "- Value :", $TCPAlias
			Set-ItemProperty -Path $x64 -Name $AliasName -Value $TCPAlias
		}
		WriteLine
		 
		# Open cliconfig to verify the aliases 
		Start-Process C:\Windows\System32\cliconfg.exe
		Start-Process C:\Windows\SysWOW64\cliconfg.exe
	}
	catch  [system.exception]
	{
        Write-Host -ForegroundColor Yellow " ->> SQL Alias caught a system exception"
		Write-Host -ForegroundColor Red "Exception Message:", $_.Exception.ToString()
	}
	finally
	{
        WriteLine
	}
}

AddSQLServerAlias
