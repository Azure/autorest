# Microsoft.MachineLearning/webServices template reference
API Version: 2016-05-01-preview
## Template format

To create a Microsoft.MachineLearning/webServices resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.MachineLearning/webServices",
  "apiVersion": "2016-05-01-preview",
  "name": "string",
  "location": "string",
  "tags": {},
  "properties": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.MachineLearning/webServices" />
### Microsoft.MachineLearning/webServices object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.MachineLearning/webServices |
|  apiVersion | enum | Yes | 2016-05-01-preview |
|  name | string | No | Resource Name |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | Web service resource properties. - [WebServiceProperties object](#WebServiceProperties) |

