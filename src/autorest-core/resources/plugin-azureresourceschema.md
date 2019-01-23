# Default Configuration - Azure Resource Schema Generator

The Azure Resource Schema Generator will generate Azure Resource Schemas for use with Resource Templates.

``` yaml $(azureresourceschema) && $(preview)
use-extension:
  "@microsoft.azure/autorest.azureresourceschema": "preview"
try-require: ./readme.azureresourceschema.md
```

``` yaml $(azureresourceschema)
enable-multi-api: true

use-extension:
  "@microsoft.azure/autorest.azureresourceschema": "~2.0.14"
try-require: ./readme.azureresourceschema.md


```