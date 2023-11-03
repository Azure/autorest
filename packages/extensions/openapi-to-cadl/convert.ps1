param(
    [Parameter(Mandatory)]
    [string]$swaggerConfigFile,
    [string]$outputFolder,
    [string]$csharpCodegen = "https://aka.ms/azsdk/openapi-to-typespec-csharp",
    [string]$converterCodegen = "https://aka.ms/azsdk/openapi-to-typespec"
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
