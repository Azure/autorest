# Microsoft.Scheduler template schema

Creates a Microsoft.Scheduler resource.

## Schema format

To create a Microsoft.Scheduler, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Scheduler/jobCollections",
  "apiVersion": "2016-03-01",
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
  }
}
```
```
{
  "type": "Microsoft.Scheduler/jobCollections/jobs",
  "apiVersion": "2016-03-01",
  "properties": {
    "startTime": "string",
    "action": {
      "type": "string",
      "request": {
        "authentication": {
          "type": "string"
        },
        "uri": "string",
        "method": "string",
        "body": "string",
        "headers": {}
      },
      "queueMessage": {
        "storageAccount": "string",
        "queueName": "string",
        "sasToken": "string",
        "message": "string"
      },
      "serviceBusQueueMessage": {
        "authentication": {
          "sasKey": "string",
          "sasKeyName": "string",
          "type": "string"
        },
        "brokeredMessageProperties": {
          "contentType": "string",
          "correlationId": "string",
          "forcePersistence": "boolean",
          "label": "string",
          "messageId": "string",
          "partitionKey": "string",
          "replyTo": "string",
          "replyToSessionId": "string",
          "scheduledEnqueueTimeUtc": "string",
          "sessionId": "string",
          "timeToLive": "string",
          "to": "string",
          "viaPartitionKey": "string"
        },
        "customMessageProperties": {},
        "message": "string",
        "namespace": "string",
        "transportType": "string",
        "queueName": "string"
      },
      "serviceBusTopicMessage": {
        "authentication": {
          "sasKey": "string",
          "sasKeyName": "string",
          "type": "string"
        },
        "brokeredMessageProperties": {
          "contentType": "string",
          "correlationId": "string",
          "forcePersistence": "boolean",
          "label": "string",
          "messageId": "string",
          "partitionKey": "string",
          "replyTo": "string",
          "replyToSessionId": "string",
          "scheduledEnqueueTimeUtc": "string",
          "sessionId": "string",
          "timeToLive": "string",
          "to": "string",
          "viaPartitionKey": "string"
        },
        "customMessageProperties": {},
        "message": "string",
        "namespace": "string",
        "transportType": "string",
        "topicPath": "string"
      },
      "retryPolicy": {
        "retryType": "string",
        "retryInterval": "string",
        "retryCount": "integer"
      },
      "errorAction": {
        "type": "string",
        "request": {
          "authentication": {
            "type": "string"
          },
          "uri": "string",
          "method": "string",
          "body": "string",
          "headers": {}
        },
        "queueMessage": {
          "storageAccount": "string",
          "queueName": "string",
          "sasToken": "string",
          "message": "string"
        },
        "serviceBusQueueMessage": {
          "authentication": {
            "sasKey": "string",
            "sasKeyName": "string",
            "type": "string"
          },
          "brokeredMessageProperties": {
            "contentType": "string",
            "correlationId": "string",
            "forcePersistence": "boolean",
            "label": "string",
            "messageId": "string",
            "partitionKey": "string",
            "replyTo": "string",
            "replyToSessionId": "string",
            "scheduledEnqueueTimeUtc": "string",
            "sessionId": "string",
            "timeToLive": "string",
            "to": "string",
            "viaPartitionKey": "string"
          },
          "customMessageProperties": {},
          "message": "string",
          "namespace": "string",
          "transportType": "string",
          "queueName": "string"
        },
        "serviceBusTopicMessage": {
          "authentication": {
            "sasKey": "string",
            "sasKeyName": "string",
            "type": "string"
          },
          "brokeredMessageProperties": {
            "contentType": "string",
            "correlationId": "string",
            "forcePersistence": "boolean",
            "label": "string",
            "messageId": "string",
            "partitionKey": "string",
            "replyTo": "string",
            "replyToSessionId": "string",
            "scheduledEnqueueTimeUtc": "string",
            "sessionId": "string",
            "timeToLive": "string",
            "to": "string",
            "viaPartitionKey": "string"
          },
          "customMessageProperties": {},
          "message": "string",
          "namespace": "string",
          "transportType": "string",
          "topicPath": "string"
        },
        "retryPolicy": {
          "retryType": "string",
          "retryInterval": "string",
          "retryCount": "integer"
        }
      }
    },
    "recurrence": {
      "frequency": "string",
      "interval": "integer",
      "count": "integer",
      "endTime": "string",
      "schedule": {
        "weekDays": [
          "string"
        ],
        "hours": [
          "integer"
        ],
        "minutes": [
          "integer"
        ],
        "monthDays": [
          "integer"
        ],
        "monthlyOccurrences": [
          {
            "day": "string",
            "Occurrence": "integer"
          }
        ]
      }
    },
    "state": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="jobCollections" />
## jobCollections object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Scheduler/jobCollections**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  name | No | string<br /><br />Gets or sets the job collection resource name. |
|  location | No | string<br /><br />Gets or sets the storage account location. |
|  tags | No | object<br /><br />Gets or sets the tags. |
|  properties | Yes | object<br />[JobCollectionProperties object](#JobCollectionProperties)<br /><br />Gets or sets the job collection properties. |
|  resources | No | array<br />[jobs object](#jobs)<br /> |


<a id="jobCollections_jobs" />
## jobCollections_jobs object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Scheduler/jobCollections/jobs**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  properties | Yes | object<br />[JobProperties object](#JobProperties)<br /><br />Gets or sets the job properties. |


<a id="JobCollectionProperties" />
## JobCollectionProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sku | No | object<br />[Sku object](#Sku)<br /><br />Gets or sets the SKU. |
|  state | No | enum<br />**Enabled**, **Disabled**, **Suspended**, **Deleted**<br /><br />Gets or sets the state. |
|  quota | No | object<br />[JobCollectionQuota object](#JobCollectionQuota)<br /><br />Gets or sets the job collection quota. |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Standard**, **Free**, **P10Premium**, **P20Premium**<br /><br />Gets or set the SKU. |


<a id="JobCollectionQuota" />
## JobCollectionQuota object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  maxJobCount | No | integer<br /><br />Gets or set the maximum job count. |
|  maxJobOccurrence | No | integer<br /><br />Gets or sets the maximum job occurrence. |
|  maxRecurrence | No | object<br />[JobMaxRecurrence object](#JobMaxRecurrence)<br /><br />Gets or set the maximum recurrence. |


<a id="JobMaxRecurrence" />
## JobMaxRecurrence object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frequency | No | enum<br />**Minute**, **Hour**, **Day**, **Week**, **Month**<br /><br />Gets or sets the frequency of recurrence (second, minute, hour, day, week, month). |
|  interval | No | integer<br /><br />Gets or sets the interval between retries. |


<a id="JobProperties" />
## JobProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  startTime | No | string<br /><br />Gets or sets the job start time. |
|  action | No | object<br />[JobAction object](#JobAction)<br /><br />Gets or sets the job action. |
|  recurrence | No | object<br />[JobRecurrence object](#JobRecurrence)<br /><br />Gets or sets the job recurrence. |
|  state | No | enum<br />**Enabled**, **Disabled**, **Faulted**, **Completed**<br /><br />Gets or set the job state. |


<a id="JobAction" />
## JobAction object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | No | enum<br />**Http**, **Https**, **StorageQueue**, **ServiceBusQueue**, **ServiceBusTopic**<br /><br />Gets or sets the job action type. |
|  request | No | object<br />[HttpRequest object](HttpRequest)<br /><br />Gets or sets the http requests. |
|  queueMessage | No | object<br />[StorageQueueMessage object](#StorageQueueMessage)<br /><br />Gets or sets the storage queue message. |
|  serviceBusQueueMessage | No | object<br />[ServiceBusQueueMessage object](#ServiceBusQueueMessage)<br /><br />Gets or sets the service bus queue message. |
|  serviceBusTopicMessage | No | object<br />[ServiceBusTopicMessage object](#ServiceBusTopicMessage)<br /><br />Gets or sets the service bus topic message. |
|  retryPolicy | No | object<br />[RetryPolicy object](#RetryPolicy)<br /><br />Gets or sets the retry policy. |
|  errorAction | No | object<br />[JobErrorAction object](#JobErrorAction)<br /><br />Gets or sets the error action. |


<a id="HttpRequest" />
## HttpRequest object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  authentication | No | object<br />[HttpAuthentication object](HttpAuthentication)<br /><br />Gets or sets the http authentication. |
|  uri | No | string<br /><br />Gets or sets the Uri. |
|  method | No | string<br /><br />Gets or sets the method of the request. |
|  body | No | string<br /><br />Gets or sets the request body. |
|  headers | No | object<br /><br />Gets or sets the headers. |


<a id="HttpAuthentication" />
## HttpAuthentication object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | No | enum<br />**NotSpecified**, **ClientCertificate**, **ActiveDirectoryOAuth**, **Basic**<br /><br />Gets or sets the http authentication type. |


<a id="StorageQueueMessage" />
## StorageQueueMessage object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  storageAccount | No | string<br /><br />Gets or sets the storage account name. |
|  queueName | No | string<br /><br />Gets or sets the queue name. |
|  sasToken | No | string<br /><br />Gets or sets the SAS key. |
|  message | No | string<br /><br />Gets or sets the message. |


<a id="ServiceBusQueueMessage" />
## ServiceBusQueueMessage object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  authentication | No | object<br />[ServiceBusAuthentication object](#ServiceBusAuthentication)<br /><br />Gets or sets the authentication. |
|  brokeredMessageProperties | No | object<br />[ServiceBusBrokeredMessageProperties object](#ServiceBusBrokeredMessageProperties)<br /><br />Gets or sets the brokered message properties. |
|  customMessageProperties | No | object<br /><br />Gets or sets the custom message properties. |
|  message | No | string<br /><br />Gets or sets the message. |
|  namespace | No | string<br /><br />Gets or sets the namespace. |
|  transportType | No | enum<br />**NotSpecified**, **NetMessaging**, **AMQP**<br /><br />Gets or sets the transport type. |
|  queueName | No | string<br /><br />Gets or sets the queue name. |


<a id="ServiceBusAuthentication" />
## ServiceBusAuthentication object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sasKey | No | string<br /><br />Gets or sets the SAS key. |
|  sasKeyName | No | string<br /><br />Gets or sets the SAS key name. |
|  type | No | enum<br />**NotSpecified** or **SharedAccessKey**<br /><br />Gets or sets the authentication type. |


<a id="ServiceBusBrokeredMessageProperties" />
## ServiceBusBrokeredMessageProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  contentType | No | string<br /><br />Gets or sets the content type. |
|  correlationId | No | string<br /><br />Gets or sets the correlation id. |
|  forcePersistence | No | boolean<br /><br />Gets or sets the force persistence. |
|  label | No | string<br /><br />Gets or sets the label. |
|  messageId | No | string<br /><br />Gets or sets the message id. |
|  partitionKey | No | string<br /><br />Gets or sets the partition key. |
|  replyTo | No | string<br /><br />Gets or sets the reply to. |
|  replyToSessionId | No | string<br /><br />Gets or sets the reply to session id. |
|  scheduledEnqueueTimeUtc | No | string<br /><br />Gets or sets the scheduled enqueue time UTC. |
|  sessionId | No | string<br /><br />Gets or sets the session id. |
|  timeToLive | No | string<br /><br />Gets or sets the time to live. |
|  to | No | string<br /><br />Gets or sets the to. |
|  viaPartitionKey | No | string<br /><br />Gets or sets the via partition key. |


<a id="ServiceBusTopicMessage" />
## ServiceBusTopicMessage object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  authentication | No | object<br />[ServiceBusAuthentication object](#ServiceBusAuthentication)<br /><br />Gets or sets the authentication. |
|  brokeredMessageProperties | No | object<br />[ServiceBusBrokeredMessageProperties object](#ServiceBusBrokeredMessageProperties)<br /><br />Gets or sets the brokered message properties. |
|  customMessageProperties | No | object<br /><br />Gets or sets the custom message properties. |
|  message | No | string<br /><br />Gets or sets the message. |
|  namespace | No | string<br /><br />Gets or sets the namespace. |
|  transportType | No | enum<br />**NotSpecified**, **NetMessaging**, **AMQP**<br /><br />Gets or sets the transport type. |
|  topicPath | No | string<br /><br />Gets or sets the topic path. |


<a id="RetryPolicy" />
## RetryPolicy object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  retryType | No | enum<br />**None** or **Fixed**<br /><br />Gets or sets the retry strategy to be used. |
|  retryInterval | No | string<br /><br />Gets or sets the retry interval between retries. |
|  retryCount | No | integer<br /><br />Gets or sets the number of times a retry should be attempted. |


<a id="JobErrorAction" />
## JobErrorAction object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | No | enum<br />**Http**, **Https**, **StorageQueue**, **ServiceBusQueue**, **ServiceBusTopic**<br /><br />Gets or sets the job error action type. |
|  request | No | object<br />[HttpRequest object](HttpRequest)<br /><br />Gets or sets the http requests. |
|  queueMessage | No | object<br />[StorageQueueMessage object](#StorageQueueMessage)<br /><br />Gets or sets the storage queue message. |
|  serviceBusQueueMessage | No | object<br />[ServiceBusQueueMessage object](#ServiceBusQueueMessage)<br /><br />Gets or sets the service bus queue message. |
|  serviceBusTopicMessage | No | object<br />[ServiceBusTopicMessage object](#ServiceBusTopicMessage)<br /><br />Gets or sets the service bus topic message. |
|  retryPolicy | No | object<br />[RetryPolicy object](#RetryPolicy)<br /><br />Gets or sets the retry policy. |


<a id="JobRecurrence" />
## JobRecurrence object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frequency | No | enum<br />**Minute**, **Hour**, **Day**, **Week**, **Month**<br /><br />Gets or sets the frequency of recurrence (second, minute, hour, day, week, month). |
|  interval | No | integer<br /><br />Gets or sets the interval between retries. |
|  count | No | integer<br /><br />Gets or sets the maximum number of times that the job should run. |
|  endTime | No | string<br /><br />Gets or sets the time at which the job will complete. |
|  schedule | No | object<br />[JobRecurrenceSchedule object](#JobRecurrenceSchedule)<br /> |


<a id="JobRecurrenceSchedule" />
## JobRecurrenceSchedule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  weekDays | No | array<br />**Sunday**, **Monday**, **Tuesday**, **Wednesday**, **Thursday**, **Friday**, **Saturday**<br /><br />Gets or sets the days of the week that the job should execute on. |
|  hours | No | array<br />**integer**<br /><br />Gets or sets the hours of the day that the job should execute at. |
|  minutes | No | array<br />**integer**<br /><br />Gets or sets the minutes of the hour that the job should execute at. |
|  monthDays | No | array<br />**integer**<br /><br />Gets or sets the days of the month that the job should execute on. Must be between 1 and 31. |
|  monthlyOccurrences | No | array<br />[JobRecurrenceScheduleMonthlyOccurrence object](#JobRecurrenceScheduleMonthlyOccurrence)<br /><br />Gets or sets the occurrences of days within a month. |


<a id="JobRecurrenceScheduleMonthlyOccurrence" />
## JobRecurrenceScheduleMonthlyOccurrence object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  day | No | enum<br />**Monday**, **Tuesday**, **Wednesday**, **Thursday**, **Friday**, **Saturday**, **Sunday**<br /><br />Gets or sets the day. Must be one of monday, tuesday, wednesday, thursday, friday, saturday, sunday. |
|  Occurrence | No | integer<br /><br />Gets or sets the occurrence. Must be between -5 and 5. |


<a id="jobCollections_jobs_childResource" />
## jobCollections_jobs_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**jobs**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-01**<br /> |
|  properties | Yes | object<br />[JobProperties object](#JobProperties)<br /><br />Gets or sets the job properties. |

