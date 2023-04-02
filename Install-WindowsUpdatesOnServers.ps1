$CurrentDate = Get-Date -Format "MMddyyyy"
$PSWindowsUpdateModuleNetworkLocaiton = "\\Server.lab.local\PSWU$\Module\PSWindowsUpdate"
$LogFile =  "\\Server.lab.local\PSWU$\Log\UpdateTaskLog_" + $env:computername + "_" + $CurrentDate + ".txt"
$ServersThatAreRebootingAt1AM = "ExchangeServer","DC"
$ServersThatAreRebootingAt2AM = "CA","DC2"
$ServersThatAreRebootingAt3AM = "WSUS"
############################################################ Other Servers will schedule the reboot at 4 AM ############################################################



#Check if the major version of powershell is greather or equal 5 
$psversion = $PSVersionTable.PSVersion.Major
if (-not ($psversion -ge 5)) {
    throw 'Please execute the script with a newer verion of Powershell!'
}

#Check If the user who runs this script is an admin
$ScriptIsRunningAsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($ScriptIsRunningAsAdmin -eq $false) {
    throw 'Please execute the script with admin rights!'
}

#Check If PSWindowsUpdate is installed. If not the script will try to install PSWindowsUpdate via from a SMB-Share
if (-not(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Copy-Item -Path $PSWindowsUpdateModuleNetworkLocaiton -Destination "C:\Program Files\WindowsPowerShell\Modules" -Recurse
}


#Verify that the computer running the script is included in the ServersThatAreRebootingAt1AM list.
if ($ServersThatAreRebootingAt1AM.Contains($env:computername)) {
    $ScheduleRebootTime = (Get-Date -Hour 01 -Minute 0 -Second 0)
}
#Verify that the computer running the script is included in the ServersThatAreRebootingAt2AM list.
elseif ($ServersThatAreRebootingAt2AM.Contains($env:computername)) {
    $ScheduleRebootTime = (Get-Date -Hour 02 -Minute 0 -Second 0)
}
#Verify that the computer running the script is included in the ServersThatAreRebootingAt3AM list.
elseif ($ServersThatAreRebootingAt3AM.Contains($env:computername)) {
    $ScheduleRebootTime = (Get-Date -Hour 03 -Minute 0 -Second 0)
}
#If the computer does not match in any of the above conditions it will reboot at 4am when the updates require a reboot.
else {
    $ScheduleRebootTime = (Get-Date -Hour 04 -Minute 0 -Second 0)
}

#Check if the date is in the past. If it is, the script will perform the restart on the next day.
$Now = Get-Date 
if($ScheduleRebootTime -lt $Now){
    $ScheduleRebootTime = $ScheduleRebootTime.AddDays(1)
}

#Install
Import-Module PSWindowsUpdate
Install-WindowsUpdate -AcceptAll -ScheduleReboot $ScheduleRebootTime -Verbose | Out-File $LogFile
cmd /c msg * "This computer is scheduled for reboot at $ScheduleRebootTime if the updates needed a reboot. So save your work to be on the safe side!"