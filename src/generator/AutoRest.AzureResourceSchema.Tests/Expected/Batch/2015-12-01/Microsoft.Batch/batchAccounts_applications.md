# Microsoft.Batch/batchAccounts/applications template reference
API Version: 2015-12-01
## Template format

To create a Microsoft.Batch/batchAccounts/applications resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Batch/batchAccounts/applications",
  "apiVersion": "2015-12-01",
  "allowUpdates": boolean,
  "displayName": "string",
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Batch/batchAccounts/applications" />
### Microsoft.Batch/batchAccounts/applications object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Batch/batchAccounts/applications |
|  apiVersion | enum | Yes | 2015-12-01 |
|  allowUpdates | boolean | No | A value indicating whether packages within the application may be overwritten using the same version string. |
|  displayName | string | No | The display name for the application. |
|  resources | array | No | [batchAccounts_applications_versions_childResource object](#batchAccounts_applications_versions_childResource) |


<a id="batchAccounts_applications_versions_childResource" />
### batchAccounts_applications_versions_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | versions |
|  apiVersion | enum | Yes | 2015-12-01 |

