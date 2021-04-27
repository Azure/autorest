# Default Configuration - Java

The V3 version of the Java Generator.

```yaml $(java) && !$(legacy) && !$(v2) && !isRequested('@microsoft.azure/autorest.java')
version: ~3.1.0

use-extension:
  "@autorest/java": "^4.0.24"
try-require: ./readme.java.md
```

Enable use of the V2 Java generator (and V2 core) with the `--legacy` or `--v2` parameter:

```yaml $(java) && ($(legacy) || $(v2) || isRequested('@microsoft.azure/autorest.java'))
# default the v2 generator to using the last stable @microsoft.azure/autorest-core
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.java": "three"
try-require: ./readme.java.md
```
