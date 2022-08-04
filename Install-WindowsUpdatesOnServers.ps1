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
        Install-WindowsUpdatesOnServers -TriggerDate 19:40
    #>
    
    [CmdletBinding()]
    
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [DateTime]$TriggerDate
    )
    BEGIN {
        $ScriptIsRunningAsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if ($ScriptIsRunningAsAdmin -eq $false) {
            throw 'Please execute the script with admin rights!'
        }
        if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
            #Nothing to do :D
        } 
        else {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
        }
    }
    
    PROCESS {
        $TriggerDate.ToLongDateString()
        $TriggerDate.ToLongTimeString()
        Import-Module PSWindowsUpdate
        Invoke-WUJob -Script { Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Import-Module PSWindowsUpdate; Install-WindowsUpdate -AcceptAll -AutoReboot  | Out-File C:\Users\cleme\Desktop\asdf.log } -TriggerDate $TriggerDate -Confirm:$false -Verbose
    }
    
    END {}
}
#RUN 
Install-WindowsUpdatesOnServers