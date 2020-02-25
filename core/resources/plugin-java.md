# Default Configuration - Java

The V2 version of the Java Generator.

``` yaml $(java) && $(preview) && !isRequested('@autorest/java')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: 2.0.4413

use-extension:
  "@microsoft.azure/autorest.java": "~2.1.88"
try-require: ./readme.java.md
```

``` yaml $(java) && !isRequested('@autorest/java')
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: 2.0.4413

use-extension:
  "@microsoft.azure/autorest.java": "~2.1.88"
try-require: ./readme.java.md
```
