# Microsoft.Storage/storageAccounts template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Storage/storageAccounts resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2015-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "accountType": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Storage/storageAccounts" />
### Microsoft.Storage/storageAccounts object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Storage/storageAccounts |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [StorageAccountPropertiesCreateParameters object](#StorageAccountPropertiesCreateParameters) |


<a id="StorageAccountPropertiesCreateParameters" />
### StorageAccountPropertiesCreateParameters object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  accountType | enum | No | Gets or sets the account type. - Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS |

