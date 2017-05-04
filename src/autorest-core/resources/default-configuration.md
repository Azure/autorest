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

### Emitters

``` yaml
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
emit-source-file-csharp:
  input-artifact: source-file-csharp
  output-uri-expr: $key.split("/output/")[1]
emit-source-file-ruby:
  input-artifact: source-file-ruby
  output-uri-expr: $key.split("/output/")[1]
emit-source-file-nodejs:
  input-artifact: source-file-nodejs
  output-uri-expr: $key.split("/output/")[1]
emit-source-file-python:
  input-artifact: source-file-python
  output-uri-expr: $key.split("/output/")[1]
emit-source-file-go:
  input-artifact: source-file-go
  output-uri-expr: $key.split("/output/")[1]
emit-source-file-java:
  input-artifact: source-file-java
  output-uri-expr: $key.split("/output/")[1]
emit-source-file-azureresourceschema:
  input-artifact: source-file-azureresourceschema
  output-uri-expr: $key.split("/output/")[1]
```

### Output Artifacts

What to write out.

``` yaml
output-artifact:
- source-file-csharp
- source-file-ruby
- source-file-nodejs
- source-file-python
- source-file-go
- source-file-java
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