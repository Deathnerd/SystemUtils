function Get-LUAValue {
    [CmdletBinding()]
    Param ()
    Process {
        if (-not (Test-Administrator)) {
            throw "This must be run from an elevated prompt"
        }
        return Get-ItemProperty -Path $script:LUARegistryLocation -Name "EnableLUA"
    }
}