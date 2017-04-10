# Scenario: Supressing a validation message

> see https://aka.ms/autorest

## Inputs

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/master/arm-storage/2015-06-15/swagger/storage.json
```

## Validation

``` yaml
azure-arm: true
```

## Suppression

``` yaml
directive:
  - suppress: M3018
    from: storage.json
    where: $.definitions.CustomDomain
    reason: We really want that boolean property there or our customers will go nuts.
```