# Default Configuration - OpenAPI 3 loader

This loads OpenAPI3 documents from the values in the configuration `input-file`.

It requires no normalization, and will pass out the `openapi-document` artifacts.

```yaml !$(cadl)
pipeline:
  openapi-document/loader-openapi:
    scope: perform-load

  openapi-document/individual/transform:
    input: loader-openapi

  openapi-document/individual/schema-validator-openapi:
    input: individual/transform

  openapi-document/individual/full-ref-resolver:
    input: individual/schema-validator-openapi

  openapi-document/individual/identity:
    input: individual/full-ref-resolver
```

# Default Configuration -- OpenAPI2 loader

This loads OpenAPI2 documents from the values in the configuration `input-file`.

It converts the files to OpenAPI3 and processes them to normalization as
`openapi-document` artifacts.

```yaml !$(cadl)
pipeline:
  swagger-document/loader-swagger:
    # plugin: loader # IMPLICIT: default to last item if split by '/'
    output-artifact: swagger-document
    scope: perform-load

  swagger-document/individual/transform:
    input: loader-swagger
    output-artifact: swagger-document

  swagger-document/individual/schema-validator-swagger:
    input: individual/transform
    output-artifact: swagger-document

  swagger-document/individual/full-ref-resolver:
    input: individual/schema-validator-swagger

  swagger-document/individual/identity:
    input: individual/full-ref-resolver
    output-artifact: swagger-document

  #  swagger-document/transform-immediate:
  #    input:
  #    - swagger-document-override/md-override-loader-swagger
  #    - individual/identity
  #    output-artifact: swagger-document

  swagger-document/identity:
    # input: swagger-document/transform-immediate
    input: individual/full-ref-resolver
    output-artifact: swagger-document

  # OpenAPI
  openapi-document/openapi-document-converter:
    input: swagger-document/identity
    # output-artifact: openapi-document
```

```yaml $(cadl)
use-extension:
  "@autorest/cadl": latest
```

## Configuration for `--apply-transforms-in-place`

```yaml $(apply-transforms-in-place)
pipeline:
  openapi-document/individual/save-in-place:
    input: individual/schema-validator-openapi

  swagger-document/individual/save-in-place:
    input: individual/schema-validator-swagger
```
