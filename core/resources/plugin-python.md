# Default Configuration - Pythong

The V2 version of the Python Generator.



``` yaml $(python) && $(preview) && !isRequested('@autorest/java')
use-extension:
  "@microsoft.azure/autorest.python": "preview"
try-require: ./readme.python.md
```

``` yaml $(python) && !isRequested('@autorest/java')
use-extension:
  "@microsoft.azure/autorest.python": "~3.0.56"
try-require: ./readme.python.md
```
