class NetworkInterfaceIPInfo {
    [string]$Name
    [string]$Description
    [string[]]$IPAddresses
    NetworkInterfaceIPInfo([string]$Name, [string]$Description, [string[]]$IPAddresses) {
        $this.Name = $Name
        $this.Description = $Description
        $this.IPAddresses = $IPAddresses
    }
}