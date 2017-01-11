# Microsoft.NotificationHubs template schema

Creates a Microsoft.NotificationHubs resource.

## Schema format

To create a Microsoft.NotificationHubs, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.NotificationHubs/namespaces",
  "apiVersion": "2016-03-01",
  "location": "string",
  "properties": {
    "name": "string",
    "provisioningState": "string",
    "region": "string",
    "status": "string",
    "createdAt": "string",
    "serviceBusEndpoint": "string",
    "subscriptionId": "string",
    "scaleUnit": "string",
    "enabled": "boolean",
    "critical": "boolean",
    "namespaceType": "string"
  }
}
```
```
{
  "type": "Microsoft.NotificationHubs/namespaces/AuthorizationRules",
  "apiVersion": "2016-03-01",
  "location": "string",
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
```
{
  "type": "Microsoft.NotificationHubs/namespaces/notificationHubs",
  "apiVersion": "2016-03-01",
  "location": "string",
  "properties": {
    "name": "string",
    "registrationTtl": "string",
    "authorizationRules": [
      {
        "rights": [
          "string"
        ]
      }
    ],
    "apnsCredential": {
      "properties": {
        "apnsCertificate": "string",
        "certificateKey": "string",
        "endpoint": "string",
        "thumbprint": "string"
      }
    },
    "wnsCredential": {
      "properties": {
        "packageSid": "string",
        "secretKey": "string",
        "windowsLiveEndpoint": "string"
      }
    },
    "gcmCredential": {
      "properties": {
        "gcmEndpoint": "string",
        "googleApiKey": "string"
      }
    },
    "mpnsCredential": {
      "properties": {
        "mpnsCertificate": "string",
        "certificateKey": "string",
        "thumbprint": "string"
      }
    },
    "admCredential": {
      "properties": {
        "clientId": "string",
        "clientSecret": "string",
        "authTokenUrl": "string"
      }
    },
    "baiduCredential": {
      "properties": {
        "baiduApiKey": "string",
        "baiduEndPoint": "string",
        "baiduSecretKey": "string"
      }
    }
  }
}
```
```
{
  "type": "Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules",
  "apiVersion": "2016-03-01",
  "location": "string",
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="namespaces" />
## namespaces object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.NotificationHubs/namespaces**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[NamespaceProperties object](#NamespaceProperties)<br /><br />Properties of the Namespace. |
|  resources | No | array<br />[notificationHubs object](#notificationHubs)<br />[AuthorizationRules object](#AuthorizationRules)<br /> |


<a id="namespaces_AuthorizationRules" />
## namespaces_AuthorizationRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.NotificationHubs/namespaces/AuthorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /><br />Properties of the Namespace AuthorizationRules. |


<a id="namespaces_notificationHubs" />
## namespaces_notificationHubs object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.NotificationHubs/namespaces/notificationHubs**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[NotificationHubProperties object](#NotificationHubProperties)<br /><br />Properties of the NotificationHub. |
|  resources | No | array<br />[AuthorizationRules object](#AuthorizationRules)<br /> |


<a id="namespaces_notificationHubs_AuthorizationRules" />
## namespaces_notificationHubs_AuthorizationRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.NotificationHubs/namespaces/notificationHubs/AuthorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /><br />Properties of the Namespace AuthorizationRules. |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | enum<br />**Free**, **Basic**, **Standard**<br /><br />Name of the notification hub sku. |
|  tier | No | string<br /><br />The tier of particular sku |
|  size | No | string<br /><br />The Sku size |
|  family | No | string<br /><br />The Sku Family |
|  capacity | No | integer<br /><br />The capacity of the resource |


<a id="NamespaceProperties" />
## NamespaceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />The name of the namespace. |
|  provisioningState | No | string<br /><br />Provisioning state of the Namespace. |
|  region | No | string<br /><br />Specifies the targeted region in which the namespace should be created. It can be any of the following values: Australia EastAustralia SoutheastCentral USEast USEast US 2West USNorth Central USSouth Central USEast AsiaSoutheast AsiaBrazil SouthJapan EastJapan WestNorth EuropeWest Europe |
|  status | No | string<br /><br />Status of the namespace. It can be any of these values:1 = Created/Active2 = Creating3 = Suspended4 = Deleting |
|  createdAt | No | string<br /><br />The time the namespace was created. |
|  serviceBusEndpoint | No | string<br /><br />Endpoint you can use to perform NotificationHub operations. |
|  subscriptionId | No | string<br /><br />The Id of the Azure subscription associated with the namespace. |
|  scaleUnit | No | string<br /><br />ScaleUnit where the namespace gets created |
|  enabled | No | boolean<br /><br />Whether or not the namespace is currently enabled. |
|  critical | No | boolean<br /><br />Whether or not the namespace is set as Critical. |
|  namespaceType | No | enum<br />**Messaging** or **NotificationHub**<br /><br />The namespace type. |


<a id="SharedAccessAuthorizationRuleProperties" />
## SharedAccessAuthorizationRuleProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  rights | No | array<br />**Manage**, **Send**, **Listen**<br /><br />The rights associated with the rule. |


<a id="NotificationHubProperties" />
## NotificationHubProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />The NotificationHub name. |
|  registrationTtl | No | string<br /><br />The RegistrationTtl of the created NotificationHub |
|  authorizationRules | No | array<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /><br />The AuthorizationRules of the created NotificationHub |
|  apnsCredential | No | object<br />[ApnsCredential object](#ApnsCredential)<br /><br />The ApnsCredential of the created NotificationHub |
|  wnsCredential | No | object<br />[WnsCredential object](#WnsCredential)<br /><br />The WnsCredential of the created NotificationHub |
|  gcmCredential | No | object<br />[GcmCredential object](#GcmCredential)<br /><br />The GcmCredential of the created NotificationHub |
|  mpnsCredential | No | object<br />[MpnsCredential object](#MpnsCredential)<br /><br />The MpnsCredential of the created NotificationHub |
|  admCredential | No | object<br />[AdmCredential object](#AdmCredential)<br /><br />The AdmCredential of the created NotificationHub |
|  baiduCredential | No | object<br />[BaiduCredential object](#BaiduCredential)<br /><br />The BaiduCredential of the created NotificationHub |


<a id="ApnsCredential" />
## ApnsCredential object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[ApnsCredentialProperties object](#ApnsCredentialProperties)<br /><br />Properties of NotificationHub ApnsCredential. |


<a id="ApnsCredentialProperties" />
## ApnsCredentialProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  apnsCertificate | No | string<br /><br />The APNS certificate. |
|  certificateKey | No | string<br /><br />The certificate key. |
|  endpoint | No | string<br /><br />The endpoint of this credential. |
|  thumbprint | No | string<br /><br />The Apns certificate Thumbprint |


<a id="WnsCredential" />
## WnsCredential object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[WnsCredentialProperties object](#WnsCredentialProperties)<br /><br />Properties of NotificationHub WnsCredential. |


<a id="WnsCredentialProperties" />
## WnsCredentialProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  packageSid | No | string<br /><br />The package ID for this credential. |
|  secretKey | No | string<br /><br />The secret key. |
|  windowsLiveEndpoint | No | string<br /><br />The Windows Live endpoint. |


<a id="GcmCredential" />
## GcmCredential object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[GcmCredentialProperties object](#GcmCredentialProperties)<br /><br />Properties of NotificationHub GcmCredential. |


<a id="GcmCredentialProperties" />
## GcmCredentialProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  gcmEndpoint | No | string<br /><br />The GCM endpoint. |
|  googleApiKey | No | string<br /><br />The Google API key. |


<a id="MpnsCredential" />
## MpnsCredential object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[MpnsCredentialProperties object](#MpnsCredentialProperties)<br /><br />Properties of NotificationHub MpnsCredential. |


<a id="MpnsCredentialProperties" />
## MpnsCredentialProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  mpnsCertificate | No | string<br /><br />The MPNS certificate. |
|  certificateKey | No | string<br /><br />The certificate key for this credential. |
|  thumbprint | No | string<br /><br />The Mpns certificate Thumbprint |


<a id="AdmCredential" />
## AdmCredential object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[AdmCredentialProperties object](#AdmCredentialProperties)<br /><br />Properties of NotificationHub AdmCredential. |


<a id="AdmCredentialProperties" />
## AdmCredentialProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  clientId | No | string<br /><br />The client identifier. |
|  clientSecret | No | string<br /><br />The credential secret access key. |
|  authTokenUrl | No | string<br /><br />The URL of the authorization token. |


<a id="BaiduCredential" />
## BaiduCredential object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[BaiduCredentialProperties object](#BaiduCredentialProperties)<br /><br />Properties of NotificationHub BaiduCredential. |


<a id="BaiduCredentialProperties" />
## BaiduCredentialProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  baiduApiKey | No | string<br /><br />Baidu Api Key. |
|  baiduEndPoint | No | string<br /><br />Baidu Endpoint. |
|  baiduSecretKey | No | string<br /><br />Baidu Secret Key |


<a id="namespaces_notificationHubs_AuthorizationRules_childResource" />
## namespaces_notificationHubs_AuthorizationRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**AuthorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /><br />Properties of the Namespace AuthorizationRules. |


<a id="namespaces_notificationHubs_childResource" />
## namespaces_notificationHubs_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**notificationHubs**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[NotificationHubProperties object](#NotificationHubProperties)<br /><br />Properties of the NotificationHub. |
|  resources | No | array<br />[AuthorizationRules object](#AuthorizationRules)<br /> |


<a id="namespaces_AuthorizationRules_childResource" />
## namespaces_AuthorizationRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**AuthorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />The sku of the created namespace |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /><br />Properties of the Namespace AuthorizationRules. |

