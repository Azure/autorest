# Microsoft.ServerManagement template schema

Creates a Microsoft.ServerManagement resource.

## Schema format

To create a Microsoft.ServerManagement, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.ServerManagement/gateways",
  "apiVersion": "2016-07-01-preview",
  "properties": {
    "upgradeMode": "string"
  }
}
```
```
{
  "type": "Microsoft.ServerManagement/nodes",
  "apiVersion": "2016-07-01-preview",
  "properties": {
    "gatewayId": "string",
    "connectionName": "string",
    "userName": "string",
    "password": "string"
  }
}
```
```
{
  "type": "Microsoft.ServerManagement/nodes/sessions",
  "apiVersion": "2016-07-01-preview",
  "properties": {
    "userName": "string",
    "password": "string",
    "retentionPeriod": "string",
    "credentialDataFormat": "RsaEncrypted",
    "EncryptionCertificateThumbprint": "string"
  }
}
```
```
{
  "type": "Microsoft.ServerManagement/nodes/sessions/features/pssessions",
  "apiVersion": "2016-07-01-preview"
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="gateways" />
## gateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServerManagement/gateways**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-01-preview**<br /> |
|  location | No | string<br /><br />location of the resource |
|  tags | No | object<br /><br />resource tags |
|  properties | Yes | object<br />[GatewayParameters_properties object](#GatewayParameters_properties)<br /><br />collection of properties |


<a id="nodes" />
## nodes object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServerManagement/nodes**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-01-preview**<br /> |
|  location | No | string<br /><br />location of the resource? |
|  tags | No | object<br /><br />resource tags |
|  properties | Yes | object<br />[NodeParameters_properties object](#NodeParameters_properties)<br /><br />collection of properties |
|  resources | No | array<br />[sessions object](#sessions)<br /> |


<a id="nodes_sessions" />
## nodes_sessions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServerManagement/nodes/sessions**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-01-preview**<br /> |
|  properties | Yes | object<br />[SessionParameters_properties object](#SessionParameters_properties)<br /><br />collection of properties |


<a id="nodes_sessions_features_pssessions" />
## nodes_sessions_features_pssessions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServerManagement/nodes/sessions/features/pssessions**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-01-preview**<br /> |


<a id="GatewayParameters_properties" />
## GatewayParameters_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  upgradeMode | No | enum<br />**Manual** or **Automatic**<br /><br />The upgradeMode property gives the flexibility to gateway to auto upgrade itself. If properties value not specified, then we assume upgradeMode = Automatic. |


<a id="NodeParameters_properties" />
## NodeParameters_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  gatewayId | No | string<br /><br />Gateway id which will manage this node |
|  connectionName | No | string<br /><br />myhost.domain.com |
|  userName | No | string<br /><br />User name to be used to connect to node |
|  password | No | string<br /><br />Password associated with user name |


<a id="SessionParameters_properties" />
## SessionParameters_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  userName | No | string<br /><br />encrypted User name to be used to connect to node |
|  password | No | string<br /><br />encrypted Password associated with user name |
|  retentionPeriod | No | enum<br />**Session** or **Persistent**<br /><br />session retention period. |
|  credentialDataFormat | No | enum<br />**RsaEncrypted**<br /><br />credential data format. |
|  EncryptionCertificateThumbprint | No | string<br /><br />encryption certificate thumbprint |


<a id="nodes_sessions_childResource" />
## nodes_sessions_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**sessions**<br /> |
|  apiVersion | Yes | enum<br />**2016-07-01-preview**<br /> |
|  properties | Yes | object<br />[SessionParameters_properties object](#SessionParameters_properties)<br /><br />collection of properties |

