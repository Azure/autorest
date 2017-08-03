# Microsoft.Logic/workflows template reference
API Version: 2016-06-01
## Template format

To create a Microsoft.Logic/workflows resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Logic/workflows",
  "apiVersion": "2016-06-01",
  "id": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "state": "string",
    "sku": {
      "name": "string",
      "plan": {
        "id": "string"
      }
    },
    "integrationAccount": {
      "id": "string"
    },
    "definition": {},
    "parameters": {}
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Logic/workflows" />
### Microsoft.Logic/workflows object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Logic/workflows |
|  apiVersion | enum | Yes | 2016-06-01 |
|  id | string | No | The resource id. |
|  location | string | No | The resource location. |
|  tags | object | No | The resource tags. |
|  properties | object | Yes | The workflow properties. - [WorkflowProperties object](#WorkflowProperties) |


<a id="WorkflowProperties" />
### WorkflowProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  state | enum | No | The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended |
|  sku | object | No | The sku. - [Sku object](#Sku) |
|  integrationAccount | object | No | The integration account. - [ResourceReference object](#ResourceReference) |
|  definition | object | No | The definition. |
|  parameters | object | No | The parameters. |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | The name. - NotSpecified, Free, Shared, Basic, Standard, Premium |
|  plan | object | No | The reference to plan. - [ResourceReference object](#ResourceReference) |


<a id="ResourceReference" />
### ResourceReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | The resource id. |

