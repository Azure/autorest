# Microsoft.Compute/availabilitySets template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.Compute/availabilitySets resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Compute/availabilitySets",
  "apiVersion": "2016-03-30",
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
|  type | enum | Yes | Microsoft.Compute/availabilitySets |
|  apiVersion | enum | Yes | 2016-03-30 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [AvailabilitySetProperties object](#AvailabilitySetProperties) |


<a id="AvailabilitySetProperties" />
### AvailabilitySetProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  platformUpdateDomainCount | integer | No | Update Domain count. |
|  platformFaultDomainCount | integer | No | Fault Domain count. |
|  virtualMachines | array | No | a list containing reference to all Virtual Machines created under this Availability Set. - [SubResource object](#SubResource) |
|  statuses | array | No | the resource status information. - [InstanceViewStatus object](#InstanceViewStatus) |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="InstanceViewStatus" />
### InstanceViewStatus object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  code | string | No | the status Code. |
|  level | enum | No | the level Code. - Info, Warning, Error |
|  displayStatus | string | No | the short localizable label for the status. |
|  message | string | No | the detailed Message, including for alerts and error messages. |
|  time | string | No | the time of the status. |

