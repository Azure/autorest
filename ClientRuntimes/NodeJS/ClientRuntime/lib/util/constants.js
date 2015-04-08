// 
// Copyright (c) Microsoft and contributors.  All rights reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 
// See the License for the specific language governing permissions and
// limitations under the License.
// 

// Expose 'HeaderConstants'.
exports = module.exports;

var Constants = {
  /**
  * Constant representing the Odata Error 'message' property
  *
  * @const
  * @type {string}
  */
  ODATA_ERROR_MESSAGE: 'message',
  /**
  * Constant representing the 'value' property of Odata Error 'message' property
  *
  * @const
  * @type {string}
  */
  ODATA_ERROR_MESSAGE_VALUE: 'value',
  /**
  * Constant representing the property where the atom default elements are stored.
  *
  * @const
  * @type {string}
  */
  ATOM_METADATA_MARKER: '_',

  /**
  * Constant representing the atom namespace.
  *
  * @const
  * @type {string}
  */
  ATOM_NAMESPACE: 'http://www.w3.org/2005/Atom',

  /**
  * Constant representing the service bus namespace.
  *
  * @const
  * @type {string}
  */
  SB_NAMESPACE: 'http://schemas.microsoft.com/netservices/2010/10/servicebus/connect',

  /**
  * Constant representing a kilobyte (Non-SI version).
  *
  * @const
  * @type {string}
  */
  KB: 1024,

  /**
  * Constant representing a megabyte (Non-SI version).
  *
  * @const
  * @type {string}
  */
  MB: 1024 * 1024,

  /**
  * Constant representing a gigabyte (Non-SI version).
  *
  * @const
  * @type {string}
  */
  GB: 1024 * 1024 * 1024,

  /**
  * Buffer width used to copy data to output streams.
  *
  * @const
  * @type {string}
  */
  BUFFER_COPY_LENGTH: 8 * 1024,

  /**
  * Default client request time out
  */
  DEFAULT_CLIENT_REQUEST_TIMEOUT : 5 * 60 * 1000,

  /**
  * XML element for an access policy.
  *
  * @const
  * @type {string}
  */
  ACCESS_POLICY: 'AccessPolicy',

  /**
  * XML element for authentication error details.
  *
  * @const
  * @type {string}
  */
  AUTHENTICATION_ERROR_DETAIL: 'AuthenticationErrorDetail',

  /**
  * The changeset response delimiter.
  *
  * @const
  * @type {string}
  */
  CHANGESET_DELIMITER: '--changesetresponse_',

  /**
  * XML element for a blob.
  *
  * @const
  * @type {string}
  */
  BLOB_ELEMENT: 'Blob',

  /**
  * XML element for blob prefixes.
  *
  * @const
  * @type {string}
  */
  BLOB_PREFIX_ELEMENT: 'BlobPrefix',

  /**
  * XML element for blobs.
  *
  * @const
  * @type {string}
  */
  BLOBS_ELEMENT: 'Blobs',

  /**
  * XML element for a blob type.
  *
  * @const
  * @type {string}
  */
  BLOB_TYPE_ELEMENT: 'BlobType',

  /**
  * Constant signaling a block blob.
  *
  * @const
  * @type {string}
  */
  BLOCK_BLOB_VALUE: 'BlockBlob',

  /**
  * XML element for blocks.
  *
  * @const
  * @type {string}
  */
  BLOCK_ELEMENT: 'Block',

  /**
  * XML element for a block list.
  *
  * @const
  * @type {string}
  */
  BLOCK_LIST_ELEMENT: 'BlockList',

  /**
  * XML element for committed blocks.
  *
  * @const
  * @type {string}
  */
  COMMITTED_BLOCKS_ELEMENT: 'CommittedBlocks',

  /**
  * XML element for committed blocks.
  *
  * @const
  * @type {string}
  */
  COMMITTED_ELEMENT: 'Committed',

  /**
  * XML element for a container.
  *
  * @const
  * @type {string}
  */
  CONTAINER_ELEMENT: 'Container',

  /**
  * XML element for containers.
  *
  * @const
  * @type {string}
  */
  CONTAINERS_ELEMENT: 'Containers',

  /**
  * XML element for a queue.
  *
  * @const
  * @type {string}
  */
  QUEUE_ELEMENT: 'Queue',

  /**
  * XML element for queues.
  *
  * @const
  * @type {string}
  */
  QUEUES_ELEMENT: 'Queues',

  /**
  * XML element for QueueMessagesList.
  *
  * @const
  * @type {string}
  */
  QUEUE_MESSAGES_LIST_ELEMENT: 'QueueMessagesList',

  /**
  * XML element for QueueMessage.
  *
  * @const
  * @type {string}
  */
  QUEUE_MESSAGE_ELEMENT: 'QueueMessage',

  /**
  * The Uri path component to access the messages in a queue.
  *
  * @const
  * @type {string}
  */
  Messages: 'messages',

  /**
  * XML element for MessageId.
  *
  * @const
  * @type {string}
  */
  MESSAGE_ID_ELEMENT: 'MessageId',

  /**
  * XML element for InsertionTime.
  *
  * @const
  * @type {string}
  */
  INSERTION_TIME_ELEMENT: 'InsertionTime',

  /**
  * XML element for ExpirationTime.
  *
  * @const
  * @type {string}
  */
  EXPIRATION_TIME_ELEMENT: 'ExpirationTime',

  /**
  * XML element for PopReceipt.
  *
  * @const
  * @type {string}
  */
  POP_RECEIPT_ELEMENT: 'PopReceipt',

  /**
  * XML element for TimeNextVisible.
  *
  * @const
  * @type {string}
  */
  TIME_NEXT_VISIBLE_ELEMENT: 'TimeNextVisible',

  /**
  * XML element for DequeueCount.
  *
  * @const
  * @type {string}
  */
  DEQUEUE_COUNT_ELEMENT: 'DequeueCount',

  /**
  * XML element for MessageText.
  *
  * @const
  * @type {string}
  */
  MESSAGE_TEXT_ELEMENT: 'MessageText',

  /**
  * Default client side timeout, in milliseconds, for all service clients.
  *
  * @const
  * @type {int}
  */
  DEFAULT_TIMEOUT_IN_MS: 90 * 1000,

  /**
  * XML element for delimiters.
  *
  * @const
  * @type {string}
  */
  DELIMITER_ELEMENT: 'Delimiter',

  /**
  * An empty <code>String</code> to use for comparison.
  *
  * @const
  * @type {string}
  */
  EMPTY_STRING: '',

  /**
  * XML element for page range end elements.
  *
  * @const
  * @type {string}
  */
  END_ELEMENT: 'End',

  /**
  * XML element for error codes.
  *
  * @const
  * @type {string}
  */
  ERROR_CODE: 'Code',

  /**
  * XML element for exception details.
  *
  * @const
  * @type {string}
  */
  ERROR_EXCEPTION: 'ExceptionDetails',

  /**
  * XML element for exception messages.
  *
  * @const
  * @type {string}
  */
  ERROR_EXCEPTION_MESSAGE: 'ExceptionMessage',

  /**
  * XML element for stack traces.
  *
  * @const
  * @type {string}
  */
  ERROR_EXCEPTION_STACK_TRACE: 'StackTrace',

  /**
  * XML element for error messages.
  *
  * @const
  * @type {string}
  */
  ERROR_MESSAGE: 'Message',

  /**
  * XML root element for errors.
  *
  * @const
  * @type {string}
  */
  ERROR_ROOT_ELEMENT: 'Error',

  /**
  * XML element for the ETag.
  *
  * @const
  * @type {string}
  */
  ETAG_ELEMENT: 'Etag',

  /**
  * XML element for the end time of an access policy.
  *
  * @const
  * @type {string}
  */
  EXPIRY: 'Expiry',

  /**
  * Specifies HTTP.
  *
  * @const
  * @type {string}
  */
  HTTP: 'http:',

  /**
  * Specifies HTTPS.
  *
  * @const
  * @type {string}
  */
  HTTPS: 'https:',

  /**
  * XML attribute for IDs.
  *
  * @const
  * @type {string}
  */
  ID: 'Id',

  /**
  * XML element for an invalid metadata name.
  *
  * @const
  * @type {string}
  */
  INVALID_METADATA_NAME: 'x-ms-invalid-name',

  /**
  * XML element for the last modified date.
  *
  * @const
  * @type {string}
  */
  LAST_MODIFIED_ELEMENT: 'Last-Modified',

  /**
  * XML element for the laassert.
  *
  * @const
  * @type {string}
  */
  LATEST_ELEMENT: 'Latest',

  /**
  * XML element for the lease status.
  *
  * @const
  * @type {string}
  */
  LEASE_STATUS_ELEMENT: 'LeaseStatus',

  /**
  * Constant signaling the blob is locked.
  *
  * @const
  * @type {string}
  */
  LOCKED_VALUE: 'Locked',

  /**
  * XML element for a marker.
  *
  * @const
  * @type {string}
  */
  MARKER_ELEMENT: 'Marker',

  /**
  * Number of default concurrent requests for parallel operation.
  *
  * @const
  * @type {int}
  */
  MAXIMUM_SEGMENTED_RESULTS: 5000,

  /**
  * XML element for maximum results.
  *
  * @const
  * @type {string}
  */
  MAX_RESULTS_ELEMENT: 'MaxResults',

  /**
  * Maximum number of shared access policy identifiers supported by server.
  *
  * @const
  * @type {string}
  */
  MAX_SHARED_ACCESS_POLICY_IDENTIFIERS: 5,

  /**
  * The URI path part to access the messages in a queue.
  *
  * @const
  * @type {string}
  */
  MESSAGES: 'messages',

  /**
  * XML element for the metadata.
  *
  * @const
  * @type {string}
  */
  METADATA_ELEMENT: 'Metadata',

  /**
  * XML element for names.
  *
  * @const
  * @type {string}
  */
  NAME_ELEMENT: 'Name',

  /**
  * XML element for the next marker.
  *
  * @const
  * @type {string}
  */
  NEXT_MARKER_ELEMENT: 'NextMarker',

  /**
  * Constant signaling a page blob.
  *
  * @const
  * @type {string}
  */
  PAGE_BLOB_VALUE: 'PageBlob',

  /**
  * XML element for page list elements.
  *
  * @const
  * @type {string}
  */
  PAGE_LIST_ELEMENT: 'PageList',

  /**
  * XML element for a page range.
  *
  * @const
  * @type {string}
  */
  PAGE_RANGE_ELEMENT: 'PageRange',

  /**
  * XML element for the permission of an access policy.
  *
  * @const
  * @type {string}
  */
  PERMISSION: 'Permission',

  /**
  * XML element for a prefix.
  *
  * @const
  * @type {string}
  */
  PREFIX_ELEMENT: 'Prefix',

  /**
  * XML element for properties.
  *
  * @const
  * @type {string}
  */
  PROPERTIES: 'Properties',

  /**
  * XML element for a signed identifier.
  *
  * @const
  * @type {string}
  */
  SIGNED_IDENTIFIER_ELEMENT: 'SignedIdentifier',

  /**
  * XML element for signed identifiers.
  *
  * @const
  * @type {string}
  */
  SIGNED_IDENTIFIERS_ELEMENT: 'SignedIdentifiers',

  /**
  * XML element for storage service properties.
  *
  * @const
  * @type {string}
  */
  STORAGE_SERVICE_PROPERTIES_ELEMENT: 'StorageServiceProperties',

  /**
  * XML element for logging.
  *
  * @const
  * @type {string}
  */
  LOGGING_ELEMENT: 'Logging',

  /**
  * XML element for version.
  *
  * @const
  * @type {string}
  */
  VERSION_ELEMENT: 'Version',

  /**
  * XML element for delete.
  *
  * @const
  * @type {string}
  */
  DELETE_ELEMENT: 'Delete',

  /**
  * XML element for read.
  *
  * @const
  * @type {string}
  */
  READ_ELEMENT: 'Read',

  /**
  * XML element for write.
  *
  * @const
  * @type {string}
  */
  WRITE_ELEMENT: 'Write',

  /**
  * XML element for retention policy.
  *
  * @const
  * @type {string}
  */
  RETENTION_POLICY_ELEMENT: 'RetentionPolicy',

  /**
  * XML element for enabled.
  *
  * @const
  * @type {string}
  */
  ENABLED_ELEMENT: 'Enabled',

  /**
  * XML element for days.
  *
  * @const
  * @type {string}
  */
  DAYS_ELEMENT: 'Days',

  /**
  * XML element for Metrics.
  *
  * @const
  * @type {string}
  */
  METRICS_ELEMENT: 'Metrics',

  /**
  * XML element for IncludeAPIs.
  *
  * @const
  * @type {string}
  */
  INCLUDE_APIS_ELEMENT: 'IncludeAPIs',

  /**
  * XML element for DefaultServiceVersion.
  *
  * @const
  * @type {string}
  */
  DEFAULT_SERVICE_VERSION_ELEMENT: 'DefaultServiceVersion',

  /**
  * XML element for the block length.
  *
  * @const
  * @type {string}
  */
  SIZE_ELEMENT: 'Size',

  /**
  * XML element for a snapshot.
  *
  * @const
  * @type {string}
  */
  SNAPSHOT_ELEMENT: 'Snapshot',

  /**
  * XML element for the start time of an access policy.
  *
  * @const
  * @type {string}
  */
  START: 'Start',

  /**
  * XML element for page range start elements.
  *
  * @const
  * @type {string}
  */
  START_ELEMENT: 'Start',

  /**
  * XML element for uncommitted blocks.
  *
  * @const
  * @type {string}
  */
  UNCOMMITTED_BLOCKS_ELEMENT: 'UncommittedBlocks',

  /**
  * XML element for uncommitted blocks.
  *
  * @const
  * @type {string}
  */
  UNCOMMITTED_ELEMENT: 'Uncommitted',

  /**
  * Constant signaling the blob is unlocked.
  *
  * @const
  * @type {string}
  */
  UNLOCKED_VALUE: 'Unlocked',

  /**
  * XML element for the URL.
  *
  * @const
  * @type {string}
  */
  URL_ELEMENT: 'Url',

  /**
  * Marker for atom metadata.
  *
  * @const
  * @type {string}
  */
  XML_METADATA_MARKER: '$',

  /**
  * Marker for atom value.
  *
  * @const
  * @type {string}
  */
  XML_VALUE_MARKER: '_',

  /**
  * Marker for atom title tag.
  *
  * @const
  * @type {string}
  */
  ATOM_TITLE_MARKER: 'title',

  /**
  * Marker for atom updated tag.
  *
  * @const
  * @type {string}
  */
  ATOM_UPDATED_MARKER: 'updated',

  /**
  * Marker for atom author tag.
  *
  * @const
  * @type {string}
  */
  ATOM_AUTHOR_MARKER: 'author',

  /**
  * Marker for atom id tag.
  *
  * @const
  * @type {string}
  */
  ATOM_ID_MARKER: 'id',

  /**
  * Marker for atom content tag.
  *
  * @const
  * @type {string}
  */
  ATOM_CONTENT_MARKER: 'content',

  /**
  * Marker for atom properties tag.
  *
  * @const
  * @type {string}
  */
  ATOM_PROPERTIES_MARKER: 'properties',

  /**
  * Marker for atom queue description.
  *
  * @const
  * @type {string}
  */
  ATOM_QUEUE_DESCRIPTION_MARKER: 'QueueDescription',

  /**
  * Marker for atom topic description.
  *
  * @const
  * @type {string}
  */
  ATOM_TOPIC_DESCRIPTION_MARKER: 'TopicDescription',

  /**
  * Marker for atom rule description.
  *
  * @const
  * @type {string}
  */
  ATOM_RULE_DESCRIPTION_MARKER: 'RuleDescription',

  /**
  * Marker for atom subscription description.
  *
  * @const
  * @type {string}
  */
  ATOM_SUBSCRIPTION_DESCRIPTION_MARKER: 'SubscriptionDescription',

  /**
  * The development store URI.
  *
  * @const
  * @type {string}
  */
  DEV_STORE_URI: 'http://127.0.0.1',

  DEV_STORE_BLOB_HOST: '127.0.0.1:10000',

  DEV_STORE_QUEUE_HOST: '127.0.0.1:10001',

  DEV_STORE_TABLE_HOST: '127.0.0.1:10002',

  /**
  * The development store account name.
  *
  * @const
  * @type {string}
  */
  DEV_STORE_NAME: 'devstoreaccount1',

  /**
  * The development store account key.
  *
  * @const
  * @type {string}
  */
  DEV_STORE_KEY: 'Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==',

  /**
  * The service management URI.
  *
  * @const
  * @type {string}
  */
  SERVICE_MANAGEMENT_URL: 'https://management.core.windows.net',

  /**
  * Defines constants for use with blob operations.
  */
  BlobConstants: {
    /**
    * The number of default concurrent requests for parallel operation.
    *
    * @const
    * @type {string}
    */
    DEFAULT_CONCURRENT_REQUEST_COUNT: 1,

    /**
    * The default delimiter used to create a virtual directory structure of blobs.
    *
    * @const
    * @type {string}
    */
    DEFAULT_DELIMITER: '/',

    /**
    * The default write pages size, in bytes, used by blob stream for page blobs.
    *
    * @const
    * @type {string}
    */
    DEFAULT_MINIMUM_PAGE_STREAM_WRITE_IN_BYTES: 4 * 1024 * 1024,

    /**
    * The default write page size, in bytes, used by blob streams.
    *
    * @const
    * @type {string}
    */
    DEFAULT_WRITE_PAGE_SIZE_IN_BYTES: 4 * 1024 * 1024,

    /**
    * Max size for single get page range. The max value should be 150MB
    * http://blogs.msdn.com/b/windowsazurestorage/archive/2012/03/26/getting-the-page-ranges-of-a-large-page-blob-in-segments.aspx
    */
    MAX_SINGLE_GET_PAGE_RANGE_SIZE : 37 * 4 * 1024 * 1024,

    /**
    * The default minimum read size, in bytes, for streams.
    *
    * @const
    * @type {string}
    */
    DEFAULT_MINIMUM_READ_SIZE_IN_BYTES: 4 * 1024 * 1024,

    /**
    * The default maximum size, in bytes, of a blob before it must be separated into blocks.
    *
    * @const
    * @type {string}
    */
    DEFAULT_SINGLE_BLOB_PUT_THRESHOLD_IN_BYTES: 32 * 1024 * 1024,

    /**
    * The default write block size, in bytes, used by blob streams.
    *
    * @const
    * @type {string}
    */
    DEFAULT_WRITE_BLOCK_SIZE_IN_BYTES: 4 * 1024 * 1024,

    /**
    * The maximum size, in bytes, of a blob before it must be separated into blocks.
    *
    * @const
    * @type {string}
    */
    MAX_SINGLE_UPLOAD_BLOB_SIZE_IN_BYTES: 64 * 1024 * 1024,

    /**
    * The maximun size, in bytes, of write disk buffer
    */
    MAX_QUEUED_WRITE_DISK_BUFFER_SIZE : 100 * 1024 * 1024,

    /**
    * The size of a page, in bytes, in a page blob.
    *
    * @const
    * @type {string}
    */
    PAGE_SIZE: 512,

    /**
    * The service runtime major number for the minimum version requirement.
    *
    * @const
    * @type {int}
    */
    SERVICERUNTIME_MIN_VERSION_MAJOR: 6,

    /**
    * The service runtime minor number for the minimum version requirement.
    *
    * @const
    * @type {int}
    */
    SERVICERUNTIME_MIN_VERSION_MINOR: 11,

    /**
    * Blobs and container public access types.
    *
    * @const
    * @enum {string}
    */
    BlobContainerPublicAccessType: {
      OFF: null,
      CONTAINER: 'container',
      BLOB: 'blob'
    },

    ResourceTypeProperty: 'ResourceTypeProperty',

    /**
    * Resource types.
    *
    * @const
    * @enum {string}
    */
    ResourceTypes: {
      CONTAINER: 'c',
      BLOB: 'b'
    },

    SharedAccessPermissionProperty: 'SharedAccessPermissionProperty',

    /**
    * Permission types
    *
    * @const
    * @enum {string}
    */
    SharedAccessPermissions: {
      READ: 'r',
      WRITE: 'w',
      DELETE: 'd',
      LIST: 'l'
    },

    DEFAULT_PARALLEL_OPERATION_COUNT: 1,

    /**
    * Blobs listing details.
    *
    * @const
    * @enum {string}
    */
    BlobListingDetails: {
      SNAPSHOTS: 'snapshots',
      METADATA: 'metadata',
      UNCOMMITTEDBLOBS: 'uncommittedblobs'
    },

    /**
    * Blob types
    *
    * @const
    * @enum {string}
    */
    BlobTypes: {
      BLOCK: 'BlockBlob',
      PAGE: 'PageBlob'
    },

    /**
    * Type of block list to retrieve
    *
    * @const
    * @enum {string}
    */
    BlockListFilter: {
      ALL: 'all',
      COMMITTED: 'committed',
      UNCOMMITTED: 'uncommitted'
    },

    /**
    * Blob lease constants
    *
    * @const
    * @enum {string}
    */
    LeaseOperation: {
      ACQUIRE: 'acquire',
      RENEW: 'renew',
      RELEASE: 'release',
      BREAK: 'break'
    },

    /**
    * Put page write options
    *
    * @const
    * @enum {string}
    */
    PageWriteOptions: {
      UPDATE: 'update',
      CLEAR: 'clear'
    }
  },

  /**
  * Defines constants for use with table storage.
  *
  * @const
  * @type {string}
  */
  TableConstants: {
    /**
    * The next continuation row key token.
    *
    * @const
    * @type {string}
    */
    CONTINUATION_NEXT_ROW_KEY: 'x-ms-continuation-nextrowkey',

    /**
    * The next continuation partition key token.
    *
    * @const
    * @type {string}
    */
    CONTINUATION_NEXT_PARTITION: 'x-ms-continuation-nextpartitionkey',

    /**
    * The next continuation table name token.
    *
    * @const
    * @type {string}
    */
    CONTINUATION_NEXT_TABLE_NAME: 'x-ms-continuation-nexttablename',

    /**
    * The next table name query string argument.
    *
    * @const
    * @type {string}
    */
    NEXT_TABLE_NAME: 'NextTableName'
  },

  /**
  * Defines constants for use with service bus.
  *
  * @const
  * @type {string}
  */
  ServiceBusConstants: {
    /**
    * The maximum size in megabytes.
    *
    * @const
    * @type {string}
    */
    MAX_SIZE_IN_MEGABYTES: 'MaxSizeInMegabytes',

    /**
    * The default message time to live.
    *
    * @const
    * @type {string}
    */
    DEFAULT_MESSAGE_TIME_TO_LIVE: 'DefaultMessageTimeToLive',

    /**
    * The lock duration.
    *
    * @const
    * @type {string}
    */
    LOCK_DURATION: 'LockDuration',

    /**
    * The indication if session is required or not.
    *
    * @const
    * @type {string}
    */
    REQUIRES_SESSION: 'RequiresSession',

    /**
    * The indication if duplicate detection is required or not.
    *
    * @const
    * @type {string}
    */
    REQUIRES_DUPLICATE_DETECTION: 'RequiresDuplicateDetection',

    /**
    * The indication if dead lettering on message expiration.
    *
    * @const
    * @type {string}
    */
    DEAD_LETTERING_ON_MESSAGE_EXPIRATION: 'DeadLetteringOnMessageExpiration',

    /**
    * The indication if dead lettering on filter evaluation exceptions.
    *
    * @const
    * @type {string}
    */
    DEAD_LETTERING_ON_FILTER_EVALUATION_EXCEPTIONS: 'DeadLetteringOnFilterEvaluationExceptions',

    /**
    * The history time window for duplicate detection.
    *
    * @const
    * @type {string}
    */
    DUPLICATE_DETECTION_HISTORY_TIME_WINDOW: 'DuplicateDetectionHistoryTimeWindow',

    /**
    * The maximum number of subscriptions per topic.
    *
    * @const
    * @type {string}
    */
    MAX_SUBSCRIPTIONS_PER_TOPIC: 'MaxSubscriptionsPerTopic',

    /**
    * The maximum amount of sql filters per topic.
    *
    * @const
    * @type {string}
    */
    MAX_SQL_FILTERS_PER_TOPIC: 'MaxSqlFiltersPerTopic',

    /**
    * The maximum amount of correlation filters per topic.
    *
    * @const
    * @type {string}
    */
    MAX_CORRELATION_FILTERS_PER_TOPIC: 'MaxCorrelationFiltersPerTopic',

    /**
    * The maximum delivery count.
    *
    * @const
    * @type {string}
    */
    MAX_DELIVERY_COUNT: 'MaxDeliveryCount',

    /**
    * Indicates if the queue has enabled batch operations.
    *
    * @const
    * @type {string}
    */
    ENABLE_BATCHED_OPERATIONS: 'EnableBatchedOperations',

    /**
    * Indicates the default rule description.
    *
    * @const
    * @type {string}
    */
    DEFAULT_RULE_DESCRIPTION: 'DefaultRuleDescription',

    /**
    * The queue's size in bytes.
    *
    * @const
    * @type {string}
    */
    SIZE_IN_BYTES: 'SizeInBytes',

    /**
    * The queue's message count.
    *
    * @const
    * @type {string}
    */
    MESSAGE_COUNT: 'MessageCount',

    /**
    * The default rule name.
    *
    * @const
    * @type {string}
    */
    DEFAULT_RULE_NAME: '$Default',

    /**
    * The wrap access token.
    *
    * @const
    * @type {string}
    */
    WRAP_ACCESS_TOKEN: 'wrap_access_token',

    /**
    * The wrap access token expires utc.
    *
    * @const
    * @type {string}
    */
    WRAP_ACCESS_TOKEN_EXPIRES_UTC: 'wrap_access_token_expires_utc',

    /**
    * The wrap access token expires in.
    *
    * @const
    * @type {string}
    */
    WRAP_ACCESS_TOKEN_EXPIRES_IN: 'wrap_access_token_expires_in',

    /**
    * Max idle time before entity is deleted
    *
    * @const
    * @type {string}
    */
    AUTO_DELETE_ON_IDLE: 'AutoDeleteOnIdle',

    /**
    * Query string parameter to set Service Bus API version
    *
    * @const
    * @type {string}
    */
    API_VERSION_QUERY_KEY: 'api-version',

    /**
    * Current API version being sent to service bus
    *
    * @const
    * @type {string}
    */
    CURRENT_API_VERSION: '2013-07'
  },

  /**
  * Defines constants for use with Service Runtime.
  *
    * @const
    * @type {string}
    */
  ServiceRuntimeConstants: {
    /**
    * The fault domain property.
    *
    * @const
    * @type {string}
    */
    FAULT_DOMAIN: 'faultDomain',

    /**
    * The update domain property.
    *
    * @const
    * @type {string}
    */
    UPDATE_DOMAIN: 'updateDomain',

    /**
    * The runtime server discovery element.
    *
    * @const
    * @type {string}
    */
    RUNTIME_SERVER_DISCOVERY: 'RuntimeServerDiscovery',

    /**
    * The runtime server endpoints element.
    *
    * @const
    * @type {string}
    */
    RUNTIME_SERVER_ENDPOINTS: 'RuntimeServerEndpoints',

    /**
    * The runtime server endpoint element.
    *
    * @const
    * @type {string}
    */
    RUNTIME_SERVER_ENDPOINT: 'RuntimeServerEndpoint',

    /**
    * The goal state element.
    *
    * @const
    * @type {string}
    */
    GOAL_STATE: 'GoalState',

    /**
    * The role environment element.
    *
    * @const
    * @type {string}
    */
    ROLE_ENVIRONMENT: 'RoleEnvironment',

    /**
    * The current instance element.
    *
    * @const
    * @type {string}
    */
    CURRENT_INSTANCE: 'CurrentInstance',

    /**
    * The configuration settings element.
    *
    * @const
    * @type {string}
    */
    CONFIGURATION_SETTINGS: 'ConfigurationSettings',

    /**
    * The configuration setting element.
    *
    * @const
    * @type {string}
    */
    CONFIGURATION_SETTING: 'ConfigurationSetting',

    /**
    * The local resources element.
    *
    * @const
    * @type {string}
    */
    LOCAL_RESOURCES: 'LocalResources',

    /**
    * The local resource element.
    *
    * @const
    * @type {string}
    */
    LOCAL_RESOURCE: 'LocalResource',

    /**
    * The deployment element.
    *
    * @const
    * @type {string}
    */
    DEPLOYMENT: 'Deployment',

    /**
    * The emulated element.
    *
    * @const
    * @type {string}
    */
    EMULATED: 'emulated',

    /**
    * The id element.
    *
    * @const
    * @type {string}
    */
    DEPLOYMENT_ID: 'id',

    /**
    * The endpoints element.
    *
    * @const
    * @type {string}
    */
    ENDPOINTS: 'Endpoints',

    /**
    * The endpoint element.
    *
    * @const
    * @type {string}
    */
    ENDPOINT: 'Endpoint',

    /**
    * The roles element.
    *
    * @const
    * @type {string}
    */
    ROLES: 'Roles',

    /**
    * The role element.
    *
    * @const
    * @type {string}
    */
    ROLE: 'Role',

    /**
    * The instances element.
    *
    * @const
    * @type {string}
    */
    INSTANCES: 'Instances',

    /**
    * The instance element.
    *
    * @const
    * @type {string}
    */
    INSTANCE: 'Instance',

    /**
    * The role environment path element.
    *
    * @const
    * @type {string}
    */
    ROLE_ENVIRONMENT_PATH: 'RoleEnvironmentPath',

    /**
    * The role environment changed event.
    *
    * @const
    * @type {string}
    */
    CHANGED: 'changed',

    /**
    * The role environment changing event.
    *
    * @const
    * @type {string}
    */
    CHANGING: 'changing',

    /**
    * The role environment stopping event.
    *
    * @const
    * @type {string}
    */
    STOPPING: 'stopping',

    /**
    * The ready event.
    *
    * @const
    * @type {string}
    */
    READY: 'ready',

    /**
    * The expected state element.
    *
    * @const
    * @type {string}
    */
    EXPECTED_STATE: 'ExpectedState',

    /**
    * The incarnation element.
    *
    * @const
    * @type {string}
    */
    INCARNATION: 'Incarnation',

    /**
    * The current state endpoint element.
    *
    * @const
    * @type {string}
    */
    CURRENT_STATE_ENDPOINT: 'CurrentStateEndpoint',

    /**
    * The deadline element.
    *
    * @const
    * @type {string}
    */
    DEADLINE: 'Deadline',

    /**
    * The current state element.
    *
    * @const
    * @type {string}
    */
    CURRENT_STATE: 'CurrentState',

    /**
    * The status lease element.
    *
    * @const
    * @type {string}
    */
    STATUS_LEASE: 'StatusLease',

    /**
    * The status lease element.
    *
    * @const
    * @type {string}
    */
    STATUS: 'Status',

    /**
    * The status detail element.
    *
    * @const
    * @type {string}
    */
    STATUS_DETAIL: 'StatusDetail',

    /**
    * The expiration element.
    *
    * @const
    * @type {string}
    */
    EXPIRATION: 'Expiration',

    /**
    * The client identifier element.
    *
    * @const
    * @type {string}
    */
    CLIENT_ID: 'ClientId',

    /**
    * The acquire element.
    *
    * @const
    * @type {string}
    */
    ACQUIRE: 'Acquire',

    /**
    * The release element.
    *
    * @const
    * @type {string}
    */
    RELEASE: 'Release',

    /**
    * The different role instance target statuses.
    *
    * @const
    * @type {string}
    */
    RoleInstanceStatus: {
      /**
      * The ready status.
      *
      * @const
      * @type {string}
      */
      READY: 'Ready',

      /**
      * The busy status.
      *
      * @const
      * @type {string}
      */
      BUSY: 'Busy'
    },

    /**
    * The different role statuses.
    *
    * @const
    * @type {string}
    */
    RoleStatus: {
      /**
      * The started event.
      *
      * @const
      * @type {string}
      */
      STARTED: 'Started',

      /**
      * The stopped event.
      *
      * @const
      * @type {string}
      */
      STOPPED: 'Stopped',

      /**
      * The busy event.
      *
      * @const
      * @type {string}
      */
      BUSY: 'Busy',

      /**
      * The recycle event.
      *
      * @const
      * @type {string}
      */
      RECYCLE: 'Recycle'
    }
  },

  /**
  * Defines constants for use with HTTP headers.
  */
  HeaderConstants: {
    /**
    * The accept ranges header.
    *
    * @const
    * @type {string}
    */
    ACCEPT_RANGES: 'accept_ranges',

    /**
    * The content transfer encoding header.
    *
    * @const
    * @type {string}
    */
    CONTENT_TRANSFER_ENCODING_HEADER: 'content-transfer-encoding',

    /**
    * The transfer encoding header.
    *
    * @const
    * @type {string}
    */
    TRANSFER_ENCODING_HEADER: 'transfer-encoding',

    /**
    * The server header.
    *
    * @const
    * @type {string}
    */
    SERVER_HEADER: 'server',

    /**
    * The location header.
    *
    * @const
    * @type {string}
    */
    LOCATION_HEADER: 'location',

    /**
    * The Last-Modified header
    *
    * @const
    * @type {string}
    */
    LAST_MODIFIED: 'Last-Modified',

    /**
    * The data service version.
    *
    * @const
    * @type {string}
    */
    DATA_SERVICE_VERSION: 'dataserviceversion',

    /**
    * The maximum data service version.
    *
    * @const
    * @type {string}
    */
    MAX_DATA_SERVICE_VERSION: 'maxdataserviceversion',

    /**
    * The master Microsoft Azure Storage header prefix.
    *
    * @const
    * @type {string}
    */
    PREFIX_FOR_STORAGE_HEADER: 'x-ms-',

    /**
    * The header that specifies the approximate message count of a queue.
    *
    * @const
    * @type {string}
    */
    APPROXIMATE_MESSAGES_COUNT: 'x-ms-approximate-messages-count',

    /**
    * The Authorization header.
    *
    * @const
    * @type {string}
    */
    AUTHORIZATION: 'authorization',

    /**
    * The header that specifies blob content MD5.
    *
    * @const
    * @type {string}
    */
    BLOB_CONTENT_MD5_HEADER: 'x-ms-blob-content-md5',

    /**
    * The header that specifies public access to blobs.
    *
    * @const
    * @type {string}
    */
    BLOB_PUBLIC_ACCESS_HEADER: 'x-ms-blob-public-access',

    /**
    * The header for the blob type.
    *
    * @const
    * @type {string}
    */
    BLOB_TYPE_HEADER: 'x-ms-blob-type',

    /**
    * Specifies the block blob type.
    *
    * @const
    * @type {string}
    */
    BLOCK_BLOB: 'blockblob',

    /**
    * The CacheControl header.
    *
    * @const
    * @type {string}
    */
    CACHE_CONTROL: 'cache-control',

    /**
    * The header that specifies blob caching control.
    *
    * @const
    * @type {string}
    */
    CACHE_CONTROL_HEADER: 'x-ms-blob-cache-control',

    /**
    * The copy status.
    *
    * @const
    * @type {string}
    */
    COPY_STATUS: 'x-ms-copy-status',

    /**
    * The copy completion time
    *
    * @const
    * @type {string}
    */
    COPY_COMPLETION_TIME: 'x-ms-copy-completion-time',

    /**
    * The copy status message
    *
    * @const
    * @type {string}
    */
    COPY_STATUS_DESCRIPTION: 'x-ms-copy-status-description',

    /**
    * The copy identifier.
    *
    * @const
    * @type {string}
    */
    COPY_ID: 'x-ms-copy-id',

    /**
    * Progress of any copy operation
    *
    * @const
    * @type {string}
    */
    COPY_PROGRESS: 'x-ms-copy-progress',

    /**
    * The copy action.
    *
    * @const
    * @type {string}
    */
    COPY_ACTION: 'x-ms-copy-action',

    /**
    * The ContentID header.
    *
    * @const
    * @type {string}
    */
    CONTENT_ID: 'content-id',

    /**
    * The ContentEncoding header.
    *
    * @const
    * @type {string}
    */
    CONTENT_ENCODING: 'content-encoding',

    /**
    * The header that specifies blob content encoding.
    *
    * @const
    * @type {string}
    */
    CONTENT_ENCODING_HEADER: 'x-ms-blob-content-encoding',

    /**
    * The ContentLangauge header.
    *
    * @const
    * @type {string}
    */
    CONTENT_LANGUAGE: 'content-language',

    /**
    * The header that specifies blob content language.
    *
    * @const
    * @type {string}
    */
    CONTENT_LANGUAGE_HEADER: 'x-ms-blob-content-language',

    /**
    * The ContentLength header.
    *
    * @const
    * @type {string}
    */
    CONTENT_LENGTH: 'content-length',

    /**
    * The header that specifies blob content length.
    *
    * @const
    * @type {string}
    */
    CONTENT_LENGTH_HEADER: 'x-ms-blob-content-length',

    /**
    * The ContentMD5 header.
    *
    * @const
    * @type {string}
    */
    CONTENT_MD5: 'content-md5',

    /**
    * The ContentRange header.
    *
    * @const
    * @type {string}
    */
    CONTENT_RANGE: 'cache-range',

    /**
    * The ContentType header.
    *
    * @const
    * @type {string}
    */
    CONTENT_TYPE: 'content-type',

    /**
    * The header that specifies blob content type.
    *
    * @const
    * @type {string}
    */
    CONTENT_TYPE_HEADER: 'x-ms-blob-content-type',

    /**
    * The header for copy source.
    *
    * @const
    * @type {string}
    */
    COPY_SOURCE_HEADER: 'x-ms-copy-source',

    /**
    * The header that specifies the date.
    *
    * @const
    * @type {string}
    */
    DATE: 'date',

    /**
    * The header that specifies the date.
    *
    * @const
    * @type {string}
    */
    DATE_HEADER: 'x-ms-date',

    /**
    * The header to delete snapshots.
    *
    * @const
    * @type {string}
    */
    DELETE_SNAPSHOT_HEADER: 'x-ms-delete-snapshots',

    /**
    * The ETag header.
    *
    * @const
    * @type {string}
    */
    ETAG: 'etag',

    /**
    * The IfMatch header.
    *
    * @const
    * @type {string}
    */
    IF_MATCH: 'if-match',

    /**
    * The IfModifiedSince header.
    *
    * @const
    * @type {string}
    */
    IF_MODIFIED_SINCE: 'if-modified-since',

    /**
    * The IfNoneMatch header.
    *
    * @const
    * @type {string}
    */
    IF_NONE_MATCH: 'if-none-match',

    /**
    * The IfUnmodifiedSince header.
    *
    * @const
    * @type {string}
    */
    IF_UNMODIFIED_SINCE: 'if-unmodified-since',

    /**
    * Specifies snapshots are to be included.
    *
    * @const
    * @type {string}
    */
    INCLUDE_SNAPSHOTS_VALUE: 'include',

    /**
    * The header that specifies lease ID.
    *
    * @const
    * @type {string}
    */
    LEASE_ID_HEADER: 'x-ms-lease-id',

    /**
    * The header that specifies the lease break period.
    *
    * @const
    * @type {string}
    */
    LEASE_BREAK_PERIOD: 'x-ms-lease-break-period',

    /**
    * The header that specifies the proposed lease identifier.
    *
    * @const
    * @type {string}
    */
    PROPOSED_LEASE_ID: 'x-ms-proposed-lease-id',

    /**
    * The header that specifies the lease duration.
    *
    * @const
    * @type {string}
    */
    LEASE_DURATION: 'x-ms-lease-duration',

    /**
    * The header that specifies the source lease ID.
    *
    * @const
    * @type {string}
    */
    SOURCE_LEASE_ID_HEADER: 'x-ms-source-lease-id',

    /**
    * The header that specifies lease time.
    *
    * @const
    * @type {string}
    */
    LEASE_TIME_HEADER: 'x-ms-lease-time',

    /**
    * The header that specifies lease status.
    *
    * @const
    * @type {string}
    */
    LEASE_STATUS: 'x-ms-lease-status',

    /**
    * The header that specifies lease state.
    *
    * @const
    * @type {string}
    */
    LEASE_STATE: 'x-ms-lease-state',

    /**
    * Specifies the page blob type.
    *
    * @const
    * @type {string}
    */
    PAGE_BLOB: 'PageBlob',

    /**
    * The header that specifies page write mode.
    *
    * @const
    * @type {string}
    */
    PAGE_WRITE: 'x-ms-page-write',

    /**
    * The header prefix for metadata.
    *
    * @const
    * @type {string}
    */
    PREFIX_FOR_STORAGE_METADATA: 'x-ms-meta-',

    /**
    * The header prefix for properties.
    *
    * @const
    * @type {string}
    */
    PREFIX_FOR_STORAGE_PROPERTIES: 'x-ms-prop-',

    /**
    * The Range header.
    *
    * @const
    * @type {string}
    */
    RANGE: 'Range',

    /**
    * The header that specifies if the request will populate the ContentMD5 header for range gets.
    *
    * @const
    * @type {string}
    */
    RANGE_GET_CONTENT_MD5: 'x-ms-range-get-content-md5',

    /**
    * The format string for specifying ranges.
    *
    * @const
    * @type {string}
    */
    RANGE_HEADER_FORMAT: 'bytes:%d-%d',

    /**
    * The header that indicates the request ID.
    *
    * @const
    * @type {string}
    */
    REQUEST_ID_HEADER: 'x-ms-request-id',

    /**
    * The header for specifying the sequence number.
    *
    * @const
    * @type {string}
    */
    SEQUENCE_NUMBER: 'x-ms-blob-sequence-number',

    /**
    * The header for the blob content length.
    *
    * @const
    * @type {string}
    */
    SIZE: 'x-ms-blob-content-length',

    /**
    * The header for snapshots.
    *
    * @const
    * @type {string}
    */
    SNAPSHOT_HEADER: 'x-ms-snapshot',

    /**
    * Specifies only snapshots are to be included.
    *
    * @const
    * @type {string}
    */
    SNAPSHOTS_ONLY_VALUE: 'only',

    /**
    * The header for the If-Match condition.
    *
    * @const
    * @type {string}
    */
    SOURCE_IF_MATCH_HEADER: 'x-ms-source-if-match',

    /**
    * The header for the If-Modified-Since condition.
    *
    * @const
    * @type {string}
    */
    SOURCE_IF_MODIFIED_SINCE_HEADER: 'x-ms-source-if-modified-since',

    /**
    * The header for the If-None-Match condition.
    *
    * @const
    * @type {string}
    */
    SOURCE_IF_NONE_MATCH_HEADER: 'x-ms-source-if-none-match',

    /**
    * The header for the If-Unmodified-Since condition.
    *
    * @const
    * @type {string}
    */
    SOURCE_IF_UNMODIFIED_SINCE_HEADER: 'x-ms-source-if-unmodified-since',

    /**
    * The header for data ranges.
    *
    * @const
    * @type {string}
    */
    STORAGE_RANGE_HEADER: 'x-ms-range',

    /**
    * The header for storage version.
    *
    * @const
    * @type {string}
    */
    STORAGE_VERSION_HEADER: 'x-ms-version',

    /**
    * The current storage version header value.
    *
    * @const
    * @type {string}
    */
    TARGET_STORAGE_VERSION: '2011-08-18',

    /**
    * The UserAgent header.
    *
    * @const
    * @type {string}
    */
    USER_AGENT: 'user-agent',

    /**
    * The pop receipt header.
    *
    * @const
    * @type {string}
    */
    POP_RECEIPT_HEADER: 'x-ms-popreceipt',

    /**
    * The time next visibile header.
    *
    * @const
    * @type {string}
    */
    TIME_NEXT_VISIBLE_HEADER: 'x-ms-time-next-visible',

    /**
    * The approximate message counter header.
    *
    * @const
    * @type {string}
    */
    APPROXIMATE_MESSAGE_COUNT_HEADER: 'x-ms-approximate-message-count',

    /**
    * The lease action header.
    *
    * @const
    * @type {string}
    */
    LEASE_ACTION_HEADER: 'x-ms-lease-action',

    /**
    * The accept header.
    *
    * @const
    * @type {string}
    */
    ACCEPT_HEADER: 'accept',

    /**
    * The accept charset header.
    *
    * @const
    * @type {string}
    */
    ACCEPT_CHARSET_HEADER: 'Accept-Charset',

    /**
    * The host header.
    *
    * @const
    * @type {string}
    */
    HOST_HEADER: 'host',

    /**
    * The correlation identifier header.
    *
    * @const
    * @type {string}
    */
    CORRELATION_ID_HEADER: 'x-ms-correlation-id',

    /**
    * The group identifier header.
    *
    * @const
    * @type {string}
    */
    GROUP_ID_HEADER: 'x-ms-group-id',

    /**
    * The label header.
    *
    * @const
    * @type {string}
    */
    LABEL_HEADER: 'x-ms-label',

    /**
    * The reply to header.
    *
    * @const
    * @type {string}
    */
    REPLY_TO_HEADER: 'x-ms-reply_to',

    /**
    * The ttl header.
    *
    * @const
    * @type {string}
    */
    TTL_HEADER: 'x-ms-ttl',

    /**
    * The to header.
    *
    * @const
    * @type {string}
    */
    TO_HEADER: 'x-ms-to',

    /**
    * The scheduled enqueue time header.
    *
    * @const
    * @type {string}
    */
    SCHEDULED_ENQUEUE_TIME_HEADER: 'x-ms-scheduled-enqueue-time',

    /**
    * The broker properties for service bus queue messages.
    *
    * @const
    * @type {string}
    */
    BROKER_PROPERTIES_HEADER: 'brokerproperties',

    /**
    * The service bus notification format header.
    *
    * @const
    * @type {string}
    */
    SERVICE_BUS_NOTIFICATION_FORMAT: 'ServiceBusNotification-Format',

    /**
    * The service bus notification tags header.
    *
    * @const
    * @type {string}
    */
    SERVICE_BUS_NOTIFICATION_TAGS: 'ServiceBusNotification-Tags',

    /**
    * The service bus notification apns expiry.
    *
    * @const
    * @type {string}
    */
    SERVICE_BUS_NOTIFICATION_APNS_EXPIRY: 'ServiceBusNotification-ApnsExpiry',

    /**
    * The service bus notification wns type.
    *
    * @const
    * @type {string}
    */
    SERVICE_BUS_X_WNS_TYPE: 'X-WNS-Type'
  },

  QueryStringConstants: {
    /**
    * The Comp value.
    *
    * @const
    * @type {string}
    */
    COMP: 'comp',

    /**
    * The Res Type.
    *
    * @const
    * @type {string}
    */
    RESTYPE: 'restype',

    /**
    * The Snapshot value.
    *
    * @const
    * @type {string}
    */
    SNAPSHOT: 'snapshot',

    /**
    * The timeout value.
    *
    * @const
    * @type {string}
    */
    TIMEOUT: 'timeout',

    /**
    * The signed start time query string argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNED_START: 'st',

    /**
    * The signed expiry time query string argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNED_EXPIRY: 'se',

    /**
    * The signed resource query string argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNED_RESOURCE: 'sr',

    /**
    * The signed permissions query string argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNED_PERMISSIONS: 'sp',

    /**
    * The signed identifier query string argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNED_IDENTIFIER: 'si',

    /**
    * The signature query string argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNATURE: 'sig',

    /**
    * The signed version argument for shared access signature.
    *
    * @const
    * @type {string}
    */
    SIGNED_VERSION: 'sv',

    /**
    * The block identifier query string argument for blob service.
    *
    * @const
    * @type {string}
    */
    BLOCK_ID: 'blockid',

    /**
    * The block list type query string argument for blob service.
    *
    * @const
    * @type {string}
    */
    BLOCK_LIST_TYPE: 'blocklisttype',

    /**
    * The prefix query string argument for listing operations.
    *
    * @const
    * @type {string}
    */
    PREFIX: 'prefix',

    /**
    * The marker query string argument for listing operations.
    *
    * @const
    * @type {string}
    */
    MARKER: 'marker',

    /**
    * The maxresults query string argument for listing operations.
    *
    * @const
    * @type {string}
    */
    MAX_RESULTS: 'maxresults',

    /**
    * The delimiter query string argument for listing operations.
    *
    * @const
    * @type {string}
    */
    DELIMITER: 'delimiter',

    /**
    * The include query string argument for listing operations.
    *
    * @const
    * @type {string}
    */
    INCLUDE: 'include',

    /**
    * The peekonly query string argument for queue service.
    *
    * @const
    * @type {string}
    */
    PEEK_ONLY: 'peekonly',

    /**
    * The numofmessages query string argument for queue service.
    *
    * @const
    * @type {string}
    */
    NUM_OF_MESSAGES: 'numofmessages',

    /**
    * The popreceipt query string argument for queue service.
    *
    * @const
    * @type {string}
    */
    POP_RECEIPT: 'popreceipt',

    /**
    * The visibilitytimeout query string argument for queue service.
    *
    * @const
    * @type {string}
    */
    VISIBILITY_TIMEOUT: 'visibilitytimeout',

    /**
    * The messagettl query string argument for queue service.
    *
    * @const
    * @type {string}
    */
    MESSAGE_TTL: 'messagettl',

    /**
    * The select query string argument.
    *
    * @const
    * @type {string}
    */
    SELECT: '$select',

    /**
    * The filter query string argument.
    *
    * @const
    * @type {string}
    */
    FILTER: '$filter',

    /**
    * The top query string argument.
    *
    * @const
    * @type {string}
    */
    TOP: '$top',

    /**
    * The skip query string argument.
    *
    * @const
    * @type {string}
    */
    SKIP: '$skip',

    /**
    * The next partition key query string argument for table service.
    *
    * @const
    * @type {string}
    */
    NEXT_PARTITION_KEY: 'NextPartitionKey',

    /**
    * The next row key query string argument for table service.
    *
    * @const
    * @type {string}
    */
    NEXT_ROW_KEY: 'NextRowKey',

    /**
    * The lock identifier for service bus messages.
    *
    * @const
    * @type {string}
    */
    LOCK_ID: 'lockid'
  },

  HttpConstants: {
    /**
    * Http Verbs
    *
    * @const
    * @enum {string}
    */
    HttpVerbs: {
      PUT: 'PUT',
      GET: 'GET',
      DELETE: 'DELETE',
      POST: 'POST',
      MERGE: 'MERGE',
      HEAD: 'HEAD'
    },

    /**
    * Response codes.
    *
    * @const
    * @enum {int}
    */
    HttpResponseCodes: {
      Ok: 200,
      Created: 201,
      Accepted: 202,
      NoContent: 204,
      PartialContent: 206,
      BadRequest: 400,
      Unauthorized: 401,
      Forbidden: 403,
      NotFound: 404,
      Conflict: 409,
      LengthRequired: 411,
      PreconditionFailed: 412
    }
  },

  SqlAzureConstants: {
    SQL_SERVER_MANAGEMENT_COOKIE: '.SQLSERVERMANAGEMENT',
    MANAGEMENT_SERVICE_URI: '/v1/ManagementService.svc/',
    WEB_EDITION: 'Web',
    BUSINESS_EDITION: 'Business',
    WEB_1GB: 1,
    WEB_5GB: 5,
    BUSINESS_10GB: 10,
    BUSINESS_20GB: 20,
    BUSINESS_30GB: 30,
    BUSINESS_40GB: 40,
    BUSINESS_50GB: 50,
    BUSINESS_100GB: 100,
    BUSINESS_150GB: 150,
    DEFAULT_COLLATION_NAME: 'SQL_Latin1_General_CP1_CI_AS'
  },

  BlobErrorCodeStrings: {
    INVALID_BLOCK_ID: 'InvalidBlockId',
    BLOB_NOT_FOUND: 'BlobNotFound',
    BLOB_ALREADY_EXISTS: 'BlobAlreadyExists',
    CONTAINER_ALREADY_EXISTS: 'ContainerAlreadyExists',
    INVALID_BLOB_OR_BLOCK: 'InvalidBlobOrBlock',
    INVALID_BLOCK_LIST: 'InvalidBlockList'
  },

  ServiceBusErrorCodeStrings: {
    QUEUE_NOT_FOUND: 'QueueNotFound',
    TOPIC_NOT_FOUND: 'TopicNotFound',
    SUBSCRIPTION_NOT_FOUND: 'SubscriptionNotFound',
    RULE_NOT_FOUND: 'RuleNotFound',
    NOTIFICATION_HUB_NOT_FOUND: 'NotificationHubNotFound'
  },

  QueueErrorCodeStrings: {
    QUEUE_NOT_FOUND: 'QueueNotFound',
    QUEUE_DISABLED: 'QueueDisabled',
    QUEUE_ALREADY_EXISTS: 'QueueAlreadyExists',
    QUEUE_NOT_EMPTY: 'QueueNotEmpty',
    QUEUE_BEING_DELETED: 'QueueBeingDeleted',
    POP_RECEIPT_MISMATCH: 'PopReceiptMismatch',
    INVALID_PARAMETER: 'InvalidParameter',
    MESSAGE_NOT_FOUND: 'MessageNotFound',
    MESSAGE_TOO_LARGE: 'MessageTooLarge',
    INVALID_MARKER: 'InvalidMarker'
  },

  StorageErrorCodeStrings: {
    UNSUPPORTED_HTTP_VERB: 'UnsupportedHttpVerb',
    MISSING_CONTENT_LENGTH_HEADER: 'MissingContentLengthHeader',
    MISSING_REQUIRED_HEADER: 'MissingRequiredHeader',
    MISSING_REQUIRED_XML_NODE: 'MissingRequiredXmlNode',
    UNSUPPORTED_HEADER: 'UnsupportedHeader',
    UNSUPPORTED_XML_NODE: 'UnsupportedXmlNode',
    INVALID_HEADER_VALUE: 'InvalidHeaderValue',
    INVALID_XML_NODE_VALUE: 'InvalidXmlNodeValue',
    MISSING_REQUIRED_QUERY_PARAMETER: 'MissingRequiredQueryParameter',
    UNSUPPORTED_QUERY_PARAMETER: 'UnsupportedQueryParameter',
    INVALID_QUERY_PARAMETER_VALUE: 'InvalidQueryParameterValue',
    OUT_OF_RANGE_QUERY_PARAMETER_VALUE: 'OutOfRangeQueryParameterValue',
    INVALID_URI: 'InvalidUri',
    INVALID_HTTP_VERB: 'InvalidHttpVerb',
    EMPTY_METADATA_KEY: 'EmptyMetadataKey',
    REQUEST_BODY_TOO_LARGE: 'RequestBodyTooLarge',
    INVALID_XML_DOCUMENT: 'InvalidXmlDocument',
    INTERNAL_ERROR: 'InternalError',
    AUTHENTICATION_FAILED: 'AuthenticationFailed',
    MD5_MISMATCH: 'Md5Mismatch',
    INVALID_MD5: 'InvalidMd5',
    OUT_OF_RANGE_INPUT: 'OutOfRangeInput',
    INVALID_INPUT: 'InvalidInput',
    OPERATION_TIMED_OUT: 'OperationTimedOut',
    RESOURCE_NOT_FOUND: 'ResourceNotFound',
    INVALID_METADATA: 'InvalidMetadata',
    METADATA_TOO_LARGE: 'MetadataTooLarge',
    CONDITION_NOT_MET: 'ConditionNotMet',
    UPDATE_CONDITION_NOT_SATISFIED: 'UpdateConditionNotSatisfied',
    INVALID_RANGE: 'InvalidRange',
    CONTAINER_NOT_FOUND: 'ContainerNotFound',
    CONTAINER_ALREADY_EXISTS: 'ContainerAlreadyExists',
    CONTAINER_DISABLED: 'ContainerDisabled',
    CONTAINER_BEING_DELETED: 'ContainerBeingDeleted',
    SERVER_BUSY: 'ServerBusy'
  },

  TableErrorCodeStrings: {
    XMETHOD_NOT_USING_POST: 'XMethodNotUsingPost',
    XMETHOD_INCORRECT_VALUE: 'XMethodIncorrectValue',
    XMETHOD_INCORRECT_COUNT: 'XMethodIncorrectCount',
    TABLE_HAS_NO_PROPERTIES: 'TableHasNoProperties',
    DUPLICATE_PROPERTIES_SPECIFIED: 'DuplicatePropertiesSpecified',
    TABLE_HAS_NO_SUCH_PROPERTY: 'TableHasNoSuchProperty',
    DUPLICATE_KEY_PROPERTY_SPECIFIED: 'DuplicateKeyPropertySpecified',
    TABLE_ALREADY_EXISTS: 'TableAlreadyExists',
    TABLE_NOT_FOUND: 'TableNotFound',
    ENTITY_NOT_FOUND: 'EntityNotFound',
    ENTITY_ALREADY_EXISTS: 'EntityAlreadyExists',
    PARTITION_KEY_NOT_SPECIFIED: 'PartitionKeyNotSpecified',
    OPERATOR_INVALID: 'OperatorInvalid',
    UPDATE_CONDITION_NOT_SATISFIED: 'UpdateConditionNotSatisfied',
    PROPERTIES_NEED_VALUE: 'PropertiesNeedValue',
    PARTITION_KEY_PROPERTY_CANNOT_BE_UPDATED: 'PartitionKeyPropertyCannotBeUpdated',
    TOO_MANY_PROPERTIES: 'TooManyProperties',
    ENTITY_TOO_LARGE: 'EntityTooLarge',
    PROPERTY_VALUE_TOO_LARGE: 'PropertyValueTooLarge',
    INVALID_VALUE_TYPE: 'InvalidValueType',
    TABLE_BEING_DELETED: 'TableBeingDeleted',
    TABLE_SERVER_OUT_OF_MEMORY: 'TableServerOutOfMemory',
    PRIMARY_KEY_PROPERTY_IS_INVALID_TYPE: 'PrimaryKeyPropertyIsInvalidType',
    PROPERTY_NAME_TOO_LONG: 'PropertyNameTooLong',
    PROPERTY_NAME_INVALID: 'PropertyNameInvalid',
    BATCH_OPERATION_NOT_SUPPORTED: 'BatchOperationNotSupported',
    JSON_FORMAT_NOT_SUPPORTED: 'JsonFormatNotSupported',
    METHOD_NOT_ALLOWED: 'MethodNotAllowed',
    NOT_IMPLEMENTED: 'NotImplemented'
  },

  GeneralErrorCodeStrings: {
    INVALID_CONTENT_TYPE: 'The response content type is invalid'
  },

  ConnectionStringKeys: {
    USE_DEVELOPMENT_STORAGE_NAME: 'UseDevelopmentStorage',
    DEVELOPMENT_STORAGE_PROXY_URI_NAME: 'DevelopmentStorageProxyUri',
    DEFAULT_ENDPOINTS_PROTOCOL_NAME: 'DefaultEndpointsProtocol',
    ACCOUNT_NAME_NAME: 'AccountName',
    ACCOUNT_KEY_NAME: 'AccountKey',
    BLOB_ENDPOINT_NAME: 'BlobEndpoint',
    QUEUE_ENDPOINT_NAME: 'QueueEndpoint',
    TABLE_ENDPOINT_NAME: 'TableEndpoint',
    SHARED_ACCESS_SIGNATURE_NAME: 'SharedAccessSignature',
    BLOB_BASE_DNS_NAME: 'blob.core.windows.net',
    QUEUE_BASE_DNS_NAME: 'queue.core.windows.net',
    TABLE_BASE_DNS_NAME: 'table.core.windows.net',
    DEV_STORE_CONNECTION_STRING: 'BlobEndpoint=127.0.0.1:10000;QueueEndpoint=127.0.0.1:10001;TableEndpoint=127.0.0.1:10002;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==',
    SUBSCRIPTION_ID_NAME: 'SubscriptionID',
    CERTIFICATE_PATH_NAME: 'CertificatePath',
    SERVICE_MANAGEMENT_ENDPOINT_NAME: 'ServiceManagementEndpoint',
    SERVICE_BUS_ENDPOINT_NAME: 'Endpoint',
    WRAP_ENDPOINT_NAME: 'StsEndpoint',
    SHARED_SECRET_ISSUER_NAME: 'SharedSecretIssuer',
    SHARED_SECRET_VALUE_NAME: 'SharedSecretValue',
    SHARED_ACCESS_KEY_NAME: 'SharedAccessKeyName',
    SHARED_ACCESS_KEY: 'SharedAccessKey'
  }
};

module.exports = Constants;
