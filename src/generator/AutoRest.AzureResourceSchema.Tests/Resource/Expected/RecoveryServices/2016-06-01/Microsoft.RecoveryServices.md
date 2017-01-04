# Microsoft.RecoveryServices template schema

Creates a Microsoft.RecoveryServices resource.

## Schema format

To create a Microsoft.RecoveryServices, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.RecoveryServices/vaults",
  "apiVersion": "2016-06-01",
  "properties": {}
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="vaults" />
## vaults object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.RecoveryServices/vaults**<br /> |
|  apiVersion | Yes | enum<br />**2016-06-01**<br /> |
|  location | No | string<br /><br />Resource Location |
|  sku | No | object<br />[Sku object](#Sku)<br /> |
|  tags | No | object<br /><br />Resource Tags |
|  properties | Yes | object<br />[VaultProperties object](#VaultProperties)<br /> |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | enum<br />**Standard** or **RS0**<br /><br />The Sku name. |

