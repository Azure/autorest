# Default Configuration - NodeJS

The V2 version of the NodeJS Generator.


``` yaml $(nodejs) && $(preview) && !isRequested('@autorest/nodejs')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.nodejs": "preview"
try-require: ./readme.nodejs.md
```

``` yaml $(nodejs) && !isRequested('@autorest/nodejs')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.nodejs": "~2.1.25"
try-require: ./readme.nodejs.md
```