```yaml
require: https://github.com/Azure/azure-rest-api-specs/blob/04a97e3c6d55746bf9349b16e8d1c2fe2fa942af/specification/azureintegrationspaces/resource-manager/readme.md
title: "Azure Integration Spaces resource management API."
clear-output-folder: false
guessResourceKey: false
isAzureSpec: true
isArm: true
namespace: "Azure.ResourceManager.Integration.Spaces"
```

### Config for csharp

```yaml
save-inputs: true
request-path-to-resource-data:
  /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IntegrationSpaces/spaces/{spaceName}/applications/{applicationName}/resources/{resourceName}: ApplicationResource
```
