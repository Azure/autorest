# Microsoft.MachineLearning/commitmentPlans template reference
API Version: 2016-05-01-preview
## Template format

To create a Microsoft.MachineLearning/commitmentPlans resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.MachineLearning/commitmentPlans",
  "apiVersion": "2016-05-01-preview",
  "location": "string",
  "tags": {},
  "etag": "string",
  "sku": {
    "capacity": "integer",
    "name": "string",
    "tier": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.MachineLearning/commitmentPlans" />
### Microsoft.MachineLearning/commitmentPlans object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | The Azure ML commitment plan name. |
|  type | enum | Yes | Microsoft.MachineLearning/commitmentPlans |
|  apiVersion | enum | Yes | 2016-05-01-preview |
|  location | string | Yes | Resource location. |
|  tags | object | No | User-defined tags for the resource. |
|  etag | string | No | An entity tag used to enforce optimistic concurrency. |
|  sku | object | No | The commitment plan SKU. - [ResourceSku object](#ResourceSku) |


<a id="ResourceSku" />
### ResourceSku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  capacity | integer | No | The scale-out capacity of the resource. 1 is 1x, 2 is 2x, etc. This impacts the quantities and cost of any commitment plan resource. |
|  name | string | No | The SKU name. Along with tier, uniquely identifies the SKU. |
|  tier | string | No | The SKU tier. Along with name, uniquely identifies the SKU. |

