function Test-LUA {
    [CmdletBinding()]
    Param ()
    Process {
        if (-not (Test-Administrator)) {
            throw "This must be run from an elevated prompt"
        }
        return (Get-LUAValue) -eq 0
    }
}