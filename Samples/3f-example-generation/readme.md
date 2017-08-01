# Scenario: Sample code generation from x-ms-examples

> see https://aka.ms/autorest

## Input

``` yaml 
input-file:
- https://github.com/Azure/azure-rest-api-specs/blob/53b26d1ed62c7b1958009153cba534b52f17da62/specification/network/resource-manager/Microsoft.Network/2017-06-01/loadBalancer.json
- https://github.com/Azure/azure-rest-api-specs/blob/53b26d1ed62c7b1958009153cba534b52f17da62/specification/network/resource-manager/Microsoft.Network/2017-06-01/network.json
- https://github.com/Azure/azure-rest-api-specs/blob/53b26d1ed62c7b1958009153cba534b52f17da62/specification/network/resource-manager/Microsoft.Network/2017-06-01/networkInterface.json
- https://github.com/Azure/azure-rest-api-specs/blob/53b26d1ed62c7b1958009153cba534b52f17da62/specification/network/resource-manager/Microsoft.Network/2017-06-01/networkSecurityGroup.json
- https://github.com/Azure/azure-rest-api-specs/blob/53b26d1ed62c7b1958009153cba534b52f17da62/specification/network/resource-manager/Microsoft.Network/2017-06-01/networkWatcher.json
- https://github.com/Azure/azure-rest-api-specs/blob/53b26d1ed62c7b1958009153cba534b52f17da62/specification/network/resource-manager/Microsoft.Network/2017-06-01/publicIpAddress.json
```


## Generation

Generate samples instead of REST client code.

``` yaml
sample-generation: true
output-file: combined
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
