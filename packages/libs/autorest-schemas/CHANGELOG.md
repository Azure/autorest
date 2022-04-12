# Change Log - @autorest/schemas

This log was last generated on Tue, 15 Mar 2022 16:00:38 GMT and should not be manually modified.

## 1.3.4
Tue, 15 Mar 2022 16:00:38 GMT

### Patches

- Fix `x-ms-examples` schema reference

## 1.3.3
Tue, 01 Feb 2022 23:06:50 GMT

### Patches

- Added `operation-location` as option for lro `final-state-via`

## 1.3.2
Fri, 19 Nov 2021 04:23:42 GMT

### Patches

- **Remove** empty version validation from schema validator

## 1.3.1
Fri, 17 Sep 2021 17:52:01 GMT

### Patches

- **Change** remove "name" requirement

## 1.3.0
Wed, 08 Sep 2021 15:39:22 GMT

### Minor changes

- **Added** `x-ms-original-file` to the `x-ms-examples` schema

## 1.2.0
Mon, 19 Jul 2021 15:15:41 GMT

### Minor changes

- **Feature** Add `x-ms-permissions` definition to swagger-schema"
- **Improve** OpenAPI 3 schema for parameter: Give better error message when it doesn't match

### Patches

- **Fix** Link schema in OpenAPI3 can be empty

## 1.1.4
Thu, 03 Jun 2021 22:37:55 GMT

### Patches

- Allow x-ms-paths not to start with /

## 1.1.3
Thu, 20 May 2021 16:41:13 GMT

### Patches

- **Update** Swagger 2.0 schema to allow custom extension with  `x-ms-` prefix

## 1.1.2
Tue, 13 Apr 2021 15:34:55 GMT

### Patches

- **Fix** Schema.addtionalProperties not allowing $Ref

## 1.1.1
Thu, 01 Apr 2021 15:46:41 GMT

### Patches

- **Fix**: OpenAPI3 Validation of additional properties support boolean

## 1.1.0
Tue, 16 Mar 2021 15:52:56 GMT

### Minor changes

- Update schemas to jsonschema draft-07.
- Update schemas to use if else instead of oneof to provide more helpful validation.

## 1.0.1
Tue, 09 Feb 2021 22:00:21 GMT

### Patches

- Allow x-ms-client-default to be an array of primitive types

