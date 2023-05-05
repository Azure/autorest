import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace NotificationHubsClient;

@doc("Deletes a notification hub.")
@route("/{hubName}")
@delete
op DeleteNotificationHub is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;
  },
  void
>;

@doc("Retrieves information about a notification hub.")
@route("/{hubName}")
@get
op GetNotificationHub is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  NotificationHubEntryModel | void
>;

@doc("Create or update a notification hub.")
@route("/{hubName}")
@put
op CreateOrUpdateNotificationHub is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("ETag as returned by creation, update, and retrieval, or * (overwrite).")
    @header
    `If-Match`: string;
    @body body: NotificationHubEntryModel;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  NotificationHubEntryModel | void
>;

@doc("Retrieves all registrations with a specific tag.")
@route("/{hubName}/tags/{tag}/registrations")
@get
op GetRegistrationsByTag is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("The path for the tag to query")
    @path
    tag: string;

    @doc("""
Contains the token to continue the enumeration of registrations, in case there
are more.
""")
    @query
    ContinuationToken: string;

    @doc("OData top parameter")
    @query
    $top: string;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  void
>;

@doc("Create a registration ID")
@route("/{hubName}/registrationIDs")
@post
op CreateRegistrationId is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;
  },
  void
>;

@doc("Get registrations by the specified criteria")
@route("/{hubName}/registrations")
@get
op GetRegistrations is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("""
Contains the token to continue the enumeration of registrations, in case there
are more.
""")
    @query
    ContinuationToken: string;

    @doc("OData filter parameter")
    @query
    $filter: string;

    @doc("OData top parameter")
    @query
    $top: string;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  void
>;

@doc("Creates a registration")
@route("/{hubName}/registrations")
@post
op CreateRegistration is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  RegistrationEntryModel | void
>;

@doc("Deletes a registration")
@route("/{hubName}/registrations/{registrationId}")
@delete
op DeleteRegistration is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Registration ID parameter")
    @path
    registrationId: string;

    @doc("ETag as returned by creation, update, and retrieval, or * (overwrite).")
    @header
    `If-Match`: string;

    @doc("Authorization Header value")
    @header
    Authorization: string;
  },
  void
>;

@doc("Get a registration by registration ID")
@route("/{hubName}/registrations/{registrationId}")
@get
op GetRegistration is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Registration ID parameter")
    @path
    registrationId: string;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  RegistrationEntryModel | void
>;

@doc("Create or update a registration")
@route("/{hubName}/registrations/{registrationId}")
@put
op CreateOrUpdateRegistration is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Registration ID parameter")
    @path
    registrationId: string;

    @doc("Authorization Header value")
    @header
    Authorization: string;
    @body body: RegistrationEntryModel;

    @doc("Accept header")
    @header
    Accept: "application/atom+xml;type=entry;charset=utf-8";
  },
  RegistrationEntryModel | void
>;

@summary("Delete Installation")
@doc("Delete an installation by ID")
@route("/{hubName}/installations/{installationId}")
@delete
op DeleteInstallation is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Installation ID parameter")
    @path
    installationId: string;

    @doc("Authorization Header value")
    @header
    Authorization: string;
  },
  void
>;

@doc("Get an Installation by Installation ID")
op GetInstallation is Azure.Core.ResourceRead<
  InstallationModel,
  {
    parameters: {
      @doc("API Version")
      @header
      `x-ms-version`: MSApiVersionType;

      @doc("Authorization Header value")
      @header
      Authorization: string;
    };
  }
>;

@doc("""
Azure Notification Hubs supports partial updates to an installation using the
JSON-Patch standard in [RFC6902](https://tools.ietf.org/html/rfc6902).
""")
op PatchInstallation is Azure.Core.ResourceCreateOrUpdate<
  InstallationModel,
  {
    parameters: {
      @doc("API Version")
      @header
      `x-ms-version`: MSApiVersionType;

      @doc("Authorization Header value")
      @header
      Authorization: string;
    };
  }
>;

@doc("Creates or overwrites an installation.")
op CreateOrUpdateInstallation is Azure.Core.ResourceCreateOrReplace<
  InstallationModel,
  {
    parameters: {
      @doc("API Version")
      @header
      `x-ms-version`: MSApiVersionType;

      @doc("Authorization Header value")
      @header
      Authorization: string;
    };
  }
>;

@doc("Sends a notification to the specified targets.")
@route("/{hubName}/messages")
@post
op SendMessage is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("Device handle for the PNS")
    @header
    `ServiceBusNotification-DeviceHandle`: string;

    @doc("Platform type for the notification")
    @header
    `ServiceBusNotification-Format`: FormatParameterType;

    @doc("Notification message tags for targeting")
    @header
    `ServiceBusNotification-Tags`: string;

    @doc("Direct Send")
    @query
    direct: boolean;

    @doc("The apns-topic header")
    @header
    `apns-topic`: string;

    @doc("The apns-priority header")
    @header
    `apns-priority`: string;

    @doc("The apns-push-type header")
    @header
    `apns-push-type`: string;

    @doc(" X-WNS-Cache-Policy header parameter")
    @header
    `X-WNS-Cache-Policy`: string;

    @doc("X-WNS-PRIORITY header parameter")
    @header
    `X-WNS-PRIORITY`: string;

    @doc("X-WNS-RequestForStatus header parameter")
    @header
    `X-WNS-RequestForStatus`: string;

    @doc("X-WNS-Tag header parameter")
    @header
    `X-WNS-Tag`: string;

    @doc("X-WNS-TTL header parameter")
    @header
    `X-WNS-TTL`: string;

    @doc("X-WNS-Type header parameter")
    @header
    `X-WNS-Type`: string;

    @doc("Upload file type")
    @header
    `Content-Type`: ContentType;

    @doc("The notification message body")
    @body
    body: string;
  },
  void
>;

@doc("Sends a notification to the specified targets.")
@route("/{hubName}/messages")
@post
op SendMessage is Azure.Core.Foundations.Operation<
  {
    @doc("Notification Hub Name")
    @path
    hubName: string;

    @doc("API Version")
    @header
    `x-ms-version`: MSApiVersionType;

    @doc("Authorization Header value")
    @header
    Authorization: string;

    @doc("Device handle for the PNS")
    @header
    `ServiceBusNotification-DeviceHandle`: string;

    @doc("Platform type for the notification")
    @header
    `ServiceBusNotification-Format`: FormatParameterType;

    @doc("Notification message tags for targeting")
    @header
    `ServiceBusNotification-Tags`: string;

    @doc("Direct Send")
    @query
    direct: boolean;

    @doc("The apns-topic header")
    @header
    `apns-topic`: string;

    @doc("The apns-priority header")
    @header
    `apns-priority`: string;

    @doc("The apns-push-type header")
    @header
    `apns-push-type`: string;

    @doc(" X-WNS-Cache-Policy header parameter")
    @header
    `X-WNS-Cache-Policy`: string;

    @doc("X-WNS-PRIORITY header parameter")
    @header
    `X-WNS-PRIORITY`: string;

    @doc("X-WNS-RequestForStatus header parameter")
    @header
    `X-WNS-RequestForStatus`: string;

    @doc("X-WNS-Tag header parameter")
    @header
    `X-WNS-Tag`: string;

    @doc("X-WNS-TTL header parameter")
    @header
    `X-WNS-TTL`: string;

    @doc("X-WNS-Type header parameter")
    @header
    `X-WNS-Type`: string;

    @doc("Upload file type")
    @header
    `Content-Type`: ContentType;

    @doc("The notification message body")
    @body
    body: string;
  },
  void
>;
