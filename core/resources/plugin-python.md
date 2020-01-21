# Default Configuration - Pythong

The V2 version of the Python Generator.



``` yaml $(v2-python) && $(preview) 
use-extension:
  "@microsoft.azure/autorest.python": "preview"
try-require: ./readme.python.md
```

``` yaml $(v2-python)  && $(pipeline-model) !== 'v3'
use-extension:
  "@microsoft.azure/autorest.python": "~3.0.56"
try-require: ./readme.python.md
```
