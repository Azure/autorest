# Default Configuration - Go

The V2 version of the Go Generator.

```yaml $(go) && $(legacy) && !isRequested('@microsoft.azure/autorest.go')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.go": "~2.1.187"
try-require: ./readme.go.md
```

```yaml $(go) && !$(legacy) && !isRequested('@autorest/go')
use-extension:
  "@autorest/go": "~4.0.0-preview.42"
try-require: ./readme.go.md
```
