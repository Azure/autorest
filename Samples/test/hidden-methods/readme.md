# Hide certain methods from the end user

> see https://aka.ms/autorest

``` yaml 
input-file: hidden-methods.yaml
output-artifact: code-model-v1.yaml
```

## Regular run

``` yaml
csharp:
  - output-folder: Client
```

## Hide method

``` yaml
csharp:
  - output-folder: ClientFancy
    directive:
      from: code-model-v1
      where-operation: Cowbell_Add
      transform: $.hidden = true
```

The directive activates the `hidden` flag for method `Cowbell_Add`.
As a result, the C# generator will mark associated methods as `internal` which can be useful to hide methods for which a convenience layer was provided.