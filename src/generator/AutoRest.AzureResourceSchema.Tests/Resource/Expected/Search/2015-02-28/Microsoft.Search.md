# Microsoft.Search template schema

Creates a Microsoft.Search resource.

## Schema format

To create a Microsoft.Search, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Search/searchServices",
  "apiVersion": "2015-02-28",
  "properties": {
    "sku": {
      "name": "string"
    },
    "replicaCount": "integer",
    "partitionCount": "integer"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="searchServices" />
## searchServices object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Search/searchServices**<br /> |
|  apiVersion | Yes | enum<br />**2015-02-28**<br /> |
|  location | No | string<br /><br />The geographic location of the Search service. |
|  tags | No | object<br /><br />Tags to help categorize the Search service in the Azure Portal. |
|  properties | Yes | object<br />[SearchServiceProperties object](#SearchServiceProperties)<br /><br />Properties of the Search service. |


<a id="SearchServiceProperties" />
## SearchServiceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The SKU of the Search Service, which determines price tier and capacity limits. |
|  replicaCount | No | integer<br /><br />The number of replicas in the Search service. If specified, it must be a value between 1 and 6 inclusive. |
|  partitionCount | No | integer<br /><br />The number of partitions in the Search service; if specified, it can be 1, 2, 3, 4, 6, or 12. |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**free**, **standard**, **standard2**<br /><br />The SKU of the Search service. |

