# Microsoft.DevTestLab/labs/formulas template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs/formulas resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.DevTestLab/labs/formulas",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "description": "string",
    "author": "string",
    "osType": "string",
    "creationDate": "string",
    "formulaContent": {
      "properties": {
        "notes": "string",
        "ownerObjectId": "string",
        "createdByUserId": "string",
        "createdByUser": "string",
        "computeId": "string",
        "customImageId": "string",
        "osType": "string",
        "size": "string",
        "userName": "string",
        "password": "string",
        "sshKey": "string",
        "isAuthenticationWithSshKey": boolean,
        "fqdn": "string",
        "labSubnetName": "string",
        "labVirtualNetworkId": "string",
        "disallowPublicIpAddress": boolean,
        "artifacts": [
          {
            "artifactId": "string",
            "parameters": [
              {
                "name": "string",
                "value": "string"
              }
            ]
          }
        ],
        "artifactDeploymentStatus": {
          "deploymentStatus": "string",
          "artifactsApplied": "integer",
          "totalArtifacts": "integer"
        },
        "galleryImageReference": {
          "offer": "string",
          "publisher": "string",
          "sku": "string",
          "osType": "string",
          "version": "string"
        },
        "provisioningState": "string"
      },
      "id": "string",
      "name": "string",
      "type": "string",
      "location": "string",
      "tags": {}
    },
    "vm": {
      "labVmId": "string"
    },
    "provisioningState": "string"
  },
  "id": "string",
  "location": "string",
  "tags": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs/formulas" />
### Microsoft.DevTestLab/labs/formulas object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.DevTestLab/labs/formulas |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [FormulaProperties object](#FormulaProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="FormulaProperties" />
### FormulaProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  description | string | No | The description of the formula. |
|  author | string | No | The author of the formula. |
|  osType | string | No | The OS type of the formula. |
|  creationDate | string | No | The creation date of the formula. |
|  formulaContent | object | No | The content of the formula. - [LabVirtualMachine object](#LabVirtualMachine) |
|  vm | object | No | Information about a VM from which a formula is to be created. - [FormulaPropertiesFromVm object](#FormulaPropertiesFromVm) |
|  provisioningState | string | No | The provisioning status of the resource. |


<a id="LabVirtualMachine" />
### LabVirtualMachine object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  properties | object | No | The properties of the resource. - [LabVirtualMachineProperties object](#LabVirtualMachineProperties) |
|  id | string | No | The identifier of the resource. |
|  name | string | No | The name of the resource. |
|  type | string | No | The type of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="FormulaPropertiesFromVm" />
### FormulaPropertiesFromVm object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  labVmId | string | No | The identifier of the VM from which a formula is to be created. |


<a id="LabVirtualMachineProperties" />
### LabVirtualMachineProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  notes | string | No | The notes of the virtual machine. |
|  ownerObjectId | string | No | The object identifier of the owner of the virtual machine. |
|  createdByUserId | string | No | The object identifier of the creator of the virtual machine. |
|  createdByUser | string | No | The email address of creator of the virtual machine. |
|  computeId | string | No | The resource identifier (Microsoft.Compute) of the virtual machine. |
|  customImageId | string | No | The custom image identifier of the virtual machine. |
|  osType | string | No | The OS type of the virtual machine. |
|  size | string | No | The size of the virtual machine. |
|  userName | string | No | The user name of the virtual machine. |
|  password | string | No | The password of the virtual machine administrator. |
|  sshKey | string | No | The SSH key of the virtual machine administrator. |
|  isAuthenticationWithSshKey | boolean | No | A value indicating whether this virtual machine uses an SSH key for authentication. |
|  fqdn | string | No | The fully-qualified domain name of the virtual machine. |
|  labSubnetName | string | No | The lab subnet name of the virtual machine. |
|  labVirtualNetworkId | string | No | The lab virtual network identifier of the virtual machine. |
|  disallowPublicIpAddress | boolean | No | Indicates whether the virtual machine is to be created without a public IP address. |
|  artifacts | array | No | The artifacts to be installed on the virtual machine. - [ArtifactInstallProperties object](#ArtifactInstallProperties) |
|  artifactDeploymentStatus | object | No | The artifact deployment status for the virtual machine. - [ArtifactDeploymentStatusProperties object](#ArtifactDeploymentStatusProperties) |
|  galleryImageReference | object | No | The Microsoft Azure Marketplace image reference of the virtual machine. - [GalleryImageReference object](#GalleryImageReference) |
|  provisioningState | string | No | The provisioning status of the resource. |


<a id="ArtifactInstallProperties" />
### ArtifactInstallProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  artifactId | string | No | The artifact's identifier. |
|  parameters | array | No | The parameters of the artifact. - [ArtifactParameterProperties object](#ArtifactParameterProperties) |


<a id="ArtifactDeploymentStatusProperties" />
### ArtifactDeploymentStatusProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  deploymentStatus | string | No | The deployment status of the artifact. |
|  artifactsApplied | integer | No | The total count of the artifacts that were successfully applied. |
|  totalArtifacts | integer | No | The total count of the artifacts that were tentatively applied. |


<a id="GalleryImageReference" />
### GalleryImageReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  offer | string | No | The offer of the gallery image. |
|  publisher | string | No | The publisher of the gallery image. |
|  sku | string | No | The SKU of the gallery image. |
|  osType | string | No | The OS type of the gallery image. |
|  version | string | No | The version of the gallery image. |


<a id="ArtifactParameterProperties" />
### ArtifactParameterProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The name of the artifact parameter. |
|  value | string | No | The value of the artifact parameter. |

