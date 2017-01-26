# Microsoft.Web/sites/hybridconnection template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/sites/hybridconnection resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Web/sites/hybridconnection",
  "apiVersion": "2015-08-01",
  "id": "string",
  "name": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "entityName": "string",
    "entityConnectionString": "string",
    "resourceType": "string",
    "resourceConnectionString": "string",
    "hostname": "string",
    "port": "integer",
    "biztalkUri": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/sites/hybridconnection" />
### Microsoft.Web/sites/hybridconnection object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Web/sites/hybridconnection |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties) |


<a id="RelayServiceConnectionEntity_properties" />
### RelayServiceConnectionEntity_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  entityName | string | No |  |
|  entityConnectionString | string | No |  |
|  resourceType | string | No |  |
|  resourceConnectionString | string | No |  |
|  hostname | string | No |  |
|  port | integer | No |  |
|  biztalkUri | string | No |  |

