# <img align="center" src="./images/logo.png">  Managing AutoRest from the command line

Once you have AutoRest installed using `npm`, it should be available on the PATH, so you can just run it from anywhere:

``` powershell
# The first time you run it, it will pull in the binaries that are needed to run. (no elevation/root required)
> autorest 

AutoRest
Downloading https://github.com/Azure/autorest/releases/.../dotnet-win7-x64.1.0.4.zip
        to  c:\users\...\.autorest\frameworks
Downloading https://github.com/Azure/autorest/releases/.../autorest-1.0.1-20170223-1007-preview.zip
        to  c:\users\...\.autorest\plugins\autorest\1.0.1-20170223-1007-preview

```

You can get some help from the command line:

``` powershell
# Run AutoRest and see the command-line help.
> autorest --help

AutoRest
  Build Information
  Bootstrapper :        0.9.10
  NetCore framework :   1.0.4
  AutoRest core :       1.0.1-20170223-1007-preview

Output Verbosity
  --verbose            show verbose output information
  --debug              show internal debug information
  --quiet              suppress output

Versions
  --list-installed     show all installed versions of AutoRest tools
  --list-available=nn  lists the last nn releases available from github
                        (defaults to 10)

Installation
  --version=version    uses version of AutoRest, installing if necessary.
                        for version you can
                        use a version label (see --list-available) or
                          latest         - get latest nightly build
                          latest-release - get latest release version
  --reset              remove all installed versions of AutoRest tools
                        and install the latest (override with --version)

```

You can use any version of AutoRest by asking for it on the command-line. If it's not installed, AutoRest will install it first:

``` powershell
# Use the latest nightly or preview version:
> autorest --version=latest <...args>

# Use the latest 'release' version :
> autorest --version=latest-release <...args>

# Use a specific version 
> autorest --version=1.0.1-20170223-1007-preview <...args>
```

You can see what versions of AutoRest that are available to install:

``` powershell
# show available versions
> autorest --list-available

AutoRest
  Build Information
  Bootstrapper :        0.9.10
  NetCore framework :   1.0.4
  AutoRest core :       1.0.1-20170223-1007-preview

Output Verbosity

  --verbose            show verbose output information
  --debug              show internal debug information
  --quiet              suppress output

Versions

  --list-installed     show all installed versions of AutoRest tools
  --list-available=nn  lists the last nn releases available from github
                        (defaults to 10)

Installation

  --version=version    uses version of AutoRest, installing if necessary.
                        for version you can
                        use a version label (see --list-available) or
                          latest         - get latest nightly build
                          latest-release - get latest release version
  --reset              remove all installed versions of AutoRest tools
                        and install the latest (override with --version)

Last 10 releases available online:

  1.0.1-20170223-1007-preview
  1.0.1-20170222-1520-preview
```

You can also see what's installed locally:

``` powershell
# look what is installed already
autorest --list-installed
AutoRest
  Build Information
  Bootstrapper :        0.9.10                      # current npm package version
  NetCore framework :   1.0.4                       # current version of the .NET Core framework
  AutoRest core :       1.0.1-20170223-1007-preview # current version of the AutoRest tool itself.

Installed versions of AutoRest :

  1.0.1-20170223-1007-preview                       # list of all the versions installed.
```

If you want to remove all versions of AutoRest and install the just latest version

``` powershell
# Remove all binaries for AutoRest
> autorest --reset <...args>

AutoRest
Downloading https://github.com/Azure/autorest/releases/.../dotnet-win7-x64.1.0.4.zip
        to  ~\.autorest\frameworks
Downloading https://github.com/Azure/autorest/releases/.../autorest-1.0.1-20170223-1007-preview.zip
        to  ~\.autorest\plugins\autorest\1.0.1-20170223-1007-preview

```
