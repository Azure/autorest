# Scenario: Query command line help

> see https://aka.ms/autorest

There is generic help and help specific to plugins, which will actually be queried from extensions on the fly.
This allows extensions that we don't even know about to not only be usable but also discoverable through AutoRest.

``` yaml
help: true # we wanna query for help in each of the following scenarios

batch:
  # no additional arguments => query for generic AutoRest help
  - {}
  # plugin specific help (on CLI you would say something like `autorest --help --csharp`)
  - csharp: true
  - azure-validator: true
  - csharp: true
    azure-arm: true # could provide customized help for this!
    fluent: true
  # combination (let's list everything *we* own to make sure it works)
  - azureresourceschema: true
    csharp: true
    go: true
    java: true
    nodejs: true
    php: true
    python: true
    ruby: true
    typescript: true
    azure-validator: true
    model-validator: true
    semantic-validator: true
```