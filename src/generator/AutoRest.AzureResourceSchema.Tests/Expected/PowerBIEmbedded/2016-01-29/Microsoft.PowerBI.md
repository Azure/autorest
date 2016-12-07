# Microsoft.PowerBI template schema

Creates a Microsoft.PowerBI resource.

## Schema format

To create a Microsoft.PowerBI, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.PowerBI/workspaceCollections",
  "apiVersion": "2016-01-29"
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="workspaceCollections" />
## workspaceCollections object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.PowerBI/workspaceCollections**<br /> |
|  apiVersion | Yes | enum<br />**2016-01-29**<br /> |
|  location | No | string<br /><br />Azure location |
|  tags | No | object<br /> |
|  sku | No | object<br />[AzureSku object](#AzureSku)<br /> |


<a id="AzureSku" />
## AzureSku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | enum<br />**S1**<br /><br />SKU name |
|  tier | Yes | enum<br />**Standard**<br /><br />SKU tier |

