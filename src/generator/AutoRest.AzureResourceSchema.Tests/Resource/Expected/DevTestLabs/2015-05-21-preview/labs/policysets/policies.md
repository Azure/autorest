# Microsoft.DevTestLab/labs/policysets/policies template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs/policysets/policies resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.DevTestLab/labs/policysets/policies",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "description": "string",
    "status": "string",
    "factName": "string",
    "factData": "string",
    "threshold": "string",
    "evaluatorType": "string",
    "provisioningState": "string"
  },
  "id": "string",
  "location": "string",
  "tags": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs/policysets/policies" />
### Microsoft.DevTestLab/labs/policysets/policies object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.DevTestLab/labs/policysets/policies |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [PolicyProperties object](#PolicyProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="PolicyProperties" />
### PolicyProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  description | string | No | The description of the policy. |
|  status | enum | No | The status of the policy. - Enabled or Disabled |
|  factName | enum | No | The fact name of the policy. - UserOwnedLabVmCount, LabVmCount, LabVmSize, GalleryImage, UserOwnedLabVmCountInSubnet |
|  factData | string | No | The fact data of the policy. |
|  threshold | string | No | The threshold of the policy. |
|  evaluatorType | enum | No | The evaluator type of the policy. - AllowedValuesPolicy or MaxValuePolicy |
|  provisioningState | string | No | The provisioning status of the resource. |

