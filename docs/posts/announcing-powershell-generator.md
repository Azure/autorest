# <img align="center" src="https://github.com/Azure/autorest/raw/master/docs/images/logo.png"> Generating PowerShell Cmdlets from OpenAPI/Swagger with AutoRest

A long time coming, but I'm now announcing the availability of the first beta of the [AutoRest](https://aka.ms/autorest) PowerShell cmdlet generator.

> [AutoRest](http://github.com/Azure/autorest) is the SDK generation tool that we use in Azure to produce SDKS for 90+ management services across 7+ languages. <br>Its pluggable architecture allows fine-grained control over the generation process, and allows extensions to be written in any language that can read/write JSON via stdin/stdout (we use the [JSON-RPC](https://www.npmjs.com/package/vscode-jsonrpc) protocol that [Visual Studio Code uses](https://code.visualstudio.com) )

Along the way, we had to go back and make some updates to the core of AutoRest (to begin support of OpenAPI 3, and introduce some changes to support generating multiple API versions with Azure Profiles.)


## Getting Started

### Requirements

Use of the beta version of `autorest.powershell` requires the following:

- [Node.js LTS](https://nodejs.org) (10.15.x LTS preferred. Will not function with a Node version less than 10.x. Be wary of 11.x builds as they may introduce instability or breaking changes. ) 
> If you want an easy way to install and update Node, I recommend [NVS - Node Version Switcher](https://github.com/Azure/autorest/blob/master/docs/nodejs/installing-via-nvs.md) or [NVM - Node Version Manager](https://github.com/Azure/autorest/blob/master/docs/nodejs/installing-via-nvm.md)

- [AutoRest](https://aka.ms/autorest) v3 beta: `npm install -g autorest@beta`
- PowerShell 6.1 - If you don't have it installed, you can use the cross-platform npm package <br> `npm install -g pwsh` <br>&nbsp;
- Dotnet SDK 2 or greater - If you don't have it installed, you can use the cross-platform .NET 2.1 npm package <br> `npm install -g dotnet-sdk-2.1 ` <br>&nbsp;

### Using AutoRest Powershell

At a bare minimum, you can generate a PowerShell module using a Swagger or OpenAPI file and using `--powershell`.

The output will be in the `./generated` folder by default:

`autorest --powershell --input-file:<path-to-swagger-file> [...options]`

Be sure to check out [these additional samples that use the PowerShell generator](https://github.com/Azure/autorest/blob/master/docs/powershell/samples/readme.md).

### Known Issues
As with all `beta` software, there are bound to be a few glitches or things that are not working. 

We've cataloged some [known issues](https://github.com/Azure/autorest/blob/master/docs/powershell/release-notes.md#caveats-and-known-issues) with this first beta we encourage you to read before reporting any issues you experience.

### Support 
We're working as fast as we can to finish up the generator, as we have a lot of modules to generate internally. 

If you run into problems, you can post an issue on the [github repo](https://github.com/Azure/autorest/issues) and tag it with the `powershell` label, and we'll try to take a look.

## Features

### Generates modules from OpenAPI files without any external dependencies
Most language SDKs generated with AutoRest required the use of at least a 'client runtime' package, and often pulls in a few other libraries (ie, `JSON.NET`) that are required to compile the output of the generator.

The new PowerShell generator creates modules that require _no dependencies_ outside of `netstandard2.0` and the `PowerShellStandard.Library` which drastically reduces the chances of having assembly loading conflicts.

### Modules work on both Windows PowerShell and PowerShell 
Due to the use of `netstandard2.0` and `PowerShellStandard.Library`, once compiled, the cmdlets work on both Windows PowerShell 5.1 and PowerShell 6.x.

### Cmdlets have no weird base-classes or force hierarchy
All the generated cmdlets inherit `PSCmdlet` and are fairly straightforward. For ARM resources, we already support generating `-AsJob` support for long-running-operations, and this can be expanded in the future to support more patterns.

### An incredible number of extensibility points 
After generation of a module, the developer may wish to augment the module in many ways (custom work when the module loads, changing the HTTP pipeline, adding additional variants of cmdlets, and more). 
The generated cmdlets offer number of ways to be customized and enhanced, and we'll be posting some documentation on how to do that in the near future.

### Many variants of cmdlets are created to offer several `ParameterSets`
Behind-the-scenes, many different flavors of a cmdlet can get created, and these are tied together into a single cmdlet with multiple parameter sets. These can be joined with manually written cmdlets that are written in `.ps1` scripts or C# classes.

### No reflection for serialization
The generated module has custom-created JSON serialization (using an embedded copy of [Carbon.JSON](https://github.com/carbon/Data/tree/master/Carbon.Json) This significantly improves serialization performance.

## FAQs

### What happened to 'PSSwagger'?
In order to get to the point where we can generate the [Az](https://azure.microsoft.com/en-us/blog/azure-powershell-az-module-version-1/) 
modules for all the Azure management services, we needed more control in the fine-grained details of the resulting cmdlets.
After consulting with the PowerShell team, the decision was made to integrate more closely with the existing mechanism for generating Azure SDKs (AutoRest) and build a full-featured generator extension to create PowerShell cmdlets.

### Source code?
Of course! Get started with the source code by reading [the developer documentation](https://github.com/Azure/autorest/blob/master/docs/powershell/development.md)

### Are there any PowerShell specific generation options?

Yes! You can modify the entire output folder layout, and tweak the way it generates cmdlets, including cmdlet names, parameters, etc. (Check out [our additional documentation on these options](https://github.com/Azure/autorest/blob/master/docs/powershell/options.md)). If you have feedback about these code generation options, feel free to post an issue on the [AutoRest GitHub repo](https://github.com/Azure/autorest/issues).

# Quick Links
- [AutoRest GitHub repository](https://github.com/Azure/autorest/blob/master/README.md)
- [Getting Started with the AutoRest PowerShell Generator](https://github.com/Azure/autorest/blob/master/docs/powershell/readme.md)
- [Additional documentation](https://github.com/Azure/autorest/blob/master/docs/powershell/readme.md#more-information) will be added as we get it written. 
- [Developer documentation](https://github.com/Azure/autorest/blob/master/docs/powershell/development.md) for the PowerShell generator. 
