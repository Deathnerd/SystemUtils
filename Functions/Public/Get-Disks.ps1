function Get-Disks {
    [CmdletBinding()]
    Param()
    return Get-CimInstance Win32_LogicalDisk
}