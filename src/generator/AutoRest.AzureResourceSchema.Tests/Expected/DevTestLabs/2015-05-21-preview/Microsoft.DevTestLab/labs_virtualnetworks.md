# Microsoft.DevTestLab/labs/virtualnetworks template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs/virtualnetworks resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.DevTestLab/labs/virtualnetworks",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "allowedSubnets": [
      {
        "resourceId": "string",
        "labSubnetName": "string",
        "allowPublicIp": "string"
      }
    ],
    "description": "string",
    "externalProviderResourceId": "string",
    "subnetOverrides": [
      {
        "resourceId": "string",
        "labSubnetName": "string",
        "useInVmCreationPermission": "string",
        "usePublicIpAddressPermission": "string"
      }
    ],
    "provisioningState": "string"
  },
  "id": "string",
  "name": "string",
  "location": "string",
  "tags": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs/virtualnetworks" />
### Microsoft.DevTestLab/labs/virtualnetworks object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.DevTestLab/labs/virtualnetworks |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [VirtualNetworkProperties object](#VirtualNetworkProperties) |
|  id | string | No | The identifier of the resource. |
|  name | string | No | The name of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="VirtualNetworkProperties" />
### VirtualNetworkProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allowedSubnets | array | No | The allowed subnets of the virtual network. - [Subnet object](#Subnet) |
|  description | string | No | The description of the virtual network. |
|  externalProviderResourceId | string | No | The Microsoft.Network resource identifier of the virtual network. |
|  subnetOverrides | array | No | The subnet overrides of the virtual network. - [SubnetOverride object](#SubnetOverride) |
|  provisioningState | string | No | The provisioning status of the resource. |


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  resourceId | string | No |  |
|  labSubnetName | string | No |  |
|  allowPublicIp | enum | No | Default, Deny, Allow |


<a id="SubnetOverride" />
### SubnetOverride object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  resourceId | string | No | The resource identifier of the subnet. |
|  labSubnetName | string | No | The name given to the subnet within the lab. |
|  useInVmCreationPermission | enum | No | Indicates whether this subnet can be used during virtual machine creation. - Default, Deny, Allow |
|  usePublicIpAddressPermission | enum | No | Indicates whether public IP addresses can be assigned to virtual machines on this subnet. - Default, Deny, Allow |

