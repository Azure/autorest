# Microsoft.Compute template schema

Creates a Microsoft.Compute resource.

## Schema format

To create a Microsoft.Compute, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Compute/availabilitySets",
  "apiVersion": "2016-03-30",
  "location": "string",
  "properties": {
    "platformUpdateDomainCount": "integer",
    "platformFaultDomainCount": "integer",
    "virtualMachines": [
      {
        "id": "string"
      }
    ],
    "statuses": [
      {
        "code": "string",
        "level": "string",
        "displayStatus": "string",
        "message": "string",
        "time": "string"
      }
    ]
  }
}
```
```
{
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "apiVersion": "2016-03-30",
  "location": "string",
  "properties": {
    "forceUpdateTag": "string",
    "publisher": "string",
    "type": "string",
    "typeHandlerVersion": "string",
    "autoUpgradeMinorVersion": "boolean",
    "settings": {},
    "protectedSettings": {},
    "instanceView": {
      "name": "string",
      "type": "string",
      "typeHandlerVersion": "string",
      "substatuses": [
        {
          "code": "string",
          "level": "string",
          "displayStatus": "string",
          "message": "string",
          "time": "string"
        }
      ],
      "statuses": [
        {
          "code": "string",
          "level": "string",
          "displayStatus": "string",
          "message": "string",
          "time": "string"
        }
      ]
    }
  }
}
```
```
{
  "type": "Microsoft.Compute/virtualMachines",
  "apiVersion": "2016-03-30",
  "location": "string",
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
          "enabled": "boolean"
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
        "provisionVMAgent": "boolean",
        "enableAutomaticUpdates": "boolean",
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
        "disablePasswordAuthentication": "boolean",
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
            "primary": "boolean"
          }
        }
      ]
    },
    "diagnosticsProfile": {
      "bootDiagnostics": {
        "enabled": "boolean",
        "storageUri": "string"
      }
    },
    "availabilitySet": {
      "id": "string"
    },
    "licenseType": "string"
  }
}
```
```
{
  "type": "Microsoft.Compute/virtualMachineScaleSets",
  "apiVersion": "2016-03-30",
  "location": "string",
  "properties": {
    "upgradePolicy": {
      "mode": "string"
    },
    "virtualMachineProfile": {
      "osProfile": {
        "computerNamePrefix": "string",
        "adminUsername": "string",
        "adminPassword": "string",
        "customData": "string",
        "windowsConfiguration": {
          "provisionVMAgent": "boolean",
          "enableAutomaticUpdates": "boolean",
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
          "disablePasswordAuthentication": "boolean",
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
      "storageProfile": {
        "imageReference": {
          "publisher": "string",
          "offer": "string",
          "sku": "string",
          "version": "string"
        },
        "osDisk": {
          "name": "string",
          "caching": "string",
          "createOption": "string",
          "osType": "string",
          "image": {
            "uri": "string"
          },
          "vhdContainers": [
            "string"
          ]
        }
      },
      "networkProfile": {
        "networkInterfaceConfigurations": [
          {
            "id": "string",
            "name": "string",
            "properties": {
              "primary": "boolean",
              "ipConfigurations": [
                {
                  "id": "string",
                  "name": "string",
                  "properties": {
                    "subnet": {
                      "id": "string"
                    },
                    "applicationGatewayBackendAddressPools": [
                      {
                        "id": "string"
                      }
                    ],
                    "loadBalancerBackendAddressPools": [
                      {
                        "id": "string"
                      }
                    ],
                    "loadBalancerInboundNatPools": [
                      {
                        "id": "string"
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      },
      "extensionProfile": {
        "extensions": [
          {
            "id": "string",
            "name": "string",
            "properties": {
              "publisher": "string",
              "type": "string",
              "typeHandlerVersion": "string",
              "autoUpgradeMinorVersion": "boolean",
              "settings": {},
              "protectedSettings": {}
            }
          }
        ]
      }
    },
    "overProvision": "boolean"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="availabilitySets" />
## availabilitySets object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Compute/availabilitySets**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-30**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[AvailabilitySetProperties object](#AvailabilitySetProperties)<br /> |


<a id="virtualMachines_extensions" />
## virtualMachines_extensions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Compute/virtualMachines/extensions**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-30**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VirtualMachineExtensionProperties object](#VirtualMachineExtensionProperties)<br /> |


<a id="virtualMachines" />
## virtualMachines object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Compute/virtualMachines**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-30**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  plan | No | object<br />[Plan object](#Plan)<br /><br />the purchase plan when deploying virtual machine from VM Marketplace images. |
|  properties | Yes | object<br />[VirtualMachineProperties object](#VirtualMachineProperties)<br /> |
|  resources | No | array<br />[extensions object](#extensions)<br /> |


<a id="virtualMachineScaleSets" />
## virtualMachineScaleSets object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Compute/virtualMachineScaleSets**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-30**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />the virtual machine scale set sku. |
|  properties | Yes | object<br />[VirtualMachineScaleSetProperties object](#VirtualMachineScaleSetProperties)<br /> |


<a id="AvailabilitySetProperties" />
## AvailabilitySetProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  platformUpdateDomainCount | No | integer<br /><br />Update Domain count. |
|  platformFaultDomainCount | No | integer<br /><br />Fault Domain count. |
|  virtualMachines | No | array<br />[SubResource object](#SubResource)<br /><br />a list containing reference to all Virtual Machines created under this Availability Set. |
|  statuses | No | array<br />[InstanceViewStatus object](#InstanceViewStatus)<br /><br />the resource status information. |


<a id="SubResource" />
## SubResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |


<a id="InstanceViewStatus" />
## InstanceViewStatus object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  code | No | string<br /><br />the status Code. |
|  level | No | enum<br />**Info**, **Warning**, **Error**<br /><br />the level Code. |
|  displayStatus | No | string<br /><br />the short localizable label for the status. |
|  message | No | string<br /><br />the detailed Message, including for alerts and error messages. |
|  time | No | string<br /><br />the time of the status. |


<a id="VirtualMachineExtensionProperties" />
## VirtualMachineExtensionProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  forceUpdateTag | No | string<br /><br />how the extension handler should be forced to update even if the extension configuration has not changed. |
|  publisher | No | string<br /><br />the name of the extension handler publisher. |
|  type | No | string<br /><br />the type of the extension handler. |
|  typeHandlerVersion | No | string<br /><br />the type version of the extension handler. |
|  autoUpgradeMinorVersion | No | boolean<br /><br />whether the extension handler should be automatically upgraded across minor versions. |
|  settings | No | object<br /><br />Json formatted public settings for the extension. |
|  protectedSettings | No | object<br /><br />Json formatted protected settings for the extension. |
|  instanceView | No | object<br />[VirtualMachineExtensionInstanceView object](#VirtualMachineExtensionInstanceView)<br /><br />the virtual machine extension instance view. |


<a id="VirtualMachineExtensionInstanceView" />
## VirtualMachineExtensionInstanceView object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />the virtual machine extension name. |
|  type | No | string<br /><br />the full type of the extension handler which includes both publisher and type. |
|  typeHandlerVersion | No | string<br /><br />the type version of the extension handler. |
|  substatuses | No | array<br />[InstanceViewStatus object](#InstanceViewStatus)<br /><br />the resource status information. |
|  statuses | No | array<br />[InstanceViewStatus object](#InstanceViewStatus)<br /><br />the resource status information. |


<a id="Plan" />
## Plan object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />the plan ID. |
|  publisher | No | string<br /><br />the publisher ID. |
|  product | No | string<br /><br />the offer ID. |
|  promotionCode | No | string<br /><br />the promotion code. |


<a id="VirtualMachineProperties" />
## VirtualMachineProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  hardwareProfile | No | object<br />[HardwareProfile object](#HardwareProfile)<br /><br />the hardware profile. |
|  storageProfile | No | object<br />[StorageProfile object](#StorageProfile)<br /><br />the storage profile. |
|  osProfile | No | object<br />[OSProfile object](#OSProfile)<br /><br />the OS profile. |
|  networkProfile | No | object<br />[NetworkProfile object](#NetworkProfile)<br /><br />the network profile. |
|  diagnosticsProfile | No | object<br />[DiagnosticsProfile object](#DiagnosticsProfile)<br /><br />the diagnostics profile. |
|  availabilitySet | No | object<br />[SubResource object](#SubResource)<br /><br />the reference Id of the availability set to which this virtual machine belongs. |
|  licenseType | No | string<br /><br />the license type, which is for bring your own license scenario. |


<a id="HardwareProfile" />
## HardwareProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  vmSize | No | enum<br />**Basic_A0**, **Basic_A1**, **Basic_A2**, **Basic_A3**, **Basic_A4**, **Standard_A0**, **Standard_A1**, **Standard_A2**, **Standard_A3**, **Standard_A4**, **Standard_A5**, **Standard_A6**, **Standard_A7**, **Standard_A8**, **Standard_A9**, **Standard_A10**, **Standard_A11**, **Standard_D1**, **Standard_D2**, **Standard_D3**, **Standard_D4**, **Standard_D11**, **Standard_D12**, **Standard_D13**, **Standard_D14**, **Standard_D1_v2**, **Standard_D2_v2**, **Standard_D3_v2**, **Standard_D4_v2**, **Standard_D5_v2**, **Standard_D11_v2**, **Standard_D12_v2**, **Standard_D13_v2**, **Standard_D14_v2**, **Standard_D15_v2**, **Standard_DS1**, **Standard_DS2**, **Standard_DS3**, **Standard_DS4**, **Standard_DS11**, **Standard_DS12**, **Standard_DS13**, **Standard_DS14**, **Standard_DS1_v2**, **Standard_DS2_v2**, **Standard_DS3_v2**, **Standard_DS4_v2**, **Standard_DS5_v2**, **Standard_DS11_v2**, **Standard_DS12_v2**, **Standard_DS13_v2**, **Standard_DS14_v2**, **Standard_DS15_v2**, **Standard_G1**, **Standard_G2**, **Standard_G3**, **Standard_G4**, **Standard_G5**, **Standard_GS1**, **Standard_GS2**, **Standard_GS3**, **Standard_GS4**, **Standard_GS5**<br /><br />The virtual machine size name. |


<a id="StorageProfile" />
## StorageProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  imageReference | No | object<br />[ImageReference object](#ImageReference)<br /><br />the image reference. |
|  osDisk | No | object<br />[OSDisk object](#OSDisk)<br /><br />the OS disk. |
|  dataDisks | No | array<br />[DataDisk object](#DataDisk)<br /><br />the data disks. |


<a id="ImageReference" />
## ImageReference object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publisher | No | string<br /><br />the image publisher. |
|  offer | No | string<br /><br />the image offer. |
|  sku | No | string<br /><br />the image sku. |
|  version | No | string<br /><br />the image version. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor and Build being decimal numbers. Specify 'latest' to use the latest version of image. |


<a id="OSDisk" />
## OSDisk object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  osType | No | enum<br />**Windows** or **Linux**<br /><br />the Operating System type. |
|  encryptionSettings | No | object<br />[DiskEncryptionSettings object](#DiskEncryptionSettings)<br /><br />the disk encryption settings. |
|  name | Yes | string<br /><br />the disk name. |
|  vhd | Yes | object<br />[VirtualHardDisk object](#VirtualHardDisk)<br /><br />the Virtual Hard Disk. |
|  image | No | object<br />[VirtualHardDisk object](#VirtualHardDisk)<br /><br />the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine.If SourceImage is provided, the destination VirtualHardDisk should not exist. |
|  caching | No | enum<br />**None**, **ReadOnly**, **ReadWrite**<br /><br />the caching type. |
|  createOption | Yes | enum<br />**fromImage**, **empty**, **attach**<br /><br />the create option. |
|  diskSizeGB | No | integer<br /><br />the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks. |


<a id="DiskEncryptionSettings" />
## DiskEncryptionSettings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  diskEncryptionKey | No | object<br />[KeyVaultSecretReference object](#KeyVaultSecretReference)<br /><br />the disk encryption key which is a KeyVault Secret. |
|  keyEncryptionKey | No | object<br />[KeyVaultKeyReference object](#KeyVaultKeyReference)<br /><br />the key encryption key which is KeyVault Key. |
|  enabled | No | boolean<br /><br />whether disk encryption should be enabled on the Virtual Machine. |


<a id="KeyVaultSecretReference" />
## KeyVaultSecretReference object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  secretUrl | Yes | string<br /><br />the URL referencing a secret in a Key Vault. |
|  sourceVault | Yes | object<br />[SubResource object](#SubResource)<br /><br />the Relative URL of the Key Vault containing the secret. |


<a id="KeyVaultKeyReference" />
## KeyVaultKeyReference object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  keyUrl | Yes | string<br /><br />the URL referencing a key in a Key Vault. |
|  sourceVault | Yes | object<br />[SubResource object](#SubResource)<br /><br />the Relative URL of the Key Vault containing the key |


<a id="VirtualHardDisk" />
## VirtualHardDisk object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  uri | No | string<br /><br />the virtual hard disk's uri. It should be a valid Uri to a virtual hard disk. |


<a id="DataDisk" />
## DataDisk object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  lun | Yes | integer<br /><br />the logical unit number. |
|  name | Yes | string<br /><br />the disk name. |
|  vhd | Yes | object<br />[VirtualHardDisk object](#VirtualHardDisk)<br /><br />the Virtual Hard Disk. |
|  image | No | object<br />[VirtualHardDisk object](#VirtualHardDisk)<br /><br />the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine.If SourceImage is provided, the destination VirtualHardDisk should not exist. |
|  caching | No | enum<br />**None**, **ReadOnly**, **ReadWrite**<br /><br />the caching type. |
|  createOption | Yes | enum<br />**fromImage**, **empty**, **attach**<br /><br />the create option. |
|  diskSizeGB | No | integer<br /><br />the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks. |


<a id="OSProfile" />
## OSProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  computerName | No | string<br /><br />the computer name. |
|  adminUsername | No | string<br /><br />the admin user name. |
|  adminPassword | No | string<br /><br />the admin user password. |
|  customData | No | string<br /><br />a base-64 encoded string of custom data. |
|  windowsConfiguration | No | object<br />[WindowsConfiguration object](#WindowsConfiguration)<br /><br />the Windows Configuration of the OS profile. |
|  linuxConfiguration | No | object<br />[LinuxConfiguration object](#LinuxConfiguration)<br /><br />the Linux Configuration of the OS profile. |
|  secrets | No | array<br />[VaultSecretGroup object](#VaultSecretGroup)<br /><br />the List of certificates for addition to the VM. |


<a id="WindowsConfiguration" />
## WindowsConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  provisionVMAgent | No | boolean<br /><br />whether VM Agent should be provisioned on the Virtual Machine. |
|  enableAutomaticUpdates | No | boolean<br /><br />whether Windows updates are automatically installed on the VM |
|  timeZone | No | string<br /><br />the Time Zone of the VM |
|  additionalUnattendContent | No | array<br />[AdditionalUnattendContent object](#AdditionalUnattendContent)<br /><br />the additional base-64 encoded XML formatted information that can be included in the Unattend.xml file. |
|  winRM | No | object<br />[WinRMConfiguration object](#WinRMConfiguration)<br /><br />the Windows Remote Management configuration of the VM |


<a id="AdditionalUnattendContent" />
## AdditionalUnattendContent object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  passName | No | enum<br />**oobeSystem**<br /><br />the pass name. Currently, the only allowable value is oobeSystem. |
|  componentName | No | enum<br />**Microsoft-Windows-Shell-Setup**<br /><br />the component name. Currently, the only allowable value is Microsoft-Windows-Shell-Setup. |
|  settingName | No | enum<br />**AutoLogon** or **FirstLogonCommands**<br /><br />setting name (e.g. FirstLogonCommands, AutoLogon ). |
|  content | No | string<br /><br />XML formatted content that is added to the unattend.xml file in the specified pass and component.The XML must be less than 4 KB and must include the root element for the setting or feature that is being inserted. |


<a id="WinRMConfiguration" />
## WinRMConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  listeners | No | array<br />[WinRMListener object](#WinRMListener)<br /><br />the list of Windows Remote Management listeners |


<a id="WinRMListener" />
## WinRMListener object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  protocol | No | enum<br />**Http** or **Https**<br /><br />the Protocol used by WinRM listener. Currently only Http and Https are supported. |
|  certificateUrl | No | string<br /><br />the Certificate URL in KMS for Https listeners. Should be null for Http listeners. |


<a id="LinuxConfiguration" />
## LinuxConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  disablePasswordAuthentication | No | boolean<br /><br />whether Authentication using user name and password is allowed or not |
|  ssh | No | object<br />[SshConfiguration object](#SshConfiguration)<br /><br />the SSH configuration for linux VMs |


<a id="SshConfiguration" />
## SshConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publicKeys | No | array<br />[SshPublicKey object](#SshPublicKey)<br /><br />the list of SSH public keys used to authenticate with linux based VMs |


<a id="SshPublicKey" />
## SshPublicKey object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  path | No | string<br /><br />the full path on the created VM where SSH public key is stored. If the file already exists, the specified key is appended to the file. |
|  keyData | No | string<br /><br />Certificate public key used to authenticate with VM through SSH.The certificate must be in Pem format with or without headers. |


<a id="VaultSecretGroup" />
## VaultSecretGroup object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sourceVault | No | object<br />[SubResource object](#SubResource)<br /><br />the Relative URL of the Key Vault containing all of the certificates in VaultCertificates. |
|  vaultCertificates | No | array<br />[VaultCertificate object](#VaultCertificate)<br /><br />the list of key vault references in SourceVault which contain certificates |


<a id="VaultCertificate" />
## VaultCertificate object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  certificateUrl | No | string<br /><br />the URL referencing a secret in a Key Vault which contains a properly formatted certificate. |
|  certificateStore | No | string<br /><br />the Certificate store in LocalMachine to add the certificate to on Windows, leave empty on Linux. |


<a id="NetworkProfile" />
## NetworkProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  networkInterfaces | No | array<br />[NetworkInterfaceReference object](#NetworkInterfaceReference)<br /><br />the network interfaces. |


<a id="NetworkInterfaceReference" />
## NetworkInterfaceReference object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[NetworkInterfaceReferenceProperties object](#NetworkInterfaceReferenceProperties)<br /> |


<a id="NetworkInterfaceReferenceProperties" />
## NetworkInterfaceReferenceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  primary | No | boolean<br /><br />whether this is a primary NIC on a virtual machine |


<a id="DiagnosticsProfile" />
## DiagnosticsProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  bootDiagnostics | No | object<br />[BootDiagnostics object](#BootDiagnostics)<br /><br />the boot diagnostics. |


<a id="BootDiagnostics" />
## BootDiagnostics object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  enabled | No | boolean<br /><br />whether boot diagnostics should be enabled on the Virtual Machine. |
|  storageUri | No | string<br /><br />the boot diagnostics storage Uri. It should be a valid Uri |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />the sku name. |
|  tier | No | string<br /><br />the sku tier. |
|  capacity | No | integer<br /><br />the sku capacity. |


<a id="VirtualMachineScaleSetProperties" />
## VirtualMachineScaleSetProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  upgradePolicy | No | object<br />[UpgradePolicy object](#UpgradePolicy)<br /><br />the upgrade policy. |
|  virtualMachineProfile | No | object<br />[VirtualMachineScaleSetVMProfile object](#VirtualMachineScaleSetVMProfile)<br /><br />the virtual machine profile. |
|  overProvision | No | boolean<br /><br />Specifies whether the Virtual Machine Scale Set should be overprovisioned. |


<a id="UpgradePolicy" />
## UpgradePolicy object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  mode | No | enum<br />**Automatic** or **Manual**<br /><br />the upgrade mode. |


<a id="VirtualMachineScaleSetVMProfile" />
## VirtualMachineScaleSetVMProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  osProfile | No | object<br />[VirtualMachineScaleSetOSProfile object](#VirtualMachineScaleSetOSProfile)<br /><br />the virtual machine scale set OS profile. |
|  storageProfile | No | object<br />[VirtualMachineScaleSetStorageProfile object](#VirtualMachineScaleSetStorageProfile)<br /><br />the virtual machine scale set storage profile. |
|  networkProfile | No | object<br />[VirtualMachineScaleSetNetworkProfile object](#VirtualMachineScaleSetNetworkProfile)<br /><br />the virtual machine scale set network profile. |
|  extensionProfile | No | object<br />[VirtualMachineScaleSetExtensionProfile object](#VirtualMachineScaleSetExtensionProfile)<br /><br />the virtual machine scale set extension profile. |


<a id="VirtualMachineScaleSetOSProfile" />
## VirtualMachineScaleSetOSProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  computerNamePrefix | No | string<br /><br />the computer name prefix. |
|  adminUsername | No | string<br /><br />the admin user name. |
|  adminPassword | No | string<br /><br />the admin user password. |
|  customData | No | string<br /><br />a base-64 encoded string of custom data. |
|  windowsConfiguration | No | object<br />[WindowsConfiguration object](#WindowsConfiguration)<br /><br />the Windows Configuration of the OS profile. |
|  linuxConfiguration | No | object<br />[LinuxConfiguration object](#LinuxConfiguration)<br /><br />the Linux Configuration of the OS profile. |
|  secrets | No | array<br />[VaultSecretGroup object](#VaultSecretGroup)<br /><br />the List of certificates for addition to the VM. |


<a id="VirtualMachineScaleSetStorageProfile" />
## VirtualMachineScaleSetStorageProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  imageReference | No | object<br />[ImageReference object](#ImageReference)<br /><br />the image reference. |
|  osDisk | No | object<br />[VirtualMachineScaleSetOSDisk object](#VirtualMachineScaleSetOSDisk)<br /><br />the OS disk. |


<a id="VirtualMachineScaleSetOSDisk" />
## VirtualMachineScaleSetOSDisk object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />the disk name. |
|  caching | No | enum<br />**None**, **ReadOnly**, **ReadWrite**<br /><br />the caching type. |
|  createOption | Yes | enum<br />**fromImage**, **empty**, **attach**<br /><br />the create option. |
|  osType | No | enum<br />**Windows** or **Linux**<br /><br />the Operating System type. |
|  image | No | object<br />[VirtualHardDisk object](#VirtualHardDisk)<br /><br />the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine.If SourceImage is provided, the destination VirtualHardDisk should not exist. |
|  vhdContainers | No | array<br />**string**<br /><br />the list of virtual hard disk container uris. |


<a id="VirtualMachineScaleSetNetworkProfile" />
## VirtualMachineScaleSetNetworkProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  networkInterfaceConfigurations | No | array<br />[VirtualMachineScaleSetNetworkConfiguration object](#VirtualMachineScaleSetNetworkConfiguration)<br /><br />the list of network configurations. |


<a id="VirtualMachineScaleSetNetworkConfiguration" />
## VirtualMachineScaleSetNetworkConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | Yes | string<br /><br />the network configuration name. |
|  properties | No | object<br />[VirtualMachineScaleSetNetworkConfigurationProperties object](#VirtualMachineScaleSetNetworkConfigurationProperties)<br /> |


<a id="VirtualMachineScaleSetNetworkConfigurationProperties" />
## VirtualMachineScaleSetNetworkConfigurationProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  primary | No | boolean<br /><br />whether this is a primary NIC on a virtual machine. |
|  ipConfigurations | Yes | array<br />[VirtualMachineScaleSetIPConfiguration object](#VirtualMachineScaleSetIPConfiguration)<br /><br />the virtual machine scale set IP Configuration. |


<a id="VirtualMachineScaleSetIPConfiguration" />
## VirtualMachineScaleSetIPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | Yes | string<br /><br />the IP configuration name. |
|  properties | No | object<br />[VirtualMachineScaleSetIPConfigurationProperties object](#VirtualMachineScaleSetIPConfigurationProperties)<br /> |


<a id="VirtualMachineScaleSetIPConfigurationProperties" />
## VirtualMachineScaleSetIPConfigurationProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  subnet | Yes | object<br />[ApiEntityReference object](#ApiEntityReference)<br /><br />the subnet. |
|  applicationGatewayBackendAddressPools | No | array<br />[SubResource object](#SubResource)<br /><br />the application gateway backend address pools. |
|  loadBalancerBackendAddressPools | No | array<br />[SubResource object](#SubResource)<br /><br />the load balancer backend address pools. |
|  loadBalancerInboundNatPools | No | array<br />[SubResource object](#SubResource)<br /><br />the load balancer inbound nat pools. |


<a id="ApiEntityReference" />
## ApiEntityReference object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />the ARM resource id in the form of /subscriptions/{SubcriptionId}/resourceGroups/{ResourceGroupName}/... |


<a id="VirtualMachineScaleSetExtensionProfile" />
## VirtualMachineScaleSetExtensionProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  extensions | No | array<br />[VirtualMachineScaleSetExtension object](#VirtualMachineScaleSetExtension)<br /><br />the virtual machine scale set child extension resources. |


<a id="VirtualMachineScaleSetExtension" />
## VirtualMachineScaleSetExtension object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />the name of the extension. |
|  properties | No | object<br />[VirtualMachineScaleSetExtensionProperties object](#VirtualMachineScaleSetExtensionProperties)<br /> |


<a id="VirtualMachineScaleSetExtensionProperties" />
## VirtualMachineScaleSetExtensionProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publisher | No | string<br /><br />the name of the extension handler publisher. |
|  type | No | string<br /><br />the type of the extension handler. |
|  typeHandlerVersion | No | string<br /><br />the type version of the extension handler. |
|  autoUpgradeMinorVersion | No | boolean<br /><br />whether the extension handler should be automatically upgraded across minor versions. |
|  settings | No | object<br /><br />Json formatted public settings for the extension. |
|  protectedSettings | No | object<br /><br />Json formatted protected settings for the extension. |


<a id="virtualMachines_extensions_childResource" />
## virtualMachines_extensions_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**extensions**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-30**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VirtualMachineExtensionProperties object](#VirtualMachineExtensionProperties)<br /> |

