# Working on AutoRest extensions

See our [extension documentation](./architecture/AutoRest-extension.md) to learn about what an AutoRest extension is and how it interacts with the core.

All that is required to work on/test/debug an extension is a regular production installation of AutoRest, i.e. a clone of this very repo is not required!
To make AutoRest use an extension (overrides extensions loaded via `use-extension`, so perfect for testing local changes), simply use `--use=<local path or GitHub repo>`.

> **Example workflow: Testing a change to the Java generator**
>
> Prerequisites:
> - AutoRest installation, i.e. have the `autorest` command available
> - clone/fork of https://github.com/Azure/autorest.java
>
> Process:
> - make changes to clone/fork
> - test them by issuing the `autorest` command you would normally use, but add
>   - `--use=<PATH TO YOUR CLONE>` if you wanna test your local changes or
>   - `--use=https://github.com/<YOUR ACCOUNT>/autorest.java` if you wanna test your fork


As noted in the extension documentation, extensions can be developed in any programming language, so there is no perfectly generic guide we can provide for working on the extension itself.
However, we maintain and support a number of commonly used code generators:

# Code Generators

For code generation we maintain the following repositories.

``` Python gives nice highlighting
# Helping packages:
https://github.com/Azure/autorest.common        # common functionality shared between generators
https://github.com/Azure/autorest.testserver    # testing facility used by generators' tests 

# Valid AutoRest extensions:
https://github.com/Azure/autorest.modeler
https://github.com/Azure/autorest.azureresourceschema
https://github.com/Azure/autorest.csharp
https://github.com/Azure/autorest.go
https://github.com/Azure/autorest.java
https://github.com/Azure/autorest.nodejs
https://github.com/Azure/autorest.php
https://github.com/Azure/autorest.ruby
https://github.com/Azure/autorest.python
https://github.com/Azure/autorest.typescript
```

## Getting Started
All of the above extensions have both their development and runtime dependencies (dotnet 2.0) persisted in their `package.json`, so `npm install` will install `dotnet` and make it available to the other `npm` scripts including:
- `npm run build` to build the extension
- `npm test` to test the extension

Use these scripts and the development workflow should be as easy as:
- clone
- `npm install`
- make changes
- `npm test`
- `npm run build`
- run it using `autorest --use=...` (see above)
- debug it (see below)

## Debugging

This first generation of AutoRest generators were written in C# and are not invokable as a stand-alone since they rely on previous processing steps either done by other extensions or by the AutoRest core.

As a result, debugging a generator extension also requires it to be launched *through the core* like in a regular invocation of AutoRest (on the bright side, one can stay on the CLI and run exactly the command that exposes the problem to debug).
One can then attach to the running extension process (`dotnet autorest.<something>.dll --server`) through VS Code, there is a launch configuration for that.
The biggest problem is timing, i.e. attaching and having breakpoints in place before execution has passed the critical point.
For this purpose, we introduced the `--<plugin to debug>.debugger` flag which will cause any call to the extension to *sit and wait* until a debugger is attached.

### Example

Assume a customer reports a bug in C# code generation when running

```haskell gives nice highlighting
autorest foo\readme.md --azure-validator --fancy-setting=3 --csharp.azure-arm
```

or you find that a feature you are working on in `autorest.csharp` behaves unexpectedly:

```haskell gives nice highlighting
autorest foo\readme.md --azure-validator --fancy-setting=3 --csharp.azure-arm --use=<local variation of autorest.csharp>
```

Simply call:

```haskell gives nice highlighting
autorest foo\readme.md --azure-validator --fancy-setting=3 --csharp.azure-arm --use=<local copy/variation of autorest.csharp> --csharp.debugger
```

The call to `autorest.csharp.dll` will be suspended until a debugger is attached to the `dotnet` process.
It will print something like `Waiting for debugger to attach to process <PID>.......` to the console.
Specifying `use` to run `autorest.csharp` from a local directory is important in order for VSCode to find the sources.
Open this directory in VSCode, launch the `.NET Core Attach` configuration and select the PID from the list.
The debugging session will begin paused in a location *prior* to any of your code running, i.e. set breakpoints and hit "Continue"/F5.
Happy debugging!

## Further resources

The following resources may be useful to understand some concepts found among those generators.

- [`CodeModel` and the Language-specific Generator/Transformer/Namer](./architecture/CodeModel-and-the-Language-specific-Generator-Transformer-Namer.md)
- [`Fixable<T>` -- When a value is both calculated and/or fixed](./architecture/Fixable-T----When-a-value-is-both-calculated-and-or-fixed.md)
- [LODIS -- Least Offensive Dependency Injection System](./architecture/Least-Offensive-Dependency-Injection-System.md)
- [Name Disambiguation](./architecture/Name-Disambiguation.md)
