# Test: Generate metadata about API versions

> see https://aka.ms/autorest

## Inputs

We want metadata from the following files:

``` yaml 
input-file:
  - https://github.com/Azure/azure-rest-api-specs/blob/045c0d0be67cb18e3439f5b7aae9864ace8fab11/specification/compute/resource-manager/Microsoft.Compute/2017-03-30/compute.json
  - https://github.com/Azure/azure-rest-api-specs/blob/045c0d0be67cb18e3439f5b7aae9864ace8fab11/specification/compute/resource-manager/Microsoft.Compute/2017-03-30/disk.json
  - https://github.com/Azure/azure-rest-api-specs/blob/045c0d0be67cb18e3439f5b7aae9864ace8fab11/specification/compute/resource-manager/Microsoft.Compute/2017-03-30/runCommands.json
  - https://github.com/Azure/azure-rest-api-specs/blob/087554c4480e144f715fe92f97621ff5603cd907/specification/compute/resource-manager/Microsoft.ContainerService/2017-01-31/containerService.json
```

Since the info sections of the OpenAPI definition files differ, we choose a new title for the overall client:

``` yaml
title: Compute
```

## Metadata generation

``` yaml
csharp:
  output-folder: SdkClient
  reflect-api-versions: true
```