# Default Configuration - Java

The V2 version of the Java Generator.

``` yaml $(java) && $(preview) && !isRequested('@autorest/java')
use-extension:
  "@microsoft.azure/autorest.java": "~2.1.88"
try-require: ./readme.java.md
```

``` yaml $(java) && !isRequested('@autorest/csharp')
use-extension:
  "@microsoft.azure/autorest.java": "~2.1.88"
try-require: ./readme.java.md
```
