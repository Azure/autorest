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
plugins:
  fantasy-plugin: 42
```

### Graph

#### Reflection

``` yaml
pipeline:
  pipeline-emitter: # emits the pipeline graph
    scope: scope-pipeline-emitter
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
  swagger-document/compose:
    input: individual/transform
    output-artifact: swagger-document
  swagger-document/transform-immediate:
    input:
    - swagger-document-override/md-override-loader
    - compose
    output-artifact: swagger-document
  swagger-document/transform:
    input: transform-immediate
    output-artifact: swagger-document
  swagger-document/emitter:
    input: transform
    scope: scope-swagger-document/emitter

scope-pipeline-emitter:
  input-artifact: pipeline
  is-object: true
  output-uri-expr: |
    "pipeline"
scope-swagger-document/emitter:
  input-artifact: swagger-document
  is-object: true
  # rethink that output-file part
  output-uri-expr: |
    $config["output-file"] || 
    $config.namespace || 
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
    input: transform
    scope: model-validator
  swagger-document/semantic-validator:
    input: transform
    scope: semantic-validator
```

##### Azure Validator

``` yaml
pipeline:
  # validator written in C#
  swagger-document/azure-validator:
    input: transform
    scope: azure-validator-composed
  swagger-document/individual/azure-validator:
    input: individual/transform
    scope: azure-validator-individual
  # validator written in TypeScript
  swagger-document/azure-openapi-validator:
    input: transform
    scope: azure-validator-composed # same scope as above as it plays side by side with "swagger-document/azure-validator"
  swagger-document/individual/azure-openapi-validator:
    input: transform
    scope: azure-validator-individual # same scope as above as it plays side by side with "swagger-document/individual/azure-validator"
```

Activate `azure-validator` when setting `azure-arm`!?

``` yaml $(azure-arm)
azure-validator: true
```

``` yaml $(azure-validator)
azure-validator-composed:
  merge-state: composed
azure-validator-individual:
  merge-state: individual
```

#### Generation

##### C#

``` yaml
pipeline:
  csharp/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: csharp
  csharp/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  csharp/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  csharp/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  csharp/generate:
    plugin: csharp
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-csharp
  csharp/simplifier:
    plugin: csharp-simplifier
    input: generate
    output-artifact: source-file-csharp
  csharp/transform:
    input: simplifier
    output-artifact: source-file-csharp
  csharp/emitter:
    input: transform
    scope: scope-csharp/emitter

scope-csharp/emitter:
  input-artifact: source-file-csharp
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-csharp
```

##### Go

``` yaml
pipeline:
  go/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: go
  go/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  go/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  go/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  go/generate:
    plugin: go
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-go
  go/transform:
    input: generate
    output-artifact: source-file-go
  go/emitter:
    input: transform
    scope: scope-go/emitter

scope-go/emitter:
  input-artifact: source-file-go
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-go
```

##### Java

``` yaml
pipeline:
  java/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: java
  java/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  java/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  java/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  java/generate:
    plugin: java
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-java
  java/transform:
    input: generate
    output-artifact: source-file-java
  java/emitter:
    input: transform
    scope: scope-java/emitter

scope-java/emitter:
  input-artifact: source-file-java
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-java
```

##### Python

``` yaml
pipeline:
  python/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: python
  python/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  python/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  python/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  python/generate:
    plugin: python
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-python
  python/transform:
    input: generate
    output-artifact: source-file-python
  python/emitter:
    input: transform
    scope: scope-python/emitter

scope-python/emitter:
  input-artifact: source-file-python
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-python
```

##### Node JS

``` yaml
pipeline:
  nodejs/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: nodejs
  nodejs/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  nodejs/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  nodejs/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  nodejs/generate:
    plugin: nodejs
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-nodejs
  nodejs/transform:
    input: generate
    output-artifact: source-file-nodejs
  nodejs/emitter:
    input: transform
    scope: scope-nodejs/emitter

scope-nodejs/emitter:
  input-artifact: source-file-nodejs
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-nodejs
```

##### Ruby

``` yaml
pipeline:
  ruby/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: ruby
  ruby/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  ruby/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  ruby/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  ruby/generate:
    plugin: ruby
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-ruby
  ruby/transform:
    input: generate
    output-artifact: source-file-ruby
  ruby/emitter:
    input: transform
    scope: scope-ruby/emitter

scope-ruby/emitter:
  input-artifact: source-file-ruby
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-ruby
```

##### Azure Resource Schema

``` yaml
pipeline:
  azureresourceschema/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: azureresourceschema
  azureresourceschema/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  azureresourceschema/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  azureresourceschema/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  azureresourceschema/generate:
    plugin: azureresourceschema
    input: 
      - swagger-document/transform
      - cm/transform
    output-artifact: source-file-azureresourceschema
  azureresourceschema/transform:
    input: generate
    output-artifact: source-file-azureresourceschema
  azureresourceschema/emitter:
    input: transform
    scope: scope-azureresourceschema/emitter

scope-azureresourceschema/emitter:
  input-artifact: source-file-azureresourceschema
  output-uri-expr: $key.split("/output/")[1]
output-artifact:
- source-file-azureresourceschema
```

##### JSON-RPC client

``` yaml
pipeline:
  jsonrpcclient/modeler:
    input: swagger-document/transform
    output-artifact: code-model-v1
    scope: jsonrpcclient
  jsonrpcclient/generate:
    plugin: jsonrpcclient
    input: 
      - swagger-document/transform
      - modeler
    output-artifact: source-file-jsonrpcclient
  jsonrpcclient/transform:
    input: generate
    output-artifact: source-file-jsonrpcclient
  jsonrpcclient/emitter:
    input: transform
    scope: scope-jsonrpcclient/emitter

scope-jsonrpcclient/emitter:
  input-artifact: source-file-jsonrpcclient
  output-uri-expr: $key.split("/output/")[1]
output-artifact:
- source-file-jsonrpcclient
```

# Validation

## Client Side Validation

On by default for backwards compatibility, but see https://github.com/Azure/autorest/issues/2100

``` yaml
client-side-validation: true
```
