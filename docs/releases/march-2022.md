# March 2022 Release - Autorest Core 3.8.0, Modelerfour 4.23.0

Changelogs for full details:

- [Autorest Core](https://github.com/Azure/autorest/blob/main/packages/extensions/core/CHANGELOG.md)
- [Modelerfour](https://github.com/Azure/autorest/blob/main/packages/extensions/modelerfour/CHANGELOG.md)

## CLI: Improve reliability resolving core version

Autorest cli 3.6.0 simplified the logic for resolving the available core version which should improve both performance and reliability.

## Core: Apply transforms in place

[Docs](https://github.com/Azure/autorest/blob/main/docs/generate/directives.md#use-directive-to-permanently-update-inputs)
This version introduce a new flag `--apply-transforms-in-place` which will take the transforms run after loading the Swagger 2.0 or OpenAPI 3.0 input file and save the resulting document.
This can be used to do a permant fix to the spec using directives.

```bash
# Apply transforms defined in the mytransforms.md config file to the openapi.yaml file.
autorest --apply-transforms-in-place --input-file=openapi.yaml --require=./mytransforms.yaml
```

## Core: Configure log level for a specific plugin

When working on or trying to diagnostic a specific plugin or extension you can now only show verbose and debug logs for that plugin and not have the autorest output overloaded with extra information from other plugins.

**Via flag**

```
--<scope>.log-level=debug
--<scope>.verbose
--<scope>.debug
```

**Via config**

```yaml
<scope>:
  logLevel: "debug"
  verbose: true
  debug: true
```

### Examples:

**Via flag**

```
# Set logging level to debug for modelerfour
--modelerfour.level=debug

# Set logging level to verbose for modelerfour
--modelerfour.verbose

# Set logging level to debug for modelerfour
--modelerfour.debug
```

**Via config**

```yaml
# Set logging level to debug for modelerfour
modelerfour:
  level: 'debug'

# Set logging level to verbose for modelerfour
modelerfour:
  verbose: true

# Set logging level to debug for modelerfour
modelerfour:
  debug: true
```

## Core: New built-in directives

Added directives `where-operation-match` and `remove-operation-match` which takes regexp.

Example:

```yaml
directive:
  - where-operation-match: /mygroup_.*/i
    transform: $["x-marked"] = true
```

## Modelerfour: Improvements to request body interpretation

Modelerfour use to have an inconsitent behavior when interpreting the request bodies. This produce some operation that had invalid overload due to conflicting body types. This release introduce a redesign of the behavior.
Spec and docs on how body gets interpreted can be found here https://github.com/Azure/autorest/blob/main/docs/openapi/request-body.md
In the case where the old request body interpretation behavior is wanted a flag can be used to achieve this result `--modelerfour.legacy-request-body`

The main principle for the new behavior is that the request body is interpreted using the schema of the body not the content-type.
There is however a few execeptions due to Swagger 2.0 limitations described in the [documentation](https://github.com/Azure/autorest/blob/main/docs/openapi/request-body.md)

## Modelerfour: Security scheme generalization

**Breaking for generators**

Modelerfour 4.19.0 introduced behavior that would take OpenAPI security schemes or autorest configuration and add the security definition to the codemodel. This was however very restricted(AADToken and AzureKey only two name allowed)

This version introduce more flexibility by removing the requirement for the name and look for the type(`oauth2` or `apiKey`)

**Breaking change for generators:**

- Renamed the `AADTokenSecurityScheme` to `OAuth2SecurityScheme`
- Renamed the `AzureKeySecurityScheme` to `KeySecurityScheme` and added `in` property that can only be `header` for now.

## Modelerfour: Other updates to the codemodel

1. Added `operationId` property on operation pointing to the original value of `operationId` in the OpenAPI document. This can be used to figure out the unique id of the operation.
2. Added `specialHeaders` property on operation that contains a list of header name that should be automatically handled by the generator. Those are headers that were removed from the parameter list so they could be auto injected by the client. (e.g. OASIS repatibility headers)
