# Microsoft.DevTestLab/labs/artifactsources template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs/artifactsources resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.DevTestLab/labs/artifactsources",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "displayName": "string",
    "uri": "string",
    "sourceType": "string",
    "folderPath": "string",
    "branchRef": "string",
    "securityToken": "string",
    "status": "string",
    "provisioningState": "string"
  },
  "id": "string",
  "location": "string",
  "tags": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs/artifactsources" />
### Microsoft.DevTestLab/labs/artifactsources object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.DevTestLab/labs/artifactsources |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [ArtifactSourceProperties object](#ArtifactSourceProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="ArtifactSourceProperties" />
### ArtifactSourceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  displayName | string | No | The display name of the artifact source. |
|  uri | string | No | The URI of the artifact source. |
|  sourceType | enum | No | The type of the artifact source. - VsoGit or GitHub |
|  folderPath | string | No | The folder path of the artifact source. |
|  branchRef | string | No | The branch reference of the artifact source. |
|  securityToken | string | No | The security token of the artifact source. |
|  status | enum | No | The status of the artifact source. - Enabled or Disabled |
|  provisioningState | string | No | The provisioning status of the resource. |

