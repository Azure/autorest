# Default Configuration - Typescript

The V2 version of the Typescript Generator.

``` yaml $(typescript) && $(preview) && !isRequested('@autorest/typescript')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: 2.0.4413

use-extension:
  "@microsoft.azure/autorest.typescript": "preview"
try-require: ./readme.typescript.md
```

``` yaml $(typescript) && !isRequested('@autorest/typescript')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: 2.0.4413

use-extension:
  "@microsoft.azure/autorest.typescript": "~4.2.0"
try-require: ./readme.typescript.md
```

