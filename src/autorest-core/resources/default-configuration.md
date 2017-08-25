# Default Configuration

This configuration applies to every run of AutoRest, but with less priority than any other specified configuration (i.e. it is overridable).

## Basic

``` yaml
azure-arm: false
output-folder: generated
openapi-type: arm
```

## Pipeline

### External Plugins

``` yaml
use-extension:
  "@microsoft.azure/autorest.azureresourceschema": "*"
  "@microsoft.azure/autorest.csharp": "*"
  "@microsoft.azure/autorest.go": "*"
  "@microsoft.azure/autorest.java": "*"
  "@microsoft.azure/autorest.nodejs": "*"
  "@microsoft.azure/autorest.php": "*"
  "@microsoft.azure/autorest.python": "*"
  "@microsoft.azure/autorest.ruby": "*"
  "@microsoft.azure/classic-openapi-validator": ">=0.0.6-preview"
  "@microsoft.azure/openapi-validator": ">=0.1.2-preview"
```    

### Graph

#### Reflection

##### Pipeline

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

##### Configuration

``` yaml
pipeline:
  configuration-emitter: # emits the pipeline graph
    scope: scope-configuration-emitter

scope-configuration-emitter:
  input-artifact: configuration
  is-object: true
  output-uri-expr: |
    "configuration"
```

#### Loading

Markdown documentation overrides:

``` yaml
pipeline:
  swagger-document-override/md-override-loader:
    output-artifact: immediate-config
```

OpenAPI definitions:

``` yaml
pipeline:
  swagger-document/loader:
    # plugin: loader # IMPLICIT: default to last item if split by '/'
    output-artifact: swagger-document
  swagger-document/individual/transform:
    input: loader
    output-artifact: swagger-document
  swagger-document/individual/identity:
    input: transform
    output-artifact: swagger-document
  swagger-document/compose:
    input: individual/identity
    output-artifact: swagger-document
  swagger-document/transform-immediate:
    input:
    - swagger-document-override/md-override-loader
    - compose
    output-artifact: swagger-document
  swagger-document/transform:
    input: transform-immediate
    output-artifact: swagger-document
  swagger-document/identity:
    input: transform
    output-artifact: swagger-document
  swagger-document/emitter:
    input: transform
    scope: scope-swagger-document/emitter

scope-swagger-document/emitter:
  input-artifact: swagger-document
  is-object: true
  # rethink that output-file part
  output-uri-expr: |
    $config["output-file"] || 
    ($config.namespace ? $config.namespace.replace(/:/g,'_') : undefined) || 
    $config["input-file"][0].split('/').reverse()[0].split('\\').reverse()[0].replace(/\.json$/, "")
scope-cm/emitter:
  input-artifact: code-model-v1
  is-object: true
  output-uri-expr: |
    "code-model-v1"
```

#### Validation

``` yaml
pipeline:
  swagger-document/model-validator:
    input: swagger-document/identity
    scope: model-validator
  swagger-document/semantic-validator:
    input: swagger-document/identity
    scope: semantic-validator
```

# Validation

## Client Side Validation

On by default for backwards compatibility, but see https://github.com/Azure/autorest/issues/2100

``` yaml
client-side-validation: true
```
