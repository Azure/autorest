# Change Log - @autorest/configuration

This log was last generated on Thu, 01 Apr 2021 15:46:41 GMT and should not be manually modified.

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

