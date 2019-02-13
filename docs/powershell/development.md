# AutoRest PowerShell Generator - Development

## Requirements

Use of this project requires the following:

- [NodeJS LTS](https://nodejs.org) (currently 10.15.0) <br> I recommend that you use a tool like [nvs](https://github.com/jasongin/nvs) so that you can switch between versions of node without pain <br>&nbsp;
- [AutoRest](https://aka.ms/autorest) v3 beta <br> `npm install -g autorest@beta ` <br>&nbsp;
- [RushJS](https://rushjs.io/) manages multiple nodejs projects in a single repository. <br> `npm install -g @microsoft/rush` <br>&nbsp;
- PowerShell 6.0 - If you dont have it installed, you can use the cross-platform npm package <br> `npm install -g pwsh` <br>&nbsp;
- Dotnet SDK 2 or greater - If you dont have it installed, you can use the cross-platform npm package <br> `npm install -g dotnet-sdk-2.1 ` <br>&nbsp;
- _Recommended_: [Visual Studio Code](https://code.visualstudio.com/)


## Cloning this repository

Make sure that you clone this repository with `--recurse` - there is a submodule with common code that we pull from the `https://github.com/azure/perks` project.

``` powershell
# clone recursively
git clone https://github.com/azure/autorest.powershell --recurse

# one-time
cd autorest.powershell
npm install
```

## Using RushJS

This repository is built as a 'monorepo' using [RushJS](https://rushjs.io/) - which manages multiple nodejs projects in a single repository.

``` powershell
# install nodejs modules for all projects in the monorepo
rush update
```

Rush is used to make sure that package versions are consistent between sub-projects

``` powershell
# ensure all projects are using the same versions
rush sync-versions

# install modules 
rush update
```

## Compiling

Rush is used to build `autorest.powershell`

``` powershell
# build everything
rush rebuild
```

You can use `watch` to compile when a file is changed, which will rebuild dependencies automatically.
Just kill the process with ctrl-c to stop it.

``` powershell
# start watching 
rush watch
```

## Using your locally built version of `autorest.powershell`

To use the locally built version of the plugin, add `--use:<path>` to the command line 

``` powershell
# using a local build
> autorest --use:c:/work/autorest.powershell <...arguments>

```

### Debugging 

COMING SOON.

### Testing

COMING SOON.

# Contributing


## Contributor License Agreement Requirements

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
