# Microsoft.Cdn/profiles/endpoints/origins template reference
API Version: 2016-04-02
## Template format

To create a Microsoft.Cdn/profiles/endpoints/origins resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Cdn/profiles/endpoints/origins",
  "apiVersion": "2016-04-02",
  "properties": {
    "hostName": "string",
    "httpPort": "integer",
    "httpsPort": "integer"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Cdn/profiles/endpoints/origins" />
### Microsoft.Cdn/profiles/endpoints/origins object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Cdn/profiles/endpoints/origins |
|  apiVersion | enum | Yes | 2016-04-02 |
|  properties | object | Yes | [OriginPropertiesParameters object](#OriginPropertiesParameters) |


<a id="OriginPropertiesParameters" />
### OriginPropertiesParameters object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  hostName | string | Yes | The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported. |
|  httpPort | integer | No | The value of the HTTP port. Must be between 1 and 65535. |
|  httpsPort | integer | No | The value of the HTTPS port. Must be between 1 and 65535. |

