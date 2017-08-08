# Microsoft.Web/certificates template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/certificates resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Web/certificates",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "friendlyName": "string",
    "subjectName": "string",
    "hostNames": [
      "string"
    ],
    "pfxBlob": "string",
    "siteName": "string",
    "selfLink": "string",
    "issuer": "string",
    "issueDate": "string",
    "expirationDate": "string",
    "password": "string",
    "thumbprint": "string",
    "valid": boolean,
    "cerBlob": "string",
    "publicKeyHash": "string",
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    }
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/certificates" />
### Microsoft.Web/certificates object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Web/certificates |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Certificate_properties object](#Certificate_properties) |


<a id="Certificate_properties" />
### Certificate_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  friendlyName | string | No | Friendly name of the certificate |
|  subjectName | string | No | Subject name of the certificate |
|  hostNames | array | No | Host names the certificate applies to - string |
|  pfxBlob | string | No | Pfx blob |
|  siteName | string | No | App name |
|  selfLink | string | No | Self link |
|  issuer | string | No | Certificate issuer |
|  issueDate | string | No | Certificate issue Date |
|  expirationDate | string | No | Certificate expriration date |
|  password | string | No | Certificate password |
|  thumbprint | string | No | Certificate thumbprint |
|  valid | boolean | No | Is the certificate valid? |
|  cerBlob | string | No | Raw bytes of .cer file |
|  publicKeyHash | string | No | Public key hash |
|  hostingEnvironmentProfile | object | No | Specification for the hosting environment (App Service Environment) to use for the certificate - [HostingEnvironmentProfile object](#HostingEnvironmentProfile) |


<a id="HostingEnvironmentProfile" />
### HostingEnvironmentProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource id of the hostingEnvironment (App Service Environment) |
|  name | string | No | Name of the hostingEnvironment (App Service Environment) (read only) |
|  type | string | No | Resource type of the hostingEnvironment (App Service Environment) (read only) |

