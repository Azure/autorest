# Change Log - @azure-tools/datastore

This log was last generated on Tue, 27 Apr 2021 17:48:43 GMT and should not be manually modified.

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

