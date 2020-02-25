# Default Configuration - Azure Resource Schema Generator

The Azure Resource Schema Generator will generate Azure Resource Schemas for use with Resource Templates.

``` yaml $(azureresourceschema) && !isLoaded('@autorest/azureresourceschema')
use-extension:
  "@autorest/azureresourceschema": "~3.0.45"
try-require: ./readme.azureresourceschema.md

```