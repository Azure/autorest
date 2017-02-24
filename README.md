# <img align="center" src="./docs/images/logo.png">  AutoRest

The **AutoRest** tool generates client libraries for accessing RESTful web services. Input to *AutoRest* is a spec that describes the REST API using the [Open API Initiative](https://github.com/OAI/OpenAPI-Specification) format.

[![Repo Status](http://img.shields.io/travis/Azure/autorest/dev.svg?style=flat-square&label=build)](https://travis-ci.org/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/pr?style=flat-square)](http://issuestats.com/github/Azure/autorest) [![Issue Stats](http://issuestats.com/github/Azure/autorest/badge/issue?style=flat-square)](http://issuestats.com/github/Azure/autorest)

# What's New (02/24/2017)

AutoRest has been thru a lot of changes recently, most notably:
- we've switched to building the core components with the latest [dotnet-cli](https://github.com/dotnet/cli) tools, and the binaries are build for .NET Core 1.0 (aka 'CoreCLR')
- we're starting to build some of the components in NodeJS - this allows us to leverage all sorts of other great functionality with less coding effort
- we have a great cross-platform installation model for Windows, Mac OSX and Linux, which is built on top of NodeJS's `npm` package manager

> #### Why did you change that?
> Previously, in order to get AutoRest, you had to either get an older version from Chocolatey, or install a 'nightly' build from the MyGet feed using the NuGet tool.
> This didn't make it easier to keep up-to-date with AutoRest (as development happens pretty fast these days!), and often bugs were getting fixed and it was a pain for users to get the updated binaries.
>
> Now, you can "install" AutoRest just once, and AutoRest itself has the ability to download and install any updates, as well as allowing the user to choose any arbitrary build at runtime, and it will use the requested verion.
>
> This will let you install a 'release' version of AutoRest, and use that, but if you want to test a new nightly or preview version, you can just ask for it on the command line. 
>
> Additionally, we're making AutoRest work in multiple environments, (including a upcoming [Visual Studio Code](https://code.visualstudio.com/) extension), and using this model, AutoRest will give exactly the same results from the command line as in the IDE, without having to manually fight to switch versions when you want.


# Installing Autorest 

Installing AutoRest on Windows, MacOS or Linux involves two steps:

1. __Install [Node.js](https://nodejs.org/en/)__ (6.9.5 or greater)
> for more help, check out [Installing Node.JS on different platforms](./docs/developer/workstation.md#nodejs)

2. __Install AutoRest__ using `npm`

  ``` powershell
  # Depending on your configuration you may need to be elevated or root to run this. (on OSX/Linux use 'sudo' )
  npm install -g autorest
  ```

### _Coming Soon_ 
A downloadable Installer EXE for Windows that automates both steps should be available shortly.

# Getting Started using AutoRest ![image](./docs/images/normal.png)

Start by reading the documentation for using AutoRest:
- [Managing Autorest](./docs/managing-autorest.md) - shows how to get new updates to AutoRest and choose which version to use for code generation
- [Generating a Client using AutoRest](./docs/generating-a-client.md) - shows simple command line usage for generating a client library.

# Developers ![image](./docs/images/glasses.png)

Get yourself up and coding in AutoRest

- [Developer Workstation Requirements](./docs/developer/workstation.md) - what do you need to install to start working with the AutoRest code
- [Compiling AutoRest](./docs/developer/compiling-autorest.md) - compiling/testing AutoRest using the build scripts 

Some information about the internal AutoRest architecture (may need updating!):
- [Developer Guide](./docs/developer/guide/) - Notes on developing with AutoRest
- [AutoRest and ClientRuntimes](./docs/developer/architecture/Autorest-and-Clientruntimes.md) - about the client runtime requirements for AutoRest
- [The `CodeModel` data model](./docs/developer/architecture/CodeModel-and-the-Language-specific-Generator-Transformer-Namer.md) and the Language-specific Generator/Transformer/Namer
- [`Fixable<T>` implemenation](./docs/developer/architecture/Fixable-T----When-a-value-is-both-calculated-and-or-fixed.md) - When a value is both calculated and/or fixed
- [LODIS](./docs/developer/architecture/Least-Offensive-Dependency-Injection-System.md) - The Least Offensive Dependency Injection System
- [Name Disambiguation](./docs/developer/architecture/Name-Disambiguation.md) - how names don't collide in code generation.
- [Validation Rules & Linting](./docs/developer/validation-rules/readme.md) - about the validation rules in AutoRest

---

### Code of Conduct 
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

