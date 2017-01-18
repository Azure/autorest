# Microsoft.ServiceBus/namespaces/topics/subscriptions template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.ServiceBus/namespaces/topics/subscriptions resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ServiceBus/namespaces/topics/subscriptions",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "accessedAt": "string",
    "autoDeleteOnIdle": "string",
    "countDetails": {
      "activeMessageCount": "integer",
      "deadLetterMessageCount": "integer",
      "scheduledMessageCount": "integer",
      "transferDeadLetterMessageCount": "integer",
      "transferMessageCount": "integer"
    },
    "createdAt": "string",
    "defaultMessageTimeToLive": "string",
    "deadLetteringOnFilterEvaluationExceptions": boolean,
    "deadLetteringOnMessageExpiration": boolean,
    "enableBatchedOperations": boolean,
    "entityAvailabilityStatus": "string",
    "isReadOnly": boolean,
    "lockDuration": "string",
    "maxDeliveryCount": "integer",
    "messageCount": "integer",
    "requiresSession": boolean,
    "status": "string",
    "updatedAt": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ServiceBus/namespaces/topics/subscriptions" />
### Microsoft.ServiceBus/namespaces/topics/subscriptions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ServiceBus/namespaces/topics/subscriptions |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | Yes | Subscription data center location. |
|  properties | object | Yes | [SubscriptionProperties object](#SubscriptionProperties) |


<a id="SubscriptionProperties" />
### SubscriptionProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  accessedAt | string | No | Last time a there was a receive request to this subscription. |
|  autoDeleteOnIdle | string | No | TimeSpan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes. |
|  countDetails | object | No | [MessageCountDetails object](#MessageCountDetails) |
|  createdAt | string | No | Exact time the message was created. |
|  defaultMessageTimeToLive | string | No | Default message time to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
|  deadLetteringOnFilterEvaluationExceptions | boolean | No | Value that indicates if a subscription has dead letter support on Filter evaluation exceptions. |
|  deadLetteringOnMessageExpiration | boolean | No | Value that indicates if a subscription has dead letter support when a message expires. |
|  enableBatchedOperations | boolean | No | Value that indicates whether server-side batched operations are enabled.. |
|  entityAvailabilityStatus | enum | No | Entity availability status for the topic. - Available, Limited, Renaming, Restoring, Unknown |
|  isReadOnly | boolean | No | Value that indicates whether the entity description is read-only. |
|  lockDuration | string | No | The lock duration time span for the subscription. |
|  maxDeliveryCount | integer | No | Number of maximum deliveries. |
|  messageCount | integer | No | Number of messages. |
|  requiresSession | boolean | No | Value indicating if a subscription supports the concept of session. |
|  status | enum | No | Enumerates the possible values for the status of a messaging entity. - Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown |
|  updatedAt | string | No | The exact time the message has been updated. |


<a id="MessageCountDetails" />
### MessageCountDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  activeMessageCount | integer | No | Number of active messages in the queue, topic, or subscription. |
|  deadLetterMessageCount | integer | No | Number of messages that are dead letters. |
|  scheduledMessageCount | integer | No | Number scheduled messages. |
|  transferDeadLetterMessageCount | integer | No | Number of messages transferred into dead letters. |
|  transferMessageCount | integer | No | Number of messages transferred to another queue, topic, or subscription. |

