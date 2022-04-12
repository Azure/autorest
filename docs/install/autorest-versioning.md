# AutoRest Versioning

AutoRest comes in three distinct parts:

- **The CLI** -- the command line tool itself, bootstraps the core module, doesn't handle any processing directly.
- **The Core module** -- when you run AutoRest, this is the component that handles all the loading of Swagger/OpenAPI files, connects the extensions and runs the pipeline.
- **Extensions** - the individual language generators that perform code generation (based on the processing from another 'modeler' extension)

## The CLI

The CLI itself does not often change or require updates, as it doens't hold much actual logic for AutoRest.

The AutoRest CLI is updated like any Node package, via NPM:

> `npm install -g autorest`

## Core Module

The AutoRest core module is the real processing hub for AutoRest.

The CLI can load any version of the AutoRest Core module by using the command line `--version:[VERSION]` where `[VERSION]` is one of:

- a semver version range that matches a published nodejs package `@autorest/core` package.<br>AutoRest v3 defaults to `~3.0.6000` (ie, the latest published `3.0` package above build `6000` )
- the specific version of the core module package, which can come from npm or a prerelase build in [github releases](https://github.com/azure/autorest/releases)<br>ie, `--version:3.0.6189`
- a folder where the core package has been cloned and compiled. (ie, `c:\work\autorest` )
- a URL to a nodejs autorest-core package

An AutoRest configuration file can also specify a `version:` that requests a specific core module.<br>
This can be overridden on the command line with `--version:`<br>

V2 generators will have their core module version defaulting to the latest v2 core module (`2.0.4413`)

> ### Technical details
>
> ---
>
> AutoRest core modules are installed into the user's `$HOME/.autorest` folder.<br>
> Multiple instances of the core module can be installed side-by-side<br>
>
> The core module runs in-process of the CLI (the module library is acquired and executed in the same process)
>
> AutoRest v2 core modules are called `@microsoft.azure/autorest-core` <br>
> AutoRest v3 core modules are called `@autorest/core`<br>
>
> See the [Managing Versions](#managing-versions) section below<br> > &nbsp;

## Extension Modules

AutoRest code generation is all handled in AutoRest extensions. <br>
An individual extension can have one or more plugins that can plug into the AutoRest pipeline to participate in the code generation process.

You can request a _well-known_ extension to be loaded by asking for it on the command line:

> `autorest --csharp ` -- loads the c# plugin.

If you want to pin to a specific version of an extension or to load one that is not _well-known_ specify `--use:[PKGREF]` on the command-line, where `[PKGREF]` is a NPM package reference like:

- an npm package reference with a semver version range that matches a published nodejs package (ie, `--use:@autorest.powershell@~2.0.0` -- loads the powershell package that has a version greater than `2.0.0 `
- an npm package reference with a semver version range that matches a published nodejs package, which can come from npm or a prerelase build in a [github repo](https://github.com/Azure/autorest.modelerfour/releases)<br>ie, `--use:@autorest/modelerfour@4.3.144`
- a folder where the module package has been cloned and compiled. (ie, `c:\work\modelerfour` )
- a URL to a nodejs module package file

> ### Technical details
>
> ---
>
> AutoRest extension modules are installed into the user's `$HOME/.autorest` folder.<br>
> Multiple instances of an extension module can be installed side-by-side<br>
>
> Extension modules are executed out-of-process (communicating via a JSON-RPC protocol over stdin/out). <br>
> They can be written in any language (still must be packaged with npm!)<br>
> We have plugins written in typescript, c#, python, java.
>
> AutoRest v2 extension modules are generally called `@microsoft.azure/autorest.[LANGUAGE]` <br>
> AutoRest v3 extension modules are called `@autorest/[LANGUAGE]`<br>
>
> See the [Managing Versions](#managing-versions) section below<br> > &nbsp;

## Managing Versions

AutoRest modules and extensions support concurrent installaton side-by-side of multiple versions.

You can use `autorest --info` to examine installed cores and extensions:

> `autorest --info`

```text
AutoRest code generation utility [version: 3.0.6161; node: v10.15.1, max-memory: 8192 MB]
(C) 2018 Microsoft Corporation.
https://aka.ms/autorest


Showing All Installed Extensions

 Type       Extension Name                           Version      Location
 core       @autorest/core                           3.0.6197     C:\Users\gs\.autorest\@autorest_core@3.0.6197
 core       @autorest/core                           3.0.6198     C:\Users\gs\.autorest\@autorest_core@3.0.6198
 extension  @autorest/modelerfour                    4.3.144      C:\Users\gs\.autorest\@autorest_modelerfour@4.3.144
```

You can remove all the AutoRest core modules and extensions by using `--reset`:

> `autorest --reset`

```text
AutoRest code generation utility [version: 3.0.6161; node: v10.15.1, max-memory: 8192 gb]
(C) 2018 Microsoft Corporation.
https://aka.ms/autorest
Clearing 25 autorest temp data folders...


Cleared the AutoRest extension folder.
On the next run, extensions will be reacquired from the repository.
```
