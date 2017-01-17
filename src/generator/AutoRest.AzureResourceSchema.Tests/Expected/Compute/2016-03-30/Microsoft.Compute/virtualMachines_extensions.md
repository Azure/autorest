# Microsoft.Compute/virtualMachines/extensions template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.Compute/virtualMachines/extensions resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "apiVersion": "2016-03-30",
  "location": "string",
  "tags": {},
  "properties": {
    "forceUpdateTag": "string",
    "publisher": "string",
    "type": "string",
    "typeHandlerVersion": "string",
    "autoUpgradeMinorVersion": boolean,
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
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Compute/virtualMachines/extensions" />
### Microsoft.Compute/virtualMachines/extensions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Compute/virtualMachines/extensions |
|  apiVersion | enum | Yes | 2016-03-30 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VirtualMachineExtensionProperties object](#VirtualMachineExtensionProperties) |


<a id="VirtualMachineExtensionProperties" />
### VirtualMachineExtensionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  forceUpdateTag | string | No | how the extension handler should be forced to update even if the extension configuration has not changed. |
|  publisher | string | No | the name of the extension handler publisher. |
|  type | string | No | the type of the extension handler. |
|  typeHandlerVersion | string | No | the type version of the extension handler. |
|  autoUpgradeMinorVersion | boolean | No | whether the extension handler should be automatically upgraded across minor versions. |
|  settings | object | No | Json formatted public settings for the extension. |
|  protectedSettings | object | No | Json formatted protected settings for the extension. |
|  instanceView | object | No | the virtual machine extension instance view. - [VirtualMachineExtensionInstanceView object](#VirtualMachineExtensionInstanceView) |


<a id="VirtualMachineExtensionInstanceView" />
### VirtualMachineExtensionInstanceView object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | the virtual machine extension name. |
|  type | string | No | the full type of the extension handler which includes both publisher and type. |
|  typeHandlerVersion | string | No | the type version of the extension handler. |
|  substatuses | array | No | the resource status information. - [InstanceViewStatus object](#InstanceViewStatus) |
|  statuses | array | No | the resource status information. - [InstanceViewStatus object](#InstanceViewStatus) |


<a id="InstanceViewStatus" />
### InstanceViewStatus object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  code | string | No | the status Code. |
|  level | enum | No | the level Code. - Info, Warning, Error |
|  displayStatus | string | No | the short localizable label for the status. |
|  message | string | No | the detailed Message, including for alerts and error messages. |
|  time | string | No | the time of the status. |

