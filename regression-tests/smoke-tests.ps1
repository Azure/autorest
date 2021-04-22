param (
   [string] $coreVersion = "",
   [string] $m4Version = ""
)

$ErrorActionPreference = "Stop"

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
        autorest --version=$coreVersion --use:$m4Version $readme
        if($LastExitCode -ne 0)
        {
            throw "Command failed to execute: $command"
        }
    }
}
