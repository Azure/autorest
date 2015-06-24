$tests = 
@{
    "SwaggerBat\Lro"="..\..\AcceptanceTests\swagger\lro.json";
    "SwaggerBat\Paging"="..\..\AcceptanceTests\swagger\paging.json";
    "SwaggerBat\ResourceFlattening"="..\..\AcceptanceTests\swagger\resource-flattening.json";
    "SwaggerBat\Head"="..\..\AcceptanceTests\swagger\head.json";
    "SwaggerBat\Report"="..\..\AcceptanceTests\swagger\azure-report.json";
}

Import-Module "$PSScriptRoot\..\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

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
    #&"$PSScriptRoot\..\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}