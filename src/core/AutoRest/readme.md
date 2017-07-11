# AutoRest Classic

Provides first generation, .NET based modeler and code generators.

## Validation

``` yaml
pipeline:
  swagger-document/azure-validator:
    input: swagger-document/identity
    scope: azure-validator-composed
  swagger-document/individual/azure-validator:
    input: swagger-document/individual/identity
    scope: azure-validator-individual
```

## PHP

``` yaml
pipeline:
  php/modeler:
    input: swagger-document/identity
    output-artifact: code-model-v1
    scope: php
  php/generate:
    plugin: php
    input: 
      - swagger-document/identity
      - modeler
    output-artifact: source-file-php
  php/emitter:
    input: generate
    scope: scope-php/emitter

scope-php/emitter:
  input-artifact: source-file-php
  output-uri-expr: $key.split("/output/")[1]

output-artifact:
- source-file-php
```


## C#

``` yaml
pipeline:
  csharp/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## Go

``` yaml
pipeline:
  go/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## Java

``` yaml
pipeline:
  java/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## Python

``` yaml
pipeline:
  python/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## Node JS

``` yaml
pipeline:
  nodejs/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## Ruby

``` yaml
pipeline:
  ruby/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## Azure Resource Schema

``` yaml
pipeline:
  azureresourceschema/modeler:
    input: swagger-document/identity
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
      - swagger-document/identity
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

## JSON-RPC client

``` yaml
pipeline:
  jsonrpcclient/modeler:
    input: swagger-document/identity
    output-artifact: code-model-v1
    scope: jsonrpcclient
  jsonrpcclient/generate:
    plugin: jsonrpcclient
    input: 
      - swagger-document/identity
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
