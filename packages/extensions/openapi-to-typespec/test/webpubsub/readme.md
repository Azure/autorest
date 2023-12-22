```yaml
require:
  - https://raw.githubusercontent.com/Azure/azure-rest-api-specs/main/specification/webpubsub/data-plane/readme.md
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
