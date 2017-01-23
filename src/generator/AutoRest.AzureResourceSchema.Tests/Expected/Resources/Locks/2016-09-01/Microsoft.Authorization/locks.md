# Microsoft.Authorization/locks template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Authorization/locks resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Authorization/locks",
  "apiVersion": "2016-09-01",
  "properties": {
    "level": "string",
    "notes": "string",
    "owners": [
      {
        "applicationId": "string"
      }
    ]
  },
  "name": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Authorization/locks" />
### Microsoft.Authorization/locks object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Authorization/locks |
|  apiVersion | enum | Yes | 2016-09-01 |
|  properties | object | Yes | The properties of the lock. - [ManagementLockProperties object](#ManagementLockProperties) |
|  name | string | No | The name of the lock. |


<a id="ManagementLockProperties" />
### ManagementLockProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  level | enum | Yes | The lock level of the management lock. - NotSpecified, CanNotDelete, ReadOnly |
|  notes | string | No | The notes of the management lock. |
|  owners | array | No | The owners of the management lock. - [ManagementLockOwner object](#ManagementLockOwner) |


<a id="ManagementLockOwner" />
### ManagementLockOwner object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  applicationId | string | No | The application Id of the management lock owner. |

