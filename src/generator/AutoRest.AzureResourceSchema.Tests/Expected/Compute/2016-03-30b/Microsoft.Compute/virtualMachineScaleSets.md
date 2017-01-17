# Microsoft.Compute/virtualMachineScaleSets template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.Compute/virtualMachineScaleSets resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Compute/virtualMachineScaleSets",
  "apiVersion": "2016-03-30",
  "location": "string",
  "tags": {},
  "sku": {
    "name": "string",
    "tier": "string",
    "capacity": "integer"
  },
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
              "primary": boolean,
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
              "autoUpgradeMinorVersion": boolean,
              "settings": {},
              "protectedSettings": {}
            }
          }
        ]
      }
    },
    "overprovision": boolean
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Compute/virtualMachineScaleSets" />
### Microsoft.Compute/virtualMachineScaleSets object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Compute/virtualMachineScaleSets |
|  apiVersion | enum | Yes | 2016-03-30 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  sku | object | No | the virtual machine scale set sku. - [Sku object](#Sku) |
|  properties | object | Yes | [VirtualMachineScaleSetProperties object](#VirtualMachineScaleSetProperties) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | the sku name. |
|  tier | string | No | the sku tier. |
|  capacity | integer | No | the sku capacity. |


<a id="VirtualMachineScaleSetProperties" />
### VirtualMachineScaleSetProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  upgradePolicy | object | No | the upgrade policy. - [UpgradePolicy object](#UpgradePolicy) |
|  virtualMachineProfile | object | No | the virtual machine profile. - [VirtualMachineScaleSetVMProfile object](#VirtualMachineScaleSetVMProfile) |
|  overprovision | boolean | No | Specifies whether the Virtual Machine Scale Set should be overprovisioned. |


<a id="UpgradePolicy" />
### UpgradePolicy object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  mode | enum | No | the upgrade mode. - Automatic or Manual |


<a id="VirtualMachineScaleSetVMProfile" />
### VirtualMachineScaleSetVMProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  osProfile | object | No | the virtual machine scale set OS profile. - [VirtualMachineScaleSetOSProfile object](#VirtualMachineScaleSetOSProfile) |
|  storageProfile | object | No | the virtual machine scale set storage profile. - [VirtualMachineScaleSetStorageProfile object](#VirtualMachineScaleSetStorageProfile) |
|  networkProfile | object | No | the virtual machine scale set network profile. - [VirtualMachineScaleSetNetworkProfile object](#VirtualMachineScaleSetNetworkProfile) |
|  extensionProfile | object | No | the virtual machine scale set extension profile. - [VirtualMachineScaleSetExtensionProfile object](#VirtualMachineScaleSetExtensionProfile) |


<a id="VirtualMachineScaleSetOSProfile" />
### VirtualMachineScaleSetOSProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  computerNamePrefix | string | No | the computer name prefix. |
|  adminUsername | string | No | the admin user name. |
|  adminPassword | string | No | the admin user password. |
|  customData | string | No | a base-64 encoded string of custom data. |
|  windowsConfiguration | object | No | the Windows Configuration of the OS profile. - [WindowsConfiguration object](#WindowsConfiguration) |
|  linuxConfiguration | object | No | the Linux Configuration of the OS profile. - [LinuxConfiguration object](#LinuxConfiguration) |
|  secrets | array | No | the List of certificates for addition to the VM. - [VaultSecretGroup object](#VaultSecretGroup) |


<a id="VirtualMachineScaleSetStorageProfile" />
### VirtualMachineScaleSetStorageProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  imageReference | object | No | the image reference. - [ImageReference object](#ImageReference) |
|  osDisk | object | No | the OS disk. - [VirtualMachineScaleSetOSDisk object](#VirtualMachineScaleSetOSDisk) |


<a id="VirtualMachineScaleSetNetworkProfile" />
### VirtualMachineScaleSetNetworkProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  networkInterfaceConfigurations | array | No | the list of network configurations. - [VirtualMachineScaleSetNetworkConfiguration object](#VirtualMachineScaleSetNetworkConfiguration) |


<a id="VirtualMachineScaleSetExtensionProfile" />
### VirtualMachineScaleSetExtensionProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  extensions | array | No | the virtual machine scale set child extension resources. - [VirtualMachineScaleSetExtension object](#VirtualMachineScaleSetExtension) |


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


<a id="ImageReference" />
### ImageReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publisher | string | No | the image publisher. |
|  offer | string | No | the image offer. |
|  sku | string | No | the image sku. |
|  version | string | No | the image version. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor and Build being decimal numbers. Specify 'latest' to use the latest version of image. |


<a id="VirtualMachineScaleSetOSDisk" />
### VirtualMachineScaleSetOSDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | the disk name. |
|  caching | enum | No | the caching type. - None, ReadOnly, ReadWrite |
|  createOption | enum | Yes | the create option. - fromImage, empty, attach |
|  osType | enum | No | the Operating System type. - Windows or Linux |
|  image | object | No | the Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine. If SourceImage is provided, the destination VirtualHardDisk should not exist. - [VirtualHardDisk object](#VirtualHardDisk) |
|  vhdContainers | array | No | the list of virtual hard disk container uris. - string |


<a id="VirtualMachineScaleSetNetworkConfiguration" />
### VirtualMachineScaleSetNetworkConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | Yes | the network configuration name. |
|  properties | object | No | [VirtualMachineScaleSetNetworkConfigurationProperties object](#VirtualMachineScaleSetNetworkConfigurationProperties) |


<a id="VirtualMachineScaleSetExtension" />
### VirtualMachineScaleSetExtension object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | No | the name of the extension. |
|  properties | object | No | [VirtualMachineScaleSetExtensionProperties object](#VirtualMachineScaleSetExtensionProperties) |


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


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="VaultCertificate" />
### VaultCertificate object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  certificateUrl | string | No | the URL referencing a secret in a Key Vault which contains a properly formatted certificate. |
|  certificateStore | string | No | the Certificate store in LocalMachine to add the certificate to on Windows, leave empty on Linux. |


<a id="VirtualHardDisk" />
### VirtualHardDisk object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  uri | string | No | the virtual hard disk's uri. It should be a valid Uri to a virtual hard disk. |


<a id="VirtualMachineScaleSetNetworkConfigurationProperties" />
### VirtualMachineScaleSetNetworkConfigurationProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  primary | boolean | No | whether this is a primary NIC on a virtual machine. |
|  ipConfigurations | array | Yes | the virtual machine scale set IP Configuration. - [VirtualMachineScaleSetIPConfiguration object](#VirtualMachineScaleSetIPConfiguration) |


<a id="VirtualMachineScaleSetExtensionProperties" />
### VirtualMachineScaleSetExtensionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publisher | string | No | the name of the extension handler publisher. |
|  type | string | No | the type of the extension handler. |
|  typeHandlerVersion | string | No | the type version of the extension handler. |
|  autoUpgradeMinorVersion | boolean | No | whether the extension handler should be automatically upgraded across minor versions. |
|  settings | object | No | Json formatted public settings for the extension. |
|  protectedSettings | object | No | Json formatted protected settings for the extension. |


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


<a id="VirtualMachineScaleSetIPConfiguration" />
### VirtualMachineScaleSetIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | Yes | the IP configuration name. |
|  properties | object | No | [VirtualMachineScaleSetIPConfigurationProperties object](#VirtualMachineScaleSetIPConfigurationProperties) |


<a id="VirtualMachineScaleSetIPConfigurationProperties" />
### VirtualMachineScaleSetIPConfigurationProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  subnet | object | Yes | the subnet. - [ApiEntityReference object](#ApiEntityReference) |
|  applicationGatewayBackendAddressPools | array | No | the application gateway backend address pools. - [SubResource object](#SubResource) |
|  loadBalancerBackendAddressPools | array | No | the load balancer backend address pools. - [SubResource object](#SubResource) |
|  loadBalancerInboundNatPools | array | No | the load balancer inbound nat pools. - [SubResource object](#SubResource) |


<a id="ApiEntityReference" />
### ApiEntityReference object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | the ARM resource id in the form of /subscriptions/{SubcriptionId}/resourceGroups/{ResourceGroupName}/... |

