# Microsoft.Compute/availabilitySets template reference
API Version: 2015-06-15
## Template format

To create a Microsoft.Compute/availabilitySets resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Compute/availabilitySets",
  "apiVersion": "2015-06-15",
  "location": "string",
  "tags": {},
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
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Compute/availabilitySets" />
### Microsoft.Compute/availabilitySets object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Compute/availabilitySets |
|  apiVersion | enum | Yes | 2015-06-15 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [AvailabilitySetProperties object](#AvailabilitySetProperties) |


<a id="AvailabilitySetProperties" />
### AvailabilitySetProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  platformUpdateDomainCount | integer | No | Gets or sets Update Domain count. |
|  platformFaultDomainCount | integer | No | Gets or sets Fault Domain count. |
|  virtualMachines | array | No | Gets or sets a list containing reference to all Virtual Machines  created under this Availability Set. - [SubResource object](#SubResource) |
|  statuses | array | No | Gets or sets the resource status information. - [InstanceViewStatus object](#InstanceViewStatus) |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="InstanceViewStatus" />
### InstanceViewStatus object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  code | string | No | Gets the status Code. |
|  level | enum | No | Gets or sets the level Code. - Info, Warning, Error |
|  displayStatus | string | No | Gets or sets the short localizable label for the status. |
|  message | string | No | Gets or sets the detailed Message, including for alerts and error messages. |
|  time | string | No | Gets or sets the time of the status. |

