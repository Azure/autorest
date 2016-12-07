# Microsoft.DevTestLab template schema

Creates a Microsoft.DevTestLab resource.

## Schema format

To create a Microsoft.DevTestLab, add the following schema to the resources section of your template.

```
{
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
  }
}
```
```
{
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
  }
}
```
```
{
  "type": "Microsoft.DevTestLab/labs/customimages",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "vm": {
      "sourceVmId": "string",
      "sysPrep": "boolean",
      "windowsOsInfo": {
        "windowsOsState": "string"
      },
      "linuxOsInfo": {
        "linuxOsState": "string"
      }
    },
    "vhd": {
      "imageName": "string",
      "sysPrep": "boolean"
    },
    "description": "string",
    "osType": "string",
    "author": "string",
    "creationDate": "string",
    "provisioningState": "string"
  }
}
```
```
{
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
        "isAuthenticationWithSshKey": "boolean",
        "fqdn": "string",
        "labSubnetName": "string",
        "labVirtualNetworkId": "string",
        "disallowPublicIpAddress": "boolean",
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
  }
}
```
```
{
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
  }
}
```
```
{
  "type": "Microsoft.DevTestLab/labs/schedules",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "status": "string",
    "taskType": "string",
    "weeklyRecurrence": {
      "weekdays": [
        "string"
      ],
      "time": "string"
    },
    "dailyRecurrence": {
      "time": "string"
    },
    "hourlyRecurrence": {
      "minute": "integer"
    },
    "timeZoneId": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.DevTestLab/labs/virtualmachines",
  "apiVersion": "2015-05-21-preview",
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
    "isAuthenticationWithSshKey": "boolean",
    "fqdn": "string",
    "labSubnetName": "string",
    "labVirtualNetworkId": "string",
    "disallowPublicIpAddress": "boolean",
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
  }
}
```
```
{
  "type": "Microsoft.DevTestLab/labs/virtualnetworks",
  "apiVersion": "2015-05-21-preview",
  "properties": {
    "allowedSubnets": [
      {
        "resourceId": "string",
        "labSubnetName": "string",
        "allowPublicIp": "string"
      }
    ],
    "description": "string",
    "externalProviderResourceId": "string",
    "subnetOverrides": [
      {
        "resourceId": "string",
        "labSubnetName": "string",
        "useInVmCreationPermission": "string",
        "usePublicIpAddressPermission": "string"
      }
    ],
    "provisioningState": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="labs" />
## labs object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[LabProperties object](#LabProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |
|  resources | No | array<br />[virtualnetworks object](#virtualnetworks)<br />[virtualmachines object](#virtualmachines)<br />[schedules object](#schedules)<br />[formulas object](#formulas)<br />[customimages object](#customimages)<br />[artifactsources object](#artifactsources)<br /> |


<a id="labs_artifactsources" />
## labs_artifactsources object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/artifactsources**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[ArtifactSourceProperties object](#ArtifactSourceProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_customimages" />
## labs_customimages object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/customimages**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[CustomImageProperties object](#CustomImageProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_formulas" />
## labs_formulas object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/formulas**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[FormulaProperties object](#FormulaProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_policysets_policies" />
## labs_policysets_policies object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/policysets/policies**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[PolicyProperties object](#PolicyProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_schedules" />
## labs_schedules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/schedules**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[ScheduleProperties object](#ScheduleProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_virtualmachines" />
## labs_virtualmachines object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/virtualmachines**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[LabVirtualMachineProperties object](#LabVirtualMachineProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_virtualnetworks" />
## labs_virtualnetworks object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DevTestLab/labs/virtualnetworks**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[VirtualNetworkProperties object](#VirtualNetworkProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="LabProperties" />
## LabProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  defaultStorageAccount | No | string<br /><br />The lab's default storage account. |
|  artifactsStorageAccount | No | string<br /><br />The artifact storage account of the lab. |
|  storageAccounts | No | array<br />**string**<br /><br />The storage accounts of the lab. |
|  vaultName | No | string<br /><br />The name of the key vault of the lab. |
|  labStorageType | No | enum<br />**Standard** or **Premium**<br /><br />The type of the lab storage. |
|  defaultVirtualNetworkId | No | string<br /><br />The default virtual network identifier of the lab. |
|  createdDate | No | string<br /><br />The creation date of the lab. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="ArtifactSourceProperties" />
## ArtifactSourceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  displayName | No | string<br /><br />The display name of the artifact source. |
|  uri | No | string<br /><br />The URI of the artifact source. |
|  sourceType | No | enum<br />**VsoGit** or **GitHub**<br /><br />The type of the artifact source. |
|  folderPath | No | string<br /><br />The folder path of the artifact source. |
|  branchRef | No | string<br /><br />The branch reference of the artifact source. |
|  securityToken | No | string<br /><br />The security token of the artifact source. |
|  status | No | enum<br />**Enabled** or **Disabled**<br /><br />The status of the artifact source. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="CustomImageProperties" />
## CustomImageProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  vm | No | object<br />[CustomImagePropertiesFromVm object](#CustomImagePropertiesFromVm)<br /> |
|  vhd | No | object<br />[CustomImagePropertiesCustom object](#CustomImagePropertiesCustom)<br /><br />The VHD from which the image is to be created. |
|  description | No | string<br /><br />The description of the custom image. |
|  osType | No | enum<br />**Windows**, **Linux**, **None**<br /><br />The OS type of the custom image. |
|  author | No | string<br /><br />The author of the custom image. |
|  creationDate | No | string<br /><br />The creation date of the custom image. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="CustomImagePropertiesFromVm" />
## CustomImagePropertiesFromVm object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sourceVmId | No | string<br /><br />The source vm identifier. |
|  sysPrep | No | boolean<br /><br />Indicates whether sysprep has been run on the VHD. |
|  windowsOsInfo | No | object<br />[WindowsOsInfo object](#WindowsOsInfo)<br /><br />The Windows OS information of the VM. |
|  linuxOsInfo | No | object<br />[LinuxOsInfo object](#LinuxOsInfo)<br /><br />The Linux OS information of the VM. |


<a id="WindowsOsInfo" />
## WindowsOsInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  windowsOsState | No | enum<br />**NonSysprepped**, **SysprepRequested**, **SysprepApplied**<br /><br />The state of the Windows OS. |


<a id="LinuxOsInfo" />
## LinuxOsInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  linuxOsState | No | enum<br />**NonDeprovisioned**, **DeprovisionRequested**, **DeprovisionApplied**<br /><br />The state of the Linux OS. |


<a id="CustomImagePropertiesCustom" />
## CustomImagePropertiesCustom object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  imageName | No | string<br /><br />The image name. |
|  sysPrep | No | boolean<br /><br />Indicates whether sysprep has been run on the VHD. |


<a id="FormulaProperties" />
## FormulaProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  description | No | string<br /><br />The description of the formula. |
|  author | No | string<br /><br />The author of the formula. |
|  osType | No | string<br /><br />The OS type of the formula. |
|  creationDate | No | string<br /><br />The creation date of the formula. |
|  formulaContent | No | object<br />[LabVirtualMachine object](#LabVirtualMachine)<br /><br />The content of the formula. |
|  vm | No | object<br />[FormulaPropertiesFromVm object](#FormulaPropertiesFromVm)<br /><br />Information about a VM from which a formula is to be created. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="LabVirtualMachine" />
## LabVirtualMachine object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  properties | No | object<br />[LabVirtualMachineProperties object](#LabVirtualMachineProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  type | No | string<br /><br />The type of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="LabVirtualMachineProperties" />
## LabVirtualMachineProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  notes | No | string<br /><br />The notes of the virtual machine. |
|  ownerObjectId | No | string<br /><br />The object identifier of the owner of the virtual machine. |
|  createdByUserId | No | string<br /><br />The object identifier of the creator of the virtual machine. |
|  createdByUser | No | string<br /><br />The email address of creator of the virtual machine. |
|  computeId | No | string<br /><br />The resource identifier (Microsoft.Compute) of the virtual machine. |
|  customImageId | No | string<br /><br />The custom image identifier of the virtual machine. |
|  osType | No | string<br /><br />The OS type of the virtual machine. |
|  size | No | string<br /><br />The size of the virtual machine. |
|  userName | No | string<br /><br />The user name of the virtual machine. |
|  password | No | string<br /><br />The password of the virtual machine administrator. |
|  sshKey | No | string<br /><br />The SSH key of the virtual machine administrator. |
|  isAuthenticationWithSshKey | No | boolean<br /><br />A value indicating whether this virtual machine uses an SSH key for authentication. |
|  fqdn | No | string<br /><br />The fully-qualified domain name of the virtual machine. |
|  labSubnetName | No | string<br /><br />The lab subnet name of the virtual machine. |
|  labVirtualNetworkId | No | string<br /><br />The lab virtual network identifier of the virtual machine. |
|  disallowPublicIpAddress | No | boolean<br /><br />Indicates whether the virtual machine is to be created without a public IP address. |
|  artifacts | No | array<br />[ArtifactInstallProperties object](#ArtifactInstallProperties)<br /><br />The artifacts to be installed on the virtual machine. |
|  artifactDeploymentStatus | No | object<br />[ArtifactDeploymentStatusProperties object](#ArtifactDeploymentStatusProperties)<br /><br />The artifact deployment status for the virtual machine. |
|  galleryImageReference | No | object<br />[GalleryImageReference object](#GalleryImageReference)<br /><br />The Microsoft Azure Marketplace image reference of the virtual machine. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="ArtifactInstallProperties" />
## ArtifactInstallProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  artifactId | No | string<br /><br />The artifact's identifier. |
|  parameters | No | array<br />[ArtifactParameterProperties object](#ArtifactParameterProperties)<br /><br />The parameters of the artifact. |


<a id="ArtifactParameterProperties" />
## ArtifactParameterProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />The name of the artifact parameter. |
|  value | No | string<br /><br />The value of the artifact parameter. |


<a id="ArtifactDeploymentStatusProperties" />
## ArtifactDeploymentStatusProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  deploymentStatus | No | string<br /><br />The deployment status of the artifact. |
|  artifactsApplied | No | integer<br /><br />The total count of the artifacts that were successfully applied. |
|  totalArtifacts | No | integer<br /><br />The total count of the artifacts that were tentatively applied. |


<a id="GalleryImageReference" />
## GalleryImageReference object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  offer | No | string<br /><br />The offer of the gallery image. |
|  publisher | No | string<br /><br />The publisher of the gallery image. |
|  sku | No | string<br /><br />The SKU of the gallery image. |
|  osType | No | string<br /><br />The OS type of the gallery image. |
|  version | No | string<br /><br />The version of the gallery image. |


<a id="FormulaPropertiesFromVm" />
## FormulaPropertiesFromVm object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  labVmId | No | string<br /><br />The identifier of the VM from which a formula is to be created. |


<a id="PolicyProperties" />
## PolicyProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  description | No | string<br /><br />The description of the policy. |
|  status | No | enum<br />**Enabled** or **Disabled**<br /><br />The status of the policy. |
|  factName | No | enum<br />**UserOwnedLabVmCount**, **LabVmCount**, **LabVmSize**, **GalleryImage**, **UserOwnedLabVmCountInSubnet**<br /><br />The fact name of the policy. |
|  factData | No | string<br /><br />The fact data of the policy. |
|  threshold | No | string<br /><br />The threshold of the policy. |
|  evaluatorType | No | enum<br />**AllowedValuesPolicy** or **MaxValuePolicy**<br /><br />The evaluator type of the policy. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="ScheduleProperties" />
## ScheduleProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  status | No | enum<br />**Enabled** or **Disabled**<br /><br />The status of the schedule. |
|  taskType | No | enum<br />**LabVmsShutdownTask**, **LabVmsStartupTask**, **LabBillingTask**<br /><br />The task type of the schedule. |
|  weeklyRecurrence | No | object<br />[WeekDetails object](#WeekDetails)<br /><br />The weekly recurrence of the schedule. |
|  dailyRecurrence | No | object<br />[DayDetails object](#DayDetails)<br /><br />The daily recurrence of the schedule. |
|  hourlyRecurrence | No | object<br />[HourDetails object](#HourDetails)<br /><br />The hourly recurrence of the schedule. |
|  timeZoneId | No | string<br /><br />The time zone id. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="WeekDetails" />
## WeekDetails object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  weekdays | No | array<br />**string**<br /><br />The days of the week. |
|  time | No | string<br /><br />The time of the day. |


<a id="DayDetails" />
## DayDetails object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  time | No | string<br /> |


<a id="HourDetails" />
## HourDetails object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  minute | No | integer<br /><br />Minutes of the hour the schedule will run. |


<a id="VirtualNetworkProperties" />
## VirtualNetworkProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  allowedSubnets | No | array<br />[Subnet object](#Subnet)<br /><br />The allowed subnets of the virtual network. |
|  description | No | string<br /><br />The description of the virtual network. |
|  externalProviderResourceId | No | string<br /><br />The Microsoft.Network resource identifier of the virtual network. |
|  subnetOverrides | No | array<br />[SubnetOverride object](#SubnetOverride)<br /><br />The subnet overrides of the virtual network. |
|  provisioningState | No | string<br /><br />The provisioning status of the resource. |


<a id="Subnet" />
## Subnet object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  resourceId | No | string<br /> |
|  labSubnetName | No | string<br /> |
|  allowPublicIp | No | enum<br />**Default**, **Deny**, **Allow**<br /> |


<a id="SubnetOverride" />
## SubnetOverride object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  resourceId | No | string<br /><br />The resource identifier of the subnet. |
|  labSubnetName | No | string<br /><br />The name given to the subnet within the lab. |
|  useInVmCreationPermission | No | enum<br />**Default**, **Deny**, **Allow**<br /><br />Indicates whether this subnet can be used during virtual machine creation. |
|  usePublicIpAddressPermission | No | enum<br />**Default**, **Deny**, **Allow**<br /><br />Indicates whether public IP addresses can be assigned to virtual machines on this subnet. |


<a id="labs_virtualnetworks_childResource" />
## labs_virtualnetworks_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**virtualnetworks**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[VirtualNetworkProperties object](#VirtualNetworkProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_virtualmachines_childResource" />
## labs_virtualmachines_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**virtualmachines**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[LabVirtualMachineProperties object](#LabVirtualMachineProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_schedules_childResource" />
## labs_schedules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**schedules**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[ScheduleProperties object](#ScheduleProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_formulas_childResource" />
## labs_formulas_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**formulas**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[FormulaProperties object](#FormulaProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_customimages_childResource" />
## labs_customimages_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**customimages**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[CustomImageProperties object](#CustomImageProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |


<a id="labs_artifactsources_childResource" />
## labs_artifactsources_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**artifactsources**<br /> |
|  apiVersion | Yes | enum<br />**2015-05-21-preview**<br /> |
|  properties | Yes | object<br />[ArtifactSourceProperties object](#ArtifactSourceProperties)<br /><br />The properties of the resource. |
|  id | No | string<br /><br />The identifier of the resource. |
|  name | No | string<br /><br />The name of the resource. |
|  location | No | string<br /><br />The location of the resource. |
|  tags | No | object<br /><br />The tags of the resource. |

