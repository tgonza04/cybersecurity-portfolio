#requires -version 2
<#
.SYNOPSIS
  <Overview of script>
.DESCRIPTION
  <Brief description of script>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
.EXAMPLE
  powershell -executionpolicy unrestricted .\ldat-template.ps1
#>

#-------------LOOK HERE (STEP 1)----------------
# Step 1: Check to make sure script is run as administrator
# Write your code here. You want to exit the program if you do not have admin privileges
# Hint: review https://gitlab.com/jknyght9/deploy-windows-dfir forensic-baseline.ps1 for help
#-----------------------------------------------

# Set output directory
$ToolName = "LDAT"
$OutputDir = "C:\ForensicCollection"
$LogDir = "${OutputDir}\Logs"
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

# Get case information
$CaseNumber = Read-Host -Prompt "Enter case number"
$Investigator = Read-Host -Prompt "Enter your name"
$Contact = Read-Host -Prompt "Enter your email address"
# Create an object to store the case information
$CaseInfo = [PSCustomObject]@{
  "Case Number"   = $CaseNumber
  "Investigator"  = $Investigator
  "Contact Email" = $Contact
}

# Output as a formatted table
$CaseInfo | Format-Table -AutoSize

# Get current datetime in YYYY-MM-DD_HH-MM-SS format
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Get the computer hostname
$Hostname = $env:COMPUTERNAME

# Starting a transcript of activity
Start-Transcript -Path "${LogDir}\${Timestamp}_${CaseNumber}_${Hostname}-${ToolName}-Collection.txt" -NoClobber
Write-Host "Creating transcript and starting collection..."

#-------------LOOK HERE (STEP 2-13) ----------------
# Step 2: Obtain computer system information using a PowerShell cmdlet. Output must be in text format
Get-ComputerInfo | Select-Object CsName, CsDomain, OSArchitecture, OSInstallData, OsTotalVisibleMemorySize, OsUptime, Timezone, LogonServer, WindowsProductName, WindowsRegisteredOwner | Out-File ${OutputDir}\systeminformation.txt
# Step 3: Obtain a list of running processes including their name and ID. Output must be in CSV format
# Step 4: Obtain a list of services with name, display name, status, start type, and service type. Output must be in text format
# Step 5: Obtain a list of local users with their group memberships. Output must be in text format
# Step 6: Obtain a list of local and remote shares. Output must be in text format
# Step 7: Obtain a list of network adapters. Output must be in JSON format
# Step 8: Obtain the IP network configurations for all adapters. Output must be in text format
# Step 9: Obtain a list of TCP connections including local address, local port, remote address, remote port, state, and owning process. Output must be in text format
# Step 10: Obtain a list of UDP connections including local address, local port, remote address, remote port, state, and owning process. Output must be in text format
# Step 11: Obtain the ARP table. Output must be in text format
# Step 12: Obtain the Route table. Output must be in text format
Get-ChildItem ${OutputDir} -File | Get-FileHash -Algorithm SHA256 | Format-Table Path, Hash | Out-File "${LogDir}\FileHashes.txt"
# Step 13: Hash all output files using SHA256, include the path and hash, and put them into a file named TIMESTAMP_CASENUMBER_HOSTNAME-Filehashes.txt
#---------------------------------------------------

Write-Host "Forensic data collection complete. Output saved to $OutputDir"
Stop-Transcript
