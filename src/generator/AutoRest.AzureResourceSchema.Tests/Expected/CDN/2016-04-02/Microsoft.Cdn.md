# Microsoft.Cdn template schema

Creates a Microsoft.Cdn resource.

## Schema format

To create a Microsoft.Cdn, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Cdn/profiles",
  "apiVersion": "2016-04-02",
  "location": "string",
  "sku": {
    "name": "string"
  }
}
```
```
{
  "type": "Microsoft.Cdn/profiles/endpoints",
  "apiVersion": "2016-04-02",
  "location": "string",
  "properties": {
    "originHostHeader": "string",
    "originPath": "string",
    "contentTypesToCompress": [
      "string"
    ],
    "isCompressionEnabled": "boolean",
    "isHttpAllowed": "boolean",
    "isHttpsAllowed": "boolean",
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
  }
}
```
```
{
  "type": "Microsoft.Cdn/profiles/endpoints/origins",
  "apiVersion": "2016-04-02",
  "properties": {
    "hostName": "string",
    "httpPort": "integer",
    "httpsPort": "integer"
  }
}
```
```
{
  "type": "Microsoft.Cdn/profiles/endpoints/customDomains",
  "apiVersion": "2016-04-02",
  "properties": {
    "hostName": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="profiles" />
## profiles object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Cdn/profiles**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  location | Yes | string<br /><br />Profile location |
|  tags | No | object<br /><br />Profile tags |
|  sku | Yes | object<br />[Sku object](#Sku)<br /><br />The SKU (pricing tier) of the CDN profile. |
|  resources | No | array<br />[endpoints object](#endpoints)<br /> |


<a id="profiles_endpoints" />
## profiles_endpoints object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Cdn/profiles/endpoints**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  location | Yes | string<br /><br />Endpoint location |
|  tags | No | object<br /><br />Endpoint tags |
|  properties | Yes | object<br />[EndpointPropertiesCreateParameters object](#EndpointPropertiesCreateParameters)<br /> |
|  resources | No | array<br />[customDomains object](#customDomains)<br />[origins object](#origins)<br /> |


<a id="profiles_endpoints_origins" />
## profiles_endpoints_origins object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Cdn/profiles/endpoints/origins**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  properties | Yes | object<br />[OriginPropertiesParameters object](#OriginPropertiesParameters)<br /> |


<a id="profiles_endpoints_customDomains" />
## profiles_endpoints_customDomains object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Cdn/profiles/endpoints/customDomains**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  properties | Yes | object<br />[CustomDomainPropertiesParameters object](#CustomDomainPropertiesParameters)<br /> |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Standard_Verizon**, **Premium_Verizon**, **Custom_Verizon**, **Standard_Akamai**<br /><br />Name of the pricing tier. |


<a id="EndpointPropertiesCreateParameters" />
## EndpointPropertiesCreateParameters object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  originHostHeader | No | string<br /><br />The host header CDN provider will send along with content requests to origins. The default value is the host name of the origin. |
|  originPath | No | string<br /><br />The path used for origin requests. |
|  contentTypesToCompress | No | array<br />**string**<br /><br />List of content types on which compression will be applied. The value for the elements should be a valid MIME type. |
|  isCompressionEnabled | No | boolean<br /><br />Indicates whether content compression is enabled. Default value is false. If compression is enabled, the content transferred from the CDN endpoint to the end user will be compressed. The requested content must be larger than 1 byte and smaller than 1 MB. |
|  isHttpAllowed | No | boolean<br /><br />Indicates whether HTTP traffic is allowed on the endpoint. Default value is true. At least one protocol (HTTP or HTTPS) must be allowed. |
|  isHttpsAllowed | No | boolean<br /><br />Indicates whether https traffic is allowed on the endpoint. Default value is true. At least one protocol (HTTP or HTTPS) must be allowed. |
|  queryStringCachingBehavior | No | enum<br />**IgnoreQueryString**, **BypassCaching**, **UseQueryString**, **NotSet**<br /><br />Defines the query string caching behavior. |
|  origins | Yes | array<br />[DeepCreatedOrigin object](#DeepCreatedOrigin)<br /><br />The set of origins for the CDN endpoint. When multiple origins exist, the first origin will be used as primary and rest will be used as failover options. |


<a id="DeepCreatedOrigin" />
## DeepCreatedOrigin object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Origin name |
|  properties | No | object<br />[DeepCreatedOriginProperties object](#DeepCreatedOriginProperties)<br /> |


<a id="DeepCreatedOriginProperties" />
## DeepCreatedOriginProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  hostName | Yes | string<br /><br />The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported. |
|  httpPort | No | integer<br /><br />The value of the HTTP port. Must be between 1 and 65535 |
|  httpsPort | No | integer<br /><br />The value of the HTTPS port. Must be between 1 and 65535 |


<a id="OriginPropertiesParameters" />
## OriginPropertiesParameters object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  hostName | Yes | string<br /><br />The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported. |
|  httpPort | No | integer<br /><br />The value of the HTTP port. Must be between 1 and 65535. |
|  httpsPort | No | integer<br /><br />The value of the HTTPS port. Must be between 1 and 65535. |


<a id="CustomDomainPropertiesParameters" />
## CustomDomainPropertiesParameters object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  hostName | Yes | string<br /><br />The host name of the custom domain. Must be a domain name. |


<a id="profiles_endpoints_customDomains_childResource" />
## profiles_endpoints_customDomains_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**customDomains**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  properties | Yes | object<br />[CustomDomainPropertiesParameters object](#CustomDomainPropertiesParameters)<br /> |


<a id="profiles_endpoints_origins_childResource" />
## profiles_endpoints_origins_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**origins**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  properties | Yes | object<br />[OriginPropertiesParameters object](#OriginPropertiesParameters)<br /> |


<a id="profiles_endpoints_childResource" />
## profiles_endpoints_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**endpoints**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-02**<br /> |
|  location | Yes | string<br /><br />Endpoint location |
|  tags | No | object<br /><br />Endpoint tags |
|  properties | Yes | object<br />[EndpointPropertiesCreateParameters object](#EndpointPropertiesCreateParameters)<br /> |
|  resources | No | array<br />[customDomains object](#customDomains)<br />[origins object](#origins)<br /> |

