# Microsoft.Web/hostingEnvironments/workerPools template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/hostingEnvironments/workerPools resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Web/hostingEnvironments/workerPools",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "workerSizeId": "integer",
    "computeMode": "string",
    "workerSize": "string",
    "workerCount": "integer",
    "instanceNames": [
      "string"
    ]
  },
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

<a id="Microsoft.Web/hostingEnvironments/workerPools" />
### Microsoft.Web/hostingEnvironments/workerPools object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Web/hostingEnvironments/workerPools |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [WorkerPool_properties object](#WorkerPool_properties) |
|  sku | object | No | [SkuDescription object](#SkuDescription) |


<a id="WorkerPool_properties" />
### WorkerPool_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  workerSizeId | integer | No | Worker size id for referencing this worker pool |
|  computeMode | enum | No | Shared or dedicated web app hosting. - Shared, Dedicated, Dynamic |
|  workerSize | string | No | VM size of the worker pool instances |
|  workerCount | integer | No | Number of instances in the worker pool |
|  instanceNames | array | No | Names of all instances in the worker pool (read only) - string |


<a id="SkuDescription" />
### SkuDescription object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the resource sku |
|  tier | string | No | Service Tier of the resource sku |
|  size | string | No | Size specifier of the resource sku |
|  family | string | No | Family code of the resource sku |
|  capacity | integer | No | Current number of instances assigned to the resource |

