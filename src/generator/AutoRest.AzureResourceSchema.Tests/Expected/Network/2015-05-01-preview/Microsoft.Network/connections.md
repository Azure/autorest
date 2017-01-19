# Microsoft.Network/connections template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/connections resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/connections",
  "apiVersion": "2015-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "virtualNetworkGateway1": {
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
    },
    "virtualNetworkGateway2": {
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
    },
    "localNetworkGateway2": {
      "location": "string",
      "tags": {},
      "properties": {
        "localNetworkAddressSpace": {
          "addressPrefixes": [
            "string"
          ]
        },
        "gatewayIpAddress": "string",
        "resourceGuid": "string",
        "provisioningState": "string"
      },
      "etag": "string"
    },
    "connectionType": "string",
    "routingWeight": "integer",
    "sharedKey": "string",
    "connectionStatus": "string",
    "egressBytesTransferred": "integer",
    "ingressBytesTransferred": "integer",
    "peer": {
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

<a id="Microsoft.Network/connections" />
### Microsoft.Network/connections object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Network/connections |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualNetworkGatewayConnectionPropertiesFormat object](#VirtualNetworkGatewayConnectionPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkGatewayConnectionPropertiesFormat" />
### VirtualNetworkGatewayConnectionPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualNetworkGateway1 | object | No | [VirtualNetworkGateway object](#VirtualNetworkGateway) |
|  virtualNetworkGateway2 | object | No | [VirtualNetworkGateway object](#VirtualNetworkGateway) |
|  localNetworkGateway2 | object | No | [LocalNetworkGateway object](#LocalNetworkGateway) |
|  connectionType | enum | No | Gateway connection type -Ipsec/Dedicated/VpnClient/Vnet2Vnet. - IPsec, Vnet2Vnet, ExpressRoute, VPNClient |
|  routingWeight | integer | No | The Routing weight. |
|  sharedKey | string | No | The Ipsec share key. |
|  connectionStatus | enum | No | Virtual network Gateway connection status. - Unknown, Connecting, Connected, NotConnected |
|  egressBytesTransferred | integer | No | The Egress Bytes Transferred in this connection |
|  ingressBytesTransferred | integer | No | The Ingress Bytes Transferred in this connection |
|  peer | object | No | The reference to peerings resource. - [SubResource object](#SubResource) |
|  resourceGuid | string | No | Gets or sets resource guid property of the VirtualNetworkGatewayConnection resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the VirtualNetworkGatewayConnection resource Updating/Deleting/Failed |


<a id="VirtualNetworkGateway" />
### VirtualNetworkGateway object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [VirtualNetworkGatewayPropertiesFormat object](#VirtualNetworkGatewayPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="LocalNetworkGateway" />
### LocalNetworkGateway object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [LocalNetworkGatewayPropertiesFormat object](#LocalNetworkGatewayPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


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


<a id="LocalNetworkGatewayPropertiesFormat" />
### LocalNetworkGatewayPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  localNetworkAddressSpace | object | No | Local network site Address space - [AddressSpace object](#AddressSpace) |
|  gatewayIpAddress | string | No | IP address of local network gateway. |
|  resourceGuid | string | No | Gets or sets resource guid property of the LocalNetworkGateway resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the LocalNetworkGateway resource Updating/Deleting/Failed |


<a id="VirtualNetworkGatewayIpConfiguration" />
### VirtualNetworkGatewayIpConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [VirtualNetworkGatewayIpConfigurationPropertiesFormat object](#VirtualNetworkGatewayIpConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="AddressSpace" />
### AddressSpace object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefixes | array | No | Gets or sets List of address blocks reserved for this virtual network in CIDR notation - string |


<a id="VirtualNetworkGatewayIpConfigurationPropertiesFormat" />
### VirtualNetworkGatewayIpConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the Network Interface IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [SubResource object](#SubResource) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |

