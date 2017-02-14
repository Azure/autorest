# Microsoft.ApiManagement/service/loggers template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/loggers resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ApiManagement/service/loggers",
  "apiVersion": "2016-07-07",
  "description": "string",
  "credentials": {},
  "isBuffered": boolean
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/loggers" />
### Microsoft.ApiManagement/service/loggers object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ApiManagement/service/loggers |
|  apiVersion | enum | Yes | 2016-07-07 |
|  description | string | No | Logger description. |
|  credentials | object | Yes | Logger credentials. |
|  isBuffered | boolean | No | whether records are buffered in the logger before publishing. Default is assumed to be true. |

