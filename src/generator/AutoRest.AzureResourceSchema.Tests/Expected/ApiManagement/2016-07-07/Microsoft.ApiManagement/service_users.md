# Microsoft.ApiManagement/service/users template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/users resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ApiManagement/service/users",
  "apiVersion": "2016-07-07",
  "email": "string",
  "password": "string",
  "firstName": "string",
  "lastName": "string",
  "state": "string",
  "note": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/users" />
### Microsoft.ApiManagement/service/users object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ApiManagement/service/users |
|  apiVersion | enum | Yes | 2016-07-07 |
|  email | string | Yes | Email address. |
|  password | string | Yes | Password. |
|  firstName | string | Yes | First name. |
|  lastName | string | Yes | Last name. |
|  state | enum | No | Account state. - Active or Blocked |
|  note | string | No | Note about user. |

