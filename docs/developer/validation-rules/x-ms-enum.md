# ValidFormats
## Description
For enum types, we should encourage authors to use the `x-ms-enum` extension and apply appropriate options. Please refer to the dcoumentation details [here](https://github.com/Azure/azure-rest-api-specs/blob/master/documentation/swagger-extensions.md#x-ms-enum)
## How to fix
Add the `x-ms-enum` extension to the enum and set appropriate properties including `modelAsString`.