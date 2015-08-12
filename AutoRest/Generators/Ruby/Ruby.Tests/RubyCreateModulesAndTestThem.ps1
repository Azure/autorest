
$tests = 
@{
    "boolean"="..\..\AcceptanceTests\swagger\body-boolean.json";
    "integer"="..\..\AcceptanceTests\swagger\body-integer.json";
    "number"="..\..\AcceptanceTests\swagger\body-number.json";
    "string"="..\..\AcceptanceTests\swagger\body-string.json";
    "byte"="..\..\AcceptanceTests\swagger\body-byte.json";
    "array"="..\..\AcceptanceTests\swagger\body-array.json";
    "dictionary"="..\..\AcceptanceTests\swagger\body-dictionary.json";
    "date"="..\..\AcceptanceTests\swagger\body-date.json";
    "datetime"="..\..\AcceptanceTests\swagger\body-datetime.json";
    "complex"="..\..\AcceptanceTests\swagger\body-complex.json";
    "url"="..\..\AcceptanceTests\swagger\url.json";
    "url_items"="..\..\AcceptanceTests\swagger\url.json";
    "url_query"="..\..\AcceptanceTests\swagger\url.json";
    "header"="..\..\AcceptanceTests\swagger\header.json";
    "http_infrastructure"="..\..\AcceptanceTests\swagger\httpInfrastructure.json";
    "required_optional"="..\..\AcceptanceTests\swagger\required-optional.json";
    "report"="..\..\AcceptanceTests\swagger\report.json";
}

Import-Module "$PSScriptRoot\..\..\..\..\binaries\net45\AutoRest.Core.dll"

foreach ($test in $tests.GetEnumerator())
{
    $settings = New-Object Microsoft.Rest.Generator.Settings
    $settings.CodeGenerator = "Ruby";
    $settings.Modeler = "Swagger"
    $settings.OutputDirectory = "$PSScriptRoot\bin\RspecTests\$($test.Key)"
    $settings.Input = "$PSScriptRoot\$($test.Value)"
    $settings.Header = "NONE"
    $settings.Namespace = "MyNamespace"
    Write-Output "Generating $($test.Value)"
    [Microsoft.Rest.Generator.AutoRest]::Generate($settings)
}

Copy-Item -Path "$PSScriptRoot\RspecTests\*" -Destination "$PSScriptRoot\bin\RspecTests\" -Recurse

cd "$PSScriptRoot\..\..\AcceptanceTests\server\"
Start-Process npm -ArgumentList 'install'

$proc = Start-Process npm -PassThru -ArgumentList 'start'

cd "$PSScriptRoot\bin\"
Start-Process bundle -ArgumentList "install" -Wait

$OsVersionNumber = [int]([System.Environment]::OSVersion.Platform)
$IsUnix = ($OsVersionNumber -eq 4) -or ($OsVersionNumber -eq 128)
if($IsUnix){
    $executableFileName = "bundle"
}
else{
    $executableFileName = "bundle.bat"
}

foreach ($path in $env:Path.Split(@([System.IO.Path]::PathSeparator), [System.StringSplitOptions]::RemoveEmptyEntries)){
    $fullPath = [System.IO.Path]::Combine($path, $executableFileName)
    if([System.IO.File]::Exists($fullPath)){
        break;
    }
}

$exit_code = 0
$files = Get-ChildItem "$PSScriptRoot\bin\RspecTests"|`
Where-Object{$_.Name -like "*_spec.rb" -and $_.Name -notmatch "report_spec.rb"}|`
Select -ExpandProperty Name
$files += "report_spec.rb"

foreach($file in $files){
    Write-Output "Test $file"
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $fullPath
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardError = $true
    $pinfo.UseShellExecute = $false
    $pinfo.CreateNoWindow = $true
    $pinfo.Arguments = "exec rspec RspecTests\$file"
    $pinfo.WorkingDirectory = "$PSScriptRoot\bin\"
    $pinfo.EnvironmentVariables["StubServerURI"] = "http://localhost:3000"
    $rspec = New-Object System.Diagnostics.Process
    $rspec.StartInfo = $pinfo
    $rspec.Start() | Out-Null
    $stdout = $rspec.StandardOutput.ReadToEnd()
    $stderr = $rspec.StandardError.ReadToEnd()
    $rspec.WaitForExit()

    $stdout
    $stderr
    Write-Output "Exit code: $($rspec.ExitCode)"
    if($rspec.ExitCode -ne 0){
        $exit_code = $rspec.ExitCode
    }
}

$fake = $proc.CloseMainWindow()

Exit $exit_code