
$tests = 
@{
    "PetstoreV2.Cs"="Swagger\swagger.2.0.example.v2.json";
    "Mirror.RecursiveTypes.Cs"="Swagger\swagger-mirror-recursive-type.json";
    "Mirror.Primitives.Cs"="Swagger\swagger-mirror-primitives.json";
    "Mirror.Sequences.Cs"="Swagger\swagger-mirror-sequences.json";
    "Mirror.Polymorphic.Cs"="Swagger\swagger-mirror-polymorphic.json";
    "SwaggerBat\BodyBoolean.Cs"="..\..\AcceptanceTests\swagger\body-boolean.json";
    "SwaggerBat\BodyInteger.Cs"="..\..\AcceptanceTests\swagger\body-integer.json";
    "SwaggerBat\BodyNumber.Cs"="..\..\AcceptanceTests\swagger\body-number.json";
    "SwaggerBat\BodyString.Cs"="..\..\AcceptanceTests\swagger\body-string.json";
    "SwaggerBat\BodyByte.Cs"="..\..\AcceptanceTests\swagger\body-byte.json";
    "SwaggerBat\BodyArray.Cs"="..\..\AcceptanceTests\swagger\body-array.json";
    "SwaggerBat\BodyDictionary.Cs"="..\..\AcceptanceTests\swagger\body-dictionary.json";
    "SwaggerBat\BodyDate.Cs"="..\..\AcceptanceTests\swagger\body-date.json";
    "SwaggerBat\BodyDateTime.Cs"="..\..\AcceptanceTests\swagger\body-datetime.json";
    "SwaggerBat\BodyComplex.Cs"="..\..\AcceptanceTests\swagger\body-complex.json";
    "SwaggerBat\Url.Cs"="..\..\AcceptanceTests\swagger\url.json";
    "SwaggerBat\Header.Cs"="..\..\AcceptanceTests\swagger\header.json";
    "SwaggerBat\Http.Cs"="..\..\AcceptanceTests\swagger\httpInfrastructure.json";
    "SwaggerBat\RequiredOptional.Cs"="..\..\AcceptanceTests\swagger\required-optional.json";
    "SwaggerBat\Report.Cs"="..\..\AcceptanceTests\swagger\report.json";
}

# TODO: direct reference to AutoRest .Net objects and methods leaves handles to the binaries open. Invoke the command line instead.
Import-Module "$PSScriptRoot\..\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.Namespace = "Fixtures." + $test.Key.Replace(".Cs","").Replace(".","").Replace("\","").Replace("-","")
    $settings.CodeGenerator = "CSharp";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\$($test.Value)"
    $settings.Header = "NONE"
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}