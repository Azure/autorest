# Microsoft.ServiceBus/namespaces/topics template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.ServiceBus/namespaces/topics resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.ServiceBus/namespaces/topics",
  "apiVersion": "2015-08-01",
  "name": "string",
  "location": "string",
  "properties": {
    "accessedAt": "string",
    "autoDeleteOnIdle": "string",
    "entityAvailabilityStatus ": "string",
    "createdAt": "string",
    "countDetails": {
      "activeMessageCount": "integer",
      "deadLetterMessageCount": "integer",
      "scheduledMessageCount": "integer",
      "transferDeadLetterMessageCount": "integer",
      "transferMessageCount": "integer"
    },
    "defaultMessageTimeToLive": "string",
    "duplicateDetectionHistoryTimeWindow ": "string",
    "enableBatchedOperations": boolean,
    "enableExpress": boolean,
    "enablePartitioning": boolean,
    "enableSubscriptionPartitioning": boolean,
    "filteringMessagesBeforePublishing": boolean,
    "isAnonymousAccessible": boolean,
    "isExpress": boolean,
    "maxSizeInMegabytes": "integer",
    "requiresDuplicateDetection": boolean,
    "sizeInBytes": "integer",
    "status": "string",
    "subscriptionCount": "integer",
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

<a id="Microsoft.ServiceBus/namespaces/topics" />
### Microsoft.ServiceBus/namespaces/topics object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.ServiceBus/namespaces/topics |
|  apiVersion | enum | Yes | 2015-08-01 |
|  name | string | No | Topic name. |
|  location | string | Yes | Location of the resource. |
|  properties | object | Yes | [TopicProperties object](#TopicProperties) |
|  resources | array | No | [namespaces_topics_subscriptions_childResource object](#namespaces_topics_subscriptions_childResource) [namespaces_topics_authorizationRules_childResource object](#namespaces_topics_authorizationRules_childResource) |


<a id="TopicProperties" />
### TopicProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  accessedAt | string | No | Last time the message was sent or a request was received for this topic. |
|  autoDeleteOnIdle | string | No | TimeSpan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes. |
|  entityAvailabilityStatus  | enum | No | Entity availability status for the topic. - Available, Limited, Renaming, Restoring, Unknown |
|  createdAt | string | No | Exact time the message was created. |
|  countDetails | object | No | [MessageCountDetails object](#MessageCountDetails) |
|  defaultMessageTimeToLive | string | No | Default message time to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
|  duplicateDetectionHistoryTimeWindow  | string | No | TimeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.. |
|  enableBatchedOperations | boolean | No | Value that indicates whether server-side batched operations are enabled.. |
|  enableExpress | boolean | No | Value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. |
|  enablePartitioning | boolean | No | Value that indicates whether the topic to be partitioned across multiple message brokers is enabled. |
|  enableSubscriptionPartitioning | boolean | No | Value that indicates whether partitioning is enabled or disabled.. |
|  filteringMessagesBeforePublishing | boolean | No | Whether messages should be filtered before publishing. |
|  isAnonymousAccessible | boolean | No | Value that indicates whether the message is anonymous accessible. |
|  isExpress | boolean | No |  |
|  maxSizeInMegabytes | integer | No | Maximum size of the topic in megabytes, which is the size of memory allocated for the topic. |
|  requiresDuplicateDetection | boolean | No | Value indicating if this topic requires duplicate detection. |
|  sizeInBytes | integer | No | Size of the topic in bytes. |
|  status | enum | No | Enumerates the possible values for the status of a messaging entity. - Active, Creating, Deleting, Disabled, ReceiveDisabled, Renaming, Restoring, SendDisabled, Unknown |
|  subscriptionCount | integer | No | Number of subscriptions. |
|  supportOrdering | boolean | No | Value that indicates whether the topic supports ordering. |
|  updatedAt | string | No | The exact time the message has been updated. |


<a id="namespaces_topics_subscriptions_childResource" />
### namespaces_topics_subscriptions_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | subscriptions |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | Yes | Subscription data center location. |
|  properties | object | Yes | [SubscriptionProperties object](#SubscriptionProperties) |


<a id="namespaces_topics_authorizationRules_childResource" />
### namespaces_topics_authorizationRules_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | authorizationRules |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | No | data center location. |
|  name | string | No | Name of the AuthorizationRule. |
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


<a id="SharedAccessAuthorizationRuleProperties" />
### SharedAccessAuthorizationRuleProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  rights | array | Yes | The rights associated with the rule. - Manage, Send, Listen |

