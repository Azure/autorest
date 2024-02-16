import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace NotificationHubsClient;

/**
 * Deletes a notification hub.
 */
@route("/{hubName}")
@delete
op deleteNotificationHub is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;
  },
  void
>;

/**
 * Retrieves information about a notification hub.
 */
@route("/{hubName}")
@get
op getNotificationHub is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  NotificationHubEntryModel | void
>;

/**
 * Create or update a notification hub.
 */
@route("/{hubName}")
@put
op createOrUpdateNotificationHub is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * ETag as returned by creation, update, and retrieval, or * (overwrite).
     */
    @header
    `If-Match`?: string;

    @body
    body: NotificationHubEntryModel;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  NotificationHubEntryModel | void
>;

/**
 * Retrieves all registrations with a specific tag.
 */
@route("/{hubName}/tags/{tag}/registrations")
@get
op getRegistrationsByTag is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * The path for the tag to query
     */
    @path
    tag: string;

    /**
     * Contains the token to continue the enumeration of registrations, in case there
     * are more.
     */
    @query("ContinuationToken")
    ContinuationToken?: string;

    /**
     * OData top parameter
     */
    @query("$top")
    $top?: string;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  void
>;

/**
 * Create a registration ID
 */
@route("/{hubName}/registrationIDs")
@post
op createRegistrationId is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;
  },
  void
>;

/**
 * Get registrations by the specified criteria
 */
@route("/{hubName}/registrations")
@get
op getRegistrations is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * Contains the token to continue the enumeration of registrations, in case there
     * are more.
     */
    @query("ContinuationToken")
    ContinuationToken?: string;

    /**
     * OData filter parameter
     */
    @query("$filter")
    $filter?: string;

    /**
     * OData top parameter
     */
    @query("$top")
    $top?: string;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  void
>;

/**
 * Creates a registration
 */
@route("/{hubName}/registrations")
@post
op createRegistration is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  RegistrationEntryModel | void
>;

/**
 * Deletes a registration
 */
@route("/{hubName}/registrations/{registrationId}")
@delete
op deleteRegistration is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Registration ID parameter
     */
    @path
    registrationId: string;

    /**
     * ETag as returned by creation, update, and retrieval, or * (overwrite).
     */
    @header
    `If-Match`?: string;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;
  },
  void
>;

/**
 * Get a registration by registration ID
 */
@route("/{hubName}/registrations/{registrationId}")
@get
op getRegistration is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Registration ID parameter
     */
    @path
    registrationId: string;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  RegistrationEntryModel | void
>;

/**
 * Create or update a registration
 */
@route("/{hubName}/registrations/{registrationId}")
@put
op createOrUpdateRegistration is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Registration ID parameter
     */
    @path
    registrationId: string;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    @body
    body: RegistrationEntryModel;

    /**
     * Accept header
     */
    @header
    accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  RegistrationEntryModel | void
>;

/**
 * Delete an installation by ID
 */
@summary("Delete Installation")
@route("/{hubName}/installations/{installationId}")
@delete
op deleteInstallation is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Installation ID parameter
     */
    @path
    installationId: string;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;
  },
  void
>;

/**
 * Get an Installation by Installation ID
 */
op getInstallation is Azure.Core.ResourceRead<
  InstallationModel,
  {
    parameters: {
      /**
       * API Version
       */
      @header
      `x-ms-version`: MSApiVersionType;

      /**
       * Authorization Header value
       */
      @header
      Authorization: string;
    };
  }
>;

/**
 * Azure Notification Hubs supports partial updates to an installation using the
 * JSON-Patch standard in [RFC6902](https://tools.ietf.org/html/rfc6902).
 */
op patchInstallation is Azure.Core.ResourceCreateOrUpdate<
  InstallationModel,
  {
    parameters: {
      /**
       * API Version
       */
      @header
      `x-ms-version`: MSApiVersionType;

      /**
       * Authorization Header value
       */
      @header
      Authorization: string;
    };
  }
>;

/**
 * Creates or overwrites an installation.
 */
op createOrUpdateInstallation is Azure.Core.ResourceCreateOrReplace<
  InstallationModel,
  {
    parameters: {
      /**
       * API Version
       */
      @header
      `x-ms-version`: MSApiVersionType;

      /**
       * Authorization Header value
       */
      @header
      Authorization: string;
    };
  }
>;

/**
 * Sends a notification to the specified targets.
 */
@route("/{hubName}/messages")
@post
op sendMessage is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * Device handle for the PNS
     */
    @header
    `ServiceBusNotification-DeviceHandle`?: string;

    /**
     * Platform type for the notification
     */
    @header
    `ServiceBusNotification-Format`: FormatParameterType;

    /**
     * Notification message tags for targeting
     */
    @header
    `ServiceBusNotification-Tags`?: string;

    /**
     * Direct Send
     */
    @query("direct")
    direct?: boolean;

    /**
     * The apns-topic header
     */
    @header
    `apns-topic`?: string;

    /**
     * The apns-priority header
     */
    @header
    `apns-priority`?: string;

    /**
     * The apns-push-type header
     */
    @header
    `apns-push-type`?: string;

    /**
     *  X-WNS-Cache-Policy header parameter
     */
    @header
    `X-WNS-Cache-Policy`?: string;

    /**
     * X-WNS-PRIORITY header parameter
     */
    @header
    `X-WNS-PRIORITY`?: string;

    /**
     * X-WNS-RequestForStatus header parameter
     */
    @header
    `X-WNS-RequestForStatus`?: string;

    /**
     * X-WNS-Tag header parameter
     */
    @header
    `X-WNS-Tag`?: string;

    /**
     * X-WNS-TTL header parameter
     */
    @header
    `X-WNS-TTL`?: string;

    /**
     * X-WNS-Type header parameter
     */
    @header
    `X-WNS-Type`?: string;

    /**
     * Upload file type
     */
    @header
    `content-type`: ContentType;

    /**
     * The notification message body
     */
    @body
    body: string;
  },
  void
>;

/**
 * Sends a notification to the specified targets.
 */
@route("/{hubName}/messages")
@post
op sendMessage is Azure.Core.Foundations.Operation<
  {
    /**
     * Notification Hub Name
     */
    @path
    hubName: string;

    /**
     * API Version
     */
    @header
    `x-ms-version`: MSApiVersionType;

    /**
     * Authorization Header value
     */
    @header
    Authorization: string;

    /**
     * Device handle for the PNS
     */
    @header
    `ServiceBusNotification-DeviceHandle`?: string;

    /**
     * Platform type for the notification
     */
    @header
    `ServiceBusNotification-Format`: FormatParameterType;

    /**
     * Notification message tags for targeting
     */
    @header
    `ServiceBusNotification-Tags`?: string;

    /**
     * Direct Send
     */
    @query("direct")
    direct?: boolean;

    /**
     * The apns-topic header
     */
    @header
    `apns-topic`?: string;

    /**
     * The apns-priority header
     */
    @header
    `apns-priority`?: string;

    /**
     * The apns-push-type header
     */
    @header
    `apns-push-type`?: string;

    /**
     *  X-WNS-Cache-Policy header parameter
     */
    @header
    `X-WNS-Cache-Policy`?: string;

    /**
     * X-WNS-PRIORITY header parameter
     */
    @header
    `X-WNS-PRIORITY`?: string;

    /**
     * X-WNS-RequestForStatus header parameter
     */
    @header
    `X-WNS-RequestForStatus`?: string;

    /**
     * X-WNS-Tag header parameter
     */
    @header
    `X-WNS-Tag`?: string;

    /**
     * X-WNS-TTL header parameter
     */
    @header
    `X-WNS-TTL`?: string;

    /**
     * X-WNS-Type header parameter
     */
    @header
    `X-WNS-Type`?: string;

    /**
     * Upload file type
     */
    @header
    `content-type`: ContentType;

    /**
     * The notification message body
     */
    @body
    body: string;
  },
  void
>;
