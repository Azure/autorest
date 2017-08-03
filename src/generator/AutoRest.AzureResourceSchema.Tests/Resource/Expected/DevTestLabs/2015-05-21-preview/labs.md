# Microsoft.DevTestLab/labs template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.DevTestLab/labs",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "defaultStorageAccount": "string",
    "artifactsStorageAccount": "string",
    "storageAccounts": [
      "string"
    ],
    "vaultName": "string",
    "labStorageType": "string",
    "defaultVirtualNetworkId": "string",
    "createdDate": "string",
    "provisioningState": "string"
  },
  "id": "string",
  "location": "string",
  "tags": {},
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs" />
### Microsoft.DevTestLab/labs object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.DevTestLab/labs |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [LabProperties object](#LabProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |
|  resources | array | No | [virtualnetworks](./labs/virtualnetworks.md) [virtualmachines](./labs/virtualmachines.md) [schedules](./labs/schedules.md) [formulas](./labs/formulas.md) [customimages](./labs/customimages.md) [artifactsources](./labs/artifactsources.md) |


<a id="LabProperties" />
### LabProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  defaultStorageAccount | string | No | The lab's default storage account. |
|  artifactsStorageAccount | string | No | The artifact storage account of the lab. |
|  storageAccounts | array | No | The storage accounts of the lab. - string |
|  vaultName | string | No | The name of the key vault of the lab. |
|  labStorageType | enum | No | The type of the lab storage. - Standard or Premium |
|  defaultVirtualNetworkId | string | No | The default virtual network identifier of the lab. |
|  createdDate | string | No | The creation date of the lab. |
|  provisioningState | string | No | The provisioning status of the resource. |

