$tests = 
@{
    "SwaggerBat\BodyBoolean"="Swagger\SwaggerBat\body-boolean.json";
    "SwaggerBat\BodyInteger"="Swagger\SwaggerBat\body-integer.json";
    "SwaggerBat\BodyNumber"="Swagger\SwaggerBat\body-number.json";
    "SwaggerBat\BodyString"="Swagger\SwaggerBat\body-string.json";
    "SwaggerBat\BodyByte"="Swagger\SwaggerBat\body-byte.json";
    "SwaggerBat\BodyArray"="Swagger\SwaggerBat\body-array.json";
    "SwaggerBat\BodyDictionary"="Swagger\SwaggerBat\body-dictionary.json";
    "SwaggerBat\BodyDate"="Swagger\SwaggerBat\body-date.json";
    "SwaggerBat\BodyDateTime"="Swagger\SwaggerBat\body-datetime.json";
    "SwaggerBat\BodyComplex"="Swagger\SwaggerBat\body-complex.json";
    "SwaggerBat\Url"="Swagger\SwaggerBat\url.json";
    "SwaggerBat\Header"="Swagger\SwaggerBat\header.json";
    "SwaggerBat\Http"="Swagger\SwaggerBat\httpInfrastructure.json";
    "SwaggerBat\RequiredOptional"="Swagger\SwaggerBat\required-optional.json";
    "SwaggerBat\Report"="Swagger\SwaggerBat\report.json";
}

Import-Module "$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.CodeGenerator = "NodeJS";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\..\CSharp.Tests\$($test.Value)"
    $settings.Header = "NONE"
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}