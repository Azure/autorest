# Microsoft.Logic/workflows/accessKeys template reference
API Version: 2015-02-01-preview
## Template format

To create a Microsoft.Logic/workflows/accessKeys resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Logic/workflows/accessKeys",
  "apiVersion": "2015-02-01-preview",
  "id": "string",
  "properties": {
    "notBefore": "string",
    "notAfter": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Logic/workflows/accessKeys" />
### Microsoft.Logic/workflows/accessKeys object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Logic/workflows/accessKeys |
|  apiVersion | enum | Yes | 2015-02-01-preview |
|  id | string | No | Gets or sets the resource id. |
|  properties | object | Yes | Gets or sets the workflow access key properties. - [WorkflowAccessKeyProperties object](#WorkflowAccessKeyProperties) |


<a id="WorkflowAccessKeyProperties" />
### WorkflowAccessKeyProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  notBefore | string | No | Gets or sets the not-before time. |
|  notAfter | string | No | Gets or sets the not-after time. |

