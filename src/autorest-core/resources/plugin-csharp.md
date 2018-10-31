# Default Configuration - CSharp

The V2 version of the C# Generator.

``` yaml $(csharp) && $(preview)
use-extension:
  "@microsoft.azure/autorest.csharp": "preview"
try-require: ./readme.csharp.md
```

``` yaml $(csharp)
use-extension:
  "@microsoft.azure/autorest.csharp": "~2.3.79"
try-require: ./readme.csharp.md
```

``` yaml $(jsonrpcclient)
use-extension:
  "@microsoft.azure/autorest.csharp": "~2.3.79"
```

##### Input API versions (azure-rest-api-specs + C# specific)

``` yaml $(csharp)
pipeline:
  swagger-document/reflect-api-versions-cs: # emits a *.cs file containing information about the API versions involved in this call
    input:
    - identity
    - individual/identity
    - csharp/emitter # ensures delay and C# scope
    scope: reflect-api-versions
  swagger-document/reflect-api-versions-cs/emitter: # emits the pipeline graph
    input: reflect-api-versions-cs
    scope: scope-reflect-api-versions-cs-emitter
```

``` yaml $(csharp)
pipeline:
  openapi-document/reflect-api-versions-cs: # emits a *.cs file containing information about the API versions involved in this call
    input:
    - identity
    - individual/identity
    - csharp/emitter # ensures delay and C# scope
    scope: reflect-api-versions
  openapi-document/reflect-api-versions-cs/emitter: # emits the pipeline graph
    input: reflect-api-versions-cs
    scope: scope-reflect-api-versions-cs-emitter
```


``` yaml
scope-reflect-api-versions-cs-emitter:
  input-artifact: source-file-csharp
  output-uri-expr: $key
```