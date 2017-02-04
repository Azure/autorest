# Microsoft.Network/networkSecurityGroups/securityRules template reference
API Version: 2015-06-15
## Template format

To create a Microsoft.Network/networkSecurityGroups/securityRules resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/networkSecurityGroups/securityRules",
  "apiVersion": "2015-06-15",
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
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/networkSecurityGroups/securityRules" />
### Microsoft.Network/networkSecurityGroups/securityRules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/networkSecurityGroups/securityRules |
|  apiVersion | enum | Yes | 2015-06-15 |
|  id | string | No | Resource Id |
|  properties | object | Yes | [SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat) |
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
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |

