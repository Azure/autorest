# Microsoft.ServerManagement/gateways template reference
API Version: 2016-07-01-preview
## Template format

To create a Microsoft.ServerManagement/gateways resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ServerManagement/gateways",
  "apiVersion": "2016-07-01-preview",
  "location": "string",
  "tags": {},
  "properties": {
    "upgradeMode": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ServerManagement/gateways" />
### Microsoft.ServerManagement/gateways object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ServerManagement/gateways |
|  apiVersion | enum | Yes | 2016-07-01-preview |
|  location | string | No | location of the resource |
|  tags | object | No | resource tags |
|  properties | object | Yes | collection of properties - [GatewayParameters_properties object](#GatewayParameters_properties) |


<a id="GatewayParameters_properties" />
### GatewayParameters_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  upgradeMode | enum | No | The upgradeMode property gives the flexibility to gateway to auto upgrade itself. If properties value not specified, then we assume upgradeMode = Automatic. - Manual or Automatic |

