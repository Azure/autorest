# Default Configuration

This configuration applies to every run of AutoRest, but with less priority than any other specified configuration (i.e. it is overridable).

## Basic

``` yaml
azure-arm: false
output-folder: generated
disable-validation: false
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
  swagger-loader:
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