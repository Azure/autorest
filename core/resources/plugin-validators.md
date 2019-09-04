# Default Configuration - Validators

The Azure and Model validators


``` yaml $(azure-validator)
# use-extension:
#  "@microsoft.azure/classic-openapi-validator": "~1.0.9"
#  "@microsoft.azure/openapi-validator": "~1.0.2"
```

``` yaml $(model-validator)
#use-extension:
 #"oav": "~0.4.20"
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

On by default for backwards compatibility, but see https://github.com/Azure/autorest/issues/2100

``` yaml
client-side-validation: true
```
