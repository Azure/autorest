# Default Configuration - Python

The V2 version of the Python Generator.

``` yaml $(python) && $(v3)
version: ~3.0.6298

use-extension:
  "@autorest/python": "latest"
try-require: ./readme.python.md
```

``` yaml $(python) && $(preview) && !isRequested('@autorest/python')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.python": "preview"
try-require: ./readme.python.md
```

``` yaml $(python) && !isRequested('@autorest/python')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.python": "~3.0.56"
try-require: ./readme.python.md
```
