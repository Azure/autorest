pushd %~dp0
cd ..\ClientRuntimes\CSharp\ClientRuntime\Microsoft.Rest.ClientRuntime
call ..\..\..\..\Tools\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu restore
call ..\..\..\..\Tools\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu build --configuration debug
call ..\..\..\..\Tools\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu pack
copy bin\Release\*.nupkg c:\nuget

cd ..\ClientRuntimes\CSharp\ClientRuntime.Azure\Microsoft.Rest.ClientRuntime.Azure
call ..\..\..\..\Tools\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu restore
call ..\..\..\..\Tools\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu build --configuration debug
call ..\..\..\..\Tools\dnx-coreclr-win-x86.1.0.0-beta7\bin\dnu pack
copy bin\Release\*.nupkg c:\nuget
popd


