function Install-CleartypeStartupFix {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [switch]$Overwrite
    )
    $regfile = Resolve-Path -Path "~\Documents\cleartype.reg"
    $startupfile = Resolve-Path -Path "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\cleartype.cmd"
    $regpath = "HKCU\Software\Microsoft\Avalon.Graphics"
    if ($Overwrite -or !(Test-Path $Regfile)) {
        $ShouldExport = $PSCmdlet.ShouldProcess($regpath, "Export")
        $ShouldWrite = $PSCmdlet.ShouldProcess($regfile, "Write")
        if ($ShouldExport -and $ShouldWrite) {
            Invoke-Expression "reg export $regpath $regfile /y" | Out-Null
        }
    }
    if ($Overwrite -or !(Test-Path $startupfile)) {
        $cmdcontents = "@echo off`nreg import $regfile`n"
        if ($PSCmdlet.ShouldProcess($startupfile, "Write '$cmdcontents'")) {
            $cmdcontents | Out-File $startupfile -Force
        }
    }
}