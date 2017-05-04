# Default Configuration

This configuration applies to every run of AutoRest, but with less priority than any other specified configuration (i.e. it is overridable).

## Basic

``` yaml
azure-arm: false
output-folder: generated
```

## Pipeline

### Standard Plugins

Schema:

```
plugins:
  swagger-loader:
    input-artifact?: string  # no input artifact means no dependencies, i.e. runnable immediately
    output-artifact?: string # no output artifact could make perfect sense for CLIs, inspection, etc.
```

``` yaml
plugins:
  swagger-loader: 42
```

### Graph

#### Loading

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
  swagger-document/transform:
    input: compose
    output-artifact: swagger-document
  swagger-document/emitter:
    input: transform
    scope: emit-swagger-document

emit-swagger-document:
  input-artifact: swagger-document
  is-object: true
  # rethink that output-file part
  output-uri-expr: |
    $config["output-file"] || 
    $config.namespace || 
    $config["input-file"][0].split('/').reverse()[0].split('\\').reverse()[0].replace(/\.json$/, "")
emit-code-model-v1:
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
  swagger-document/azure-validator:
    input: transform
    scope: azure-validator
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-csharp

emit-source-file-csharp:
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-go

emit-source-file-go:
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-java

emit-source-file-java:
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-python

emit-source-file-python:
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-nodejs

emit-source-file-nodejs:
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-ruby

emit-source-file-ruby:
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
    scope: emit-code-model-v1
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
    scope: emit-source-file-azureresourceschema

emit-source-file-azureresourceschema:
  input-artifact: source-file-azureresourceschema
  output-uri-expr: $key.split("/output/")[1]
output-artifact:
- source-file-azureresourceschema
```

# Validation

## Client Side Validation

On by default for backwards compatibility, but see https://github.com/Azure/autorest/issues/2100

``` yaml
client-side-validation: true
```

## Azure Validation

Activate `azure-validator` when setting `azure-arm`!?

``` yaml $(azure-arm)
azure-validator: true
```
