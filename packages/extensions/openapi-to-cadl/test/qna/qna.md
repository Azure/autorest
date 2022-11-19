```yaml
input-file:
  - https://raw.githubusercontent.com/Azure/azure-rest-api-specs/cb969a7b7c92b02ab93261b165dd2d91ecfd4b9a/dev/cognitiveservices/data-plane/Language/questionanswering.json
clear-output-folder: false
namespace: "Azure.Language.QnAMaker"
title: "QnA Maker"
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
