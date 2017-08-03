# Microsoft.DataLakeStore/accounts template reference
API Version: 2015-10-01-preview
## Template format

To create a Microsoft.DataLakeStore/accounts resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.DataLakeStore/accounts",
  "apiVersion": "2015-10-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "endpoint": "string",
    "defaultGroup": "string"
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DataLakeStore/accounts" />
### Microsoft.DataLakeStore/accounts object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.DataLakeStore/accounts |
|  apiVersion | enum | Yes | 2015-10-01-preview |
|  location | string | No | Gets or sets the account regional location. |
|  tags | object | No | Gets or sets the value of custom properties. |
|  properties | object | Yes | Gets or sets the Data Lake Store account properties. - [DataLakeStoreAccountProperties object](#DataLakeStoreAccountProperties) |
|  resources | array | No | [firewallRules](./accounts/firewallRules.md) |


<a id="DataLakeStoreAccountProperties" />
### DataLakeStoreAccountProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  endpoint | string | No | Gets or sets the gateway host. |
|  defaultGroup | string | No | Gets or sets the default owner group for all new folders and files created in the Data Lake Store account. |

