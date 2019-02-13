# AutoRest PowerShell Generator

## Users Quick Links
  - PowerShell specific options -- see [PowerShell Options](./options.md)
  - PowerShell specific samples -- see [Samples](./samples/readme.md)

## Developers Quick Links
- Compiling and using the generator yourself - see [PowerShell Generator Development](./development.md) 
- [AutoRest PowerShell Source Code](https://github.com/azure/autorest.powershell) -- the source code to the generator. (Work-in-progress)


## Requirements

Use of the released version of `autorest.powershell` requires the following:

- [NodeJS LTS](https://nodejs.org) (currently 10.15.0) <br> I recommend that you use a tool like [nvs](https://github.com/jasongin/nvs) so that you can switch between versions of node without pain <br>&nbsp;
- [AutoRest](https://aka.ms/autorest) v3 beta <br> `npm install -g autorest@beta ` <br>&nbsp;
- PowerShell 6.0 - If you dont have it installed, you can use the cross-platform npm package <br> `npm install -g pwsh` <br>&nbsp;
- Dotnet SDK 2 or greater - If you dont have it installed, you can use the cross-platform npm package <br> `npm install -g dotnet-sdk-2.1 ` <br>&nbsp;

## Installing AutoRest Beta and the PowerShell generator

To use the PowerShell generator, you have to first install the AutoRest v3 beta:

``` powershell
# Installing AutoRest (beta)
> npm install -g autorest@beta

# if you have a previous version installed (or want it to pull the latest version), reset the autorest plugins
> autorest --reset
```

## Returning to the release version of the generator

If you run into a problem, and need to return to the release version of the generator


``` powershell
# Installing AutoRest (release)
> npm install -g autorest

# remove all the installed plugins
> autorest --reset
```

## Using AutoRest Powershell

At a bare minimum, you can generate a powershell module using a swagger or openapi file and using `--powershell`.

The output will be in the `./generated` folder by default

``` powershell
# AutoRest command line
> autorest --powershell --input-file:<path-to-swagger-file> [...options]
```

## Common AutoRest parameters:

- `--powershell` - required to use the powershell generator
- `--input-file:<OpenAPI2 or OpenAPI3 file>` - the OpenAPI2/OpenAPI3/Swagger (.json or .yaml) file to generate the module from
- `--output-folder:<folder>` - you can specify where the output is to be generated
- `--verbose`  - get verbose information from autorest as to what is going on
- `--debug` - get debug information from autorest as to what is going on
- `--clear-output-folder` - to clear out previous generated files in the output folder (except files in the custom folder)


