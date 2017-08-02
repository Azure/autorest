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
  "resources": []
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
|  resources | array | No | [notificationHubs](./namespaces/notificationHubs.md) [AuthorizationRules](./namespaces/AuthorizationRules.md) |


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

