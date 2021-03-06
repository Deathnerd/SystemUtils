function Disable-LUA {
    [CmdletBinding()]
    Param ()
    Process {
        if (-not (Test-Administrator)) {
            throw "This must be run from an elevated prompt"
        }
        Write-Host -ForegroundColor Green "Enabling non-default behavior"
        Write-Host -ForegroundColor Yellow "WARNING: THIS WILL STOP PROGRAMS SUCH AS CAMERA, PHOTOS, EDGE, AND OTHERS FROM STARTING"
        Set-ItemProperty -Path $script:LUARegistryLocation -Name "EnableLUA" -Value "0"
        Set-ItemProperty -Path $script:LUARegistryLocation -Name "ConsentPromptBehaviorAdmin" -Value "0"
        Set-ItemProperty -Path $script:LUARegistryLocation -Name "EnableUIADesktopToggle" -Value "1"
        Write-Host "You should restart to ensure the changes are complete"
    }
}