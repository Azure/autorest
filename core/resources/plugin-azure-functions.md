# Configurations for Azure Functions

The following are configurations for Azure Functions plugins for autorest. For more information about Azure Functions, you can find out at [autorest.azure-functions](https://github.com/Azure/autorest.azure-functions) page.

## Default Configuration - Python

The Azure Functions Python Generator.

``` yaml $(azure-functions-python)
use-extension:
  "@autorest/azure-functions-python": "0.0.1-preview-dev.20200827.2"
```

## Default Configuration - C\#

The Azure Functions C# Generator.

``` yaml $(azure-functions-csharp)
use-extension:
  "autorest/azure-functions-csharp": "0.1.0-dev.187602791"
```

## Default Configuration - Java

The Azure Functions Java Generator.

``` yaml $(azure-functions-java)
use-extension:
  "@autorest/azure-functions-java": "0.0.3-Preview"
```

## Default Configuration - TypeScript

The Azure Functions TypeScript Generator.

``` yaml $(azure-functions-typescript)
use-extension:
  "@autorest/azure-functions-typescript": "0.0.2-preview-dev.20200730.1"
```
