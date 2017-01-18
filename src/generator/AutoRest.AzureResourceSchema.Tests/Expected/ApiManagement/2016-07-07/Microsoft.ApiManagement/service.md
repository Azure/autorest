# Microsoft.ApiManagement/service template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ApiManagement/service",
  "apiVersion": "2016-07-07",
  "location": "string",
  "tags": {},
  "properties": {
    "publisherEmail": "string",
    "publisherName": "string",
    "provisioningState": "string",
    "targetProvisioningState": "string",
    "createdAtUtc": "string",
    "runtimeUrl": "string",
    "portalUrl": "string",
    "managementApiUrl": "string",
    "scmUrl": "string",
    "addresserEmail": "string",
    "hostnameConfigurations": [
      {
        "type": "string",
        "hostname": "string",
        "certificate": {
          "expiry": "string",
          "thumbprint": "string",
          "subject": "string"
        }
      }
    ],
    "staticIPs": [
      "string"
    ],
    "vpnconfiguration": {
      "subnetResourceId": "string",
      "location": "string"
    },
    "additionalLocations": [
      {
        "location": "string",
        "skuType": "string",
        "skuUnitCount": "integer",
        "staticIPs": [
          "string"
        ],
        "vpnconfiguration": {
          "subnetResourceId": "string",
          "location": "string"
        }
      }
    ],
    "customProperties": {},
    "vpnType": "string"
  },
  "sku": {
    "name": "string",
    "capacity": "integer"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service" />
### Microsoft.ApiManagement/service object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ApiManagement/service |
|  apiVersion | enum | Yes | 2016-07-07 |
|  location | string | Yes | Api Management service data center location. |
|  tags | object | No | Api Management service tags. A maximum of 10 tags can be provided for a resource, and each tag must have a key no greater than 128 characters (and value no greater than 256 characters) |
|  properties | object | Yes | Properties of the Api Management service. - [ApiServiceProperties object](#ApiServiceProperties) |
|  sku | object | Yes | Sku properties of the Api Management service. - [ApiServiceSkuProperties object](#ApiServiceSkuProperties) |
|  resources | array | No | [service_openidConnectProviders_childResource object](#service_openidConnectProviders_childResource) [service_properties_childResource object](#service_properties_childResource) [service_loggers_childResource object](#service_loggers_childResource) [service_authorizationServers_childResource object](#service_authorizationServers_childResource) [service_users_childResource object](#service_users_childResource) [service_certificates_childResource object](#service_certificates_childResource) [service_groups_childResource object](#service_groups_childResource) [service_products_childResource object](#service_products_childResource) [service_subscriptions_childResource object](#service_subscriptions_childResource) [service_apis_childResource object](#service_apis_childResource) |


<a id="ApiServiceProperties" />
### ApiServiceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publisherEmail | string | No | Publisher email. |
|  publisherName | string | No | Publisher name. |
|  provisioningState | string | No | Provisioning state of the Api Management service. |
|  targetProvisioningState | string | No | Target provisioning state of the Api Management service.The state that is targeted for the Api Management service by the infrastructure. |
|  createdAtUtc | string | No | Creation UTC date of the Api Management service.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
 |
|  runtimeUrl | string | No | Proxy endpoint Url of the Api Management service. |
|  portalUrl | string | No | management portal endpoint Url of the Api Management service. |
|  managementApiUrl | string | No | management api endpoint Url of the Api Management service. |
|  scmUrl | string | No | Scm endpoint Url of the Api Management service. |
|  addresserEmail | string | No | Addresser email. |
|  hostnameConfigurations | array | No | Custom hostname configuration of the Api Management service. - [HostnameConfiguration object](#HostnameConfiguration) |
|  staticIPs | array | No | Static ip addresses of the Api Management service virtual machines. Available only for Standard and Premium Sku. - string |
|  vpnconfiguration | object | No | Virtual network configuration of the Api Management service. - [VirtualNetworkConfiguration object](#VirtualNetworkConfiguration) |
|  additionalLocations | array | No | Additional datacenter locations description of the Api Management service. - [AdditionalRegion object](#AdditionalRegion) |
|  customProperties | object | No | Custom properties of the Api Management service. |
|  vpnType | enum | No | Virtual private network type of the Api Management service. - None, External, Internal |


<a id="ApiServiceSkuProperties" />
### ApiServiceSkuProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Name of the Sku. - Developer, Standard, Premium |
|  capacity | integer | No | Capacity of the Sku (number of deployed units of the Sku). |


<a id="service_openidConnectProviders_childResource" />
### service_openidConnectProviders_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | openidConnectProviders |
|  apiVersion | enum | Yes | 2016-07-07 |
|  name | string | Yes | User-friendly OpenID Connect Provider name. |
|  description | string | No | User-friendly description of OpenID Connect Provider. |
|  metadataEndpoint | string | Yes | Metadata endpoint URI. |
|  clientId | string | Yes | Client ID of developer console which is the client application. |
|  clientSecret | string | No | Client Secret of developer console which is the client application. |


<a id="service_properties_childResource" />
### service_properties_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | properties |
|  apiVersion | enum | Yes | 2016-07-07 |
|  name | string | Yes | Unique name of Property. |
|  value | string | Yes | The Value of the Property. |
|  tags | array | No | Collection of tags associated with a property. - string |
|  secret | boolean | No | The value which determines the value should be encrypted or not. Default value is false. |


<a id="service_loggers_childResource" />
### service_loggers_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | loggers |
|  apiVersion | enum | Yes | 2016-07-07 |
|  description | string | No | Logger description. |
|  credentials | object | Yes | Logger credentials. |
|  isBuffered | boolean | No | whether records are buffered in the logger before publishing. Default is assumed to be true. |


<a id="service_authorizationServers_childResource" />
### service_authorizationServers_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | authorizationServers |
|  apiVersion | enum | Yes | 2016-07-07 |
|  OAuth2AuthorizationServerContract | object | Yes | OAuth2 Authorization Server details. - [OAuth2AuthorizationServerContract object](#OAuth2AuthorizationServerContract) |


<a id="service_users_childResource" />
### service_users_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | users |
|  apiVersion | enum | Yes | 2016-07-07 |
|  email | string | Yes | Email address. |
|  password | string | Yes | Password. |
|  firstName | string | Yes | First name. |
|  lastName | string | Yes | Last name. |
|  state | enum | No | Account state. - Active or Blocked |
|  note | string | No | Note about user. |


<a id="service_certificates_childResource" />
### service_certificates_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | certificates |
|  apiVersion | enum | Yes | 2016-07-07 |
|  data | string | No | Base 64 encoded Certificate |
|  password | string | No | Password for the Certificate |


<a id="service_groups_childResource" />
### service_groups_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | groups |
|  apiVersion | enum | Yes | 2016-07-07 |
|  name | string | Yes | Group name. |
|  description | string | No | Group description. |
|  externalId | string | No | Identifier for an external group. |
|  resources | array | No | [service_groups_users_childResource object](#service_groups_users_childResource) |


<a id="service_products_childResource" />
### service_products_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | products |
|  apiVersion | enum | Yes | 2016-07-07 |
|  ProductContract | object | Yes | [ProductContract object](#ProductContract) |
|  resources | array | No | [service_products_groups_childResource object](#service_products_groups_childResource) [service_products_apis_childResource object](#service_products_apis_childResource) |


<a id="service_subscriptions_childResource" />
### service_subscriptions_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | subscriptions |
|  apiVersion | enum | Yes | 2016-07-07 |
|  userId | string | Yes | User (user id path) for whom subscription is being created in form /users/{uid} |
|  productId | string | Yes | Product (product id path) for which subscription is being created in form /products/{productid} |
|  name | string | Yes | Subscription name. |
|  primaryKey | string | No | Primary subscription key. If not specified during request key will be generated automatically. |
|  secondaryKey | string | No | Secondary subscription key. If not specified during request key will be generated automatically. |
|  state | enum | No | Initial subscription state. - Suspended, Active, Expired, Submitted, Rejected, Cancelled |


<a id="service_apis_childResource" />
### service_apis_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | apis |
|  apiVersion | enum | Yes | 2016-07-07 |
|  ApiContract | object | Yes | ApiContract. - [ApiContract object](#ApiContract) |
|  resources | array | No | [service_apis_operations_childResource object](#service_apis_operations_childResource) |


<a id="HostnameConfiguration" />
### HostnameConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Hostname type. - Proxy, Portal, Management, Scm |
|  hostname | string | Yes | Hostname. |
|  certificate | object | Yes | Certificate information. - [CertificateInformation object](#CertificateInformation) |


<a id="VirtualNetworkConfiguration" />
### VirtualNetworkConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  subnetResourceId | string | No | Subnet Resource Id. |
|  location | string | No | Virtual network location name. |


<a id="AdditionalRegion" />
### AdditionalRegion object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  location | string | No | Location name. |
|  skuType | enum | No | Sku type in the location. - Developer, Standard, Premium |
|  skuUnitCount | integer | No | Sku Unit count at the location. |
|  staticIPs | array | No | Static IP addresses of the location virtual machines. - string |
|  vpnconfiguration | object | No | Virtual network configuration for the location. - [VirtualNetworkConfiguration object](#VirtualNetworkConfiguration) |


<a id="OAuth2AuthorizationServerContract" />
### OAuth2AuthorizationServerContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | User-friendly authorization server name. |
|  description | string | No | User-friendly authorization server name. |
|  clientRegistrationEndpoint | string | No | Client registration URI that will be shown for developers. |
|  authorizationEndpoint | string | No | OAuth authorization endpoint. See http://tools.ietf.org/html/rfc6749#section-3.2. |
|  authorizationMethods | array | No | Supported methods of authorization. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE |
|  clientAuthenticationMethod | array | No | Supported methods of authorization. - Basic or Body |
|  tokenBodyParameters | array | No | Token request body parameters. - [TokenBodyParameterContract object](#TokenBodyParameterContract) |
|  tokenEndpoint | string | No | OAuth token endpoint. See http://tools.ietf.org/html/rfc6749#section-3.1 . |
|  supportState | boolean | No | whether Auhtorizatoin Server supports client credentials in body or not. See http://tools.ietf.org/html/rfc6749#section-3.1 . |
|  defaultScope | string | No | Scope that is going to applied by default on the console page. See http://tools.ietf.org/html/rfc6749#section-3.3 . |
|  grantTypes | array | No | Form of an authorization grant, which the client uses to request the access token. See http://tools.ietf.org/html/rfc6749#section-4 . - authorizationCode, implicit, resourceOwnerPassword, clientCredentials |
|  bearerTokenSendingMethods | array | No | Form of an authorization grant, which the client uses to request the access token. See http://tools.ietf.org/html/rfc6749#section-4 . - authorizationHeader or query |
|  clientId | string | No | Client ID of developer console which is the client application. |
|  clientSecret | string | No | Client Secret of developer console which is the client application. |
|  resourceOwnerUsername | string | No | Username of the resource owner on behalf of whom developer console will make requests. |
|  resourceOwnerPassword | string | No | Password of the resource owner on behalf of whom developer console will make requests. |


<a id="service_groups_users_childResource" />
### service_groups_users_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | users |
|  apiVersion | enum | Yes | 2016-07-07 |


<a id="ProductContract" />
### ProductContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Product identifier path. |
|  name | string | Yes | Product name. |
|  description | string | No | Product description. May be 1 to 500 characters long. |
|  terms | string | No | Product terms and conditions. Developer will have to accept these terms before he's allowed to call product API. |
|  subscriptionRequired | boolean | No | Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
|  approvalRequired | boolean | No | whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
|  subscriptionsLimit | integer | No | whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
|  state | enum | No | whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. - NotPublished or Published |


<a id="service_products_groups_childResource" />
### service_products_groups_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | groups |
|  apiVersion | enum | Yes | 2016-07-07 |


<a id="service_products_apis_childResource" />
### service_products_apis_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | apis |
|  apiVersion | enum | Yes | 2016-07-07 |


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


<a id="CertificateInformation" />
### CertificateInformation object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  expiry | string | Yes | Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
 |
|  thumbprint | string | Yes | Thumbprint of the certificate. |
|  subject | string | Yes | Subject of the certificate. |


<a id="TokenBodyParameterContract" />
### TokenBodyParameterContract object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | body parameter name. |
|  value | string | No | body parameter value. |


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

