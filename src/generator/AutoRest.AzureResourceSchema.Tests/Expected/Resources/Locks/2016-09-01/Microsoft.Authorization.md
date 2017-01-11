# Microsoft.Authorization template schema

Creates a Microsoft.Authorization resource.

## Schema format

To create a Microsoft.Authorization, add the following schema to the resources section of your template.

```
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
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="locks" />
## locks object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Authorization/locks**<br /> |
|  apiVersion | Yes | enum<br />**2016-09-01**<br /> |
|  properties | Yes | object<br />[ManagementLockProperties object](#ManagementLockProperties)<br /><br />The properties of the lock. |
|  name | No | string<br /><br />The name of the lock. |


<a id="ManagementLockProperties" />
## ManagementLockProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  level | Yes | enum<br />**NotSpecified**, **CanNotDelete**, **ReadOnly**<br /><br />The lock level of the management lock. |
|  notes | No | string<br /><br />The notes of the management lock. |
|  owners | No | array<br />[ManagementLockOwner object](#ManagementLockOwner)<br /><br />The owners of the management lock. |


<a id="ManagementLockOwner" />
## ManagementLockOwner object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  applicationId | No | string<br /><br />The application Id of the management lock owner. |

