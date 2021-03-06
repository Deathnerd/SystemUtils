function Get-NetworkStatisticsWithInterfaces {
    [CmdletBinding()]
    Param()
    $NetworkInterfaces = Get-NetworkInterfaceIPInfo
    WFTools\Get-NetworkStatistics | ForEach-Object {
        [pscustomobject]@{
            ComputerName  = $_.ComputerName
            Protocol      = $_.Protocol
            LocalAddress  = $_.LocalAddress
            LocalPort     = $_.LocalPort
            RemoteAddress = $_.RemoteAddress
            RemotePort    = $_.RemotePort
            Interface     = $NetworkInterFaces | Where-Object IPAddresses -contains $_.LocalAddress | Select-Object -First 1 -ExpandProperty Name
            State         = $_.State
            ProcessName   = $_.ProcessName
            PID           = $_.PID
        }
    }
}