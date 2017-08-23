# Microsoft.ServiceBus/namespaces template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.ServiceBus/namespaces resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ServiceBus/namespaces",
  "apiVersion": "2015-08-01",
  "location": "string",
  "sku": {
    "name": "string",
    "tier": "string",
    "capacity": "integer"
  },
  "tags": {},
  "properties": {
    "provisioningState": "string",
    "status": "string",
    "createdAt": "string",
    "updatedAt": "string",
    "serviceBusEndpoint": "string",
    "createACSNamespace": boolean,
    "enabled": boolean
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ServiceBus/namespaces" />
### Microsoft.ServiceBus/namespaces object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ServiceBus/namespaces |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | Yes | Namespace location. |
|  sku | object | No | [Sku object](#Sku) |
|  tags | object | No | Namespace tags. |
|  properties | object | Yes | [NamespaceProperties object](#NamespaceProperties) |
|  resources | array | No | [topics](./namespaces/topics.md) [queues](./namespaces/queues.md) [AuthorizationRules](./namespaces/AuthorizationRules.md) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Name of this Sku. - Basic, Standard, Premium |
|  tier | enum | Yes | The tier of this particular SKU. - Basic, Standard, Premium |
|  capacity | integer | No | The messaging units for the tier specified |


<a id="NamespaceProperties" />
### NamespaceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  provisioningState | string | No | Provisioning state of the Namespace. |
|  status | enum | No | State of the namespace. - Unknown, Creating, Created, Activating, Enabling, Active, Disabling, Disabled, SoftDeleting, SoftDeleted, Removing, Removed, Failed |
|  createdAt | string | No | The time the namespace was created. |
|  updatedAt | string | No | The time the namespace was updated. |
|  serviceBusEndpoint | string | No | Endpoint you can use to perform ServiceBus operations. |
|  createACSNamespace | boolean | No | Indicates whether to create ACS namespace. |
|  enabled | boolean | No | Specifies whether this instance is enabled. |

