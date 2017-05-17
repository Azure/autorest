# Scenario: Validate a OpenAPI definition file according to the ARM guidelines 

> see https://aka.ms/autorest

## Inputs

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/d374d03801e97737ddb32e01f20513e7b2bbd9c3/arm-storage/2015-06-15/swagger/storage.json
```

## Validation

This time, we not only want to generate code, we also want to validate.

``` yaml
azure-validator: true # Azure specific validation
model-validator: true # validation of examples against the API definition
semantic-validator: true # general semantic checks such as: Does the specified `default` value actually have the type specified for the corresponding field?
```

## Generation

Also generate for some languages.

``` yaml 
azure-arm: true # generate code using Azure ARM flavor
csharp:
  output-folder: CSharp
java:
  output-folder: Java
nodejs:
  output-folder: NodeJS
python:
  output-folder: Python
ruby:
  output-folder: Ruby
```
