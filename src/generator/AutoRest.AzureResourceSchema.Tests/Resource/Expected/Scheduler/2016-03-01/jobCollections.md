# Microsoft.Scheduler/jobCollections template reference
API Version: 2016-03-01
## Template format

To create a Microsoft.Scheduler/jobCollections resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Scheduler/jobCollections",
  "apiVersion": "2016-03-01",
  "location": "string",
  "tags": {},
  "properties": {
    "sku": {
      "name": "string"
    },
    "state": "string",
    "quota": {
      "maxJobCount": "integer",
      "maxJobOccurrence": "integer",
      "maxRecurrence": {
        "frequency": "string",
        "interval": "integer"
      }
    }
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Scheduler/jobCollections" />
### Microsoft.Scheduler/jobCollections object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Scheduler/jobCollections |
|  apiVersion | enum | Yes | 2016-03-01 |
|  location | string | No | Gets or sets the storage account location. |
|  tags | object | No | Gets or sets the tags. |
|  properties | object | Yes | Gets or sets the job collection properties. - [JobCollectionProperties object](#JobCollectionProperties) |
|  resources | array | No | [jobs](./jobCollections/jobs.md) |


<a id="JobCollectionProperties" />
### JobCollectionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sku | object | No | Gets or sets the SKU. - [Sku object](#Sku) |
|  state | enum | No | Gets or sets the state. - Enabled, Disabled, Suspended, Deleted |
|  quota | object | No | Gets or sets the job collection quota. - [JobCollectionQuota object](#JobCollectionQuota) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Gets or set the SKU. - Standard, Free, P10Premium, P20Premium |


<a id="JobCollectionQuota" />
### JobCollectionQuota object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  maxJobCount | integer | No | Gets or set the maximum job count. |
|  maxJobOccurrence | integer | No | Gets or sets the maximum job occurrence. |
|  maxRecurrence | object | No | Gets or set the maximum recurrence. - [JobMaxRecurrence object](#JobMaxRecurrence) |


<a id="JobMaxRecurrence" />
### JobMaxRecurrence object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frequency | enum | No | Gets or sets the frequency of recurrence (second, minute, hour, day, week, month). - Minute, Hour, Day, Week, Month |
|  interval | integer | No | Gets or sets the interval between retries. |

