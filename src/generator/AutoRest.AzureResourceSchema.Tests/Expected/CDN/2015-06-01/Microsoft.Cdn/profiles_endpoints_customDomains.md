# Microsoft.Cdn/profiles/endpoints/customDomains template reference
API Version: 2015-06-01
## Template format

To create a Microsoft.Cdn/profiles/endpoints/customDomains resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Cdn/profiles/endpoints/customDomains",
  "apiVersion": "2015-06-01",
  "properties": {
    "hostName": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Cdn/profiles/endpoints/customDomains" />
### Microsoft.Cdn/profiles/endpoints/customDomains object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Cdn/profiles/endpoints/customDomains |
|  apiVersion | enum | Yes | 2015-06-01 |
|  properties | object | Yes | [CustomDomainPropertiesParameters object](#CustomDomainPropertiesParameters) |


<a id="CustomDomainPropertiesParameters" />
### CustomDomainPropertiesParameters object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  hostName | string | Yes | The host name of the custom domain. Must be a domain name. |

