# Microsoft.Network/virtualNetworks/virtualNetworkPeerings template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Network/virtualNetworks/virtualNetworkPeerings resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",
  "apiVersion": "2016-09-01",
  "id": "string",
  "properties": {
    "allowVirtualNetworkAccess": boolean,
    "allowForwardedTraffic": boolean,
    "allowGatewayTransit": boolean,
    "useRemoteGateways": boolean,
    "remoteVirtualNetwork": {
      "id": "string"
    },
    "peeringState": "string",
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/virtualNetworks/virtualNetworkPeerings" />
### Microsoft.Network/virtualNetworks/virtualNetworkPeerings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/virtualNetworks/virtualNetworkPeerings |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [VirtualNetworkPeeringPropertiesFormat object](#VirtualNetworkPeeringPropertiesFormat) |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkPeeringPropertiesFormat" />
### VirtualNetworkPeeringPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allowVirtualNetworkAccess | boolean | No | Gets or sets whether the VMs in the linked virtual network space would be able to access all the VMs in local Virtual network space |
|  allowForwardedTraffic | boolean | No | Gets or sets whether the forwarded traffic from the VMs in the remote virtual network will be allowed/disallowed |
|  allowGatewayTransit | boolean | No | Gets or sets if gatewayLinks can be used in remote virtual network’s link to this virtual network |
|  useRemoteGateways | boolean | No | Gets or sets if remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only 1 peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. |
|  remoteVirtualNetwork | object | No | Gets or sets the reference of the remote virtual network - [SubResource object](#SubResource) |
|  peeringState | enum | No | Gets the status of the virtual network peering. - Initiated, Connected, Disconnected |
|  provisioningState | string | No | Gets provisioning state of the resource |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |

