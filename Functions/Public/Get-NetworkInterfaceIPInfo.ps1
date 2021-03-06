function Get-NetworkInterfaceIPInfo {
    [CmdletBinding()]
    [OutputType([NetworkInterfaceIPInfo])]
    Param()
    Get-NetAdapter | ForEach-Object {
        [NetworkInterfaceIPInfo]::new($_.Name, $_.InterfaceDescription, (Get-NetIPAddress -InterfaceIndex $_.ifindex -ErrorAction SilentlyContinue | Select-Object -ExpandProperty IPAddress))
    } | Where-Object IPAddresses -ne $null
}