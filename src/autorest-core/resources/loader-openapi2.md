# Default Configuration -- OpenAPI2 loader

This loads OpenAPI2 documents from the values in the configuration `input-file`.

It converts the files to OpenAPI3 and processes them to normalization as
`openapi-document` artifacts.


``` yaml
pipeline:
  swagger-document/loader-swagger:
    # plugin: loader # IMPLICIT: default to last item if split by '/'
    output-artifact: swagger-document
    scope: perform-load
  swagger-document/individual/transform:
    input: loader-swagger
    output-artifact: swagger-document
  swagger-document/individual/schema-validator-swagger:
    input: transform
    output-artifact: swagger-document
  swagger-document/individual/identity:
    input: schema-validator-swagger
    output-artifact: swagger-document

  swagger-document/compose: # merge the files together.
    input: individual/identity
    output-artifact: swagger-document
  swagger-document/transform-immediate:
    input:
    - swagger-document-override/md-override-loader-swagger
    - compose
    output-artifact: swagger-document
  swagger-document/transform:
    input: transform-immediate
    output-artifact: swagger-document
  swagger-document/identity:
    input: transform
    output-artifact: swagger-document
  swagger-document/emitter:
    input: identity
    scope: scope-swagger-document/emitter
  # OpenAPI
  openapi-document/openapi-document-converter:
    input: swagger-document/identity
    output-artifact: openapi-document
```
