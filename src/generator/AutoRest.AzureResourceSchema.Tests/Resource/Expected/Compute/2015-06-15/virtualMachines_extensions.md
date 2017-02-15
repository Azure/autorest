# Microsoft.Compute/virtualMachines/extensions template reference
API Version: 2015-06-15
## Template format

To create a Microsoft.Compute/virtualMachines/extensions resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "apiVersion": "2015-06-15",
  "location": "string",
  "tags": {},
  "properties": {
    "forceUpdateTag": "RerunExtension",
    "publisher": "string",
    "type": "string",
    "typeHandlerVersion": "string",
    "autoUpgradeMinorVersion": boolean,
    "settings": {},
    "protectedSettings": {},
    "provisioningState": "string",
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
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Compute/virtualMachines/extensions" />
### Microsoft.Compute/virtualMachines/extensions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Compute/virtualMachines/extensions |
|  apiVersion | enum | Yes | 2015-06-15 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualMachineExtensionProperties object](#VirtualMachineExtensionProperties) |


<a id="VirtualMachineExtensionProperties" />
### VirtualMachineExtensionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  forceUpdateTag | enum | No | Gets or sets how the extension handler should be forced to update even if the extension configuration has not changed. - RerunExtension |
|  publisher | string | No | Gets or sets the name of the extension handler publisher. |
|  type | string | No | Gets or sets the type of the extension handler. |
|  typeHandlerVersion | string | No | Gets or sets the type version of the extension handler. |
|  autoUpgradeMinorVersion | boolean | No | Gets or sets whether the extension handler should be automatically upgraded across minor versions. |
|  settings | object | No | Gets or sets Json formatted public settings for the extension. |
|  protectedSettings | object | No | Gets or sets Json formatted protected settings for the extension. |
|  provisioningState | string | No | Gets or sets the provisioning state, which only appears in the response. |
|  instanceView | object | No | Gets or sets the virtual machine extension instance view. - [VirtualMachineExtensionInstanceView object](#VirtualMachineExtensionInstanceView) |


<a id="VirtualMachineExtensionInstanceView" />
### VirtualMachineExtensionInstanceView object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Gets or sets the virtual machine extension name. |
|  type | string | No | Gets or sets the full type of the extension handler which includes both publisher and type. |
|  typeHandlerVersion | string | No | Gets or sets the type version of the extension handler. |
|  substatuses | array | No | Gets or sets the resource status information. - [InstanceViewStatus object](#InstanceViewStatus) |
|  statuses | array | No | Gets or sets the resource status information. - [InstanceViewStatus object](#InstanceViewStatus) |


<a id="InstanceViewStatus" />
### InstanceViewStatus object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  code | string | No | Gets the status Code. |
|  level | enum | No | Gets or sets the level Code. - Info, Warning, Error |
|  displayStatus | string | No | Gets or sets the short localizable label for the status. |
|  message | string | No | Gets or sets the detailed Message, including for alerts and error messages. |
|  time | string | No | Gets or sets the time of the status. |

