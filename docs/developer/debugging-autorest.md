# Debugging AutoRest

Since AutoRest is a combination of multiple components that work together, it is important to distinguish between them in order to choose the correct debugging strategy.
See [AutoRest Fundamentals](./architecture/AutoRest-fundamentals.md) for information about the architecture.

## Debugging the core

The core is written in TypeScript, is the main entry point (`src/autorest-core/app.ts`) and can hence be debugged regularly using VS Code, corresponding launch scripts are predefined.

## Debugging a classic generator

The first generation of AutoRest generators were written in C#, resulting in the `AutoRest.dll` which now merely serves as one of many [extensions](./architecture/AutoRest-extension.md) to the AutoRest core.
This extension is not usable or invokable as a stand-alone since it relies on previous processing steps either done by other extensions or by the AutoRest core.

As a result, debugging the extension also requires it to be launched *through the core* like in a regular invocation of AutoRest (on the bright side, one can stay on the CLI and run exactly the command that exposes the problem to debug).
One can then attach to the running extension process (`dotnet AutoRest.dll --server`) through VS Code, there is a launch configuration for that.
The biggest problem is timing, i.e. attaching and having breakpoints in place before execution has passed the critical point.

For this purpose, we introduced the `--debugger` flag which will cause any call to `AutoRest.dll` to *sit and wait* until a debugger is attached.

### Example

Assume there is a bug in C# code generation when running:

```haskell
autorest foo\readme.md --azure-validator --fancy-setting=3 --csharp.azure-arm
```

Simply call:

```haskell
autorest foo\readme.md --azure-validator --fancy-setting=3 --csharp.azure-arm --debugger
```

In this case, the modeler and the C# generator exposed by `AutoRest.dll` are called.
Both of these calls will be suspended until a debugger is attached to the `dotnet` process.
It will print something like `Waiting for debugger to attach.......` to the console.
Happy debugging!