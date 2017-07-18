# Sharing response headers between operations

> see https://aka.ms/autorest

This test validates recent changes to AutoRest to support sharing response header types across multiple operations (and as a side effect, allows customizing the name of the generated model class).

Example usage:
``` yaml false
# in some operation:
"200":
  x-ms-headers:
    $ref: "#/definitions/MyHeaders"
  headers:
    Some-Header:
      description: The foo of the bar.
      type: string
    Other-Header:
      description: The foo of the bar.
      type: string
# in definitions:
MyHeaders:
  properties:
    Some-Header:
      description: The foo of the bar.
      type: string
    Other-Header:
      description: The foo of the bar.
      type: string
```

Specifying the regular `headers` is not necessary for AutoRest (the definition is ignored in the presence of `x-ms-headers`), however we recommend specifying it for compatibility with other tools.
As `MyHeaders` is a regular model definition, it can be reused in other places arbitrarily, e.g. as a response headers for another operation, but also as part of a request or response body - in case this is remotely useful.

``` yaml 
input-file: shared-headers.yaml
csharp:
  output-folder: Client
  azure-arm: true
```