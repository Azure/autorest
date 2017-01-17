# Microsoft.ApiManagement/service/properties template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/properties resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ApiManagement/service/properties",
  "apiVersion": "2016-07-07",
  "name": "string",
  "value": "string",
  "tags": [
    "string"
  ],
  "secret": boolean
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/properties" />
### Microsoft.ApiManagement/service/properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ApiManagement/service/properties |
|  apiVersion | enum | Yes | 2016-07-07 |
|  name | string | Yes | Unique name of Property. |
|  value | string | Yes | The Value of the Property. |
|  tags | array | No | Collection of tags associated with a property. - string |
|  secret | boolean | No | The value which determines the value should be encrypted or not. Default value is false. |

