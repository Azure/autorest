

### Pre-requisite
* Visual Studio 2013 Update 2 is required as the minimum version for AutoRest.
* To build from command line, Visual Studio Developer Command line needs to be used. It is usually located at "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\Shortcuts\Developer Command Prompt for VS2013.lnk"

### Build
##### From Visual Studio
The ClientRuntime solution supports the following targets:
* Net40
* Net45
* Portable

The targets can be switched manually by selecting the target as follows:
Build --> ConfigurationManager
  
##### From Command line
```
msbuild build.proj
```

### UnitTest
Tests can always be executed from Test Explorer in VisualStudio

##### Running tests from Command line
```
msbuild build.proj /t:build;test
```

### Other build tasks
* Rebuild
```
msbuild build.proj /t:clean;build
```
* Build NuGet packages. The packages will drop to '.\binaries\packages'.
```
msbuild build.proj /t:build;package
```
