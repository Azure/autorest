# Microsoft.ApiManagement/service/openidConnectProviders template reference
API Version: 2016-07-07
## Template format

To create a Microsoft.ApiManagement/service/openidConnectProviders resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ApiManagement/service/openidConnectProviders",
  "apiVersion": "2016-07-07",
  "description": "string",
  "metadataEndpoint": "string",
  "clientId": "string",
  "clientSecret": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ApiManagement/service/openidConnectProviders" />
### Microsoft.ApiManagement/service/openidConnectProviders object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ApiManagement/service/openidConnectProviders |
|  apiVersion | enum | Yes | 2016-07-07 |
|  description | string | No | User-friendly description of OpenID Connect Provider. |
|  metadataEndpoint | string | Yes | Metadata endpoint URI. |
|  clientId | string | Yes | Client ID of developer console which is the client application. |
|  clientSecret | string | No | Client Secret of developer console which is the client application. |

