# Microsoft.Network/localNetworkGateways template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.Network/localNetworkGateways resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/localNetworkGateways",
  "apiVersion": "2016-03-30",
  "id": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "localNetworkAddressSpace": {
      "addressPrefixes": [
        "string"
      ]
    },
    "gatewayIpAddress": "string",
    "bgpSettings": {
      "asn": "integer",
      "bgpPeeringAddress": "string",
      "peerWeight": "integer"
    },
    "resourceGuid": "string",
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/localNetworkGateways" />
### Microsoft.Network/localNetworkGateways object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/localNetworkGateways |
|  apiVersion | enum | Yes | 2016-03-30 |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [LocalNetworkGatewayPropertiesFormat object](#LocalNetworkGatewayPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="LocalNetworkGatewayPropertiesFormat" />
### LocalNetworkGatewayPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  localNetworkAddressSpace | object | No | Local network site Address space - [AddressSpace object](#AddressSpace) |
|  gatewayIpAddress | string | No | IP address of local network gateway. |
|  bgpSettings | object | No | Local network gateway's BGP speaker settings - [BgpSettings object](#BgpSettings) |
|  resourceGuid | string | No | Gets or sets resource guid property of the LocalNetworkGateway resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the LocalNetworkGateway resource Updating/Deleting/Failed |


<a id="AddressSpace" />
### AddressSpace object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefixes | array | No | Gets or sets List of address blocks reserved for this virtual network in CIDR notation - string |


<a id="BgpSettings" />
### BgpSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  asn | integer | No | Gets or sets this BGP speaker's ASN |
|  bgpPeeringAddress | string | No | Gets or sets the BGP peering address and BGP identifier of this BGP speaker |
|  peerWeight | integer | No | Gets or sets the weight added to routes learned from this BGP speaker |

