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

``` yaml $(azureresourceschema)
use-extension:
  "@microsoft.azure/autorest.azureresourceschema": "~2.0.0"
```

``` yaml $(csharp)
use-extension:
  "@microsoft.azure/autorest.csharp": "~2.0.0"
```

``` yaml $(jsonrpcclient)
use-extension:
  "@microsoft.azure/autorest.csharp": "~2.0.0"
```

``` yaml $(go)
use-extension:
  "@microsoft.azure/autorest.go": "~2.0.0"
```

``` yaml $(java)
use-extension:
  "@microsoft.azure/autorest.java": "~2.0.0"
```

``` yaml $(nodejs)
use-extension:
  "@microsoft.azure/autorest.nodejs": "~2.0.0"
```

``` yaml $(php)
use-extension:
  "@microsoft.azure/autorest.php": "~2.0.0"
```

``` yaml $(python)
use-extension:
  "@microsoft.azure/autorest.python": "~2.0.0"
```

``` yaml $(ruby)
use-extension:
  "@microsoft.azure/autorest.ruby": "~2.0.0"
```

``` yaml $(azure-validator)
use-extension:
  "@microsoft.azure/classic-openapi-validator": "~1.0.3"
  "@microsoft.azure/openapi-validator": "~1.0.0"
```

``` yaml $(typescript)
use-extension:
  "@microsoft.azure/autorest.typescript": "~2.0.0"
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

#### Polyfills

Support for `additionalProperties: true/false` in `definitions` section

``` yaml
directive:
- from: swagger-document
  where: $.definitions.*.additionalProperties
  transform: |
    return typeof $ === "boolean"
      ? ($ ? { type: "object" } : undefined)
      : $
  reason: polyfill
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

# Directives

The built-in `transform` directive with its filters `from` and `where` are very powerful, but can become verbose and thus hard to reuse for common patterns (e.g. rename an operation).
Furthermore, they usually rely on precise data formats (e.g. where to find operations in the `code-model-v1`) and thus break once the data format changes.
We propose the following mechanism of declaring directives similar to macros, which allows capturing commonly used directives in a more high-level way.
Configuration files using these macros instead of "low-level" directives are robust against changes in the data format as the declaration in here will be adjusted accordingly.

## How it works

A declaration such as

``` yaml false
declare-directive:
  my-directive: >-
    [
      {
        transform: `some transformer, parameterized with '${JSON.stringify($)}'`
      },
      {
        from: "code-model-v1"
        transform: `some other transformer, parameterized with '${JSON.stringify($)}'`
      }
    ]
```

can be used by naming it in a `directive` section:

``` yaml false
directive:
  - my-directive: # as a standalone, with an object as parameter
      foo: bar
      baz: 42
  - from: a
    where: b
    my-directive: 42 # together with other stuff, with a number as parameter
```

Each `directive` entry that names `my-directive` will be expanded with the whatever the declaration evaluates to, where `$` is substituted with the value provided to the directive when used.
If the declaration evaluates to an array, the directives are duplicated accordingly (this enables directive declarations that transform data on multiple stages).
In the above example, `directive` gets expanded to:

``` yaml false
directive:
  - transform: >-
      some transformer, parameterized with '{ "foo": \"bar\", "baz": 42 }'
  - from: code-model-v1
    transform: >-
      some other transformer, parameterized with '{ "foo": \"bar\", "baz": 42 }'
  - from: a
    where: b
    transform: >-
      some transformer, parameterized with '42'
  - from: a
    where: b
    transform: >-
      some other transformer, parameterized with '42'
```

As can be seen in the last `directive`, `from` as specified originally was not overridden by `code-model-v1`, i.e. what was specified by the user is given higher priority.


## `set`

Formerly implemented in the AutoRest core itself, `set` is now just syntactic sugar.

``` yaml
declare-directive:
  set: >-
    { transform: `return ${JSON.stringify($)}` };
```