# Default Configuration - Azure Resource Schema Generator

The Azure Resource Schema Generator will generate Azure Resource Schemas for use with Resource Templates.

``` yaml $(azureresourceschema) && $(preview)
use-extension:
  "@microsoft.azure/autorest.azureresourceschema": "v3"
try-require: ./readme.azureresourceschema.md
```

``` yaml $(azureresourceschema)
enable-multi-api: true

use-extension:
  "@microsoft.azure/autorest.azureresourceschema": "v3"
try-require: ./readme.azureresourceschema.md


```