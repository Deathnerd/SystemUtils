using namespace System.Net

$script:LUARegistryLocation = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
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

function Get-NetworkInterfaceIPInfo {
    [CmdletBinding()]
    [OutputType([NetworkInterfaceIPInfo])]
    Param()
    Get-NetAdapter | ForEach-Object { 
        [NetworkInterfaceIPInfo]::new($_.Name, $_.InterfaceDescription, (Get-NetIPAddress -InterfaceIndex $_.ifindex -ErrorAction SilentlyContinue | Select-Object -ExpandProperty IPAddress))
    } | Where-Object IPAddresses -ne $null
}
function Get-Disks {
    return Get-CimInstance Win32_LogicalDisk
}

function Install-CleartypeStartupFix {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [switch]$Overwrite
    )
    function local:joinpaths([string[]]$Paths) {$Paths | ForEach-Object {$Path = ""} {if ($Path -eq "") {$Path = $_} else {$Path = Join-Path $Path $_}} {$Path}}
    $regfile = joinpaths $home, "Documents", "cleartype.reg"
    $startupfile = joinpaths $Home, "AppData", "Roaming", "Microsoft", "Windows", "Start Menu", "Programs", "Startup", "cleartype.cmd"
    $regpath = "HKCU\Software\Microsoft\Avalon.Graphics"
    if($Overwrite -or !(Test-Path $Regfile)) {
        $ShouldExport = $PSCmdlet.ShouldProcess($regpath, "Export")
        $ShouldWrite = $PSCmdlet.ShouldProcess($regfile, "Write")
        if($ShouldExport -and $ShouldWrite) {
            Invoke-Expression "reg export $regpath $regfile /y" | Out-Null
        }
    }
    if($Overwrite -or !(Test-Path $startupfile)) {
        $cmdcontents = "@echo off`nreg import $regfile`n"
        if($PSCmdlet.ShouldProcess($startupfile, "Write '$cmdcontents'")) {
            $cmdcontents | Out-File $startupfile -Force
        }
    }
}

Export-ModuleMember -Function *-*