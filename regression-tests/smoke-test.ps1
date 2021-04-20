param (
   [string] $coreVersion = "",
   [string] $m4Version = ""
)

$ErrorActionPreference = "Stop"


function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ("Error executing command {0}" -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

if($coreVersion -eq "") {
    $coreVersion = Resolve-Path "$PSScriptRoot/../packages/extensions/core"
}

if($m4Version -eq "") {
    $m4Version = Resolve-Path "$PSScriptRoot/../packages/extensions/modelerfour"
}

Write-Host "Using Core $coreVersion"
Write-Host "Using M4 $m4Version"
foreach ($input in Get-Content (Join-Path $PSScriptRoot "smoke-tests.yaml"))
{
    if ($input -match "^(?<readme>[^#].*?specification/(?<name>[\w-]+(/[\w-]+)+)/readme.md)(:(?<args>.*))?")
    {
        $readme = $Matches["readme"]

        Write-Host "Testing spec: $readme"
        Exec { autorest --version=$coreVersion --use:$m4Version }
    }
}
