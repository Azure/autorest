# Microsoft.ApiManagement/service/groups template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/groups resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ApiManagement/service/groups",
  "apiVersion": "2016-07-07",
  "description": "string",
  "externalId": "string",
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/groups" />
### Microsoft.ApiManagement/service/groups object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Group identifier. Must be unique in the current API Management service instance. |
|  type | enum | Yes | Microsoft.ApiManagement/service/groups |
|  apiVersion | enum | Yes | 2016-07-07 |
|  description | string | No | Group description. |
|  externalId | string | No | Identifier for an external group. |
|  resources | array | No | [service_groups_users_childResource object](#service_groups_users_childResource) |


<a id="service_groups_users_childResource" />
### service_groups_users_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | User identifier. Must be unique in the current API Management service instance. |
|  type | enum | Yes | users |
|  apiVersion | enum | Yes | 2016-07-07 |

