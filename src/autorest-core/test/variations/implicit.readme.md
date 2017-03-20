# Implicit Configuration
> see https://aka.ms/autorest

##  basic defaults
``` yaml
azure-arm: false    # no special ARM consideratons 
output-folder: $(base-folder)/generated 

disable-validation: false
```

## Implicit plugins

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

``` yaml $(azure-arm) && !$(disable-validation)
azure-validator: # enable the azure validator 
#consumes: swaggerdocument
#produces: (nothing)
```
### Model Validator (Amar's Enhnanced Swagger-Tools validation)
The Model Validator is enabled by default, and can be disabled when `disable-validation` is set to `true`.
``` yaml !$(disable-validation)
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

``` yaml
priority:
  first: false
  last: true
  before: <plugin-name>
  after: <plugin-name>

consumes: C# Source Files
produces: C# Source Files

```
