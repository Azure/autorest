# Default Configuration - OpenAPI 3 loader

This loads OpenAPI3 documents from the values in the configuration `input-file`.

It requires no normalization, and will pass out the `openapi-document` artifacts.


``` yaml
pipeline:
  openapi-document/loader-openapi:
    # plugin: loader # IMPLICIT: default to last item if split by '/'
    output-artifact: openapi-document
    scope: perform-load
  openapi-document/individual/transform:
    input: loader-openapi
    output-artifact: openapi-document
  openapi-document/individual/schema-validator-openapi:
    input: transform
    output-artifact: openapi-document
  openapi-document/individual/identity:
    input: schema-validator-openapi
    output-artifact: openapi-document
  openapi-document/compose:
    input: individual/identity
    output-artifact: openapi-document
  openapi-document/transform-immediate:
    input:
    - openapi-document-override/md-override-loader-openapi
    - compose
    output-artifact: openapi-document
```
