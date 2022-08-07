#Load Function
Function Install-WindowsUpdatesOnServers {
    <#
    .SYNOPSIS
        Used for automating my windows update workflow on servers
    
    
    .NOTES
        Name: Install-WindowsUpdatesOnServers
        Author: ClemensRichterr
        Version: 0.85
        DateCreated: 2022-July-31
    
    
    .EXAMPLE
        Install-WindowsUpdatesOnServers
    #>
    
    [CmdletBinding()]
    
    param(
        
    )
    BEGIN {
        $ScriptIsRunningAsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if ($ScriptIsRunningAsAdmin -eq $false) {
            throw 'Please execute the script with admin rights!'
        }

        if (-not(Test-Path -Path "Install-WindowsUpdatesOnServer.ini")) {
            throw 'Install-WindowsUpdatesOnServer.ini is missing!'
        }
        if (-not(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
        } 
    }
    
    PROCESS {
        $Parameters = Get-Content 'Install-WindowsUpdatesOnServer.ini' | ConvertFrom-StringData
        $TriggerDate = [Datetime]::Parse($Parameters.TriggerDate)
        $TriggerDate.ToLongDateString()
        $TriggerDate.ToLongTimeString()
        $CurrentDate = Get-Date -Format "MMddyyyy"
        $LogFile = $Parameters.LogFileLocation + "\UpdateTaskLog_" + $env:computername + "_" + $CurrentDate + ".txt"
        Import-Module PSWindowsUpdate
        $Script = "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; ipmo PSWindowsUpdate; Install-WindowsUpdate -AcceptAll -AutoReboot | Out-File " + "'" + $LogFile + "'"
        Invoke-WUJob -ComputerName $env:computername -Script $Script -TriggerDate $TriggerDate -Confirm:$false -Verbose
    }
    
    END {}
}
#RUN 
Install-WindowsUpdatesOnServers