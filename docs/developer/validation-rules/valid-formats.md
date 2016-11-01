# ValidFormats
## Description
The `format` property is an extendible way of providing more information about a `type` in the spec. AutoRest will generate code for formats that it does not know about (or ones that are typically used with a different type), but there will be no special handling for those values. You can see the set of formats that AutoRest supports here: [AutoRest Data Types](../guide/defining-clients-swagger.md#data-types).
## How to fix
Change the `format` to a format that AutoRest knows about, or omit it.