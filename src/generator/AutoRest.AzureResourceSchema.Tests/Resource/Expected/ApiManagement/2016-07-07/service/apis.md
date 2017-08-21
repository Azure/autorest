# Microsoft.ApiManagement/service/apis template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/apis resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
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
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/apis" />
### Microsoft.ApiManagement/service/apis object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | API identifier. Must be unique in the current API Management service instance. |
|  type | enum | Yes | Microsoft.ApiManagement/service/apis |
|  apiVersion | enum | Yes | 2016-07-07 |
|  ApiContract | object | Yes | ApiContract. - [ApiContract object](#ApiContract) |
|  resources | array | No | [operations](./apis/operations.md) |


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


<a id="OAuth2AuthenticationSettingsContract" />
### OAuth2AuthenticationSettingsContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authorizationServerId | string | No | OAuth authorization server identifier. |
|  scope | string | No | operations scope. |

