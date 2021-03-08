# Default Configuration - CSharp

The V2 version of the C# Generator.

``` yaml $(csharp) && !$(legacy) && !$(v2) && !isRequested('@microsoft.azure/autorest.csharp')
version: ~3.1.0

use-extension:
  "@autorest/csharp": "latest"
try-require: ./readme.csharp.md
```

``` yaml $(csharp) && $(preview) && $(legacy) || $(v2) || isRequested('@microsoft.azure/autorest.csharp')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.csharp": "preview"
try-require: ./readme.csharp.md
```

``` yaml $(csharp) && !$(preview) && $(legacy) || $(v2) || isRequested('@microsoft.azure/autorest.csharp')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.csharp": "~2.3.79"
try-require: ./readme.csharp.md
```

``` yaml $(jsonrpcclient) && !isRequested('@autorest/csharp')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.csharp": "~2.3.79"
```

##### Input API versions (azure-rest-api-specs + C# specific)

``` yaml $(csharp) && !isRequested('@autorest/csharp') && ($(legacy) || $(v2))
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

``` yaml $(csharp) && !isRequested('@autorest/csharp') && ($(legacy) || $(v2))
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
