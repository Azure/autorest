# Default Configuration - PowerShell

The beta version of the PowerShell Generator.

``` yaml $(powershell)
# requires multi-api merger
enable-multi-api: true

# probe from readme.powershell.md file 
try-require: ./readme.powershell.md
```

Note: if the --powershell is mentioned, but they are using autorest.powershell locally, don't try to load the autorest.powershell from npm.

``` yaml $(powershell) && ( "$(requesting-extensions)".indexOf('autorest.powershell') === -1 )
# load the extension 
use-extension:
  "@microsoft.azure/autorest.powershell": "beta"
```