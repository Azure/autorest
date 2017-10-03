# Remove certain methods from the pipeline

In other words, neither validate them nor generate code.

> see https://aka.ms/autorest

``` yaml 
input-file: remove-methods.yaml
csharp: true
clear-output-folder: true
batch:
  - 
    # Regular run
    output-folder: Client
  - 
    # Hide method
    output-folder: ClientFancy
    # add the following directive to your configuration to hide method `Cowbell_Add`
    directive:
      from: swagger-document
      where: $.paths.*[?(@.operationId == "Cowbell_Add")]
      transform: return undefined
    output-artifact: swagger-document.yaml
```

The directive finds method `Cowbell_Add` and removes the corresponding object graph from the Swagger representation.