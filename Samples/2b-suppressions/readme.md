# Scenario: Supressing a validation message

> see https://aka.ms/autorest

## Inputs

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
```

## Validation

``` yaml
azure-validator: true
```

## Suppression

``` yaml
directive:
  - suppress: M3018
    from: storage.json
    where: $.definitions.CustomDomain
    reason: We really want that boolean property there or our customers will go nuts.
```
