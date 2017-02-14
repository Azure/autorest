# Microsoft.PowerBI/workspaceCollections template reference
API Version: 2016-01-29
## Template format

To create a Microsoft.PowerBI/workspaceCollections resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.PowerBI/workspaceCollections",
  "apiVersion": "2016-01-29",
  "location": "string",
  "tags": {},
  "sku": {
    "name": "S1",
    "tier": "Standard"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.PowerBI/workspaceCollections" />
### Microsoft.PowerBI/workspaceCollections object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.PowerBI/workspaceCollections |
|  apiVersion | enum | Yes | 2016-01-29 |
|  location | string | No | Azure location |
|  tags | object | No |  |
|  sku | object | No | [AzureSku object](#AzureSku) |


<a id="AzureSku" />
### AzureSku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | SKU name - S1 |
|  tier | enum | Yes | SKU tier - Standard |

