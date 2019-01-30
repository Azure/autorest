# Default Configuration - PowerShell

The beta version of the PowerShell Generator.


Note: if the --powershell is mentioned, but they are using autorest.incubator, don't try to load the autorest.powershell from npm.

``` yaml $(powershell) && ( "$(requesting-extensions)".indexOf('autorest.incubator') === -1 ) 
# requires multi-api merger
enable-multi-api: true

# load the extension 
use-extension:
  "@microsoft.azure/autorest.powershell": "beta"

# probe from readme.powershell.md file 
try-require: ./readme.powershell.md

```
