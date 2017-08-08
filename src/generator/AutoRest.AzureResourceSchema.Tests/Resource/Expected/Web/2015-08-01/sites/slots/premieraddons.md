# Microsoft.Web/sites/slots/premieraddons template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/sites/slots/premieraddons resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Web/sites/slots/premieraddons",
  "apiVersion": "2015-08-01",
  "location": "string",
  "tags": {},
  "plan": {
    "name": "string",
    "publisher": "string",
    "product": "string",
    "promotionCode": "string",
    "version": "string"
  },
  "properties": {},
  "sku": {
    "name": "string",
    "tier": "string",
    "size": "string",
    "family": "string",
    "capacity": "integer"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/sites/slots/premieraddons" />
### Microsoft.Web/sites/slots/premieraddons object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Web/sites/slots/premieraddons |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | No | Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | object | No | Tags associated with resource |
|  plan | object | No | Azure resource manager plan - [ArmPlan object](#ArmPlan) |
|  properties | object | Yes | Resource specific properties |
|  sku | object | No | Sku description of the resource - [SkuDescription object](#SkuDescription) |


<a id="ArmPlan" />
### ArmPlan object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The name |
|  publisher | string | No | The publisher |
|  product | string | No | The product |
|  promotionCode | string | No | The promotion code |
|  version | string | No | Version of product |


<a id="SkuDescription" />
### SkuDescription object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the resource sku |
|  tier | string | No | Service Tier of the resource sku |
|  size | string | No | Size specifier of the resource sku |
|  family | string | No | Family code of the resource sku |
|  capacity | integer | No | Current number of instances assigned to the resource |

