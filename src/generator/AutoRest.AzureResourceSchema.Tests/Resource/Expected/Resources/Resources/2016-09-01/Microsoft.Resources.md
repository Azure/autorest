# Microsoft.Resources template schema

Creates a Microsoft.Resources resource.

## Schema format

To create a Microsoft.Resources, add the following schema to the resources section of your template.

```
{
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
## Values

The following tables describe the values you need to set in the schema.

<a id="deployments" />
## deployments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Resources/deployments**<br /> |
|  apiVersion | Yes | enum<br />**2016-09-01**<br /> |
|  properties | Yes | object<br />[DeploymentProperties object](#DeploymentProperties)<br /><br />The deployment properties. |


<a id="DeploymentProperties" />
## DeploymentProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  template | No | object<br /><br />The template content. It can be a JObject or a well formed JSON string. Use only one of Template or TemplateLink. |
|  templateLink | No | object<br />[TemplateLink object](#TemplateLink)<br /><br />The template URI. Use only one of Template or TemplateLink. |
|  parameters | No | object<br /><br />Deployment parameters. It can be a JObject or a well formed JSON string. Use only one of Parameters or ParametersLink. |
|  parametersLink | No | object<br />[ParametersLink object](#ParametersLink)<br /><br />The parameters URI. Use only one of Parameters or ParametersLink. |
|  mode | Yes | enum<br />**Incremental** or **Complete**<br /><br />The deployment mode. |
|  debugSetting | No | object<br />[DebugSetting object](#DebugSetting)<br /><br />The debug setting of the deployment. |


<a id="TemplateLink" />
## TemplateLink object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  uri | Yes | string<br /><br />URI referencing the template. |
|  contentVersion | No | string<br /><br />If included it must match the ContentVersion in the template. |


<a id="ParametersLink" />
## ParametersLink object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  uri | Yes | string<br /><br />URI referencing the template. |
|  contentVersion | No | string<br /><br />If included it must match the ContentVersion in the template. |


<a id="DebugSetting" />
## DebugSetting object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  detailLevel | No | string<br /><br />The debug detail level. |

