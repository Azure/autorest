# Generating cmdlets from OpenAPI/Swagger with AutoRest

A long time coming, but I'm now announcing the availability of the first beta of the [AutoRest](https://aka.ms/autorest) PowerShell cmdlet generator.

> [AutoRest](http://github.com/Azure/autorest) is the SDK generation tool that we use in Azure to produce SDKS for 90+ management services across 7+ languages. <br>Its pluggable architecture allows fine-grained control over the generation process, and allows extensions to be written in any language that can read/write JSON via stdin/stdout (we use the [JSON-RPC](https://www.npmjs.com/package/vscode-jsonrpc) protocol that [Visual Studio Code uses](https://code.visualstudio.com) )

Along the way, we had to go back and make some updates to the core of autorest (to begin supportof OpenAPI3, and introduce some changes to support generating multiple-api versions with Azure Profiles.)

<hr>

## Getting Started

### Requirements

Use of the beta version of `autorest.powershell` requires the following:

- [NodeJS LTS](https://nodejs.org) (10.15.x LTS preferred. Will not function with Node < 10.x Be Wary of 11.x builds as they may introduce instability or breaking changes. ) 
> if you want an easy way to install and update Node, I recommend [NVS - Node Version Switcher](https://github.com/Azure/autorest/blob/master/docs/nodejs/installing-via-nvs.md) or [NVM - Node Version Manager](https://github.com/Azure/autorest/blob/master/docs/nodejs/installing-via-nvm.md)

- [AutoRest](https://aka.ms/autorest) v3 beta <br> `npm install -g autorest@beta ` <br>&nbsp;
- PowerShell 6.0 - If you dont have it installed, you can use the cross-platform npm package <br> `npm install -g pwsh` <br>&nbsp;
- Dotnet SDK 2 or greater - If you dont have it installed, you can use the cross-platform npm package <br> `npm install -g dotnet-sdk-2.1 ` <br>&nbsp;

### Using AutoRest Powershell

At a bare minimum, you can generate a powershell module using a swagger or openapi file and using `--powershell`.

The output will be in the `./generated` folder by default:

> `autorest --powershell --input-file:<path-to-swagger-file> [...options]`

See: [Some Samples](https://github.com/Azure/autorest/blob/master/docs/powershell/samples/readme.md) using the PowerShell generator.

### Known Issues
As with all `beta` software, there are bound to be a few glitches or things that are not working. 

See : [Known Issues](https://github.com/Azure/autorest/blob/master/docs/powershell/release-notes.md#caveats-and-known-issues) with the first beta.

### Support 
We're working as fast as we can to finish up the generator, as we have a lot of modules to generate internally. 

If you run into problems, you can post an issue on the [github repo](https://github.com/Azure/autorest/issues) and tag it with the `powershell` label, and we'll try to take a look.

<hr>

##  Features

### Generates modules from OpenAPI files without any external dependencies
Most language SDKs generated with AutoRest required the use of at least a 'client runtime' package, and often pulls in a few other libraries (ie, `JSON.NET`) that are required to compile the output of the generator.

The new PowerShell generator requires _nothing_ outside of found in `netstandard2.0` and the `PowerShellStandard.Library` which drastically reduces the chances of having conflicts.

### Modules work on both Windows PowerShell and PowerShell 
Due ot the use of `netstandard2.0` and `PowerShellStandard.Library`, once compiled, the cmdlets work on both Windows PowerShell 5.1 and PowerShell 6.x.

### Cmdlets have no weird base-classes or force heirarchy.
All the generated cmdlets inherit `PSCmdlet` and are fairly straightforward. For Azure ARM resources, we already support generating `-AsJob` support for long-running-operations, and this can be expanded in the future to support more patterns.

### An incredible number of extensibility points 
After generation of a module, the developer may wish to augment the module in many ways (custom work when the module loads, changing the HTTP pipeline, adding additional variants of cmdlets, and more). 
The generated cmdlets have a large number of ways to be customized and enhanced, and we'll be posting some documentation on how to do that in the near future.

### Many variants of Cmdlets are created to offer several `ParameterSets`
Behind-the-scenes, many differenct flavors of a cmdlet can get created, and these are tied together into a single cmdlet with multiple parameter sets. These can be joined with manually-written cmdlets that are written in `.ps1` scripts or c# classes.

### No reflection for Serialization
The generated module has custom-created JSON serialization (using an embedded copy of [Carbon.JSON](https://github.com/carbon/Data/tree/master/Carbon.Json)) This significantly improves serialization performance.

<hr>

## FAQs

### What happened to 'PSSwagger'?
In order to get to the point where we can generate the [Az](https://azure.microsoft.com/en-us/blog/azure-powershell-az-module-version-1/) 
modules for all the Azure management services, we had to have a lot more control in the fine-grained details of how the cmdlets turned out, 
and after consulatation with the PowerShell team, the decision was made to take two steps back, and build a full-featured generator extension create PowerShell cmdlets.

### Source Code?
Of Course! Get started with the source by reading [the developer documentation](https://github.com/Azure/autorest/blob/master/docs/powershell/development.md)

# Quick Links
- [AutoRest](https://github.com/Azure/autorest/blob/master/README.md) information can be found on the github site.
- [Getting Started](https://github.com/Azure/autorest/blob/master/docs/powershell/readme.md) with the AutoRest PowerShell Generator
- [Additional documentation](https://github.com/Azure/autorest/blob/master/docs/powershell/readme.md#more-information) will be added as we get it written. 
- [Developer documentation](https://github.com/Azure/autorest/blob/master/docs/powershell/development.md) for the powershell generator. 
