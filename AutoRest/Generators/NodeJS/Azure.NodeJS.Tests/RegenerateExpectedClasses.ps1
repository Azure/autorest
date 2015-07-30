$tests = 
@{
    "AcceptanceTests\Lro"="..\..\AcceptanceTests\swagger\lro.json";
    "AcceptanceTests\Paging"="..\..\AcceptanceTests\swagger\paging.json";
    "AcceptanceTests\ResourceFlattening"="..\..\AcceptanceTests\swagger\resource-flattening.json";
    "AcceptanceTests\Head"="..\..\AcceptanceTests\swagger\head.json";
    "AcceptanceTests\AzureReport"="..\..\AcceptanceTests\swagger\azure-report.json";
    "AcceptanceTests\SubscriptionIdApiVersion"="..\..\AcceptanceTests\swagger\subscriptionId-apiVersion.json";
    "AcceptanceTests\AzureSpecials"="..\..\AcceptanceTests\swagger\azure-special-properties.json";
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
    if (Test-Path "$($settings.OutputDirectory)") 
    {
        Remove-Item "$($settings.OutputDirectory)" -Recurse -Force
    }
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}