# Microsoft.Search/searchServices template reference
API Version: 2015-02-28
## Template format

To create a Microsoft.Search/searchServices resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Search/searchServices",
  "apiVersion": "2015-02-28",
  "location": "string",
  "tags": {},
  "properties": {
    "sku": {
      "name": "string"
    },
    "replicaCount": "integer",
    "partitionCount": "integer"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Search/searchServices" />
### Microsoft.Search/searchServices object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Search/searchServices |
|  apiVersion | enum | Yes | 2015-02-28 |
|  location | string | No | The geographic location of the Search service. |
|  tags | object | No | Tags to help categorize the Search service in the Azure Portal. |
|  properties | object | Yes | Properties of the Search service. - [SearchServiceProperties object](#SearchServiceProperties) |


<a id="SearchServiceProperties" />
### SearchServiceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sku | object | No | The SKU of the Search Service, which determines price tier and capacity limits. - [Sku object](#Sku) |
|  replicaCount | integer | No | The number of replicas in the Search service. If specified, it must be a value between 1 and 6 inclusive. |
|  partitionCount | integer | No | The number of partitions in the Search service; if specified, it can be 1, 2, 3, 4, 6, or 12. |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | The SKU of the Search service. - free, standard, standard2 |

