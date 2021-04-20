# Default Configuration - OpenAPI 3 loader

This loads OpenAPI3 documents from the values in the configuration `input-file`.

It requires no normalization, and will pass out the `openapi-document` artifacts.

```yaml
pipeline:
  openapi-document/loader-openapi:
    scope: perform-load

  openapi-document/individual/transform:
    input: loader-openapi

  openapi-document/individual/schema-validator-openapi:
    input: individual/transform

  openapi-document/individual/identity:
    input: individual/schema-validator-openapi
```

# Default Configuration -- OpenAPI2 loader

This loads OpenAPI2 documents from the values in the configuration `input-file`.

It converts the files to OpenAPI3 and processes them to normalization as
`openapi-document` artifacts.

```yaml
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

  swagger-document/individual/identity:
    input: individual/schema-validator-swagger
    output-artifact: swagger-document

  #  swagger-document/transform-immediate:
  #    input:
  #    - swagger-document-override/md-override-loader-swagger
  #    - individual/identity
  #    output-artifact: swagger-document

  swagger-document/identity:
    # input: swagger-document/transform-immediate
    input: individual/schema-validator-swagger
    output-artifact: swagger-document

  # OpenAPI
  openapi-document/openapi-document-converter:
    input: swagger-document/identity
    # output-artifact: openapi-document
```
