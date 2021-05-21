# Change Log - @autorest/modelerfour

This log was last generated on Thu, 20 May 2021 16:41:13 GMT and should not be manually modified.

## 4.19.2
Thu, 20 May 2021 16:41:13 GMT

### Patches

- **Immproved** error message for duplicate operations

## 4.19.1
Tue, 04 May 2021 18:18:45 GMT

### Patches

- **Fix** Using multiple security layers(`AND`) now produce warning instead of error.

## 4.19.0
Tue, 27 Apr 2021 17:48:43 GMT

### Minor changes

- **Added** Distinction between anything and anyobject
- **Added** Support for openapi deprecation
- **Added** Support known set of security scheme

### Patches

- **Perf** Major performance improvment to duplicate schema finder

## 4.18.4
Mon, 19 Apr 2021 21:06:54 GMT

### Patches

- **Fix** Enum defined just with allOf of other enum
- **Typo** Ambigious -> Ambiguous 

## 4.18.3
Tue, 13 Apr 2021 21:32:54 GMT

### Patches

- **Fix** Enum without type resulting in null values

## 4.18.2
Fri, 09 Apr 2021 19:53:22 GMT

### Patches

- **Fix** api-version-mode configuration not working if not auto

## 4.18.1
Thu, 01 Apr 2021 15:46:41 GMT

### Patches

- Bump @azure-tools/uri version to ~3.1.1
- **Cleanup** Migrated use of require -> es6 imports
- **Update** how binary request body are treated if the content-type is not binary: Group all binary body together to prevent multiple method overload with same parameter
- **Fix** Some unhandled promises

## 4.18.0
Tue, 16 Mar 2021 15:52:56 GMT

### Minor changes

- **Change** let single value enum parameters be able to be grouped.
- **Feature** Support using `allOf` in enum to reference a parent enum. All the parent choices will be flattened in the child enum

### Patches

- **Respect** OpenAPI3 discriminator mapping
- Bump dependencies versions

## 4.17.2
Fri, 05 Mar 2021 16:31:29 GMT

### Patches

- Allow server variables to provide a string format(url, uri, etc.)

## 4.17.1
Fri, 26 Feb 2021 21:50:13 GMT

### Patches

- **Fix** Don't add a duplicate Content-Type parameter if it is already provided in the spec
- Fix x-ms-header-collection-prefix injected dictionary not defined in the list of schemas

## 4.17.0
Fri, 19 Feb 2021 21:42:09 GMT

### Minor changes

- **Change** Body parmaeters for a `formData` body will be seperate parameters in the generated model instead of being grouped in a body object.

### Patches

- Change property redefinition error when changing type into a warning to allow polymorphism

## 4.16.2
Thu, 11 Feb 2021 18:03:07 GMT

### Patches

- **Internals** Update chalk dependency to ^4.1.0

## 4.16.1
Mon, 08 Feb 2021 23:06:15 GMT

### Patches

- Set `isInMultipart: true` for multipart parameters

## 4.16.0
Thu, 04 Feb 2021 19:05:18 GMT

### Minor changes

- Migrate bundling system from static-link to webpack

### Patches

- Fix the use of  circular dependencies in additionalProperties [PR #3819](https://github.com/Azure/autorest/pull/3819)
- Internal code linting fixes
- Internal: Move out test custom matchers to seperate package
- Rename @azure-tools/autorest-extension-base dependency to new @autorest/extension-base pkg

## 4.15.456
Thu, 28 Jan 2021 00:22:27 GMT

### Patches

- Fix static linking issue with modelerfour resulting in incompatible dependency.

## 4.15.455
Tue, 26 Jan 2021 21:36:02 GMT

### Patches

- Update modelerfour to use renamed package @azuretools/codemodel -> @autorest/codemodel.

## 4.15.x

### Patches

- **Fix** Missing description in responses. ([PR 370](https://github.com/Azure/autorest.modelerfour/pull/370))
- **Feature** Added new flag `always-create-accept-parameter` to enable/disable accept param auto generation. ([PR 366](https://github.com/Azure/autorest.modelerfour/pull/366))
- **Fix** Allow request with body being a file and `application/json` content-type. ([PR 363](https://github.com/Azure/autorest.modelerfour/pull/363))
- **Fix** Dictionaries of dictionaries not being modeled as such(`dict[str, object]` instead of `dict[str, dict[str, str]]`). ([PR 372](https://github.com/Azure/autorest.modelerfour/pull/372))
- **Fix** Issue with sibling models(Model just being a ref of another) causing circular dependency exception. ([PR 375](https://github.com/Azure/autorest.modelerfour/pull/375))
- **Fix** Issue with duplicates schemas names due to consequtive name duplicate removal. ([PR 374](https://github.com/Azure/autorest.modelerfour/pull/374))
- Schemas with `x-ms-enum`'s `modelAsString` set to `true` will now be represented as `ChoiceSchema` even with a single value.
- `Accept` headers are now automatically added to operations having responses with content types
- Added `always-seal-x-ms-enum` settings to always create `SealedChoiceSchema` when an `x-ms-enum` is encountered

## 4.14.x

### Patches

- added `exception` SchemaContext for `usage` when used as an exception response
- changed `output` SchemaContext for `usage` to no longer include exception response uses

## 4.13.x

### Patches

- add security info (checks to see if `input.components?.securitySchemes` has any content)
- sync version of m4 and perks/codemodel == 4.13.x
- adding quality prechecker step as a way to test the OAI document for quality before modelerfour runs.
- report duplicate parents via allOf as an error.
- added `modelerfour.lenient-model-deduplication` to cause schemas with duplicated names to be renamed with an `AutoGenerated` suffix.  Note that this is a *temporary* measuer that should only be used when Swaggers cannot be updated easily.  This option will be removed in a future version of Modeler Four.

## 4.12.x

### Patches

- updated CI to build packages
- any is in a category in schemas
- times is a new category in schemas (not populated yet, next build)
- polymorphic payloads are not flattened (when it's the class that declares the discriminator)
- readonly is pulled from the schema if it's there
- body parameters should have the required flag set correctly
- content-type is now a header parameter (wasn't set before)
- added `modelerfour.always-create-content-type-parameter` to always get the content type parameter even when there are only one option.
- add support for x-ms-api-version extension to force enabling/disabling parameter to be treated as an api-version parameter
- the checker plugin will now halt on errors (can be disabled by `modelerfour.additional-checks: false`)
- when an enum without type is presented, if the values are all strings, assume 'string'
- flatten parents first for consistency
- added choiceType for content-type schema

## 4.6.x

### Patches

- add additional checks for empty names, collisions
- fix errant processing on APString => Apstring 
- x-ms-client-name fixes on parameters
- added setting for `preserve-uppercase-max-length` to preserve uppercase words up to a certain length.

## 4.5.x

### Patches

- static linking libraries for stability
- processed all names in namer, styles can be set in config (see below):
- support overrides in namer 
- static linked dependency

## 4.4.x

### Patches

- parameter grouping 
- some namer changes 

## 4.3.x

### Patches

- flattening (model and payload) enabled.
- properties should respect x-ms-client-name (many fixes)
- global parameters should try to be in order of original spec
- filter out 'x-ms-original' from extensions
- add serializedName for host parameters
- make sure reused global parameter is added to method too
- processed values in constants/enums a bit better, support AnySchema for no type/format 
- support server variable parameters as method unless they have x-ms-parameter-location

## 4.2.75

### Patches

- add `style` to parameters to support collection format 
- `potential-breaking-change` Include common paramters from oai/path #68 (requires fix from autorest-core 3.0.6160+ ) 
- propogate extensions from server parameters (ie, x-ms-skip-url-encoding) #61
- `potential-breaking-change` make operation groups case insensitive. #59 
- `potential-breaking-change` sealedChoice/Choice selection was backwards ( was creating a sealedchoice schema for modelAsString:true and vice versa) #62 
- `potential-breaking-change` drop constant schema from response, use constantschema's valueType instead. #63
- `potential-breaking-change` fix body parameter marked as required when not marked so in spec. #64

## 4.1.60

### Patches

- query parameters should have a serializedName so that they don't rely on the cosmetic name property.

## 4.1.58

### Patches

- version bump, change your configuration to specify version `~4.1.0` or greater
  
  ``` 
  use-extension:
    "@autorest/modelerfour" : "~4.1.0" 
  ```
  - each Http operation (via `.protocol.http`) will now have a separate `path` and `uri` properties. 
  <br>Both are still templates, and will have parameters. 
  <br>The parameters for the `uri` property will have `in` set to `ParameterLocation.Uri`
  <br>The parameters for the `path` property will continue to have `in` set to `ParameterLocation.Path`

  
  - autorest-core recently added an option to aggressively deduplicate inline models (ie, ones without a name)
  and modeler-four based generator will have that enabled by default. (ie `deduplicate-inline-models: true`)
  <br>This may increase deduplication time on extremely large openapi models.

  - this package contains the initial code for the flattener plugin, however it is not yet enabled.

  - updated `@azure-tools/codemodel` package to `3.0.241`:
  <br>`uri` (required) was added to `HttpRequest`
  <br>`flattenedNames` (optional) was added to `Property` (in anticipation of supporting flattening)

