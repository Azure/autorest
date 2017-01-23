# Microsoft.Web/sites/deployments template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/sites/deployments resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Web/sites/deployments",
  "apiVersion": "2015-08-01",
  "id": "string",
  "name": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "id": "string",
    "status": "integer",
    "message": "string",
    "author": "string",
    "deployer": "string",
    "author_email": "string",
    "start_time": "string",
    "end_time": "string",
    "active": boolean,
    "details": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/sites/deployments" />
### Microsoft.Web/sites/deployments object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Web/sites/deployments |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Deployment_properties object](#Deployment_properties) |


<a id="Deployment_properties" />
### Deployment_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Id |
|  status | integer | No | Status |
|  message | string | No | Message |
|  author | string | No | Author |
|  deployer | string | No | Deployer |
|  author_email | string | No | AuthorEmail |
|  start_time | string | No | StartTime |
|  end_time | string | No | EndTime |
|  active | boolean | No | Active |
|  details | string | No | Detail |

