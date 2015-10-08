pushd %~dp0
call .\nuget.exe install dnx-clr-win-x86 -Version 1.0.0-beta7 -Prerelease
call .\nuget.exe install dnx-coreclr-win-x86 -Version 1.0.0-beta7 -Prerelease
popd


