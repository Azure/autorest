$tests = 
@{
    "SwaggerBat\Lro"="Swagger\SwaggerBat\lro.json";
    "SwaggerBat\Paging"="Swagger\SwaggerBat\paging.json";
    "SwaggerBat\ResourceFlattening"="Swagger\SwaggerBat\resource-flattening.json";
    "SwaggerBat\Head"="Swagger\SwaggerBat\head.json";
    "SwaggerBat\Report"="Swagger\SwaggerBat\azure-report.json";
}

Import-Module "$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.CodeGenerator = "Azure.NodeJS";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\..\Azure.CSharp.Tests\$($test.Value)"
    $settings.Header = "NONE"
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}