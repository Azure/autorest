param(
    [Parameter(Mandatory)]
    [string]$swaggerConfigFile,
    [string]$outputFolder,
    [string]$csharpCodegen = "https://pkgs.dev.azure.com/azure-sdk/public/_packaging/azure-sdk-for-js-test-autorest/npm/registry/@autorest/csharp/-/csharp-3.0.0-alpha.20231017.8.tgz",
    [string]$converterCodegen = "https://artprodcus3.artifacts.visualstudio.com/A0fb41ef4-5012-48a9-bf39-4ee3de03ee35/29ec6040-b234-4e31-b139-33dc4287b756/_apis/artifact/cGlwZWxpbmVhcnRpZmFjdDovL2F6dXJlLXNkay9wcm9qZWN0SWQvMjllYzYwNDAtYjIzNC00ZTMxLWIxMzktMzNkYzQyODdiNzU2L2J1aWxkSWQvMzE5ODY3OC9hcnRpZmFjdE5hbWUvcGFja2FnZXM1/content?format=file&subPath=%2Fautorest-openapi-to-cadl-0.6.0-ci.83cedcacb.tgz"
)

function GenerateMetadata ()
{
    Write-Host "##Generating metadata with csharp codegen in $outputFolder with $csharpCodegen"
    $cmd = "autorest --csharp --max-memory-size=8192 --use=`"$csharpCodegen`" --output-folder=$outputFolder --mgmt-debug.only-generate-metadata --azure-arm --skip-csproj $swaggerConfigFile"
    Write-Host "$cmd"
    Invoke-Expression  $cmd
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
    if (Test-Path (Join-Path $outputFolder resources.json))
    {
        Remove-Item (Join-Path $outputFolder resources.json)
    }
    Rename-Item (Join-Path $outputFolder metadata.json) (Join-Path $outputFolder resources.json)
}

function DoConvert ()
{
    Write-Host "##Converting from swagger to tsp with in $outputFolder with $converterCodegen"
    $cmd = "autorest --openapi-to-cadl --isArm --use=`"$converterCodegen`" --output-folder=$outputFolder --src-path=tsp-output $swaggerConfigFile"
    Write-Host "$cmd"
    Invoke-Expression  $cmd
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}

if ([string]::IsNullOrEmpty($outputFolder))
{
    $outputFolder = Get-Location
}
else
{
    $outputFolder = (Resolve-Path $outputFolder) -replace "(\\|\/)$"
}
Write-Host "##output folder is $outputFolder"

if ([string]::IsNullOrEmpty($converterCodegen))
{
    $converterCodegen = $PSScriptRoot
}

GenerateMetadata
DoConvert
