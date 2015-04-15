/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.utils;

/**
 * Defines constants for use with blob operations, HTTP headers, and query
 * strings.
 */
public final class Constants {
    /**
     * Defines constants for use Analytics requests.
     */
    public static class AnalyticsConstants {
        /**
         * The XML element for the Analytics RetentionPolicy Days.
         */
        public static final String DAYS_ELEMENT = "Days";

        /**
         * The XML element for the Default Service Version.
         */
        public static final String DEFAULT_SERVICE_VERSION = "DefaultServiceVersion";

        /**
         * The XML element for the Analytics Logging Delete type.
         */
        public static final String DELETE_ELEMENT = "Delete";

        /**
         * The XML element for the Analytics RetentionPolicy Enabled.
         */
        public static final String ENABLED_ELEMENT = "Enabled";

        /**
         * The XML element for the Analytics Metrics IncludeAPIs.
         */
        public static final String INCLUDE_APIS_ELEMENT = "IncludeAPIs";

        /**
         * The XML element for the Analytics Logging
         */
        public static final String LOGGING_ELEMENT = "Logging";

        /**
         * The XML element for the Analytics Metrics
         */
        public static final String METRICS_ELEMENT = "Metrics";

        /**
         * The XML element for the Analytics Logging Read type.
         */
        public static final String READ_ELEMENT = "Read";

        /**
         * The XML element for the Analytics RetentionPolicy.
         */
        public static final String RETENTION_POLICY_ELEMENT = "RetentionPolicy";

        /**
         * The XML element for the StorageServiceProperties
         */
        public static final String STORAGE_SERVICE_PROPERTIES_ELEMENT = "StorageServiceProperties";

        /**
         * The XML element for the Analytics Version
         */
        public static final String VERSION_ELEMENT = "Version";

        /**
         * The XML element for the Analytics Logging Write type.
         */
        public static final String WRITE_ELEMENT = "Write";
    }

    /**
     * Defines constants for use with HTTP headers.
     */
    public static class HeaderConstants {
        /**
         * The Accept header.
         */
        public static final String ACCEPT = "Accept";

        /**
         * The Accept header.
         */
        public static final String ACCEPT_CHARSET = "Accept-Charset";

        /**
         * The Authorization header.
         */
        public static final String AUTHORIZATION = "Authorization";

        /**
         * The CacheControl header.
         */
        public static final String CACHE_CONTROL = "Cache-Control";

        /**
         * The header that specifies blob caching control.
         */
        public static final String CACHE_CONTROL_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "blob-cache-control";

        /**
         * The Comp value.
         */
        public static final String COMP = "comp";

        /**
         * The ContentEncoding header.
         */
        public static final String CONTENT_ENCODING = "Content-Encoding";

        /**
         * The ContentLangauge header.
         */
        public static final String CONTENT_LANGUAGE = "Content-Language";

        /**
         * The ContentLength header.
         */
        public static final String CONTENT_LENGTH = "Content-Length";

        /**
         * The ContentMD5 header.
         */
        public static final String CONTENT_MD5 = "Content-MD5";

        /**
         * The ContentRange header.
         */
        public static final String CONTENT_RANGE = "Cache-Range";

        /**
         * The ContentType header.
         */
        public static final String CONTENT_TYPE = "Content-Type";

        /**
         * The header for copy source.
         */
        public static final String COPY_SOURCE_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "copy-source";

        /**
         * The header that specifies the date.
         */
        public static final String DATE = PREFIX_FOR_STORAGE_HEADER + "date";

        /**
         * The header to delete snapshots.
         */
        public static final String DELETE_SNAPSHOT_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "delete-snapshots";

        /**
         * The ETag header.
         */
        public static final String ETAG = "ETag";

        /**
         * Buffer width used to copy data to output streams.
         */
        public static final int HTTP_UNUSED_306 = 306;

        /**
         * The IfMatch header.
         */
        public static final String IF_MATCH = "If-Match";

        /**
         * The IfModifiedSince header.
         */
        public static final String IF_MODIFIED_SINCE = "If-Modified-Since";

        /**
         * The IfNoneMatch header.
         */
        public static final String IF_NONE_MATCH = "If-None-Match";

        /**
         * The IfUnmodifiedSince header.
         */
        public static final String IF_UNMODIFIED_SINCE = "If-Unmodified-Since";

        /**
         * The header that specifies lease ID.
         */
        public static final String LEASE_ID_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "lease-id";

        /**
         * The header that specifies lease status.
         */
        public static final String LEASE_STATUS = PREFIX_FOR_STORAGE_HEADER
                + "lease-status";

        /**
         * The header that specifies lease state.
         */
        public static final String LEASE_STATE = PREFIX_FOR_STORAGE_HEADER
                + "lease-state";

        /**
         * The header that specifies lease duration.
         */
        public static final String LEASE_DURATION = PREFIX_FOR_STORAGE_HEADER
                + "lease-duration";

        /**
         * The header that specifies copy status.
         */
        public static final String COPY_STATUS = PREFIX_FOR_STORAGE_HEADER
                + "copy-status";

        /**
         * The header that specifies copy progress.
         */
        public static final String COPY_PROGRESS = PREFIX_FOR_STORAGE_HEADER
                + "copy-progress";

        /**
         * The header that specifies copy status description.
         */
        public static final String COPY_STATUS_DESCRIPTION = PREFIX_FOR_STORAGE_HEADER
                + "copy-status-description";

        /**
         * The header that specifies copy id.
         */
        public static final String COPY_ID = PREFIX_FOR_STORAGE_HEADER
                + "copy-id";

        /**
         * The header that specifies copy source.
         */
        public static final String COPY_SOURCE = PREFIX_FOR_STORAGE_HEADER
                + "copy-source";

        /**
         * The header that specifies copy completion time.
         */
        public static final String COPY_COMPLETION_TIME = PREFIX_FOR_STORAGE_HEADER
                + "copy-completion-time";

        /**
         * The header prefix for metadata.
         */
        public static final String PREFIX_FOR_STORAGE_METADATA = "x-ms-meta-";

        /**
         * The header prefix for properties.
         */
        public static final String PREFIX_FOR_STORAGE_PROPERTIES = "x-ms-prop-";

        /**
         * The Range header.
         */
        public static final String RANGE = "Range";

        /**
         * The header that specifies if the request will populate the ContentMD5
         * header for range gets.
         */
        public static final String RANGE_GET_CONTENT_MD5 = PREFIX_FOR_STORAGE_HEADER
                + "range-get-content-md5";

        /**
         * The format string for specifying ranges.
         */
        public static final String RANGE_HEADER_FORMAT = "bytes=%d-%d";

        /**
         * The header that indicates the request ID.
         */
        public static final String REQUEST_ID_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "request-id";

        /**
         * The header that indicates the client request ID.
         */
        public static final String CLIENT_REQUEST_ID_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "client-request-id";

        /**
         * The header for the If-Match condition.
         */
        public static final String SOURCE_IF_MATCH_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "source-if-match";

        /**
         * The header for the If-Modified-Since condition.
         */
        public static final String SOURCE_IF_MODIFIED_SINCE_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "source-if-modified-since";

        /**
         * The header for the If-None-Match condition.
         */
        public static final String SOURCE_IF_NONE_MATCH_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "source-if-none-match";

        /**
         * The header for the If-Unmodified-Since condition.
         */
        public static final String SOURCE_IF_UNMODIFIED_SINCE_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "source-if-unmodified-since";

        /**
         * The header for the source lease id.
         */
        public static final String SOURCE_LEASE_ID_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "source-lease-id";

        /**
         * The header for data ranges.
         */
        public static final String STORAGE_RANGE_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "range";

        /**
         * The header for storage version.
         */
        public static final String STORAGE_VERSION_HEADER = PREFIX_FOR_STORAGE_HEADER
                + "version";

        /**
         * The current storage version header value.
         */
        public static final String TARGET_STORAGE_VERSION = "2012-02-12";

        /**
         * The UserAgent header.
         */
        public static final String USER_AGENT = "User-Agent";

        /**
         * Specifies the value to use for UserAgent header.
         */
        public static final String USER_AGENT_PREFIX = "WA-Storage";

        /**
         * Specifies the value to use for UserAgent header.
         */
        public static final String USER_AGENT_VERSION = "Client v0.1.3.2";
    }

    /**
     * Defines constants for use with query strings.
     */
    public static class QueryConstants {
        /**
         * The query component for the SAS signature.
         */
        public static final String SIGNATURE = "sig";

        /**
         * The query component for the signed SAS expiry time.
         */
        public static final String SIGNED_EXPIRY = "se";

        /**
         * The query component for the signed SAS identifier.
         */
        public static final String SIGNED_IDENTIFIER = "si";

        /**
         * The query component for the signed SAS permissions.
         */
        public static final String SIGNED_PERMISSIONS = "sp";

        /**
         * The query component for the signed SAS resource.
         */
        public static final String SIGNED_RESOURCE = "sr";

        /**
         * The query component for the signed SAS start time.
         */
        public static final String SIGNED_START = "st";

        /**
         * The query component for the SAS start partition key.
         */
        public static final String START_PARTITION_KEY = "spk";

        /**
         * The query component for the SAS start row key.
         */
        public static final String START_ROW_KEY = "srk";

        /**
         * The query component for the SAS end partition key.
         */
        public static final String END_PARTITION_KEY = "epk";

        /**
         * The query component for the SAS end row key.
         */
        public static final String END_ROW_KEY = "erk";

        /**
         * The query component for the SAS table name.
         */
        public static final String SAS_TABLE_NAME = "tn";

        /**
         * The query component for the signing SAS key.
         */
        public static final String SIGNED_KEY = "sk";

        /**
         * The query component for the signed SAS version.
         */
        public static final String SIGNED_VERSION = "sv";

        /**
         * The query component for snapshot time.
         */
        public static final String SNAPSHOT = "snapshot";
    }

    /**
     * The master Windows Azure Storage header prefix.
     */
    public static final String PREFIX_FOR_STORAGE_HEADER = "x-ms-";

    /**
     * Constant representing a kilobyte (Non-SI version).
     */
    public static final int KB = 1024;

    /**
     * Constant representing a megabyte (Non-SI version).
     */
    public static final int MB = 1024 * KB;

    /**
     * Constant representing a gigabyte (Non-SI version).
     */
    public static final int GB = 1024 * MB;

    /**
     * Buffer width used to copy data to output streams.
     */
    public static final int BUFFER_COPY_LENGTH = 8 * KB;

    /**
     * Default client side timeout, in milliseconds, for all service clients.
     */
    public static final int DEFAULT_TIMEOUT_IN_MS = 90 * 1000;

    /**
     * XML element for delimiters.
     */
    public static final String DELIMITER_ELEMENT = "Delimiter";

    /**
     * An empty <code>String</code> to use for comparison.
     */
    public static final String EMPTY_STRING = "";

    /**
     * XML element for page range end elements.
     */
    public static final String END_ELEMENT = "End";

    /**
     * XML element for error codes.
     */
    public static final String ERROR_CODE = "Code";

    /**
     * XML element for exception details.
     */
    public static final String ERROR_EXCEPTION = "ExceptionDetails";

    /**
     * XML element for exception messages.
     */
    public static final String ERROR_EXCEPTION_MESSAGE = "ExceptionMessage";

    /**
     * XML element for stack traces.
     */
    public static final String ERROR_EXCEPTION_STACK_TRACE = "StackTrace";

    /**
     * XML element for error messages.
     */
    public static final String ERROR_MESSAGE = "Message";

    /**
     * XML root element for errors.
     */
    public static final String ERROR_ROOT_ELEMENT = "Error";

    /**
     * XML element for the ETag.
     */
    public static final String ETAG_ELEMENT = "Etag";

    /**
     * Constant for False.
     */
    public static final String FALSE = "false";

    /**
     * Specifies HTTP.
     */
    public static final String HTTP = "http";

    /**
     * Specifies HTTPS.
     */
    public static final String HTTPS = "https";

    /**
     * XML attribute for IDs.
     */
    public static final String ID = "Id";

    /**
     * XML element for an invalid metadata name.
     */
    public static final String INVALID_METADATA_NAME = "x-ms-invalid-name";

    /**
     * XML element for the last modified date.
     */
    public static final String LAST_MODIFIED_ELEMENT = "Last-Modified";

    /**
     * XML element for the lease status.
     */
    public static final String LEASE_STATUS_ELEMENT = "LeaseStatus";

    /**
     * XML element for the lease state.
     */
    public static final String LEASE_STATE_ELEMENT = "LeaseState";

    /**
     * XML element for the lease duration.
     */
    public static final String LEASE_DURATION_ELEMENT = "LeaseDuration";

    /**
     * XML element for the copy id.
     */
    public static final String COPY_ID_ELEMENT = "CopyId";

    /**
     * XML element for the copy status.
     */
    public static final String COPY_STATUS_ELEMENT = "CopyStatus";

    /**
     * XML element for the copy source .
     */
    public static final String COPY_SOURCE_ELEMENT = "CopySource";

    /**
     * XML element for the copy progress.
     */
    public static final String COPY_PROGRESS_ELEMENT = "CopyProgress";

    /**
     * XML element for the copy completion time.
     */
    public static final String COPY_COMPLETION_TIME_ELEMENT = "CopyCompletionTime";

    /**
     * XML element for the copy status description.
     */
    public static final String COPY_STATUS_DESCRIPTION_ELEMENT = "CopyStatusDescription";

    /**
     * Constant signaling the resource is locked.
     */
    public static final String LOCKED_VALUE = "Locked";

    /**
     * XML element for a marker.
     */
    public static final String MARKER_ELEMENT = "Marker";

    /**
     * XML element for maximum results.
     */
    public static final String MAX_RESULTS_ELEMENT = "MaxResults";

    /**
     * Number of default concurrent requests for parallel operation.
     */
    public static final int MAXIMUM_SEGMENTED_RESULTS = 5000;

    /**
     * The maximum size, in bytes, of a given stream mark operation.
     */
    // Note if BlobConstants.MAX_SINGLE_UPLOAD_BLOB_SIZE_IN_BYTES is updated
    // then this needs to be as well.
    public static final int MAX_MARK_LENGTH = 64 * MB;

    /**
     * XML element for the metadata.
     */
    public static final String METADATA_ELEMENT = "Metadata";

    /**
     * XML element for names.
     */
    public static final String NAME_ELEMENT = "Name";

    /**
     * XML element for the next marker.
     */
    public static final String NEXT_MARKER_ELEMENT = "NextMarker";

    /**
     * XML element for a prefix.
     */
    public static final String PREFIX_ELEMENT = "Prefix";

    /**
     * Constant for True.
     */
    public static final String TRUE = "true";

    /**
     * Constant signaling the resource is unlocked.
     */
    public static final String UNLOCKED_VALUE = "Unlocked";

    /**
     * XML element for the URL.
     */
    public static final String URL_ELEMENT = "Url";

    /**
     * XML element for a signed identifier.
     */
    public static final String SIGNED_IDENTIFIER_ELEMENT = "SignedIdentifier";

    /**
     * XML element for signed identifiers.
     */
    public static final String SIGNED_IDENTIFIERS_ELEMENT = "SignedIdentifiers";

    /**
     * XML element for an access policy.
     */
    public static final String ACCESS_POLICY = "AccessPolicy";

    /**
     * Maximum number of shared access policy identifiers supported by server.
     */
    public static final int MAX_SHARED_ACCESS_POLICY_IDENTIFIERS = 5;

    /**
     * XML element for the start time of an access policy.
     */
    public static final String START = "Start";

    /**
     * XML element for the end time of an access policy.
     */
    public static final String EXPIRY = "Expiry";

    /**
     * XML element for the permission of an access policy.
     */
    public static final String PERMISSION = "Permission";

    /**
     * Private Default Ctor
     */
    private Constants() {
        // No op
    }
}
