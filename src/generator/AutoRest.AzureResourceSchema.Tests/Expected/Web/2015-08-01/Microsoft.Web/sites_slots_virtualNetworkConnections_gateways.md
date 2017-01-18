# Microsoft.Web/sites/slots/virtualNetworkConnections/gateways template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/sites/slots/virtualNetworkConnections/gateways resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Web/sites/slots/virtualNetworkConnections/gateways",
  "apiVersion": "2015-08-01",
  "id": "string",
  "name": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "vnetName": "string",
    "vpnPackageUri": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/sites/slots/virtualNetworkConnections/gateways" />
### Microsoft.Web/sites/slots/virtualNetworkConnections/gateways object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Web/sites/slots/virtualNetworkConnections/gateways |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VnetGateway_properties object](#VnetGateway_properties) |


<a id="VnetGateway_properties" />
### VnetGateway_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vnetName | string | No | The VNET name. |
|  vpnPackageUri | string | No | The URI where the Vpn package can be downloaded |

