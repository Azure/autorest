# Change Log - @autorest/openapi-to-typespec

This log was last generated on Fri, 29 Nov 2024 09:20:01 GMT and should not be manually modified.

## 0.10.4
Fri, 29 Nov 2024 09:20:01 GMT

### Patches

- Change @body to @bodyRoot
- Upgrade tsp compiler to 0.62

## 0.10.3
Thu, 24 Oct 2024 11:53:16 GMT

### Patches

- Fix some warnings in tsp converter

## 0.10.2
Thu, 17 Oct 2024 10:14:02 GMT

### Patches

- Fix paging, LRO and provideraction template. Upgrade compiler to 0.61
- Fix flatter and no doc warning 

## 0.10.1
Tue, 08 Oct 2024 09:03:42 GMT

### Patches

- Uptake SDK configuration to converter
- Fix some issues in convertion tool
- Upgrade compiler to 0.60.0

## 0.10.0
Fri, 06 Sep 2024 08:41:02 GMT

### Minor changes

- Remove .net generator dependency of tsp converter

## 0.9.1
Tue, 20 Aug 2024 21:31:07 GMT

### Patches

- Upgrade tsp compiler to 0.59

## 0.9.0
Mon, 12 Aug 2024 04:49:28 GMT

### Minor changes

- Support char type from swagger and Automatically detect ARM specs

### Patches

- upgrade tsp version of converter to 0.58

## 0.8.2
Tue, 25 Jun 2024 08:03:35 GMT

### Patches

- Upgrade compiler version to 0.57

## 0.8.1
Fri, 07 Jun 2024 02:12:15 GMT

### Patches

- Add output information to generated tsp
- Change enum outout to the latest definition

## 0.8.0
Tue, 28 May 2024 21:27:00 GMT

### Minor changes

- support generating csharp rename decorator when converting to tsp

### Patches

- Support AnyObject
- Add command to run compilation on test projects
- lock openapi-to-typespec test config
- fix wrong client lib import name
- Change isFullCompatible logic
- Support apiversion as path parameter
- Upgrade compiler to 0.56 and fix issues

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

