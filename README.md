# SNMP Printer Management Script

This PowerShell script is designed to retrieve SNMP data from networked printers, compile the tonerlevel, and export this data into a CSV file. It supports a variety of printer models and can be easily extended to include more devices.

## Prerequisites

- **Windows Environment**: This script is designed for Windows and requires PowerShell 5.1 or newer.
- **SNMP Service**: Ensure SNMP services are enabled and accessible on the printers and the machine running the script.
- **PowerShell SNMP Module**: This script uses the PowerShell SNMP module. You must have this module installed, which can be done via PowerShellGet or manually if not available by default.

## Usage

1. **Download the Script**: Clone or download the script files to your local machine or network accessible to the printers.
2. **Configure SNMP on Printers**: Ensure that SNMP is enabled on each printer you wish to monitor and that you have the correct community string.
3. **Edit the Script**: Update the `$devices` array with the printers' details (see the section on adding new printers).
4. **Run the Script**: Open PowerShell, navigate to the directory containing the script, and run it using the command:
   ```powersershell
   .\PrinterSNMPManagement.ps1

## Troubleshooting

   - **Script Fails to Run:** Check PowerShell execution policies allow script execution (Set-ExecutionPolicy may be needed).
   - **No Data Collected:** Verify network connectivity to the printer and correctness of the SNMP OIDs.
   -**Incorrect Output:** Double-check SNMP community strings and IP addresses.
     
## Add a Printer

   - **1:** Copy one of the arrayparts the first is for **COLORPRINTERS** the second for **BLACKANDWHITEPRINTERS** (its depending from the model of the Printer)and the third one is for **COLORPRINTERS without SCANNERS**.
     
      ```powersershell
      #1
      @{ Name = "Name of the Printer"; IPAddress = "IP Address"; ColorPrinter = $true; OIDBlack = @("1.3.6.1.2.1.43.11.1.1.9.1.1"); OIDColor = @("1.3.6.1.2.1.43.11.1.1.9.1.2", "1.3.6.1.2.1.43.11.1.1.9.1.3", "1.3.6.1.2.1.43.11.1.1.9.1.4")},
      #2
      @{ Name = "Name of the Printer"; IPAddress = "IP Address"; ColorPrinter = $false ; OIDBlack = "1.3.6.1.2.1.43.11.1.1.9.1.1"},
      @{ Name = "Name of the Printer"; IPAddress = "IP Address"; ColorPrinter = $false ; OIDBlack = "1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.1"},
      #3
      @{ Name = "Name of the Printer"; IPAddress = "IP Address"; ColorPrinter = $true; OIDBlack = @("1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.1"); OIDColor = @("1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.2", "1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.3", "1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.4")}
   - **2:** Put the arraypart into your script and let it run.

## Own modifikation

   - **Changes:** You can make changes to the Script as you want.
   - **Get OIDs:** With the following Command you can get a range of OIDs with their values pick the ones you need and integrate them into the script.
     ```powershell
     Invoke-SnmpWalk -IP IP-Address -Community public -OIDStart 1.3.6.1.4.1.18334.1.1.1.5.7.2 //For others you need to change the OID Start like 1.3.6.1.4.1.18334.1.1.1

## Support
For additional help or to report issues, please open an issue on the project repository or contact your network administrator.
