# Scenario: Batching AutoRest calls

> see https://aka.ms/autorest

## Common Settings

The following settings will be used for every task of the batch.

``` yaml
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
```

Batch tasks can also active guards:

``` yaml $(activate-csharp)
csharp:
  azure-arm: true
```

## Batch

The following definition will cause AutoRest to be called multiple times, using the settings of each entry.

``` yaml
batch:
  - activate-csharp: true
    output-folder: output1
  - java: true
    output-folder: output2
  - ruby: true
    # the following input will be added to the existing one
    input-file: https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-advisor/2017-04-19/swagger/advisor.json
    # have to override title since the 2 input files have conflicting ones
    title: ComposedCowbellClient
    # have to remove one of the `Resource` definitions and `securityDefinitions` since descriptions differ
    directive:
      from: advisor.json
      where: $
      transform: |-
        delete $.definitions.Resource;
        delete $.securityDefinitions;
    output-folder: output3
```