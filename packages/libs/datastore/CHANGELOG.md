# Change Log - @azure-tools/datastore

This log was last generated on Wed, 07 Dec 2022 22:24:34 GMT and should not be manually modified.

## 4.7.1
Wed, 07 Dec 2022 22:24:34 GMT

### Patches

- Add `normalizePath` helper
- Update dependencies

## 4.7.0
Tue, 19 Jul 2022 15:09:55 GMT

### Minor changes

- **Migrate** from jsonpath to jsonpath-plus

## 4.6.1
Tue, 15 Mar 2022 16:00:38 GMT

_Version update only_

## 4.6.0
Fri, 19 Nov 2021 04:23:42 GMT

### Minor changes

- Added support for identity sourcemap type

### Patches

- **Fix** Performance issue with not reusing DataHandle causing multiple instance of sourcemaps to be loaded at the same time

## 4.5.1
Thu, 14 Oct 2021 23:03:29 GMT

_Version update only_

## 4.5.0
Wed, 08 Sep 2021 15:39:22 GMT

### Minor changes

- **Added** Option to disable auto unloading of data in DataStore
- **Added** New tree source map builder replacing graph builder
- **Added** Support for yaml `<<` merge keyword in parser"
- Extract yaml logic in own package `@azure-tools/yaml`
- **Perf** Improvement to perf when buildingraph mappings
- **Added** New path mapping sourcemap functionality to improve performance significantly by reducing the yaml ast parsing needed to construct position based sourcemap

## 4.4.0
Mon, 19 Jul 2021 15:15:42 GMT

### Minor changes

- **Remove** NodeT type
- Drop support for node 10
- **Perf** Memory usage improvements
- **Perf** Unload sourcemap from memory if not used

### Patches

- **Fix** Sourcemap computation

## 4.3.1
Tue, 27 Apr 2021 17:48:43 GMT

### Patches

- **Deprecate** json-pointer functionality as it is moved to seperate package

## 4.3.0
Fri, 09 Apr 2021 19:53:22 GMT

### Minor changes

- **Added** sourcemap support

## 4.2.2
Thu, 01 Apr 2021 15:46:41 GMT

### Patches

- Bump @azure-tools/uri version to ~3.1.1
- **Update** Logging to use `@azure/logger` instead of `console`
- **Refactor** datastore and deprecated PascalCase methods
- **Fix vulnerability** incomplete url sanitization when adding github auth token

## 4.2.1
Tue, 16 Mar 2021 19:28:18 GMT

### Patches

- **Revert** logging when failed to load file as it creates too much noise

## 4.2.0
Tue, 16 Mar 2021 15:52:56 GMT

### Minor changes

- Added retry logic for loading uris.
- **Refactor** abstract file system. Moved CachingFileSystem from @autorest/configuration.

### Patches

- **Update** TransformerViaPointer to take Generic Input/Output types
- Bump dependencies versions

## 4.1.271
Thu, 04 Feb 2021 19:05:18 GMT

### Patches

- Internal: Moved from Azure/perks, formatting changes

