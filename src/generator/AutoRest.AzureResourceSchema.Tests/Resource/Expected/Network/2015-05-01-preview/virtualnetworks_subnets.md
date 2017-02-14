# Microsoft.Network/virtualnetworks/subnets template reference
API Version: 2015-05-01-preview
## Template format

To create a Microsoft.Network/virtualnetworks/subnets resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/virtualnetworks/subnets",
  "apiVersion": "2015-05-01-preview",
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
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/virtualnetworks/subnets" />
### Microsoft.Network/virtualnetworks/subnets object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/virtualnetworks/subnets |
|  apiVersion | enum | Yes | 2015-05-01-preview |
|  id | string | No | Resource Id |
|  properties | object | Yes | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
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

