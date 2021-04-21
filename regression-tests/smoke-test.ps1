param (
   [string] $coreVersion = "",
   [string] $m4Version = ""
)

$ErrorActionPreference = "Stop"


function Invoke($command)
{
    Write-Host "> $command"
    pushd $repoRoot
    if ($IsLinux)
    {
        sh -c "$command 2>&1"
    }
    else
    {
        cmd /c "$command 2>&1"
    }
    popd

    if($LastExitCode -ne 0)
    {
        throw "Command failed to execute: $command"
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
        Invoke "autorest --version=$coreVersion --use:$m4Version"
    }
}
