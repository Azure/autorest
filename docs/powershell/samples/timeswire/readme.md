# TimesWire Search

> see https://aka.ms/autorest

This is the AutoRest configuration file for TimesWire Search.

---
## Getting Started
To build the SDK for TimesWire Search, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> `autorest`

To see additional help and options, run:

> `autorest --help`
---

## Configuration


### Basic Information
These are the global settings for the  API.




``` yaml

input-file: timeswire.yaml
namespace: Times.Wire.Search

powershell:
  clear-output-folder: true
  output-folder: generated

  operations:
    Articles_ListBySourceAndRange:
      verb: Get
      noun: MyArticle
      description: Gets an article for me.
      parameters:
        TimePeriod:
          type: integer
          description: The *time* period. Get it ? "TIME"
        Source: null # delete this parameter entirely.




```


``` yaml

use:
- "@microsoft.azure/autorest.powershell@beta"

```

