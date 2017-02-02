# Microsoft.DevTestLab/labs/schedules template reference
API Version: 2015-05-21-preview
## Template format

To create a Microsoft.DevTestLab/labs/schedules resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
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
  },
  "id": "string",
  "location": "string",
  "tags": {}
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DevTestLab/labs/schedules" />
### Microsoft.DevTestLab/labs/schedules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.DevTestLab/labs/schedules |
|  apiVersion | enum | Yes | 2015-05-21-preview |
|  properties | object | Yes | The properties of the resource. - [ScheduleProperties object](#ScheduleProperties) |
|  id | string | No | The identifier of the resource. |
|  location | string | No | The location of the resource. |
|  tags | object | No | The tags of the resource. |


<a id="ScheduleProperties" />
### ScheduleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  status | enum | No | The status of the schedule. - Enabled or Disabled |
|  taskType | enum | No | The task type of the schedule. - LabVmsShutdownTask, LabVmsStartupTask, LabBillingTask |
|  weeklyRecurrence | object | No | The weekly recurrence of the schedule. - [WeekDetails object](#WeekDetails) |
|  dailyRecurrence | object | No | The daily recurrence of the schedule. - [DayDetails object](#DayDetails) |
|  hourlyRecurrence | object | No | The hourly recurrence of the schedule. - [HourDetails object](#HourDetails) |
|  timeZoneId | string | No | The time zone id. |
|  provisioningState | string | No | The provisioning status of the resource. |


<a id="WeekDetails" />
### WeekDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  weekdays | array | No | The days of the week. - string |
|  time | string | No | The time of the day. |


<a id="DayDetails" />
### DayDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  time | string | No |  |


<a id="HourDetails" />
### HourDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  minute | integer | No | Minutes of the hour the schedule will run. |

