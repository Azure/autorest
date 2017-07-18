# Scenario: Client generation

> see https://aka.ms/autorest

``` yaml 
input-file: pétstöre.json # full Unicode support

csharp:
  namespace: Petstore
  output-folder: Client
  enable-xml: true                # enable experimental XML serialization support
  # azure-arm: true               # uncomment this line to enable code generation in the Azure flavor
```