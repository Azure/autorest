# Default Configuration - Tree Shaker

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

``` yaml
pipeline:
  openapi-document/transform:
    input:
      - openapi-document/openapi-document-converter	                               # openapi-document/openapi-document-converter comes from the OAI2 loader
      - openapi-document/transform-immediate                                                   # openapi-document/transform-immediate comes from the OAI3 loader
    output-artifact: openapi-document

  openapi-document/tree-shaker:
    input: openapi-document/transform
    output-artifact: openapi-document

```