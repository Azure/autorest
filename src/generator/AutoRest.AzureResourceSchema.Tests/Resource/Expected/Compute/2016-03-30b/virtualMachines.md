# Microsoft.Compute/virtualMachines template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.Compute/virtualMachines resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Compute/virtualMachines",
  "apiVersion": "2016-03-30",
  "location": "string",
  "tags": {},
  "plan": {
    "name": "string",
    "publisher": "string",
    "product": "string",
    "promotionCode": "string"
  },
  "properties": {
    "hardwareProfile": {
      "vmSize": "string"
    },
    "storageProfile": {
      "imageReference": {
        "publisher": "string",
        "offer": "string",
        "sku": "string",
        "version": "string"
      },
      "osDisk": {
        "osType": "string",
        "encryptionSettings": {
          "diskEncryptionKey": {
            "secretUrl": "string",
            "sourceVault": {
              "id": "string"
            }
          },
          "keyEncryptionKey": {
            "keyUrl": "string",
            "sourceVault": {
              "id": "string"
            }
          },
          "enabled": boolean
        },
        "name": "string",
        "vhd": {
          "uri": "string"
        },
        "image": {
          "uri": "string"
        },
        "caching": "string",
        "createOption": "string",
        "diskSizeGB": "integer"
      },
      "dataDisks": [
        {
          "lun": "integer",
          "name": "string",
          "vhd": {
            "uri": "string"
          },
          "image": {
            "uri": "string"
          },
          "caching": "string",
          "createOption": "string",
          "diskSizeGB": "integer"
        }
      ]
    },
    "osProfile": {
      "computerName": "string",
      "adminUsername": "string",
      "adminPassword": "string",
      "customData": "string",
      "windowsConfiguration": {
        "provisionVMAgent": boolean,
        "enableAutomaticUpdates": boolean,
        "timeZone": "string",
        "additionalUnattendContent": [
          {
            "passName": "oobeSystem",
            "componentName": "Microsoft-Windows-Shell-Setup",
            "settingName": "string",
            "content": "string"
          }
        ],
        "winRM": {
          "listeners": [
            {
              "protocol": "string",
              "certificateUrl": "string"
            }
          ]
        }
      },
      "linuxConfiguration": {
        "disablePasswordAuthentication": boolean,
        "ssh": {
          "publicKeys": [
            {
              "path": "string",
              "keyData": "string"
            }
          ]
        }
      },
      "secrets": [
        {
          "sourceVault": {
            "id": "string"
          },
          "vaultCertificates": [
            {
              "certificateUrl": "string",
              "certificateStore": "string"
            }
          ]
        }
      ]
    },
    "networkProfile": {
      "networkInterfaces": [
        {
          "id": "string",
          "properties": {
            "primary": boolean
          }
        }
      ]
    },
    "diagnosticsProfile": {
      "bootDiagnostics": {
        "enabled": boolean,
        "storageUri": "string"
      }
    },
    "availabilitySet": {
      "id": "string"
    },
    "licenseType": "string"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Compute/virtualMachines" />
### Microsoft.Compute/virtualMachines object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Compute/virtualMachines |
|  apiVersion | enum | Yes | 2016-03-30 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  plan | object | No | the purchase plan when deploying virtual machine from VM Marketplace images. - [Plan object](#Plan) |
|  properties | object | Yes | [VirtualMachineProperties object](#VirtualMachineProperties) |
|  resources | array | No | [virtualMachines_extensions_childResource object](#virtualMachines_extensions_childResource) |


<a id="Plan" />
### Plan object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | the plan ID. |
|  publisher | string | No | the publisher ID. |
|  product | string | No | the offer ID. |
|  promotionCode | string | No | the promotion code. |


<a id="VirtualMachineProperties" />
### VirtualMachineProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  hardwareProfile | object | No | the hardware profile. - [HardwareProfile object](#HardwareProfile) |
|  storageProfile | object | No | the storage profile. - [StorageProfile object](#StorageProfile) |
|  osProfile | object | No | the OS profile. - [OSProfile object](#OSProfile) |
|  networkProfile | object | No | the network profile. - [NetworkProfile object](#NetworkProfile) |
|  diagnosticsProfile | object | No | the diagnostics profile. - [DiagnosticsProfile object](#DiagnosticsProfile) |
|  availabilitySet | object | No | the reference Id of the availability set to which this virtual machine belongs. - [SubResource object](#SubResource) |
|  licenseType | string | No | the license type, which is for bring your own license scenario. |


<a id="virtualMachines_extensions_childResource" />
### virtualMachines_extensions_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | extensions |
|  apiVersion | enum | Yes | 2016-03-30 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualMachineExtensionProperties object](#VirtualMachineExtensionProperties) |


<a id="HardwareProfile" />
### HardwareProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vmSize | enum | No | The virtual machine size name. - Basic_A0, Basic_A1, Basic_A2, Basic_A3, Basic_A4, Standard_A0, Standard_A1, Standard_A2, Standard_A3, Standard_A4, Standard_A5, Standard_A6, Standard_A7, Standard_A8, Standard_A9, Standard_A10, Standard_A11, Standard_D1, Standard_D2, Standard_D3, Standard_D4, Standard_D11, Standard_D12, Standard_D13, Standard_D14, Standard_D1_v2, Standard_D2_v2, Standard_D3_v2, Standard_D4_v2, Standard_D5_v2, Standard_D11_v2, Standard_D12_v2, Standard_D13_v2, Standard_D14_v2, Standard_D15_v2, Standard_DS1, Standard_DS2, Standard_DS3, Standard_DS4, Standard_DS11, Standard_DS12, Standard_DS13, Standard_DS14, Standard_DS1_v2, Standard_DS2_v2, Standard_DS3_v2, Standard_DS4_v2, Standard_DS5_v2, Standard_DS11_v2, Standard_DS12_v2, Standard_DS13_v2, Standard_DS14_v2, Standard_DS15_v2, Standard_G1, Standard_G2, Standard_G3, Standard_G4, Standard_G5, Standard_GS1, Standard_GS2, Standard_GS3, Standard_GS4, Standard_GS5 |


<a id="StorageProfile" />
### StorageProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  imageReference | object | No | the image reference. - [ImageReference object](#ImageReference) |
|  osDisk | object | No | the OS disk. - [OSDisk object](#OSDisk) |
|  dataDisks | array | No | the data disks. - [DataDisk object](#DataDisk) |


<a id="OSProfile" />
### OSProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  computerName | string | No | the computer name. |
|  adminUsername | string | No | the admin user name. |
|  adminPassword | string | No | the admin user password. |
|  customData | string | No | a base-64 encoded string of custom data. |
|  windowsConfiguration | object | No | the Windows Configuration of the OS profile. - [WindowsConfiguration object](#WindowsConfiguration) |
|  linuxConfiguration | object | No | the Linux Configuration of the OS profile. - [LinuxConfiguration object](#LinuxConfiguration) |
|  secrets | array | No | the List of certificates for addition to the VM. - [VaultSecretGroup object](#VaultSecretGroup) |


<a id="NetworkProfile" />
### NetworkProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  networkInterfaces | array | No | the network interfaces. - [NetworkInterfaceReference object](#NetworkInterfaceReference) |


<a id="DiagnosticsProfile" />
### DiagnosticsProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  bootDiagnostics | object | No | the boot diagnostics. - [BootDiagnostics object](#BootDiagnostics) |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="VirtualMachineExtensionProperties" />
### VirtualMachineExtensionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  extensionType | enum | No | Generic, IaasDiagnostics, IaasAntimalware, CustomScript |


<a id="ImageReference" />
### ImageReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publisher | string | No | the image publisher. |
|  offer | string | No | the image offer. |
|  sku | string | No | the image sku. |
|  version | string | No | the image version. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor and Build being decimal numbers. Specify 'latest' to use the latest version of image. |


<a id="OSDisk" />
### OSDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  osType | enum | No | the Operating System type. - Windows or Linux |
|  encryptionSettings | object | No | the disk encryption settings. - [DiskEncryptionSettings object](#DiskEncryptionSettings) |
|  name | string | Yes | the disk name. |
|  vhd | object | Yes | the Virtual Hard Disk. - [VirtualHardDisk object](#VirtualHardDisk) |
|  image | object | No | the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine. If SourceImage is provided, the destination VirtualHardDisk should not exist. - [VirtualHardDisk object](#VirtualHardDisk) |
|  caching | enum | No | the caching type. - None, ReadOnly, ReadWrite |
|  createOption | enum | Yes | the create option. - fromImage, empty, attach |
|  diskSizeGB | integer | No | the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks. |


<a id="DataDisk" />
### DataDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  lun | integer | Yes | the logical unit number. |
|  name | string | Yes | the disk name. |
|  vhd | object | Yes | the Virtual Hard Disk. - [VirtualHardDisk object](#VirtualHardDisk) |
|  image | object | No | the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine. If SourceImage is provided, the destination VirtualHardDisk should not exist. - [VirtualHardDisk object](#VirtualHardDisk) |
|  caching | enum | No | the caching type. - None, ReadOnly, ReadWrite |
|  createOption | enum | Yes | the create option. - fromImage, empty, attach |
|  diskSizeGB | integer | No | the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks. |


<a id="WindowsConfiguration" />
### WindowsConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  provisionVMAgent | boolean | No | whether VM Agent should be provisioned on the Virtual Machine. |
|  enableAutomaticUpdates | boolean | No | whether Windows updates are automatically installed on the VM |
|  timeZone | string | No | the Time Zone of the VM |
|  additionalUnattendContent | array | No | the additional base-64 encoded XML formatted information that can be included in the Unattend.xml file. - [AdditionalUnattendContent object](#AdditionalUnattendContent) |
|  winRM | object | No | the Windows Remote Management configuration of the VM - [WinRMConfiguration object](#WinRMConfiguration) |


<a id="LinuxConfiguration" />
### LinuxConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  disablePasswordAuthentication | boolean | No | whether Authentication using user name and password is allowed or not |
|  ssh | object | No | the SSH configuration for linux VMs - [SshConfiguration object](#SshConfiguration) |


<a id="VaultSecretGroup" />
### VaultSecretGroup object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sourceVault | object | No | the Relative URL of the Key Vault containing all of the certificates in VaultCertificates. - [SubResource object](#SubResource) |
|  vaultCertificates | array | No | the list of key vault references in SourceVault which contain certificates - [VaultCertificate object](#VaultCertificate) |


<a id="NetworkInterfaceReference" />
### NetworkInterfaceReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [NetworkInterfaceReferenceProperties object](#NetworkInterfaceReferenceProperties) |


<a id="BootDiagnostics" />
### BootDiagnostics object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  enabled | boolean | No | whether boot diagnostics should be enabled on the Virtual Machine. |
|  storageUri | string | No | the boot diagnostics storage Uri. It should be a valid Uri |


<a id="DiskEncryptionSettings" />
### DiskEncryptionSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  diskEncryptionKey | object | No | the disk encryption key which is a KeyVault Secret. - [KeyVaultSecretReference object](#KeyVaultSecretReference) |
|  keyEncryptionKey | object | No | the key encryption key which is KeyVault Key. - [KeyVaultKeyReference object](#KeyVaultKeyReference) |
|  enabled | boolean | No | whether disk encryption should be enabled on the Virtual Machine. |


<a id="VirtualHardDisk" />
### VirtualHardDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  uri | string | No | the virtual hard disk's uri. It should be a valid Uri to a virtual hard disk. |


<a id="AdditionalUnattendContent" />
### AdditionalUnattendContent object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  passName | enum | No | the pass name. Currently, the only allowable value is oobeSystem. - oobeSystem |
|  componentName | enum | No | the component name. Currently, the only allowable value is Microsoft-Windows-Shell-Setup. - Microsoft-Windows-Shell-Setup |
|  settingName | enum | No | setting name (e.g. FirstLogonCommands, AutoLogon ). - AutoLogon or FirstLogonCommands |
|  content | string | No | XML formatted content that is added to the unattend.xml file in the specified pass and component. The XML must be less than 4 KB and must include the root element for the setting or feature that is being inserted. |


<a id="WinRMConfiguration" />
### WinRMConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  listeners | array | No | the list of Windows Remote Management listeners - [WinRMListener object](#WinRMListener) |


<a id="SshConfiguration" />
### SshConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publicKeys | array | No | the list of SSH public keys used to authenticate with linux based VMs - [SshPublicKey object](#SshPublicKey) |


<a id="VaultCertificate" />
### VaultCertificate object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  certificateUrl | string | No | the URL referencing a secret in a Key Vault which contains a properly formatted certificate. |
|  certificateStore | string | No | the Certificate store in LocalMachine to add the certificate to on Windows, leave empty on Linux. |


<a id="NetworkInterfaceReferenceProperties" />
### NetworkInterfaceReferenceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  primary | boolean | No | whether this is a primary NIC on a virtual machine |


<a id="KeyVaultSecretReference" />
### KeyVaultSecretReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  secretUrl | string | Yes | the URL referencing a secret in a Key Vault. |
|  sourceVault | object | Yes | the Relative URL of the Key Vault containing the secret. - [SubResource object](#SubResource) |


<a id="KeyVaultKeyReference" />
### KeyVaultKeyReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  keyUrl | string | Yes | the URL referencing a key in a Key Vault. |
|  sourceVault | object | Yes | the Relative URL of the Key Vault containing the key - [SubResource object](#SubResource) |


<a id="WinRMListener" />
### WinRMListener object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  protocol | enum | No | the Protocol used by WinRM listener. Currently only Http and Https are supported. - Http or Https |
|  certificateUrl | string | No | the Certificate URL in KMS for Https listeners. Should be null for Http listeners. |


<a id="SshPublicKey" />
### SshPublicKey object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  path | string | No | the full path on the created VM where SSH public key is stored. If the file already exists, the specified key is appended to the file. |
|  keyData | string | No | Certificate public key used to authenticate with VM through SSH. The certificate must be in Pem format with or without headers. |

