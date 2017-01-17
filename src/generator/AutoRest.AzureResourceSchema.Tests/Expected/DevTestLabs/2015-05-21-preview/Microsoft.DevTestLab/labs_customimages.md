# Microsoft.DevTestLab/labs/customimages template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs/customimages resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.DevTestLab/labs/customimages",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "vm": {
      "sourceVmId": "string",
      "sysPrep": boolean,
      "windowsOsInfo": {
        "windowsOsState": "string"
      },
      "linuxOsInfo": {
        "linuxOsState": "string"
      }
    },
    "vhd": {
      "imageName": "string",
      "sysPrep": boolean
    },
    "description": "string",
    "osType": "string",
    "author": "string",
    "creationDate": "string",
    "provisioningState": "string"
  },
  "id": "string",
  "name": "string",
  "location": "string",
  "tags": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs/customimages" />
### Microsoft.DevTestLab/labs/customimages object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.DevTestLab/labs/customimages |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [CustomImageProperties object](#CustomImageProperties) |
|  id | string | No | The identifier of the resource. |
|  name | string | No | The name of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="CustomImageProperties" />
### CustomImageProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vm | object | No | [CustomImagePropertiesFromVm object](#CustomImagePropertiesFromVm) |
|  vhd | object | No | The VHD from which the image is to be created. - [CustomImagePropertiesCustom object](#CustomImagePropertiesCustom) |
|  description | string | No | The description of the custom image. |
|  osType | enum | No | The OS type of the custom image. - Windows, Linux, None |
|  author | string | No | The author of the custom image. |
|  creationDate | string | No | The creation date of the custom image. |
|  provisioningState | string | No | The provisioning status of the resource. |


<a id="CustomImagePropertiesFromVm" />
### CustomImagePropertiesFromVm object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sourceVmId | string | No | The source vm identifier. |
|  sysPrep | boolean | No | Indicates whether sysprep has been run on the VHD. |
|  windowsOsInfo | object | No | The Windows OS information of the VM. - [WindowsOsInfo object](#WindowsOsInfo) |
|  linuxOsInfo | object | No | The Linux OS information of the VM. - [LinuxOsInfo object](#LinuxOsInfo) |


<a id="CustomImagePropertiesCustom" />
### CustomImagePropertiesCustom object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  imageName | string | No | The image name. |
|  sysPrep | boolean | No | Indicates whether sysprep has been run on the VHD. |


<a id="WindowsOsInfo" />
### WindowsOsInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  windowsOsState | enum | No | The state of the Windows OS. - NonSysprepped, SysprepRequested, SysprepApplied |


<a id="LinuxOsInfo" />
### LinuxOsInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  linuxOsState | enum | No | The state of the Linux OS. - NonDeprovisioned, DeprovisionRequested, DeprovisionApplied |

