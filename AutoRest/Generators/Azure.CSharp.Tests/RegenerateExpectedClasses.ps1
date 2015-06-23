$tests = 
@{
    "SwaggerBat\Lro.Cs"="Swagger\SwaggerBat\lro.json";
    "SwaggerBat\Paging.Cs"="Swagger\SwaggerBat\paging.json";
    "SwaggerBat\Report.Cs"="Swagger\SwaggerBat\azure-report.json";
    "SwaggerBat\ResourceFlattening.Cs"="Swagger\SwaggerBat\resource-flattening.json";
    "SwaggerBat\Head.Cs"="Swagger\SwaggerBat\head.json";
}

# TODO: direct reference to AutoRest .Net objects and methods leaves handles to the binaries open. Invoke the command line instead.
Import-Module "$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

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
    #&"$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}

