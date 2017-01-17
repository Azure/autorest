# Microsoft.Web/serverfarms template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/serverfarms resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Web/serverfarms",
  "apiVersion": "2015-08-01",
  "id": "string",
  "name": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "name": "string",
    "workerTierName": "string",
    "adminSiteName": "string",
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    },
    "maximumNumberOfWorkers": "integer",
    "perSiteScaling": boolean
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

<a id="Microsoft.Web/serverfarms" />
### Microsoft.Web/serverfarms object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Web/serverfarms |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [ServerFarmWithRichSku_properties object](#ServerFarmWithRichSku_properties) |
|  sku | object | No | [SkuDescription object](#SkuDescription) |


<a id="ServerFarmWithRichSku_properties" />
### ServerFarmWithRichSku_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name for the App Service Plan |
|  workerTierName | string | No | Target worker tier assigned to the App Service Plan |
|  adminSiteName | string | No | App Service Plan administration site |
|  hostingEnvironmentProfile | object | No | Specification for the hosting environment (App Service Environment) to use for the App Service Plan - [HostingEnvironmentProfile object](#HostingEnvironmentProfile) |
|  maximumNumberOfWorkers | integer | No | Maximum number of instances that can be assigned to this App Service Plan |
|  perSiteScaling | boolean | No | If True apps assigned to this App Service Plan can be scaled independently
            If False apps assigned to this App Service Plan will scale to all instances of the plan |


<a id="SkuDescription" />
### SkuDescription object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the resource sku |
|  tier | string | No | Service Tier of the resource sku |
|  size | string | No | Size specifier of the resource sku |
|  family | string | No | Family code of the resource sku |
|  capacity | integer | No | Current number of instances assigned to the resource |


<a id="HostingEnvironmentProfile" />
### HostingEnvironmentProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource id of the hostingEnvironment (App Service Environment) |
|  name | string | No | Name of the hostingEnvironment (App Service Environment) (read only) |
|  type | string | No | Resource type of the hostingEnvironment (App Service Environment) (read only) |

