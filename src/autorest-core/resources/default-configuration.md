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

## Output Artifacts

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