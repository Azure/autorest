# Default Configuration - Python

The V3 version of the Python Generator.

``` yaml $(python) && !$(legacy) && !$(v2) && !isRequested('@microsoft.azure/autorest.python')
version: ~3.1.0

use-extension:
  "@autorest/python": "latest"
try-require: ./readme.python.md
```

Enable use of the V2 Python generator (and V2 core) with the `--legacy` or `--v2` parameter:

``` yaml $(python) && ($(legacy) || $(v2) || isRequested('@microsoft.azure/autorest.python'))
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.python": "~4.0.73"
try-require: ./readme.python.md
```
