# Default Configuration - Typescript

The V2 version of the Typescript Generator.

``` yaml $(typescript) && $(preview) && !isRequested('@autorest/typescript')
use-extension:
  "@microsoft.azure/autorest.typescript": "preview"
try-require: ./readme.typescript.md
```

``` yaml $(typescript) && !isRequested('@autorest/typescript')
use-extension:
  "@microsoft.azure/autorest.typescript": "~4.2.0"
try-require: ./readme.typescript.md
```

