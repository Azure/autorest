# Change Log - @autorest/openapi-to-typespec

This log was last generated on Wed, 28 Feb 2024 18:02:21 GMT and should not be manually modified.

## 0.7.0
Wed, 28 Feb 2024 18:02:21 GMT

### Minor changes

- Add support for custom resource, enhance doc conversion and fix default value issue
- Initial Support for ARM in OpenAPI to TypeSpec Conversion
- Support Auth
- Support new location resource expression, support new flatten decorator and fix doc escape problem.

### Patches

- Add feature and fix bug for converter.
- Fix validation issues for converter
- use different base parameter for different resource
- Add a flag to disable conversion feature for backcomp
- migrate `@projectedName` to `@encodedName`
- fix default value of array and remove default value of duration temporarily
- Change to use raw operation for non-resource operations for ARM
- Improve data-plane tspconfig

## 0.6.0
Thu, 16 Nov 2023 16:00:04 GMT

### Minor changes

- Update dependencies

## 0.5.0
Fri, 26 May 2023 15:35:37 GMT

### Minor changes

- Fix pagination issue and update to compiler 0.44.0

## 0.4.0
Thu, 13 Apr 2023 04:20:09 GMT

### Minor changes

- Improvements on Enum translation
- Update to generate TypeSpec after Cadl -> Typespec rename

### Patches

- Fix issue with output-folder
- Remove unnecessary dependency.

## 0.2.0
Wed, 07 Dec 2022 22:24:34 GMT

### Minor changes

- Add @projectedName on model properties

### Patches

- Introducing the OpenAPI to CADL plugin

