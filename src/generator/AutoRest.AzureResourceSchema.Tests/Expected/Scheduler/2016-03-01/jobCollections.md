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
  "resources": [
    null
  ]
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
|  resources | array | No | [jobCollections_jobs_childResource object](#jobCollections_jobs_childResource) |


<a id="JobCollectionProperties" />
### JobCollectionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sku | object | No | Gets or sets the SKU. - [Sku object](#Sku) |
|  state | enum | No | Gets or sets the state. - Enabled, Disabled, Suspended, Deleted |
|  quota | object | No | Gets or sets the job collection quota. - [JobCollectionQuota object](#JobCollectionQuota) |


<a id="jobCollections_jobs_childResource" />
### jobCollections_jobs_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | jobs |
|  apiVersion | enum | Yes | 2016-03-01 |
|  properties | object | Yes | Gets or sets the job properties. - [JobProperties object](#JobProperties) |


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


<a id="JobProperties" />
### JobProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  startTime | string | No | Gets or sets the job start time. |
|  action | object | No | Gets or sets the job action. - [JobAction object](#JobAction) |
|  recurrence | object | No | Gets or sets the job recurrence. - [JobRecurrence object](#JobRecurrence) |
|  state | enum | No | Gets or set the job state. - Enabled, Disabled, Faulted, Completed |


<a id="JobMaxRecurrence" />
### JobMaxRecurrence object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frequency | enum | No | Gets or sets the frequency of recurrence (second, minute, hour, day, week, month). - Minute, Hour, Day, Week, Month |
|  interval | integer | No | Gets or sets the interval between retries. |


<a id="JobAction" />
### JobAction object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | No | Gets or sets the job action type. - Http, Https, StorageQueue, ServiceBusQueue, ServiceBusTopic |
|  request | object | No | Gets or sets the http requests. - [HttpRequest object](#HttpRequest) |
|  queueMessage | object | No | Gets or sets the storage queue message. - [StorageQueueMessage object](#StorageQueueMessage) |
|  serviceBusQueueMessage | object | No | Gets or sets the service bus queue message. - [ServiceBusQueueMessage object](#ServiceBusQueueMessage) |
|  serviceBusTopicMessage | object | No | Gets or sets the service bus topic message. - [ServiceBusTopicMessage object](#ServiceBusTopicMessage) |
|  retryPolicy | object | No | Gets or sets the retry policy. - [RetryPolicy object](#RetryPolicy) |
|  errorAction | object | No | Gets or sets the error action. - [JobErrorAction object](#JobErrorAction) |


<a id="JobRecurrence" />
### JobRecurrence object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frequency | enum | No | Gets or sets the frequency of recurrence (second, minute, hour, day, week, month). - Minute, Hour, Day, Week, Month |
|  interval | integer | No | Gets or sets the interval between retries. |
|  count | integer | No | Gets or sets the maximum number of times that the job should run. |
|  endTime | string | No | Gets or sets the time at which the job will complete. |
|  schedule | object | No | [JobRecurrenceSchedule object](#JobRecurrenceSchedule) |


<a id="HttpRequest" />
### HttpRequest object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authentication | object | No | Gets or sets the http authentication. - [HttpAuthentication object](#HttpAuthentication) |
|  uri | string | No | Gets or sets the Uri. |
|  method | string | No | Gets or sets the method of the request. |
|  body | string | No | Gets or sets the request body. |
|  headers | object | No | Gets or sets the headers. |


<a id="StorageQueueMessage" />
### StorageQueueMessage object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  storageAccount | string | No | Gets or sets the storage account name. |
|  queueName | string | No | Gets or sets the queue name. |
|  sasToken | string | No | Gets or sets the SAS key. |
|  message | string | No | Gets or sets the message. |


<a id="ServiceBusQueueMessage" />
### ServiceBusQueueMessage object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authentication | object | No | Gets or sets the authentication. - [ServiceBusAuthentication object](#ServiceBusAuthentication) |
|  brokeredMessageProperties | object | No | Gets or sets the brokered message properties. - [ServiceBusBrokeredMessageProperties object](#ServiceBusBrokeredMessageProperties) |
|  customMessageProperties | object | No | Gets or sets the custom message properties. |
|  message | string | No | Gets or sets the message. |
|  namespace | string | No | Gets or sets the namespace. |
|  transportType | enum | No | Gets or sets the transport type. - NotSpecified, NetMessaging, AMQP |
|  queueName | string | No | Gets or sets the queue name. |


<a id="ServiceBusTopicMessage" />
### ServiceBusTopicMessage object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  authentication | object | No | Gets or sets the authentication. - [ServiceBusAuthentication object](#ServiceBusAuthentication) |
|  brokeredMessageProperties | object | No | Gets or sets the brokered message properties. - [ServiceBusBrokeredMessageProperties object](#ServiceBusBrokeredMessageProperties) |
|  customMessageProperties | object | No | Gets or sets the custom message properties. |
|  message | string | No | Gets or sets the message. |
|  namespace | string | No | Gets or sets the namespace. |
|  transportType | enum | No | Gets or sets the transport type. - NotSpecified, NetMessaging, AMQP |
|  topicPath | string | No | Gets or sets the topic path. |


<a id="RetryPolicy" />
### RetryPolicy object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  retryType | enum | No | Gets or sets the retry strategy to be used. - None or Fixed |
|  retryInterval | string | No | Gets or sets the retry interval between retries. |
|  retryCount | integer | No | Gets or sets the number of times a retry should be attempted. |


<a id="JobErrorAction" />
### JobErrorAction object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | No | Gets or sets the job error action type. - Http, Https, StorageQueue, ServiceBusQueue, ServiceBusTopic |
|  request | object | No | Gets or sets the http requests. - [HttpRequest object](#HttpRequest) |
|  queueMessage | object | No | Gets or sets the storage queue message. - [StorageQueueMessage object](#StorageQueueMessage) |
|  serviceBusQueueMessage | object | No | Gets or sets the service bus queue message. - [ServiceBusQueueMessage object](#ServiceBusQueueMessage) |
|  serviceBusTopicMessage | object | No | Gets or sets the service bus topic message. - [ServiceBusTopicMessage object](#ServiceBusTopicMessage) |
|  retryPolicy | object | No | Gets or sets the retry policy. - [RetryPolicy object](#RetryPolicy) |


<a id="JobRecurrenceSchedule" />
### JobRecurrenceSchedule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  weekDays | array | No | Gets or sets the days of the week that the job should execute on. - Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday |
|  hours | array | No | Gets or sets the hours of the day that the job should execute at. - integer |
|  minutes | array | No | Gets or sets the minutes of the hour that the job should execute at. - integer |
|  monthDays | array | No | Gets or sets the days of the month that the job should execute on. Must be between 1 and 31. - integer |
|  monthlyOccurrences | array | No | Gets or sets the occurrences of days within a month. - [JobRecurrenceScheduleMonthlyOccurrence object](#JobRecurrenceScheduleMonthlyOccurrence) |


<a id="HttpAuthentication" />
### HttpAuthentication object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | No | Gets or sets the http authentication type. - NotSpecified, ClientCertificate, ActiveDirectoryOAuth, Basic |


<a id="ServiceBusAuthentication" />
### ServiceBusAuthentication object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sasKey | string | No | Gets or sets the SAS key. |
|  sasKeyName | string | No | Gets or sets the SAS key name. |
|  type | enum | No | Gets or sets the authentication type. - NotSpecified or SharedAccessKey |


<a id="ServiceBusBrokeredMessageProperties" />
### ServiceBusBrokeredMessageProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  contentType | string | No | Gets or sets the content type. |
|  correlationId | string | No | Gets or sets the correlation id. |
|  forcePersistence | boolean | No | Gets or sets the force persistence. |
|  label | string | No | Gets or sets the label. |
|  messageId | string | No | Gets or sets the message id. |
|  partitionKey | string | No | Gets or sets the partition key. |
|  replyTo | string | No | Gets or sets the reply to. |
|  replyToSessionId | string | No | Gets or sets the reply to session id. |
|  scheduledEnqueueTimeUtc | string | No | Gets or sets the scheduled enqueue time UTC. |
|  sessionId | string | No | Gets or sets the session id. |
|  timeToLive | string | No | Gets or sets the time to live. |
|  to | string | No | Gets or sets the to. |
|  viaPartitionKey | string | No | Gets or sets the via partition key. |


<a id="JobRecurrenceScheduleMonthlyOccurrence" />
### JobRecurrenceScheduleMonthlyOccurrence object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  day | enum | No | Gets or sets the day. Must be one of monday, tuesday, wednesday, thursday, friday, saturday, sunday. - Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday |
|  Occurrence | integer | No | Gets or sets the occurrence. Must be between -5 and 5. |

