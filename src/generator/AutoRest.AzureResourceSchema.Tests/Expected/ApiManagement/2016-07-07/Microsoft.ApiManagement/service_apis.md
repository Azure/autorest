# Microsoft.ApiManagement/service/apis template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/apis resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ApiManagement/service/apis",
  "apiVersion": "2016-07-07",
  "ApiContract": {
    "name": "string",
    "description": "string",
    "serviceUrl": "string",
    "path": "string",
    "protocols": [
      "string"
    ],
    "authenticationSettings": {
      "oAuth2": {
        "authorizationServerId": "string",
        "scope": "string"
      }
    },
    "subscriptionKeyParameterNames": {
      "header": "string",
      "query": "string"
    },
    "type": "string"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/apis" />
### Microsoft.ApiManagement/service/apis object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ApiManagement/service/apis |
|  apiVersion | enum | Yes | 2016-07-07 |
|  ApiContract | object | Yes | ApiContract. - [ApiContract object](#ApiContract) |
|  resources | array | No | [service_apis_operations_childResource object](#service_apis_operations_childResource) |


<a id="ApiContract" />
### ApiContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | API name. |
|  description | string | No | Description of the API. May include HTML formatting tags. |
|  serviceUrl | string | Yes | Absolute URL of the backend service implementing this API. |
|  path | string | Yes | Path for API requests. |
|  protocols | array | Yes | Protocols over which API is made available. - Http or Https |
|  authenticationSettings | object | No | Collection of authentication settings included into this API. - [AuthenticationSettingsContract object](#AuthenticationSettingsContract) |
|  subscriptionKeyParameterNames | object | No | Protocols over which API is made available. - [SubscriptionKeyParameterNamesContract object](#SubscriptionKeyParameterNamesContract) |
|  type | enum | No | Type of API. - Http or Soap |


<a id="service_apis_operations_childResource" />
### service_apis_operations_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | operations |
|  apiVersion | enum | Yes | 2016-07-07 |
|  OperationContract | object | Yes | operation details. - [OperationContract object](#OperationContract) |


<a id="AuthenticationSettingsContract" />
### AuthenticationSettingsContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  oAuth2 | object | No | [OAuth2AuthenticationSettingsContract object](#OAuth2AuthenticationSettingsContract) |


<a id="SubscriptionKeyParameterNamesContract" />
### SubscriptionKeyParameterNamesContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  header | string | No | Subscription key header name. |
|  query | string | No | Subscription key query string parameter name. |


<a id="OperationContract" />
### OperationContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | OperationId path. |
|  name | string | Yes | Operation Name. |
|  method | string | Yes | Operation Method (GET, PUT, POST, etc.). |
|  urlTemplate | string | Yes | Operation URI template. Cannot be more than 400 characters long. |
|  templateParameters | array | No | Collection of URL template parameters. - [ParameterContract object](#ParameterContract) |
|  description | string | No | Operation description. |
|  request | object | No | Operation request. - [RequestContract object](#RequestContract) |
|  responses | array | No | Array of Operation responses. - [ResultContract object](#ResultContract) |


<a id="OAuth2AuthenticationSettingsContract" />
### OAuth2AuthenticationSettingsContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authorizationServerId | string | No | OAuth authorization server identifier. |
|  scope | string | No | operations scope. |


<a id="ParameterContract" />
### ParameterContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Parameter name. |
|  description | string | No | Parameter description. |
|  type | string | Yes | Parameter type. |
|  defaultValue | string | No | Default parameter value. |
|  required | boolean | No | whether parameter is required or not. |
|  values | array | No | Parameter values. - string |


<a id="RequestContract" />
### RequestContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  description | string | No | Operation request description. |
|  queryParameters | array | No | Collection of operation request query parameters. - [ParameterContract object](#ParameterContract) |
|  headers | array | No | Collection of operation request headers. - [ParameterContract object](#ParameterContract) |
|  representations | array | No | Collection of operation request representations. - [RepresentationContract object](#RepresentationContract) |


<a id="ResultContract" />
### ResultContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  statusCode | integer | Yes | Operation response status code. |
|  description | string | No | Operation response description. |
|  representations | array | No | Collection of operation response representations. - [RepresentationContract object](#RepresentationContract) |


<a id="RepresentationContract" />
### RepresentationContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  contentType | string | Yes | Content type. |
|  sample | string | No | Content sample. |

