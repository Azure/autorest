$tests = 
@{
    "SwaggerBat\Lro.Cs"="..\..\AcceptanceTests\swagger\lro.json";
    "SwaggerBat\Paging.Cs"="..\..\AcceptanceTests\swagger\paging.json";
    "SwaggerBat\Report.Cs"="..\..\AcceptanceTests\swagger\azure-report.json";
    "SwaggerBat\ResourceFlattening.Cs"="..\..\AcceptanceTests\swagger\resource-flattening.json";
    "SwaggerBat\Head.Cs"="..\..\AcceptanceTests\swagger\head.json";
}

# TODO: direct reference to AutoRest .Net objects and methods leaves handles to the binaries open. Invoke the command line instead.
Import-Module "$PSScriptRoot\..\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.Namespace = "Fixtures.Azure." + $test.Key.Replace(".Cs","").Replace(".","").Replace("\","").Replace("-","")
    $settings.CodeGenerator = "Azure.CSharp";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\$($test.Value)"
    $settings.Header = "NONE"
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}

