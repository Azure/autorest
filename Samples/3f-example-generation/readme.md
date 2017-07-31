# Scenario: Sample code generation from x-ms-examples

> see https://aka.ms/autorest

## Input

The following OpenAPI definition references 8 examples.

``` yaml 
input-file: https://github.com/Azure/azure-rest-api-specs/blob/087554c4480e144f715fe92f97621ff5603cd907/specification/advisor/resource-manager/Microsoft.Advisor/2016-07-12-preview/advisor.json
```

## Generation

Generate samples instead of REST client code.

``` yaml
sample-generation: true
```

### CSharp

``` yaml 
csharp:
  - output-folder: CSharp
    namespace: CSharpNamespace
  - output-folder: Azure.CSharp
    azure-arm: true
  - output-folder: Azure.CSharp.Fluent
    azure-arm: true
    fluent: true
```

### Go

``` yaml 
go:
  output-folder: Go
```

### Java

``` yaml
java:
- output-folder: Java
  namespace: JavaNamespace
- output-folder: Azure.Java
  azure-arm: true
- output-folder: Azure.Java.Fluent
  azure-arm: true
  fluent: true
```

### NodeJS
``` yaml 
nodejs:
  - output-folder: NodeJS
  - output-folder: Azure.NodeJS
    azure-arm: true
```

### Python
``` yaml 
pyhton:
  - output-folder: Python
  - output-folder: Azure.Python
    azure-arm: true
```

### Ruby
``` yaml 
ruby:
  - output-folder: Ruby
  - output-folder: Azure.Ruby
    azure-arm: true
```
