
# Default Configuration - Ruby

The V2 version of the Ruby Generator.


``` yaml $(ruby) && $(preview)
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.ruby": "preview"
try-require: ./readme.ruby.md
```
``` yaml $(ruby)
# default the v2 generator to using the last stable @microsoft.azure/autorest-core 
version: ~2.0.4413

use-extension:
  "@microsoft.azure/autorest.ruby": "~3.1.26"
try-require: ./readme.ruby.md
```
