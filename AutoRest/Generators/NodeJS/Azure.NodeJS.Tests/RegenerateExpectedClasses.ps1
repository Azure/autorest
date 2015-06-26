$tests = 
@{
    "SwaggerBat\Lro"="..\..\AcceptanceTests\swagger\lro.json";
    "SwaggerBat\Paging"="..\..\AcceptanceTests\swagger\paging.json";
    "SwaggerBat\ResourceFlattening"="..\..\AcceptanceTests\swagger\resource-flattening.json";
    "SwaggerBat\Head"="..\..\AcceptanceTests\swagger\head.json";
    "SwaggerBat\Report"="..\..\AcceptanceTests\swagger\azure-report.json";
    "SwaggerBat\SubscriptionIdApiVersion"="..\..\AcceptanceTests\swagger\subscriptionId-apiVersion.json";
}

Import-Module "$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.CodeGenerator = "Azure.NodeJS";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\..\Azure.CSharp.Tests\$($test.Value)"
    $settings.Header = "NONE"
    Remove-Item "$($settings.OutputDirectory)" -Recurse -Force
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}