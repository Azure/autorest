```yaml
require:
  - https://github.com/Azure/azure-rest-api-specs/blob/c2462b79745a22cccf825973c64fa4c53ce29ceb/specification/webpubsub/data-plane/readme.md
clear-output-folder: false
isAzureSpec: true
guessResourceKey: true
```

```yaml
directive:
  - from: swagger-document
    where: $.definitions.ClientTokenResponse
    transform: >
      $.required = ["token"]
```
