# Prerequisites
 Visual Studio 2013 Update 2 is the minimum version for building AutoRest.

## Build
### Visual Studio Build
The ClientRuntime solution includes separate build configurations for the following targets:
* Net40-Debug
* Net40-Release
* Net45-Debug
* Net45-Release
* Portable-Debug
* Portable-Release
Switch between targets using the ConfigurationManager found in the Build menu of Visual Studio.
  
### Command-line Build
To build from the command line, use the Developer Command Prompt. A shortcut to launch it is installed by default in
```bash
    "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\Shortcuts\Developer Command Prompt for VS2013.lnk"
```
The command-line build will compile Net40, Net45 and Portable configurations. From the root of the project, run:
```bash
msbuild build.proj
```

## Run Unit Tests
Tests can be run from the Test menu in Visual Studio or they can be started from the command line using the **clean** build target.

```bash
msbuild build.proj /t:test
```
Compile and run the tests by using multiple build targets.
```bash
msbuild build.proj /t:build;test
```

## Additional Build Targets
Rebuild by including the **clean** target to remove existing temporary outputs.
```bash
msbuild build.proj /t:clean;build
```
Build NuGet packages. The packages will be placed in `'.\binaries\packages'`.
```bash
msbuild build.proj /t:build;package
```
