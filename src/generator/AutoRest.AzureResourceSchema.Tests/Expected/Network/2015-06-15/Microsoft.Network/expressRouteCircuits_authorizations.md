# Microsoft.Network/expressRouteCircuits/authorizations template reference
API Version: 2015-06-15
## Template format

To create a Microsoft.Network/expressRouteCircuits/authorizations resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/expressRouteCircuits/authorizations",
  "apiVersion": "2015-06-15",
  "id": "string",
  "properties": {
    "authorizationKey": "string",
    "authorizationUseStatus": "string",
    "provisioningState": "string"
  },
  "name": "string",
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/expressRouteCircuits/authorizations" />
### Microsoft.Network/expressRouteCircuits/authorizations object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Network/expressRouteCircuits/authorizations |
|  apiVersion | enum | Yes | 2015-06-15 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [AuthorizationPropertiesFormat object](#AuthorizationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="AuthorizationPropertiesFormat" />
### AuthorizationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authorizationKey | string | No | Gets or sets the authorization key |
|  authorizationUseStatus | enum | No | Gets or sets AuthorizationUseStatus. - Available or InUse |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |

