# Microsoft.DataLakeStore template schema

Creates a Microsoft.DataLakeStore resource.

## Schema format

To create a Microsoft.DataLakeStore, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.DataLakeStore/accounts/firewallRules",
  "apiVersion": "2015-10-01-preview",
  "properties": {
    "startIpAddress": "string",
    "endIpAddress": "string"
  }
}
```
```
{
  "type": "Microsoft.DataLakeStore/accounts",
  "apiVersion": "2015-10-01-preview",
  "properties": {
    "endpoint": "string",
    "defaultGroup": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="accounts_firewallRules" />
## accounts_firewallRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DataLakeStore/accounts/firewallRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  name | No | string<br /><br />Gets or sets the firewall rule's name. |
|  id | No | string<br /><br />Gets or sets the firewall rule's subscription ID. |
|  location | No | string<br /><br />Gets or sets the firewall rule's regional location. |
|  properties | Yes | object<br />[FirewallRuleProperties object](#FirewallRuleProperties)<br /><br />Gets or sets the properties of the firewall rule. |


<a id="accounts" />
## accounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DataLakeStore/accounts**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  location | No | string<br /><br />Gets or sets the account regional location. |
|  name | No | string<br /><br />Gets or sets the account name. |
|  tags | No | object<br /><br />Gets or sets the value of custom properties. |
|  properties | Yes | object<br />[DataLakeStoreAccountProperties object](#DataLakeStoreAccountProperties)<br /><br />Gets or sets the Data Lake Store account properties. |
|  resources | No | array<br />[firewallRules object](#firewallRules)<br /> |


<a id="FirewallRuleProperties" />
## FirewallRuleProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  startIpAddress | No | string<br /><br />Gets or sets the start IP address for the firewall rule. |
|  endIpAddress | No | string<br /><br />Gets or sets the end IP address for the firewall rule. |


<a id="DataLakeStoreAccountProperties" />
## DataLakeStoreAccountProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  endpoint | No | string<br /><br />Gets or sets the gateway host. |
|  defaultGroup | No | string<br /><br />Gets or sets the default owner group for all new folders and files created in the Data Lake Store account. |


<a id="accounts_firewallRules_childResource" />
## accounts_firewallRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**firewallRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-10-01-preview**<br /> |
|  name | No | string<br /><br />Gets or sets the firewall rule's name. |
|  id | No | string<br /><br />Gets or sets the firewall rule's subscription ID. |
|  location | No | string<br /><br />Gets or sets the firewall rule's regional location. |
|  properties | Yes | object<br />[FirewallRuleProperties object](#FirewallRuleProperties)<br /><br />Gets or sets the properties of the firewall rule. |

