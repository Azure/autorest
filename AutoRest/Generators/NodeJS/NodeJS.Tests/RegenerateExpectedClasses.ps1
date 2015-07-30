$tests = 
@{
    "AcceptanceTests\BodyBoolean"="..\..\AcceptanceTests\swagger\body-boolean.json";
    "AcceptanceTests\BodyInteger"="..\..\AcceptanceTests\swagger\body-integer.json";
    "AcceptanceTests\BodyNumber"="..\..\AcceptanceTests\swagger\body-number.json";
    "AcceptanceTests\BodyString"="..\..\AcceptanceTests\swagger\body-string.json";
    "AcceptanceTests\BodyByte"="..\..\AcceptanceTests\swagger\body-byte.json";
    "AcceptanceTests\BodyArray"="..\..\AcceptanceTests\swagger\body-array.json";
    "AcceptanceTests\BodyDictionary"="..\..\AcceptanceTests\swagger\body-dictionary.json";
    "AcceptanceTests\BodyDate"="..\..\AcceptanceTests\swagger\body-date.json";
    "AcceptanceTests\BodyDateTime"="..\..\AcceptanceTests\swagger\body-datetime.json";
    "AcceptanceTests\BodyComplex"="..\..\AcceptanceTests\swagger\body-complex.json";
    "AcceptanceTests\BodyFile"="..\..\AcceptanceTests\swagger\body-file.json";
    "AcceptanceTests\Url"="..\..\AcceptanceTests\swagger\url.json";
    "AcceptanceTests\Header"="..\..\AcceptanceTests\swagger\header.json";
    "AcceptanceTests\Http"="..\..\AcceptanceTests\swagger\httpInfrastructure.json";
    "AcceptanceTests\RequiredOptional"="..\..\AcceptanceTests\swagger\required-optional.json";
    "AcceptanceTests\Report"="..\..\AcceptanceTests\swagger\report.json";
}

Import-Module "$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.CodeGenerator = "NodeJS";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\Expected\$($test.Key)"
    $settings.Input = "$PSScriptRoot\..\CSharp.Tests\$($test.Value)"
    $settings.Header = "NONE"
    if (Test-Path "$($settings.OutputDirectory)") 
    {
        Remove-Item "$($settings.OutputDirectory)" -Recurse -Force
    }
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
    #&"$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.exe" -Modeler Swagger -CodeGenerator $flavor -OutputDirectory "$PSScriptRoot\Expected" -Namespace "$namespace" -Input "$PSScriptRoot\$($test.Value)" -Header NONE
}