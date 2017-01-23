# Microsoft.ServerManagement/nodes template reference
API Version: 2016-07-01-preview
## Template format

To create a Microsoft.ServerManagement/nodes resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ServerManagement/nodes",
  "apiVersion": "2016-07-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "gatewayId": "string",
    "connectionName": "string",
    "userName": "string",
    "password": "string"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ServerManagement/nodes" />
### Microsoft.ServerManagement/nodes object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ServerManagement/nodes |
|  apiVersion | enum | Yes | 2016-07-01-preview |
|  location | string | No | location of the resource? |
|  tags | object | No | resource tags |
|  properties | object | Yes | collection of properties - [NodeParameters_properties object](#NodeParameters_properties) |
|  resources | array | No | [nodes_sessions_childResource object](#nodes_sessions_childResource) |


<a id="NodeParameters_properties" />
### NodeParameters_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  gatewayId | string | No | Gateway id which will manage this node |
|  connectionName | string | No | myhost.domain.com |
|  userName | string | No | User name to be used to connect to node |
|  password | string | No | Password associated with user name |


<a id="nodes_sessions_childResource" />
### nodes_sessions_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | sessions |
|  apiVersion | enum | Yes | 2016-07-01-preview |
|  properties | object | Yes | collection of properties - [SessionParameters_properties object](#SessionParameters_properties) |


<a id="SessionParameters_properties" />
### SessionParameters_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  userName | string | No | encrypted User name to be used to connect to node |
|  password | string | No | encrypted Password associated with user name |
|  retentionPeriod | enum | No | session retention period. - Session or Persistent |
|  credentialDataFormat | enum | No | credential data format. - RsaEncrypted |
|  EncryptionCertificateThumbprint | string | No | encryption certificate thumbprint |

