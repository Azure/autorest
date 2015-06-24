$tests = 
@{
    "SwaggerBat\BodyBoolean"="..\..\AcceptanceTests\swagger\body-boolean.json";
    "SwaggerBat\BodyInteger"="..\..\AcceptanceTests\swagger\body-integer.json";
    "SwaggerBat\BodyNumber"="..\..\AcceptanceTests\swagger\body-number.json";
    "SwaggerBat\BodyString"="..\..\AcceptanceTests\swagger\body-string.json";
    "SwaggerBat\BodyByte"="..\..\AcceptanceTests\swagger\body-byte.json";
    "SwaggerBat\BodyArray"="..\..\AcceptanceTests\swagger\body-array.json";
    "SwaggerBat\BodyDictionary"="..\..\AcceptanceTests\swagger\body-dictionary.json";
    "SwaggerBat\BodyDate"="..\..\AcceptanceTests\swagger\body-date.json";
    "SwaggerBat\BodyDateTime"="..\..\AcceptanceTests\swagger\body-datetime.json";
    "SwaggerBat\BodyComplex"="..\..\AcceptanceTests\swagger\body-complex.json";
    "SwaggerBat\Url"="..\..\AcceptanceTests\swagger\url.json";
    "SwaggerBat\Header"="..\..\AcceptanceTests\swagger\header.json";
    "SwaggerBat\Http"="..\..\AcceptanceTests\swagger\httpInfrastructure.json";
    "SwaggerBat\RequiredOptional"="..\..\AcceptanceTests\swagger\required-optional.json";
    "SwaggerBat\Report"="..\..\AcceptanceTests\swagger\report.json";
}

Import-Module "$PSScriptRoot\..\..\..\..\binaries\Net45\AutoRest.Core.dll"

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
    #&"$PSScriptRoot\..\..\..\..\binaries\Net45\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}