# Default Configuration - Patches

These are directives that make patches to documents in the pipeline
Rather than changing the generators directly.


##### `additionalProperties: true/false` in definitions section

``` yaml
directive:
- from: swagger-document
  where: $.definitions.*.additionalProperties
  transform: |
    return typeof $ === "boolean"
      ? ($ ? { type: "object" } : undefined)
      : $
  reason: polyfill
- from: openapi-document
  where: $.components.*.additionalProperties
  transform: |
    return typeof $ === "boolean"
      ? ($ ? { type: "object"} : undefined)
      : $
  reason: polyfill
```

##### Reproduce old buggy behavior of ignoring `required`ness of properties in nested schemas (anything outside `definitions` section)
See https://github.com/Azure/autorest/issues/2688

``` yaml $(ignore-nested-required)
directive:
- from: openapi-document
  where: $..*[?(Array.isArray(@.required) && @.properties)]
  transform: |
    if ($path.length > 3) delete $.required;
  reason: see issue https://github.com/Azure/autorest/issues/2688
```
