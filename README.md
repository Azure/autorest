# <img align="center" src="./docs/images/logo.png">  AutoRest

## Autorest 2.0 Branch

AutoRest is making a a few structural changes, along with eliminating some deprecated legacy behavior.

Notable changes in this branch:
- Bumping required node.js version to 7.10 or greater. (Will add checks in to ensure that this is the case)<br> This enables us to target the `ES2017` javascript standard, vastly simplifying compiled code and has significant performance benefits. 
- Bumping Dotnet/CLI SDK and Runtime to 2.0
- Updated bootstrapper that implements use-extension
- Moving common TypeScript code into the Perks.Node project so that they can be built and reused independently of building AutoRest.
- Removing all remaining Legacy CLI features, standardizing on the `--switch` format for all cmdline operations


---

The **AutoRest** tool generates client libraries for accessing RESTful web services. Input to *AutoRest* is a spec that describes the REST API using the [Open API Initiative](https://github.com/OAI/OpenAPI-Specification) format.

[![Repo Status](http://img.shields.io/travis/Azure/autorest/dev.svg?style=flat-square&label=build)](https://travis-ci.org/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/pr?style=flat-square)](http://issuestats.com/github/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/issue?style=flat-square)](http://issuestats.com/github/Azure/autorest)

# Installing Autorest 

Installing AutoRest on Windows, MacOS or Linux involves two steps:

1. __Install [Node.js](https://nodejs.org/en/)__ (7.10.0 or greater)
> for more help, check out [Installing Node.JS on different platforms](./docs/developer/workstation.md#nodejs)

2. __Install AutoRest__ using `npm`

  ``` powershell
  # Depending on your configuration you may need to be elevated or root to run this. (on OSX/Linux use 'sudo' )
  npm install -g autorest
  ```

### Updating Autorest
  To update AutoRest if you have previous versions installed, please run:
    
  ``` powershell
  autorest --latest
  ``` 
or 
  ```powershell
  # Removes all other versions and installs the latest
  autorest --reset
  ```
  For more information, run  `autorest --help`


### Status on various platforms:
 
|OS | Status | 
|---|--------|
|Windows x64| Verified - Working|
|OSX 10.11 x64| Verified - Working (may have to install openssl manually?)|
|Ubuntu 14.04 x64 (any) | Verified - Working -- use the following commands first: <br>`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install libunwind8 libicu52 -y` |
|Ubuntu 16.04 x64 (desktop)| Verified - Working|
|Ubuntu 16.04 x64 (server or via BashForWindows/WSL) | Verified - Working -- use the following commands first: <br>`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install libunwind8 -y` |
|Ubuntu 16.10 x64| Verified - Working -- use the following commands first: <br>`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install libunwind8 -y && wget  http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu55_55.1-7_amd64.deb && sudo dpkg -i libicu55_55.1-7_amd64.deb`   |

Other Linux platforms *might* work -- if the platform is listed https://github.com/Azure/autorest/releases/tag/dotnet-runtime-1.0.4 -- there is a fairly good chance that it'll work. As more testing is completed, we'll ensure that we update the status here.

### _PREVIEW AVAILABLE_ : Installer EXE for AutoRest now online 
You can test out the PREVIEW AutoRest installer from : https://github.com/Azure/autorest/releases/download/dotnet-runtime-1.0.3/AutoInstaller.exe

> **Note**: 
> The Installer is a work-in-progress -- it has been tested for the happy path, some functionality isn't yet implemented:
> - Remove/Uninstall - not yet implemented
> - Upgrade - minimally tested
> - About and Project buttons - not yet implemented
> - not yet codesiged
> - no silent/unattended mode yet
> <br>
> <br> ![image](https://cloud.githubusercontent.com/assets/133736/23370663/440ff1c4-fcca-11e6-9b66-5e0da642af55.png) <br>

> - Feedback welcome at https://github.com/Azure/autorest/issues/1884


# Getting Started using AutoRest ![image](./docs/images/normal.png)

Start by reading the documentation for using AutoRest:
- [Managing Autorest](./docs/managing-autorest.md) - shows how to get new updates to AutoRest and choose which version to use for code generation
- [Generating a Client using AutoRest](./docs/generating-a-client.md) - shows simple command line usage for generating a client library.
- [Command Line Interface Documentation](./docs/user/cli.md) - explains common command line arguments
- [Examples](./Samples) - full, walkthrough-style scenarios for using AutoRest

# Developers ![image](./docs/images/glasses.png)

Get yourself up and coding in AutoRest

- [Developer Workstation Requirements](./docs/developer/workstation.md) - what do you need to install to start working with the AutoRest code
- [Compiling AutoRest](./docs/developer/compiling-autorest.md) - compiling/testing AutoRest using the build scripts 

Some information about the internal AutoRest architecture (may need updating!):
- [Developer Guide](./docs/developer/guide/) - Notes on developing with AutoRest
- [AutoRest and ClientRuntimes](./docs/developer/architecture/Autorest-and-Clientruntimes.md) - about the client runtime requirements for AutoRest
- [The `CodeModel` data model](./docs/developer/architecture/CodeModel-and-the-Language-specific-Generator-Transformer-Namer.md) and the Language-specific Generator/Transformer/Namer
- [`Fixable<T>` implementation](./docs/developer/architecture/Fixable-T----When-a-value-is-both-calculated-and-or-fixed.md) - When a value is both calculated and/or fixed
- [LODIS](./docs/developer/architecture/Least-Offensive-Dependency-Injection-System.md) - The Least Offensive Dependency Injection System
- [Name Disambiguation](./docs/developer/architecture/Name-Disambiguation.md) - how names don't collide in code generation.
- [Validation Rules & Linting](./docs/developer/validation-rules/readme.md) - about the validation rules in AutoRest

---

### Code of Conduct 
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

