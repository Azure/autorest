# Change Log - @azure-tools/oai2-to-oai3

This log was last generated on Wed, 27 Apr 2022 18:53:11 GMT and should not be manually modified.

## 4.6.1
Wed, 27 Apr 2022 18:53:11 GMT

### Patches

- Fix issue with using $ref in responses inserterting $ref in the parent

## 4.6.0
Tue, 15 Mar 2022 16:00:38 GMT

### Minor changes

- Make use of openapi workspace
- Extract OpenAPI2 types into @azure-tools/openapi package

## 4.5.1
Mon, 06 Dec 2021 20:16:04 GMT

### Patches

- **Internal** type fix

## 4.5.0
Fri, 19 Nov 2021 04:23:43 GMT

### Minor changes

- Copy all extensions on parameters

## 4.4.0
Wed, 08 Sep 2021 15:39:22 GMT

### Minor changes

- **Updated** to use new tree source map builder
- Add warning and ignore invalid response examples
- Tweaking request body processing and removed some invalid swagger  processing with `type: file` with non `formData` parmaeter
-  **Update** to new path mapping sourcemap functionality

## 4.3.0
Mon, 19 Jul 2021 15:15:42 GMT

### Minor changes

- Drop support for node 10

## 4.2.281
Fri, 16 Apr 2021 15:18:54 GMT

### Patches

- Stop merging x-ms-paths into paths

## 4.2.280
Fri, 09 Apr 2021 19:53:22 GMT

_Version update only_

## 4.2.279
Thu, 01 Apr 2021 15:46:42 GMT

### Patches

- **Fix** enum with $ref inside not being processed

## 4.2.278
Tue, 16 Mar 2021 15:52:56 GMT

### Patches

- Bump dependencies versions

## 4.2.277
Fri, 05 Mar 2021 16:31:29 GMT

### Patches

- When converting x-ms-parameterized-host parameters to server variables keep format as x-format

## 4.2.276
Thu, 04 Feb 2021 19:05:18 GMT

### Patches

- Internal: Migrate test framwork mocha -> jest
- Internal code linting fixes
- Internal: Add scenario tests

## 4.2.0
Thu, 04 Feb 2021 19:05:18 GMT

### Minor changes

- **fix**: Fail if a response has no produces defined and no global defined either [PR 144](https://github.com/Azure/perks/pull/144)

## 4.1.0
Thu, 04 Feb 2021 19:05:18 GMT

### Minor changes

- **fix**: Issue with cross-file referneces of body parameters [PR 131](https://github.com/Azure/perks/pull/131)

