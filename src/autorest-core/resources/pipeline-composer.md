# Default Configuration - Single API Version Pipeline

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

The final step is the `openapi-document/identity`, which is the pipeline input
for Single-API version generators (ie, based using `imodeler1` ).


``` yaml
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