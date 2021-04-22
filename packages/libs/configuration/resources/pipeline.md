# Default Configuration - Multi API Version Pipeline

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

The final step is the `openapi-document/multi-api/identity`, which is the pipeline input
for Multi-API version generators (ie, based using `imodeler2` ).

Avoiding conflicts is done thru additional metadata specified in the
`x-ms-metadata` extension node.

```yaml
pipeline:
  openapi-document/multi-api-merger:
    input: tree-shaker
    # output-artifact: openapi-document

  openapi-document/components-cleaner:
    input: multi-api-merger
    # output-artifact: openapi-document

  openapi-document/component-modifiers:
    input: components-cleaner
    # output-artifact: openapi-document

  openapi-document/api-version-parameter-handler:
    input: component-modifiers
    # output-artifact: openapi-document

  openapi-document/profile-filter:
    input: api-version-parameter-handler
    #output-artifact: openapi-document

  openapi-document/model-deduplicator:
    input: profile-filter
    # output-artifact: openapi-document

  openapi-document/emitter:
    input: profile-filter
    input-artifact: profile-filter-log
```

```yaml $(pipeline-model) == 'v3'
pass-thru:
  - api-version-parameter-handler

pipeline:
  openapi-document/enum-deduplicator:
    input: model-deduplicator

  openapi-document/subset-reducer:
    input: enum-deduplicator

  openapi-document/quick-check:
    input: subset-reducer

  openapi-document/multi-api/reset-identity:
    input: subset-reducer
    to: openapi-document
    name: openapi-document.json

  openapi-document/multi-api/identity:
    input: reset-identity

  openapi-document/multi-api/emitter:
    input: openapi-document/multi-api/identity
    input-artifact: openapi-document
    is-object: true
```

# Default Configuration - Single API Version Pipeline

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

The final step is the `openapi-document/identity`, which is the pipeline input
for Single-API version generators (ie, based using `imodeler1` ).

```yaml !$(pipeline-model) || $(pipeline-model) == 'v2'
pipeline:
  openapi-document/compose:
    input: openapi-document/model-deduplicator # just before deduplication.
    # output-artifact: openapi-document

  openapi-document/identity:
    input: compose
    # output-artifact: openapi-document

  openapi-document/emitter:
    input: openapi-document/identity
    scope: scope-openapi-document/emitter

# todo/hack: not sure what this is here for,
scope-openapi-document/emitter:
  input-artifact: openapi-document
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

```yaml
pipeline:
  openapi-document/transform:
    input:
      - openapi-document/openapi-document-converter # openapi-document/openapi-document-converter comes from the OAI2 loader
      - openapi-document/individual/identity # openapi-document/individual/identity comes from the OAI3 loader

  openapi-document/semantic-validator:
    input: openapi-document/transform

  openapi-document/allof-cleaner:
    input: openapi-document/semantic-validator

  openapi-document/tree-shaker:
    input: openapi-document/allof-cleaner
```

### Default configuration: Output Converted Openapi

```yaml $(output-converted-oai3)
pipeline:
  converted-oai3/normalize-identity:
    input: openapi-document/transform
    to: converted-oai3-document

  converted-oai3/emitter:
    input: converted-oai3/normalize-identity
    is-object: true

output-artifact: converted-oai3-document
```

### Output stats

```yaml $(stats)
# Collect stats steps
pipeline:
  #  Collect from individual openapi document.
  openapi-document/openapi-stats-collector:
    input: openapi-document/transform

output-artifact:
  - stats.json
```
