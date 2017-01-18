# Microsoft.Network/networkSecurityGroups template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Network/networkSecurityGroups resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/networkSecurityGroups",
  "apiVersion": "2016-09-01",
  "id": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "securityRules": [
      {
        "id": "string",
        "properties": {
          "description": "string",
          "protocol": "string",
          "sourcePortRange": "string",
          "destinationPortRange": "string",
          "sourceAddressPrefix": "string",
          "destinationAddressPrefix": "string",
          "access": "string",
          "priority": "integer",
          "direction": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "defaultSecurityRules": [
      {
        "id": "string",
        "properties": {
          "description": "string",
          "protocol": "string",
          "sourcePortRange": "string",
          "destinationPortRange": "string",
          "sourceAddressPrefix": "string",
          "destinationAddressPrefix": "string",
          "access": "string",
          "priority": "integer",
          "direction": "string",
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

<a id="Microsoft.Network/networkSecurityGroups" />
### Microsoft.Network/networkSecurityGroups object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Network/networkSecurityGroups |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [NetworkSecurityGroupPropertiesFormat object](#NetworkSecurityGroupPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |
|  resources | array | No | [networkSecurityGroups_securityRules_childResource object](#networkSecurityGroups_securityRules_childResource) |


<a id="NetworkSecurityGroupPropertiesFormat" />
### NetworkSecurityGroupPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  securityRules | array | No | Gets or sets security rules of network security group - [SecurityRule object](#SecurityRule) |
|  defaultSecurityRules | array | No | Gets or default security rules of network security group - [SecurityRule object](#SecurityRule) |
|  resourceGuid | string | No | Gets or sets resource guid property of the network security group resource |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="networkSecurityGroups_securityRules_childResource" />
### networkSecurityGroups_securityRules_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | securityRules |
|  apiVersion | enum | Yes | 2016-09-01 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SecurityRule" />
### SecurityRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SecurityRulePropertiesFormat" />
### SecurityRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  description | string | No | Gets or sets a description for this rule. Restricted to 140 chars. |
|  protocol | enum | Yes | Gets or sets Network protocol this rule applies to. Can be Tcp, Udp or All(*). - Tcp, Udp, * |
|  sourcePortRange | string | No | Gets or sets Source Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  destinationPortRange | string | No | Gets or sets Destination Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  sourceAddressPrefix | string | Yes | Gets or sets source address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from.  |
|  destinationAddressPrefix | string | Yes | Gets or sets destination address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.  |
|  access | enum | Yes | Gets or sets network traffic is allowed or denied. Possible values are 'Allow' and 'Deny'. - Allow or Deny |
|  priority | integer | No | Gets or sets the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
|  direction | enum | Yes | Gets or sets the direction of the rule.InBound or Outbound. The direction specifies if rule will be evaluated on incoming or outcoming traffic. - Inbound or Outbound |
|  provisioningState | string | No | Gets provisioning state of the PublicIP resource Updating/Deleting/Failed |

