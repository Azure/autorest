# Microsoft.Network/virtualnetworks template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/virtualnetworks resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/virtualnetworks",
  "apiVersion": "2015-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "addressSpace": {
      "addressPrefixes": [
        "string"
      ]
    },
    "dhcpOptions": {
      "dnsServers": [
        "string"
      ]
    },
    "subnets": [
      {
        "id": "string",
        "properties": {
          "addressPrefix": "string",
          "networkSecurityGroup": {
            "id": "string"
          },
          "routeTable": {
            "id": "string"
          },
          "ipConfigurations": [
            {
              "id": "string"
            }
          ],
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "resourceGuid": "string",
    "provisioningState": "string"
  },
  "etag": "string",
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/virtualnetworks" />
### Microsoft.Network/virtualnetworks object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/virtualnetworks |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualNetworkPropertiesFormat object](#VirtualNetworkPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |
|  resources | array | No | [virtualnetworks_subnets_childResource object](#virtualnetworks_subnets_childResource) |


<a id="VirtualNetworkPropertiesFormat" />
### VirtualNetworkPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressSpace | object | No | Gets or sets AddressSpace that contains an array of IP address ranges that can be used by subnets - [AddressSpace object](#AddressSpace) |
|  dhcpOptions | object | No | Gets or sets DHCPOptions that contains an array of DNS servers available to VMs deployed in the virtual network - [DhcpOptions object](#DhcpOptions) |
|  subnets | array | No | Gets or sets List of subnets in a VirtualNetwork - [Subnet object](#Subnet) |
|  resourceGuid | string | No | Gets or sets resource guid property of the VirtualNetwork resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="virtualnetworks_subnets_childResource" />
### virtualnetworks_subnets_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | subnets |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  id | string | No | Resource Id |
|  properties | object | Yes | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="AddressSpace" />
### AddressSpace object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefixes | array | No | Gets or sets List of address blocks reserved for this virtual network in CIDR notation - string |


<a id="DhcpOptions" />
### DhcpOptions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  dnsServers | array | No | Gets or sets list of DNS servers IP addresses - string |


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SubnetPropertiesFormat" />
### SubnetPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | Yes | Gets or sets Address prefix for the subnet. |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [SubResource object](#SubResource) |
|  routeTable | object | No | Gets or sets the reference of the RouteTable resource - [SubResource object](#SubResource) |
|  ipConfigurations | array | No | Gets array of references to the network interface IP configurations using subnet - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |

