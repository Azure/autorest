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
  "resources": [
    null
  ]
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
|  resources | array | No | [labs_virtualnetworks_childResource object](#labs_virtualnetworks_childResource) [labs_virtualmachines_childResource object](#labs_virtualmachines_childResource) [labs_schedules_childResource object](#labs_schedules_childResource) [labs_formulas_childResource object](#labs_formulas_childResource) [labs_customimages_childResource object](#labs_customimages_childResource) [labs_artifactsources_childResource object](#labs_artifactsources_childResource) |


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


<a id="labs_virtualnetworks_childResource" />
### labs_virtualnetworks_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | virtualnetworks |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [VirtualNetworkProperties object](#VirtualNetworkProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="labs_virtualmachines_childResource" />
### labs_virtualmachines_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | virtualmachines |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [LabVirtualMachineProperties object](#LabVirtualMachineProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="labs_schedules_childResource" />
### labs_schedules_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | schedules |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [ScheduleProperties object](#ScheduleProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="labs_formulas_childResource" />
### labs_formulas_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | formulas |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [FormulaProperties object](#FormulaProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="labs_customimages_childResource" />
### labs_customimages_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | customimages |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [CustomImageProperties object](#CustomImageProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="labs_artifactsources_childResource" />
### labs_artifactsources_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | artifactsources |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [ArtifactSourceProperties object](#ArtifactSourceProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="VirtualNetworkProperties" />
### VirtualNetworkProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allowedSubnets | array | No | The allowed subnets of the virtual network. - [Subnet object](#Subnet) |
|  description | string | No | The description of the virtual network. |
|  externalProviderResourceId | string | No | The Microsoft.Network resource identifier of the virtual network. |
|  subnetOverrides | array | No | The subnet overrides of the virtual network. - [SubnetOverride object](#SubnetOverride) |
|  provisioningState | string | No | The provisioning status of the resource. |


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


<a id="ScheduleProperties" />
### ScheduleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  status | enum | No | The status of the schedule. - Enabled or Disabled |
|  taskType | enum | No | The task type of the schedule. - LabVmsShutdownTask, LabVmsStartupTask, LabBillingTask |
|  weeklyRecurrence | object | No | The weekly recurrence of the schedule. - [WeekDetails object](#WeekDetails) |
|  dailyRecurrence | object | No | The daily recurrence of the schedule. - [DayDetails object](#DayDetails) |
|  hourlyRecurrence | object | No | The hourly recurrence of the schedule. - [HourDetails object](#HourDetails) |
|  timeZoneId | string | No | The time zone id. |
|  provisioningState | string | No | The provisioning status of the resource. |


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


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  resourceId | string | No |  |
|  labSubnetName | string | No |  |
|  allowPublicIp | enum | No | Default, Deny, Allow |


<a id="SubnetOverride" />
### SubnetOverride object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  resourceId | string | No | The resource identifier of the subnet. |
|  labSubnetName | string | No | The name given to the subnet within the lab. |
|  useInVmCreationPermission | enum | No | Indicates whether this subnet can be used during virtual machine creation. - Default, Deny, Allow |
|  usePublicIpAddressPermission | enum | No | Indicates whether public IP addresses can be assigned to virtual machines on this subnet. - Default, Deny, Allow |


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


<a id="WeekDetails" />
### WeekDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  weekdays | array | No | The days of the week. - string |
|  time | string | No | The time of the day. |


<a id="DayDetails" />
### DayDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  time | string | No |  |


<a id="HourDetails" />
### HourDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  minute | integer | No | Minutes of the hour the schedule will run. |


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


<a id="ArtifactParameterProperties" />
### ArtifactParameterProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The name of the artifact parameter. |
|  value | string | No | The value of the artifact parameter. |


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

