# Microsoft.Web/sites/hostNameBindings template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/sites/hostNameBindings resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Web/sites/hostNameBindings",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "name": "string",
    "siteName": "string",
    "domainId": "string",
    "azureResourceName": "string",
    "azureResourceType": "string",
    "customHostNameDnsRecordType": "string",
    "hostNameType": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/sites/hostNameBindings" />
### Microsoft.Web/sites/hostNameBindings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Web/sites/hostNameBindings |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [HostNameBinding_properties object](#HostNameBinding_properties) |


<a id="HostNameBinding_properties" />
### HostNameBinding_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Hostname |
|  siteName | string | No | Web app name |
|  domainId | string | No | Fully qualified ARM domain resource URI |
|  azureResourceName | string | No | Azure resource name |
|  azureResourceType | enum | No | Azure resource type. - Website or TrafficManager |
|  customHostNameDnsRecordType | enum | No | Custom DNS record type. - CName or A |
|  hostNameType | enum | No | Host name type. - Verified or Managed |

