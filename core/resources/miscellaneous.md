
# Default Configuration - Configuration Bits...

Some kind of last-second tweaking to output the openapi document as a file?
If someone really needs to know what this is all about, ask @olydis (find him on github...)


``` yaml
scope-openapi-document/emitter:
  input-artifact: openapi-document
  is-object: true
  # rethink that output-file part
  output-uri-expr: |
    $config["output-file"] ||
    ($config.namespace ? $config.namespace.replace(/:/g,'_') : undefined) ||
    $config["input-file"][0].split('/').reverse()[0].split('\\').reverse()[0].replace(/\.json$/, "")


scope-swagger-document/emitter:
  input-artifact: swagger-document
  is-object: true
  # rethink that output-file part
  output-uri-expr: |
    $config["output-file"] || 
    ($config.namespace ? $config.namespace.replace(/:/g,'_') : undefined) || 
    $config["input-file"][0].split('/').reverse()[0].split('\\').reverse()[0].replace(/\.json$/, "")    

```

This is a 'legacy' bit ... really not sure what this is for.
Doesn't seem all that dangerous either way, so I'll leave this here.
If someone really needs to know what this is all about, ask @olydis (find him on github...)

``` yaml
scope-cm/emitter: # can remove once every generator depends on recent modeler
  input-artifact: code-model-v1
  is-object: true
  output-uri-expr: |
    "code-model-v1"
```

Any files that are marked as 'preserved-files' are output back to disk again.

``` yaml
# preserve files that have been asked to preserve
output-artifact:
  - preserved-files
  - binary-file
```


## Autorest Interactive
``` yaml $(interactive) 
use-extension:
  "@microsoft.azure/autorest-interactive": "latest"
```

### remove additionalProperties:false for v2 generators
``` yaml
directive:
- from: swagger-document
  where: $..*[?(@.additionalProperties===false)]
  transform: delete $.additionalProperties

```