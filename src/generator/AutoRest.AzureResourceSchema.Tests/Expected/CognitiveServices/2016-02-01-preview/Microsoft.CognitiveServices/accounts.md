# Microsoft.CognitiveServices/accounts template reference
API Version: 2016-02-01-preview
## Template format

To create a Microsoft.CognitiveServices/accounts resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.CognitiveServices/accounts",
  "apiVersion": "2016-02-01-preview",
  "sku": {
    "name": "string"
  },
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.CognitiveServices/accounts" />
### Microsoft.CognitiveServices/accounts object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.CognitiveServices/accounts |
|  apiVersion | enum | Yes | 2016-02-01-preview |
|  sku | object | Yes | [Sku object](#Sku) |
|  kind | enum | Yes | Required. Indicates the type of cognitive service account. - ComputerVision, Emotion, Face, LUIS, Recommendations, Speech, TextAnalytics, WebLM |
|  location | string | Yes | Required. Gets or sets the location of the resource. This will be one of the supported and registered Azure Geo Regions (e.g. West US, East US, Southeast Asia, etc.). The geo region of a resource cannot be changed once it is created, but if an identical geo region is specified on update the request will succeed. |
|  tags | object | No | Gets or sets a list of key value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. |
|  properties | object | Yes | Must exist in the request. Must not be null. |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | Gets or sets the sku name. Required for account creation, optional for update. - F0, S0, S1, S2, S3, S4 |

