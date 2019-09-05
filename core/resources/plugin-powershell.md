# Default Configuration - PowerShell

The beta version of the PowerShell Generator.

``` yaml $(powershell)
# probe from readme.powershell.md file 
try-require: ./readme.powershell.md
```

Note: if the --powershell is mentioned, but they are using autorest.powershell locally, don't try to load the autorest.powershell from npm.

``` yaml $(powershell) && !isLoaded('@autorest/powershell')
# load the extension 
use-extension:
  "@autorest/powershell": "beta"
```