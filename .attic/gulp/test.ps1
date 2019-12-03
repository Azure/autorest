$ErrorActionPreference = "Stop"
$root = resolve-path $PSScriptRoot/..
. $PSScriptRoot/autorest.ps1

pushd $root/autorest
try { npm test } finally { popd }

pushd $root/core
try { npm test } finally { popd }
