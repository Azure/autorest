# Microsoft.Resources/deployments template reference
API Version: 2016-09-01
## Template format

To create a Microsoft.Resources/deployments resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Resources/deployments",
  "apiVersion": "2016-09-01",
  "properties": {
    "template": {},
    "templateLink": {
      "uri": "string",
      "contentVersion": "string"
    },
    "parameters": {},
    "parametersLink": {
      "uri": "string",
      "contentVersion": "string"
    },
    "mode": "string",
    "debugSetting": {
      "detailLevel": "string"
    }
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Resources/deployments" />
### Microsoft.Resources/deployments object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Resources/deployments |
|  apiVersion | enum | Yes | 2016-09-01 |
|  properties | object | Yes | The deployment properties. - [DeploymentProperties object](#DeploymentProperties) |


<a id="DeploymentProperties" />
### DeploymentProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  template | object | No | The template content. It can be a JObject or a well formed JSON string. Use only one of Template or TemplateLink. |
|  templateLink | object | No | The template URI. Use only one of Template or TemplateLink. - [TemplateLink object](#TemplateLink) |
|  parameters | object | No | Deployment parameters. It can be a JObject or a well formed JSON string. Use only one of Parameters or ParametersLink. |
|  parametersLink | object | No | The parameters URI. Use only one of Parameters or ParametersLink. - [ParametersLink object](#ParametersLink) |
|  mode | enum | Yes | The deployment mode. - Incremental or Complete |
|  debugSetting | object | No | The debug setting of the deployment. - [DebugSetting object](#DebugSetting) |


<a id="TemplateLink" />
### TemplateLink object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  uri | string | Yes | URI referencing the template. |
|  contentVersion | string | No | If included it must match the ContentVersion in the template. |


<a id="ParametersLink" />
### ParametersLink object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  uri | string | Yes | URI referencing the template. |
|  contentVersion | string | No | If included it must match the ContentVersion in the template. |


<a id="DebugSetting" />
### DebugSetting object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  detailLevel | string | No | The debug detail level. |

