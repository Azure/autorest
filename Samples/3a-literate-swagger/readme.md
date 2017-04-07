# Scenario: Literate OpenAPI definition

> see https://aka.ms/autorest

This example combines multiple AutoRest features:
- OpenAPI definition validation
- OpenAPI definition resolution with source map
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