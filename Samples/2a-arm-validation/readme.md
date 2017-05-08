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
azure-arm: true # enables validation messages
```

## Generation

Also generate for some languages.

``` yaml 
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
