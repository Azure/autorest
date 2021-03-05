# Change Log - @autorest/configuration

This log was last generated on Fri, 05 Mar 2021 16:31:29 GMT and should not be manually modified.

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

