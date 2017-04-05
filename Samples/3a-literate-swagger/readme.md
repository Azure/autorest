# Scenario: Literate Swagger

> see https://aka.ms/autorest

This example combines multiple AutoRest features:
- Swagger validation
- Swagger resolution with source map
- client code generation

## Configuration

``` yaml 
input-file: swagger.md
azure-arm: true
output-artifact:
  - swagger-document
  - swagger-document.map
csharp:
  output-folder: Client
```