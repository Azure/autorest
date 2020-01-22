# Default Configuration - Go

The V2 version of the Go Generator.

``` yaml $(go) && $(preview) && !isRequested('@autorest/go')
use-extension:
  "@microsoft.azure/autorest.go": "preview"
try-require: ./readme.go.md
```

``` yaml $(go) && && !isRequested('@autorest/go')
use-extension:
  "@microsoft.azure/autorest.go": "~2.1.47"
try-require: ./readme.go.md
```