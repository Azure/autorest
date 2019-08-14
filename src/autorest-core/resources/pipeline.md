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
    
  openapi-document/components-cleaner:
    input: multi-api-merger
    output-artifact: openapi-document

  openapi-document/component-modifiers:
    input: components-cleaner
    output-artifact: openapi-document

  openapi-document/api-version-parameter-handler:
    input: component-modifiers
    output-artifact: openapi-document

  openapi-document/profile-filter:
    input: api-version-parameter-handler
    output-artifact: openapi-document

  openapi-document/model-deduplicator:
    input: profile-filter
    output-artifact: openapi-document   

  openapi-document/emitter:
    input: profile-filter
    input-artifact: profile-filter-log 
```


``` yaml $(pipeline-model) == 'v3'
pipeline:

  openapi-document/enum-deduplicator:
    input: model-deduplicator
    output-artifact: openapi-document

  openapi-document/subset-reducer:
    input: enum-deduplicator
    output-artifact: openapi-document

  openapi-document/quick-check:
    input: subset-reducer
    output-artifact: openapi-document

  openapi-document/multi-api/identity:
    input: subset-reducer
    output-artifact: openapi-document

  openapi-document/multi-api/emitter:
    input: openapi-document/multi-api/identity
    scope: scope-openapi-document/emitter
```

# Default Configuration - Single API Version Pipeline

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

The final step is the `openapi-document/identity`, which is the pipeline input
for Single-API version generators (ie, based using `imodeler1` ).
 

``` yaml !$(pipeline-model) || $(pipeline-model) == 'v2'
pipeline:
  openapi-document/compose:
    input: openapi-document/model-deduplicator # just before deduplication.
    output-artifact: openapi-document

  openapi-document/identity:
    input: compose
    output-artifact: openapi-document

  openapi-document/emitter:
    input: openapi-document/identity
    scope: scope-openapi-document/emitter

# todo/hack: not sure what this is here for,
scope-swagger-document/emitter:
  input-artifact: swagger-document
  is-object: true
  # rethink that output-file part
  output-uri-expr: |
    $config["output-file"] ||
    ($config.namespace ? $config.namespace.replace(/:/g,'_') : undefined) ||
    $config["input-file"][0].split('/').reverse()[0].split('\\').reverse()[0].replace(/\.json$/, "")
```

# Default Configuration - Tree Shaker

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

``` yaml
pipeline:
  openapi-document/transform:
    input:
      - openapi-document/openapi-document-converter	          # openapi-document/openapi-document-converter comes from the OAI2 loader
      - openapi-document/transform-immediate                  # openapi-document/transform-immediate comes from the OAI3 loader
    output-artifact: openapi-document

  openapi-document/tree-shaker:
    input: openapi-document/transform
    output-artifact: openapi-document

```