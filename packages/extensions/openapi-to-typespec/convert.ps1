<#
  .SYNOPSIS
  Convert ARM swagger to TypeSpec.

  .DESCRIPTION
  This script will help to call csharp codegen and converter codegen to convert an ARM specific swagger into TypeSpec.

  .EXAMPLE
  pwsh convert.ps1 https://github.com/Azure/azure-rest-api-specs/blob/main/specification/sphere/resource-manager/readme.md
#>

param(
    [Parameter(Mandatory = $true, HelpMessage = "Specifies the swagger config file (not the swagger json, but the readme config) or autorest.md file in the azure-sdk-for-net repo if .net related configuration is expected to be included.")]
    [string] 
    $swaggerConfigFile,
    [Parameter(Mandatory = $false, HelpMessage = "Specified the output folder, deafult to current folder.")]
    [string]
    $outputFolder,
    [Parameter(Mandatory = $false, HelpMessage = "Specified the csharp codegen, default to https://aka.ms/azsdk/openapi-to-typespec-csharp.")]
    [string]
    $csharpCodegen = "https://aka.ms/azsdk/openapi-to-typespec-csharp",
    [Parameter(Mandatory = $false, HelpMessage = "Specified the converter codegen, default to https://aka.ms/azsdk/openapi-to-typespec.")]
    [string]
    $converterCodegen = ".")

function GenerateMetadata ()
{
    Write-Host "##Generating metadata with csharp codegen in $outputFolder with $csharpCodegen"
    $cmd = "autorest --version=3.10.1 --csharp --isAzureSpec --isArm --max-memory-size=8192 --use=`"$csharpCodegen`" --output-folder=$outputFolder --mgmt-debug.only-generate-metadata --azure-arm --skip-csproj $swaggerConfigFile"
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
    $cmd = "autorest --version=3.10.1 --openapi-to-typespec --csharp=false --isAzureSpec --isArm --use=`"$converterCodegen`" --output-folder=$outputFolder $swaggerConfigFile"
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
