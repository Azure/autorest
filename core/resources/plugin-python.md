# Default Configuration - Python

The V3 version of the Python Generator.

``` yaml $(python) && !isRequested('@microsoft.azure/autorest.python')
version: ~3.0.6298

use-extension:
  "@autorest/python": "latest"
try-require: ./readme.python.md
```

Enable use of the V2 Python generator (and V2 core) with the `--v2` parameter:

``` yaml $(python) && $(preview) && $(v2)
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.python": "preview"
try-require: ./readme.python.md
```

``` yaml $(python) && $(v2)
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.python": "~3.0.56"
try-require: ./readme.python.md
```
