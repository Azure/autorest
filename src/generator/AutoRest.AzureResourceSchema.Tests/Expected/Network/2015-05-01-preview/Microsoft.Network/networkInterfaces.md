# Microsoft.Network/networkInterfaces template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/networkInterfaces resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/networkInterfaces",
  "apiVersion": "2015-05-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "virtualMachine": {
      "id": "string"
    },
    "networkSecurityGroup": {
      "id": "string"
    },
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
          "loadBalancerBackendAddressPools": [
            {
              "id": "string"
            }
          ],
          "loadBalancerInboundNatRules": [
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
    "dnsSettings": {
      "dnsServers": [
        "string"
      ],
      "appliedDnsServers": [
        "string"
      ],
      "internalDnsNameLabel": "string",
      "internalFqdn": "string"
    },
    "macAddress": "string",
    "primary": boolean,
    "enableIPForwarding": boolean,
    "resourceGuid": "string",
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/networkInterfaces" />
### Microsoft.Network/networkInterfaces object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Network/networkInterfaces |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [NetworkInterfacePropertiesFormat object](#NetworkInterfacePropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterfacePropertiesFormat" />
### NetworkInterfacePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualMachine | object | No | Gets or sets the reference of a VirtualMachine - [SubResource object](#SubResource) |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [SubResource object](#SubResource) |
|  ipConfigurations | array | No | Gets or sets list of IPConfigurations of the NetworkInterface - [NetworkInterfaceIpConfiguration object](#NetworkInterfaceIpConfiguration) |
|  dnsSettings | object | No | Gets or sets DNS Settings in  NetworkInterface - [NetworkInterfaceDnsSettings object](#NetworkInterfaceDnsSettings) |
|  macAddress | string | No | Gets the MAC Address of the network interface |
|  primary | boolean | No | Gets whether this is a primary NIC on a virtual machine |
|  enableIPForwarding | boolean | No | Gets or sets whether IPForwarding is enabled on the NIC |
|  resourceGuid | string | No | Gets or sets resource guid property of the network interface resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="NetworkInterfaceIpConfiguration" />
### NetworkInterfaceIpConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [NetworkInterfaceIpConfigurationPropertiesFormat object](#NetworkInterfaceIpConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterfaceDnsSettings" />
### NetworkInterfaceDnsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  dnsServers | array | No | Gets or sets list of DNS servers IP addresses - string |
|  appliedDnsServers | array | No | Gets or sets list of Applied DNS servers IP addresses - string |
|  internalDnsNameLabel | string | No | Gets or sets the Internal DNS name |
|  internalFqdn | string | No | Gets or sets full IDNS name in the form, DnsName.VnetId.ZoneId.TopleveSuffix. This is set when the NIC is associated to a VM |


<a id="NetworkInterfaceIpConfigurationPropertiesFormat" />
### NetworkInterfaceIpConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the Network Interface IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [SubResource object](#SubResource) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [SubResource object](#SubResource) |
|  loadBalancerBackendAddressPools | array | No | Gets or sets the reference of LoadBalancerBackendAddressPool resource - [SubResource object](#SubResource) |
|  loadBalancerInboundNatRules | array | No | Gets or sets list of references of LoadBalancerInboundNatRules - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |

