param (
   [string] $coreVersion = "../packages/extension/core",
   [string] $m4Version = "../packages/extension/modelerfour"
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


foreach ($input in Get-Content (Join-Path $PSScriptRoot "smoke-tests.yaml"))
{
    if ($input -match "^(?<readme>[^#].*?specification/(?<name>[\w-]+(/[\w-]+)+)/readme.md)(:(?<args>.*))?")
    {
        $readme = $Matches["readme"]

        Write-Host "Testing spec: $readme"
        Exec { autorest --version=$coreVersion --use:$m4Version }
    }
}
