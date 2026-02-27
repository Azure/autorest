```yaml
library-name: Search
namespace: Azure.Search
isAzureSpec: true
require: https://raw.githubusercontent.com/Azure/azure-rest-api-specs/d45f04200fe13e29863dd7669adb05a2639af64d/specification/search/data-plane/Search/readme.md
tag: package-2024-11-searchindex-preview # We set this tag because in the latest tag, there is an enum doesn't have name so we cannot succefully generate it
modelerfour:
  flatten-payloads: false
deserialize-null-collection-as-null-value: true
```
