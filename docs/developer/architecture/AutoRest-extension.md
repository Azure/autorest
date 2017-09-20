# AutoRest Extensibility

AutoRest can dynamically acquire and use extensions that follow the protocol specified here.

## Terminology and Basics

*AutoRest Plugin*.
A plugin implements some operation on some set of input documents.
It may generate output documents and messages.
Examples: validation, merging OpenAPI definitions, generating code

*AutoRest Extension*.
A program hosting a set of AutoRest plugins.
As it is probably the most platform agnostic way of doing inter-process communication, AutoRest uses only `stdin`/`stdout` to communicate with its extensions using JsonRPC.
The extension runs in "server mode", i.e. it will receive commands (like plugin invocation) via JsonRPC.
An error during such an invocation should not terminate the extension.
AutoRest terminates the process when appropriate.
Multiple invocations can happen in parallel.

*JsonRPC*.
[The protocol](AutoRest-extension-protocol.md) used to communicate between AutoRest and loaded extensions.
We use [a variation](https://github.com/Microsoft/language-server-protocol/blob/master/protocol.md#base-protocol) of the [original protocol](http://www.jsonrpc.org/specification) (sends `Content-Length` header before sending a payload).


## Packaging

An AutoRest package must be an `npm` package.
Note that it must not necessarily be *published* as an `npm` package - any source supported by npm is supported by AutoRest, including git repositories, `.tgz` files and even local folders.

The `package.json` file needs to have a `start` script that, when executed, launches the extension. Example:

``` json
"scripts": {
  "start": "dotnet ./bin/netcoreapp1.0/AutoRest.dll --server"
}
```

Any runtimes required for execution (above: dotnet) should be provided as dependencies (these will be installed by AutoRest), so the extension works out of the box on anyones machine.

## Usage

Using an extension is again inspired by the way `npm` packages are referenced.
In the configuration file, reference the AutoRest extension packages in a `use-extension` section.
The syntax is the same as the syntax of `npm` package dependencies.
Example:

``` yaml
use-extension:
  # published npm package
  "@microsoft.azure/openapi-validator": "~1.0.0"
  # GitHub repository
  autorest-interactive: https://github.com/olydis/autorest-interactive
  # tgz package file
  swift-generator: https://github.com/Azure/autorest-swift-generator/releases/download/2.1.0/autorest-swift-generator-2.1.0.tgz
  # local package
  myTestPlugin: C:\work\myTestPlugin
```
