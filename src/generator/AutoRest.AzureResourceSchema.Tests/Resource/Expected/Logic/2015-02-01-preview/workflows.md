# Microsoft.Logic/workflows template reference
API Version: 2015-02-01-preview
## Template format

To create a Microsoft.Logic/workflows resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Logic/workflows",
  "apiVersion": "2015-02-01-preview",
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
    "definitionLink": {
      "uri": "string",
      "contentVersion": "string",
      "contentSize": "integer",
      "contentHash": {
        "algorithm": "string",
        "value": "string"
      },
      "metadata": {}
    },
    "definition": {},
    "parametersLink": {
      "uri": "string",
      "contentVersion": "string",
      "contentSize": "integer",
      "contentHash": {
        "algorithm": "string",
        "value": "string"
      },
      "metadata": {}
    },
    "parameters": {}
  },
  "resources": []
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
|  apiVersion | enum | Yes | 2015-02-01-preview |
|  id | string | No | Gets or sets the resource id. |
|  location | string | No | Gets or sets the resource location. |
|  tags | object | No | Gets or sets the resource tags. |
|  properties | object | Yes | Gets or sets the workflow properties. - [WorkflowProperties object](#WorkflowProperties) |
|  resources | array | No | [accessKeys](./workflows/accessKeys.md) |


<a id="WorkflowProperties" />
### WorkflowProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  state | enum | No | Gets or sets the state. - NotSpecified, Enabled, Disabled, Deleted, Suspended |
|  sku | object | No | Gets or sets the sku. - [Sku object](#Sku) |
|  definitionLink | object | No | Gets or sets the link to definition. - [ContentLink object](#ContentLink) |
|  definition | object | No | Gets or sets the definition. |
|  parametersLink | object | No | Gets or sets the link to parameters. - [ContentLink object](#ContentLink) |
|  parameters | object | No | Gets or sets the parameters. |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Gets or sets the name. - NotSpecified, Free, Shared, Basic, Standard, Premium |
|  plan | object | No | Gets or sets the reference to plan. - [ResourceReference object](#ResourceReference) |


<a id="ContentLink" />
### ContentLink object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  uri | string | No | Gets or sets the content link URI. |
|  contentVersion | string | No | Gets or sets the content version. |
|  contentSize | integer | No | Gets or sets the content size. |
|  contentHash | object | No | Gets or sets the content hash. - [ContentHash object](#ContentHash) |
|  metadata | object | No | Gets or sets the metadata. |


<a id="ResourceReference" />
### ResourceReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Gets or sets the resource id. |


<a id="ContentHash" />
### ContentHash object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  algorithm | string | No | Gets or sets the algorithm. |
|  value | string | No | Gets or sets the value. |

