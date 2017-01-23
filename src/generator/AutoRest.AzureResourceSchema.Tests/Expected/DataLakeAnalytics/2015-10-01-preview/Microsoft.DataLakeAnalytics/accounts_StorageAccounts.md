# Microsoft.DataLakeAnalytics/accounts/StorageAccounts template reference
API Version: 2015-10-01-preview
## Template format

To create a Microsoft.DataLakeAnalytics/accounts/StorageAccounts resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.DataLakeAnalytics/accounts/StorageAccounts",
  "apiVersion": "2015-10-01-preview",
  "properties": {
    "accessKey": "string",
    "suffix": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DataLakeAnalytics/accounts/StorageAccounts" />
### Microsoft.DataLakeAnalytics/accounts/StorageAccounts object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.DataLakeAnalytics/accounts/StorageAccounts |
|  apiVersion | enum | Yes | 2015-10-01-preview |
|  properties | object | Yes | Gets or sets the properties for the Azure Storage account being added. - [StorageAccountProperties object](#StorageAccountProperties) |


<a id="StorageAccountProperties" />
### StorageAccountProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  accessKey | string | Yes | Gets or sets the access key associated with this Azure Storage account that will be used to connect to it. |
|  suffix | string | No | Gets or sets the optional suffix for the Data Lake account. |

