# Default Configuration - PowerShell

The AutoRest PowerShell generator is intended to be use from AutoRest. 

> see https://aka.ms/autorest


``` yaml $(powershell)
# probe for a local readme.powershell.md file 
try-require: ./readme.powershell.md
```

Note: if the --powershell is mentioned, but they are using autorest.powershell locally, don't try to load the autorest.powershell from npm.

``` yaml $(powershell) && !isLoaded('@autorest/powershell')
# load the extension  (3.0+)
use-extension:
  "@autorest/powershell": "~3.0.0"
```