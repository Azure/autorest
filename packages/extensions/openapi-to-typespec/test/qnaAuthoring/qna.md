```yaml
input-file:
  - https://raw.githubusercontent.com/Azure/azure-rest-api-specs/e5404d3e55f885d2cb8fdbff3fd1a03bcfc6bb4c/dev/cognitiveservices/data-plane/Language/questionanswering-authoring.json
clear-output-folder: false

modelerfour:
  lenient-model-deduplication: true
```

```yaml
directive:
  - from: swagger-document
    where: $.parameters.Endpoint
    transform: >
      $.name = "Endpoint";
  - from: swagger-document
    where: $.parameters.AssetKindParameter
    transform: >
      $["x-ms-enum"] = {"name": "AssetKind", "modelAsString": true};
```
