# Change Log - @autorest/common

This log was last generated on Thu, 13 Apr 2023 04:20:09 GMT and should not be manually modified.

## 1.5.6
Thu, 13 Apr 2023 04:20:09 GMT

### Patches

- Fix: Suppression of the same code for different area could conflict each other

## 1.5.5
Wed, 07 Dec 2022 22:24:34 GMT

### Patches

- Update dependencies

## 1.5.4
Fri, 19 Aug 2022 16:52:58 GMT

### Patches

- Fix suppression not working

## 1.5.3
Tue, 19 Jul 2022 15:09:55 GMT

_Version update only_

## 1.5.2
Tue, 22 Mar 2022 16:33:04 GMT

### Patches

- Fix progress Bar crashing autorest when stdout redirected to file

## 1.5.1
Mon, 21 Mar 2022 15:38:03 GMT

### Patches

- Add `PluginUserError` error type

## 1.5.0
Tue, 15 Mar 2022 16:00:38 GMT

### Minor changes

- Add the pluginName and extensionName field`LogInfo` type

## 1.4.1
Wed, 01 Dec 2021 22:39:16 GMT

### Patches

- **Fix** configuration loading issue with nested config `az:`

## 1.4.0
Fri, 19 Nov 2021 04:23:42 GMT

### Minor changes

- **Removed** identitySourceMapping
- **Added** progress bar reporting to the logger

### Patches

- **Fix** Issue with coloring [] wrapped elements
- Render progress bar before closing to force it to 100%

## 1.3.0
Wed, 08 Sep 2021 15:39:22 GMT

### Minor changes

- **Added** New logger pipeline
- Added coloring for markdown ``` code blocks
- Add `color` utility to style markdown to cli format
- **Update** to new path mapping sourcemap functionality

## 1.2.0
Mon, 19 Jul 2021 15:15:41 GMT

### Minor changes

- **Moved** literate-yaml logic to @autorest/configuration
- Drop support for node 10

### Patches

- **Added** utils `isDefined`

## 1.1.4
Mon, 10 May 2021 18:01:37 GMT

### Patches

- **Fix** Keep order of property when merging to allow interpolation from same file

## 1.1.3
Fri, 09 Apr 2021 19:53:22 GMT

_Version update only_

## 1.1.2
Thu, 01 Apr 2021 15:46:41 GMT

### Patches

- **Added** configuration for usage of @azure/logger in libraries

## 1.1.1
Tue, 16 Mar 2021 15:52:56 GMT

### Patches

- Add `trackWarning` functionality to logger
- **Fix** Max call stack issue with loading very large swagger
- Bump dependencies versions

## 1.1.0
Fri, 05 Mar 2021 16:31:29 GMT

### Minor changes

- **Update** merge functionality to be able to take interpolation context. Default to the higher priority element otherwise
- **Update** Merging functionality to accept an array merging strategy to decide order of merging

## 1.0.3
Fri, 26 Feb 2021 21:50:13 GMT

### Patches

- **Update** Autorest logger definition

## 1.0.2
Sat, 20 Feb 2021 17:49:35 GMT

### Patches

- **Fix** Revert use of flatMap which is not available on node 10

## 1.0.1
Fri, 19 Feb 2021 21:42:09 GMT

### Patches

- Initial release, include code extract from @autorest/core around merging object and reading yaml/config

