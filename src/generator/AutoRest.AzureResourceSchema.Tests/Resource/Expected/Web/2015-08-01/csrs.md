# Microsoft.Web/csrs template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/csrs resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Web/csrs",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "name": "string",
    "distinguishedName": "string",
    "csrString": "string",
    "pfxBlob": "string",
    "password": "string",
    "publicKeyHash": "string",
    "hostingEnvironment": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/csrs" />
### Microsoft.Web/csrs object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Web/csrs |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Csr_properties object](#Csr_properties) |


<a id="Csr_properties" />
### Csr_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name used to locate CSR object |
|  distinguishedName | string | No | Distinguished name of certificate to be created |
|  csrString | string | No | Actual CSR string created |
|  pfxBlob | string | No | PFX certifcate of created certificate |
|  password | string | No | PFX password |
|  publicKeyHash | string | No | Hash of the certificates public key |
|  hostingEnvironment | string | No | Hosting environment |

