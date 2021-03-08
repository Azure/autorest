# Default Configuration - TypeScript

The V3 version of the Typescript Generator.

``` yaml $(typescript) && !$(legacy) && !$(v2) && !isRequested('@microsoft.azure/autorest.typescript')
version: ~3.1.0

use-extension:
  "@autorest/typescript": "latest"
try-require: ./readme.typescript.md
```

Enable use of the V2 TypeScript generator (and V2 core) with the `--legacy` or `--v2` parameter:

``` yaml $(typescript) && ($(legacy) || $(v2) || isRequested('@microsoft.azure/autorest.typescript'))
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.typescript": "~4.4.4"
try-require: ./readme.typescript.md
```

