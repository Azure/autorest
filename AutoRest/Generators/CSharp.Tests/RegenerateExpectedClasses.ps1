
$tests = 
@{
    "Mirror.RecursiveTypes.Cs"="Swagger\swagger-recursive-type.json";
    "Mirror.Primitives.Cs"="Swagger\Mirror\swagger-mirror-primitives.json";
    "Mirror.Sequences.Cs"="Swagger\Mirror\swagger-mirror-sequences.json";
    "Mirror.Polymorphic.Cs"="Swagger\Mirror\swagger-mirror-polymorphic.json";
    "SwaggerBat\BodyBoolean.Cs"="Swagger\SwaggerBat\body-boolean.json";
    "SwaggerBat\BodyInteger.Cs"="Swagger\SwaggerBat\body-integer.json";
    "SwaggerBat\BodyNumber.Cs"="Swagger\SwaggerBat\body-number.json";
    "SwaggerBat\BodyString.Cs"="Swagger\SwaggerBat\body-string.json";
    "SwaggerBat\BodyByte.Cs"="Swagger\SwaggerBat\body-byte.json";
    "SwaggerBat\BodyArray.Cs"="Swagger\SwaggerBat\body-array.json";
    "SwaggerBat\BodyDictionary.Cs"="Swagger\SwaggerBat\body-dictionary.json";
    "SwaggerBat\BodyDate.Cs"="Swagger\SwaggerBat\body-date.json";
    "SwaggerBat\BodyDateTime.Cs"="Swagger\SwaggerBat\body-datetime.json";
    "SwaggerBat\BodyComplex.Cs"="Swagger\SwaggerBat\body-complex.json";
    "SwaggerBat\Url.Cs"="Swagger\SwaggerBat\url.json";
    "SwaggerBat\Header.Cs"="Swagger\SwaggerBat\header.json";
    "SwaggerBat\Http.Cs"="Swagger\SwaggerBat\httpInfrastructure.json";
    "SwaggerBat\RequiredOptional.Cs"="Swagger\SwaggerBat\required-optional.json";
    "SwaggerBat\Report.Cs"="Swagger\SwaggerBat\report.json";
    "PetstoreV2.Cs"="Swagger\swagger.2.0.example.v2.json";
}

# TODO: direct reference to AutoRest .Net objects and methods leaves handles to the binaries open. Invoke the command line instead.
Import-Module "$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.Core.dll"

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
    #&"$PSScriptRoot\..\..\..\binaries\Net45-Debug\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}