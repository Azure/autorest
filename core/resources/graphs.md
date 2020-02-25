# Default Configuration - Graph emitters

This has definitions to allow outputing the `Configuration` and `Pipeline` graphs
as an object (instead of serializing them to text)

##### Pipeline Graph

This configures the emitter that will emit the pipeline graph itself.
Used by the autorest-interactive tool to show what the pipeline graph looks like.

``` yaml
pipeline:
  pipeline-emitter: # emits the pipeline graph
    scope: scope-pipeline-emitter

scope-pipeline-emitter:
  input-artifact: pipeline
  is-object: true
  output-uri-expr: |
    "pipeline"
```

##### Configuration Graph

This configures the emitter that will emit the configuration graph itself.
It allows the configuration graph itself to be retrieved.

``` yaml
pipeline:
  configuration-emitter: # emits the configuration graph
    scope: scope-configuration-emitter

scope-configuration-emitter:
  input-artifact: configuration
  is-object: true
  output-uri-expr: |
    "configuration"
```