# Microsoft.ApiManagement template schema

Creates a Microsoft.ApiManagement resource.

## Schema format

To create a Microsoft.ApiManagement, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.ApiManagement/service",
  "apiVersion": "2016-07-07",
  "location": "string",
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
  }
}
```
```
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
  }
}
```
```
{
  "type": "Microsoft.ApiManagement/service/apis/operations",
  "apiVersion": "2016-07-07",
  "OperationContract": {
    "id": "string",
    "name": "string",
    "method": "string",
    "urlTemplate": "string",
    "templateParameters": [
      {
        "name": "string",
        "description": "string",
        "type": "string",
        "defaultValue": "string",
        "required": "boolean",
        "values": [
          "string"
        ]
      }
    ],
    "description": "string",
    "request": {
      "description": "string",
      "queryParameters": [
        {
          "name": "string",
          "description": "string",
          "type": "string",
          "defaultValue": "string",
          "required": "boolean",
          "values": [
            "string"
          ]
        }
      ],
      "headers": [
        {
          "name": "string",
          "description": "string",
          "type": "string",
          "defaultValue": "string",
          "required": "boolean",
          "values": [
            "string"
          ]
        }
      ],
      "representations": [
        {
          "contentType": "string",
          "sample": "string"
        }
      ]
    },
    "responses": [
      {
        "statusCode": "integer",
        "description": "string",
        "representations": [
          {
            "contentType": "string",
            "sample": "string"
          }
        ]
      }
    ]
  }
}
```
```
{
  "type": "Microsoft.ApiManagement/service/subscriptions",
  "apiVersion": "2016-07-07",
  "userId": "string",
  "productId": "string",
  "name": "string"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/products",
  "apiVersion": "2016-07-07",
  "ProductContract": {
    "id": "string",
    "name": "string",
    "description": "string",
    "terms": "string",
    "subscriptionRequired": "boolean",
    "approvalRequired": "boolean",
    "subscriptionsLimit": "integer",
    "state": "string"
  }
}
```
```
{
  "type": "Microsoft.ApiManagement/service/products/apis",
  "apiVersion": "2016-07-07"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/products/groups",
  "apiVersion": "2016-07-07"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/groups",
  "apiVersion": "2016-07-07",
  "name": "string"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/groups/users",
  "apiVersion": "2016-07-07"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/certificates",
  "apiVersion": "2016-07-07"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/users",
  "apiVersion": "2016-07-07",
  "email": "string",
  "password": "string",
  "firstName": "string",
  "lastName": "string"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/authorizationServers",
  "apiVersion": "2016-07-07",
  "OAuth2AuthorizationServerContract": {
    "name": "string",
    "description": "string",
    "clientRegistrationEndpoint": "string",
    "authorizationEndpoint": "string",
    "authorizationMethods": [
      "string"
    ],
    "clientAuthenticationMethod": [
      "string"
    ],
    "tokenBodyParameters": [
      {
        "name": "string",
        "value": "string"
      }
    ],
    "tokenEndpoint": "string",
    "supportState": "boolean",
    "defaultScope": "string",
    "grantTypes": [
      "string"
    ],
    "bearerTokenSendingMethods": [
      "string"
    ],
    "clientId": "string",
    "clientSecret": "string",
    "resourceOwnerUsername": "string",
    "resourceOwnerPassword": "string"
  }
}
```
```
{
  "type": "Microsoft.ApiManagement/service/loggers",
  "apiVersion": "2016-07-07",
  "credentials": {}
}
```
```
{
  "type": "Microsoft.ApiManagement/service/properties",
  "apiVersion": "2016-07-07",
  "name": "string",
  "value": "string"
}
```
```
{
  "type": "Microsoft.ApiManagement/service/openidConnectProviders",
  "apiVersion": "2016-07-07",
  "name": "string",
  "metadataEndpoint": "string",
  "clientId": "string"
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="service" />
## service object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  location | Yes | string<br /><br />Api Management service data center location. |
|  tags | No | object<br /><br />Api Management service tags. A maximum of 10 tags can be provided for a resource, and each tag must have a key no greater than 128 characters (and value no greater than 256 characters) |
|  properties | Yes | object<br />[ApiServiceProperties object](#ApiServiceProperties)<br /><br />Properties of the Api Management service. |
|  sku | Yes | object<br />[ApiServiceSkuProperties object](#ApiServiceSkuProperties)<br /><br />Sku properties of the Api Management service. |
|  resources | No | array<br />[openidConnectProviders object](#openidConnectProviders)<br />[properties object](#properties)<br />[loggers object](#loggers)<br />[authorizationServers object](#authorizationServers)<br />[users object](#users)<br />[certificates object](#certificates)<br />[groups object](#groups)<br />[products object](#products)<br />[subscriptions object](#subscriptions)<br />[apis object](#apis)<br /> |


<a id="service_apis" />
## service_apis object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/apis**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  ApiContract | Yes | object<br />[ApiContract object](#ApiContract)<br /><br />ApiContract. |
|  resources | No | array<br />[operations object](#operations)<br /> |


<a id="service_apis_operations" />
## service_apis_operations object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/apis/operations**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  OperationContract | Yes | object<br />[OperationContract object](#OperationContract)<br /><br />operation details. |


<a id="service_subscriptions" />
## service_subscriptions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/subscriptions**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  userId | Yes | string<br /><br />User (user id path) for whom subscription is being created in form /users/{uid} |
|  productId | Yes | string<br /><br />Product (product id path) for which subscription is being created in form /products/{productid} |
|  name | Yes | string<br /><br />Subscription name. |
|  primaryKey | No | string<br /><br />Primary subscription key. If not specified during request key will be generated automatically. |
|  secondaryKey | No | string<br /><br />Secondary subscription key. If not specified during request key will be generated automatically. |
|  state | No | enum<br />**Suspended**, **Active**, **Expired**, **Submitted**, **Rejected**, **Cancelled**<br /><br />Initial subscription state. |


<a id="service_products" />
## service_products object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/products**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  ProductContract | Yes | object<br />[ProductContract object](#ProductContract)<br /> |
|  resources | No | array<br />[groups object](#groups)<br />[apis object](#apis)<br /> |


<a id="service_products_apis" />
## service_products_apis object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/products/apis**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |


<a id="service_products_groups" />
## service_products_groups object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/products/groups**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |


<a id="service_groups" />
## service_groups object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/groups**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  name | Yes | string<br /><br />Group name. |
|  description | No | string<br /><br />Group description. |
|  externalId | No | string<br /><br />Identifier for an external group. |
|  resources | No | array<br />[users object](#users)<br /> |


<a id="service_groups_users" />
## service_groups_users object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/groups/users**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |


<a id="service_certificates" />
## service_certificates object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/certificates**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  data | No | string<br /><br />Base 64 encoded Certificate |
|  password | No | string<br /><br />Password for the Certificate |


<a id="service_users" />
## service_users object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/users**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  email | Yes | string<br /><br />Email address. |
|  password | Yes | string<br /><br />Password. |
|  firstName | Yes | string<br /><br />First name. |
|  lastName | Yes | string<br /><br />Last name. |
|  state | No | enum<br />**Active** or **Blocked**<br /><br />Account state. |
|  note | No | string<br /><br />Note about user. |


<a id="service_authorizationServers" />
## service_authorizationServers object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/authorizationServers**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  OAuth2AuthorizationServerContract | Yes | object<br />[OAuth2AuthorizationServerContract object](#OAuth2AuthorizationServerContract)<br /><br />OAuth2 Authorization Server details. |


<a id="service_loggers" />
## service_loggers object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/loggers**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  description | No | string<br /><br />Logger description. |
|  credentials | Yes | object<br /><br />Logger credentials. |
|  isBuffered | No | boolean<br /><br />whether records are buffered in the logger before publishing. Default is assumed to be true. |


<a id="service_properties" />
## service_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/properties**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  name | Yes | string<br /><br />Unique name of Property. |
|  value | Yes | string<br /><br />The Value of the Property. |
|  tags | No | array<br />**string**<br /><br />Collection of tags associated with a property. |
|  secret | No | boolean<br /><br />The value which determines the value should be encrypted or not. Default value is false. |


<a id="service_openidConnectProviders" />
## service_openidConnectProviders object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ApiManagement/service/openidConnectProviders**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  name | Yes | string<br /><br />User-friendly OpenID Connect Provider name. |
|  description | No | string<br /><br />User-friendly description of OpenID Connect Provider. |
|  metadataEndpoint | Yes | string<br /><br />Metadata endpoint URI. |
|  clientId | Yes | string<br /><br />Client ID of developer console which is the client application. |
|  clientSecret | No | string<br /><br />Client Secret of developer console which is the client application. |


<a id="ApiServiceProperties" />
## ApiServiceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publisherEmail | No | string<br /><br />Publisher email. |
|  publisherName | No | string<br /><br />Publisher name. |
|  provisioningState | No | string<br /><br />Provisioning state of the Api Management service. |
|  targetProvisioningState | No | string<br /><br />Target provisioning state of the Api Management service.The state that is targeted for the Api Management service by the infrastructure. |
|  createdAtUtc | No | string<br /><br />Creation UTC date of the Api Management service.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
 |
|  runtimeUrl | No | string<br /><br />Proxy endpoint Url of the Api Management service. |
|  portalUrl | No | string<br /><br />management portal endpoint Url of the Api Management service. |
|  managementApiUrl | No | string<br /><br />management api endpoint Url of the Api Management service. |
|  scmUrl | No | string<br /><br />Scm endpoint Url of the Api Management service. |
|  addresserEmail | No | string<br /><br />Addresser email. |
|  hostnameConfigurations | No | array<br />[HostnameConfiguration object](#HostnameConfiguration)<br /><br />Custom hostname configuration of the Api Management service. |
|  staticIPs | No | array<br />**string**<br /><br />Static ip addresses of the Api Management service virtual machines. Available only for Standard and Premium Sku. |
|  vpnconfiguration | No | object<br />[VirtualNetworkConfiguration object](#VirtualNetworkConfiguration)<br /><br />Virtual network configuration of the Api Management service. |
|  additionalLocations | No | array<br />[AdditionalRegion object](#AdditionalRegion)<br /><br />Additional datacenter locations description of the Api Management service. |
|  customProperties | No | object<br /><br />Custom properties of the Api Management service. |
|  vpnType | No | enum<br />**None**, **External**, **Internal**<br /><br />Virtual private network type of the Api Management service. |


<a id="HostnameConfiguration" />
## HostnameConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Proxy**, **Portal**, **Management**, **Scm**<br /><br />Hostname type. |
|  hostname | Yes | string<br /><br />Hostname. |
|  certificate | Yes | object<br />[CertificateInformation object](#CertificateInformation)<br /><br />Certificate information. |


<a id="CertificateInformation" />
## CertificateInformation object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  expiry | Yes | string<br /><br />Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
 |
|  thumbprint | Yes | string<br /><br />Thumbprint of the certificate. |
|  subject | Yes | string<br /><br />Subject of the certificate. |


<a id="VirtualNetworkConfiguration" />
## VirtualNetworkConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  subnetResourceId | No | string<br /><br />Subnet Resource Id. |
|  location | No | string<br /><br />Virtual network location name. |


<a id="AdditionalRegion" />
## AdditionalRegion object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  location | No | string<br /><br />Location name. |
|  skuType | No | enum<br />**Developer**, **Standard**, **Premium**<br /><br />Sku type in the location. |
|  skuUnitCount | No | integer<br /><br />Sku Unit count at the location. |
|  staticIPs | No | array<br />**string**<br /><br />Static IP addresses of the location virtual machines. |
|  vpnconfiguration | No | object<br />[VirtualNetworkConfiguration object](#VirtualNetworkConfiguration)<br /><br />Virtual network configuration for the location. |


<a id="ApiServiceSkuProperties" />
## ApiServiceSkuProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Developer**, **Standard**, **Premium**<br /><br />Name of the Sku. |
|  capacity | No | integer<br /><br />Capacity of the Sku (number of deployed units of the Sku). |


<a id="ApiContract" />
## ApiContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />API name. |
|  description | No | string<br /><br />Description of the API. May include HTML formatting tags. |
|  serviceUrl | Yes | string<br /><br />Absolute URL of the backend service implementing this API. |
|  path | Yes | string<br /><br />Path for API requests. |
|  protocols | Yes | array<br />**Http** or **Https**<br /><br />Protocols over which API is made available. |
|  authenticationSettings | No | object<br />[AuthenticationSettingsContract object](#AuthenticationSettingsContract)<br /><br />Collection of authentication settings included into this API. |
|  subscriptionKeyParameterNames | No | object<br />[SubscriptionKeyParameterNamesContract object](#SubscriptionKeyParameterNamesContract)<br /><br />Protocols over which API is made available. |
|  type | No | enum<br />**Http** or **Soap**<br /><br />Type of API. |


<a id="AuthenticationSettingsContract" />
## AuthenticationSettingsContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  oAuth2 | No | object<br />[OAuth2AuthenticationSettingsContract object](#OAuth2AuthenticationSettingsContract)<br /> |


<a id="OAuth2AuthenticationSettingsContract" />
## OAuth2AuthenticationSettingsContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  authorizationServerId | No | string<br /><br />OAuth authorization server identifier. |
|  scope | No | string<br /><br />operations scope. |


<a id="SubscriptionKeyParameterNamesContract" />
## SubscriptionKeyParameterNamesContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  header | No | string<br /><br />Subscription key header name. |
|  query | No | string<br /><br />Subscription key query string parameter name. |


<a id="OperationContract" />
## OperationContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />OperationId path. |
|  name | Yes | string<br /><br />Operation Name. |
|  method | Yes | string<br /><br />Operation Method (GET, PUT, POST, etc.). |
|  urlTemplate | Yes | string<br /><br />Operation URI template. Cannot be more than 400 characters long. |
|  templateParameters | No | array<br />[ParameterContract object](#ParameterContract)<br /><br />Collection of URL template parameters. |
|  description | No | string<br /><br />Operation description. |
|  request | No | object<br />[RequestContract object](#RequestContract)<br /><br />Operation request. |
|  responses | No | array<br />[ResultContract object](#ResultContract)<br /><br />Array of Operation responses. |


<a id="ParameterContract" />
## ParameterContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Parameter name. |
|  description | No | string<br /><br />Parameter description. |
|  type | Yes | string<br /><br />Parameter type. |
|  defaultValue | No | string<br /><br />Default parameter value. |
|  required | No | boolean<br /><br />whether parameter is required or not. |
|  values | No | array<br />**string**<br /><br />Parameter values. |


<a id="RequestContract" />
## RequestContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  description | No | string<br /><br />Operation request description. |
|  queryParameters | No | array<br />[ParameterContract object](#ParameterContract)<br /><br />Collection of operation request query parameters. |
|  headers | No | array<br />[ParameterContract object](#ParameterContract)<br /><br />Collection of operation request headers. |
|  representations | No | array<br />[RepresentationContract object](#RepresentationContract)<br /><br />Collection of operation request representations. |


<a id="RepresentationContract" />
## RepresentationContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  contentType | Yes | string<br /><br />Content type. |
|  sample | No | string<br /><br />Content sample. |


<a id="ResultContract" />
## ResultContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  statusCode | Yes | integer<br /><br />Operation response status code. |
|  description | No | string<br /><br />Operation response description. |
|  representations | No | array<br />[RepresentationContract object](#RepresentationContract)<br /><br />Collection of operation response representations. |


<a id="ProductContract" />
## ProductContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Product identifier path. |
|  name | Yes | string<br /><br />Product name. |
|  description | No | string<br /><br />Product description. May be 1 to 500 characters long. |
|  terms | No | string<br /><br />Product terms and conditions. Developer will have to accept these terms before he's allowed to call product API. |
|  subscriptionRequired | No | boolean<br /><br />Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
|  approvalRequired | No | boolean<br /><br />whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
|  subscriptionsLimit | No | integer<br /><br />whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
|  state | No | enum<br />**NotPublished** or **Published**<br /><br />whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. |


<a id="OAuth2AuthorizationServerContract" />
## OAuth2AuthorizationServerContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />User-friendly authorization server name. |
|  description | No | string<br /><br />User-friendly authorization server name. |
|  clientRegistrationEndpoint | No | string<br /><br />Client registration URI that will be shown for developers. |
|  authorizationEndpoint | No | string<br /><br />OAuth authorization endpoint. See http://tools.ietf.org/html/rfc6749#section-3.2. |
|  authorizationMethods | No | array<br />**HEAD**, **OPTIONS**, **TRACE**, **GET**, **POST**, **PUT**, **PATCH**, **DELETE**<br /><br />Supported methods of authorization. |
|  clientAuthenticationMethod | No | array<br />**Basic** or **Body**<br /><br />Supported methods of authorization. |
|  tokenBodyParameters | No | array<br />[TokenBodyParameterContract object](#TokenBodyParameterContract)<br /><br />Token request body parameters. |
|  tokenEndpoint | No | string<br /><br />OAuth token endpoint. See http://tools.ietf.org/html/rfc6749#section-3.1 . |
|  supportState | No | boolean<br /><br />whether Auhtorizatoin Server supports client credentials in body or not. See http://tools.ietf.org/html/rfc6749#section-3.1 . |
|  defaultScope | No | string<br /><br />Scope that is going to applied by default on the console page. See http://tools.ietf.org/html/rfc6749#section-3.3 . |
|  grantTypes | No | array<br />**authorizationCode**, **implicit**, **resourceOwnerPassword**, **clientCredentials**<br /><br />Form of an authorization grant, which the client uses to request the access token. See http://tools.ietf.org/html/rfc6749#section-4 . |
|  bearerTokenSendingMethods | No | array<br />**authorizationHeader** or **query**<br /><br />Form of an authorization grant, which the client uses to request the access token. See http://tools.ietf.org/html/rfc6749#section-4 . |
|  clientId | No | string<br /><br />Client ID of developer console which is the client application. |
|  clientSecret | No | string<br /><br />Client Secret of developer console which is the client application. |
|  resourceOwnerUsername | No | string<br /><br />Username of the resource owner on behalf of whom developer console will make requests. |
|  resourceOwnerPassword | No | string<br /><br />Password of the resource owner on behalf of whom developer console will make requests. |


<a id="TokenBodyParameterContract" />
## TokenBodyParameterContract object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />body parameter name. |
|  value | No | string<br /><br />body parameter value. |


<a id="service_openidConnectProviders_childResource" />
## service_openidConnectProviders_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**openidConnectProviders**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  name | Yes | string<br /><br />User-friendly OpenID Connect Provider name. |
|  description | No | string<br /><br />User-friendly description of OpenID Connect Provider. |
|  metadataEndpoint | Yes | string<br /><br />Metadata endpoint URI. |
|  clientId | Yes | string<br /><br />Client ID of developer console which is the client application. |
|  clientSecret | No | string<br /><br />Client Secret of developer console which is the client application. |


<a id="service_properties_childResource" />
## service_properties_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**properties**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  name | Yes | string<br /><br />Unique name of Property. |
|  value | Yes | string<br /><br />The Value of the Property. |
|  tags | No | array<br />**string**<br /><br />Collection of tags associated with a property. |
|  secret | No | boolean<br /><br />The value which determines the value should be encrypted or not. Default value is false. |


<a id="service_loggers_childResource" />
## service_loggers_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**loggers**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  description | No | string<br /><br />Logger description. |
|  credentials | Yes | object<br /><br />Logger credentials. |
|  isBuffered | No | boolean<br /><br />whether records are buffered in the logger before publishing. Default is assumed to be true. |


<a id="service_authorizationServers_childResource" />
## service_authorizationServers_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**authorizationServers**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  OAuth2AuthorizationServerContract | Yes | object<br />[OAuth2AuthorizationServerContract object](#OAuth2AuthorizationServerContract)<br /><br />OAuth2 Authorization Server details. |


<a id="service_users_childResource" />
## service_users_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**users**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  email | Yes | string<br /><br />Email address. |
|  password | Yes | string<br /><br />Password. |
|  firstName | Yes | string<br /><br />First name. |
|  lastName | Yes | string<br /><br />Last name. |
|  state | No | enum<br />**Active** or **Blocked**<br /><br />Account state. |
|  note | No | string<br /><br />Note about user. |


<a id="service_certificates_childResource" />
## service_certificates_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**certificates**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  data | No | string<br /><br />Base 64 encoded Certificate |
|  password | No | string<br /><br />Password for the Certificate |


<a id="service_groups_users_childResource" />
## service_groups_users_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**users**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |


<a id="service_groups_childResource" />
## service_groups_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**groups**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  name | Yes | string<br /><br />Group name. |
|  description | No | string<br /><br />Group description. |
|  externalId | No | string<br /><br />Identifier for an external group. |
|  resources | No | array<br />[users object](#users)<br /> |


<a id="service_products_groups_childResource" />
## service_products_groups_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**groups**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |


<a id="service_products_apis_childResource" />
## service_products_apis_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**apis**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |


<a id="service_products_childResource" />
## service_products_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**products**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  ProductContract | Yes | object<br />[ProductContract object](#ProductContract)<br /> |
|  resources | No | array<br />[groups object](#groups)<br />[apis object](#apis)<br /> |


<a id="service_subscriptions_childResource" />
## service_subscriptions_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**subscriptions**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  userId | Yes | string<br /><br />User (user id path) for whom subscription is being created in form /users/{uid} |
|  productId | Yes | string<br /><br />Product (product id path) for which subscription is being created in form /products/{productid} |
|  name | Yes | string<br /><br />Subscription name. |
|  primaryKey | No | string<br /><br />Primary subscription key. If not specified during request key will be generated automatically. |
|  secondaryKey | No | string<br /><br />Secondary subscription key. If not specified during request key will be generated automatically. |
|  state | No | enum<br />**Suspended**, **Active**, **Expired**, **Submitted**, **Rejected**, **Cancelled**<br /><br />Initial subscription state. |


<a id="service_apis_operations_childResource" />
## service_apis_operations_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**operations**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  OperationContract | Yes | object<br />[OperationContract object](#OperationContract)<br /><br />operation details. |


<a id="service_apis_childResource" />
## service_apis_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**apis**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-07**<br /> |
|  ApiContract | Yes | object<br />[ApiContract object](#ApiContract)<br /><br />ApiContract. |
|  resources | No | array<br />[operations object](#operations)<br /> |

