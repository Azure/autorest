# Default Configuration - NodeJS

The V2 version of the NodeJS Generator.


``` yaml $(nodejs) && $(preview) && !isRequested('@autorest/nodejs')
use-extension:
  "@microsoft.azure/autorest.nodejs": "preview"
try-require: ./readme.nodejs.md
```

``` yaml $(nodejs) && !isRequested('@autorest/nodejs')
use-extension:
  "@microsoft.azure/autorest.nodejs": "~2.1.25"
try-require: ./readme.nodejs.md
```