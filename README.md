# Install-WindowsUpdatesOnServers

## Story

I built this script mainly to simplify my Windows Update workflow on Windows servers. Since you often have the problem that you cannot restart the server during working hours etc

## Usage

 1. Copy the script and the associated ini file to the server on which Windows Updates are to be installed.
 2. Adjust the parameters in the ini file so that they meet your requirements
 2.1 **TriggerDate**: Determines when to start installing the updates
 2.2 **LogFileLocation**: Determines where the log file is stored
 3. Run script

### Hints

- The [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) module does not have to be preinstalled. My script checks if it is available. If it is not available, you will be prompted to install it
- My script installs the Windows Updates with the following [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) parameters (this can be adjusted if necessary, just like the whole script):
  - `-AcceptAll` All available updates will be installed
  - `-AutoReboot` Automatically restarts the server after installing the updates to apply the updates

## Note of Thanks

Thanks for the [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate) module ✌, because without it this script would not have been possible!
