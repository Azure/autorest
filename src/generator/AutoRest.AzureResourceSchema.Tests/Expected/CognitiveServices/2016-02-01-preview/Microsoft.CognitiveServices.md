# Microsoft.CognitiveServices template schema

Creates a Microsoft.CognitiveServices resource.

## Schema format

To create a Microsoft.CognitiveServices, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.CognitiveServices/accounts",
  "apiVersion": "2016-02-01-preview",
  "sku": {
    "name": "string"
  },
  "kind": "string",
  "location": "string",
  "properties": {}
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="accounts" />
## accounts object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.CognitiveServices/accounts**<br /> |
|  apiVersion | Yes | enum<br />**2016-02-01-preview**<br /> |
|  sku | Yes | object<br />[Sku object](#Sku)<br /> |
|  kind | Yes | enum<br />**ComputerVision**, **Emotion**, **Face**, **LUIS**, **Recommendations**, **Speech**, **TextAnalytics**, **WebLM**<br /><br />Required. Indicates the type of cognitive service account. |
|  location | Yes | string<br /><br />Required. Gets or sets the location of the resource. This will be one of the supported and registered Azure Geo Regions (e.g. West US, East US, Southeast Asia, etc.). The geo region of a resource cannot be changed once it is created, but if an identical geo region is specified on update the request will succeed. |
|  tags | No | object<br /><br />Gets or sets a list of key value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. |
|  properties | Yes | object<br /><br />Must exist in the request. Must not be null. |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | enum<br />**F0**, **S0**, **S1**, **S2**, **S3**, **S4**<br /><br />Gets or sets the sku name. Required for account creation, optional for update. |

