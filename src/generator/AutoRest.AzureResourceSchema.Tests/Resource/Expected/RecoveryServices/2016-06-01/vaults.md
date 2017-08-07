# Microsoft.RecoveryServices/vaults template reference
API Version: 2016-06-01
## Template format

To create a Microsoft.RecoveryServices/vaults resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.RecoveryServices/vaults",
  "apiVersion": "2016-06-01",
  "location": "string",
  "sku": {
    "name": "string"
  },
  "tags": {},
  "properties": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.RecoveryServices/vaults" />
### Microsoft.RecoveryServices/vaults object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | The name of the recovery services vault. |
|  type | enum | Yes | Microsoft.RecoveryServices/vaults |
|  apiVersion | enum | Yes | 2016-06-01 |
|  location | string | No | Resource Location |
|  sku | object | No | [Sku object](#Sku) |
|  tags | object | No | Resource Tags |
|  properties | object | Yes | [VaultProperties object](#VaultProperties) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | The Sku name. - Standard or RS0 |

