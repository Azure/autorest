import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.ApiManagement;

interface Operations extends Azure.ResourceManager.Operations {}

enum Protocol {
  http,
  https,
  ws,
  wss,
}

/**
 * An value that determines where the API Version identifier will be located in a HTTP request.
 */
enum VersioningScheme {
  Segment,
  Query,
  Header,
}

enum BearerTokenSendingMethod {
  authorizationHeader,
  query,
}

/**
 * Type of API.
 */
enum ApiType {
  http,
  soap,
  websocket,
  graphql,
}

/**
 * Format of the Content in which the API is getting imported.
 */
enum ContentFormat {
  /**
   * The contents are inline and Content type is a WADL document.
   */
  `wadl-xml`,

  /**
   * The WADL document is hosted on a publicly accessible internet address.
   */
  `wadl-link-json`,

  /**
   * The contents are inline and Content Type is a OpenAPI 2.0 JSON Document.
   */
  `swagger-json`,

  /**
   * The OpenAPI 2.0 JSON document is hosted on a publicly accessible internet address.
   */
  `swagger-link-json`,

  /**
   * The contents are inline and the document is a WSDL/Soap document.
   */
  wsdl,

  /**
   * The WSDL document is hosted on a publicly accessible internet address.
   */
  `wsdl-link`,

  /**
   * The contents are inline and Content Type is a OpenAPI 3.0 YAML Document.
   */
  openapi,

  /**
   * The contents are inline and Content Type is a OpenAPI 3.0 JSON Document.
   */
  `openapi+json`,

  /**
   * The OpenAPI 3.0 YAML document is hosted on a publicly accessible internet address.
   */
  `openapi-link`,

  /**
   * The OpenAPI 3.0 JSON document is hosted on a publicly accessible internet address.
   */
  `openapi+json-link`,

  /**
   * The GraphQL API endpoint hosted on a publicly accessible internet address.
   */
  `graphql-link`,
}

/**
 * Type of API to create.
 *  * `http` creates a REST API
 *  * `soap` creates a SOAP pass-through API
 *  * `websocket` creates websocket API
 *  * `graphql` creates GraphQL API.
 */
enum SoapApiType {
  /**
   * Imports a SOAP API having a RESTful front end.
   */
  SoapToRest: "http",

  /**
   * Imports the SOAP API having a SOAP front end.
   */
  SoapPassThrough: "soap",

  /**
   * Imports the API having a Websocket front end.
   */
  WebSocket: "websocket",

  /**
   * Imports the API having a GraphQL front end.
   */
  GraphQL: "graphql",
}

/**
 * Format of the policyContent.
 */
enum PolicyContentFormat {
  /**
   * The contents are inline and Content type is an XML document.
   */
  xml,

  /**
   * The policy XML document is hosted on a http endpoint accessible from the API Management service.
   */
  `xml-link`,

  /**
   * The contents are inline and Content type is a non XML encoded policy document.
   */
  rawxml,

  /**
   * The policy document is not Xml encoded and is hosted on a http endpoint accessible from the API Management service.
   */
  `rawxml-link`,
}

enum PolicyIdName {
  policy,
}

enum PolicyExportFormat {
  /**
   * The contents are inline and Content type is an XML document.
   */
  xml,

  /**
   * The contents are inline and Content type is a non XML encoded policy document.
   */
  rawxml,
}

/**
 * Specifies for what type of messages sampling settings should not apply.
 */
enum AlwaysLog {
  /**
   * Always log all erroneous request regardless of sampling settings.
   */
  allErrors,
}

/**
 * Sampling type.
 */
enum SamplingType {
  /**
   * Fixed-rate sampling.
   */
  fixed,
}

/**
 * Data masking mode.
 */
enum DataMaskingMode {
  /**
   * Mask the value of an entity.
   */
  Mask,

  /**
   * Hide the presence of an entity.
   */
  Hide,
}

/**
 * Sets correlation protocol to use for Application Insights diagnostics.
 */
enum HttpCorrelationProtocol {
  /**
   * Do not read and inject correlation headers.
   */
  None,

  /**
   * Inject Request-Id and Request-Context headers with request correlation data. See https://github.com/dotnet/corefx/blob/master/src/System.Diagnostics.DiagnosticSource/src/HttpCorrelationProtocol.md.
   */
  Legacy,

  /**
   * Inject Trace Context headers. See https://w3c.github.io/trace-context.
   */
  W3C,
}

/**
 * The verbosity level applied to traces emitted by trace policies.
 */
enum Verbosity {
  /**
   * All the traces emitted by trace policies will be sent to the logger attached to this diagnostic instance.
   */
  verbose,

  /**
   * Traces with 'severity' set to 'information' and 'error' will be sent to the logger attached to this diagnostic instance.
   */
  information,

  /**
   * Only traces with 'severity' set to 'error' will be sent to the logger attached to this diagnostic instance.
   */
  error,
}

/**
 * The format of the Operation Name for Application Insights telemetries. Default is Name.
 */
enum OperationNameFormat {
  /**
   * API_NAME;rev=API_REVISION - OPERATION_NAME
   */
  Name,

  /**
   * HTTP_VERB URL
   */
  Url,
}

/**
 * Status of the issue.
 */
enum State {
  /**
   * The issue is proposed.
   */
  proposed,

  /**
   * The issue is opened.
   */
  open,

  /**
   * The issue was removed.
   */
  removed,

  /**
   * The issue is now resolved.
   */
  resolved,

  /**
   * The issue was closed.
   */
  closed,
}

enum ExportFormat {
  /**
   * Export the Api Definition in OpenAPI 2.0 Specification as JSON document to the Storage Blob.
   */
  Swagger: "swagger-link",

  /**
   * Export the Api Definition in WSDL Schema to Storage Blob. This is only supported for APIs of Type `soap`
   */
  Wsdl: "wsdl-link",

  /**
   * Export the Api Definition in WADL Schema to Storage Blob.
   */
  Wadl: "wadl-link",

  /**
   * Export the Api Definition in OpenAPI 3.0 Specification as YAML document to Storage Blob.
   */
  Openapi: "openapi-link",

  /**
   * Export the Api Definition in OpenAPI 3.0 Specification as JSON document to Storage Blob.
   */
  OpenapiJson: "openapi+json-link",
}

enum ExportApi {
  `true`,
}

/**
 * Format in which the API Details are exported to the Storage Blob with Sas Key valid for 5 minutes.
 */
enum ExportResultFormat {
  /**
   * The API Definition is exported in OpenAPI Specification 2.0 format to the Storage Blob.
   */
  Swagger: "swagger-link-json",

  /**
   * The API Definition is exported in WSDL Schema to Storage Blob. This is only supported for APIs of Type `soap`
   */
  Wsdl: "wsdl-link+xml",

  /**
   * Export the API Definition in WADL Schema to Storage Blob.
   */
  Wadl: "wadl-link-json",

  /**
   * Export the API Definition in OpenAPI Specification 3.0 to Storage Blob.
   */
  OpenApi: "openapi-link",
}

enum GrantType {
  /**
   * Authorization Code Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.1.
   */
  authorizationCode,

  /**
   * Implicit Code Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.2.
   */
  implicit,

  /**
   * Resource Owner Password Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.3.
   */
  resourceOwnerPassword,

  /**
   * Client Credentials Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.4.
   */
  clientCredentials,
}

enum ClientAuthenticationMethod {
  /**
   * Basic Client Authentication method.
   */
  Basic,

  /**
   * Body based Authentication method.
   */
  Body,
}

/**
 * Backend communication protocol.
 */
enum BackendProtocol {
  /**
   * The Backend is a RESTful service.
   */
  http,

  /**
   * The Backend is a SOAP service.
   */
  soap,
}

/**
 * The IP version to be used. Only IPv4 is supported for now.
 */
enum PreferredIPVersion {
  IPv4,
}

/**
 * The request's protocol. Specific protocol configuration can be available based on this selection. The specified destination address must be coherent with this value.
 */
enum ConnectivityCheckProtocol {
  TCP,
  HTTP,
  HTTPS,
}

/**
 * The HTTP method to be used.
 */
enum Method {
  GET,
  POST,
}

/**
 * The severity of the issue.
 */
enum Severity {
  Error,
  Warning,
}

/**
 * The type of issue.
 */
enum IssueType {
  Unknown,
  AgentStopped,
  GuestFirewall,
  DnsResolution,
  SocketBind,
  NetworkSecurityRule,
  UserDefinedRoute,
  PortThrottled,
  Platform,
}

/**
 * The connection status.
 */
enum ConnectionStatus {
  Unknown,
  Connected,
  Disconnected,
  Degraded,
}

/**
 * Name of the Sku.
 */
enum SkuType {
  /**
   * Developer SKU of Api Management.
   */
  Developer,

  /**
   * Standard SKU of Api Management.
   */
  Standard,

  /**
   * Premium SKU of Api Management.
   */
  Premium,

  /**
   * Basic SKU of Api Management.
   */
  Basic,

  /**
   * Consumption SKU of Api Management.
   */
  Consumption,

  /**
   * Isolated SKU of Api Management.
   */
  Isolated,
}

/**
 * The scale type applicable to the sku.
 */
enum ResourceSkuCapacityScaleType {
  /**
   * Supported scale type automatic.
   */
  automatic,

  /**
   * Supported scale type manual.
   */
  manual,

  /**
   * Scaling not supported.
   */
  none,
}

/**
 * The type of access to be used for the storage account.
 */
enum AccessType {
  /**
   * Use access key.
   */
  AccessKey,

  /**
   * Use system assigned managed identity.
   */
  SystemAssignedManagedIdentity,

  /**
   * Use user assigned managed identity.
   */
  UserAssignedManagedIdentity,
}

/**
 * Hostname type.
 */
enum HostnameType {
  Proxy,
  Portal,
  Management,
  Scm,
  DeveloperPortal,
}

/**
 * Certificate Source.
 */
enum CertificateSource {
  Managed,
  KeyVault,
  Custom,
  BuiltIn,
}

/**
 * Certificate Status.
 */
enum CertificateStatus {
  Completed,
  Failed,
  InProgress,
}

/**
 * Whether or not public endpoint access is allowed for this API Management service.  Value is optional but if passed in, must be 'Enabled' or 'Disabled'. If 'Disabled', private endpoints are the exclusive access method. Default value is 'Enabled'
 */
enum PublicNetworkAccess {
  Enabled,
  Disabled,
}

/**
 * Compute Platform Version running the service.
 */
enum PlatformVersion {
  /**
   * Platform version cannot be determined, as compute platform is not deployed.
   */
  undetermined,

  /**
   * Platform running the service on Single Tenant V1 platform.
   */
  stv1,

  /**
   * Platform running the service on Single Tenant V2 platform.
   */
  stv2,

  /**
   * Platform running the service on Multi Tenant V1 platform.
   */
  mtv1,
}

/**
 * The System.Security.Cryptography.x509certificates.StoreName certificate store location. Only Root and CertificateAuthority are valid locations.
 */
enum CertificateConfigurationStoreName {
  CertificateAuthority,
  Root,
}

/**
 * The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.
 */
enum VirtualNetworkType {
  /**
   * The service is not part of any Virtual Network.
   */
  None,

  /**
   * The service is part of Virtual Network and it is accessible from Internet.
   */
  External,

  /**
   * The service is part of Virtual Network and it is only accessible from within the virtual network.
   */
  Internal,
}

/**
 * The private endpoint connection status.
 */
enum PrivateEndpointServiceConnectionStatus {
  Pending,
  Approved,
  Rejected,
}

/**
 * The type of identity used for the resource. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the service.
 */
enum ApimIdentityType {
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
  None,
}

enum TemplateName {
  applicationApprovedNotificationMessage,
  accountClosedDeveloper,
  quotaLimitApproachingDeveloperNotificationMessage,
  newDeveloperNotificationMessage,
  emailChangeIdentityDefault,
  inviteUserNotificationMessage,
  newCommentNotificationMessage,
  confirmSignUpIdentityDefault,
  newIssueNotificationMessage,
  purchaseDeveloperNotificationMessage,
  passwordResetIdentityDefault,
  passwordResetByAdminNotificationMessage,
  rejectDeveloperNotificationMessage,
  requestDeveloperNotificationMessage,
}

/**
 * Account state. Specifies whether the user is active or not. Blocked users are unable to sign into the developer portal or call any APIs of subscribed products. Default state is Active.
 */
enum UserState {
  /**
   * User state is active.
   */
  active,

  /**
   * User is blocked. Blocked users cannot authenticate at developer portal or call API.
   */
  blocked,

  /**
   * User account is pending. Requires identity confirmation before it can be made active.
   */
  pending,

  /**
   * User account is closed. All identities and related entities are removed.
   */
  deleted,
}

enum IdentityProviderType {
  /**
   * Facebook as Identity provider.
   */
  facebook,

  /**
   * Google as Identity provider.
   */
  google,

  /**
   * Microsoft Live as Identity provider.
   */
  microsoft,

  /**
   * Twitter as Identity provider.
   */
  twitter,

  /**
   * Azure Active Directory as Identity provider.
   */
  aad,

  /**
   * Azure Active Directory B2C as Identity provider.
   */
  aadB2C,
}

/**
 * Logger type.
 */
enum LoggerType {
  /**
   * Azure Event Hub as log destination.
   */
  azureEventHub,

  /**
   * Azure Application Insights as log destination.
   */
  applicationInsights,

  /**
   * Azure Monitor
   */
  azureMonitor,
}

/**
 * Resource Connectivity Status Type identifier.
 */
enum ConnectivityStatusType {
  initializing,
  success,
  failure,
}

enum NotificationName {
  /**
   * The following email recipients and users will receive email notifications about subscription requests for API products requiring approval.
   */
  RequestPublisherNotificationMessage,

  /**
   * The following email recipients and users will receive email notifications about new API product subscriptions.
   */
  PurchasePublisherNotificationMessage,

  /**
   * The following email recipients and users will receive email notifications when new applications are submitted to the application gallery.
   */
  NewApplicationNotificationMessage,

  /**
   * The following recipients will receive blind carbon copies of all emails sent to developers.
   */
  BCC,

  /**
   * The following email recipients and users will receive email notifications when a new issue or comment is submitted on the developer portal.
   */
  NewIssuePublisherNotificationMessage,

  /**
   * The following email recipients and users will receive email notifications when developer closes his account.
   */
  AccountClosedPublisher,

  /**
   * The following email recipients and users will receive email notifications when subscription usage gets close to usage quota.
   */
  QuotaLimitApproachingPublisherNotificationMessage,
}

/**
 * Status of the portal's revision.
 */
enum PortalRevisionStatus {
  /**
   * Portal's revision has been queued.
   */
  pending,

  /**
   * Portal's revision is being published.
   */
  publishing,

  /**
   * Portal's revision publishing completed.
   */
  completed,

  /**
   * Portal's revision publishing failed.
   */
  failed,
}

/**
 * The current provisioning state.
 */
enum PrivateEndpointConnectionProvisioningState {
  Succeeded,
  Creating,
  Deleting,
  Failed,
}

/**
 * Schema Type. Immutable.
 */
enum SchemaType {
  /**
   * Xml schema type.
   */
  Xml: "xml",

  /**
   * Json schema type.
   */
  Json: "json",
}

enum SettingsTypeName {
  public,
}

enum AppType {
  /**
   * User create request was sent by legacy developer portal.
   */
  portal,

  /**
   * User create request was sent by new developer portal.
   */
  developerPortal,
}

enum AccessIdName {
  access,
  gitAccess,
}

enum ConfigurationIdName {
  configuration,
}

/**
 * Determines the type of confirmation e-mail that will be sent to the newly created user.
 */
enum Confirmation {
  /**
   * Send an e-mail to the user confirming they have successfully signed up.
   */
  signup,

  /**
   * Send an e-mail inviting the user to sign-up and complete registration.
   */
  invite,
}

/**
 * whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished.
 */
@fixed
enum ProductState {
  notPublished,
  published,
}

@fixed
enum AuthorizationMethod {
  HEAD,
  OPTIONS,
  TRACE,
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

/**
 * Invalid indicates the name provided does not match the resource provider’s naming requirements (incorrect length, unsupported characters, etc.)  AlreadyExists indicates that the name is already in use and is therefore unavailable.
 */
@fixed
enum NameAvailabilityReason {
  Valid,
  Invalid,
  AlreadyExists,
}

/**
 * The Key being regenerated.
 */
@fixed
enum GatewayRegenerateKeyType {
  primary,
  secondary,
}

/**
 * The Key to be used to generate token for user.
 */
@fixed
enum KeyType {
  primary,
  secondary,
}

/**
 * Group type.
 */
@fixed
enum GroupType {
  custom,
  system,
  external,
}

@fixed
enum PolicyScopeContract {
  Tenant,
  Product,
  Api,
  Operation,
  All,
}

/**
 * Subscription state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.
 */
@fixed
enum SubscriptionState {
  suspended,
  active,
  expired,
  submitted,
  rejected,
  cancelled,
}

/**
 * The scale type applicable to the sku.
 */
@fixed
enum ApiManagementSkuCapacityScaleType {
  Automatic,
  Manual,
  None,
}

/**
 * The type of restrictions.
 */
@fixed
enum ApiManagementSkuRestrictionsType {
  Location,
  Zone,
}

/**
 * The reason for restriction.
 */
@fixed
enum ApiManagementSkuRestrictionsReasonCode {
  QuotaId,
  NotAvailableForSubscription,
}

/**
 * Status of an async operation.
 */
@fixed
enum AsyncOperationStatus {
  Started,
  InProgress,
  Succeeded,
  Failed,
}

/**
 * API Entity Properties
 */
model ApiContractProperties extends ApiEntityBaseContract {
  /**
   * API identifier of the source API.
   */
  sourceApiId?: string;

  /**
   * API name. Must be 1 to 300 characters long.
   */
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  /**
   * Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.
   */
  @maxLength(2000)
  serviceUrl?: string;

  /**
   * Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.
   */
  @maxLength(400)
  path: string;

  /**
   * Describes on which protocols the operations in this API can be invoked.
   */
  protocols?: Protocol[];

  /**
   * Version set details
   */
  apiVersionSet?: ApiVersionSetContractDetails;
}

/**
 * An API Version Set contains the common configuration for a set of API Versions relating
 */
model ApiVersionSetContractDetails {
  /**
   * Identifier for existing API Version Set. Omit this value to create a new Version Set.
   */
  id?: string;

  /**
   * The display Name of the API Version Set.
   */
  name?: string;

  /**
   * Description of API Version Set.
   */
  description?: string;

  /**
   * An value that determines where the API Version identifier will be located in a HTTP request.
   */
  versioningScheme?: VersioningScheme;

  /**
   * Name of query parameter that indicates the API Version if versioningScheme is set to `query`.
   */
  versionQueryName?: string;

  /**
   * Name of HTTP header parameter that indicates the API Version if versioningScheme is set to `header`.
   */
  versionHeaderName?: string;
}

/**
 * API base contract details.
 */
model ApiEntityBaseContract {
  /**
   * Description of the API. May include HTML formatting tags.
   */
  description?: string;

  /**
   * Collection of authentication settings included into this API.
   */
  authenticationSettings?: AuthenticationSettingsContract;

  /**
   * Protocols over which API is made available.
   */
  subscriptionKeyParameterNames?: SubscriptionKeyParameterNamesContract;

  /**
   * Type of API.
   */
  @encodedName("application/json", "type")
  apiType?: ApiType;

  /**
   * Describes the revision of the API. If no value is provided, default revision 1 is created
   */
  @maxLength(100)
  @minLength(1)
  apiRevision?: string;

  /**
   * Indicates the version identifier of the API if the API is versioned
   */
  @maxLength(100)
  apiVersion?: string;

  /**
   * Indicates if API revision is current api revision.
   */
  isCurrent?: boolean;

  /**
   * Indicates if API revision is accessible via the gateway.
   */
  @visibility("read")
  isOnline?: boolean;

  /**
   * Description of the API Revision.
   */
  @maxLength(256)
  apiRevisionDescription?: string;

  /**
   * Description of the API Version.
   */
  @maxLength(256)
  apiVersionDescription?: string;

  /**
   * A resource identifier for the related ApiVersionSet.
   */
  apiVersionSetId?: string;

  /**
   * Specifies whether an API or Product subscription is required for accessing the API.
   */
  @encodedName("application/json", "subscriptionRequired")
  IsSubscriptionRequired?: boolean;

  /**
   *  A URL to the Terms of Service for the API. MUST be in the format of a URL.
   */
  termsOfServiceUrl?: string;

  /**
   * Contact information for the API.
   */
  contact?: ApiContactInformation;

  /**
   * License information for the API.
   */
  license?: ApiLicenseInformation;
}

/**
 * API Authentication Settings.
 */
model AuthenticationSettingsContract {
  /**
   * OAuth2 Authentication settings
   */
  oAuth2?: OAuth2AuthenticationSettingsContract;

  /**
   * OpenID Connect Authentication Settings
   */
  openid?: OpenIdAuthenticationSettingsContract;
}

/**
 * API OAuth2 Authentication settings details.
 */
model OAuth2AuthenticationSettingsContract {
  /**
   * OAuth authorization server identifier.
   */
  authorizationServerId?: string;

  /**
   * operations scope.
   */
  scope?: string;
}

/**
 * API OAuth2 Authentication settings details.
 */
model OpenIdAuthenticationSettingsContract {
  /**
   * OAuth authorization server identifier.
   */
  openidProviderId?: string;

  /**
   * How to send token to the server.
   */
  bearerTokenSendingMethods?: BearerTokenSendingMethod[];
}

/**
 * Subscription key parameter names details.
 */
model SubscriptionKeyParameterNamesContract {
  /**
   * Subscription key header name.
   */
  header?: string;

  /**
   * Subscription key query string parameter name.
   */
  query?: string;
}

/**
 * API contact information
 */
model ApiContactInformation {
  /**
   * The identifying name of the contact person/organization
   */
  name?: string;

  /**
   * The URL pointing to the contact information. MUST be in the format of a URL
   */
  url?: string;

  /**
   * The email address of the contact person/organization. MUST be in the format of an email address
   */
  email?: string;
}

/**
 * API license information
 */
model ApiLicenseInformation {
  /**
   * The license name used for the API
   */
  name?: string;

  /**
   * A URL to the license used for the API. MUST be in the format of a URL
   */
  url?: string;
}

/**
 * Common fields that are returned in the response for all Azure Resource Manager resources
 */
model Resource {
  /**
   * Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}
   */
  @visibility("read")
  id?: string;

  /**
   * The name of the resource
   */
  @visibility("read")
  name?: string;

  /**
   * The type of the resource. E.g. "Microsoft.Compute/virtualMachines" or "Microsoft.Storage/storageAccounts"
   */
  @visibility("read")
  type?: string;
}

/**
 * Error Body contract.
 */
model ErrorResponseBody {
  /**
   * Service-defined error code. This code serves as a sub-status for the HTTP error code specified in the response.
   */
  code?: string;

  /**
   * Human-readable representation of the error.
   */
  message?: string;

  /**
   * The list of invalid fields send in request, in case of validation error.
   */
  details?: ErrorFieldContract[];
}

/**
 * Error Field contract.
 */
model ErrorFieldContract {
  /**
   * Property level error code.
   */
  code?: string;

  /**
   * Human-readable representation of property-level error.
   */
  message?: string;

  /**
   * Property name.
   */
  target?: string;
}

/**
 * API Create or Update Parameters.
 */
model ApiCreateOrUpdateParameter {
  /**
   * API entity create of update properties.
   */
  properties?: ApiCreateOrUpdateProperties;
}

/**
 * API Create or Update Properties.
 */
model ApiCreateOrUpdateProperties extends ApiContractProperties {
  /**
   * Content value when Importing an API.
   */
  value?: string;

  /**
   * Format of the Content in which the API is getting imported.
   */
  format?: ContentFormat;

  /**
   * Criteria to limit import of WSDL to a subset of the document.
   */
  wsdlSelector?: ApiCreateOrUpdatePropertiesWsdlSelector;

  /**
   * Type of API to create.
   *  * `http` creates a REST API
   *  * `soap` creates a SOAP pass-through API
   *  * `websocket` creates websocket API
   *  * `graphql` creates GraphQL API.
   */
  @encodedName("application/json", "apiType")
  soapApiType?: SoapApiType;
}

/**
 * Criteria to limit import of WSDL to a subset of the document.
 */
model ApiCreateOrUpdatePropertiesWsdlSelector {
  /**
   * Name of service to import from WSDL
   */
  wsdlServiceName?: string;

  /**
   * Name of endpoint(port) to import from WSDL
   */
  wsdlEndpointName?: string;
}

/**
 * API update contract details.
 */
model ApiUpdateContract {
  /**
   * Properties of the API entity that can be updated.
   */
  properties?: ApiContractUpdateProperties;
}

/**
 * API update contract properties.
 */
model ApiContractUpdateProperties extends ApiEntityBaseContract {
  /**
   * API name.
   */
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  /**
   * Absolute URL of the backend service implementing this API.
   */
  @maxLength(2000)
  @minLength(1)
  serviceUrl?: string;

  /**
   * Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.
   */
  @maxLength(400)
  path?: string;

  /**
   * Describes on which protocols the operations in this API can be invoked.
   */
  protocols?: Protocol[];
}

/**
 * Paged API Revision list representation.
 */
model ApiRevisionListResult is Azure.Core.Page<ApiRevisionContract> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

/**
 * Summary of revision metadata.
 */
model ApiRevisionContract {
  /**
   * Identifier of the API Revision.
   */
  @visibility("read")
  apiId?: string;

  /**
   * Revision number of API.
   */
  @visibility("read")
  @maxLength(100)
  @minLength(1)
  apiRevision?: string;

  /**
   * The time the API Revision was created. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The time the API Revision were updated. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedDateTime?: utcDateTime;

  /**
   * Description of the API Revision.
   */
  @visibility("read")
  @maxLength(256)
  description?: string;

  /**
   * Gateway URL for accessing the non-current API Revision.
   */
  @visibility("read")
  privateUrl?: string;

  /**
   * Indicates if API revision is the current api revision.
   */
  @visibility("read")
  isOnline?: boolean;

  /**
   * Indicates if API revision is accessible via the gateway.
   */
  @visibility("read")
  isCurrent?: boolean;
}

/**
 * API Release details
 */
model ApiReleaseContractProperties {
  /**
   * Identifier of the API the release belongs to.
   */
  apiId?: string;

  /**
   * The time the API was released. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The time the API release was updated.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedDateTime?: utcDateTime;

  /**
   * Release Notes
   */
  notes?: string;
}

/**
 * Operation Contract Properties
 */
model OperationContractProperties extends OperationEntityBaseContract {
  /**
   * Operation Name.
   */
  @maxLength(300)
  @minLength(1)
  displayName: string;

  /**
   * A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.
   */
  method: string;

  /**
   * Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}
   */
  @maxLength(1000)
  @minLength(1)
  urlTemplate: string;
}

/**
 * API Operation Entity Base Contract details.
 */
model OperationEntityBaseContract {
  /**
   * Collection of URL template parameters.
   */
  templateParameters?: ParameterContract[];

  /**
   * Description of the operation. May include HTML formatting tags.
   */
  @maxLength(1000)
  description?: string;

  /**
   * An entity containing request details.
   */
  request?: RequestContract;

  /**
   * Array of Operation responses.
   */
  responses?: ResponseContract[];

  /**
   * Operation Policies
   */
  policies?: string;
}

/**
 * Operation parameters details.
 */
model ParameterContract {
  /**
   * Parameter name.
   */
  name: string;

  /**
   * Parameter description.
   */
  description?: string;

  /**
   * Parameter type.
   */
  type: string;

  /**
   * Default parameter value.
   */
  defaultValue?: string;

  /**
   * Specifies whether parameter is required or not.
   */
  required?: boolean;

  /**
   * Parameter values.
   */
  values?: string[];

  /**
   * Schema identifier.
   */
  schemaId?: string;

  /**
   * Type name defined by the schema.
   */
  typeName?: string;

  /**
   * Exampled defined for the parameter.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  examples?: Record<ParameterExampleContract>;
}

/**
 * Parameter example.
 */
model ParameterExampleContract {
  /**
   * Short description for the example
   */
  summary?: string;

  /**
   * Long description for the example
   */
  description?: string;

  /**
   * Example value. May be a primitive value, or an object.
   */
  value?: unknown;

  /**
   * A URL that points to the literal example
   */
  externalValue?: string;
}

/**
 * Operation request details.
 */
model RequestContract {
  /**
   * Operation request description.
   */
  description?: string;

  /**
   * Collection of operation request query parameters.
   */
  queryParameters?: ParameterContract[];

  /**
   * Collection of operation request headers.
   */
  headers?: ParameterContract[];

  /**
   * Collection of operation request representations.
   */
  representations?: RepresentationContract[];
}

/**
 * Operation request/response representation details.
 */
model RepresentationContract {
  /**
   * Specifies a registered or custom content type for this representation, e.g. application/xml.
   */
  contentType: string;

  /**
   * Schema identifier. Applicable only if 'contentType' value is neither 'application/x-www-form-urlencoded' nor 'multipart/form-data'.
   */
  schemaId?: string;

  /**
   * Type name defined by the schema. Applicable only if 'contentType' value is neither 'application/x-www-form-urlencoded' nor 'multipart/form-data'.
   */
  typeName?: string;

  /**
   * Collection of form parameters. Required if 'contentType' value is either 'application/x-www-form-urlencoded' or 'multipart/form-data'..
   */
  formParameters?: ParameterContract[];

  /**
   * Exampled defined for the representation.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  examples?: Record<ParameterExampleContract>;
}

/**
 * Operation response details.
 */
model ResponseContract {
  /**
   * Operation response HTTP status code.
   */
  statusCode: int32;

  /**
   * Operation response description.
   */
  description?: string;

  /**
   * Collection of operation response representations.
   */
  representations?: RepresentationContract[];

  /**
   * Collection of operation response headers.
   */
  headers?: ParameterContract[];
}

/**
 * API Operation Update Contract details.
 */
model OperationUpdateContract {
  /**
   * Properties of the API Operation entity that can be updated.
   */
  properties?: OperationUpdateContractProperties;
}

/**
 * Operation Update Contract Properties.
 */
model OperationUpdateContractProperties extends OperationEntityBaseContract {
  /**
   * Operation Name.
   */
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  /**
   * A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.
   */
  method?: string;

  /**
   * Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}
   */
  @maxLength(1000)
  @minLength(1)
  urlTemplate?: string;
}

/**
 * Policy contract Properties.
 */
model PolicyContractProperties {
  /**
   * Contents of the Policy as defined by the format.
   */
  value: string;

  /**
   * Format of the policyContent.
   */
  format?: PolicyContentFormat = PolicyContentFormat.xml;
}

/**
 * Tag contract Properties.
 */
model TagContractProperties {
  /**
   * Tag name.
   */
  @maxLength(160)
  @minLength(1)
  displayName: string;
}

/**
 * Product profile.
 */
model ProductContractProperties extends ProductEntityBaseParameters {
  /**
   * Product name.
   */
  @maxLength(300)
  @minLength(1)
  displayName: string;
}

/**
 * Product Entity Base Parameters
 */
model ProductEntityBaseParameters {
  /**
   * Product description. May include HTML formatting tags.
   */
  @maxLength(1000)
  description?: string;

  /**
   * Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.
   */
  terms?: string;

  /**
   * Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true.
   */
  @encodedName("application/json", "subscriptionRequired")
  IsSubscriptionRequired?: boolean;

  /**
   * whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false.
   */
  @encodedName("application/json", "approvalRequired")
  IsApprovalRequired?: boolean;

  /**
   * Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.
   */
  subscriptionsLimit?: int32;

  /**
   * whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished.
   */
  state?: ProductState;
}

/**
 * API Schema create or update contract Properties.
 */
model SchemaContractProperties {
  /**
   * Must be a valid a media type used in a Content-Type header as defined in the RFC 2616. Media type of the schema document (e.g. application/json, application/xml). </br> - `Swagger` Schema use `application/vnd.ms-azure-apim.swagger.definitions+json` </br> - `WSDL` Schema use `application/vnd.ms-azure-apim.xsd+xml` </br> - `OpenApi` Schema use `application/vnd.oai.openapi.components+json` </br> - `WADL Schema` use `application/vnd.ms-azure-apim.wadl.grammars+xml`.
   */
  contentType: string;

  /**
   * Create or update Properties of the API Schema Document.
   */
  document?: SchemaDocumentProperties;
}

/**
 * Api Schema Document Properties.
 */
model SchemaDocumentProperties {
  /**
   * Json escaped string defining the document representing the Schema. Used for schemas other than Swagger/OpenAPI.
   */
  value?: string;

  /**
   * Types definitions. Used for Swagger/OpenAPI v1 schemas only, null otherwise.
   */
  definitions?: Record<unknown>;

  /**
   * Types definitions. Used for Swagger/OpenAPI v2/v3 schemas only, null otherwise.
   */
  components?: Record<unknown>;
}

/**
 * Diagnostic Entity Properties
 */
model DiagnosticContractProperties {
  /**
   * Specifies for what type of messages sampling settings should not apply.
   */
  alwaysLog?: AlwaysLog;

  /**
   * Resource Id of a target logger.
   */
  loggerId: string;

  /**
   * Sampling settings for Diagnostic.
   */
  sampling?: SamplingSettings;

  /**
   * Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.
   */
  frontend?: PipelineDiagnosticSettings;

  /**
   * Diagnostic settings for incoming/outgoing HTTP messages to the Backend
   */
  backend?: PipelineDiagnosticSettings;

  /**
   * Log the ClientIP. Default is false.
   */
  logClientIp?: boolean;

  /**
   * Sets correlation protocol to use for Application Insights diagnostics.
   */
  httpCorrelationProtocol?: HttpCorrelationProtocol;

  /**
   * The verbosity level applied to traces emitted by trace policies.
   */
  verbosity?: Verbosity;

  /**
   * The format of the Operation Name for Application Insights telemetries. Default is Name.
   */
  operationNameFormat?: OperationNameFormat;

  /**
   * Emit custom metrics via emit-metric policy. Applicable only to Application Insights diagnostic settings.
   */
  metrics?: boolean;
}

/**
 * Sampling settings for Diagnostic.
 */
model SamplingSettings {
  /**
   * Sampling type.
   */
  samplingType?: SamplingType;

  /**
   * Rate of sampling for fixed-rate sampling.
   */
  @maxValue(100)
  percentage?: float64;
}

/**
 * Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.
 */
model PipelineDiagnosticSettings {
  /**
   * Diagnostic settings for request.
   */
  request?: HttpMessageDiagnostic;

  /**
   * Diagnostic settings for response.
   */
  response?: HttpMessageDiagnostic;
}

/**
 * Http message diagnostic settings.
 */
model HttpMessageDiagnostic {
  /**
   * Array of HTTP Headers to log.
   */
  headers?: string[];

  /**
   * Body logging settings.
   */
  body?: BodyDiagnosticSettings;

  /**
   * Data masking settings.
   */
  dataMasking?: DataMasking;
}

/**
 * Body logging settings.
 */
model BodyDiagnosticSettings {
  /**
   * Number of request body bytes to log.
   */
  @maxValue(8192)
  bytes?: int32;
}

model DataMasking {
  /**
   * Masking settings for Url query parameters
   */
  queryParams?: DataMaskingEntity[];

  /**
   * Masking settings for headers
   */
  headers?: DataMaskingEntity[];
}

model DataMaskingEntity {
  /**
   * The name of an entity to mask (e.g. a name of a header or a query parameter).
   */
  value?: string;

  /**
   * Data masking mode.
   */
  mode?: DataMaskingMode;
}

/**
 * Issue contract Properties.
 */
model IssueContractProperties extends IssueContractBaseProperties {
  /**
   * The issue title.
   */
  title: string;

  /**
   * Text describing the issue.
   */
  description: string;

  /**
   * A resource identifier for the user created the issue.
   */
  userId: string;
}

/**
 * Issue contract Base Properties.
 */
model IssueContractBaseProperties {
  /**
   * Date and time when the issue was created.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  /**
   * Status of the issue.
   */
  state?: State;

  /**
   * A resource identifier for the API the issue was created for.
   */
  apiId?: string;
}

/**
 * Issue update Parameters.
 */
model IssueUpdateContract {
  /**
   * Issue entity Update contract properties.
   */
  properties?: IssueUpdateContractProperties;
}

/**
 * Issue contract Update Properties.
 */
model IssueUpdateContractProperties extends IssueContractBaseProperties {
  /**
   * The issue title.
   */
  title?: string;

  /**
   * Text describing the issue.
   */
  description?: string;

  /**
   * A resource identifier for the user created the issue.
   */
  userId?: string;
}

/**
 * Issue Comment contract Properties.
 */
model IssueCommentContractProperties {
  /**
   * Comment text.
   */
  text: string;

  /**
   * Date and time when the comment was created.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  /**
   * A resource identifier for the user who left the comment.
   */
  userId: string;
}

/**
 * Issue Attachment contract Properties.
 */
model IssueAttachmentContractProperties {
  /**
   * Filename by which the binary data will be saved.
   */
  title: string;

  /**
   * Either 'link' if content is provided via an HTTP link or the MIME type of the Base64-encoded binary data provided in the 'content' property.
   */
  contentFormat: string;

  /**
   * An HTTP link or Base64-encoded binary data.
   */
  content: string;
}

/**
 * TagDescription contract Properties.
 */
model TagDescriptionContractProperties extends TagDescriptionBaseProperties {
  /**
   * Identifier of the tag in the form of /tags/{tagId}
   */
  tagId?: string;

  /**
   * Tag name.
   */
  @maxLength(160)
  @minLength(1)
  displayName?: string;
}

/**
 * Parameters supplied to the Create TagDescription operation.
 */
model TagDescriptionBaseProperties {
  /**
   * Description of the Tag.
   */
  description?: string;

  /**
   * Absolute URL of external resources describing the tag.
   */
  @maxLength(2000)
  externalDocsUrl?: string;

  /**
   * Description of the external resources describing the tag.
   */
  externalDocsDescription?: string;
}

/**
 * Parameters supplied to the Create TagDescription operation.
 */
model TagDescriptionCreateParameters {
  /**
   * Properties supplied to Create TagDescription operation.
   */
  properties?: TagDescriptionBaseProperties;
}

/**
 * Paged Tag list representation.
 */
model TagResourceListResult is Azure.Core.Page<TagResourceContract> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

/**
 * TagResource contract properties.
 */
model TagResourceContract {
  /**
   * Tag associated with the resource.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  tag: TagTagResourceContractProperties;

  /**
   * API associated with the tag.
   */
  api?: ApiTagResourceContractProperties;

  /**
   * Operation associated with the tag.
   */
  operation?: OperationTagResourceContractProperties;

  /**
   * Product associated with the tag.
   */
  product?: ProductTagResourceContractProperties;
}

/**
 * Contract defining the Tag property in the Tag Resource Contract
 */
model TagTagResourceContractProperties {
  /**
   * Tag identifier
   */
  id?: string;

  /**
   * Tag Name
   */
  @maxLength(160)
  @minLength(1)
  name?: string;
}

/**
 * API contract properties for the Tag Resources.
 */
model ApiTagResourceContractProperties extends ApiEntityBaseContract {
  /**
   * API identifier in the form /apis/{apiId}.
   */
  id?: string;

  /**
   * API name.
   */
  @maxLength(300)
  @minLength(1)
  name?: string;

  /**
   * Absolute URL of the backend service implementing this API.
   */
  @maxLength(2000)
  @minLength(1)
  serviceUrl?: string;

  /**
   * Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.
   */
  @maxLength(400)
  path?: string;

  /**
   * Describes on which protocols the operations in this API can be invoked.
   */
  protocols?: Protocol[];
}

/**
 * Operation Entity contract Properties.
 */
model OperationTagResourceContractProperties {
  /**
   * Identifier of the operation in form /operations/{operationId}.
   */
  id?: string;

  /**
   * Operation name.
   */
  @visibility("read")
  name?: string;

  /**
   * API Name.
   */
  @visibility("read")
  apiName?: string;

  /**
   * API Revision.
   */
  @visibility("read")
  apiRevision?: string;

  /**
   * API Version.
   */
  @visibility("read")
  apiVersion?: string;

  /**
   * Operation Description.
   */
  @visibility("read")
  description?: string;

  /**
   * A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.
   */
  @visibility("read")
  method?: string;

  /**
   * Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}
   */
  @visibility("read")
  urlTemplate?: string;
}

/**
 * Product profile.
 */
model ProductTagResourceContractProperties extends ProductEntityBaseParameters {
  /**
   * Identifier of the product in the form of /products/{productId}
   */
  id?: string;

  /**
   * Product name.
   */
  @maxLength(300)
  @minLength(1)
  name: string;
}

/**
 * API Export result.
 */
model ApiExportResult {
  /**
   * ResourceId of the API which was exported.
   */
  id?: string;

  /**
   * Format in which the API Details are exported to the Storage Blob with Sas Key valid for 5 minutes.
   */
  @encodedName("application/json", "format")
  exportResultFormat?: ExportResultFormat;

  /**
   * The object defining the schema of the exported API Detail
   */
  value?: ApiExportResultValue;
}

/**
 * The object defining the schema of the exported API Detail
 */
model ApiExportResultValue {
  /**
   * Link to the Storage Blob containing the result of the export operation. The Blob Uri is only valid for 5 minutes.
   */
  link?: string;
}

/**
 * Properties of an API Version Set.
 */
model ApiVersionSetContractProperties extends ApiVersionSetEntityBase {
  /**
   * Name of API Version Set
   */
  @maxLength(100)
  @minLength(1)
  displayName: string;

  /**
   * An value that determines where the API Version identifier will be located in a HTTP request.
   */
  versioningScheme: VersioningScheme;
}

/**
 * API Version set base parameters
 */
model ApiVersionSetEntityBase {
  /**
   * Description of API Version Set.
   */
  description?: string;

  /**
   * Name of query parameter that indicates the API Version if versioningScheme is set to `query`.
   */
  @maxLength(100)
  @minLength(1)
  versionQueryName?: string;

  /**
   * Name of HTTP header parameter that indicates the API Version if versioningScheme is set to `header`.
   */
  @maxLength(100)
  @minLength(1)
  versionHeaderName?: string;
}

/**
 * Parameters to update or create an API Version Set Contract.
 */
model ApiVersionSetUpdateParameters {
  /**
   * Parameters to update or create an API Version Set Contract.
   */
  properties?: ApiVersionSetUpdateParametersProperties;
}

/**
 * Properties used to create or update an API Version Set.
 */
model ApiVersionSetUpdateParametersProperties extends ApiVersionSetEntityBase {
  /**
   * Name of API Version Set
   */
  @maxLength(100)
  @minLength(1)
  displayName?: string;

  /**
   * An value that determines where the API Version identifier will be located in a HTTP request.
   */
  versioningScheme?: VersioningScheme;
}

/**
 * External OAuth authorization server settings Properties.
 */
model AuthorizationServerContractProperties
  extends AuthorizationServerContractBaseProperties {
  /**
   * User-friendly authorization server name.
   */
  @maxLength(50)
  @minLength(1)
  displayName: string;

  /**
   * Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.
   */
  clientRegistrationEndpoint: string;

  /**
   * OAuth authorization endpoint. See http://tools.ietf.org/html/rfc6749#section-3.2.
   */
  authorizationEndpoint: string;

  /**
   * Form of an authorization grant, which the client uses to request the access token.
   */
  grantTypes: GrantType[];

  /**
   * Client or app id registered with this authorization server.
   */
  clientId: string;

  /**
   * Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  clientSecret?: string;
}

/**
 * External OAuth authorization server Update settings contract.
 */
model AuthorizationServerContractBaseProperties {
  /**
   * Description of the authorization server. Can contain HTML formatting tags.
   */
  description?: string;

  /**
   * HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional.
   */
  authorizationMethods?: AuthorizationMethod[];

  /**
   * Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format.
   */
  @encodedName("application/json", "clientAuthenticationMethod")
  clientAuthenticationMethods?: ClientAuthenticationMethod[];

  /**
   * Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}.
   */
  tokenBodyParameters?: TokenBodyParameterContract[];

  /**
   * OAuth token endpoint. Contains absolute URI to entity being referenced.
   */
  tokenEndpoint?: string;

  /**
   * If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.
   */
  @encodedName("application/json", "supportState")
  doesSupportState?: boolean;

  /**
   * Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values.
   */
  defaultScope?: string;

  /**
   * Specifies the mechanism by which access token is passed to the API.
   */
  bearerTokenSendingMethods?: BearerTokenSendingMethod[];

  /**
   * Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.
   */
  resourceOwnerUsername?: string;

  /**
   * Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.
   */
  resourceOwnerPassword?: string;
}

/**
 * OAuth acquire token request body parameter (www-url-form-encoded).
 */
model TokenBodyParameterContract {
  /**
   * body parameter name.
   */
  name: string;

  /**
   * body parameter value.
   */
  value: string;
}

/**
 * External OAuth authorization server settings.
 */
model AuthorizationServerUpdateContract extends Resource {
  /**
   * Properties of the External OAuth authorization server update Contract.
   */
  properties?: AuthorizationServerUpdateContractProperties;
}

/**
 * External OAuth authorization server Update settings contract.
 */
model AuthorizationServerUpdateContractProperties
  extends AuthorizationServerContractBaseProperties {
  /**
   * User-friendly authorization server name.
   */
  @maxLength(50)
  @minLength(1)
  displayName?: string;

  /**
   * Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.
   */
  clientRegistrationEndpoint?: string;

  /**
   * OAuth authorization endpoint. See http://tools.ietf.org/html/rfc6749#section-3.2.
   */
  authorizationEndpoint?: string;

  /**
   * Form of an authorization grant, which the client uses to request the access token.
   */
  grantTypes?: GrantType[];

  /**
   * Client or app id registered with this authorization server.
   */
  clientId?: string;

  /**
   * Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  clientSecret?: string;
}

/**
 * OAuth Server Secrets Contract.
 */
model AuthorizationServerSecretsContract {
  /**
   * oAuth Authorization Server Secrets.
   */
  clientSecret?: string;

  /**
   * Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.
   */
  resourceOwnerUsername?: string;

  /**
   * Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.
   */
  resourceOwnerPassword?: string;
}

/**
 * Parameters supplied to the Create Backend operation.
 */
model BackendContractProperties extends BackendBaseParameters {
  /**
   * Runtime Url of the Backend.
   */
  @maxLength(2000)
  @minLength(1)
  url: string;

  /**
   * Backend communication protocol.
   */
  protocol: BackendProtocol;
}

/**
 * Backend entity base Parameter set.
 */
model BackendBaseParameters {
  /**
   * Backend Title.
   */
  @maxLength(300)
  @minLength(1)
  title?: string;

  /**
   * Backend Description.
   */
  @maxLength(2000)
  @minLength(1)
  description?: string;

  /**
   * Management Uri of the Resource in External System. This url can be the Arm Resource Id of Logic Apps, Function Apps or API Apps.
   */
  @maxLength(2000)
  @minLength(1)
  resourceId?: string;

  /**
   * Backend Properties contract
   */
  properties?: BackendProperties;

  /**
   * Backend Credentials Contract Properties
   */
  credentials?: BackendCredentialsContract;

  /**
   * Backend Proxy Contract Properties
   */
  proxy?: BackendProxyContract;

  /**
   * Backend TLS Properties
   */
  tls?: BackendTlsProperties;
}

/**
 * Properties specific to the Backend Type.
 */
model BackendProperties {
  /**
   * Backend Service Fabric Cluster Properties
   */
  serviceFabricCluster?: BackendServiceFabricClusterProperties;
}

/**
 * Properties of the Service Fabric Type Backend.
 */
model BackendServiceFabricClusterProperties {
  /**
   * The client certificate id for the management endpoint.
   */
  clientCertificateId?: string;

  /**
   * The client certificate thumbprint for the management endpoint. Will be ignored if certificatesIds are provided
   */
  clientCertificatethumbprint?: string;

  /**
   * Maximum number of retries while attempting resolve the partition.
   */
  maxPartitionResolutionRetries?: int32;

  /**
   * The cluster management endpoint.
   */
  managementEndpoints: string[];

  /**
   * Thumbprints of certificates cluster management service uses for tls communication
   */
  serverCertificateThumbprints?: string[];

  /**
   * Server X509 Certificate Names Collection
   */
  serverX509Names?: X509CertificateName[];
}

/**
 * Properties of server X509Names.
 */
model X509CertificateName {
  /**
   * Common Name of the Certificate.
   */
  name?: string;

  /**
   * Thumbprint for the Issuer of the Certificate.
   */
  issuerCertificateThumbprint?: string;
}

/**
 * Details of the Credentials used to connect to Backend.
 */
model BackendCredentialsContract {
  /**
   * List of Client Certificate Ids.
   */
  certificateIds?: string[];

  /**
   * List of Client Certificate Thumbprints. Will be ignored if certificatesIds are provided.
   */
  certificate?: string[];

  /**
   * Query Parameter description.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  query?: Record<string[]>;

  /**
   * Header Parameter description.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  header?: Record<string[]>;

  /**
   * Authorization header authentication
   */
  authorization?: BackendAuthorizationHeaderCredentials;
}

/**
 * Authorization header information.
 */
model BackendAuthorizationHeaderCredentials {
  /**
   * Authentication Scheme name.
   */
  @maxLength(100)
  @minLength(1)
  scheme: string;

  /**
   * Authentication Parameter value.
   */
  @maxLength(300)
  @minLength(1)
  parameter: string;
}

/**
 * Details of the Backend WebProxy Server to use in the Request to Backend.
 */
model BackendProxyContract {
  /**
   * WebProxy Server AbsoluteUri property which includes the entire URI stored in the Uri instance, including all fragments and query strings.
   */
  @maxLength(2000)
  @minLength(1)
  url: string;

  /**
   * Username to connect to the WebProxy server
   */
  username?: string;

  /**
   * Password to connect to the WebProxy Server
   */
  password?: string;
}

/**
 * Properties controlling TLS Certificate Validation.
 */
model BackendTlsProperties {
  /**
   * Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host.
   */
  validateCertificateChain?: boolean = true;

  /**
   * Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host.
   */
  validateCertificateName?: boolean = true;
}

/**
 * Backend update parameters.
 */
model BackendUpdateParameters {
  /**
   * Backend entity update contract properties.
   */
  properties?: BackendUpdateParameterProperties;
}

/**
 * Parameters supplied to the Update Backend operation.
 */
model BackendUpdateParameterProperties extends BackendBaseParameters {
  /**
   * Runtime Url of the Backend.
   */
  @maxLength(2000)
  @minLength(1)
  url?: string;

  /**
   * Backend communication protocol.
   */
  protocol?: BackendProtocol;
}

/**
 * Reconnect request parameters.
 */
model BackendReconnectContract extends Resource {
  /**
   * Reconnect request properties.
   */
  properties?: BackendReconnectProperties;
}

/**
 * Properties to control reconnect requests.
 */
model BackendReconnectProperties {
  /**
   * Duration in ISO8601 format after which reconnect will be initiated. Minimum duration of the Reconnect is PT2M.
   */
  after?: duration;
}

/**
 * Properties of the Cache contract.
 */
model CacheContractProperties {
  /**
   * Cache description
   */
  @maxLength(2000)
  description?: string;

  /**
   * Runtime connection string to cache
   */
  @maxLength(300)
  connectionString: string;

  /**
   * Location identifier to use cache from (should be either 'default' or valid Azure region identifier)
   */
  @maxLength(256)
  useFromLocation: string;

  /**
   * Original uri of entity in external system cache points to
   */
  @maxLength(2000)
  @encodedName("application/json", "resourceId")
  resourceUri?: string;
}

/**
 * Cache update details.
 */
model CacheUpdateParameters {
  /**
   * Cache update properties details.
   */
  properties?: CacheUpdateProperties;
}

/**
 * Parameters supplied to the Update Cache operation.
 */
model CacheUpdateProperties {
  /**
   * Cache description
   */
  @maxLength(2000)
  description?: string;

  /**
   * Runtime connection string to cache
   */
  @maxLength(300)
  connectionString?: string;

  /**
   * Location identifier to use cache from (should be either 'default' or valid Azure region identifier)
   */
  @maxLength(256)
  useFromLocation?: string;

  /**
   * Original uri of entity in external system cache points to
   */
  @maxLength(2000)
  @encodedName("application/json", "resourceId")
  resourceUri?: string;
}

/**
 * Properties of the Certificate contract.
 */
model CertificateContractProperties {
  /**
   * Subject attribute of the certificate.
   */
  subject: string;

  /**
   * Thumbprint of the certificate.
   */
  thumbprint: string;

  /**
   * Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDate: utcDateTime;

  /**
   * KeyVault location details of the certificate.
   */
  keyVault?: KeyVaultContractProperties;
}

/**
 * KeyVault contract details.
 */
model KeyVaultContractProperties extends KeyVaultContractCreateProperties {
  /**
   * Last time sync and refresh status of secret from key vault.
   */
  lastStatus?: KeyVaultLastAccessStatusContractProperties;
}

/**
 * Issue contract Update Properties.
 */
model KeyVaultLastAccessStatusContractProperties {
  /**
   * Last status code for sync and refresh of secret from key vault.
   */
  code?: string;

  /**
   * Details of the error else empty.
   */
  message?: string;

  /**
   * Last time secret was accessed. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeStampUtc?: utcDateTime;
}

/**
 * Create keyVault contract details.
 */
model KeyVaultContractCreateProperties {
  /**
   * Key vault secret identifier for fetching secret. Providing a versioned secret will prevent auto-refresh. This requires API Management service to be configured with aka.ms/apimmsi
   */
  secretIdentifier?: string;

  /**
   * Null for SystemAssignedIdentity or Client Id for UserAssignedIdentity , which will be used to access key vault secret.
   */
  identityClientId?: string;
}

/**
 * Certificate create or update details.
 */
model CertificateCreateOrUpdateParameters {
  /**
   * Certificate create or update properties details.
   */
  properties?: CertificateCreateOrUpdateProperties;
}

/**
 * Parameters supplied to the CreateOrUpdate certificate operation.
 */
model CertificateCreateOrUpdateProperties {
  /**
   * Base 64 encoded certificate using the application/x-pkcs12 representation.
   */
  data?: string;

  /**
   * Password for the Certificate
   */
  password?: string;

  /**
   * KeyVault location details of the certificate.
   */
  keyVault?: KeyVaultContractCreateProperties;
}

/**
 * A request to perform the connectivity check operation on a API Management service.
 */
model ConnectivityCheckRequest {
  /**
   * Definitions about the connectivity check origin.
   */
  source: ConnectivityCheckRequestSource;

  /**
   * The connectivity check operation destination.
   */
  destination: ConnectivityCheckRequestDestination;

  /**
   * The IP version to be used. Only IPv4 is supported for now.
   */
  preferredIPVersion?: PreferredIPVersion;

  /**
   * The request's protocol. Specific protocol configuration can be available based on this selection. The specified destination address must be coherent with this value.
   */
  protocol?: ConnectivityCheckProtocol;

  /**
   * Protocol-specific configuration.
   */
  protocolConfiguration?: ConnectivityCheckRequestProtocolConfiguration;
}

/**
 * Definitions about the connectivity check origin.
 */
model ConnectivityCheckRequestSource {
  /**
   * The API Management service region from where to start the connectivity check operation.
   */
  region: string;

  /**
   * The particular VMSS instance from which to fire the request.
   */
  instance?: int64;
}

/**
 * The connectivity check operation destination.
 */
model ConnectivityCheckRequestDestination {
  /**
   * Destination address. Can either be an IP address or a FQDN.
   */
  address: string;

  /**
   * Destination port.
   */
  port: int64;
}

/**
 * Protocol-specific configuration.
 */
model ConnectivityCheckRequestProtocolConfiguration {
  /**
   * Configuration for HTTP or HTTPS requests.
   */
  @encodedName("application/json", "HTTPConfiguration")
  httpConfiguration?: ConnectivityCheckRequestProtocolConfigurationHttpConfiguration;
}

/**
 * Configuration for HTTP or HTTPS requests.
 */
model ConnectivityCheckRequestProtocolConfigurationHttpConfiguration {
  /**
   * The HTTP method to be used.
   */
  method?: Method;

  /**
   * List of HTTP status codes considered valid for the request response.
   */
  validStatusCodes?: int64[];

  /**
   * List of headers to be included in the request.
   */
  headers?: HttpHeader[];
}

/**
 * HTTP header and it's value.
 */
model HttpHeader {
  /**
   * Header name.
   */
  name: string;

  /**
   * Header value.
   */
  value: string;
}

/**
 * Information on the connectivity status.
 */
model ConnectivityCheckResponse {
  /**
   * List of hops between the source and the destination.
   */
  @visibility("read")
  hops?: ConnectivityHop[];

  /**
   * The connection status.
   */
  @visibility("read")
  connectionStatus?: ConnectionStatus;

  /**
   * Average latency in milliseconds.
   */
  @visibility("read")
  avgLatencyInMs?: int64;

  /**
   * Minimum latency in milliseconds.
   */
  @visibility("read")
  minLatencyInMs?: int64;

  /**
   * Maximum latency in milliseconds.
   */
  @visibility("read")
  maxLatencyInMs?: int64;

  /**
   * Total number of probes sent.
   */
  @visibility("read")
  probesSent?: int64;

  /**
   * Number of failed probes.
   */
  @visibility("read")
  probesFailed?: int64;
}

/**
 * Information about a hop between the source and the destination.
 */
model ConnectivityHop {
  /**
   * The type of the hop.
   */
  @visibility("read")
  type?: string;

  /**
   * The ID of the hop.
   */
  @visibility("read")
  id?: string;

  /**
   * The IP address of the hop.
   */
  @visibility("read")
  address?: string;

  /**
   * The ID of the resource corresponding to this hop.
   */
  @visibility("read")
  resourceId?: string;

  /**
   * List of next hop identifiers.
   */
  @visibility("read")
  nextHopIds?: string[];

  /**
   * List of issues.
   */
  @visibility("read")
  issues?: ConnectivityIssue[];
}

/**
 * Information about an issue encountered in the process of checking for connectivity.
 */
model ConnectivityIssue {
  /**
   * The origin of the issue.
   */
  @visibility("read")
  origin?: Origin;

  /**
   * The severity of the issue.
   */
  @visibility("read")
  severity?: Severity;

  /**
   * The type of issue.
   */
  @visibility("read")
  type?: IssueType;

  /**
   * Provides additional context on the issue.
   */
  @visibility("read")
  context?: Record<string>[];
}

/**
 * Paged list of content types.
 */
model ContentTypeListResult is Azure.Core.Page<ContentTypeContract>;

/**
 * Content type contract details.
 */
model ContentTypeContract extends Resource {
  /**
   * Properties of the content type.
   */
  properties?: ContentTypeContractProperties;
}

model ContentTypeContractProperties {
  /**
   * Content type identifier
   */
  id?: string;

  /**
   * Content type name. Must be 1 to 250 characters long.
   */
  name?: string;

  /**
   * Content type description.
   */
  description?: string;

  /**
   * Content type schema.
   */
  schema?: Record<unknown>;

  /**
   * Content type version.
   */
  version?: string;
}

/**
 * Paged list of content items.
 */
model ContentItemListResult is Azure.Core.Page<ContentItemContract>;

/**
 * Content type contract details.
 */
model ContentItemContract extends Resource {
  /**
   * Properties of the content item.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  properties?: Record<unknown>;
}

model DeletedServiceContractProperties {
  /**
   * Fully-qualified API Management Service Resource ID
   */
  serviceId?: string;

  /**
   * UTC Date and Time when the service will be automatically purged. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  scheduledPurgeDate?: utcDateTime;

  /**
   * UTC Timestamp when the service was soft-deleted. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deletionDate?: utcDateTime;
}

/**
 * The API Management service SKUs operation response.
 */
model ResourceSkuResults is Azure.Core.Page<ResourceSkuResult>;

/**
 * Describes an available API Management service SKU.
 */
model ResourceSkuResult {
  /**
   * The type of resource the SKU applies to.
   */
  @visibility("read")
  resourceType?: string;

  /**
   * Specifies API Management SKU.
   */
  @visibility("read")
  sku?: ResourceSku;

  /**
   * Specifies the number of API Management units.
   */
  @visibility("read")
  capacity?: ResourceSkuCapacity;
}

/**
 * Describes scaling information of a SKU.
 */
model ResourceSkuCapacity {
  /**
   * The minimum capacity.
   */
  @visibility("read")
  minimum?: int32;

  /**
   * The maximum capacity that can be set.
   */
  @visibility("read")
  maximum?: int32;

  /**
   * The default capacity.
   */
  @visibility("read")
  default?: int32;

  /**
   * The scale type applicable to the sku.
   */
  @visibility("read")
  scaleType?: ResourceSkuCapacityScaleType;
}

/**
 * Parameters supplied to the Backup/Restore of an API Management service operation.
 */
model ApiManagementServiceBackupRestoreParameters {
  /**
   * The name of the Azure storage account (used to place/retrieve the backup).
   */
  storageAccount: string;

  /**
   * The name of the blob container (used to place/retrieve the backup).
   */
  containerName: string;

  /**
   * The name of the backup file to create/retrieve.
   */
  backupName: string;

  /**
   * The type of access to be used for the storage account.
   */
  accessType?: AccessType = AccessType.AccessKey;

  /**
   * Storage account access key. Required only if `accessType` is set to `AccessKey`.
   */
  accessKey?: string;

  /**
   * The Client ID of user assigned managed identity. Required only if `accessType` is set to `UserAssignedManagedIdentity`.
   */
  clientId?: string;
}

/**
 * Properties of an API Management service resource description.
 */
model ApiManagementServiceProperties
  extends ApiManagementServiceBaseProperties {
  /**
   * Publisher email.
   */
  @maxLength(100)
  publisherEmail: string;

  /**
   * Publisher name.
   */
  @maxLength(100)
  publisherName: string;
}

/**
 * Base Properties of an API Management service resource description.
 */
model ApiManagementServiceBaseProperties {
  /**
   * Email address from which the notification will be sent.
   */
  @maxLength(100)
  notificationSenderEmail?: string;

  /**
   * The current provisioning state of the API Management service which can be one of the following: Created/Activating/Succeeded/Updating/Failed/Stopped/Terminating/TerminationFailed/Deleted.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The provisioning state of the API Management service, which is targeted by the long running operation started on the service.
   */
  @visibility("read")
  targetProvisioningState?: string;

  /**
   * Creation UTC date of the API Management service.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdAtUtc?: utcDateTime;

  /**
   * Gateway URL of the API Management service.
   */
  @visibility("read")
  gatewayUrl?: string;

  /**
   * Gateway URL of the API Management service in the Default Region.
   */
  @visibility("read")
  gatewayRegionalUrl?: string;

  /**
   * Publisher portal endpoint Url of the API Management service.
   */
  @visibility("read")
  portalUrl?: string;

  /**
   * Management API endpoint URL of the API Management service.
   */
  @visibility("read")
  managementApiUrl?: string;

  /**
   * SCM endpoint URL of the API Management service.
   */
  @visibility("read")
  scmUrl?: string;

  /**
   * DEveloper Portal endpoint URL of the API Management service.
   */
  @visibility("read")
  developerPortalUrl?: string;

  /**
   * Custom hostname configuration of the API Management service.
   */
  hostnameConfigurations?: HostnameConfiguration[];

  /**
   * Public Static Load Balanced IP addresses of the API Management service in Primary region. Available only for Basic, Standard, Premium and Isolated SKU.
   */
  @visibility("read")
  publicIPAddresses?: string[];

  /**
   * Private Static Load Balanced IP addresses of the API Management service in Primary region which is deployed in an Internal Virtual Network. Available only for Basic, Standard, Premium and Isolated SKU.
   */
  @visibility("read")
  privateIPAddresses?: string[];

  /**
   * Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.
   */
  publicIpAddressId?: string;

  /**
   * Whether or not public endpoint access is allowed for this API Management service.  Value is optional but if passed in, must be 'Enabled' or 'Disabled'. If 'Disabled', private endpoints are the exclusive access method. Default value is 'Enabled'
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * Virtual network configuration of the API Management service.
   */
  virtualNetworkConfiguration?: VirtualNetworkConfiguration;

  /**
   * Additional datacenter locations of the API Management service.
   */
  additionalLocations?: AdditionalLocation[];

  /**
   * Custom properties of the API Management service.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168` will disable the cipher TLS_RSA_WITH_3DES_EDE_CBC_SHA for all TLS(1.0, 1.1 and 1.2).</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11` can be used to disable just TLS 1.1.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10` can be used to disable TLS 1.0 on an API Management service.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11` can be used to disable just TLS 1.1 for communications with backends.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10` can be used to disable TLS 1.0 for communications with backends.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2` can be used to enable HTTP2 protocol on an API Management service.</br>Not specifying any of these properties on PATCH operation will reset omitted properties' values to their defaults. For all the settings except Http2 the default value is `True` if the service was created on or before April 1st 2018 and `False` otherwise. Http2 setting's default value is `False`.</br></br>You can disable any of next ciphers by using settings `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.[cipher_name]`: TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA. For example, `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256`:`false`. The default value is `true` for them.  Note: next ciphers can't be disabled since they are required by Azure CloudService internal components: TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  customProperties?: Record<string>;

  /**
   * List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.
   */
  certificates?: CertificateConfiguration[];

  /**
   * Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.
   */
  enableClientCertificate?: boolean;

  /**
   * Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in master region.
   */
  disableGateway?: boolean;

  /**
   * The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.
   */
  virtualNetworkType?: VirtualNetworkType = VirtualNetworkType.None;

  /**
   * Control Plane Apis version constraint for the API Management service.
   */
  apiVersionConstraint?: ApiVersionConstraint;

  /**
   * Undelete Api Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.
   */
  restore?: boolean;

  /**
   * List of Private Endpoint Connections of this service.
   */
  privateEndpointConnections?: RemotePrivateEndpointConnectionWrapper[];

  /**
   * Compute Platform Version running the service in this location.
   */
  @visibility("read")
  platformVersion?: PlatformVersion;
}

/**
 * Custom hostname configuration.
 */
model HostnameConfiguration {
  /**
   * Hostname type.
   */
  type: HostnameType;

  /**
   * Hostname to configure on the Api Management service.
   */
  hostName: string;

  /**
   * Url to the KeyVault Secret containing the Ssl Certificate. If absolute Url containing version is provided, auto-update of ssl certificate will not work. This requires Api Management service to be configured with aka.ms/apimmsi. The secret should be of type *application/x-pkcs12*
   */
  keyVaultId?: string;

  /**
   * System or User Assigned Managed identity clientId as generated by Azure AD, which has GET access to the keyVault containing the SSL certificate.
   */
  identityClientId?: string;

  /**
   * Base64 Encoded certificate.
   */
  encodedCertificate?: string;

  /**
   * Certificate Password.
   */
  certificatePassword?: string;

  /**
   * Specify true to setup the certificate associated with this Hostname as the Default SSL Certificate. If a client does not send the SNI header, then this will be the certificate that will be challenged. The property is useful if a service has multiple custom hostname enabled and it needs to decide on the default ssl certificate. The setting only applied to Proxy Hostname Type.
   */
  defaultSslBinding?: boolean;

  /**
   * Specify true to always negotiate client certificate on the hostname. Default Value is false.
   */
  negotiateClientCertificate?: boolean;

  /**
   * Certificate information.
   */
  certificate?: CertificateInformation;

  /**
   * Certificate Source.
   */
  certificateSource?: CertificateSource;

  /**
   * Certificate Status.
   */
  certificateStatus?: CertificateStatus;
}

/**
 * SSL certificate information.
 */
model CertificateInformation {
  /**
   * Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiry: utcDateTime;

  /**
   * Thumbprint of the certificate.
   */
  thumbprint: string;

  /**
   * Subject of the certificate.
   */
  subject: string;
}

/**
 * Configuration of a virtual network to which API Management service is deployed.
 */
model VirtualNetworkConfiguration {
  /**
   * The virtual network ID. This is typically a GUID. Expect a null GUID by default.
   */
  @visibility("read")
  vnetid?: string;

  /**
   * The name of the subnet.
   */
  @visibility("read")
  subnetname?: string;

  /**
   * The full resource ID of a subnet in a virtual network to deploy the API Management service in.
   */
  @pattern("^/subscriptions/[^/]*/resourceGroups/[^/]*/providers/Microsoft.(ClassicNetwork|Network)/virtualNetworks/[^/]*/subnets/[^/]*$")
  subnetResourceId?: string;
}

/**
 * Description of an additional API Management resource location.
 */
model AdditionalLocation {
  /**
   * The location name of the additional region among Azure Data center regions.
   */
  location: string;

  /**
   * SKU properties of the API Management service.
   */
  sku: ApiManagementServiceSkuProperties;

  /**
   * A list of availability zones denoting where the resource needs to come from.
   */
  zones?: string[];

  /**
   * Public Static Load Balanced IP addresses of the API Management service in the additional location. Available only for Basic, Standard, Premium and Isolated SKU.
   */
  @visibility("read")
  publicIPAddresses?: string[];

  /**
   * Private Static Load Balanced IP addresses of the API Management service which is deployed in an Internal Virtual Network in a particular additional location. Available only for Basic, Standard, Premium and Isolated SKU.
   */
  @visibility("read")
  privateIPAddresses?: string[];

  /**
   * Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the location. Supported only for Premium SKU being deployed in Virtual Network.
   */
  publicIpAddressId?: string;

  /**
   * Virtual network configuration for the location.
   */
  virtualNetworkConfiguration?: VirtualNetworkConfiguration;

  /**
   * Gateway URL of the API Management service in the Region.
   */
  @visibility("read")
  gatewayRegionalUrl?: string;

  /**
   * Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in this additional location.
   */
  disableGateway?: boolean;

  /**
   * Compute Platform Version running the service.
   */
  @visibility("read")
  platformVersion?: PlatformVersion;
}

/**
 * API Management service resource SKU properties.
 */
model ApiManagementServiceSkuProperties {
  /**
   * Name of the Sku.
   */
  name: SkuType;

  /**
   * Capacity of the SKU (number of deployed units of the SKU). For Consumption SKU capacity must be specified as 0.
   */
  capacity: int32;
}

/**
 * Certificate configuration which consist of non-trusted intermediates and root certificates.
 */
model CertificateConfiguration {
  /**
   * Base64 Encoded certificate.
   */
  encodedCertificate?: string;

  /**
   * Certificate Password.
   */
  certificatePassword?: string;

  /**
   * The System.Security.Cryptography.x509certificates.StoreName certificate store location. Only Root and CertificateAuthority are valid locations.
   */
  storeName: CertificateConfigurationStoreName;

  /**
   * Certificate information.
   */
  certificate?: CertificateInformation;
}

/**
 * Control Plane Apis version constraint for the API Management service.
 */
model ApiVersionConstraint {
  /**
   * Limit control plane API calls to API Management service with version equal to or newer than this value.
   */
  minApiVersion?: string;
}

/**
 * Remote Private Endpoint Connection resource.
 */
model RemotePrivateEndpointConnectionWrapper {
  /**
   * Private Endpoint connection resource id
   */
  id?: string;

  /**
   * Private Endpoint Connection Name
   */
  name?: string;

  /**
   * Private Endpoint Connection Resource Type
   */
  type?: string;

  /**
   * Resource properties.
   */
  properties?: PrivateEndpointConnectionWrapperProperties;
}

/**
 * Properties of the PrivateEndpointConnectProperties.
 */
model PrivateEndpointConnectionWrapperProperties {
  /**
   * The resource of private end point.
   */
  privateEndpoint?: ArmIdWrapper;

  /**
   * A collection of information about the state of the connection between service consumer and provider.
   */
  privateLinkServiceConnectionState: PrivateLinkServiceConnectionState;

  /**
   * The provisioning state of the private endpoint connection resource.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * All the Group ids.
   */
  @visibility("read")
  groupIds?: string[];
}

/**
 * A wrapper for an ARM resource id
 */
model ArmIdWrapper {
  @visibility("read")
  id?: string;
}

/**
 * A collection of information about the state of the connection between service consumer and provider.
 */
model PrivateLinkServiceConnectionState {
  /**
   * Indicates whether the connection has been Approved/Rejected/Removed by the owner of the service.
   */
  status?: PrivateEndpointServiceConnectionStatus;

  /**
   * The reason for approval/rejection of the connection.
   */
  description?: string;

  /**
   * A message indicating if changes on the service provider require any updates on the consumer.
   */
  actionsRequired?: string;
}

/**
 * Identity properties of the Api Management service resource.
 */
model ApiManagementServiceIdentity {
  /**
   * The type of identity used for the resource. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the service.
   */
  type: ApimIdentityType;

  /**
   * The principal id of the identity.
   */
  @visibility("read")
  principalId?: string;

  /**
   * The client tenant id of the identity.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * The list of user identities associated with the resource. The user identity
   * dictionary key references will be ARM resource ids in the form:
   * '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
   *     providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  userAssignedIdentities?: Record<UserIdentityProperties>;
}

model UserIdentityProperties {
  /**
   * The principal id of user assigned identity.
   */
  principalId?: string;

  /**
   * The client id of user assigned identity.
   */
  clientId?: string;
}

/**
 * The Resource definition.
 */
model ApimResource {
  /**
   * Resource ID.
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name.
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type for API Management resource is set to Microsoft.ApiManagement.
   */
  @visibility("read")
  type?: string;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Parameter supplied to Update Api Management Service.
 */
model ApiManagementServiceUpdateParameters extends ApimResource {
  /**
   * Properties of the API Management service.
   */
  properties?: ApiManagementServiceUpdateProperties;

  /**
   * SKU properties of the API Management service.
   */
  sku?: ApiManagementServiceSkuProperties;

  /**
   * Managed service identity of the Api Management service.
   */
  identity?: ApiManagementServiceIdentity;

  /**
   * ETag of the resource.
   */
  @visibility("read")
  etag?: string;

  /**
   * A list of availability zones denoting where the resource needs to come from.
   */
  zones?: string[];
}

/**
 * Properties of an API Management service resource description.
 */
model ApiManagementServiceUpdateProperties
  extends ApiManagementServiceBaseProperties {
  /**
   * Publisher email.
   */
  @maxLength(100)
  publisherEmail?: string;

  /**
   * Publisher name.
   */
  @maxLength(100)
  publisherName?: string;
}

/**
 * The response of the GetSsoToken operation.
 */
model ApiManagementServiceGetSsoTokenResult {
  /**
   * Redirect URL to the Publisher Portal containing the SSO token.
   */
  redirectUri?: string;
}

/**
 * Parameters supplied to the CheckNameAvailability operation.
 */
model ApiManagementServiceCheckNameAvailabilityParameters {
  /**
   * The name to check for availability.
   */
  name: string;
}

/**
 * Response of the CheckNameAvailability operation.
 */
model ApiManagementServiceNameAvailabilityResult {
  /**
   * True if the name is available and can be used to create a new API Management service; otherwise false.
   */
  @visibility("read")
  nameAvailable?: boolean;

  /**
   * If reason == invalid, provide the user with the reason why the given name is invalid, and provide the resource naming requirements so that the user can select a valid name. If reason == AlreadyExists, explain that <resourceName> is already in use, and direct them to select a different name.
   */
  @visibility("read")
  message?: string;

  /**
   * Invalid indicates the name provided does not match the resource provider’s naming requirements (incorrect length, unsupported characters, etc.)  AlreadyExists indicates that the name is already in use and is therefore unavailable.
   */
  reason?: NameAvailabilityReason;
}

/**
 * Response of the GetDomainOwnershipIdentifier operation.
 */
model ApiManagementServiceGetDomainOwnershipIdentifierResult {
  /**
   * The domain ownership identifier value.
   */
  @visibility("read")
  domainOwnershipIdentifier?: string;
}

/**
 * Parameter supplied to the Apply Network configuration operation.
 */
model ApiManagementServiceApplyNetworkConfigurationParameters {
  /**
   * Location of the Api Management service to update for a multi-region service. For a service deployed in a single region, this parameter is not required.
   */
  location?: string;
}

/**
 * Email Template Contract properties.
 */
model EmailTemplateContractProperties {
  /**
   * Subject of the Template.
   */
  @maxLength(1000)
  @minLength(1)
  subject: string;

  /**
   * Email Template Body. This should be a valid XDocument
   */
  @minLength(1)
  body: string;

  /**
   * Title of the Template.
   */
  title?: string;

  /**
   * Description of the Email Template.
   */
  description?: string;

  /**
   * Whether the template is the default template provided by API Management or has been edited.
   */
  @visibility("read")
  isDefault?: boolean;

  /**
   * Email Template Parameter values.
   */
  parameters?: EmailTemplateParametersContractProperties[];
}

/**
 * Email Template Parameter contract.
 */
model EmailTemplateParametersContractProperties {
  /**
   * Template parameter name.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  name?: string;

  /**
   * Template parameter title.
   */
  @maxLength(4096)
  @minLength(1)
  title?: string;

  /**
   * Template parameter description.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  description?: string;
}

/**
 * Email Template update Parameters.
 */
model EmailTemplateUpdateParameters {
  /**
   * Email Template Update contract properties.
   */
  properties?: EmailTemplateUpdateParameterProperties;
}

/**
 * Email Template Update Contract properties.
 */
model EmailTemplateUpdateParameterProperties {
  /**
   * Subject of the Template.
   */
  @maxLength(1000)
  @minLength(1)
  subject?: string;

  /**
   * Title of the Template.
   */
  title?: string;

  /**
   * Description of the Email Template.
   */
  description?: string;

  /**
   * Email Template Body. This should be a valid XDocument
   */
  @minLength(1)
  body?: string;

  /**
   * Email Template Parameter values.
   */
  parameters?: EmailTemplateParametersContractProperties[];
}

/**
 * Properties of the Gateway contract.
 */
model GatewayContractProperties {
  /**
   * Gateway location.
   */
  locationData?: ResourceLocationDataContract;

  /**
   * Gateway description
   */
  @maxLength(1000)
  description?: string;
}

/**
 * Resource location data properties.
 */
model ResourceLocationDataContract {
  /**
   * A canonical name for the geographic or physical location.
   */
  @maxLength(256)
  name: string;

  /**
   * The city or locality where the resource is located.
   */
  @maxLength(256)
  city?: string;

  /**
   * The district, state, or province where the resource is located.
   */
  @maxLength(256)
  district?: string;

  /**
   * The country or region where the resource is located.
   */
  @maxLength(256)
  countryOrRegion?: string;
}

/**
 * Gateway authentication keys.
 */
model GatewayKeysContract {
  /**
   * Primary gateway key.
   */
  primary?: string;

  /**
   * Secondary gateway key.
   */
  secondary?: string;
}

/**
 * Gateway key regeneration request contract properties.
 */
model GatewayKeyRegenerationRequestContract {
  /**
   * The Key being regenerated.
   */
  keyType: GatewayRegenerateKeyType;
}

/**
 * Gateway token request contract properties.
 */
model GatewayTokenRequestContract {
  /**
   * The Key to be used to generate gateway token.
   */
  keyType: KeyType;

  /**
   * The Expiry time of the Token. Maximum token expiry time is set to 30 days. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiry: utcDateTime;
}

/**
 * Gateway access token.
 */
model GatewayTokenContract {
  /**
   * Shared Access Authentication token value for the Gateway.
   */
  value?: string;
}

/**
 * Gateway hostname configuration details.
 */
model GatewayHostnameConfigurationContractProperties {
  /**
   * Hostname value. Supports valid domain name, partial or full wildcard
   */
  hostname?: string;

  /**
   * Identifier of Certificate entity that will be used for TLS connection establishment
   */
  certificateId?: string;

  /**
   * Determines whether gateway requests client certificate
   */
  negotiateClientCertificate?: boolean;

  /**
   * Specifies if TLS 1.0 is supported
   */
  tls10Enabled?: boolean;

  /**
   * Specifies if TLS 1.1 is supported
   */
  tls11Enabled?: boolean;

  /**
   * Specifies if HTTP/2.0 is supported
   */
  http2Enabled?: boolean;
}

/**
 * Paged API list representation.
 */
model ApiManagementGatewayApiListResult is Azure.Core.Page<GatewayApiData> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

model GatewayApiData extends ApiContract {}

/**
 * Association entity details.
 */
model AssociationContract extends Resource {
  /**
   * Association entity contract properties.
   */
  properties?: AssociationContractProperties;
}

/**
 * Association entity contract properties.
 */
model AssociationContractProperties {
  /**
   * Provisioning state.
   */
  provisioningState?: "created";
}

/**
 * Gateway certificate authority details.
 */
model GatewayCertificateAuthorityContractProperties {
  /**
   * Determines whether certificate authority is trusted.
   */
  isTrusted?: boolean;
}

/**
 * Group contract Properties.
 */
model GroupContractProperties {
  /**
   * Group name.
   */
  @maxLength(300)
  @minLength(1)
  displayName: string;

  /**
   * Group description. Can contain HTML formatting tags.
   */
  @maxLength(1000)
  description?: string;

  /**
   * true if the group is one of the three system groups (Administrators, Developers, or Guests); otherwise false.
   */
  @visibility("read")
  builtIn?: boolean;

  /**
   * Group type.
   */
  type?: GroupType;

  /**
   * For external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://<tenant>.onmicrosoft.com/groups/<group object id>`; otherwise the value is null.
   */
  externalId?: string;
}

/**
 * Parameters supplied to the Create Group operation.
 */
model GroupCreateParameters {
  /**
   * Properties supplied to Create Group operation.
   */
  properties?: GroupCreateParametersProperties;
}

/**
 * Parameters supplied to the Create Group operation.
 */
model GroupCreateParametersProperties {
  /**
   * Group name.
   */
  @maxLength(300)
  @minLength(1)
  displayName: string;

  /**
   * Group description.
   */
  description?: string;

  /**
   * Group type.
   */
  type?: GroupType;

  /**
   * Identifier of the external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://<tenant>.onmicrosoft.com/groups/<group object id>`; otherwise the value is null.
   */
  externalId?: string;
}

/**
 * Parameters supplied to the Update Group operation.
 */
model GroupUpdateParameters {
  /**
   * Group entity update contract properties.
   */
  properties?: GroupUpdateParametersProperties;
}

/**
 * Parameters supplied to the Update Group operation.
 */
model GroupUpdateParametersProperties {
  /**
   * Group name.
   */
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  /**
   * Group description.
   */
  description?: string;

  /**
   * Group type.
   */
  type?: GroupType;

  /**
   * Identifier of the external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://<tenant>.onmicrosoft.com/groups/<group object id>`; otherwise the value is null.
   */
  externalId?: string;
}

/**
 * Paged Group Users list representation.
 */
model ApiManagementGroupUserListResult
  is Azure.Core.Page<ApiManagementGroupUserData> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

model ApiManagementGroupUserData extends UserContract {}

/**
 * User profile.
 */
model UserContractProperties extends UserEntityBaseParameters {
  /**
   * First name.
   */
  firstName?: string;

  /**
   * Last name.
   */
  lastName?: string;

  /**
   * Email address.
   */
  email?: string;

  /**
   * Date of user registration. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  registrationDate?: utcDateTime;

  /**
   * Collection of groups user is part of.
   */
  @visibility("read")
  groups?: GroupContractProperties[];
}

/**
 * User Entity Base Parameters set.
 */
model UserEntityBaseParameters {
  /**
   * Account state. Specifies whether the user is active or not. Blocked users are unable to sign into the developer portal or call any APIs of subscribed products. Default state is Active.
   */
  state?: UserState = UserState.active;

  /**
   * Optional note about a user set by the administrator.
   */
  note?: string;

  /**
   * Collection of user identities.
   */
  identities?: UserIdentityContract[];
}

/**
 * User identity details.
 */
model UserIdentityContract {
  /**
   * Identity provider name.
   */
  provider?: string;

  /**
   * Identifier value within provider.
   */
  id?: string;
}

/**
 * The external Identity Providers like Facebook, Google, Microsoft, Twitter or Azure Active Directory which can be used to enable access to the API Management service developer portal for all users.
 */
model IdentityProviderContractProperties
  extends IdentityProviderBaseParameters {
  /**
   * Client Id of the Application in the external Identity Provider. It is App ID for Facebook login, Client ID for Google login, App ID for Microsoft.
   */
  @minLength(1)
  clientId: string;

  /**
   * Client secret of the Application in external Identity Provider, used to authenticate login request. For example, it is App Secret for Facebook login, API Key for Google login, Public Key for Microsoft. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  @minLength(1)
  clientSecret?: string;
}

/**
 * Identity Provider Base Parameter Properties.
 */
model IdentityProviderBaseParameters {
  /**
   * Identity Provider Type identifier.
   */
  @encodedName("application/json", "type")
  identityProviderType?: IdentityProviderType;

  /**
   * The TenantId to use instead of Common when logging into Active Directory
   */
  @encodedName("application/json", "signinTenant")
  signInTenant?: string;

  /**
   * List of Allowed Tenants when configuring Azure Active Directory login.
   */
  allowedTenants?: string[];

  /**
   * OpenID Connect discovery endpoint hostname for AAD or AAD B2C.
   */
  authority?: string;

  /**
   * Signup Policy Name. Only applies to AAD B2C Identity Provider.
   */
  @minLength(1)
  @encodedName("application/json", "signupPolicyName")
  signUpPolicyName?: string;

  /**
   * Signin Policy Name. Only applies to AAD B2C Identity Provider.
   */
  @minLength(1)
  @encodedName("application/json", "signinPolicyName")
  signInPolicyName?: string;

  /**
   * Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.
   */
  @minLength(1)
  profileEditingPolicyName?: string;

  /**
   * Password Reset Policy Name. Only applies to AAD B2C Identity Provider.
   */
  @minLength(1)
  passwordResetPolicyName?: string;
}

/**
 * Identity Provider details.
 */
model IdentityProviderCreateContract extends Resource {
  /**
   * Identity Provider contract properties.
   */
  properties?: IdentityProviderCreateContractProperties;
}

/**
 * The external Identity Providers like Facebook, Google, Microsoft, Twitter or Azure Active Directory which can be used to enable access to the API Management service developer portal for all users.
 */
model IdentityProviderCreateContractProperties
  extends IdentityProviderBaseParameters {
  /**
   * Client Id of the Application in the external Identity Provider. It is App ID for Facebook login, Client ID for Google login, App ID for Microsoft.
   */
  @minLength(1)
  clientId: string;

  /**
   * Client secret of the Application in external Identity Provider, used to authenticate login request. For example, it is App Secret for Facebook login, API Key for Google login, Public Key for Microsoft. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  @minLength(1)
  clientSecret: string;
}

/**
 * Parameters supplied to update Identity Provider
 */
model IdentityProviderUpdateParameters {
  /**
   * Identity Provider update properties.
   */
  properties?: IdentityProviderUpdateProperties;
}

/**
 * Parameters supplied to the Update Identity Provider operation.
 */
model IdentityProviderUpdateProperties extends IdentityProviderBaseParameters {
  /**
   * Client Id of the Application in the external Identity Provider. It is App ID for Facebook login, Client ID for Google login, App ID for Microsoft.
   */
  @minLength(1)
  clientId?: string;

  /**
   * Client secret of the Application in external Identity Provider, used to authenticate login request. For example, it is App Secret for Facebook login, API Key for Google login, Public Key for Microsoft.
   */
  @minLength(1)
  clientSecret?: string;
}

/**
 * Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.
 */
model ClientSecretContract {
  /**
   * Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.
   */
  clientSecret?: string;
}

/**
 * The Logger entity in API Management represents an event sink that you can use to log API Management events. Currently the Logger entity supports logging API Management events to Azure Event Hubs.
 */
model LoggerContractProperties {
  /**
   * Logger type.
   */
  loggerType: LoggerType;

  /**
   * Logger description.
   */
  @maxLength(256)
  description?: string;

  /**
   * The name and SendRule connection string of the event hub for azureEventHub logger.
   * Instrumentation key for applicationInsights logger.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  credentials?: Record<string>;

  /**
   * Whether records are buffered in the logger before publishing. Default is assumed to be true.
   */
  isBuffered?: boolean;

  /**
   * Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource).
   */
  resourceId?: string;
}

/**
 * Logger update contract.
 */
model LoggerUpdateContract {
  /**
   * Logger entity update contract properties.
   */
  properties?: LoggerUpdateParameters;
}

/**
 * Parameters supplied to the Update Logger operation.
 */
model LoggerUpdateParameters {
  /**
   * Logger type.
   */
  loggerType?: LoggerType;

  /**
   * Logger description.
   */
  description?: string;

  /**
   * Logger credentials.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  credentials?: Record<string>;

  /**
   * Whether records are buffered in the logger before publishing. Default is assumed to be true.
   */
  isBuffered?: boolean;
}

/**
 * NamedValue Contract properties.
 */
model NamedValueContractProperties extends NamedValueEntityBaseParameters {
  /**
   * Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  displayName: string;

  /**
   * Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  @maxLength(4096)
  value?: string;

  /**
   * KeyVault location details of the namedValue.
   */
  keyVault?: KeyVaultContractProperties;
}

/**
 * NamedValue Entity Base Parameters set.
 */
model NamedValueEntityBaseParameters {
  /**
   * Optional tags that when provided can be used to filter the NamedValue list.
   */
  tags?: string[];

  /**
   * Determines whether the value is a secret and should be encrypted or not. Default value is false.
   */
  @encodedName("application/json", "secret")
  IsSecret?: boolean;
}

/**
 * NamedValue details.
 */
model NamedValueCreateContract extends Resource {
  /**
   * NamedValue entity contract properties for PUT operation.
   */
  properties?: NamedValueCreateContractProperties;
}

/**
 * NamedValue Contract properties.
 */
model NamedValueCreateContractProperties
  extends NamedValueEntityBaseParameters {
  /**
   * Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  displayName: string;

  /**
   * Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  @maxLength(4096)
  value?: string;

  /**
   * KeyVault location details of the namedValue.
   */
  keyVault?: KeyVaultContractCreateProperties;
}

/**
 * NamedValue update Parameters.
 */
model NamedValueUpdateParameters {
  /**
   * NamedValue entity Update contract properties.
   */
  properties?: NamedValueUpdateParameterProperties;
}

/**
 * NamedValue Contract properties.
 */
model NamedValueUpdateParameterProperties
  extends NamedValueEntityBaseParameters {
  /**
   * Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  displayName?: string;

  /**
   * Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace.
   */
  @maxLength(4096)
  @minLength(1)
  value?: string;

  /**
   * KeyVault location details of the namedValue.
   */
  keyVault?: KeyVaultContractCreateProperties;
}

/**
 * Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.
 */
model NamedValueSecretContract {
  /**
   * This is secret value of the NamedValue entity.
   */
  value?: string;
}

/**
 * Network Status in the Location
 */
model NetworkStatusContractByLocation {
  /**
   * Location of service
   */
  @minLength(1)
  location?: string;

  /**
   * Network status in Location
   */
  networkStatus?: NetworkStatusContract;
}

/**
 * Network Status details.
 */
model NetworkStatusContract {
  /**
   * Gets the list of DNS servers IPV4 addresses.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  dnsServers: string[];

  /**
   * Gets the list of Connectivity Status to the Resources on which the service depends upon.
   */
  connectivityStatus: ConnectivityStatusContract[];
}

/**
 * Details about connectivity to a resource.
 */
model ConnectivityStatusContract {
  /**
   * The hostname of the resource which the service depends on. This can be the database, storage or any other azure resource on which the service depends upon.
   */
  @minLength(1)
  name: string;

  /**
   * Resource Connectivity Status Type identifier.
   */
  status: ConnectivityStatusType;

  /**
   * Error details of the connectivity to the resource.
   */
  error?: string;

  /**
   * The date when the resource connectivity status was last updated. This status should be updated every 15 minutes. If this status has not been updated, then it means that the service has lost network connectivity to the resource, from inside the Virtual Network.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdated: utcDateTime;

  /**
   * The date when the resource connectivity status last Changed from success to failure or vice-versa. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastStatusChange: utcDateTime;

  /**
   * Resource Type.
   */
  resourceType: string;

  /**
   * Whether this is optional.
   */
  isOptional: boolean;
}

/**
 * Notification Contract properties.
 */
model NotificationContractProperties {
  /**
   * Title of the Notification.
   */
  @maxLength(1000)
  @minLength(1)
  title: string;

  /**
   * Description of the Notification.
   */
  description?: string;

  /**
   * Recipient Parameter values.
   */
  recipients?: RecipientsContractProperties;
}

/**
 * Notification Parameter contract.
 */
model RecipientsContractProperties {
  /**
   * List of Emails subscribed for the notification.
   */
  emails?: string[];

  /**
   * List of Users subscribed for the notification.
   */
  users?: string[];
}

/**
 * Paged Recipient User list representation.
 */
model RecipientUserListResult {
  /**
   * Page values.
   */
  value?: RecipientUserContract[];

  /**
   * Total record count number across all pages.
   */
  count?: int64;

  /**
   * Next page link if any.
   */
  nextLink?: string;
}

/**
 * Recipient User details.
 */
model RecipientUserContract extends Resource {
  /**
   * Recipient User entity contract properties.
   */
  properties?: RecipientUsersContractProperties;
}

/**
 * Recipient User Contract Properties.
 */
model RecipientUsersContractProperties {
  /**
   * API Management UserId subscribed to notification.
   */
  userId?: string;
}

/**
 * Paged Recipient User list representation.
 */
model RecipientEmailListResult {
  /**
   * Page values.
   */
  value?: RecipientEmailContract[];

  /**
   * Total record count number across all pages.
   */
  count?: int64;

  /**
   * Next page link if any.
   */
  nextLink?: string;
}

/**
 * Recipient Email details.
 */
model RecipientEmailContract extends Resource {
  /**
   * Recipient Email contract properties.
   */
  properties?: RecipientEmailContractProperties;
}

/**
 * Recipient Email Contract Properties.
 */
model RecipientEmailContractProperties {
  /**
   * User Email subscribed to notification.
   */
  email?: string;
}

/**
 * OpenID Connect Providers Contract.
 */
model OpenidConnectProviderContractProperties {
  /**
   * User-friendly OpenID Connect Provider name.
   */
  @maxLength(50)
  displayName: string;

  /**
   * User-friendly description of OpenID Connect Provider.
   */
  description?: string;

  /**
   * Metadata endpoint URI.
   */
  metadataEndpoint: string;

  /**
   * Client ID of developer console which is the client application.
   */
  clientId: string;

  /**
   * Client Secret of developer console which is the client application.
   */
  clientSecret?: string;
}

/**
 * Parameters supplied to the Update OpenID Connect Provider operation.
 */
model OpenidConnectProviderUpdateContract {
  /**
   * OpenId Connect Provider Update contract properties.
   */
  properties?: OpenidConnectProviderUpdateContractProperties;
}

/**
 * Parameters supplied to the Update OpenID Connect Provider operation.
 */
model OpenidConnectProviderUpdateContractProperties {
  /**
   * User-friendly OpenID Connect Provider name.
   */
  @maxLength(50)
  displayName?: string;

  /**
   * User-friendly description of OpenID Connect Provider.
   */
  description?: string;

  /**
   * Metadata endpoint URI.
   */
  metadataEndpoint?: string;

  /**
   * Client ID of developer console which is the client application.
   */
  clientId?: string;

  /**
   * Client Secret of developer console which is the client application.
   */
  clientSecret?: string;
}

/**
 * Collection of Outbound Environment Endpoints
 */
model OutboundEnvironmentEndpointList {
  /**
   * Collection of resources.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  value: OutboundEnvironmentEndpoint[];

  /**
   * Link to next page of resources.
   */
  @visibility("read")
  nextLink?: string;
}

/**
 * Endpoints accessed for a common purpose that the Api Management Service requires outbound network access to.
 */
model OutboundEnvironmentEndpoint {
  /**
   * The type of service accessed by the Api Management Service, e.g., Azure Storage, Azure SQL Database, and Azure Active Directory.
   */
  category?: string;

  /**
   * The endpoints that the Api Management Service reaches the service at.
   */
  endpoints?: EndpointDependency[];
}

/**
 * A domain name that a service is reached at.
 */
model EndpointDependency {
  /**
   * The domain name of the dependency.
   */
  domainName?: string;

  /**
   * The Ports used when connecting to DomainName.
   */
  endpointDetails?: EndpointDetail[];
}

/**
 * Current TCP connectivity information from the Api Management Service to a single endpoint.
 */
model EndpointDetail {
  /**
   * The port an endpoint is connected to.
   */
  port?: int32;

  /**
   * The region of the dependency.
   */
  region?: string;
}

/**
 * Descriptions of APIM policies.
 */
model PolicyDescriptionListResult {
  /**
   * Descriptions of APIM policies.
   */
  value?: PolicyDescriptionContract[];

  /**
   * Total record count number.
   */
  count?: int64;
}

/**
 * Policy description details.
 */
model PolicyDescriptionContract extends Resource {
  /**
   * Policy description contract properties.
   */
  properties?: PolicyDescriptionContractProperties;
}

/**
 * Policy description properties.
 */
model PolicyDescriptionContractProperties {
  /**
   * Policy description.
   */
  @visibility("read")
  description?: string;

  /**
   * Binary OR value of the Snippet scope.
   */
  @visibility("read")
  scope?: int64;
}

model PortalRevisionContractProperties {
  /**
   * Portal revision description.
   */
  @maxLength(2000)
  description?: string;

  /**
   * Portal revision publishing status details.
   */
  @visibility("read")
  @maxLength(2000)
  statusDetails?: string;

  /**
   * Status of the portal's revision.
   */
  @visibility("read")
  status?: PortalRevisionStatus;

  /**
   * Indicates if the portal's revision is public.
   */
  isCurrent?: boolean;

  /**
   * Portal's revision creation date and time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * Last updated date and time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedDateTime?: utcDateTime;
}

/**
 * Portal Settings for the Developer Portal.
 */
model PortalSettingsContract extends Resource {
  /**
   * Portal Settings contract properties.
   */
  properties?: PortalSettingsContractProperties;
}

/**
 * Sign-in settings contract properties.
 */
model PortalSettingsContractProperties {
  /**
   * A delegation Url.
   */
  url?: string;

  /**
   * A base64-encoded validation key to validate, that a request is coming from Azure API Management.
   */
  validationKey?: string;

  /**
   * Subscriptions delegation settings.
   */
  @encodedName("application/json", "subscriptions")
  IsSubscriptions?: SubscriptionsDelegationSettingsProperties;

  /**
   * User registration delegation settings.
   */
  @encodedName("application/json", "userRegistration")
  IsUserRegistration?: RegistrationDelegationSettingsProperties;

  /**
   * Redirect Anonymous users to the Sign-In page.
   */
  enabled?: boolean;

  /**
   * Terms of service contract properties.
   */
  termsOfService?: TermsOfServiceProperties;
}

/**
 * Subscriptions delegation settings properties.
 */
model SubscriptionsDelegationSettingsProperties {
  /**
   * Enable or disable delegation for subscriptions.
   */
  enabled?: boolean;
}

/**
 * User registration delegation settings properties.
 */
model RegistrationDelegationSettingsProperties {
  /**
   * Enable or disable delegation for user registration.
   */
  enabled?: boolean;
}

/**
 * Terms of service contract properties.
 */
model TermsOfServiceProperties {
  /**
   * A terms of service text.
   */
  text?: string;

  /**
   * Display terms of service during a sign-up process.
   */
  enabled?: boolean;

  /**
   * Ask user for consent to the terms of service.
   */
  consentRequired?: boolean;
}

/**
 * Sign-in settings contract properties.
 */
model PortalSigninSettingProperties {
  /**
   * Redirect Anonymous users to the Sign-In page.
   */
  enabled?: boolean;
}

/**
 * Sign-up settings contract properties.
 */
model PortalSignupSettingsProperties {
  /**
   * Allow users to sign up on a developer portal.
   */
  enabled?: boolean;

  /**
   * Terms of service contract properties.
   */
  termsOfService?: TermsOfServiceProperties;
}

/**
 * Delegation settings contract properties.
 */
model PortalDelegationSettingsProperties {
  /**
   * A delegation Url.
   */
  url?: string;

  /**
   * A base64-encoded validation key to validate, that a request is coming from Azure API Management.
   */
  validationKey?: string;

  /**
   * Subscriptions delegation settings.
   */
  subscriptions?: SubscriptionsDelegationSettingsProperties;

  /**
   * User registration delegation settings.
   */
  userRegistration?: RegistrationDelegationSettingsProperties;
}

/**
 * Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.
 */
model PortalSettingValidationKeyContract {
  /**
   * This is secret value of the validation key in portal settings.
   */
  validationKey?: string;
}

/**
 * Properties of the PrivateEndpointConnectProperties.
 */
model PrivateEndpointConnectionProperties {
  /**
   * The resource of private end point.
   */
  privateEndpoint?: PrivateEndpoint;

  /**
   * A collection of information about the state of the connection between service consumer and provider.
   */
  privateLinkServiceConnectionState: PrivateLinkServiceConnectionState;

  /**
   * The provisioning state of the private endpoint connection resource.
   */
  @visibility("read")
  provisioningState?: PrivateEndpointConnectionProvisioningState;
}

/**
 * The Private Endpoint resource.
 */
model PrivateEndpoint {
  /**
   * The ARM identifier for Private Endpoint
   */
  @visibility("read")
  id?: string;
}

/**
 * A request to approve or reject a private endpoint connection
 */
model PrivateEndpointConnectionRequest {
  /**
   * Private Endpoint Connection Resource Id.
   */
  id?: string;

  /**
   * The connection state of the private endpoint connection.
   */
  properties?: PrivateEndpointConnectionRequestProperties;
}

/**
 * The connection state of the private endpoint connection.
 */
model PrivateEndpointConnectionRequestProperties {
  /**
   * A collection of information about the state of the connection between service consumer and provider.
   */
  privateLinkServiceConnectionState?: PrivateLinkServiceConnectionState;
}

/**
 * Properties of a private link resource.
 */
model PrivateLinkResourceProperties {
  /**
   * The private link resource group id.
   */
  @visibility("read")
  groupId?: string;

  /**
   * The private link resource required member names.
   */
  @visibility("read")
  requiredMembers?: string[];

  /**
   * The private link resource Private link DNS zone name.
   */
  requiredZoneNames?: string[];
}

/**
 * Product Update parameters.
 */
model ProductUpdateParameters {
  /**
   * Product entity Update contract properties.
   */
  properties?: ProductUpdateProperties;
}

/**
 * Parameters supplied to the Update Product operation.
 */
model ProductUpdateProperties extends ProductEntityBaseParameters {
  /**
   * Product name.
   */
  @maxLength(300)
  @minLength(1)
  displayName?: string;
}

/**
 * Paged API list representation.
 */
model ApiManagementProductApiListResult is Azure.Core.Page<ProductApiData> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

model ProductApiData extends ApiContract {}

/**
 * Paged Group list representation.
 */
model ApiManagementProductGroupListResult is Azure.Core.Page<ProductGroupData> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

model ProductGroupData extends GroupContract {}

/**
 * Subscription details.
 */
model SubscriptionContractProperties {
  /**
   * The user resource identifier of the subscription owner. The value is a valid relative URL in the format of /users/{userId} where {userId} is a user identifier.
   */
  ownerId?: string;

  /**
   * Scope like /products/{productId} or /apis or /apis/{apiId}.
   */
  scope: string;

  /**
   * The name of the subscription, or null if the subscription has no name.
   */
  @maxLength(100)
  displayName?: string;

  /**
   * Subscription state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.
   */
  state: SubscriptionState;

  /**
   * Subscription creation date. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  /**
   * Subscription activation date. The setting is for audit purposes only and the subscription is not automatically activated. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDate?: utcDateTime;

  /**
   * Subscription expiration date. The setting is for audit purposes only and the subscription is not automatically expired. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDate?: utcDateTime;

  /**
   * Date when subscription was cancelled or expired. The setting is for audit purposes only and the subscription is not automatically cancelled. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDate?: utcDateTime;

  /**
   * Upcoming subscription expiration notification date. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  notificationDate?: utcDateTime;

  /**
   * Subscription primary key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  /**
   * Subscription secondary key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;

  /**
   * Optional subscription comment added by an administrator when the state is changed to the 'rejected'.
   */
  stateComment?: string;

  /**
   * Determines whether tracing is enabled
   */
  allowTracing?: boolean;
}

/**
 * Paged Quota Counter list representation.
 */
model QuotaCounterListResult {
  /**
   * Quota counter values.
   */
  value?: QuotaCounterContract[];

  /**
   * Total record count number across all pages.
   */
  count?: int64;

  /**
   * Next page link if any.
   */
  nextLink?: string;
}

/**
 * Quota counter details.
 */
@resource("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/periods/{quotaPeriodKey}")
model QuotaCounterContract {
  /**
   * The Key value of the Counter. Must not be empty.
   */
  @minLength(1)
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  counterKey: string;

  /**
   * Identifier of the Period for which the counter was collected. Must not be empty.
   */
  @minLength(1)
  periodKey: string;

  /**
   * The date of the start of Counter Period. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  periodStartTime: utcDateTime;

  /**
   * The date of the end of Counter Period. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  periodEndTime: utcDateTime;

  /**
   * Quota Value Properties
   */
  value?: QuotaCounterValueContractProperties;
}

/**
 * Quota counter value details.
 */
model QuotaCounterValueContractProperties {
  /**
   * Number of times Counter was called.
   */
  callsCount?: int32;

  /**
   * Data Transferred in KiloBytes.
   */
  kbTransferred?: float64;
}

/**
 * Quota counter value details.
 */
model QuotaCounterValueUpdateContract {
  /**
   * Quota counter value details.
   */
  properties?: QuotaCounterValueContractProperties;
}

/**
 * Lists Regions operation response details.
 */
model RegionListResult is Azure.Core.Page<RegionContract> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

/**
 * Region profile.
 */
model RegionContract {
  /**
   * Region name.
   */
  @visibility("read")
  name?: string;

  /**
   * whether Region is the master region.
   */
  isMasterRegion?: boolean;

  /**
   * whether Region is deleted.
   */
  isDeleted?: boolean;
}

/**
 * Paged Report records list representation.
 */
model ReportListResult is Azure.Core.Page<ReportRecordContract> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

/**
 * Report data.
 */
model ReportRecordContract {
  /**
   * Name depending on report endpoint specifies product, API, operation or developer name.
   */
  name?: string;

  /**
   * Start of aggregation period. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  /**
   * Length of aggregation period.  Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO 8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).
   */
  interval?: string;

  /**
   * Country to which this record data is related.
   */
  country?: string;

  /**
   * Country region to which this record data is related.
   */
  region?: string;

  /**
   * Zip code to which this record data is related.
   */
  zip?: string;

  /**
   * User identifier path. /users/{userId}
   */
  @visibility("read")
  userId?: string;

  /**
   * Product identifier path. /products/{productId}
   */
  @visibility("read")
  productId?: string;

  /**
   * API identifier path. /apis/{apiId}
   */
  apiId?: string;

  /**
   * Operation identifier path. /apis/{apiId}/operations/{operationId}
   */
  operationId?: string;

  /**
   * API region identifier.
   */
  apiRegion?: string;

  /**
   * Subscription identifier path. /subscriptions/{subscriptionId}
   */
  subscriptionId?: string;

  /**
   * Number of successful calls. This includes calls returning HttpStatusCode <= 301 and HttpStatusCode.NotModified and HttpStatusCode.TemporaryRedirect
   */
  callCountSuccess?: int32;

  /**
   * Number of calls blocked due to invalid credentials. This includes calls returning HttpStatusCode.Unauthorized and HttpStatusCode.Forbidden and HttpStatusCode.TooManyRequests
   */
  callCountBlocked?: int32;

  /**
   * Number of calls failed due to proxy or backend errors. This includes calls returning HttpStatusCode.BadRequest(400) and any Code between HttpStatusCode.InternalServerError (500) and 600
   */
  callCountFailed?: int32;

  /**
   * Number of other calls.
   */
  callCountOther?: int32;

  /**
   * Total number of calls.
   */
  callCountTotal?: int32;

  /**
   * Bandwidth consumed.
   */
  bandwidth?: int64;

  /**
   * Number of times when content was served from cache policy.
   */
  cacheHitCount?: int32;

  /**
   * Number of times content was fetched from backend.
   */
  cacheMissCount?: int32;

  /**
   * Average time it took to process request.
   */
  apiTimeAvg?: float64;

  /**
   * Minimum time it took to process request.
   */
  apiTimeMin?: float64;

  /**
   * Maximum time it took to process request.
   */
  apiTimeMax?: float64;

  /**
   * Average time it took to process request on backend.
   */
  serviceTimeAvg?: float64;

  /**
   * Minimum time it took to process request on backend.
   */
  serviceTimeMin?: float64;

  /**
   * Maximum time it took to process request on backend.
   */
  serviceTimeMax?: float64;
}

/**
 * Paged Report records list representation.
 */
@pagedResult
model RequestReportListResult {
  /**
   * Page values.
   */
  @items
  value?: RequestReportRecordContract[];

  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

/**
 * Request Report data.
 */
model RequestReportRecordContract {
  /**
   * API identifier path. /apis/{apiId}
   */
  apiId?: string;

  /**
   * Operation identifier path. /apis/{apiId}/operations/{operationId}
   */
  operationId?: string;

  /**
   * Product identifier path. /products/{productId}
   */
  @visibility("read")
  productId?: string;

  /**
   * User identifier path. /users/{userId}
   */
  @visibility("read")
  userId?: string;

  /**
   * The HTTP method associated with this request..
   */
  method?: string;

  /**
   * The full URL associated with this request.
   */
  url?: string;

  /**
   * The client IP address associated with this request.
   */
  ipAddress?: string;

  /**
   * The HTTP status code received by the gateway as a result of forwarding this request to the backend.
   */
  backendResponseCode?: string;

  /**
   * The HTTP status code returned by the gateway.
   */
  responseCode?: int32;

  /**
   * The size of the response returned by the gateway.
   */
  responseSize?: int32;

  /**
   * The date and time when this request was received by the gateway in ISO 8601 format.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  /**
   * Specifies if response cache was involved in generating the response. If the value is none, the cache was not used. If the value is hit, cached response was returned. If the value is miss, the cache was used but lookup resulted in a miss and request was fulfilled by the backend.
   */
  cache?: string;

  /**
   * The total time it took to process this request.
   */
  apiTime?: float64;

  /**
   * he time it took to forward this request to the backend and get the response back.
   */
  serviceTime?: float64;

  /**
   * Azure region where the gateway that processed this request is located.
   */
  apiRegion?: string;

  /**
   * Subscription identifier path. /subscriptions/{subscriptionId}
   */
  subscriptionId?: string;

  /**
   * Request Identifier.
   */
  requestId?: string;

  /**
   * The size of this request..
   */
  requestSize?: int32;
}

/**
 * Schema create or update contract Properties.
 */
model GlobalSchemaContractProperties {
  /**
   * Schema Type. Immutable.
   */
  schemaType: SchemaType;

  /**
   * Free-form schema entity description.
   */
  description?: string;

  /**
   * Json-encoded string for non json-based schema.
   */
  value?: unknown;

  /**
   * Global Schema document object for json-based schema formats(e.g. json schema).
   */
  document?: Record<unknown>;
}

/**
 * Tenant access information contract of the API Management service.
 */
model TenantSettingsContractProperties {
  /**
   * Tenant settings
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  settings?: Record<string>;
}

/**
 * The List Resource Skus operation response.
 */
model ApiManagementSkusResult is Azure.Core.Page<ApiManagementSku>;

/**
 * Describes an available ApiManagement SKU.
 */
model ApiManagementSku {
  /**
   * The type of resource the SKU applies to.
   */
  @visibility("read")
  resourceType?: string;

  /**
   * The name of SKU.
   */
  @visibility("read")
  name?: string;

  /**
   * Specifies the tier of virtual machines in a scale set.<br /><br /> Possible Values:<br /><br /> **Standard**<br /><br /> **Basic**
   */
  @visibility("read")
  tier?: string;

  /**
   * The Size of the SKU.
   */
  @visibility("read")
  size?: string;

  /**
   * The Family of this particular SKU.
   */
  @visibility("read")
  family?: string;

  /**
   * The Kind of resources that are supported in this SKU.
   */
  @visibility("read")
  kind?: string;

  /**
   * Specifies the number of virtual machines in the scale set.
   */
  @visibility("read")
  capacity?: ApiManagementSkuCapacity;

  /**
   * The set of locations that the SKU is available.
   */
  @visibility("read")
  locations?: string[];

  /**
   * A list of locations and availability zones in those locations where the SKU is available.
   */
  @visibility("read")
  locationInfo?: ApiManagementSkuLocationInfo[];

  /**
   * The api versions that support this SKU.
   */
  @visibility("read")
  apiVersions?: string[];

  /**
   * Metadata for retrieving price info.
   */
  @visibility("read")
  costs?: ApiManagementSkuCosts[];

  /**
   * A name value pair to describe the capability.
   */
  @visibility("read")
  capabilities?: ApiManagementSkuCapabilities[];

  /**
   * The restrictions because of which SKU cannot be used. This is empty if there are no restrictions.
   */
  @visibility("read")
  restrictions?: ApiManagementSkuRestrictions[];
}

/**
 * Describes scaling information of a SKU.
 */
model ApiManagementSkuCapacity {
  /**
   * The minimum capacity.
   */
  @visibility("read")
  minimum?: int32;

  /**
   * The maximum capacity that can be set.
   */
  @visibility("read")
  maximum?: int32;

  /**
   * The default capacity.
   */
  @visibility("read")
  default?: int32;

  /**
   * The scale type applicable to the sku.
   */
  @visibility("read")
  scaleType?: ApiManagementSkuCapacityScaleType;
}

model ApiManagementSkuLocationInfo {
  /**
   * Location of the SKU
   */
  @visibility("read")
  location?: string;

  /**
   * List of availability zones where the SKU is supported.
   */
  @visibility("read")
  zones?: string[];

  /**
   * Details of capabilities available to a SKU in specific zones.
   */
  @visibility("read")
  zoneDetails?: ApiManagementSkuZoneDetails[];
}

/**
 * Describes The zonal capabilities of a SKU.
 */
model ApiManagementSkuZoneDetails {
  /**
   * The set of zones that the SKU is available in with the specified capabilities.
   */
  @visibility("read")
  name?: string[];

  /**
   * A list of capabilities that are available for the SKU in the specified list of zones.
   */
  @visibility("read")
  capabilities?: ApiManagementSkuCapabilities[];
}

/**
 * Describes The SKU capabilities object.
 */
model ApiManagementSkuCapabilities {
  /**
   * An invariant to describe the feature.
   */
  @visibility("read")
  name?: string;

  /**
   * An invariant if the feature is measured by quantity.
   */
  @visibility("read")
  value?: string;
}

/**
 * Describes metadata for retrieving price info.
 */
model ApiManagementSkuCosts {
  /**
   * Used for querying price from commerce.
   */
  @visibility("read")
  meterID?: string;

  /**
   * The multiplier is needed to extend the base metered cost.
   */
  @visibility("read")
  quantity?: int64;

  /**
   * An invariant to show the extended unit.
   */
  @visibility("read")
  extendedUnit?: string;
}

/**
 * Describes scaling information of a SKU.
 */
model ApiManagementSkuRestrictions {
  /**
   * The type of restrictions.
   */
  @visibility("read")
  type?: ApiManagementSkuRestrictionsType;

  /**
   * The value of restrictions. If the restriction type is set to location. This would be different locations where the SKU is restricted.
   */
  @visibility("read")
  values?: string[];

  /**
   * The information about the restriction where the SKU cannot be used.
   */
  @visibility("read")
  restrictionInfo?: ApiManagementSkuRestrictionInfo;

  /**
   * The reason for restriction.
   */
  @visibility("read")
  reasonCode?: ApiManagementSkuRestrictionsReasonCode;
}

model ApiManagementSkuRestrictionInfo {
  /**
   * Locations where the SKU is restricted
   */
  @visibility("read")
  locations?: string[];

  /**
   * List of availability zones where the SKU is restricted.
   */
  @visibility("read")
  zones?: string[];
}

/**
 * Subscription create details.
 */
model SubscriptionCreateParameters {
  /**
   * Subscription contract properties.
   */
  properties?: SubscriptionCreateParameterProperties;
}

/**
 * Parameters supplied to the Create subscription operation.
 */
model SubscriptionCreateParameterProperties {
  /**
   * User (user id path) for whom subscription is being created in form /users/{userId}
   */
  ownerId?: string;

  /**
   * Scope like /products/{productId} or /apis or /apis/{apiId}.
   */
  scope: string;

  /**
   * Subscription name.
   */
  @maxLength(100)
  @minLength(1)
  displayName: string;

  /**
   * Primary subscription key. If not specified during request key will be generated automatically.
   */
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  /**
   * Secondary subscription key. If not specified during request key will be generated automatically.
   */
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;

  /**
   * Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.
   */
  state?: SubscriptionState;

  /**
   * Determines whether tracing can be enabled
   */
  allowTracing?: boolean;
}

/**
 * Subscription update details.
 */
model SubscriptionUpdateParameters {
  /**
   * Subscription Update contract properties.
   */
  properties?: SubscriptionUpdateParameterProperties;
}

/**
 * Parameters supplied to the Update subscription operation.
 */
model SubscriptionUpdateParameterProperties {
  /**
   * User identifier path: /users/{userId}
   */
  ownerId?: string;

  /**
   * Scope like /products/{productId} or /apis or /apis/{apiId}
   */
  scope?: string;

  /**
   * Subscription expiration date. The setting is for audit purposes only and the subscription is not automatically expired. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDate?: utcDateTime;

  /**
   * Subscription name.
   */
  displayName?: string;

  /**
   * Primary subscription key.
   */
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  /**
   * Secondary subscription key.
   */
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;

  /**
   * Subscription state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.
   */
  state?: SubscriptionState;

  /**
   * Comments describing subscription state change by the administrator when the state is changed to the 'rejected'.
   */
  stateComment?: string;

  /**
   * Determines whether tracing can be enabled
   */
  allowTracing?: boolean;
}

/**
 * Subscription keys.
 */
model SubscriptionKeysContract {
  /**
   * Subscription primary key.
   */
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  /**
   * Subscription secondary key.
   */
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;
}

/**
 * Parameters supplied to Create/Update Tag operations.
 */
model TagCreateUpdateParameters {
  /**
   * Properties supplied to Create Tag operation.
   */
  properties?: TagContractProperties;
}

/**
 * Tenant access information contract of the API Management service.
 */
model AccessInformationContractProperties {
  /**
   * Access Information type ('access' or 'gitAccess')
   */
  id?: string;

  /**
   * Principal (User) Identifier.
   */
  principalId?: string;

  /**
   * Determines whether direct access is enabled.
   */
  enabled?: boolean;
}

/**
 * Tenant access information update parameters.
 */
model AccessInformationCreateParameters {
  /**
   * Tenant access information update parameter properties.
   */
  properties?: AccessInformationCreateParameterProperties;
}

/**
 * Tenant access information update parameters of the API Management service
 */
model AccessInformationCreateParameterProperties {
  /**
   * Principal (User) Identifier.
   */
  principalId?: string;

  /**
   * Primary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  primaryKey?: string;

  /**
   * Secondary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  secondaryKey?: string;

  /**
   * Determines whether direct access is enabled.
   */
  enabled?: boolean;
}

/**
 * Tenant access information update parameters.
 */
model AccessInformationUpdateParameters {
  /**
   * Tenant access information update parameter properties.
   */
  properties?: AccessInformationUpdateParameterProperties;
}

/**
 * Tenant access information update parameters of the API Management service
 */
model AccessInformationUpdateParameterProperties {
  /**
   * Determines whether direct access is enabled.
   */
  enabled?: boolean;
}

/**
 * Tenant access information contract of the API Management service.
 */
model AccessInformationSecretsContract {
  /**
   * Access Information type ('access' or 'gitAccess')
   */
  id?: string;

  /**
   * Principal (User) Identifier.
   */
  principalId?: string;

  /**
   * Primary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  primaryKey?: string;

  /**
   * Secondary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.
   */
  secondaryKey?: string;

  /**
   * Determines whether direct access is enabled.
   */
  enabled?: boolean;
}

/**
 * Deploy Tenant Configuration Contract.
 */
model DeployConfigurationParameters {
  /**
   * Deploy Configuration Parameter contract properties.
   */
  properties?: DeployConfigurationParameterProperties;
}

/**
 * Parameters supplied to the Deploy Configuration operation.
 */
model DeployConfigurationParameterProperties {
  /**
   * The name of the Git branch from which the configuration is to be deployed to the configuration database.
   */
  branch: string;

  /**
   * The value enforcing deleting subscriptions to products that are deleted in this update.
   */
  force?: boolean;
}

/**
 * Long Running Git Operation Results.
 */
model OperationResultContract extends Resource {
  /**
   * Properties of the Operation Contract.
   */
  properties?: OperationResultContractProperties;
}

/**
 * Operation Result.
 */
model OperationResultContractProperties {
  /**
   * Operation result identifier.
   */
  id?: string;

  /**
   * Status of an async operation.
   */
  status?: AsyncOperationStatus;

  /**
   * Start time of an async operation. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  started?: utcDateTime;

  /**
   * Last update time of an async operation. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updated?: utcDateTime;

  /**
   * Optional result info.
   */
  resultInfo?: string;

  /**
   * Error Body Contract
   */
  error?: ErrorResponseBody;

  /**
   * This property if only provided as part of the TenantConfiguration_Validate operation. It contains the log the entities which will be updated/created/deleted as part of the TenantConfiguration_Deploy operation.
   */
  @visibility("read")
  actionLog?: OperationResultLogItemContract[];
}

/**
 * Log of the entity being created, updated or deleted.
 */
model OperationResultLogItemContract {
  /**
   * The type of entity contract.
   */
  objectType?: string;

  /**
   * Action like create/update/delete.
   */
  action?: string;

  /**
   * Identifier of the entity being created/updated/deleted.
   */
  objectKey?: string;
}

/**
 * Save Tenant Configuration Contract details.
 */
model SaveConfigurationParameter {
  /**
   * Properties of the Save Configuration Parameters.
   */
  properties?: SaveConfigurationParameterProperties;
}

/**
 * Parameters supplied to the Save Tenant Configuration operation.
 */
model SaveConfigurationParameterProperties {
  /**
   * The name of the Git branch in which to commit the current configuration snapshot.
   */
  branch: string;

  /**
   * The value if true, the current configuration database is committed to the Git repository, even if the Git repository has newer changes that would be overwritten.
   */
  force?: boolean;
}

/**
 * Result of Tenant Configuration Sync State.
 */
model TenantConfigurationSyncStateContract extends Resource {
  /**
   * Properties returned Tenant Configuration Sync State check.
   */
  properties?: TenantConfigurationSyncStateContractProperties;
}

/**
 * Tenant Configuration Synchronization State.
 */
model TenantConfigurationSyncStateContractProperties {
  /**
   * The name of Git branch.
   */
  branch?: string;

  /**
   * The latest commit Id.
   */
  commitId?: string;

  /**
   * value indicating if last sync was save (true) or deploy (false) operation.
   */
  isExport?: boolean;

  /**
   * value indicating if last synchronization was later than the configuration change.
   */
  isSynced?: boolean;

  /**
   * value indicating whether Git configuration access is enabled.
   */
  isGitEnabled?: boolean;

  /**
   * The date of the latest synchronization. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  syncDate?: utcDateTime;

  /**
   * The date of the latest configuration change. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  configurationChangeDate?: utcDateTime;

  /**
   * Most recent tenant configuration operation identifier
   */
  lastOperationId?: string;
}

/**
 * User create details.
 */
model UserCreateParameters {
  /**
   * User entity create contract properties.
   */
  properties?: UserCreateParameterProperties;
}

/**
 * Parameters supplied to the Create User operation.
 */
model UserCreateParameterProperties extends UserEntityBaseParameters {
  /**
   * Email address. Must not be empty and must be unique within the service instance.
   */
  @maxLength(254)
  @minLength(1)
  email: string;

  /**
   * First name.
   */
  @maxLength(100)
  @minLength(1)
  firstName: string;

  /**
   * Last name.
   */
  @maxLength(100)
  @minLength(1)
  lastName: string;

  /**
   * User Password. If no value is provided, a default password is generated.
   */
  password?: string;

  /**
   * Determines the type of application which send the create user request. Default is legacy portal.
   */
  appType?: AppType;

  /**
   * Determines the type of confirmation e-mail that will be sent to the newly created user.
   */
  confirmation?: Confirmation;
}

/**
 * User update parameters.
 */
model UserUpdateParameters {
  /**
   * User entity update contract properties.
   */
  properties?: UserUpdateParametersProperties;
}

/**
 * Parameters supplied to the Update User operation.
 */
model UserUpdateParametersProperties extends UserEntityBaseParameters {
  /**
   * Email address. Must not be empty and must be unique within the service instance.
   */
  @maxLength(254)
  @minLength(1)
  email?: string;

  /**
   * User Password.
   */
  password?: string;

  /**
   * First name.
   */
  @maxLength(100)
  @minLength(1)
  firstName?: string;

  /**
   * Last name.
   */
  @maxLength(100)
  @minLength(1)
  lastName?: string;
}

/**
 * Generate SSO Url operations response details.
 */
model GenerateSsoUrlResult {
  /**
   * Redirect Url containing the SSO URL value.
   */
  value?: string;
}

/**
 * List of Users Identity list representation.
 */
model UserIdentityListResult is Azure.Core.Page<UserIdentityContract> {
  /**
   * Total record count number across all pages.
   */
  count?: int64;
}

/**
 * Get User Token parameters.
 */
model UserTokenParameters {
  /**
   * User Token Parameter contract properties.
   */
  properties?: UserTokenParameterProperties;
}

/**
 * Parameters supplied to the Get User Token operation.
 */
model UserTokenParameterProperties {
  /**
   * The Key to be used to generate token for user.
   */
  keyType: KeyType;

  /**
   * The Expiry time of the Token. Maximum token expiry time is set to 30 days. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.
   *
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiry: utcDateTime;
}

/**
 * Get User Token response details.
 */
model UserTokenResult {
  /**
   * Shared Access Authorization token for the User.
   */
  value?: string;
}

/**
 * Object used to create an API Revision or Version based on an existing API Revision
 */
model ApiRevisionInfoContract {
  /**
   * Resource identifier of API to be used to create the revision from.
   */
  sourceApiId?: string;

  /**
   * Version identifier for the new API Version.
   */
  @maxLength(100)
  apiVersionName?: string;

  /**
   * Description of new API Revision.
   */
  @maxLength(256)
  apiRevisionDescription?: string;

  /**
   * Version set details
   */
  apiVersionSet?: ApiVersionSetContractDetails;
}

/**
 * Quota counter value details.
 */
model QuotaCounterValueContract {
  /**
   * Quota counter Value Properties.
   */
  value?: QuotaCounterValueContractProperties;
}
