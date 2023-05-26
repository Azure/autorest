# Change Log - @azure-tools/openapi

This log was last generated on Fri, 26 May 2023 14:12:36 GMT and should not be manually modified.

## 3.5.0
Fri, 26 May 2023 14:12:36 GMT

### Minor changes

- Add `rfc7231` format

## 3.4.1
Wed, 07 Dec 2022 22:24:34 GMT

### Patches

- Update dependencies

## 3.4.0
Tue, 19 Jul 2022 15:09:55 GMT

### Minor changes

- Added `arm-id` to list of known formats

### Patches

- Improve InvalidRefError message

## 3.3.0
Tue, 15 Mar 2022 16:00:38 GMT

### Minor changes

- Add workspace heplper to navigate across multiple files
- Added `HttpMethod` enum
- Add `/v2` scope to load OpenAPI2 schema types.
- Update OpenAPI 3.0 types to be more accurate.

## 3.2.3
Wed, 12 Jan 2022 22:31:57 GMT

### Patches

- Added `isExtension` util function.

## 3.2.2
Fri, 19 Nov 2021 04:23:43 GMT

### Patches

- Tweak types for description next to parameter

## 3.2.1
Wed, 08 Sep 2021 15:39:22 GMT

### Patches

- Types update
- Tweaks types to allow string enums value to accept string literals

## 3.2.0
Mon, 19 Jul 2021 15:15:42 GMT

### Minor changes

- Drop support for node 10
- **Update** include/exclude x-dash properties utils types

## 3.1.3
Thu, 20 May 2021 16:41:13 GMT

### Patches

- **Update** includeXDashProperties

## 3.1.2
Tue, 27 Apr 2021 17:48:43 GMT

### Patches

- **Update** deprecatable models
- **Fix** SecurityRequirement type incorectly defining scopes as `string` instead of `string[]`

## 3.1.1
Tue, 16 Mar 2021 15:52:56 GMT

### Patches

- Bump dependencies versions

## 3.1.0
Thu, 04 Feb 2021 19:05:18 GMT

### Minor changes

- Change types from using `: Optional<T>` to `?: T`

### Patches

- Internal: Moved from Azure/perks and update formatting

