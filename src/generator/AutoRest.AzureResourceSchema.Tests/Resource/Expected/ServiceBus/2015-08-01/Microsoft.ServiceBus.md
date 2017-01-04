# Microsoft.ServiceBus template schema

Creates a Microsoft.ServiceBus resource.

## Schema format

To create a Microsoft.ServiceBus, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.ServiceBus/namespaces",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "provisioningState": "string",
    "status": "string",
    "createdAt": "string",
    "updatedAt": "string",
    "serviceBusEndpoint": "string",
    "createACSNamespace": "boolean",
    "enabled": "boolean"
  }
}
```
```
{
  "type": "Microsoft.ServiceBus/namespaces/AuthorizationRules",
  "apiVersion": "2015-08-01",
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
```
{
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
    "enableBatchedOperations": "boolean",
    "deadLetteringOnMessageExpiration": "boolean",
    "enableExpress": "boolean",
    "enablePartitioning": "boolean",
    "isAnonymousAccessible": "boolean",
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
    "requiresDuplicateDetection": "boolean",
    "requiresSession": "boolean",
    "sizeInBytes ": "integer",
    "status": "string",
    "supportOrdering": "boolean",
    "updatedAt": "string"
  }
}
```
```
{
  "type": "Microsoft.ServiceBus/namespaces/queues/authorizationRules",
  "apiVersion": "2015-08-01",
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
```
{
  "type": "Microsoft.ServiceBus/namespaces/topics",
  "apiVersion": "2015-08-01",
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
    "enableBatchedOperations": "boolean",
    "enableExpress": "boolean",
    "enablePartitioning": "boolean",
    "enableSubscriptionPartitioning": "boolean",
    "filteringMessagesBeforePublishing": "boolean",
    "isAnonymousAccessible": "boolean",
    "isExpress": "boolean",
    "maxSizeInMegabytes": "integer",
    "requiresDuplicateDetection": "boolean",
    "sizeInBytes": "integer",
    "status": "string",
    "subscriptionCount": "integer",
    "supportOrdering": "boolean",
    "updatedAt": "string"
  }
}
```
```
{
  "type": "Microsoft.ServiceBus/namespaces/topics/authorizationRules",
  "apiVersion": "2015-08-01",
  "properties": {
    "rights": [
      "string"
    ]
  }
}
```
```
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
    "deadLetteringOnFilterEvaluationExceptions": "boolean",
    "deadLetteringOnMessageExpiration": "boolean",
    "enableBatchedOperations": "boolean",
    "entityAvailabilityStatus": "string",
    "isReadOnly": "boolean",
    "lockDuration": "string",
    "maxDeliveryCount": "integer",
    "messageCount": "integer",
    "requiresSession": "boolean",
    "status": "string",
    "updatedAt": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="namespaces" />
## namespaces object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | Yes | string<br /><br />Namespace location. |
|  sku | No | object<br />[Sku object](#Sku)<br /> |
|  tags | No | object<br /><br />Namespace tags. |
|  properties | Yes | object<br />[NamespaceProperties object](#NamespaceProperties)<br /> |
|  resources | No | array<br />[topics object](#topics)<br />[queues object](#queues)<br />[AuthorizationRules object](#AuthorizationRules)<br /> |


<a id="namespaces_AuthorizationRules" />
## namespaces_AuthorizationRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces/AuthorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />data center location. |
|  name | No | string<br /><br />Name of the AuthorizationRule. |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /> |


<a id="namespaces_queues" />
## namespaces_queues object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces/queues**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  name | No | string<br /><br />Queue name. |
|  location | Yes | string<br /><br />location of the resource. |
|  properties | Yes | object<br />[QueueProperties object](#QueueProperties)<br /> |
|  resources | No | array<br />[authorizationRules object](#authorizationRules)<br /> |


<a id="namespaces_queues_authorizationRules" />
## namespaces_queues_authorizationRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces/queues/authorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />data center location. |
|  name | No | string<br /><br />Name of the AuthorizationRule. |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /> |


<a id="namespaces_topics" />
## namespaces_topics object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces/topics**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  name | No | string<br /><br />Topic name. |
|  location | Yes | string<br /><br />Location of the resource. |
|  properties | Yes | object<br />[TopicProperties object](#TopicProperties)<br /> |
|  resources | No | array<br />[subscriptions object](#subscriptions)<br />[authorizationRules object](#authorizationRules)<br /> |


<a id="namespaces_topics_authorizationRules" />
## namespaces_topics_authorizationRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces/topics/authorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />data center location. |
|  name | No | string<br /><br />Name of the AuthorizationRule. |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /> |


<a id="namespaces_topics_subscriptions" />
## namespaces_topics_subscriptions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ServiceBus/namespaces/topics/subscriptions**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | Yes | string<br /><br />Subscription data center location. |
|  properties | Yes | object<br />[SubscriptionProperties object](#SubscriptionProperties)<br /> |


<a id="Sku" />
## Sku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Basic**, **Standard**, **Premium**<br /><br />Name of this Sku. |
|  tier | Yes | enum<br />**Basic**, **Standard**, **Premium**<br /><br />The tier of this particular SKU. |
|  capacity | No | integer<br /><br />The messaging units for the tier specified |


<a id="NamespaceProperties" />
## NamespaceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  provisioningState | No | string<br /><br />Provisioning state of the Namespace. |
|  status | No | enum<br />**Unknown**, **Creating**, **Created**, **Activating**, **Enabling**, **Active**, **Disabling**, **Disabled**, **SoftDeleting**, **SoftDeleted**, **Removing**, **Removed**, **Failed**<br /><br />State of the namespace. |
|  createdAt | No | string<br /><br />The time the namespace was created. |
|  updatedAt | No | string<br /><br />The time the namespace was updated. |
|  serviceBusEndpoint | No | string<br /><br />Endpoint you can use to perform ServiceBus operations. |
|  createACSNamespace | No | boolean<br /><br />Indicates whether to create ACS namespace. |
|  enabled | No | boolean<br /><br />Specifies whether this instance is enabled. |


<a id="SharedAccessAuthorizationRuleProperties" />
## SharedAccessAuthorizationRuleProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  rights | Yes | array<br />**Manage**, **Send**, **Listen**<br /><br />The rights associated with the rule. |


<a id="QueueProperties" />
## QueueProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  lockDuration  | No | string<br /><br />the duration of a peek lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
|  accessedAt | No | string<br /><br />Last time a message was sent, or the last time there was a receive request to this queue. |
|  autoDeleteOnIdle | No | string<br /><br />the TimeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes. |
|  entityAvailabilityStatus  | No | enum<br />**Available**, **Limited**, **Renaming**, **Restoring**, **Unknown**<br /><br />Entity availability status for the queue. |
|  createdAt | No | string<br /><br />the exact time the message was created. |
|  defaultMessageTimeToLive | No | string<br /><br />the default message time to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
|  duplicateDetectionHistoryTimeWindow  | No | string<br /><br />TimeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.. |
|  enableBatchedOperations | No | boolean<br /><br />value that indicates whether server-side batched operations are enabled.. |
|  deadLetteringOnMessageExpiration | No | boolean<br /><br />a value that indicates whether this queue has dead letter support when a message expires. |
|  enableExpress | No | boolean<br /><br />a value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. |
|  enablePartitioning | No | boolean<br /><br />value that indicates whether the queue to be partitioned across multiple message brokers is enabled. |
|  isAnonymousAccessible | No | boolean<br /><br />a value that indicates whether the message is anonymous accessible. |
|  maxDeliveryCount  | No | integer<br /><br />the maximum delivery count. A message is automatically deadlettered after this number of deliveries. |
|  maxSizeInMegabytes | No | integer<br /><br />the maximum size of the queue in megabytes, which is the size of memory allocated for the queue. |
|  messageCount  | No | integer<br /><br />the number of messages in the queue. |
|  countDetails | No | object<br />[MessageCountDetails object](#MessageCountDetails)<br /> |
|  requiresDuplicateDetection | No | boolean<br /><br />the value indicating if this queue requires duplicate detection. |
|  requiresSession | No | boolean<br /><br />a value that indicates whether the queue supports the concept of session. |
|  sizeInBytes  | No | integer<br /><br />the size of the queue in bytes. |
|  status | No | enum<br />**Active**, **Creating**, **Deleting**, **Disabled**, **ReceiveDisabled**, **Renaming**, **Restoring**, **SendDisabled**, **Unknown**<br /><br />Enumerates the possible values for the status of a messaging entity. |
|  supportOrdering | No | boolean<br /><br />a value that indicates whether the queue supports ordering. |
|  updatedAt | No | string<br /><br />the exact time the message has been updated. |


<a id="MessageCountDetails" />
## MessageCountDetails object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  activeMessageCount | No | integer<br /><br />Number of active messages in the queue, topic, or subscription. |
|  deadLetterMessageCount | No | integer<br /><br />Number of messages that are dead letters. |
|  scheduledMessageCount | No | integer<br /><br />Number scheduled messages. |
|  transferDeadLetterMessageCount | No | integer<br /><br />Number of messages transferred into dead letters. |
|  transferMessageCount | No | integer<br /><br />Number of messages transferred to another queue, topic, or subscription. |


<a id="TopicProperties" />
## TopicProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  accessedAt | No | string<br /><br />Last time the message was sent or a request was received for this topic. |
|  autoDeleteOnIdle | No | string<br /><br />TimeSpan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes. |
|  entityAvailabilityStatus  | No | enum<br />**Available**, **Limited**, **Renaming**, **Restoring**, **Unknown**<br /><br />Entity availability status for the topic. |
|  createdAt | No | string<br /><br />Exact time the message was created. |
|  countDetails | No | object<br />[MessageCountDetails object](#MessageCountDetails)<br /> |
|  defaultMessageTimeToLive | No | string<br /><br />Default message time to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
|  duplicateDetectionHistoryTimeWindow  | No | string<br /><br />TimeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.. |
|  enableBatchedOperations | No | boolean<br /><br />Value that indicates whether server-side batched operations are enabled.. |
|  enableExpress | No | boolean<br /><br />Value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. |
|  enablePartitioning | No | boolean<br /><br />Value that indicates whether the topic to be partitioned across multiple message brokers is enabled. |
|  enableSubscriptionPartitioning | No | boolean<br /><br />Value that indicates whether partitioning is enabled or disabled.. |
|  filteringMessagesBeforePublishing | No | boolean<br /><br />Whether messages should be filtered before publishing. |
|  isAnonymousAccessible | No | boolean<br /><br />Value that indicates whether the message is anonymous accessible. |
|  isExpress | No | boolean<br /> |
|  maxSizeInMegabytes | No | integer<br /><br />Maximum size of the topic in megabytes, which is the size of memory allocated for the topic. |
|  requiresDuplicateDetection | No | boolean<br /><br />Value indicating if this topic requires duplicate detection. |
|  sizeInBytes | No | integer<br /><br />Size of the topic in bytes. |
|  status | No | enum<br />**Active**, **Creating**, **Deleting**, **Disabled**, **ReceiveDisabled**, **Renaming**, **Restoring**, **SendDisabled**, **Unknown**<br /><br />Enumerates the possible values for the status of a messaging entity. |
|  subscriptionCount | No | integer<br /><br />Number of subscriptions. |
|  supportOrdering | No | boolean<br /><br />Value that indicates whether the topic supports ordering. |
|  updatedAt | No | string<br /><br />The exact time the message has been updated. |


<a id="SubscriptionProperties" />
## SubscriptionProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  accessedAt | No | string<br /><br />Last time a there was a receive request to this subscription. |
|  autoDeleteOnIdle | No | string<br /><br />TimeSpan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes. |
|  countDetails | No | object<br />[MessageCountDetails object](#MessageCountDetails)<br /> |
|  createdAt | No | string<br /><br />Exact time the message was created. |
|  defaultMessageTimeToLive | No | string<br /><br />Default message time to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
|  deadLetteringOnFilterEvaluationExceptions | No | boolean<br /><br />Value that indicates if a subscription has dead letter support on Filter evaluation exceptions. |
|  deadLetteringOnMessageExpiration | No | boolean<br /><br />Value that indicates if a subscription has dead letter support when a message expires. |
|  enableBatchedOperations | No | boolean<br /><br />Value that indicates whether server-side batched operations are enabled.. |
|  entityAvailabilityStatus | No | enum<br />**Available**, **Limited**, **Renaming**, **Restoring**, **Unknown**<br /><br />Entity availability status for the topic. |
|  isReadOnly | No | boolean<br /><br />Value that indicates whether the entity description is read-only. |
|  lockDuration | No | string<br /><br />The lock duration time span for the subscription. |
|  maxDeliveryCount | No | integer<br /><br />Number of maximum deliveries. |
|  messageCount | No | integer<br /><br />Number of messages. |
|  requiresSession | No | boolean<br /><br />Value indicating if a subscription supports the concept of session. |
|  status | No | enum<br />**Active**, **Creating**, **Deleting**, **Disabled**, **ReceiveDisabled**, **Renaming**, **Restoring**, **SendDisabled**, **Unknown**<br /><br />Enumerates the possible values for the status of a messaging entity. |
|  updatedAt | No | string<br /><br />The exact time the message has been updated. |


<a id="namespaces_topics_subscriptions_childResource" />
## namespaces_topics_subscriptions_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**subscriptions**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | Yes | string<br /><br />Subscription data center location. |
|  properties | Yes | object<br />[SubscriptionProperties object](#SubscriptionProperties)<br /> |


<a id="namespaces_topics_authorizationRules_childResource" />
## namespaces_topics_authorizationRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**authorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />data center location. |
|  name | No | string<br /><br />Name of the AuthorizationRule. |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /> |


<a id="namespaces_topics_childResource" />
## namespaces_topics_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**topics**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  name | No | string<br /><br />Topic name. |
|  location | Yes | string<br /><br />Location of the resource. |
|  properties | Yes | object<br />[TopicProperties object](#TopicProperties)<br /> |
|  resources | No | array<br />[subscriptions object](#subscriptions)<br />[authorizationRules object](#authorizationRules)<br /> |


<a id="namespaces_queues_authorizationRules_childResource" />
## namespaces_queues_authorizationRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**authorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />data center location. |
|  name | No | string<br /><br />Name of the AuthorizationRule. |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /> |


<a id="namespaces_queues_childResource" />
## namespaces_queues_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**queues**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  name | No | string<br /><br />Queue name. |
|  location | Yes | string<br /><br />location of the resource. |
|  properties | Yes | object<br />[QueueProperties object](#QueueProperties)<br /> |
|  resources | No | array<br />[authorizationRules object](#authorizationRules)<br /> |


<a id="namespaces_AuthorizationRules_childResource" />
## namespaces_AuthorizationRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**AuthorizationRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />data center location. |
|  name | No | string<br /><br />Name of the AuthorizationRule. |
|  properties | Yes | object<br />[SharedAccessAuthorizationRuleProperties object](#SharedAccessAuthorizationRuleProperties)<br /> |

