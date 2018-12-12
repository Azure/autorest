# Default Configuration - Multi API Version Pipeline

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

The final step is the `openapi-document/multi-api/identity`, which is the pipeline input
for Multi-API version generators (ie, based using `imodeler2` ).

Avoiding conflicts is done thru additional metadata specified in the
`x-ms-metadata` extension node.



``` yaml
pipeline:
  openapi-document/multi-api-merger:
    input: tree-shaker
    output-artifact: openapi-document

  openapi-document/component-modifiers:
    input: multi-api-merger
    output-artifact: openapi-document

  openapi-document/api-version-parameter-handler:
    input: component-modifiers
    output-artifact: openapi-document

  openapi-document/model-deduplicator:
    input: api-version-parameter-handler
    output-artifact: openapi-document

  openapi-document/component-key-renamer:
    input: model-deduplicator
    output-artifact: openapi-document

  openapi-document/multi-api/identity:
    input: component-key-renamer
    output-artifact: openapi-document

  openapi-document/multi-api/emitter:
    input: openapi-document/multi-api/identity
    scope: scope-openapi-document/emitter

```