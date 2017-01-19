# microsoft.insights/alertrules template reference
API Version: 2016-03-01
## Template format

To create a microsoft.insights/alertrules resource, add the following JSON to the resources section of your template.

```json
{
  "type": "microsoft.insights/alertrules",
  "apiVersion": "2016-03-01",
  "name": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "name": "string",
    "description": "string",
    "isEnabled": boolean,
    "condition": {},
    "actions": [
      {}
    ]
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="microsoft.insights/alertrules" />
### microsoft.insights/alertrules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | microsoft.insights/alertrules |
|  apiVersion | enum | Yes | 2016-03-01 |
|  name | string | No | Azure resource name |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [AlertRule object](#AlertRule) |


<a id="AlertRule" />
### AlertRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | the name of the alert rule. |
|  description | string | No | the description of the alert rule that will be included in the alert email. |
|  isEnabled | boolean | Yes | the flag that indicates whether the alert rule is enabled. |
|  condition | object | No | the condition that results in the alert rule being activated. - [RuleCondition object](#RuleCondition) |
|  actions | array | No | the actions that are performed when the alert rule becomes active, and when an alert condition is resolved. - [RuleAction object](#RuleAction) |

