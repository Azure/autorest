# Microsoft.ApiManagement/service/groups template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/groups resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ApiManagement/service/groups",
  "apiVersion": "2016-07-07",
  "name": "string",
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
|  type | enum | Yes | Microsoft.ApiManagement/service/groups |
|  apiVersion | enum | Yes | 2016-07-07 |
|  name | string | Yes | Group name. |
|  description | string | No | Group description. |
|  externalId | string | No | Identifier for an external group. |
|  resources | array | No | [service_groups_users_childResource object](#service_groups_users_childResource) |


<a id="service_groups_users_childResource" />
### service_groups_users_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | users |
|  apiVersion | enum | Yes | 2016-07-07 |

