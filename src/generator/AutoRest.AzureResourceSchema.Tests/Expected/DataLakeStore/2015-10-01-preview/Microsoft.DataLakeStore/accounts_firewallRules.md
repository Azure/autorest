# Microsoft.DataLakeStore/accounts/firewallRules template reference
API Version: 2015-10-01-preview
## Template format

To create a Microsoft.DataLakeStore/accounts/firewallRules resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.DataLakeStore/accounts/firewallRules",
  "apiVersion": "2015-10-01-preview",
  "name": "string",
  "id": "string",
  "location": "string",
  "properties": {
    "startIpAddress": "string",
    "endIpAddress": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DataLakeStore/accounts/firewallRules" />
### Microsoft.DataLakeStore/accounts/firewallRules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.DataLakeStore/accounts/firewallRules |
|  apiVersion | enum | Yes | 2015-10-01-preview |
|  name | string | No | Gets or sets the firewall rule's name. |
|  id | string | No | Gets or sets the firewall rule's subscription ID. |
|  location | string | No | Gets or sets the firewall rule's regional location. |
|  properties | object | Yes | Gets or sets the properties of the firewall rule. - [FirewallRuleProperties object](#FirewallRuleProperties) |


<a id="FirewallRuleProperties" />
### FirewallRuleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  startIpAddress | string | No | Gets or sets the start IP address for the firewall rule. |
|  endIpAddress | string | No | Gets or sets the end IP address for the firewall rule. |

