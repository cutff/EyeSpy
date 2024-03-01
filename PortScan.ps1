# Define ports to scan
$ports = @(554, 8554)

# Function to scan IP range for open ports
function Scan-IPRange {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Target
    )

    $ErrorActionPreference = "Stop"

    # Define Test_Port script block
    $Test_Port = {
        param($IPAddress, $Port)

        Write-Host "Scanning port $Port on $IPAddress"

        try {
            $socket = New-Object System.Net.Sockets.TcpClient
            $async = $socket.BeginConnect($IPAddress, $Port, $null, $null)
            $result = $async.AsyncWaitHandle.WaitOne(100)  # Timeout set to 100 milliseconds

            if ($socket.Connected) {
                $socket.EndConnect($async) | Out-Null
                $socket.Close()
                return $true
            } else {
                return $false
            }
        } catch {
            Write-Host "Failed to connect to port $Port on $IPAddress`: $_"
            return $false
        }
    }

    # Resolve IP addresses from CIDR range if necessary
    $IPAddress = $null
    if ($Target -match '^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}/\b([8-9]|[1-2][0-9]|3[0-2])\b$') {

        $IPRange = New-IPv4RangeFromCIDR -Target $Target

    } elseif ($Target -match '^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$') {
        $IPAddress = $Target
        $IPRange = @($Target)
    } else {
        Write-Host -ForegroundColor red "Invalid IP address format: " -NoNewline
        Write-Host "$Target`n`rCheck the format, IP ranges, and CIDR range (Not bigger than /8)."
        return
    }

    # Asynchronously scan IP addresses and ports
    $jobs = @()
    foreach ($IP in $IPRange) {
        foreach ($port in $ports) {
            $jobs += Start-Job -ScriptBlock $Test_Port -ArgumentList $IP, $port
        }
    }

    # Wait for all jobs to finish
    $jobs | Wait-Job | Receive-Job

    # Cleanup jobs
    $jobs | Remove-Job
}

# Function to generate IPv4 IP addresses given a CIDR
function New-IPv4RangeFromCIDR {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Target

    )

    $network, $cidrBits = $Target -split '/'
    Write-Host $network
    Write-Host $cidrBits
    $NumberOfIPs = -bnot (-bnot 0 -shl (32 - $cidrBits))
    Write-Host $NumberOfIPs

    $ip = [System.Net.IPAddress]::Parse($network).GetAddressBytes()
    Write-Host $ip
    
    [Array]::Reverse($ip)

    $ip = ([System.Net.IPAddress]($ip -join ".")).Address
    $StartIP = $ip + 1
    $EndIP = $ip + ($NumberOfIPs - 1)

    # We make sure they are of type Double before conversion
    If ($EndIP -isnot [double]) {
        $EndIP = $EndIP -as [double]
    }
    If ($StartIP -isnot [double]) {
        $StartIP = $StartIP -as [double]
    }
    # We turn the start IP and end IP in to strings so they can be used.
    $StartIP = ([System.Net.IPAddress]$StartIP).IPAddressToString
    $EndIP = ([System.Net.IPAddress]$EndIP).IPAddressToString

    #New-IPv4Range $StartIP $EndIP
    Write-Host $StartIP $EndIP

}


# Call the function with a target
Scan-IPRange -Target "192.168.0.0/16"
#Scan-IPRange -Target "192.168.0.219"