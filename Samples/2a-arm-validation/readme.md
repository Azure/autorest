# Scenario: Validate a Swagger file according to the ARM guidelines 

> see https://aka.ms/autorest

## Inputs

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/master/arm-storage/2015-06-15/swagger/storage.json
```

## Validation

This time, we do not want to generate any code.

``` yaml
azure-arm: true # enables validation messages
```