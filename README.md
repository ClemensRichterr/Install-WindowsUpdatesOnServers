# Install-WindowsUpdatesOnServers

## Story

I built this script mainly to simplify my Windows Update workflow on Windows servers. Since you often have the problem that you cannot restart the server during working hours etc.

## Usage

 0. Read LICENSE
 1. Download the script. And the backup of the GPO (To deploy a task to all Servers), if you need
 2. Adjust the parameters in the script (line 1 to 6) so that they meet your requirements

    - $CurrentDate = Get-Date -Format "MMddyyyy"
    - $PSWindowsUpdateModuleNetworkLocaiton = ""
    - $LogFile =  ""
    - $ServersThatAreRebootingAt1AM = "ExchangeServer","DC"
    - $ServersThatAreRebootingAt2AM = "CA","DC2"
    - $ServersThatAreRebootingAt3AM = "WSUS"

 3. (Deploy the script via GPO after adjusting the task parameters of the GPO.)

### Hints

- The [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) module does not have to be preinstalled. My script checks if it is available. If it is not available, you will be prompted to install it
- My script installs the Windows Updates with the following [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) parameters (this can be adjusted if necessary, just like the whole script):
  - `-AcceptAll` All available updates will be installed

## Note of Thanks

Thanks for the [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) module ✌, because without it this script would not have been possible!
