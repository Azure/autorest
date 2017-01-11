# Microsoft.Storage template schema

Creates a Microsoft.Storage resource.

## Schema format

To create a Microsoft.Storage, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2015-06-15",
  "location": "string",
  "properties": {
    "accountType": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="storageAccounts" />
## storageAccounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Storage/storageAccounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[StorageAccountPropertiesCreateParameters object](#StorageAccountPropertiesCreateParameters)<br /> |


<a id="StorageAccountPropertiesCreateParameters" />
## StorageAccountPropertiesCreateParameters object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  accountType | Yes | enum<br />**Standard_LRS**, **Standard_ZRS**, **Standard_GRS**, **Standard_RAGRS**, **Premium_LRS**<br /><br />Gets or sets the account type. |

