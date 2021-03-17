# Inspect Configuration (extended pipeline)


``` yaml $(inspector)
pipeline-model: v3
inspector:
  output-folder: inspector

pipeline:
  inspector:
    null: true

  inspector/oai2-loaded/reset-identity:
    input:
      - swagger-document/loader-swagger
      - inspector

    to: inspect-document
    name: oai2.loaded.json

  inspector/oai3-loaded/reset-identity:
    input:
      - openapi-document/loader-openapi
      - inspector

    to: inspect-document
    name: oai3.loaded.json

  inspector/deduplicated/reset-identity:
    input:
      - openapi-document/model-deduplicator
      - inspector

    to: inspect-document

  inspector/tree-shaken/reset-identity:
    input:
      - openapi-document/tree-shaker
      - inspector

    to: inspect-document

  inspector/subset-reduced/reset-identity:
    input:
      - openapi-document/subset-reducer
      - inspector

    to: inspect-document

  inspector/openapi3/reset-identity:
    input:
      - openapi-document/multi-api/identity
      - inspector

    to: inspect-document

  inspector/emitter:
    input:
      - inspector/oai2-loaded/reset-identity
      - inspector/oai3-loaded/reset-identity
      - inspector/tree-shaken/reset-identity
      - inspector/deduplicated/reset-identity
      - inspector/subset-reduced/reset-identity
      - inspector/openapi3/reset-identity
    is-object: true

output-artifact: inspect-document

```

``` yaml $(output-oai3)
pipeline-model: v3

pipeline:
  oai3/reset-identity:
    input: openapi-document/multi-api/identity
    to: oai3-document

  oai3/emitter:
    input: oai3/reset-identity
    is-object: true

output-artifact: oai3-document

```
