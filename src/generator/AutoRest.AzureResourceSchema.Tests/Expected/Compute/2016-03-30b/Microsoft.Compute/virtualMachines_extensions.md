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
  "properties": {}
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

