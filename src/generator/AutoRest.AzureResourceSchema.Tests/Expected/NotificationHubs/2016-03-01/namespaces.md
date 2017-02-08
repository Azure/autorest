# Microsoft.NotificationHubs/namespaces template reference
API Version: 2016-03-01
## Template format

To create a Microsoft.NotificationHubs/namespaces resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.NotificationHubs/namespaces",
  "apiVersion": "2016-03-01",
  "location": "string",
  "tags": {},
  "sku": {
    "name": "string",
    "tier": "string",
    "size": "string",
    "family": "string",
    "capacity": "integer"
  },
  "properties": {
    "name": "string",
    "provisioningState": "string",
    "region": "string",
    "status": "string",
    "createdAt": "string",
    "serviceBusEndpoint": "string",
    "subscriptionId": "string",
    "scaleUnit": "string",
    "enabled": boolean,
    "critical": boolean,
    "namespaceType": "string"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.NotificationHubs/namespaces" />
### Microsoft.NotificationHubs/namespaces object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.NotificationHubs/namespaces |
|  apiVersion | enum | Yes | 2016-03-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | The sku of the created namespace - [Sku object](#Sku) |
|  properties | object | Yes | Properties of the Namespace. - [NamespaceProperties object](#NamespaceProperties) |
|  resources | array | No | [namespaces_notificationHubs_childResource object](#namespaces_notificationHubs_childResource) [namespaces_AuthorizationRules_childResource object](#namespaces_AuthorizationRules_childResource) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | Yes | Name of the notification hub sku. - Free, Basic, Standard |
|  tier | string | No | The tier of particular sku |
|  size | string | No | The Sku size |
|  family | string | No | The Sku Family |
|  capacity | integer | No | The capacity of the resource |


<a id="NamespaceProperties" />
### NamespaceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The name of the namespace. |
|  provisioningState | string | No | Provisioning state of the Namespace. |
|  region | string | No | Specifies the targeted region in which the namespace should be created. It can be any of the following values: Australia EastAustralia SoutheastCentral USEast USEast US 2West USNorth Central USSouth Central USEast AsiaSoutheast AsiaBrazil SouthJapan EastJapan WestNorth EuropeWest Europe |
|  status | string | No | Status of the namespace. It can be any of these values:1 = Created/Active2 = Creating3 = Suspended4 = Deleting |
|  createdAt | string | No | The time the namespace was created. |
|  serviceBusEndpoint | string | No | Endpoint you can use to perform NotificationHub operations. |
|  subscriptionId | string | No | The Id of the Azure subscription associated with the namespace. |
|  scaleUnit | string | No | ScaleUnit where the namespace gets created |
|  enabled | boolean | No | Whether or not the namespace is currently enabled. |
|  critical | boolean | No | Whether or not the namespace is set as Critical. |
|  namespaceType | enum | No | The namespace type. - Messaging or NotificationHub |


<a id="namespaces_notificationHubs_childResource" />
### namespaces_notificationHubs_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | notificationHubs |
|  apiVersion | enum | Yes | 2016-03-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | The sku of the created namespace - [Sku object](#Sku) |
|  properties | object | Yes | Properties of the NotificationHub. - [NotificationHubProperties object](#NotificationHubProperties) |
|  resources | array | No | [namespaces_notificationHubs_AuthorizationRules_childResource object](#namespaces_notificationHubs_AuthorizationRules_childResource) |


<a id="namespaces_AuthorizationRules_childResource" />
### namespaces_AuthorizationRules_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | AuthorizationRules |
|  apiVersion | enum | Yes | 2016-03-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | The sku of the created namespace - [Sku object](#Sku) |
|  properties | object | Yes | Properties of the Namespace AuthorizationRules. - [SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties) |


<a id="NotificationHubProperties" />
### NotificationHubProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The NotificationHub name. |
|  registrationTtl | string | No | The RegistrationTtl of the created NotificationHub |
|  authorizationRules | array | No | The AuthorizationRules of the created NotificationHub - [SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties) |
|  apnsCredential | object | No | The ApnsCredential of the created NotificationHub - [ApnsCredential object](#ApnsCredential) |
|  wnsCredential | object | No | The WnsCredential of the created NotificationHub - [WnsCredential object](#WnsCredential) |
|  gcmCredential | object | No | The GcmCredential of the created NotificationHub - [GcmCredential object](#GcmCredential) |
|  mpnsCredential | object | No | The MpnsCredential of the created NotificationHub - [MpnsCredential object](#MpnsCredential) |
|  admCredential | object | No | The AdmCredential of the created NotificationHub - [AdmCredential object](#AdmCredential) |
|  baiduCredential | object | No | The BaiduCredential of the created NotificationHub - [BaiduCredential object](#BaiduCredential) |


<a id="namespaces_notificationHubs_AuthorizationRules_childResource" />
### namespaces_notificationHubs_AuthorizationRules_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | AuthorizationRules |
|  apiVersion | enum | Yes | 2016-03-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | The sku of the created namespace - [Sku object](#Sku) |
|  properties | object | Yes | Properties of the Namespace AuthorizationRules. - [SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties) |


<a id="SharedAccessAuthorizationRuleProperties" />
### SharedAccessAuthorizationRuleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  rights | array | No | The rights associated with the rule. - Manage, Send, Listen |


<a id="ApnsCredential" />
### ApnsCredential object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | Properties of NotificationHub ApnsCredential. - [ApnsCredentialProperties object](#ApnsCredentialProperties) |


<a id="WnsCredential" />
### WnsCredential object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | Properties of NotificationHub WnsCredential. - [WnsCredentialProperties object](#WnsCredentialProperties) |


<a id="GcmCredential" />
### GcmCredential object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | Properties of NotificationHub GcmCredential. - [GcmCredentialProperties object](#GcmCredentialProperties) |


<a id="MpnsCredential" />
### MpnsCredential object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | Properties of NotificationHub MpnsCredential. - [MpnsCredentialProperties object](#MpnsCredentialProperties) |


<a id="AdmCredential" />
### AdmCredential object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | Properties of NotificationHub AdmCredential. - [AdmCredentialProperties object](#AdmCredentialProperties) |


<a id="BaiduCredential" />
### BaiduCredential object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | Properties of NotificationHub BaiduCredential. - [BaiduCredentialProperties object](#BaiduCredentialProperties) |


<a id="ApnsCredentialProperties" />
### ApnsCredentialProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  apnsCertificate | string | No | The APNS certificate. |
|  certificateKey | string | No | The certificate key. |
|  endpoint | string | No | The endpoint of this credential. |
|  thumbprint | string | No | The Apns certificate Thumbprint |


<a id="WnsCredentialProperties" />
### WnsCredentialProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  packageSid | string | No | The package ID for this credential. |
|  secretKey | string | No | The secret key. |
|  windowsLiveEndpoint | string | No | The Windows Live endpoint. |


<a id="GcmCredentialProperties" />
### GcmCredentialProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  gcmEndpoint | string | No | The GCM endpoint. |
|  googleApiKey | string | No | The Google API key. |


<a id="MpnsCredentialProperties" />
### MpnsCredentialProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  mpnsCertificate | string | No | The MPNS certificate. |
|  certificateKey | string | No | The certificate key for this credential. |
|  thumbprint | string | No | The Mpns certificate Thumbprint |


<a id="AdmCredentialProperties" />
### AdmCredentialProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  clientId | string | No | The client identifier. |
|  clientSecret | string | No | The credential secret access key. |
|  authTokenUrl | string | No | The URL of the authorization token. |


<a id="BaiduCredentialProperties" />
### BaiduCredentialProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  baiduApiKey | string | No | Baidu Api Key. |
|  baiduEndPoint | string | No | Baidu Endpoint. |
|  baiduSecretKey | string | No | Baidu Secret Key |

