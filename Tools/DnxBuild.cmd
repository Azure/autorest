call .\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu restore ..\ClientRuntimes\CSharp\ClientRuntime\Microsoft.Rest.ClientRuntime
call .\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu build ..\ClientRuntimes\CSharp\ClientRuntime\Microsoft.Rest.ClientRuntime --configuration release --out ..\dnx
call .\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu restore ..\ClientRuntimes\CSharp\ClientRuntime.Azure\Microsoft.Rest.ClientRuntime.Azure
call .\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu build ..\ClientRuntimes\CSharp\ClientRuntime.Azure\Microsoft.Rest.ClientRuntime.Azure --configuration release --out ..\dnx
xcopy ..\dnx\release\dnxcore50 ..\binaries\dnxcore50 /I /Y



