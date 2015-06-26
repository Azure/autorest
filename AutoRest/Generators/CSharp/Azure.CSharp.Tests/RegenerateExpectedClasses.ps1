$tests = 
@{
    "SwaggerBat\Lro.Cs"="..\..\AcceptanceTests\swagger\lro.json";
    "SwaggerBat\Paging.Cs"="..\..\AcceptanceTests\swagger\paging.json";
    "SwaggerBat\AzureReport.Cs"="..\..\AcceptanceTests\swagger\azure-report.json";
    "SwaggerBat\ResourceFlattening.Cs"="..\..\AcceptanceTests\swagger\resource-flattening.json";
    "SwaggerBat\Head.Cs"="..\..\AcceptanceTests\swagger\head.json";
    "SwaggerBat\SubscriptionIdApiVersion.Cs"="..\..\AcceptanceTests\swagger\subscriptionId-apiVersion.json";
    "SwaggerBat\AzureSpecials.Cs"="..\..\AcceptanceTests\swagger\azure-special-properties.json";
}

# TODO: direct reference to AutoRest .Net objects and methods leaves handles to the binaries open. Invoke the command line instead.
Import-Module "$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.Namespace = "Fixtures.Azure." + $test.Key.Replace(".Cs","").Replace(".","").Replace("\","").Replace("-","")
    $settings.CodeGenerator = "Azure.CSharp";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\$($test.Value)"
    $settings.Header = "NONE"
    if (Test-Path "$($settings.OutputDirectory)") 
    {
        Remove-Item "$($settings.OutputDirectory)" -Recurse -Force
    }
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}

