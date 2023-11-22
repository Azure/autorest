# Change Log - @autorest/codemodel

This log was last generated on Thu, 16 Nov 2023 16:00:04 GMT and should not be manually modified.

## 4.20.0
Thu, 16 Nov 2023 16:00:04 GMT

### Minor changes

- Upgrade dependencies

## 4.19.3
Wed, 07 Dec 2022 22:24:34 GMT

### Patches

- Update dependencies

## 4.19.2
Fri, 12 Aug 2022 19:53:22 GMT

### Patches

- Fix: missing `ArmIdSchema` from yaml schema

## 4.19.1
Mon, 08 Aug 2022 16:48:55 GMT

### Patches

- Missing `armIds` in schemas

## 4.19.0
Tue, 19 Jul 2022 15:09:55 GMT

### Minor changes

- Added `ArmIdSchema` to represent Azure Resource Manager Resource Identifiers

## 4.18.2
Wed, 16 Mar 2022 19:40:12 GMT

### Patches

- Yaml schema missing deprecated models

## 4.18.1
Wed, 16 Mar 2022 15:14:54 GMT

### Patches

- Add back old security types to prevent breaking changes

## 4.18.0
Tue, 15 Mar 2022 16:00:38 GMT

### Minor changes

- Add `operationId` on Operation
- **Added** `requestMediaTypes` containing a mapping of all media types for a given operation to its request
- **Breaking** Renamed `AADTokenSecurityScheme` to `OAuth2SecurityScheme` and renamed `AzureKeySecurityScheme` to `KeySecurityScheme`
- Added special header to operation

### Patches

- Regen codemodel schema

## 4.17.2
Fri, 19 Nov 2021 04:23:43 GMT

_Version update only_

## 4.17.1
Thu, 14 Oct 2021 23:03:29 GMT

_Version update only_

## 4.17.0
Wed, 08 Sep 2021 15:39:22 GMT

### Minor changes

- **Internal** Remove need for @azure-tools/linq library

### Patches

- Types tweak to allow string enums value to accept string literals

## 4.16.0
Mon, 19 Jul 2021 15:15:41 GMT

### Minor changes

- Drop support for node 10

## 4.15.0
Tue, 27 Apr 2021 17:48:43 GMT

### Minor changes

- **Added** AnyObject schema type
- **Update** Codemodel to take new security model

### Patches

- **Updated** deprecation model

## 4.14.8
Fri, 09 Apr 2021 19:53:22 GMT

### Patches

- **Update** knownmediatype and mediaTypes to be optional in HttpOperation

## 4.14.7
Tue, 16 Mar 2021 15:52:56 GMT

### Patches

- Bump dependencies versions

## 4.14.6
Fri, 19 Feb 2021 21:42:09 GMT

### Patches

- Change name of isInMultipart to isPartialBody

## 4.14.5
Mon, 08 Feb 2021 23:06:15 GMT

### Patches

- Add a new `isInMultipart` field on parameters

## 4.14.4
Thu, 04 Feb 2021 19:05:18 GMT

### Patches

- Internal: Moved source to src/ folder
- Internal code linting fixes
- Removed unused deprecated dependency @azure-tools/autorest-extension-base

## 4.14.3
Tue, 26 Jan 2021 21:36:02 GMT

### Patches

- Revert js-yaml to 3.x

