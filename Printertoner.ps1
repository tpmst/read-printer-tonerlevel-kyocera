Import-Module SNMP


# Define your devices with name and IP address
$devices = @(
    @{ Name = "Color Printer"; IPAddress = "IP-Address"; ColorPrinter = $true; OIDBlack = @("1.3.6.1.2.1.43.11.1.1.9.1.1"); OIDColor = @("1.3.6.1.2.1.43.11.1.1.9.1.2", "1.3.6.1.2.1.43.11.1.1.9.1.3", "1.3.6.1.2.1.43.11.1.1.9.1.4")},
    @{ Name = "Black and White (newer Version)"; IPAddress = "IP-Address"; ColorPrinter = $false; OIDBlack = "1.3.6.1.2.1.43.11.1.1.9.1.1" },
    @{ Name = "Black and White"; IPAddress = "IP-Address"; ColorPrinter = $false; OIDBlack = "1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.1"},
    @{ Name = "Color without a scanner"; IPAddress = "IP-Address"; ColorPrinter = $true; OIDBlack = @("1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.1"); OIDColor = @("1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.2", "1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.3", "1.3.6.1.4.1.18334.1.1.1.5.7.4.4.1.3.4")}
)



#Invoke-SnmpWalk -IP 192.173.253.66 -Community public -OIDStart 1.3.6.1.4.1.18334.1.1.1.5.7.2

function Get-TonerLevels {
    param(
        [string]$Name,
        [string]$IPAddress,
        [bool]$ColorPrinter,
        [string[]]$OIDBlack,
        [string[]]$OIDColor
    )
    $pingResult = Test-Connection -ComputerName $IPAddress -Count 1 -Quiet
    $blackToner = $cyanToner = $magentaToner = $yellowToner = "N/A"

    if ($pingResult) {
        try {
            # Black Toner Level
            if ($OIDBlack.Count -gt 0) {
                $blackToner = (Get-SNMPData -IP $IPAddress -Community public -OID $OIDBlack[0]).Data
            }

            # Color Toner Levels
            if ($ColorPrinter) {
                if ($OIDColor.Count -ge 3) {
                    $cyanToner = (Get-SNMPData -IP $IPAddress -Community public -OID $OIDColor[0]).Data
                    $magentaToner = (Get-SNMPData -IP $IPAddress -Community public -OID $OIDColor[1]).Data
                    $yellowToner = (Get-SNMPData -IP $IPAddress -Community public -OID $OIDColor[2]).Data
                }
            }

            # Output results for each printer
            [PSCustomObject]@{
                Name = $Name
                IP = $IPAddress
                BlackToner = $blackToner
                CyanToner = $cyanToner
                MagentaToner = $magentaToner
                YellowToner = $yellowToner
            }
        } catch {
            Write-Error "Failed to retrieve SNMP data for $Name at $IPAddress"
        }
    } else {
        # Output results if offline
        [PSCustomObject]@{
            Name = $Name
            IP = $IPAddress
            BlackToner = "-"
            CyanToner = "-"
            MagentaToner = "-"
            YellowToner = "-"
        }
    }
} 

# Array to collect output
$output = @()

# Loop through each device and retrieve SNMP data
foreach ($device in $devices) {
    $output += Get-TonerLevels -Name $device.Name -IPAddress $device.IPAddress -ColorPrinter $device.ColorPrinter -OIDBlack $device.OIDBlack -OIDColor $device.OIDColor
}

# Display the collected output
$output | Format-Table -AutoSize

$Date = Get-Date -Format "yyyy-MM"
$Path = 'C:\temp\PrinterTonerLevels_' + $Date + '.csv'
# Export the output to a CSV file with specified headers
$output | Export-Csv -Path $Path -NoTypeInformation