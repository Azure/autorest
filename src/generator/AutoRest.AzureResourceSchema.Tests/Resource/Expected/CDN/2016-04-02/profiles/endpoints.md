# Microsoft.Cdn/profiles/endpoints template reference
API Version: 2016-04-02
## Template format

To create a Microsoft.Cdn/profiles/endpoints resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Cdn/profiles/endpoints",
  "apiVersion": "2016-04-02",
  "location": "string",
  "tags": {},
  "properties": {
    "originHostHeader": "string",
    "originPath": "string",
    "contentTypesToCompress": [
      "string"
    ],
    "isCompressionEnabled": boolean,
    "isHttpAllowed": boolean,
    "isHttpsAllowed": boolean,
    "queryStringCachingBehavior": "string",
    "origins": [
      {
        "name": "string",
        "properties": {
          "hostName": "string",
          "httpPort": "integer",
          "httpsPort": "integer"
        }
      }
    ]
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Cdn/profiles/endpoints" />
### Microsoft.Cdn/profiles/endpoints object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Cdn/profiles/endpoints |
|  apiVersion | enum | Yes | 2016-04-02 |
|  location | string | Yes | Endpoint location |
|  tags | object | No | Endpoint tags |
|  properties | object | Yes | [EndpointPropertiesCreateParameters object](#EndpointPropertiesCreateParameters) |
|  resources | array | No | [customDomains](./endpoints/customDomains.md) [origins](./endpoints/origins.md) |


<a id="EndpointPropertiesCreateParameters" />
### EndpointPropertiesCreateParameters object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  originHostHeader | string | No | The host header CDN provider will send along with content requests to origins. The default value is the host name of the origin. |
|  originPath | string | No | The path used for origin requests. |
|  contentTypesToCompress | array | No | List of content types on which compression will be applied. The value for the elements should be a valid MIME type. - string |
|  isCompressionEnabled | boolean | No | Indicates whether content compression is enabled. Default value is false. If compression is enabled, the content transferred from the CDN endpoint to the end user will be compressed. The requested content must be larger than 1 byte and smaller than 1 MB. |
|  isHttpAllowed | boolean | No | Indicates whether HTTP traffic is allowed on the endpoint. Default value is true. At least one protocol (HTTP or HTTPS) must be allowed. |
|  isHttpsAllowed | boolean | No | Indicates whether https traffic is allowed on the endpoint. Default value is true. At least one protocol (HTTP or HTTPS) must be allowed. |
|  queryStringCachingBehavior | enum | No | Defines the query string caching behavior. - IgnoreQueryString, BypassCaching, UseQueryString, NotSet |
|  origins | array | Yes | The set of origins for the CDN endpoint. When multiple origins exist, the first origin will be used as primary and rest will be used as failover options. - [DeepCreatedOrigin object](#DeepCreatedOrigin) |


<a id="DeepCreatedOrigin" />
### DeepCreatedOrigin object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Origin name |
|  properties | object | No | [DeepCreatedOriginProperties object](#DeepCreatedOriginProperties) |


<a id="DeepCreatedOriginProperties" />
### DeepCreatedOriginProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  hostName | string | Yes | The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported. |
|  httpPort | integer | No | The value of the HTTP port. Must be between 1 and 65535 |
|  httpsPort | integer | No | The value of the HTTPS port. Must be between 1 and 65535 |

