# Microsoft.Network/virtualnetworkgateways template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/virtualnetworkgateways resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/virtualnetworkgateways",
  "apiVersion": "2015-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "ipConfigurations": [
      {
        "id": "string",
        "properties": {
          "privateIPAddress": "string",
          "privateIPAllocationMethod": "string",
          "subnet": {
            "id": "string"
          },
          "publicIPAddress": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "gatewayType": "string",
    "vpnType": "string",
    "enableBgp": boolean,
    "gatewayDefaultSite": {
      "id": "string"
    },
    "resourceGuid": "string",
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/virtualnetworkgateways" />
### Microsoft.Network/virtualnetworkgateways object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/virtualnetworkgateways |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualNetworkGatewayPropertiesFormat object](#VirtualNetworkGatewayPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkGatewayPropertiesFormat" />
### VirtualNetworkGatewayPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ipConfigurations | array | No | IpConfigurations for Virtual network gateway. - [VirtualNetworkGatewayIpConfiguration object](#VirtualNetworkGatewayIpConfiguration) |
|  gatewayType | enum | No | The type of this virtual network gateway. - Vpn or ExpressRoute |
|  vpnType | enum | No | The type of this virtual network gateway. - PolicyBased or RouteBased |
|  enableBgp | boolean | No | EnableBgp Flag |
|  gatewayDefaultSite | object | No | Gets or sets the reference of the LocalNetworkGateway resource which represents Local network site having default routes. Assign Null value in case of removing existing default site setting. - [SubResource object](#SubResource) |
|  resourceGuid | string | No | Gets or sets resource guid property of the VirtualNetworkGateway resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the VirtualNetworkGateway resource Updating/Deleting/Failed |


<a id="VirtualNetworkGatewayIpConfiguration" />
### VirtualNetworkGatewayIpConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [VirtualNetworkGatewayIpConfigurationPropertiesFormat object](#VirtualNetworkGatewayIpConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="VirtualNetworkGatewayIpConfigurationPropertiesFormat" />
### VirtualNetworkGatewayIpConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the Network Interface IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [SubResource object](#SubResource) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |

