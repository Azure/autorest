# Microsoft.ApiManagement/service/subscriptions template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/subscriptions resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ApiManagement/service/subscriptions",
  "apiVersion": "2016-07-07",
  "userId": "string",
  "productId": "string",
  "primaryKey": "string",
  "secondaryKey": "string",
  "state": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/subscriptions" />
### Microsoft.ApiManagement/service/subscriptions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ApiManagement/service/subscriptions |
|  apiVersion | enum | Yes | 2016-07-07 |
|  userId | string | Yes | User (user id path) for whom subscription is being created in form /users/{uid} |
|  productId | string | Yes | Product (product id path) for which subscription is being created in form /products/{productid} |
|  primaryKey | string | No | Primary subscription key. If not specified during request key will be generated automatically. |
|  secondaryKey | string | No | Secondary subscription key. If not specified during request key will be generated automatically. |
|  state | enum | No | Initial subscription state. - Suspended, Active, Expired, Submitted, Rejected, Cancelled |

