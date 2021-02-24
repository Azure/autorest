# Change Log - @azure-tools/extension

This log was last generated on Wed, 24 Feb 2021 00:33:50 GMT and should not be manually modified.

## 3.2.1
Wed, 24 Feb 2021 00:33:50 GMT

### Patches

- **Fix** updatePythonPath wasn't patching array inplace.

## 3.2.0
Fri, 19 Feb 2021 21:42:09 GMT

### Minor changes

- **Feature**: Add option to set the path to the yarn cli in the ExtensionManager. This enable webpack compatibility.
- **Feature** Added new "systemRequirements" validation for extensions. Extension are able to provide a list of system requirements which autorest will validate before starting.

### Patches

- **Update** various dependencies and moved package source from Azure/perks -> Azure/autorest
- **Update** copy yarn file on build from node dependency.

