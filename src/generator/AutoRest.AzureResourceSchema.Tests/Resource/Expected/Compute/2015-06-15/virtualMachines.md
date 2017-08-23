# Microsoft.Compute/virtualMachines template reference
API Version: 2015-06-15
## Template format

To create a Microsoft.Compute/virtualMachines resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Compute/virtualMachines",
  "apiVersion": "2015-06-15",
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
    "provisioningState": "string",
    "licenseType": "string"
  },
  "resources": []
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
|  apiVersion | enum | Yes | 2015-06-15 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  plan | object | No | Gets or sets the purchase plan when deploying virtual machine from VM Marketplace images. - [Plan object](#Plan) |
|  properties | object | Yes | [VirtualMachineProperties object](#VirtualMachineProperties) |
|  resources | array | No | [extensions](./virtualMachines/extensions.md) |


<a id="Plan" />
### Plan object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Gets or sets the plan ID. |
|  publisher | string | No | Gets or sets the publisher ID. |
|  product | string | No | Gets or sets the offer ID. |
|  promotionCode | string | No | Gets or sets the promotion code. |


<a id="VirtualMachineProperties" />
### VirtualMachineProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  hardwareProfile | object | No | Gets or sets the hardware profile. - [HardwareProfile object](#HardwareProfile) |
|  storageProfile | object | No | Gets or sets the storage profile. - [StorageProfile object](#StorageProfile) |
|  osProfile | object | No | Gets or sets the OS profile. - [OSProfile object](#OSProfile) |
|  networkProfile | object | No | Gets or sets the network profile. - [NetworkProfile object](#NetworkProfile) |
|  diagnosticsProfile | object | No | Gets or sets the diagnostics profile. - [DiagnosticsProfile object](#DiagnosticsProfile) |
|  availabilitySet | object | No | Gets or sets the reference Id of the availability set to which this virtual machine belongs. - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets the provisioning state, which only appears in the response. |
|  licenseType | string | No | Gets or sets the license type, which is for bring your own license scenario. |


<a id="HardwareProfile" />
### HardwareProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vmSize | enum | No | The virtual machine size name. - Basic_A0, Basic_A1, Basic_A2, Basic_A3, Basic_A4, Standard_A0, Standard_A1, Standard_A2, Standard_A3, Standard_A4, Standard_A5, Standard_A6, Standard_A7, Standard_A8, Standard_A9, Standard_A10, Standard_A11, Standard_D1, Standard_D2, Standard_D3, Standard_D4, Standard_D11, Standard_D12, Standard_D13, Standard_D14, Standard_D1_v2, Standard_D2_v2, Standard_D3_v2, Standard_D4_v2, Standard_D5_v2, Standard_D11_v2, Standard_D12_v2, Standard_D13_v2, Standard_D14_v2, Standard_DS1, Standard_DS2, Standard_DS3, Standard_DS4, Standard_DS11, Standard_DS12, Standard_DS13, Standard_DS14, Standard_G1, Standard_G2, Standard_G3, Standard_G4, Standard_G5, Standard_GS1, Standard_GS2, Standard_GS3, Standard_GS4, Standard_GS5 |


<a id="StorageProfile" />
### StorageProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  imageReference | object | No | Gets or sets the image reference. - [ImageReference object](#ImageReference) |
|  osDisk | object | No | Gets or sets the OS disk. - [OSDisk object](#OSDisk) |
|  dataDisks | array | No | Gets or sets the data disks. - [DataDisk object](#DataDisk) |


<a id="OSProfile" />
### OSProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  computerName | string | No | Gets or sets the computer name. |
|  adminUsername | string | No | Gets or sets the admin user name. |
|  adminPassword | string | No | Gets or sets the admin user password. |
|  customData | string | No | Gets or sets a base-64 encoded string of custom data. |
|  windowsConfiguration | object | No | Gets or sets the Windows Configuration of the OS profile. - [WindowsConfiguration object](#WindowsConfiguration) |
|  linuxConfiguration | object | No | Gets or sets the Linux Configuration of the OS profile. - [LinuxConfiguration object](#LinuxConfiguration) |
|  secrets | array | No | Gets or sets the List of certificates for addition to the VM. - [VaultSecretGroup object](#VaultSecretGroup) |


<a id="NetworkProfile" />
### NetworkProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  networkInterfaces | array | No | Gets or sets the network interfaces. - [NetworkInterfaceReference object](#NetworkInterfaceReference) |


<a id="DiagnosticsProfile" />
### DiagnosticsProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  bootDiagnostics | object | No | Gets or sets the boot diagnostics. - [BootDiagnostics object](#BootDiagnostics) |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="ImageReference" />
### ImageReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publisher | string | No | Gets or sets the image publisher. |
|  offer | string | No | Gets or sets the image offer. |
|  sku | string | No | Gets or sets the image sku. |
|  version | string | No | Gets or sets the image version. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor and Build being decimal numbers. Specify 'latest' to use the latest version of image. |


<a id="OSDisk" />
### OSDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  osType | enum | No | Gets or sets the Operating System type. - Windows or Linux |
|  encryptionSettings | object | No | Gets or sets the disk encryption settings. - [DiskEncryptionSettings object](#DiskEncryptionSettings) |
|  name | string | Yes | Gets or sets the disk name. |
|  vhd | object | Yes | Gets or sets the Virtual Hard Disk. - [VirtualHardDisk object](#VirtualHardDisk) |
|  image | object | No | Gets or sets the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine.If SourceImage is provided, the destination VirtualHardDisk should not exist. - [VirtualHardDisk object](#VirtualHardDisk) |
|  caching | enum | No | Gets or sets the caching type. - None, ReadOnly, ReadWrite |
|  createOption | enum | Yes | Gets or sets the create option. - fromImage, empty, attach |
|  diskSizeGB | integer | No | Gets or sets the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks. |


<a id="DataDisk" />
### DataDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  lun | integer | Yes | Gets or sets the logical unit number. |
|  name | string | Yes | Gets or sets the disk name. |
|  vhd | object | Yes | Gets or sets the Virtual Hard Disk. - [VirtualHardDisk object](#VirtualHardDisk) |
|  image | object | No | Gets or sets the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine.If SourceImage is provided, the destination VirtualHardDisk should not exist. - [VirtualHardDisk object](#VirtualHardDisk) |
|  caching | enum | No | Gets or sets the caching type. - None, ReadOnly, ReadWrite |
|  createOption | enum | Yes | Gets or sets the create option. - fromImage, empty, attach |
|  diskSizeGB | integer | No | Gets or sets the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks. |


<a id="WindowsConfiguration" />
### WindowsConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  provisionVMAgent | boolean | No | Gets or sets whether VM Agent should be provisioned on the Virtual Machine. |
|  enableAutomaticUpdates | boolean | No | Gets or sets whether Windows updates are automatically installed on the VM |
|  timeZone | string | No | Gets or sets the Time Zone of the VM |
|  additionalUnattendContent | array | No | Gets or sets the additional base-64 encoded XML formatted information that can be included in the Unattend.xml file. - [AdditionalUnattendContent object](#AdditionalUnattendContent) |
|  winRM | object | No | Gets or sets the Windows Remote Management configuration of the VM - [WinRMConfiguration object](#WinRMConfiguration) |


<a id="LinuxConfiguration" />
### LinuxConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  disablePasswordAuthentication | boolean | No | Gets or sets whether Authentication using user name and password is allowed or not |
|  ssh | object | No | Gets or sets the SSH configuration for linux VMs - [SshConfiguration object](#SshConfiguration) |


<a id="VaultSecretGroup" />
### VaultSecretGroup object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sourceVault | object | No | Gets or sets the Relative URL of the Key Vault containing all of the certificates in VaultCertificates. - [SubResource object](#SubResource) |
|  vaultCertificates | array | No | Gets or sets the list of key vault references in SourceVault which contain certificates - [VaultCertificate object](#VaultCertificate) |


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
|  enabled | boolean | No | Gets or sets whether boot diagnostics should be enabled on the Virtual Machine. |
|  storageUri | string | No | Gets or sets the boot diagnostics storage Uri. It should be a valid Uri |


<a id="DiskEncryptionSettings" />
### DiskEncryptionSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  diskEncryptionKey | object | Yes | Gets or sets the disk encryption key which is a KeyVault Secret. - [KeyVaultSecretReference object](#KeyVaultSecretReference) |
|  keyEncryptionKey | object | No | Gets or sets the key encryption key which is KeyVault Key. - [KeyVaultKeyReference object](#KeyVaultKeyReference) |
|  enabled | boolean | No | Gets or sets whether disk encryption should be enabled on the Virtual Machine. |


<a id="VirtualHardDisk" />
### VirtualHardDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  uri | string | No | Gets or sets the virtual hard disk's uri. It should be a valid Uri to a virtual hard disk. |


<a id="AdditionalUnattendContent" />
### AdditionalUnattendContent object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  passName | enum | No | Gets or sets the pass name. Currently, the only allowable value is oobeSystem. - oobeSystem |
|  componentName | enum | No | Gets or sets the component name. Currently, the only allowable value is Microsoft-Windows-Shell-Setup. - Microsoft-Windows-Shell-Setup |
|  settingName | enum | No | Gets or sets setting name (e.g. FirstLogonCommands, AutoLogon ). - AutoLogon or FirstLogonCommands |
|  content | string | No | Gets or sets XML formatted content that is added to the unattend.xml file in the specified pass and component.The XML must be less than 4 KB and must include the root element for the setting or feature that is being inserted. |


<a id="WinRMConfiguration" />
### WinRMConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  listeners | array | No | Gets or sets the list of Windows Remote Management listeners - [WinRMListener object](#WinRMListener) |


<a id="SshConfiguration" />
### SshConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publicKeys | array | No | Gets or sets the list of SSH public keys used to authenticate with linux based VMs - [SshPublicKey object](#SshPublicKey) |


<a id="VaultCertificate" />
### VaultCertificate object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  certificateUrl | string | No | Gets or sets the URL referencing a secret in a Key Vault which contains a properly formatted certificate. |
|  certificateStore | string | No | Gets or sets the Certificate store in LocalMachine to add the certificate to on Windows, leave empty on Linux. |


<a id="NetworkInterfaceReferenceProperties" />
### NetworkInterfaceReferenceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  primary | boolean | No | Gets or sets whether this is a primary NIC on a virtual machine |


<a id="KeyVaultSecretReference" />
### KeyVaultSecretReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  secretUrl | string | Yes | Gets or sets the URL referencing a secret in a Key Vault. |
|  sourceVault | object | Yes | Gets or sets the Relative URL of the Key Vault containing the secret. - [SubResource object](#SubResource) |


<a id="KeyVaultKeyReference" />
### KeyVaultKeyReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  keyUrl | string | Yes | Gets or sets the URL referencing a key in a Key Vault. |
|  sourceVault | object | Yes | Gets or sets the Relative URL of the Key Vault containing the key - [SubResource object](#SubResource) |


<a id="WinRMListener" />
### WinRMListener object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  protocol | enum | No | Gets or sets the Protocol used by WinRM listener. Currently only Http and Https are supported. - Http or Https |
|  certificateUrl | string | No | Gets or sets the Certificate URL in KMS for Https listeners. Should be null for Http listeners. |


<a id="SshPublicKey" />
### SshPublicKey object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  path | string | No | Gets or sets the full path on the created VM where SSH public key is stored. If the file already exists, the specified key is appended to the file. |
|  keyData | string | No | Gets or sets Certificate public key used to authenticate with VM through SSH.The certificate must be in Pem format with or without headers. |

