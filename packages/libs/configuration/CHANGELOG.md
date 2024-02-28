# Change Log - @autorest/configuration

This log was last generated on Wed, 28 Feb 2024 18:02:21 GMT and should not be manually modified.

## 1.12.1
Wed, 28 Feb 2024 18:02:21 GMT

### Patches

- rename openapi-to-cadl to openapi-to-typespec

## 1.12.0
Thu, 16 Nov 2023 16:00:04 GMT

### Minor changes

- Upgrade dependencies
- Set autorest.powershell v4 the default version loaded by autorest

## 1.11.0
Wed, 07 Dec 2022 22:24:34 GMT

### Minor changes

- Add @autorest/openapi-to-cadl plugin
- Remove `--model-validator` flag to load oav as oav autorest plugin is not supported anymore

### Patches

- Update dependencies

## 1.10.1
Wed, 27 Jul 2022 17:44:10 GMT

### Patches

- Fix `where-operation-match` built-in directive

## 1.10.0
Tue, 19 Jul 2022 15:09:55 GMT

### Minor changes

- make Go v4 code generator the default for Go

### Patches

- **Bump** @autorest/java default version to 4.1.0
- Fix loading markdown config starting with codeblock

## 1.9.2
Thu, 31 Mar 2022 16:50:54 GMT

### Patches

- Fix cadl invalid config

## 1.9.1
Tue, 22 Mar 2022 00:17:01 GMT

### Patches

- Fix crash when having invalid cli arguments

## 1.9.0
Tue, 15 Mar 2022 16:00:38 GMT

### Minor changes

- **Added** configuration for `--apply-transforms-in-place`
- Tweak to nested configuration resolution
- Added directives `where-operation-match` and `remove-operation-match` which takes regexp.

## 1.8.2
Tue, 07 Dec 2021 16:36:46 GMT

### Patches

- **Remove** removal of additionalProperties=false for v2 generator 

## 1.8.1
Tue, 30 Nov 2021 15:50:35 GMT

### Patches

- Allow multiple `reason` on directive

## 1.8.0
Fri, 19 Nov 2021 04:23:42 GMT

### Minor changes

- **Consolidate** configuration schema to add description and missing settings
- Uptake changes to the extension loader and report installation progress

### Patches

- Relax directive validation

## 1.7.3
Thu, 14 Oct 2021 23:03:28 GMT

### Patches

- **Fix** Issue with undefined properties

## 1.7.2
Thu, 23 Sep 2021 19:51:32 GMT

### Patches

- **Added** `include-x-ms-examples-original-file` flag to activate `x-ms-original-file` injection in `x-ms-examples`

## 1.7.1
Wed, 22 Sep 2021 15:23:39 GMT

### Patches

- Added missing help text for command line arguments

## 1.7.0
Wed, 08 Sep 2021 15:39:22 GMT

### Minor changes

- **Rename** `adl` -> `cadl`
- **Remove** Yaml logging message format
-  **Update** to new path mapping sourcemap functionality and remove unused parsing logic
- **Remove** quick-check plugin from defautl configuration

### Patches

- Configuration loader will not auto unloadcode blocks
- **Fix** Input files with `..` in path would cause duplicate loading and cause issues down the line

## 1.6.0
Mon, 19 Jul 2021 15:15:41 GMT

### Minor changes

- **Added** `debug` flag to directive to enable additional logging
- **Added** Eol configuration
- **Moved** literate-yaml logic from @autorest/common
- Drop support for node 10

### Patches

- **Docs** Add documenation about `--use`
- **Added** New --memory configuration
- **Added** `--skip-sourcemap` flag
- **Fix** Handle invalid yaml in cli flag
- Add `interactive` to config type

## 1.5.0
Thu, 03 Jun 2021 22:37:55 GMT

### Minor changes

- Add support for adl

## 1.4.1
Wed, 26 May 2021 18:31:17 GMT

### Patches

- **Fix** issue when using --use: it would try to use yarn but couldn't find yarn/cli.js location

## 1.4.0
Thu, 20 May 2021 16:41:13 GMT

### Minor changes

- **Remove** Old patch directive causing incorect swagger behavior

## 1.3.1
Mon, 10 May 2021 18:01:37 GMT

### Patches

- **Fix** Keep order of property when merging to allow interpolation from same file

## 1.3.0
Tue, 27 Apr 2021 17:48:43 GMT

### Minor changes

- **Added** CLI argument parsing functionality(Moved from core and autorest)
- **Addded** configuration validator for known config properties

### Patches

- **Bump** @autorest/java default version to 4.0.24

## 1.2.3
Fri, 09 Apr 2021 19:53:22 GMT

### Patches

- Added skip-semantics-validation config flag
- **Added** remove-parameter built-in directive
- **Update** Configuration to use new semantic validator
- **Addd** `stats` flag to configuration
- **Fix** Loading same configuration twice

## 1.2.2
Fri, 02 Apr 2021 15:18:00 GMT

### Patches

- **Fix** issue where getting nested config wouldn't copy the raw config and cause issue

## 1.2.1
Thu, 01 Apr 2021 15:46:41 GMT

### Patches

- Bump @azure-tools/uri version to ~3.1.1
- Simplify configuration loading interface

## 1.2.0
Tue, 16 Mar 2021 15:52:56 GMT

### Minor changes

- Extract CachingFileSystem out into @azure-tools/datastore

### Patches

- Bump dependencies versions

## 1.1.3
Wed, 10 Mar 2021 01:07:02 GMT

### Patches

- **Fix** Defining multiple directive in configuration file as an object could override each other

## 1.1.2
Mon, 08 Mar 2021 18:07:37 GMT

### Patches

- **Fix** Loading --require configuration added from the CLI before default configuration

## 1.1.1
Fri, 05 Mar 2021 16:31:29 GMT

### Patches

- **Fix** issue where interpolating a value defined in the same block wouldn't be able to be overwritten by previous configs
- **Fix** Load arrays in the order they are defined within the same file(Resolve issue with directive loaded in inverted order)
- Revert use of flatmap

## 1.1.0
Fri, 26 Feb 2021 21:50:13 GMT

### Minor changes

- **Update** Moved configuration loading from @autorest/core and redesign

### Patches

- **Fix** Plugins with nested configuration file requiring other plugins wasn't loading those plugins

## 1.0.1
Fri, 19 Feb 2021 21:42:09 GMT

### Patches

- Initial release, include models only

