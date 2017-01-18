# Microsoft.ServiceBus/namespaces/queues/authorizationRules template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.ServiceBus/namespaces/queues/authorizationRules resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ServiceBus/namespaces/queues/authorizationRules",
  "apiVersion": "2015-08-01",
  "location": "string",
  "name": "string",
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ServiceBus/namespaces/queues/authorizationRules" />
### Microsoft.ServiceBus/namespaces/queues/authorizationRules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ServiceBus/namespaces/queues/authorizationRules |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | No | data center location. |
|  name | string | No | Name of the AuthorizationRule. |
|  properties | object | Yes | [SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties) |


<a id="SharedAccessAuthorizationRuleProperties" />
### SharedAccessAuthorizationRuleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  rights | array | Yes | The rights associated with the rule. - Manage, Send, Listen |

