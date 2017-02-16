# Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules template reference
API Version: 2016-03-01
## Template format

To create a Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules",
  "apiVersion": "2016-03-01",
  "location": "string",
  "tags": {},
  "sku": {
    "name": "string",
    "tier": "string",
    "size": "string",
    "family": "string",
    "capacity": "integer"
  },
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules" />
### Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules |
|  apiVersion | enum | Yes | 2016-03-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | The sku of the created namespace - [Sku object](#Sku) |
|  properties | object | Yes | Properties of the Namespace AuthorizationRules. - [SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | Name of the notification hub sku. - Free, Basic, Standard |
|  tier | string | No | The tier of particular sku |
|  size | string | No | The Sku size |
|  family | string | No | The Sku Family |
|  capacity | integer | No | The capacity of the resource |


<a id="SharedAccessAuthorizationRuleProperties" />
### SharedAccessAuthorizationRuleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  rights | array | No | The rights associated with the rule. - Manage, Send, Listen |

