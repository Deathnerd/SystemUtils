function Enable-LUA {
    [CmdletBinding()]
    Param ()
    Process {
        if (-not (Test-Administrator)) {
            throw "This must be run from an elevated prompt"
        }
        Write-Host -ForegroundColor Green "Enabling default behavior"
        Write-Host -ForegroundColor Yellow "WARNING: THIS WILL BREAK DASHBOARD AND PYFT'S ABILITY TO MANIPULATE THE REGISTRY"
        Set-ItemProperty -Path $script:LUARegistryLocation -Name "EnableLUA" -Value "1"
        Set-ItemProperty -Path $script:LUARegistryLocation -Name "ConsentPromptBehaviorAdmin" -Value "2"
        Set-ItemProperty -Path $script:LUARegistryLocation -Name "EnableUIADesktopToggle" -Value "0"
        Write-Host "You should restart to ensure the changes are complete"
    }
}