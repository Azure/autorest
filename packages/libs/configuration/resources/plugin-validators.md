# Default Configuration - Validators

The Azure and Model validators


``` yaml $(azure-validator) && !$(v3)
# default the v2 validator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/classic-openapi-validator": "~1.1.5"
  "@microsoft.azure/openapi-validator": "~1.7.0"
```

``` yaml $(azure-validator) && $(v3)
# the v3 validator to using the last stable @microsoft.azure/autorest-core
version: ~3.1.0
use-extension:
  "@microsoft.azure/openapi-validator": "^1.7.0"
```

``` yaml $(model-validator)
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "oav": "~0.4.20"
```


#### Validation

``` yaml
pipeline:
  swagger-document/model-validator:
    input: swagger-document/identity
    scope: model-validator
  swagger-document/semantic-validator:
    input: swagger-document/identity
    scope: semantic-validator
```

``` yaml $(notnow)
pipeline:
  openapi-document/model-validator:
    input: openapi-document/identity
    scope: model-validator
  openapi-document/semantic-validator:
    input: openapi-document/identity
    scope: semantic-validator
```

# Validation

## Client Side Validation

On by default in AutoRest v2 for backwards compatibility, but see https://github.com/Azure/autorest/issues/2100.

``` yaml $(pipeline-model) == 'v2'
client-side-validation: true
```
