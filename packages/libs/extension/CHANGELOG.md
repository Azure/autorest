# Change Log - @azure-tools/extension

This log was last generated on Tue, 27 Apr 2021 17:48:43 GMT and should not be manually modified.

## 3.2.6
Tue, 27 Apr 2021 17:48:43 GMT

### Patches

- **Fix** Fallback to github release when version doesn't exists broken if using version range

## 3.2.5
Thu, 01 Apr 2021 15:46:41 GMT

### Patches

- **Add** Logging when fail to fetch pacakge metadata

## 3.2.4
Tue, 16 Mar 2021 15:52:56 GMT

### Patches

- Bump dependencies versions

## 3.2.3
Fri, 05 Mar 2021 16:31:29 GMT

### Patches

- **Revert** not using global yarnrc and change to prevent yarn from loading alternate version

## 3.2.2
Fri, 26 Feb 2021 21:50:13 GMT

### Patches

- Prevent single-file yarn from loading user config and changing version

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

