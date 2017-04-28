# Implicit Configuration
> see https://aka.ms/autorest

##  basic defaults
``` yaml
azure-arm: false    # no special ARM consideratons 
output-folder: $(base-folder)/generated 

```

## Implicit plugins

``` yaml 
swagger-loader:
  consumes: swagger-file
  produces: swagger-document

# when process == merge ?
swagger-composer:
  consumes: swagger-document
  produces: swagger-document

azure-validator:
  consumes: swagger-document
  produces: nothing

model-validator:
  consumes: swagger-document
  produces: nothing

modeler:
  consumes: swagger-document
  produces: code-model-v1

csharp:
  consumes: code-model-v1
  produces: c# source files

csharp-simplifier:
  consumes: c# source files
  produces: c# source files
  priority:
    last: true

csharp-compiler:
  consumes: c# source files
  produces: dotnet-binaries

output-artifact:
  - swagger-document
  - c# source files
  - code-model


# csharp
csharp:
  output-artifact: 
    - c# source files
  

## my own file
output-artifact:
  - swagger-document

csharp:
ruby:
python:


```



### Parser
``` yaml
swagger-parser:
#consumes: files
#produces: swaggerdocument
```

### Modeler
``` yaml
#consumes: swaggerdocument
#produces: CodeModelV1
```


### Azure Validator (aka 'the linter')
The Azure Validator is enabled as a plugin when `azure-arm` is set to `true` and can be disabled when `disable-validation` is set to `false`.

``` yaml $(azure-arm)
azure-validator: # enable the azure validator 
#consumes: swaggerdocument
#produces: (nothing)
```
### Model Validator (Amar's Enhnanced Swagger-Tools validation)
The Model Validator is enabled by default, and can be disabled when `disable-validation` is set to `true`.
``` yaml
model-validator: # enable the model validator
#consumes: swaggerdocument
#produces: (nothing)
```

## per-plugin defaults

### azure-validatior

### schema-validator

### csharp
``` yaml
consumes: CodeModelv1
produces: C# Source Files
```

### csharp simplifier
The C# simplifier cleans up c# code.

``` yaml (maybe should end up in package.json)
plugin-name: csharp-simplifier
consumes: C# Source Files
produces: C# Source Files
priority:
  first: false
  last: true
  before: <plugin-name>
  after: <plugin-name>
  priority: 100 

```

``` yaml
fx-cop: 
  after: csharp-simplifier
  
csharp-simplifier:

```

A swagger -> c# 
B c# -> c#

C c# -> c#

D c# -> c#


XXX => YYY => ZZZ

           => AAAA

c# => binaries => signing

c# => binaries => signing 
