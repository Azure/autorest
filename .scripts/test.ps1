$ErrorActionPreference = "Stop"
$root = resolve-path $PSScriptRoot/..
. $PSScriptRoot/autorest.ps1

pushd $root/src/autorest
try { npm test } finally { popd }

pushd $root/src/autorest-core
try { npm test } finally { popd }
