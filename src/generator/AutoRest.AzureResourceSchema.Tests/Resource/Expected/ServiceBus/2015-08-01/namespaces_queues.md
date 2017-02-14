# Microsoft.ServiceBus/namespaces/queues template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.ServiceBus/namespaces/queues resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ServiceBus/namespaces/queues",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "lockDuration ": "string",
    "accessedAt": "string",
    "autoDeleteOnIdle": "string",
    "entityAvailabilityStatus ": "string",
    "createdAt": "string",
    "defaultMessageTimeToLive": "string",
    "duplicateDetectionHistoryTimeWindow ": "string",
    "enableBatchedOperations": boolean,
    "deadLetteringOnMessageExpiration": boolean,
    "enableExpress": boolean,
    "enablePartitioning": boolean,
    "isAnonymousAccessible": boolean,
    "maxDeliveryCount ": "integer",
    "maxSizeInMegabytes": "integer",
    "messageCount ": "integer",
    "countDetails": {
      "activeMessageCount": "integer",
      "deadLetterMessageCount": "integer",
      "scheduledMessageCount": "integer",
      "transferDeadLetterMessageCount": "integer",
      "transferMessageCount": "integer"
    },
    "requiresDuplicateDetection": boolean,
    "requiresSession": boolean,
    "sizeInBytes ": "integer",
    "status": "string",
    "supportOrdering": boolean,
    "updatedAt": "string"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ServiceBus/namespaces/queues" />
### Microsoft.ServiceBus/namespaces/queues object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ServiceBus/namespaces/queues |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | Yes | location of the resource. |
|  properties | object | Yes | [QueueProperties object](#QueueProperties) |
|  resources | array | No | [namespaces_queues_authorizationRules_childResource object](#namespaces_queues_authorizationRules_childResource) |


<a id="QueueProperties" />
### QueueProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  lockDuration  | string | No | the duration of a peek lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
|  accessedAt | string | No | Last time a message was sent, or the last time there was a receive request to this queue. |
|  autoDeleteOnIdle | string | No | the TimeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes. |
|  entityAvailabilityStatus  | enum | No | Entity availability status for the queue. - Available, Limited, Renaming, Restoring, Unknown |
|  createdAt | string | No | the exact time the message was created. |
|  defaultMessageTimeToLive | string | No | the default message time to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
|  duplicateDetectionHistoryTimeWindow  | string | No | TimeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.. |
|  enableBatchedOperations | boolean | No | value that indicates whether server-side batched operations are enabled.. |
|  deadLetteringOnMessageExpiration | boolean | No | a value that indicates whether this queue has dead letter support when a message expires. |
|  enableExpress | boolean | No | a value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. |
|  enablePartitioning | boolean | No | value that indicates whether the queue to be partitioned across multiple message brokers is enabled. |
|  isAnonymousAccessible | boolean | No | a value that indicates whether the message is anonymous accessible. |
|  maxDeliveryCount  | integer | No | the maximum delivery count. A message is automatically deadlettered after this number of deliveries. |
|  maxSizeInMegabytes | integer | No | the maximum size of the queue in megabytes, which is the size of memory allocated for the queue. |
|  messageCount  | integer | No | the number of messages in the queue. |
|  countDetails | object | No | [MessageCountDetails object](#MessageCountDetails) |
|  requiresDuplicateDetection | boolean | No | the value indicating if this queue requires duplicate detection. |
|  requiresSession | boolean | No | a value that indicates whether the queue supports the concept of session. |
|  sizeInBytes  | integer | No | the size of the queue in bytes. |
|  status | enum | No | Enumerates the possible values for the status of a messaging entity. - Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown |
|  supportOrdering | boolean | No | a value that indicates whether the queue supports ordering. |
|  updatedAt | string | No | the exact time the message has been updated. |


<a id="namespaces_queues_authorizationRules_childResource" />
### namespaces_queues_authorizationRules_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | authorizationRules |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | No | data center location. |
|  properties | object | Yes | [SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties) |


<a id="MessageCountDetails" />
### MessageCountDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  activeMessageCount | integer | No | Number of active messages in the queue, topic, or subscription. |
|  deadLetterMessageCount | integer | No | Number of messages that are dead letters. |
|  scheduledMessageCount | integer | No | Number scheduled messages. |
|  transferDeadLetterMessageCount | integer | No | Number of messages transferred into dead letters. |
|  transferMessageCount | integer | No | Number of messages transferred to another queue, topic, or subscription. |


<a id="SharedAccessAuthorizationRuleProperties" />
### SharedAccessAuthorizationRuleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  rights | array | Yes | The rights associated with the rule. - Manage, Send, Listen |

