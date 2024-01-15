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

@doc("An value that determines where the API Version identifier will be located in a HTTP request.")
enum VersioningScheme {
  Segment,
  Query,
  Header,
}

enum BearerTokenSendingMethod {
  authorizationHeader,
  query,
}

@doc("Type of API.")
enum ApiType {
  http,
  soap,
  websocket,
  graphql,
}

@doc("Format of the Content in which the API is getting imported.")
enum ContentFormat {
  @doc("The contents are inline and Content type is a WADL document.")
  `wadl-xml`,
  @doc("The WADL document is hosted on a publicly accessible internet address.")
  `wadl-link-json`,
  @doc("The contents are inline and Content Type is a OpenAPI 2.0 JSON Document.")
  `swagger-json`,
  @doc("The OpenAPI 2.0 JSON document is hosted on a publicly accessible internet address.")
  `swagger-link-json`,
  @doc("The contents are inline and the document is a WSDL/Soap document.")
  wsdl,
  @doc("The WSDL document is hosted on a publicly accessible internet address.")
  `wsdl-link`,
  @doc("The contents are inline and Content Type is a OpenAPI 3.0 YAML Document.")
  openapi,
  @doc("The contents are inline and Content Type is a OpenAPI 3.0 JSON Document.")
  `openapi+json`,
  @doc("The OpenAPI 3.0 YAML document is hosted on a publicly accessible internet address.")
  `openapi-link`,
  @doc("The OpenAPI 3.0 JSON document is hosted on a publicly accessible internet address.")
  `openapi+json-link`,
  @doc("The GraphQL API endpoint hosted on a publicly accessible internet address.")
  `graphql-link`,
}

@doc("""
Type of API to create. 
 * `http` creates a REST API 
 * `soap` creates a SOAP pass-through API  
 * `websocket` creates websocket API 
 * `graphql` creates GraphQL API.
""")
enum SoapApiType {
  @doc("Imports a SOAP API having a RESTful front end.") SoapToRest: "http",
  @doc("Imports the SOAP API having a SOAP front end.") SoapPassThrough: "soap",
  @doc("Imports the API having a Websocket front end.") WebSocket: "websocket",
  @doc("Imports the API having a GraphQL front end.") GraphQL: "graphql",
}

@doc("Format of the policyContent.")
enum PolicyContentFormat {
  @doc("The contents are inline and Content type is an XML document.") xml,
  @doc("The policy XML document is hosted on a http endpoint accessible from the API Management service.")
  `xml-link`,
  @doc("The contents are inline and Content type is a non XML encoded policy document.")
  rawxml,
  @doc("The policy document is not Xml encoded and is hosted on a http endpoint accessible from the API Management service.")
  `rawxml-link`,
}

enum PolicyIdName {
  policy,
}

enum PolicyExportFormat {
  @doc("The contents are inline and Content type is an XML document.") xml,
  @doc("The contents are inline and Content type is a non XML encoded policy document.")
  rawxml,
}

@doc("Specifies for what type of messages sampling settings should not apply.")
enum AlwaysLog {
  @doc("Always log all erroneous request regardless of sampling settings.")
  allErrors,
}

@doc("Sampling type.")
enum SamplingType {
  @doc("Fixed-rate sampling.") fixed,
}

@doc("Data masking mode.")
enum DataMaskingMode {
  @doc("Mask the value of an entity.") Mask,
  @doc("Hide the presence of an entity.") Hide,
}

@doc("Sets correlation protocol to use for Application Insights diagnostics.")
enum HttpCorrelationProtocol {
  @doc("Do not read and inject correlation headers.") None,
  @doc("Inject Request-Id and Request-Context headers with request correlation data. See https://github.com/dotnet/corefx/blob/master/src/System.Diagnostics.DiagnosticSource/src/HttpCorrelationProtocol.md.")
  Legacy,
  @doc("Inject Trace Context headers. See https://w3c.github.io/trace-context.")
  W3C,
}

@doc("The verbosity level applied to traces emitted by trace policies.")
enum Verbosity {
  @doc("All the traces emitted by trace policies will be sent to the logger attached to this diagnostic instance.")
  verbose,
  @doc("Traces with 'severity' set to 'information' and 'error' will be sent to the logger attached to this diagnostic instance.")
  information,
  @doc("Only traces with 'severity' set to 'error' will be sent to the logger attached to this diagnostic instance.")
  error,
}

@doc("The format of the Operation Name for Application Insights telemetries. Default is Name.")
enum OperationNameFormat {
  @doc("API_NAME;rev=API_REVISION - OPERATION_NAME") Name,
  @doc("HTTP_VERB URL") Url,
}

@doc("Status of the issue.")
enum State {
  @doc("The issue is proposed.") proposed,
  @doc("The issue is opened.") open,
  @doc("The issue was removed.") removed,
  @doc("The issue is now resolved.") resolved,
  @doc("The issue was closed.") closed,
}

enum ExportFormat {
  @doc("Export the Api Definition in OpenAPI 2.0 Specification as JSON document to the Storage Blob.")
  Swagger: "swagger-link",
  @doc("Export the Api Definition in WSDL Schema to Storage Blob. This is only supported for APIs of Type `soap`")
  Wsdl: "wsdl-link",
  @doc("Export the Api Definition in WADL Schema to Storage Blob.")
  Wadl: "wadl-link",
  @doc("Export the Api Definition in OpenAPI 3.0 Specification as YAML document to Storage Blob.")
  Openapi: "openapi-link",
  @doc("Export the Api Definition in OpenAPI 3.0 Specification as JSON document to Storage Blob.")
  OpenapiJson: "openapi+json-link",
}

enum ExportApi {
  `true`,
}

@doc("Format in which the API Details are exported to the Storage Blob with Sas Key valid for 5 minutes.")
enum ExportResultFormat {
  @doc("The API Definition is exported in OpenAPI Specification 2.0 format to the Storage Blob.")
  Swagger: "swagger-link-json",
  @doc("The API Definition is exported in WSDL Schema to Storage Blob. This is only supported for APIs of Type `soap`")
  Wsdl: "wsdl-link+xml",
  @doc("Export the API Definition in WADL Schema to Storage Blob.")
  Wadl: "wadl-link-json",
  @doc("Export the API Definition in OpenAPI Specification 3.0 to Storage Blob.")
  OpenApi: "openapi-link",
}

enum GrantType {
  @doc("Authorization Code Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.1.")
  authorizationCode,
  @doc("Implicit Code Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.2.")
  implicit,
  @doc("Resource Owner Password Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.3.")
  resourceOwnerPassword,
  @doc("Client Credentials Grant flow as described https://tools.ietf.org/html/rfc6749#section-4.4.")
  clientCredentials,
}

enum ClientAuthenticationMethod {
  @doc("Basic Client Authentication method.") Basic,
  @doc("Body based Authentication method.") Body,
}

@doc("Backend communication protocol.")
enum BackendProtocol {
  @doc("The Backend is a RESTful service.") http,
  @doc("The Backend is a SOAP service.") soap,
}

@doc("The IP version to be used. Only IPv4 is supported for now.")
enum PreferredIPVersion {
  IPv4,
}

@doc("The request's protocol. Specific protocol configuration can be available based on this selection. The specified destination address must be coherent with this value.")
enum ConnectivityCheckProtocol {
  TCP,
  HTTP,
  HTTPS,
}

@doc("The HTTP method to be used.")
enum Method {
  GET,
  POST,
}

@doc("The severity of the issue.")
enum Severity {
  Error,
  Warning,
}

@doc("The type of issue.")
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

@doc("The connection status.")
enum ConnectionStatus {
  Unknown,
  Connected,
  Disconnected,
  Degraded,
}

@doc("Name of the Sku.")
enum SkuType {
  @doc("Developer SKU of Api Management.") Developer,
  @doc("Standard SKU of Api Management.") Standard,
  @doc("Premium SKU of Api Management.") Premium,
  @doc("Basic SKU of Api Management.") Basic,
  @doc("Consumption SKU of Api Management.") Consumption,
  @doc("Isolated SKU of Api Management.") Isolated,
}

@doc("The scale type applicable to the sku.")
enum ResourceSkuCapacityScaleType {
  @doc("Supported scale type automatic.") automatic,
  @doc("Supported scale type manual.") manual,
  @doc("Scaling not supported.") none,
}

@doc("The type of access to be used for the storage account.")
enum AccessType {
  @doc("Use access key.") AccessKey,
  @doc("Use system assigned managed identity.") SystemAssignedManagedIdentity,
  @doc("Use user assigned managed identity.") UserAssignedManagedIdentity,
}

@doc("Hostname type.")
enum HostnameType {
  Proxy,
  Portal,
  Management,
  Scm,
  DeveloperPortal,
}

@doc("Certificate Source.")
enum CertificateSource {
  Managed,
  KeyVault,
  Custom,
  BuiltIn,
}

@doc("Certificate Status.")
enum CertificateStatus {
  Completed,
  Failed,
  InProgress,
}

@doc("Whether or not public endpoint access is allowed for this API Management service.  Value is optional but if passed in, must be 'Enabled' or 'Disabled'. If 'Disabled', private endpoints are the exclusive access method. Default value is 'Enabled'")
enum PublicNetworkAccess {
  Enabled,
  Disabled,
}

@doc("Compute Platform Version running the service.")
enum PlatformVersion {
  @doc("Platform version cannot be determined, as compute platform is not deployed.")
  undetermined,
  @doc("Platform running the service on Single Tenant V1 platform.") stv1,
  @doc("Platform running the service on Single Tenant V2 platform.") stv2,
  @doc("Platform running the service on Multi Tenant V1 platform.") mtv1,
}

@doc("The System.Security.Cryptography.x509certificates.StoreName certificate store location. Only Root and CertificateAuthority are valid locations.")
enum CertificateConfigurationStoreName {
  CertificateAuthority,
  Root,
}

@doc("The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.")
enum VirtualNetworkType {
  @doc("The service is not part of any Virtual Network.") None,
  @doc("The service is part of Virtual Network and it is accessible from Internet.")
  External,
  @doc("The service is part of Virtual Network and it is only accessible from within the virtual network.")
  Internal,
}

@doc("The private endpoint connection status.")
enum PrivateEndpointServiceConnectionStatus {
  Pending,
  Approved,
  Rejected,
}

@doc("The type of identity used for the resource. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the service.")
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

@doc("Account state. Specifies whether the user is active or not. Blocked users are unable to sign into the developer portal or call any APIs of subscribed products. Default state is Active.")
enum UserState {
  @doc("User state is active.") active,
  @doc("User is blocked. Blocked users cannot authenticate at developer portal or call API.")
  blocked,
  @doc("User account is pending. Requires identity confirmation before it can be made active.")
  pending,
  @doc("User account is closed. All identities and related entities are removed.")
  deleted,
}

enum IdentityProviderType {
  @doc("Facebook as Identity provider.") facebook,
  @doc("Google as Identity provider.") google,
  @doc("Microsoft Live as Identity provider.") microsoft,
  @doc("Twitter as Identity provider.") twitter,
  @doc("Azure Active Directory as Identity provider.") aad,
  @doc("Azure Active Directory B2C as Identity provider.") aadB2C,
}

@doc("Logger type.")
enum LoggerType {
  @doc("Azure Event Hub as log destination.") azureEventHub,
  @doc("Azure Application Insights as log destination.") applicationInsights,
  @doc("Azure Monitor") azureMonitor,
}

@doc("Resource Connectivity Status Type identifier.")
enum ConnectivityStatusType {
  initializing,
  success,
  failure,
}

enum NotificationName {
  @doc("The following email recipients and users will receive email notifications about subscription requests for API products requiring approval.")
  RequestPublisherNotificationMessage,
  @doc("The following email recipients and users will receive email notifications about new API product subscriptions.")
  PurchasePublisherNotificationMessage,
  @doc("The following email recipients and users will receive email notifications when new applications are submitted to the application gallery.")
  NewApplicationNotificationMessage,
  @doc("The following recipients will receive blind carbon copies of all emails sent to developers.")
  BCC,
  @doc("The following email recipients and users will receive email notifications when a new issue or comment is submitted on the developer portal.")
  NewIssuePublisherNotificationMessage,
  @doc("The following email recipients and users will receive email notifications when developer closes his account.")
  AccountClosedPublisher,
  @doc("The following email recipients and users will receive email notifications when subscription usage gets close to usage quota.")
  QuotaLimitApproachingPublisherNotificationMessage,
}

@doc("Status of the portal's revision.")
enum PortalRevisionStatus {
  @doc("Portal's revision has been queued.") pending,
  @doc("Portal's revision is being published.") publishing,
  @doc("Portal's revision publishing completed.") completed,
  @doc("Portal's revision publishing failed.") failed,
}

@doc("The current provisioning state.")
enum PrivateEndpointConnectionProvisioningState {
  Succeeded,
  Creating,
  Deleting,
  Failed,
}

@doc("Schema Type. Immutable.")
enum SchemaType {
  @doc("Xml schema type.") Xml: "xml",
  @doc("Json schema type.") Json: "json",
}

enum SettingsTypeName {
  public,
}

enum AppType {
  @doc("User create request was sent by legacy developer portal.") portal,
  @doc("User create request was sent by new developer portal.") developerPortal,
}

enum AccessIdName {
  access,
  gitAccess,
}

enum ConfigurationIdName {
  configuration,
}

@doc("Determines the type of confirmation e-mail that will be sent to the newly created user.")
enum Confirmation {
  @doc("Send an e-mail to the user confirming they have successfully signed up.")
  signup,
  @doc("Send an e-mail inviting the user to sign-up and complete registration.")
  invite,
}

@doc("whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished.")
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

@doc("Invalid indicates the name provided does not match the resource provider’s naming requirements (incorrect length, unsupported characters, etc.)  AlreadyExists indicates that the name is already in use and is therefore unavailable.")
@fixed
enum NameAvailabilityReason {
  Valid,
  Invalid,
  AlreadyExists,
}

@doc("The Key being regenerated.")
@fixed
enum GatewayRegenerateKeyType {
  primary,
  secondary,
}

@doc("The Key to be used to generate token for user.")
@fixed
enum KeyType {
  primary,
  secondary,
}

@doc("Group type.")
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

@doc("Subscription state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.")
@fixed
enum SubscriptionState {
  suspended,
  active,
  expired,
  submitted,
  rejected,
  cancelled,
}

@doc("The scale type applicable to the sku.")
@fixed
enum ApiManagementSkuCapacityScaleType {
  Automatic,
  Manual,
  None,
}

@doc("The type of restrictions.")
@fixed
enum ApiManagementSkuRestrictionsType {
  Location,
  Zone,
}

@doc("The reason for restriction.")
@fixed
enum ApiManagementSkuRestrictionsReasonCode {
  QuotaId,
  NotAvailableForSubscription,
}

@doc("Status of an async operation.")
@fixed
enum AsyncOperationStatus {
  Started,
  InProgress,
  Succeeded,
  Failed,
}

@doc("API Entity Properties")
model ApiContractProperties extends ApiEntityBaseContract {
  @doc("API identifier of the source API.")
  sourceApiId?: string;

  @doc("API name. Must be 1 to 300 characters long.")
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  @doc("Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.")
  @maxLength(2000)
  serviceUrl?: string;

  @doc("Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.")
  @maxLength(400)
  path: string;

  @doc("Describes on which protocols the operations in this API can be invoked.")
  protocols?: Protocol[];

  @doc("Version set details")
  apiVersionSet?: ApiVersionSetContractDetails;
}

@doc("An API Version Set contains the common configuration for a set of API Versions relating ")
model ApiVersionSetContractDetails {
  @doc("Identifier for existing API Version Set. Omit this value to create a new Version Set.")
  id?: string;

  @doc("The display Name of the API Version Set.")
  name?: string;

  @doc("Description of API Version Set.")
  description?: string;

  @doc("An value that determines where the API Version identifier will be located in a HTTP request.")
  versioningScheme?: VersioningScheme;

  @doc("Name of query parameter that indicates the API Version if versioningScheme is set to `query`.")
  versionQueryName?: string;

  @doc("Name of HTTP header parameter that indicates the API Version if versioningScheme is set to `header`.")
  versionHeaderName?: string;
}

@doc("API base contract details.")
model ApiEntityBaseContract {
  @doc("Description of the API. May include HTML formatting tags.")
  description?: string;

  @doc("Collection of authentication settings included into this API.")
  authenticationSettings?: AuthenticationSettingsContract;

  @doc("Protocols over which API is made available.")
  subscriptionKeyParameterNames?: SubscriptionKeyParameterNamesContract;

  @doc("Type of API.")
  @projectedName("json", "type")
  apiType?: ApiType;

  @doc("Describes the revision of the API. If no value is provided, default revision 1 is created")
  @maxLength(100)
  @minLength(1)
  apiRevision?: string;

  @doc("Indicates the version identifier of the API if the API is versioned")
  @maxLength(100)
  apiVersion?: string;

  @doc("Indicates if API revision is current api revision.")
  isCurrent?: boolean;

  @doc("Indicates if API revision is accessible via the gateway.")
  @visibility("read")
  isOnline?: boolean;

  @doc("Description of the API Revision.")
  @maxLength(256)
  apiRevisionDescription?: string;

  @doc("Description of the API Version.")
  @maxLength(256)
  apiVersionDescription?: string;

  @doc("A resource identifier for the related ApiVersionSet.")
  apiVersionSetId?: string;

  @doc("Specifies whether an API or Product subscription is required for accessing the API.")
  @projectedName("json", "subscriptionRequired")
  IsSubscriptionRequired?: boolean;

  @doc(" A URL to the Terms of Service for the API. MUST be in the format of a URL.")
  termsOfServiceUrl?: string;

  @doc("Contact information for the API.")
  contact?: ApiContactInformation;

  @doc("License information for the API.")
  license?: ApiLicenseInformation;
}

@doc("API Authentication Settings.")
model AuthenticationSettingsContract {
  @doc("OAuth2 Authentication settings")
  oAuth2?: OAuth2AuthenticationSettingsContract;

  @doc("OpenID Connect Authentication Settings")
  openid?: OpenIdAuthenticationSettingsContract;
}

@doc("API OAuth2 Authentication settings details.")
model OAuth2AuthenticationSettingsContract {
  @doc("OAuth authorization server identifier.")
  authorizationServerId?: string;

  @doc("operations scope.")
  scope?: string;
}

@doc("API OAuth2 Authentication settings details.")
model OpenIdAuthenticationSettingsContract {
  @doc("OAuth authorization server identifier.")
  openidProviderId?: string;

  @doc("How to send token to the server.")
  bearerTokenSendingMethods?: BearerTokenSendingMethod[];
}

@doc("Subscription key parameter names details.")
model SubscriptionKeyParameterNamesContract {
  @doc("Subscription key header name.")
  header?: string;

  @doc("Subscription key query string parameter name.")
  query?: string;
}

@doc("API contact information")
model ApiContactInformation {
  @doc("The identifying name of the contact person/organization")
  name?: string;

  @doc("The URL pointing to the contact information. MUST be in the format of a URL")
  url?: string;

  @doc("The email address of the contact person/organization. MUST be in the format of an email address")
  email?: string;
}

@doc("API license information")
model ApiLicenseInformation {
  @doc("The license name used for the API")
  name?: string;

  @doc("A URL to the license used for the API. MUST be in the format of a URL")
  url?: string;
}

@doc("Common fields that are returned in the response for all Azure Resource Manager resources")
model Resource {
  @doc("Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}")
  @visibility("read")
  id?: string;

  @doc("The name of the resource")
  @visibility("read")
  name?: string;

  @doc("The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\"")
  @visibility("read")
  type?: string;
}

@doc("Error Body contract.")
model ErrorResponseBody {
  @doc("Service-defined error code. This code serves as a sub-status for the HTTP error code specified in the response.")
  code?: string;

  @doc("Human-readable representation of the error.")
  message?: string;

  @doc("The list of invalid fields send in request, in case of validation error.")
  details?: ErrorFieldContract[];
}

@doc("Error Field contract.")
model ErrorFieldContract {
  @doc("Property level error code.")
  code?: string;

  @doc("Human-readable representation of property-level error.")
  message?: string;

  @doc("Property name.")
  target?: string;
}

@doc("API Create or Update Parameters.")
model ApiCreateOrUpdateParameter {
  @doc("API entity create of update properties.")
  properties?: ApiCreateOrUpdateProperties;
}

@doc("API Create or Update Properties.")
model ApiCreateOrUpdateProperties extends ApiContractProperties {
  @doc("Content value when Importing an API.")
  value?: string;

  @doc("Format of the Content in which the API is getting imported.")
  format?: ContentFormat;

  @doc("Criteria to limit import of WSDL to a subset of the document.")
  wsdlSelector?: ApiCreateOrUpdatePropertiesWsdlSelector;

  @doc("""
Type of API to create. 
 * `http` creates a REST API 
 * `soap` creates a SOAP pass-through API  
 * `websocket` creates websocket API 
 * `graphql` creates GraphQL API.
""")
  @projectedName("json", "apiType")
  soapApiType?: SoapApiType;
}

@doc("Criteria to limit import of WSDL to a subset of the document.")
model ApiCreateOrUpdatePropertiesWsdlSelector {
  @doc("Name of service to import from WSDL")
  wsdlServiceName?: string;

  @doc("Name of endpoint(port) to import from WSDL")
  wsdlEndpointName?: string;
}

@doc("API update contract details.")
model ApiUpdateContract {
  @doc("Properties of the API entity that can be updated.")
  properties?: ApiContractUpdateProperties;
}

@doc("API update contract properties.")
model ApiContractUpdateProperties extends ApiEntityBaseContract {
  @doc("API name.")
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  @doc("Absolute URL of the backend service implementing this API.")
  @maxLength(2000)
  @minLength(1)
  serviceUrl?: string;

  @doc("Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.")
  @maxLength(400)
  path?: string;

  @doc("Describes on which protocols the operations in this API can be invoked.")
  protocols?: Protocol[];
}

@doc("Paged API Revision list representation.")
model ApiRevisionListResult is Azure.Core.Page<ApiRevisionContract> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

@doc("Summary of revision metadata.")
model ApiRevisionContract {
  @doc("Identifier of the API Revision.")
  @visibility("read")
  apiId?: string;

  @doc("Revision number of API.")
  @visibility("read")
  @maxLength(100)
  @minLength(1)
  apiRevision?: string;

  @doc("The time the API Revision was created. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The time the API Revision were updated. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedDateTime?: utcDateTime;

  @doc("Description of the API Revision.")
  @visibility("read")
  @maxLength(256)
  description?: string;

  @doc("Gateway URL for accessing the non-current API Revision.")
  @visibility("read")
  privateUrl?: string;

  @doc("Indicates if API revision is the current api revision.")
  @visibility("read")
  isOnline?: boolean;

  @doc("Indicates if API revision is accessible via the gateway.")
  @visibility("read")
  isCurrent?: boolean;
}

@doc("API Release details")
model ApiReleaseContractProperties {
  @doc("Identifier of the API the release belongs to.")
  apiId?: string;

  @doc("The time the API was released. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The time the API release was updated.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedDateTime?: utcDateTime;

  @doc("Release Notes")
  notes?: string;
}

@doc("Operation Contract Properties")
model OperationContractProperties extends OperationEntityBaseContract {
  @doc("Operation Name.")
  @maxLength(300)
  @minLength(1)
  displayName: string;

  @doc("A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.")
  method: string;

  @doc("Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}")
  @maxLength(1000)
  @minLength(1)
  urlTemplate: string;
}

@doc("API Operation Entity Base Contract details.")
model OperationEntityBaseContract {
  @doc("Collection of URL template parameters.")
  templateParameters?: ParameterContract[];

  @doc("Description of the operation. May include HTML formatting tags.")
  @maxLength(1000)
  description?: string;

  @doc("An entity containing request details.")
  request?: RequestContract;

  @doc("Array of Operation responses.")
  responses?: ResponseContract[];

  @doc("Operation Policies")
  policies?: string;
}

@doc("Operation parameters details.")
model ParameterContract {
  @doc("Parameter name.")
  name: string;

  @doc("Parameter description.")
  description?: string;

  @doc("Parameter type.")
  type: string;

  @doc("Default parameter value.")
  defaultValue?: string;

  @doc("Specifies whether parameter is required or not.")
  required?: boolean;

  @doc("Parameter values.")
  values?: string[];

  @doc("Schema identifier.")
  schemaId?: string;

  @doc("Type name defined by the schema.")
  typeName?: string;

  @doc("Exampled defined for the parameter.")
  examples?: Record<ParameterExampleContract>;
}

@doc("Parameter example.")
model ParameterExampleContract {
  @doc("Short description for the example")
  summary?: string;

  @doc("Long description for the example")
  description?: string;

  @doc("Example value. May be a primitive value, or an object.")
  value?: unknown;

  @doc("A URL that points to the literal example")
  externalValue?: string;
}

@doc("Operation request details.")
model RequestContract {
  @doc("Operation request description.")
  description?: string;

  @doc("Collection of operation request query parameters.")
  queryParameters?: ParameterContract[];

  @doc("Collection of operation request headers.")
  headers?: ParameterContract[];

  @doc("Collection of operation request representations.")
  representations?: RepresentationContract[];
}

@doc("Operation request/response representation details.")
model RepresentationContract {
  @doc("Specifies a registered or custom content type for this representation, e.g. application/xml.")
  contentType: string;

  @doc("Schema identifier. Applicable only if 'contentType' value is neither 'application/x-www-form-urlencoded' nor 'multipart/form-data'.")
  schemaId?: string;

  @doc("Type name defined by the schema. Applicable only if 'contentType' value is neither 'application/x-www-form-urlencoded' nor 'multipart/form-data'.")
  typeName?: string;

  @doc("Collection of form parameters. Required if 'contentType' value is either 'application/x-www-form-urlencoded' or 'multipart/form-data'..")
  formParameters?: ParameterContract[];

  @doc("Exampled defined for the representation.")
  examples?: Record<ParameterExampleContract>;
}

@doc("Operation response details.")
model ResponseContract {
  @doc("Operation response HTTP status code.")
  statusCode: int32;

  @doc("Operation response description.")
  description?: string;

  @doc("Collection of operation response representations.")
  representations?: RepresentationContract[];

  @doc("Collection of operation response headers.")
  headers?: ParameterContract[];
}

@doc("API Operation Update Contract details.")
model OperationUpdateContract {
  @doc("Properties of the API Operation entity that can be updated.")
  properties?: OperationUpdateContractProperties;
}

@doc("Operation Update Contract Properties.")
model OperationUpdateContractProperties extends OperationEntityBaseContract {
  @doc("Operation Name.")
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  @doc("A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.")
  method?: string;

  @doc("Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}")
  @maxLength(1000)
  @minLength(1)
  urlTemplate?: string;
}

@doc("Policy contract Properties.")
model PolicyContractProperties {
  @doc("Contents of the Policy as defined by the format.")
  value: string;

  @doc("Format of the policyContent.")
  format?: PolicyContentFormat;
}

@doc("Tag contract Properties.")
model TagContractProperties {
  @doc("Tag name.")
  @maxLength(160)
  @minLength(1)
  displayName: string;
}

@doc("Product profile.")
model ProductContractProperties extends ProductEntityBaseParameters {
  @doc("Product name.")
  @maxLength(300)
  @minLength(1)
  displayName: string;
}

@doc("Product Entity Base Parameters")
model ProductEntityBaseParameters {
  @doc("Product description. May include HTML formatting tags.")
  @maxLength(1000)
  description?: string;

  @doc("Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.")
  terms?: string;

  @doc("Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as \"protected\" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as \"open\" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true.")
  @projectedName("json", "subscriptionRequired")
  IsSubscriptionRequired?: boolean;

  @doc("whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false.")
  @projectedName("json", "approvalRequired")
  IsApprovalRequired?: boolean;

  @doc("Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.")
  subscriptionsLimit?: int32;

  @doc("whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished.")
  state?: ProductState;
}

@doc("API Schema create or update contract Properties.")
model SchemaContractProperties {
  @doc("Must be a valid a media type used in a Content-Type header as defined in the RFC 2616. Media type of the schema document (e.g. application/json, application/xml). </br> - `Swagger` Schema use `application/vnd.ms-azure-apim.swagger.definitions+json` </br> - `WSDL` Schema use `application/vnd.ms-azure-apim.xsd+xml` </br> - `OpenApi` Schema use `application/vnd.oai.openapi.components+json` </br> - `WADL Schema` use `application/vnd.ms-azure-apim.wadl.grammars+xml`.")
  contentType: string;

  @doc("Create or update Properties of the API Schema Document.")
  document?: SchemaDocumentProperties;
}

@doc("Api Schema Document Properties.")
model SchemaDocumentProperties {
  @doc("Json escaped string defining the document representing the Schema. Used for schemas other than Swagger/OpenAPI.")
  value?: string;

  @doc("Types definitions. Used for Swagger/OpenAPI v1 schemas only, null otherwise.")
  definitions?: Record<unknown>;

  @doc("Types definitions. Used for Swagger/OpenAPI v2/v3 schemas only, null otherwise.")
  components?: Record<unknown>;
}

@doc("Diagnostic Entity Properties")
model DiagnosticContractProperties {
  @doc("Specifies for what type of messages sampling settings should not apply.")
  alwaysLog?: AlwaysLog;

  @doc("Resource Id of a target logger.")
  loggerId: string;

  @doc("Sampling settings for Diagnostic.")
  sampling?: SamplingSettings;

  @doc("Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.")
  frontend?: PipelineDiagnosticSettings;

  @doc("Diagnostic settings for incoming/outgoing HTTP messages to the Backend")
  backend?: PipelineDiagnosticSettings;

  @doc("Log the ClientIP. Default is false.")
  logClientIp?: boolean;

  @doc("Sets correlation protocol to use for Application Insights diagnostics.")
  httpCorrelationProtocol?: HttpCorrelationProtocol;

  @doc("The verbosity level applied to traces emitted by trace policies.")
  verbosity?: Verbosity;

  @doc("The format of the Operation Name for Application Insights telemetries. Default is Name.")
  operationNameFormat?: OperationNameFormat;

  @doc("Emit custom metrics via emit-metric policy. Applicable only to Application Insights diagnostic settings.")
  metrics?: boolean;
}

@doc("Sampling settings for Diagnostic.")
model SamplingSettings {
  @doc("Sampling type.")
  samplingType?: SamplingType;

  @doc("Rate of sampling for fixed-rate sampling.")
  @maxValue(100)
  percentage?: float64;
}

@doc("Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.")
model PipelineDiagnosticSettings {
  @doc("Diagnostic settings for request.")
  request?: HttpMessageDiagnostic;

  @doc("Diagnostic settings for response.")
  response?: HttpMessageDiagnostic;
}

@doc("Http message diagnostic settings.")
model HttpMessageDiagnostic {
  @doc("Array of HTTP Headers to log.")
  headers?: string[];

  @doc("Body logging settings.")
  body?: BodyDiagnosticSettings;

  @doc("Data masking settings.")
  dataMasking?: DataMasking;
}

@doc("Body logging settings.")
model BodyDiagnosticSettings {
  @doc("Number of request body bytes to log.")
  @maxValue(8192)
  bytes?: int32;
}

model DataMasking {
  @doc("Masking settings for Url query parameters")
  queryParams?: DataMaskingEntity[];

  @doc("Masking settings for headers")
  headers?: DataMaskingEntity[];
}

model DataMaskingEntity {
  @doc("The name of an entity to mask (e.g. a name of a header or a query parameter).")
  value?: string;

  @doc("Data masking mode.")
  mode?: DataMaskingMode;
}

@doc("Issue contract Properties.")
model IssueContractProperties extends IssueContractBaseProperties {
  @doc("The issue title.")
  title: string;

  @doc("Text describing the issue.")
  description: string;

  @doc("A resource identifier for the user created the issue.")
  userId: string;
}

@doc("Issue contract Base Properties.")
model IssueContractBaseProperties {
  @doc("Date and time when the issue was created.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  @doc("Status of the issue.")
  state?: State;

  @doc("A resource identifier for the API the issue was created for.")
  apiId?: string;
}

@doc("Issue update Parameters.")
model IssueUpdateContract {
  @doc("Issue entity Update contract properties.")
  properties?: IssueUpdateContractProperties;
}

@doc("Issue contract Update Properties.")
model IssueUpdateContractProperties extends IssueContractBaseProperties {
  @doc("The issue title.")
  title?: string;

  @doc("Text describing the issue.")
  description?: string;

  @doc("A resource identifier for the user created the issue.")
  userId?: string;
}

@doc("Issue Comment contract Properties.")
model IssueCommentContractProperties {
  @doc("Comment text.")
  text: string;

  @doc("Date and time when the comment was created.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  @doc("A resource identifier for the user who left the comment.")
  userId: string;
}

@doc("Issue Attachment contract Properties.")
model IssueAttachmentContractProperties {
  @doc("Filename by which the binary data will be saved.")
  title: string;

  @doc("Either 'link' if content is provided via an HTTP link or the MIME type of the Base64-encoded binary data provided in the 'content' property.")
  contentFormat: string;

  @doc("An HTTP link or Base64-encoded binary data.")
  content: string;
}

@doc("TagDescription contract Properties.")
model TagDescriptionContractProperties extends TagDescriptionBaseProperties {
  @doc("Identifier of the tag in the form of /tags/{tagId}")
  tagId?: string;

  @doc("Tag name.")
  @maxLength(160)
  @minLength(1)
  displayName?: string;
}

@doc("Parameters supplied to the Create TagDescription operation.")
model TagDescriptionBaseProperties {
  @doc("Description of the Tag.")
  description?: string;

  @doc("Absolute URL of external resources describing the tag.")
  @maxLength(2000)
  externalDocsUrl?: string;

  @doc("Description of the external resources describing the tag.")
  externalDocsDescription?: string;
}

@doc("Parameters supplied to the Create TagDescription operation.")
model TagDescriptionCreateParameters {
  @doc("Properties supplied to Create TagDescription operation.")
  properties?: TagDescriptionBaseProperties;
}

@doc("Paged Tag list representation.")
model TagResourceListResult is Azure.Core.Page<TagResourceContract> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

@doc("TagResource contract properties.")
model TagResourceContract {
  @doc("Tag associated with the resource.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  tag: TagTagResourceContractProperties;

  @doc("API associated with the tag.")
  api?: ApiTagResourceContractProperties;

  @doc("Operation associated with the tag.")
  operation?: OperationTagResourceContractProperties;

  @doc("Product associated with the tag.")
  product?: ProductTagResourceContractProperties;
}

@doc("Contract defining the Tag property in the Tag Resource Contract")
model TagTagResourceContractProperties {
  @doc("Tag identifier")
  id?: string;

  @doc("Tag Name")
  @maxLength(160)
  @minLength(1)
  name?: string;
}

@doc("API contract properties for the Tag Resources.")
model ApiTagResourceContractProperties extends ApiEntityBaseContract {
  @doc("API identifier in the form /apis/{apiId}.")
  id?: string;

  @doc("API name.")
  @maxLength(300)
  @minLength(1)
  name?: string;

  @doc("Absolute URL of the backend service implementing this API.")
  @maxLength(2000)
  @minLength(1)
  serviceUrl?: string;

  @doc("Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.")
  @maxLength(400)
  path?: string;

  @doc("Describes on which protocols the operations in this API can be invoked.")
  protocols?: Protocol[];
}

@doc("Operation Entity contract Properties.")
model OperationTagResourceContractProperties {
  @doc("Identifier of the operation in form /operations/{operationId}.")
  id?: string;

  @doc("Operation name.")
  @visibility("read")
  name?: string;

  @doc("API Name.")
  @visibility("read")
  apiName?: string;

  @doc("API Revision.")
  @visibility("read")
  apiRevision?: string;

  @doc("API Version.")
  @visibility("read")
  apiVersion?: string;

  @doc("Operation Description.")
  @visibility("read")
  description?: string;

  @doc("A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.")
  @visibility("read")
  method?: string;

  @doc("Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}")
  @visibility("read")
  urlTemplate?: string;
}

@doc("Product profile.")
model ProductTagResourceContractProperties extends ProductEntityBaseParameters {
  @doc("Identifier of the product in the form of /products/{productId}")
  id?: string;

  @doc("Product name.")
  @maxLength(300)
  @minLength(1)
  name: string;
}

@doc("API Export result.")
model ApiExportResult {
  @doc("ResourceId of the API which was exported.")
  id?: string;

  @doc("Format in which the API Details are exported to the Storage Blob with Sas Key valid for 5 minutes.")
  @projectedName("json", "format")
  exportResultFormat?: ExportResultFormat;

  @doc("The object defining the schema of the exported API Detail")
  value?: ApiExportResultValue;
}

@doc("The object defining the schema of the exported API Detail")
model ApiExportResultValue {
  @doc("Link to the Storage Blob containing the result of the export operation. The Blob Uri is only valid for 5 minutes.")
  link?: string;
}

@doc("Properties of an API Version Set.")
model ApiVersionSetContractProperties extends ApiVersionSetEntityBase {
  @doc("Name of API Version Set")
  @maxLength(100)
  @minLength(1)
  displayName: string;

  @doc("An value that determines where the API Version identifier will be located in a HTTP request.")
  versioningScheme: VersioningScheme;
}

@doc("API Version set base parameters")
model ApiVersionSetEntityBase {
  @doc("Description of API Version Set.")
  description?: string;

  @doc("Name of query parameter that indicates the API Version if versioningScheme is set to `query`.")
  @maxLength(100)
  @minLength(1)
  versionQueryName?: string;

  @doc("Name of HTTP header parameter that indicates the API Version if versioningScheme is set to `header`.")
  @maxLength(100)
  @minLength(1)
  versionHeaderName?: string;
}

@doc("Parameters to update or create an API Version Set Contract.")
model ApiVersionSetUpdateParameters {
  @doc("Parameters to update or create an API Version Set Contract.")
  properties?: ApiVersionSetUpdateParametersProperties;
}

@doc("Properties used to create or update an API Version Set.")
model ApiVersionSetUpdateParametersProperties extends ApiVersionSetEntityBase {
  @doc("Name of API Version Set")
  @maxLength(100)
  @minLength(1)
  displayName?: string;

  @doc("An value that determines where the API Version identifier will be located in a HTTP request.")
  versioningScheme?: VersioningScheme;
}

@doc("External OAuth authorization server settings Properties.")
model AuthorizationServerContractProperties
  extends AuthorizationServerContractBaseProperties {
  @doc("User-friendly authorization server name.")
  @maxLength(50)
  @minLength(1)
  displayName: string;

  @doc("Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.")
  clientRegistrationEndpoint: string;

  @doc("OAuth authorization endpoint. See http://tools.ietf.org/html/rfc6749#section-3.2.")
  authorizationEndpoint: string;

  @doc("Form of an authorization grant, which the client uses to request the access token.")
  grantTypes: GrantType[];

  @doc("Client or app id registered with this authorization server.")
  clientId: string;

  @doc("Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  clientSecret?: string;
}

@doc("External OAuth authorization server Update settings contract.")
model AuthorizationServerContractBaseProperties {
  @doc("Description of the authorization server. Can contain HTML formatting tags.")
  description?: string;

  @doc("HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional.")
  authorizationMethods?: AuthorizationMethod[];

  @doc("Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format.")
  @projectedName("json", "clientAuthenticationMethod")
  clientAuthenticationMethods?: ClientAuthenticationMethod[];

  @doc("Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {\"name\" : \"name value\", \"value\": \"a value\"}.")
  tokenBodyParameters?: TokenBodyParameterContract[];

  @doc("OAuth token endpoint. Contains absolute URI to entity being referenced.")
  tokenEndpoint?: string;

  @doc("If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.")
  @projectedName("json", "supportState")
  doesSupportState?: boolean;

  @doc("Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values.")
  defaultScope?: string;

  @doc("Specifies the mechanism by which access token is passed to the API. ")
  bearerTokenSendingMethods?: BearerTokenSendingMethod[];

  @doc("Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.")
  resourceOwnerUsername?: string;

  @doc("Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.")
  resourceOwnerPassword?: string;
}

@doc("OAuth acquire token request body parameter (www-url-form-encoded).")
model TokenBodyParameterContract {
  @doc("body parameter name.")
  name: string;

  @doc("body parameter value.")
  value: string;
}

@doc("External OAuth authorization server settings.")
model AuthorizationServerUpdateContract extends Resource {
  @doc("Properties of the External OAuth authorization server update Contract.")
  properties?: AuthorizationServerUpdateContractProperties;
}

@doc("External OAuth authorization server Update settings contract.")
model AuthorizationServerUpdateContractProperties
  extends AuthorizationServerContractBaseProperties {
  @doc("User-friendly authorization server name.")
  @maxLength(50)
  @minLength(1)
  displayName?: string;

  @doc("Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.")
  clientRegistrationEndpoint?: string;

  @doc("OAuth authorization endpoint. See http://tools.ietf.org/html/rfc6749#section-3.2.")
  authorizationEndpoint?: string;

  @doc("Form of an authorization grant, which the client uses to request the access token.")
  grantTypes?: GrantType[];

  @doc("Client or app id registered with this authorization server.")
  clientId?: string;

  @doc("Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  clientSecret?: string;
}

@doc("OAuth Server Secrets Contract.")
model AuthorizationServerSecretsContract {
  @doc("oAuth Authorization Server Secrets.")
  clientSecret?: string;

  @doc("Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.")
  resourceOwnerUsername?: string;

  @doc("Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.")
  resourceOwnerPassword?: string;
}

@doc("Parameters supplied to the Create Backend operation.")
model BackendContractProperties extends BackendBaseParameters {
  @doc("Runtime Url of the Backend.")
  @maxLength(2000)
  @minLength(1)
  url: string;

  @doc("Backend communication protocol.")
  protocol: BackendProtocol;
}

@doc("Backend entity base Parameter set.")
model BackendBaseParameters {
  @doc("Backend Title.")
  @maxLength(300)
  @minLength(1)
  title?: string;

  @doc("Backend Description.")
  @maxLength(2000)
  @minLength(1)
  description?: string;

  @doc("Management Uri of the Resource in External System. This url can be the Arm Resource Id of Logic Apps, Function Apps or API Apps.")
  @maxLength(2000)
  @minLength(1)
  resourceId?: string;

  @doc("Backend Properties contract")
  properties?: BackendProperties;

  @doc("Backend Credentials Contract Properties")
  credentials?: BackendCredentialsContract;

  @doc("Backend Proxy Contract Properties")
  proxy?: BackendProxyContract;

  @doc("Backend TLS Properties")
  tls?: BackendTlsProperties;
}

@doc("Properties specific to the Backend Type.")
model BackendProperties {
  @doc("Backend Service Fabric Cluster Properties")
  serviceFabricCluster?: BackendServiceFabricClusterProperties;
}

@doc("Properties of the Service Fabric Type Backend.")
model BackendServiceFabricClusterProperties {
  @doc("The client certificate id for the management endpoint.")
  clientCertificateId?: string;

  @doc("The client certificate thumbprint for the management endpoint. Will be ignored if certificatesIds are provided")
  clientCertificatethumbprint?: string;

  @doc("Maximum number of retries while attempting resolve the partition.")
  maxPartitionResolutionRetries?: int32;

  @doc("The cluster management endpoint.")
  managementEndpoints: string[];

  @doc("Thumbprints of certificates cluster management service uses for tls communication")
  serverCertificateThumbprints?: string[];

  @doc("Server X509 Certificate Names Collection")
  serverX509Names?: X509CertificateName[];
}

@doc("Properties of server X509Names.")
model X509CertificateName {
  @doc("Common Name of the Certificate.")
  name?: string;

  @doc("Thumbprint for the Issuer of the Certificate.")
  issuerCertificateThumbprint?: string;
}

@doc("Details of the Credentials used to connect to Backend.")
model BackendCredentialsContract {
  @doc("List of Client Certificate Ids.")
  certificateIds?: string[];

  @doc("List of Client Certificate Thumbprints. Will be ignored if certificatesIds are provided.")
  certificate?: string[];

  @doc("Query Parameter description.")
  query?: Record<string[]>;

  @doc("Header Parameter description.")
  header?: Record<string[]>;

  @doc("Authorization header authentication")
  authorization?: BackendAuthorizationHeaderCredentials;
}

@doc("Authorization header information.")
model BackendAuthorizationHeaderCredentials {
  @doc("Authentication Scheme name.")
  @maxLength(100)
  @minLength(1)
  scheme: string;

  @doc("Authentication Parameter value.")
  @maxLength(300)
  @minLength(1)
  parameter: string;
}

@doc("Details of the Backend WebProxy Server to use in the Request to Backend.")
model BackendProxyContract {
  @doc("WebProxy Server AbsoluteUri property which includes the entire URI stored in the Uri instance, including all fragments and query strings.")
  @maxLength(2000)
  @minLength(1)
  url: string;

  @doc("Username to connect to the WebProxy server")
  username?: string;

  @doc("Password to connect to the WebProxy Server")
  password?: string;
}

@doc("Properties controlling TLS Certificate Validation.")
model BackendTlsProperties {
  @doc("Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host.")
  validateCertificateChain?: boolean;

  @doc("Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host.")
  validateCertificateName?: boolean;
}

@doc("Backend update parameters.")
model BackendUpdateParameters {
  @doc("Backend entity update contract properties.")
  properties?: BackendUpdateParameterProperties;
}

@doc("Parameters supplied to the Update Backend operation.")
model BackendUpdateParameterProperties extends BackendBaseParameters {
  @doc("Runtime Url of the Backend.")
  @maxLength(2000)
  @minLength(1)
  url?: string;

  @doc("Backend communication protocol.")
  protocol?: BackendProtocol;
}

@doc("Reconnect request parameters.")
model BackendReconnectContract extends Resource {
  @doc("Reconnect request properties.")
  properties?: BackendReconnectProperties;
}

@doc("Properties to control reconnect requests.")
model BackendReconnectProperties {
  @doc("Duration in ISO8601 format after which reconnect will be initiated. Minimum duration of the Reconnect is PT2M.")
  after?: duration;
}

@doc("Properties of the Cache contract.")
model CacheContractProperties {
  @doc("Cache description")
  @maxLength(2000)
  description?: string;

  @doc("Runtime connection string to cache")
  @maxLength(300)
  connectionString: string;

  @doc("Location identifier to use cache from (should be either 'default' or valid Azure region identifier)")
  @maxLength(256)
  useFromLocation: string;

  @doc("Original uri of entity in external system cache points to")
  @maxLength(2000)
  @projectedName("json", "resourceId")
  resourceUri?: string;
}

@doc("Cache update details.")
model CacheUpdateParameters {
  @doc("Cache update properties details.")
  properties?: CacheUpdateProperties;
}

@doc("Parameters supplied to the Update Cache operation.")
model CacheUpdateProperties {
  @doc("Cache description")
  @maxLength(2000)
  description?: string;

  @doc("Runtime connection string to cache")
  @maxLength(300)
  connectionString?: string;

  @doc("Location identifier to use cache from (should be either 'default' or valid Azure region identifier)")
  @maxLength(256)
  useFromLocation?: string;

  @doc("Original uri of entity in external system cache points to")
  @maxLength(2000)
  @projectedName("json", "resourceId")
  resourceUri?: string;
}

@doc("Properties of the Certificate contract.")
model CertificateContractProperties {
  @doc("Subject attribute of the certificate.")
  subject: string;

  @doc("Thumbprint of the certificate.")
  thumbprint: string;

  @doc("""
Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDate: utcDateTime;

  @doc("KeyVault location details of the certificate.")
  keyVault?: KeyVaultContractProperties;
}

@doc("KeyVault contract details.")
model KeyVaultContractProperties extends KeyVaultContractCreateProperties {
  @doc("Last time sync and refresh status of secret from key vault.")
  lastStatus?: KeyVaultLastAccessStatusContractProperties;
}

@doc("Issue contract Update Properties.")
model KeyVaultLastAccessStatusContractProperties {
  @doc("Last status code for sync and refresh of secret from key vault.")
  code?: string;

  @doc("Details of the error else empty.")
  message?: string;

  @doc("""
Last time secret was accessed. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeStampUtc?: utcDateTime;
}

@doc("Create keyVault contract details.")
model KeyVaultContractCreateProperties {
  @doc("Key vault secret identifier for fetching secret. Providing a versioned secret will prevent auto-refresh. This requires API Management service to be configured with aka.ms/apimmsi")
  secretIdentifier?: string;

  @doc("Null for SystemAssignedIdentity or Client Id for UserAssignedIdentity , which will be used to access key vault secret.")
  identityClientId?: string;
}

@doc("Certificate create or update details.")
model CertificateCreateOrUpdateParameters {
  @doc("Certificate create or update properties details.")
  properties?: CertificateCreateOrUpdateProperties;
}

@doc("Parameters supplied to the CreateOrUpdate certificate operation.")
model CertificateCreateOrUpdateProperties {
  @doc("Base 64 encoded certificate using the application/x-pkcs12 representation.")
  data?: string;

  @doc("Password for the Certificate")
  password?: string;

  @doc("KeyVault location details of the certificate.")
  keyVault?: KeyVaultContractCreateProperties;
}

@doc("A request to perform the connectivity check operation on a API Management service.")
model ConnectivityCheckRequest {
  @doc("Definitions about the connectivity check origin.")
  source: ConnectivityCheckRequestSource;

  @doc("The connectivity check operation destination.")
  destination: ConnectivityCheckRequestDestination;

  @doc("The IP version to be used. Only IPv4 is supported for now.")
  preferredIPVersion?: PreferredIPVersion;

  @doc("The request's protocol. Specific protocol configuration can be available based on this selection. The specified destination address must be coherent with this value.")
  protocol?: ConnectivityCheckProtocol;

  @doc("Protocol-specific configuration.")
  protocolConfiguration?: ConnectivityCheckRequestProtocolConfiguration;
}

@doc("Definitions about the connectivity check origin.")
model ConnectivityCheckRequestSource {
  @doc("The API Management service region from where to start the connectivity check operation.")
  region: string;

  @doc("The particular VMSS instance from which to fire the request.")
  instance?: int64;
}

@doc("The connectivity check operation destination.")
model ConnectivityCheckRequestDestination {
  @doc("Destination address. Can either be an IP address or a FQDN.")
  address: string;

  @doc("Destination port.")
  port: int64;
}

@doc("Protocol-specific configuration.")
model ConnectivityCheckRequestProtocolConfiguration {
  @doc("Configuration for HTTP or HTTPS requests.")
  @projectedName("json", "HTTPConfiguration")
  httpConfiguration?: ConnectivityCheckRequestProtocolConfigurationHttpConfiguration;
}

@doc("Configuration for HTTP or HTTPS requests.")
model ConnectivityCheckRequestProtocolConfigurationHttpConfiguration {
  @doc("The HTTP method to be used.")
  method?: Method;

  @doc("List of HTTP status codes considered valid for the request response.")
  validStatusCodes?: int64[];

  @doc("List of headers to be included in the request.")
  headers?: HttpHeader[];
}

@doc("HTTP header and it's value.")
model HttpHeader {
  @doc("Header name.")
  name: string;

  @doc("Header value.")
  value: string;
}

@doc("Information on the connectivity status.")
model ConnectivityCheckResponse {
  @doc("List of hops between the source and the destination.")
  @visibility("read")
  hops?: ConnectivityHop[];

  @doc("The connection status.")
  @visibility("read")
  connectionStatus?: ConnectionStatus;

  @doc("Average latency in milliseconds.")
  @visibility("read")
  avgLatencyInMs?: int64;

  @doc("Minimum latency in milliseconds.")
  @visibility("read")
  minLatencyInMs?: int64;

  @doc("Maximum latency in milliseconds.")
  @visibility("read")
  maxLatencyInMs?: int64;

  @doc("Total number of probes sent.")
  @visibility("read")
  probesSent?: int64;

  @doc("Number of failed probes.")
  @visibility("read")
  probesFailed?: int64;
}

@doc("Information about a hop between the source and the destination.")
model ConnectivityHop {
  @doc("The type of the hop.")
  @visibility("read")
  type?: string;

  @doc("The ID of the hop.")
  @visibility("read")
  id?: string;

  @doc("The IP address of the hop.")
  @visibility("read")
  address?: string;

  @doc("The ID of the resource corresponding to this hop.")
  @visibility("read")
  resourceId?: string;

  @doc("List of next hop identifiers.")
  @visibility("read")
  nextHopIds?: string[];

  @doc("List of issues.")
  @visibility("read")
  issues?: ConnectivityIssue[];
}

@doc("Information about an issue encountered in the process of checking for connectivity.")
model ConnectivityIssue {
  @doc("The origin of the issue.")
  @visibility("read")
  origin?: Origin;

  @doc("The severity of the issue.")
  @visibility("read")
  severity?: Severity;

  @doc("The type of issue.")
  @visibility("read")
  type?: IssueType;

  @doc("Provides additional context on the issue.")
  @visibility("read")
  context?: Record<string>[];
}

@doc("Paged list of content types.")
model ContentTypeListResult is Azure.Core.Page<ContentTypeContract>;

@doc("Content type contract details.")
model ContentTypeContract extends Resource {
  @doc("Properties of the content type.")
  properties?: ContentTypeContractProperties;
}

model ContentTypeContractProperties {
  @doc("Content type identifier")
  id?: string;

  @doc("Content type name. Must be 1 to 250 characters long.")
  name?: string;

  @doc("Content type description.")
  description?: string;

  @doc("Content type schema.")
  schema?: Record<unknown>;

  @doc("Content type version.")
  version?: string;
}

@doc("Paged list of content items.")
model ContentItemListResult is Azure.Core.Page<ContentItemContract>;

@doc("Content type contract details.")
model ContentItemContract extends Resource {
  @doc("Properties of the content item.")
  properties?: Record<unknown>;
}

model DeletedServiceContractProperties {
  @doc("Fully-qualified API Management Service Resource ID")
  serviceId?: string;

  @doc("UTC Date and Time when the service will be automatically purged. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  scheduledPurgeDate?: utcDateTime;

  @doc("UTC Timestamp when the service was soft-deleted. The date conforms to the following format: yyyy-MM-ddTHH:mm:ssZ as specified by the ISO 8601 standard.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deletionDate?: utcDateTime;
}

@doc("The API Management service SKUs operation response.")
model ResourceSkuResults is Azure.Core.Page<ResourceSkuResult>;

@doc("Describes an available API Management service SKU.")
model ResourceSkuResult {
  @doc("The type of resource the SKU applies to.")
  @visibility("read")
  resourceType?: string;

  @doc("Specifies API Management SKU.")
  @visibility("read")
  sku?: ResourceSku;

  @doc("Specifies the number of API Management units.")
  @visibility("read")
  capacity?: ResourceSkuCapacity;
}

@doc("Describes scaling information of a SKU.")
model ResourceSkuCapacity {
  @doc("The minimum capacity.")
  @visibility("read")
  minimum?: int32;

  @doc("The maximum capacity that can be set.")
  @visibility("read")
  maximum?: int32;

  @doc("The default capacity.")
  @visibility("read")
  default?: int32;

  @doc("The scale type applicable to the sku.")
  @visibility("read")
  scaleType?: ResourceSkuCapacityScaleType;
}

@doc("Parameters supplied to the Backup/Restore of an API Management service operation.")
model ApiManagementServiceBackupRestoreParameters {
  @doc("The name of the Azure storage account (used to place/retrieve the backup).")
  storageAccount: string;

  @doc("The name of the blob container (used to place/retrieve the backup).")
  containerName: string;

  @doc("The name of the backup file to create/retrieve.")
  backupName: string;

  @doc("The type of access to be used for the storage account.")
  accessType?: AccessType;

  @doc("Storage account access key. Required only if `accessType` is set to `AccessKey`.")
  accessKey?: string;

  @doc("The Client ID of user assigned managed identity. Required only if `accessType` is set to `UserAssignedManagedIdentity`.")
  clientId?: string;
}

@doc("Properties of an API Management service resource description.")
model ApiManagementServiceProperties
  extends ApiManagementServiceBaseProperties {
  @doc("Publisher email.")
  @maxLength(100)
  publisherEmail: string;

  @doc("Publisher name.")
  @maxLength(100)
  publisherName: string;
}

@doc("Base Properties of an API Management service resource description.")
model ApiManagementServiceBaseProperties {
  @doc("Email address from which the notification will be sent.")
  @maxLength(100)
  notificationSenderEmail?: string;

  @doc("The current provisioning state of the API Management service which can be one of the following: Created/Activating/Succeeded/Updating/Failed/Stopped/Terminating/TerminationFailed/Deleted.")
  @visibility("read")
  provisioningState?: string;

  @doc("The provisioning state of the API Management service, which is targeted by the long running operation started on the service.")
  @visibility("read")
  targetProvisioningState?: string;

  @doc("Creation UTC date of the API Management service.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdAtUtc?: utcDateTime;

  @doc("Gateway URL of the API Management service.")
  @visibility("read")
  gatewayUrl?: string;

  @doc("Gateway URL of the API Management service in the Default Region.")
  @visibility("read")
  gatewayRegionalUrl?: string;

  @doc("Publisher portal endpoint Url of the API Management service.")
  @visibility("read")
  portalUrl?: string;

  @doc("Management API endpoint URL of the API Management service.")
  @visibility("read")
  managementApiUrl?: string;

  @doc("SCM endpoint URL of the API Management service.")
  @visibility("read")
  scmUrl?: string;

  @doc("DEveloper Portal endpoint URL of the API Management service.")
  @visibility("read")
  developerPortalUrl?: string;

  @doc("Custom hostname configuration of the API Management service.")
  hostnameConfigurations?: HostnameConfiguration[];

  @doc("Public Static Load Balanced IP addresses of the API Management service in Primary region. Available only for Basic, Standard, Premium and Isolated SKU.")
  @visibility("read")
  publicIPAddresses?: string[];

  @doc("Private Static Load Balanced IP addresses of the API Management service in Primary region which is deployed in an Internal Virtual Network. Available only for Basic, Standard, Premium and Isolated SKU.")
  @visibility("read")
  privateIPAddresses?: string[];

  @doc("Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.")
  publicIpAddressId?: string;

  @doc("Whether or not public endpoint access is allowed for this API Management service.  Value is optional but if passed in, must be 'Enabled' or 'Disabled'. If 'Disabled', private endpoints are the exclusive access method. Default value is 'Enabled'")
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("Virtual network configuration of the API Management service.")
  virtualNetworkConfiguration?: VirtualNetworkConfiguration;

  @doc("Additional datacenter locations of the API Management service.")
  additionalLocations?: AdditionalLocation[];

  @doc("Custom properties of the API Management service.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168` will disable the cipher TLS_RSA_WITH_3DES_EDE_CBC_SHA for all TLS(1.0, 1.1 and 1.2).</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11` can be used to disable just TLS 1.1.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10` can be used to disable TLS 1.0 on an API Management service.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11` can be used to disable just TLS 1.1 for communications with backends.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10` can be used to disable TLS 1.0 for communications with backends.</br>Setting `Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2` can be used to enable HTTP2 protocol on an API Management service.</br>Not specifying any of these properties on PATCH operation will reset omitted properties' values to their defaults. For all the settings except Http2 the default value is `True` if the service was created on or before April 1st 2018 and `False` otherwise. Http2 setting's default value is `False`.</br></br>You can disable any of next ciphers by using settings `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.[cipher_name]`: TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA. For example, `Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256`:`false`. The default value is `true` for them.  Note: next ciphers can't be disabled since they are required by Azure CloudService internal components: TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384")
  customProperties?: Record<string>;

  @doc("List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.")
  certificates?: CertificateConfiguration[];

  @doc("Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.")
  enableClientCertificate?: boolean;

  @doc("Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in master region.")
  disableGateway?: boolean;

  @doc("The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an Internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.")
  virtualNetworkType?: VirtualNetworkType;

  @doc("Control Plane Apis version constraint for the API Management service.")
  apiVersionConstraint?: ApiVersionConstraint;

  @doc("Undelete Api Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.")
  restore?: boolean;

  @doc("List of Private Endpoint Connections of this service.")
  privateEndpointConnections?: RemotePrivateEndpointConnectionWrapper[];

  @doc("Compute Platform Version running the service in this location.")
  @visibility("read")
  platformVersion?: PlatformVersion;
}

@doc("Custom hostname configuration.")
model HostnameConfiguration {
  @doc("Hostname type.")
  type: HostnameType;

  @doc("Hostname to configure on the Api Management service.")
  hostName: string;

  @doc("Url to the KeyVault Secret containing the Ssl Certificate. If absolute Url containing version is provided, auto-update of ssl certificate will not work. This requires Api Management service to be configured with aka.ms/apimmsi. The secret should be of type *application/x-pkcs12*")
  keyVaultId?: string;

  @doc("System or User Assigned Managed identity clientId as generated by Azure AD, which has GET access to the keyVault containing the SSL certificate.")
  identityClientId?: string;

  @doc("Base64 Encoded certificate.")
  encodedCertificate?: string;

  @doc("Certificate Password.")
  certificatePassword?: string;

  @doc("Specify true to setup the certificate associated with this Hostname as the Default SSL Certificate. If a client does not send the SNI header, then this will be the certificate that will be challenged. The property is useful if a service has multiple custom hostname enabled and it needs to decide on the default ssl certificate. The setting only applied to Proxy Hostname Type.")
  defaultSslBinding?: boolean;

  @doc("Specify true to always negotiate client certificate on the hostname. Default Value is false.")
  negotiateClientCertificate?: boolean;

  @doc("Certificate information.")
  certificate?: CertificateInformation;

  @doc("Certificate Source.")
  certificateSource?: CertificateSource;

  @doc("Certificate Status.")
  certificateStatus?: CertificateStatus;
}

@doc("SSL certificate information.")
model CertificateInformation {
  @doc("Expiration date of the certificate. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiry: utcDateTime;

  @doc("Thumbprint of the certificate.")
  thumbprint: string;

  @doc("Subject of the certificate.")
  subject: string;
}

@doc("Configuration of a virtual network to which API Management service is deployed.")
model VirtualNetworkConfiguration {
  @doc("The virtual network ID. This is typically a GUID. Expect a null GUID by default.")
  @visibility("read")
  vnetid?: string;

  @doc("The name of the subnet.")
  @visibility("read")
  subnetname?: string;

  @doc("The full resource ID of a subnet in a virtual network to deploy the API Management service in.")
  @pattern("^/subscriptions/[^/]*/resourceGroups/[^/]*/providers/Microsoft.(ClassicNetwork|Network)/virtualNetworks/[^/]*/subnets/[^/]*$")
  subnetResourceId?: string;
}

@doc("Description of an additional API Management resource location.")
model AdditionalLocation {
  @doc("The location name of the additional region among Azure Data center regions.")
  location: string;

  @doc("SKU properties of the API Management service.")
  sku: ApiManagementServiceSkuProperties;

  @doc("A list of availability zones denoting where the resource needs to come from.")
  zones?: string[];

  @doc("Public Static Load Balanced IP addresses of the API Management service in the additional location. Available only for Basic, Standard, Premium and Isolated SKU.")
  @visibility("read")
  publicIPAddresses?: string[];

  @doc("Private Static Load Balanced IP addresses of the API Management service which is deployed in an Internal Virtual Network in a particular additional location. Available only for Basic, Standard, Premium and Isolated SKU.")
  @visibility("read")
  privateIPAddresses?: string[];

  @doc("Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the location. Supported only for Premium SKU being deployed in Virtual Network.")
  publicIpAddressId?: string;

  @doc("Virtual network configuration for the location.")
  virtualNetworkConfiguration?: VirtualNetworkConfiguration;

  @doc("Gateway URL of the API Management service in the Region.")
  @visibility("read")
  gatewayRegionalUrl?: string;

  @doc("Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in this additional location.")
  disableGateway?: boolean;

  @doc("Compute Platform Version running the service.")
  @visibility("read")
  platformVersion?: PlatformVersion;
}

@doc("API Management service resource SKU properties.")
model ApiManagementServiceSkuProperties {
  @doc("Name of the Sku.")
  name: SkuType;

  @doc("Capacity of the SKU (number of deployed units of the SKU). For Consumption SKU capacity must be specified as 0.")
  capacity: int32;
}

@doc("Certificate configuration which consist of non-trusted intermediates and root certificates.")
model CertificateConfiguration {
  @doc("Base64 Encoded certificate.")
  encodedCertificate?: string;

  @doc("Certificate Password.")
  certificatePassword?: string;

  @doc("The System.Security.Cryptography.x509certificates.StoreName certificate store location. Only Root and CertificateAuthority are valid locations.")
  storeName: CertificateConfigurationStoreName;

  @doc("Certificate information.")
  certificate?: CertificateInformation;
}

@doc("Control Plane Apis version constraint for the API Management service.")
model ApiVersionConstraint {
  @doc("Limit control plane API calls to API Management service with version equal to or newer than this value.")
  minApiVersion?: string;
}

@doc("Remote Private Endpoint Connection resource.")
model RemotePrivateEndpointConnectionWrapper {
  @doc("Private Endpoint connection resource id")
  id?: string;

  @doc("Private Endpoint Connection Name")
  name?: string;

  @doc("Private Endpoint Connection Resource Type")
  type?: string;

  @doc("Resource properties.")
  properties?: PrivateEndpointConnectionWrapperProperties;
}

@doc("Properties of the PrivateEndpointConnectProperties.")
model PrivateEndpointConnectionWrapperProperties {
  @doc("The resource of private end point.")
  privateEndpoint?: ArmIdWrapper;

  @doc("A collection of information about the state of the connection between service consumer and provider.")
  privateLinkServiceConnectionState: PrivateLinkServiceConnectionState;

  @doc("The provisioning state of the private endpoint connection resource.")
  @visibility("read")
  provisioningState?: string;

  @doc("All the Group ids.")
  @visibility("read")
  groupIds?: string[];
}

@doc("A wrapper for an ARM resource id")
model ArmIdWrapper {
  @visibility("read")
  id?: string;
}

@doc("A collection of information about the state of the connection between service consumer and provider.")
model PrivateLinkServiceConnectionState {
  @doc("Indicates whether the connection has been Approved/Rejected/Removed by the owner of the service.")
  status?: PrivateEndpointServiceConnectionStatus;

  @doc("The reason for approval/rejection of the connection.")
  description?: string;

  @doc("A message indicating if changes on the service provider require any updates on the consumer.")
  actionsRequired?: string;
}

@doc("Identity properties of the Api Management service resource.")
model ApiManagementServiceIdentity {
  @doc("The type of identity used for the resource. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the service.")
  type: ApimIdentityType;

  @doc("The principal id of the identity.")
  @visibility("read")
  principalId?: string;

  @doc("The client tenant id of the identity.")
  @visibility("read")
  tenantId?: string;

  @doc("""
The list of user identities associated with the resource. The user identity 
dictionary key references will be ARM resource ids in the form: 
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  userAssignedIdentities?: Record<UserIdentityProperties>;
}

model UserIdentityProperties {
  @doc("The principal id of user assigned identity.")
  principalId?: string;

  @doc("The client id of user assigned identity.")
  clientId?: string;
}

@doc("The Resource definition.")
model ApimResource {
  @doc("Resource ID.")
  @visibility("read")
  id?: string;

  @doc("Resource name.")
  @visibility("read")
  name?: string;

  @doc("Resource type for API Management resource is set to Microsoft.ApiManagement.")
  @visibility("read")
  type?: string;

  @doc("Resource tags.")
  tags?: Record<string>;
}

@doc("Parameter supplied to Update Api Management Service.")
model ApiManagementServiceUpdateParameters extends ApimResource {
  @doc("Properties of the API Management service.")
  properties?: ApiManagementServiceUpdateProperties;

  @doc("SKU properties of the API Management service.")
  sku?: ApiManagementServiceSkuProperties;

  @doc("Managed service identity of the Api Management service.")
  identity?: ApiManagementServiceIdentity;

  @doc("ETag of the resource.")
  @visibility("read")
  etag?: string;

  @doc("A list of availability zones denoting where the resource needs to come from.")
  zones?: string[];
}

@doc("Properties of an API Management service resource description.")
model ApiManagementServiceUpdateProperties
  extends ApiManagementServiceBaseProperties {
  @doc("Publisher email.")
  @maxLength(100)
  publisherEmail?: string;

  @doc("Publisher name.")
  @maxLength(100)
  publisherName?: string;
}

@doc("The response of the GetSsoToken operation.")
model ApiManagementServiceGetSsoTokenResult {
  @doc("Redirect URL to the Publisher Portal containing the SSO token.")
  redirectUri?: string;
}

@doc("Parameters supplied to the CheckNameAvailability operation.")
model ApiManagementServiceCheckNameAvailabilityParameters {
  @doc("The name to check for availability.")
  name: string;
}

@doc("Response of the CheckNameAvailability operation.")
model ApiManagementServiceNameAvailabilityResult {
  @doc("True if the name is available and can be used to create a new API Management service; otherwise false.")
  @visibility("read")
  nameAvailable?: boolean;

  @doc("If reason == invalid, provide the user with the reason why the given name is invalid, and provide the resource naming requirements so that the user can select a valid name. If reason == AlreadyExists, explain that <resourceName> is already in use, and direct them to select a different name.")
  @visibility("read")
  message?: string;

  @doc("Invalid indicates the name provided does not match the resource provider’s naming requirements (incorrect length, unsupported characters, etc.)  AlreadyExists indicates that the name is already in use and is therefore unavailable.")
  reason?: NameAvailabilityReason;
}

@doc("Response of the GetDomainOwnershipIdentifier operation.")
model ApiManagementServiceGetDomainOwnershipIdentifierResult {
  @doc("The domain ownership identifier value.")
  @visibility("read")
  domainOwnershipIdentifier?: string;
}

@doc("Parameter supplied to the Apply Network configuration operation.")
model ApiManagementServiceApplyNetworkConfigurationParameters {
  @doc("Location of the Api Management service to update for a multi-region service. For a service deployed in a single region, this parameter is not required.")
  location?: string;
}

@doc("Email Template Contract properties.")
model EmailTemplateContractProperties {
  @doc("Subject of the Template.")
  @maxLength(1000)
  @minLength(1)
  subject: string;

  @doc("Email Template Body. This should be a valid XDocument")
  @minLength(1)
  body: string;

  @doc("Title of the Template.")
  title?: string;

  @doc("Description of the Email Template.")
  description?: string;

  @doc("Whether the template is the default template provided by API Management or has been edited.")
  @visibility("read")
  isDefault?: boolean;

  @doc("Email Template Parameter values.")
  parameters?: EmailTemplateParametersContractProperties[];
}

@doc("Email Template Parameter contract.")
model EmailTemplateParametersContractProperties {
  @doc("Template parameter name.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  name?: string;

  @doc("Template parameter title.")
  @maxLength(4096)
  @minLength(1)
  title?: string;

  @doc("Template parameter description.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  description?: string;
}

@doc("Email Template update Parameters.")
model EmailTemplateUpdateParameters {
  @doc("Email Template Update contract properties.")
  properties?: EmailTemplateUpdateParameterProperties;
}

@doc("Email Template Update Contract properties.")
model EmailTemplateUpdateParameterProperties {
  @doc("Subject of the Template.")
  @maxLength(1000)
  @minLength(1)
  subject?: string;

  @doc("Title of the Template.")
  title?: string;

  @doc("Description of the Email Template.")
  description?: string;

  @doc("Email Template Body. This should be a valid XDocument")
  @minLength(1)
  body?: string;

  @doc("Email Template Parameter values.")
  parameters?: EmailTemplateParametersContractProperties[];
}

@doc("Properties of the Gateway contract.")
model GatewayContractProperties {
  @doc("Gateway location.")
  locationData?: ResourceLocationDataContract;

  @doc("Gateway description")
  @maxLength(1000)
  description?: string;
}

@doc("Resource location data properties.")
model ResourceLocationDataContract {
  @doc("A canonical name for the geographic or physical location.")
  @maxLength(256)
  name: string;

  @doc("The city or locality where the resource is located.")
  @maxLength(256)
  city?: string;

  @doc("The district, state, or province where the resource is located.")
  @maxLength(256)
  district?: string;

  @doc("The country or region where the resource is located.")
  @maxLength(256)
  countryOrRegion?: string;
}

@doc("Gateway authentication keys.")
model GatewayKeysContract {
  @doc("Primary gateway key.")
  primary?: string;

  @doc("Secondary gateway key.")
  secondary?: string;
}

@doc("Gateway key regeneration request contract properties.")
model GatewayKeyRegenerationRequestContract {
  @doc("The Key being regenerated.")
  keyType: GatewayRegenerateKeyType;
}

@doc("Gateway token request contract properties.")
model GatewayTokenRequestContract {
  @doc("The Key to be used to generate gateway token.")
  keyType: KeyType;

  @doc("""
The Expiry time of the Token. Maximum token expiry time is set to 30 days. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiry: utcDateTime;
}

@doc("Gateway access token.")
model GatewayTokenContract {
  @doc("Shared Access Authentication token value for the Gateway.")
  value?: string;
}

@doc("Gateway hostname configuration details.")
model GatewayHostnameConfigurationContractProperties {
  @doc("Hostname value. Supports valid domain name, partial or full wildcard")
  hostname?: string;

  @doc("Identifier of Certificate entity that will be used for TLS connection establishment")
  certificateId?: string;

  @doc("Determines whether gateway requests client certificate")
  negotiateClientCertificate?: boolean;

  @doc("Specifies if TLS 1.0 is supported")
  tls10Enabled?: boolean;

  @doc("Specifies if TLS 1.1 is supported")
  tls11Enabled?: boolean;

  @doc("Specifies if HTTP/2.0 is supported")
  http2Enabled?: boolean;
}

@doc("Paged API list representation.")
model ApiManagementGatewayApiListResult is Azure.Core.Page<GatewayApiData> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

model GatewayApiData extends ApiContract {}

@doc("Association entity details.")
model AssociationContract extends Resource {
  @doc("Association entity contract properties.")
  properties?: AssociationContractProperties;
}

@doc("Association entity contract properties.")
model AssociationContractProperties {
  @doc("Provisioning state.")
  provisioningState?: "created";
}

@doc("Gateway certificate authority details.")
model GatewayCertificateAuthorityContractProperties {
  @doc("Determines whether certificate authority is trusted.")
  isTrusted?: boolean;
}

@doc("Group contract Properties.")
model GroupContractProperties {
  @doc("Group name.")
  @maxLength(300)
  @minLength(1)
  displayName: string;

  @doc("Group description. Can contain HTML formatting tags.")
  @maxLength(1000)
  description?: string;

  @doc("true if the group is one of the three system groups (Administrators, Developers, or Guests); otherwise false.")
  @visibility("read")
  builtIn?: boolean;

  @doc("Group type.")
  type?: GroupType;

  @doc("For external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://<tenant>.onmicrosoft.com/groups/<group object id>`; otherwise the value is null.")
  externalId?: string;
}

@doc("Parameters supplied to the Create Group operation.")
model GroupCreateParameters {
  @doc("Properties supplied to Create Group operation.")
  properties?: GroupCreateParametersProperties;
}

@doc("Parameters supplied to the Create Group operation.")
model GroupCreateParametersProperties {
  @doc("Group name.")
  @maxLength(300)
  @minLength(1)
  displayName: string;

  @doc("Group description.")
  description?: string;

  @doc("Group type.")
  type?: GroupType;

  @doc("Identifier of the external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://<tenant>.onmicrosoft.com/groups/<group object id>`; otherwise the value is null.")
  externalId?: string;
}

@doc("Parameters supplied to the Update Group operation.")
model GroupUpdateParameters {
  @doc("Group entity update contract properties.")
  properties?: GroupUpdateParametersProperties;
}

@doc("Parameters supplied to the Update Group operation.")
model GroupUpdateParametersProperties {
  @doc("Group name.")
  @maxLength(300)
  @minLength(1)
  displayName?: string;

  @doc("Group description.")
  description?: string;

  @doc("Group type.")
  type?: GroupType;

  @doc("Identifier of the external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://<tenant>.onmicrosoft.com/groups/<group object id>`; otherwise the value is null.")
  externalId?: string;
}

@doc("Paged Group Users list representation.")
model ApiManagementGroupUserListResult
  is Azure.Core.Page<ApiManagementGroupUserData> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

model ApiManagementGroupUserData extends UserContract {}

@doc("User profile.")
model UserContractProperties extends UserEntityBaseParameters {
  @doc("First name.")
  firstName?: string;

  @doc("Last name.")
  lastName?: string;

  @doc("Email address.")
  email?: string;

  @doc("""
Date of user registration. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  registrationDate?: utcDateTime;

  @doc("Collection of groups user is part of.")
  @visibility("read")
  groups?: GroupContractProperties[];
}

@doc("User Entity Base Parameters set.")
model UserEntityBaseParameters {
  @doc("Account state. Specifies whether the user is active or not. Blocked users are unable to sign into the developer portal or call any APIs of subscribed products. Default state is Active.")
  state?: UserState;

  @doc("Optional note about a user set by the administrator.")
  note?: string;

  @doc("Collection of user identities.")
  identities?: UserIdentityContract[];
}

@doc("User identity details.")
model UserIdentityContract {
  @doc("Identity provider name.")
  provider?: string;

  @doc("Identifier value within provider.")
  id?: string;
}

@doc("The external Identity Providers like Facebook, Google, Microsoft, Twitter or Azure Active Directory which can be used to enable access to the API Management service developer portal for all users.")
model IdentityProviderContractProperties
  extends IdentityProviderBaseParameters {
  @doc("Client Id of the Application in the external Identity Provider. It is App ID for Facebook login, Client ID for Google login, App ID for Microsoft.")
  @minLength(1)
  clientId: string;

  @doc("Client secret of the Application in external Identity Provider, used to authenticate login request. For example, it is App Secret for Facebook login, API Key for Google login, Public Key for Microsoft. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  @minLength(1)
  clientSecret?: string;
}

@doc("Identity Provider Base Parameter Properties.")
model IdentityProviderBaseParameters {
  @doc("Identity Provider Type identifier.")
  @projectedName("json", "type")
  identityProviderType?: IdentityProviderType;

  @doc("The TenantId to use instead of Common when logging into Active Directory")
  @projectedName("json", "signinTenant")
  signInTenant?: string;

  @doc("List of Allowed Tenants when configuring Azure Active Directory login.")
  allowedTenants?: string[];

  @doc("OpenID Connect discovery endpoint hostname for AAD or AAD B2C.")
  authority?: string;

  @doc("Signup Policy Name. Only applies to AAD B2C Identity Provider.")
  @minLength(1)
  @projectedName("json", "signupPolicyName")
  signUpPolicyName?: string;

  @doc("Signin Policy Name. Only applies to AAD B2C Identity Provider.")
  @minLength(1)
  @projectedName("json", "signinPolicyName")
  signInPolicyName?: string;

  @doc("Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.")
  @minLength(1)
  profileEditingPolicyName?: string;

  @doc("Password Reset Policy Name. Only applies to AAD B2C Identity Provider.")
  @minLength(1)
  passwordResetPolicyName?: string;
}

@doc("Identity Provider details.")
model IdentityProviderCreateContract extends Resource {
  @doc("Identity Provider contract properties.")
  properties?: IdentityProviderCreateContractProperties;
}

@doc("The external Identity Providers like Facebook, Google, Microsoft, Twitter or Azure Active Directory which can be used to enable access to the API Management service developer portal for all users.")
model IdentityProviderCreateContractProperties
  extends IdentityProviderBaseParameters {
  @doc("Client Id of the Application in the external Identity Provider. It is App ID for Facebook login, Client ID for Google login, App ID for Microsoft.")
  @minLength(1)
  clientId: string;

  @doc("Client secret of the Application in external Identity Provider, used to authenticate login request. For example, it is App Secret for Facebook login, API Key for Google login, Public Key for Microsoft. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  @minLength(1)
  clientSecret: string;
}

@doc("Parameters supplied to update Identity Provider")
model IdentityProviderUpdateParameters {
  @doc("Identity Provider update properties.")
  properties?: IdentityProviderUpdateProperties;
}

@doc("Parameters supplied to the Update Identity Provider operation.")
model IdentityProviderUpdateProperties extends IdentityProviderBaseParameters {
  @doc("Client Id of the Application in the external Identity Provider. It is App ID for Facebook login, Client ID for Google login, App ID for Microsoft.")
  @minLength(1)
  clientId?: string;

  @doc("Client secret of the Application in external Identity Provider, used to authenticate login request. For example, it is App Secret for Facebook login, API Key for Google login, Public Key for Microsoft.")
  @minLength(1)
  clientSecret?: string;
}

@doc("Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.")
model ClientSecretContract {
  @doc("Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.")
  clientSecret?: string;
}

@doc("The Logger entity in API Management represents an event sink that you can use to log API Management events. Currently the Logger entity supports logging API Management events to Azure Event Hubs.")
model LoggerContractProperties {
  @doc("Logger type.")
  loggerType: LoggerType;

  @doc("Logger description.")
  @maxLength(256)
  description?: string;

  @doc("""
The name and SendRule connection string of the event hub for azureEventHub logger.
Instrumentation key for applicationInsights logger.
""")
  credentials?: Record<string>;

  @doc("Whether records are buffered in the logger before publishing. Default is assumed to be true.")
  isBuffered?: boolean;

  @doc("Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource).")
  resourceId?: string;
}

@doc("Logger update contract.")
model LoggerUpdateContract {
  @doc("Logger entity update contract properties.")
  properties?: LoggerUpdateParameters;
}

@doc("Parameters supplied to the Update Logger operation.")
model LoggerUpdateParameters {
  @doc("Logger type.")
  loggerType?: LoggerType;

  @doc("Logger description.")
  description?: string;

  @doc("Logger credentials.")
  credentials?: Record<string>;

  @doc("Whether records are buffered in the logger before publishing. Default is assumed to be true.")
  isBuffered?: boolean;
}

@doc("NamedValue Contract properties.")
model NamedValueContractProperties extends NamedValueEntityBaseParameters {
  @doc("Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  displayName: string;

  @doc("Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  @maxLength(4096)
  value?: string;

  @doc("KeyVault location details of the namedValue.")
  keyVault?: KeyVaultContractProperties;
}

@doc("NamedValue Entity Base Parameters set.")
model NamedValueEntityBaseParameters {
  @doc("Optional tags that when provided can be used to filter the NamedValue list.")
  tags?: string[];

  @doc("Determines whether the value is a secret and should be encrypted or not. Default value is false.")
  @projectedName("json", "secret")
  IsSecret?: boolean;
}

@doc("NamedValue details.")
model NamedValueCreateContract extends Resource {
  @doc("NamedValue entity contract properties for PUT operation.")
  properties?: NamedValueCreateContractProperties;
}

@doc("NamedValue Contract properties.")
model NamedValueCreateContractProperties
  extends NamedValueEntityBaseParameters {
  @doc("Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  displayName: string;

  @doc("Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  @maxLength(4096)
  value?: string;

  @doc("KeyVault location details of the namedValue.")
  keyVault?: KeyVaultContractCreateProperties;
}

@doc("NamedValue update Parameters.")
model NamedValueUpdateParameters {
  @doc("NamedValue entity Update contract properties.")
  properties?: NamedValueUpdateParameterProperties;
}

@doc("NamedValue Contract properties.")
model NamedValueUpdateParameterProperties
  extends NamedValueEntityBaseParameters {
  @doc("Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[A-Za-z0-9-._]+$")
  displayName?: string;

  @doc("Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace.")
  @maxLength(4096)
  @minLength(1)
  value?: string;

  @doc("KeyVault location details of the namedValue.")
  keyVault?: KeyVaultContractCreateProperties;
}

@doc("Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.")
model NamedValueSecretContract {
  @doc("This is secret value of the NamedValue entity.")
  value?: string;
}

@doc("Network Status in the Location")
model NetworkStatusContractByLocation {
  @doc("Location of service")
  @minLength(1)
  location?: string;

  @doc("Network status in Location")
  networkStatus?: NetworkStatusContract;
}

@doc("Network Status details.")
model NetworkStatusContract {
  @doc("Gets the list of DNS servers IPV4 addresses.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  dnsServers: string[];

  @doc("Gets the list of Connectivity Status to the Resources on which the service depends upon.")
  connectivityStatus: ConnectivityStatusContract[];
}

@doc("Details about connectivity to a resource.")
model ConnectivityStatusContract {
  @doc("The hostname of the resource which the service depends on. This can be the database, storage or any other azure resource on which the service depends upon.")
  @minLength(1)
  name: string;

  @doc("Resource Connectivity Status Type identifier.")
  status: ConnectivityStatusType;

  @doc("Error details of the connectivity to the resource.")
  error?: string;

  @doc("""
The date when the resource connectivity status was last updated. This status should be updated every 15 minutes. If this status has not been updated, then it means that the service has lost network connectivity to the resource, from inside the Virtual Network.The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdated: utcDateTime;

  @doc("""
The date when the resource connectivity status last Changed from success to failure or vice-versa. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastStatusChange: utcDateTime;

  @doc("Resource Type.")
  resourceType: string;

  @doc("Whether this is optional.")
  isOptional: boolean;
}

@doc("Notification Contract properties.")
model NotificationContractProperties {
  @doc("Title of the Notification.")
  @maxLength(1000)
  @minLength(1)
  title: string;

  @doc("Description of the Notification.")
  description?: string;

  @doc("Recipient Parameter values.")
  recipients?: RecipientsContractProperties;
}

@doc("Notification Parameter contract.")
model RecipientsContractProperties {
  @doc("List of Emails subscribed for the notification.")
  emails?: string[];

  @doc("List of Users subscribed for the notification.")
  users?: string[];
}

@doc("Paged Recipient User list representation.")
model RecipientUserListResult {
  @doc("Page values.")
  value?: RecipientUserContract[];

  @doc("Total record count number across all pages.")
  count?: int64;

  @doc("Next page link if any.")
  nextLink?: string;
}

@doc("Recipient User details.")
model RecipientUserContract extends Resource {
  @doc("Recipient User entity contract properties.")
  properties?: RecipientUsersContractProperties;
}

@doc("Recipient User Contract Properties.")
model RecipientUsersContractProperties {
  @doc("API Management UserId subscribed to notification.")
  userId?: string;
}

@doc("Paged Recipient User list representation.")
model RecipientEmailListResult {
  @doc("Page values.")
  value?: RecipientEmailContract[];

  @doc("Total record count number across all pages.")
  count?: int64;

  @doc("Next page link if any.")
  nextLink?: string;
}

@doc("Recipient Email details.")
model RecipientEmailContract extends Resource {
  @doc("Recipient Email contract properties.")
  properties?: RecipientEmailContractProperties;
}

@doc("Recipient Email Contract Properties.")
model RecipientEmailContractProperties {
  @doc("User Email subscribed to notification.")
  email?: string;
}

@doc("OpenID Connect Providers Contract.")
model OpenidConnectProviderContractProperties {
  @doc("User-friendly OpenID Connect Provider name.")
  @maxLength(50)
  displayName: string;

  @doc("User-friendly description of OpenID Connect Provider.")
  description?: string;

  @doc("Metadata endpoint URI.")
  metadataEndpoint: string;

  @doc("Client ID of developer console which is the client application.")
  clientId: string;

  @doc("Client Secret of developer console which is the client application.")
  clientSecret?: string;
}

@doc("Parameters supplied to the Update OpenID Connect Provider operation.")
model OpenidConnectProviderUpdateContract {
  @doc("OpenId Connect Provider Update contract properties.")
  properties?: OpenidConnectProviderUpdateContractProperties;
}

@doc("Parameters supplied to the Update OpenID Connect Provider operation.")
model OpenidConnectProviderUpdateContractProperties {
  @doc("User-friendly OpenID Connect Provider name.")
  @maxLength(50)
  displayName?: string;

  @doc("User-friendly description of OpenID Connect Provider.")
  description?: string;

  @doc("Metadata endpoint URI.")
  metadataEndpoint?: string;

  @doc("Client ID of developer console which is the client application.")
  clientId?: string;

  @doc("Client Secret of developer console which is the client application.")
  clientSecret?: string;
}

@doc("Collection of Outbound Environment Endpoints")
model OutboundEnvironmentEndpointList {
  @doc("Collection of resources.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  value: OutboundEnvironmentEndpoint[];

  @doc("Link to next page of resources.")
  @visibility("read")
  nextLink?: string;
}

@doc("Endpoints accessed for a common purpose that the Api Management Service requires outbound network access to.")
model OutboundEnvironmentEndpoint {
  @doc("The type of service accessed by the Api Management Service, e.g., Azure Storage, Azure SQL Database, and Azure Active Directory.")
  category?: string;

  @doc("The endpoints that the Api Management Service reaches the service at.")
  endpoints?: EndpointDependency[];
}

@doc("A domain name that a service is reached at.")
model EndpointDependency {
  @doc("The domain name of the dependency.")
  domainName?: string;

  @doc("The Ports used when connecting to DomainName.")
  endpointDetails?: EndpointDetail[];
}

@doc("Current TCP connectivity information from the Api Management Service to a single endpoint.")
model EndpointDetail {
  @doc("The port an endpoint is connected to.")
  port?: int32;

  @doc("The region of the dependency.")
  region?: string;
}

@doc("Descriptions of APIM policies.")
model PolicyDescriptionListResult {
  @doc("Descriptions of APIM policies.")
  value?: PolicyDescriptionContract[];

  @doc("Total record count number.")
  count?: int64;
}

@doc("Policy description details.")
model PolicyDescriptionContract extends Resource {
  @doc("Policy description contract properties.")
  properties?: PolicyDescriptionContractProperties;
}

@doc("Policy description properties.")
model PolicyDescriptionContractProperties {
  @doc("Policy description.")
  @visibility("read")
  description?: string;

  @doc("Binary OR value of the Snippet scope.")
  @visibility("read")
  scope?: int64;
}

model PortalRevisionContractProperties {
  @doc("Portal revision description.")
  @maxLength(2000)
  description?: string;

  @doc("Portal revision publishing status details.")
  @visibility("read")
  @maxLength(2000)
  statusDetails?: string;

  @doc("Status of the portal's revision.")
  @visibility("read")
  status?: PortalRevisionStatus;

  @doc("Indicates if the portal's revision is public.")
  isCurrent?: boolean;

  @doc("Portal's revision creation date and time.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("Last updated date and time.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedDateTime?: utcDateTime;
}

@doc("Portal Settings for the Developer Portal.")
model PortalSettingsContract extends Resource {
  @doc("Portal Settings contract properties.")
  properties?: PortalSettingsContractProperties;
}

@doc("Sign-in settings contract properties.")
model PortalSettingsContractProperties {
  @doc("A delegation Url.")
  url?: string;

  @doc("A base64-encoded validation key to validate, that a request is coming from Azure API Management.")
  validationKey?: string;

  @doc("Subscriptions delegation settings.")
  @projectedName("json", "subscriptions")
  IsSubscriptions?: SubscriptionsDelegationSettingsProperties;

  @doc("User registration delegation settings.")
  @projectedName("json", "userRegistration")
  IsUserRegistration?: RegistrationDelegationSettingsProperties;

  @doc("Redirect Anonymous users to the Sign-In page.")
  enabled?: boolean;

  @doc("Terms of service contract properties.")
  termsOfService?: TermsOfServiceProperties;
}

@doc("Subscriptions delegation settings properties.")
model SubscriptionsDelegationSettingsProperties {
  @doc("Enable or disable delegation for subscriptions.")
  enabled?: boolean;
}

@doc("User registration delegation settings properties.")
model RegistrationDelegationSettingsProperties {
  @doc("Enable or disable delegation for user registration.")
  enabled?: boolean;
}

@doc("Terms of service contract properties.")
model TermsOfServiceProperties {
  @doc("A terms of service text.")
  text?: string;

  @doc("Display terms of service during a sign-up process.")
  enabled?: boolean;

  @doc("Ask user for consent to the terms of service.")
  consentRequired?: boolean;
}

@doc("Sign-in settings contract properties.")
model PortalSigninSettingProperties {
  @doc("Redirect Anonymous users to the Sign-In page.")
  enabled?: boolean;
}

@doc("Sign-up settings contract properties.")
model PortalSignupSettingsProperties {
  @doc("Allow users to sign up on a developer portal.")
  enabled?: boolean;

  @doc("Terms of service contract properties.")
  termsOfService?: TermsOfServiceProperties;
}

@doc("Delegation settings contract properties.")
model PortalDelegationSettingsProperties {
  @doc("A delegation Url.")
  url?: string;

  @doc("A base64-encoded validation key to validate, that a request is coming from Azure API Management.")
  validationKey?: string;

  @doc("Subscriptions delegation settings.")
  subscriptions?: SubscriptionsDelegationSettingsProperties;

  @doc("User registration delegation settings.")
  userRegistration?: RegistrationDelegationSettingsProperties;
}

@doc("Client or app secret used in IdentityProviders, Aad, OpenID or OAuth.")
model PortalSettingValidationKeyContract {
  @doc("This is secret value of the validation key in portal settings.")
  validationKey?: string;
}

@doc("Properties of the PrivateEndpointConnectProperties.")
model PrivateEndpointConnectionProperties {
  @doc("The resource of private end point.")
  privateEndpoint?: PrivateEndpoint;

  @doc("A collection of information about the state of the connection between service consumer and provider.")
  privateLinkServiceConnectionState: PrivateLinkServiceConnectionState;

  @doc("The provisioning state of the private endpoint connection resource.")
  @visibility("read")
  provisioningState?: PrivateEndpointConnectionProvisioningState;
}

@doc("The Private Endpoint resource.")
model PrivateEndpoint {
  @doc("The ARM identifier for Private Endpoint")
  @visibility("read")
  id?: string;
}

@doc("A request to approve or reject a private endpoint connection")
model PrivateEndpointConnectionRequest {
  @doc("Private Endpoint Connection Resource Id.")
  id?: string;

  @doc("The connection state of the private endpoint connection.")
  properties?: PrivateEndpointConnectionRequestProperties;
}

@doc("The connection state of the private endpoint connection.")
model PrivateEndpointConnectionRequestProperties {
  @doc("A collection of information about the state of the connection between service consumer and provider.")
  privateLinkServiceConnectionState?: PrivateLinkServiceConnectionState;
}

@doc("Properties of a private link resource.")
model PrivateLinkResourceProperties {
  @doc("The private link resource group id.")
  @visibility("read")
  groupId?: string;

  @doc("The private link resource required member names.")
  @visibility("read")
  requiredMembers?: string[];

  @doc("The private link resource Private link DNS zone name.")
  requiredZoneNames?: string[];
}

@doc("Product Update parameters.")
model ProductUpdateParameters {
  @doc("Product entity Update contract properties.")
  properties?: ProductUpdateProperties;
}

@doc("Parameters supplied to the Update Product operation.")
model ProductUpdateProperties extends ProductEntityBaseParameters {
  @doc("Product name.")
  @maxLength(300)
  @minLength(1)
  displayName?: string;
}

@doc("Paged API list representation.")
model ApiManagementProductApiListResult is Azure.Core.Page<ProductApiData> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

model ProductApiData extends ApiContract {}

@doc("Paged Group list representation.")
model ApiManagementProductGroupListResult is Azure.Core.Page<ProductGroupData> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

model ProductGroupData extends GroupContract {}

@doc("Subscription details.")
model SubscriptionContractProperties {
  @doc("The user resource identifier of the subscription owner. The value is a valid relative URL in the format of /users/{userId} where {userId} is a user identifier.")
  ownerId?: string;

  @doc("Scope like /products/{productId} or /apis or /apis/{apiId}.")
  scope: string;

  @doc("The name of the subscription, or null if the subscription has no name.")
  @maxLength(100)
  displayName?: string;

  @doc("Subscription state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.")
  state: SubscriptionState;

  @doc("""
Subscription creation date. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  @doc("""
Subscription activation date. The setting is for audit purposes only and the subscription is not automatically activated. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDate?: utcDateTime;

  @doc("""
Subscription expiration date. The setting is for audit purposes only and the subscription is not automatically expired. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDate?: utcDateTime;

  @doc("""
Date when subscription was cancelled or expired. The setting is for audit purposes only and the subscription is not automatically cancelled. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDate?: utcDateTime;

  @doc("""
Upcoming subscription expiration notification date. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  notificationDate?: utcDateTime;

  @doc("Subscription primary key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  @doc("Subscription secondary key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;

  @doc("Optional subscription comment added by an administrator when the state is changed to the 'rejected'.")
  stateComment?: string;

  @doc("Determines whether tracing is enabled")
  allowTracing?: boolean;
}

@doc("Paged Quota Counter list representation.")
model QuotaCounterListResult {
  @doc("Quota counter values.")
  value?: QuotaCounterContract[];

  @doc("Total record count number across all pages.")
  count?: int64;

  @doc("Next page link if any.")
  nextLink?: string;
}

@doc("Quota counter details.")
@resource("subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/periods/{quotaPeriodKey}")
model QuotaCounterContract {
  @doc("The Key value of the Counter. Must not be empty.")
  @minLength(1)
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  counterKey: string;

  @doc("Identifier of the Period for which the counter was collected. Must not be empty.")
  @minLength(1)
  periodKey: string;

  @doc("""
The date of the start of Counter Period. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  periodStartTime: utcDateTime;

  @doc("""
The date of the end of Counter Period. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  periodEndTime: utcDateTime;

  @doc("Quota Value Properties")
  value?: QuotaCounterValueContractProperties;
}

@doc("Quota counter value details.")
model QuotaCounterValueContractProperties {
  @doc("Number of times Counter was called.")
  callsCount?: int32;

  @doc("Data Transferred in KiloBytes.")
  kbTransferred?: float64;
}

@doc("Quota counter value details.")
model QuotaCounterValueUpdateContract {
  @doc("Quota counter value details.")
  properties?: QuotaCounterValueContractProperties;
}

@doc("Lists Regions operation response details.")
model RegionListResult is Azure.Core.Page<RegionContract> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

@doc("Region profile.")
model RegionContract {
  @doc("Region name.")
  @visibility("read")
  name?: string;

  @doc("whether Region is the master region.")
  isMasterRegion?: boolean;

  @doc("whether Region is deleted.")
  isDeleted?: boolean;
}

@doc("Paged Report records list representation.")
model ReportListResult is Azure.Core.Page<ReportRecordContract> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

@doc("Report data.")
model ReportRecordContract {
  @doc("Name depending on report endpoint specifies product, API, operation or developer name.")
  name?: string;

  @doc("""
Start of aggregation period. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  @doc("Length of aggregation period.  Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO 8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).")
  interval?: string;

  @doc("Country to which this record data is related.")
  country?: string;

  @doc("Country region to which this record data is related.")
  region?: string;

  @doc("Zip code to which this record data is related.")
  zip?: string;

  @doc("User identifier path. /users/{userId}")
  @visibility("read")
  userId?: string;

  @doc("Product identifier path. /products/{productId}")
  @visibility("read")
  productId?: string;

  @doc("API identifier path. /apis/{apiId}")
  apiId?: string;

  @doc("Operation identifier path. /apis/{apiId}/operations/{operationId}")
  operationId?: string;

  @doc("API region identifier.")
  apiRegion?: string;

  @doc("Subscription identifier path. /subscriptions/{subscriptionId}")
  subscriptionId?: string;

  @doc("Number of successful calls. This includes calls returning HttpStatusCode <= 301 and HttpStatusCode.NotModified and HttpStatusCode.TemporaryRedirect")
  callCountSuccess?: int32;

  @doc("Number of calls blocked due to invalid credentials. This includes calls returning HttpStatusCode.Unauthorized and HttpStatusCode.Forbidden and HttpStatusCode.TooManyRequests")
  callCountBlocked?: int32;

  @doc("Number of calls failed due to proxy or backend errors. This includes calls returning HttpStatusCode.BadRequest(400) and any Code between HttpStatusCode.InternalServerError (500) and 600")
  callCountFailed?: int32;

  @doc("Number of other calls.")
  callCountOther?: int32;

  @doc("Total number of calls.")
  callCountTotal?: int32;

  @doc("Bandwidth consumed.")
  bandwidth?: int64;

  @doc("Number of times when content was served from cache policy.")
  cacheHitCount?: int32;

  @doc("Number of times content was fetched from backend.")
  cacheMissCount?: int32;

  @doc("Average time it took to process request.")
  apiTimeAvg?: float64;

  @doc("Minimum time it took to process request.")
  apiTimeMin?: float64;

  @doc("Maximum time it took to process request.")
  apiTimeMax?: float64;

  @doc("Average time it took to process request on backend.")
  serviceTimeAvg?: float64;

  @doc("Minimum time it took to process request on backend.")
  serviceTimeMin?: float64;

  @doc("Maximum time it took to process request on backend.")
  serviceTimeMax?: float64;
}

@doc("Paged Report records list representation.")
@pagedResult
model RequestReportListResult {
  @doc("Page values.")
  @items
  value?: RequestReportRecordContract[];

  @doc("Total record count number across all pages.")
  count?: int64;
}

@doc("Request Report data.")
model RequestReportRecordContract {
  @doc("API identifier path. /apis/{apiId}")
  apiId?: string;

  @doc("Operation identifier path. /apis/{apiId}/operations/{operationId}")
  operationId?: string;

  @doc("Product identifier path. /products/{productId}")
  @visibility("read")
  productId?: string;

  @doc("User identifier path. /users/{userId}")
  @visibility("read")
  userId?: string;

  @doc("The HTTP method associated with this request..")
  method?: string;

  @doc("The full URL associated with this request.")
  url?: string;

  @doc("The client IP address associated with this request.")
  ipAddress?: string;

  @doc("The HTTP status code received by the gateway as a result of forwarding this request to the backend.")
  backendResponseCode?: string;

  @doc("The HTTP status code returned by the gateway.")
  responseCode?: int32;

  @doc("The size of the response returned by the gateway.")
  responseSize?: int32;

  @doc("The date and time when this request was received by the gateway in ISO 8601 format.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  @doc("Specifies if response cache was involved in generating the response. If the value is none, the cache was not used. If the value is hit, cached response was returned. If the value is miss, the cache was used but lookup resulted in a miss and request was fulfilled by the backend.")
  cache?: string;

  @doc("The total time it took to process this request.")
  apiTime?: float64;

  @doc("he time it took to forward this request to the backend and get the response back.")
  serviceTime?: float64;

  @doc("Azure region where the gateway that processed this request is located.")
  apiRegion?: string;

  @doc("Subscription identifier path. /subscriptions/{subscriptionId}")
  subscriptionId?: string;

  @doc("Request Identifier.")
  requestId?: string;

  @doc("The size of this request..")
  requestSize?: int32;
}

@doc("Schema create or update contract Properties.")
model GlobalSchemaContractProperties {
  @doc("Schema Type. Immutable.")
  schemaType: SchemaType;

  @doc("Free-form schema entity description.")
  description?: string;

  @doc("Json-encoded string for non json-based schema.")
  value?: unknown;

  @doc("Global Schema document object for json-based schema formats(e.g. json schema).")
  document?: Record<unknown>;
}

@doc("Tenant access information contract of the API Management service.")
model TenantSettingsContractProperties {
  @doc("Tenant settings")
  settings?: Record<string>;
}

@doc("The List Resource Skus operation response.")
model ApiManagementSkusResult is Azure.Core.Page<ApiManagementSku>;

@doc("Describes an available ApiManagement SKU.")
model ApiManagementSku {
  @doc("The type of resource the SKU applies to.")
  @visibility("read")
  resourceType?: string;

  @doc("The name of SKU.")
  @visibility("read")
  name?: string;

  @doc("Specifies the tier of virtual machines in a scale set.<br /><br /> Possible Values:<br /><br /> **Standard**<br /><br /> **Basic**")
  @visibility("read")
  tier?: string;

  @doc("The Size of the SKU.")
  @visibility("read")
  size?: string;

  @doc("The Family of this particular SKU.")
  @visibility("read")
  family?: string;

  @doc("The Kind of resources that are supported in this SKU.")
  @visibility("read")
  kind?: string;

  @doc("Specifies the number of virtual machines in the scale set.")
  @visibility("read")
  capacity?: ApiManagementSkuCapacity;

  @doc("The set of locations that the SKU is available.")
  @visibility("read")
  locations?: string[];

  @doc("A list of locations and availability zones in those locations where the SKU is available.")
  @visibility("read")
  locationInfo?: ApiManagementSkuLocationInfo[];

  @doc("The api versions that support this SKU.")
  @visibility("read")
  apiVersions?: string[];

  @doc("Metadata for retrieving price info.")
  @visibility("read")
  costs?: ApiManagementSkuCosts[];

  @doc("A name value pair to describe the capability.")
  @visibility("read")
  capabilities?: ApiManagementSkuCapabilities[];

  @doc("The restrictions because of which SKU cannot be used. This is empty if there are no restrictions.")
  @visibility("read")
  restrictions?: ApiManagementSkuRestrictions[];
}

@doc("Describes scaling information of a SKU.")
model ApiManagementSkuCapacity {
  @doc("The minimum capacity.")
  @visibility("read")
  minimum?: int32;

  @doc("The maximum capacity that can be set.")
  @visibility("read")
  maximum?: int32;

  @doc("The default capacity.")
  @visibility("read")
  default?: int32;

  @doc("The scale type applicable to the sku.")
  @visibility("read")
  scaleType?: ApiManagementSkuCapacityScaleType;
}

model ApiManagementSkuLocationInfo {
  @doc("Location of the SKU")
  @visibility("read")
  location?: string;

  @doc("List of availability zones where the SKU is supported.")
  @visibility("read")
  zones?: string[];

  @doc("Details of capabilities available to a SKU in specific zones.")
  @visibility("read")
  zoneDetails?: ApiManagementSkuZoneDetails[];
}

@doc("Describes The zonal capabilities of a SKU.")
model ApiManagementSkuZoneDetails {
  @doc("The set of zones that the SKU is available in with the specified capabilities.")
  @visibility("read")
  name?: string[];

  @doc("A list of capabilities that are available for the SKU in the specified list of zones.")
  @visibility("read")
  capabilities?: ApiManagementSkuCapabilities[];
}

@doc("Describes The SKU capabilities object.")
model ApiManagementSkuCapabilities {
  @doc("An invariant to describe the feature.")
  @visibility("read")
  name?: string;

  @doc("An invariant if the feature is measured by quantity.")
  @visibility("read")
  value?: string;
}

@doc("Describes metadata for retrieving price info.")
model ApiManagementSkuCosts {
  @doc("Used for querying price from commerce.")
  @visibility("read")
  meterID?: string;

  @doc("The multiplier is needed to extend the base metered cost.")
  @visibility("read")
  quantity?: int64;

  @doc("An invariant to show the extended unit.")
  @visibility("read")
  extendedUnit?: string;
}

@doc("Describes scaling information of a SKU.")
model ApiManagementSkuRestrictions {
  @doc("The type of restrictions.")
  @visibility("read")
  type?: ApiManagementSkuRestrictionsType;

  @doc("The value of restrictions. If the restriction type is set to location. This would be different locations where the SKU is restricted.")
  @visibility("read")
  values?: string[];

  @doc("The information about the restriction where the SKU cannot be used.")
  @visibility("read")
  restrictionInfo?: ApiManagementSkuRestrictionInfo;

  @doc("The reason for restriction.")
  @visibility("read")
  reasonCode?: ApiManagementSkuRestrictionsReasonCode;
}

model ApiManagementSkuRestrictionInfo {
  @doc("Locations where the SKU is restricted")
  @visibility("read")
  locations?: string[];

  @doc("List of availability zones where the SKU is restricted.")
  @visibility("read")
  zones?: string[];
}

@doc("Subscription create details.")
model SubscriptionCreateParameters {
  @doc("Subscription contract properties.")
  properties?: SubscriptionCreateParameterProperties;
}

@doc("Parameters supplied to the Create subscription operation.")
model SubscriptionCreateParameterProperties {
  @doc("User (user id path) for whom subscription is being created in form /users/{userId}")
  ownerId?: string;

  @doc("Scope like /products/{productId} or /apis or /apis/{apiId}.")
  scope: string;

  @doc("Subscription name.")
  @maxLength(100)
  @minLength(1)
  displayName: string;

  @doc("Primary subscription key. If not specified during request key will be generated automatically.")
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  @doc("Secondary subscription key. If not specified during request key will be generated automatically.")
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;

  @doc("Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.")
  state?: SubscriptionState;

  @doc("Determines whether tracing can be enabled")
  allowTracing?: boolean;
}

@doc("Subscription update details.")
model SubscriptionUpdateParameters {
  @doc("Subscription Update contract properties.")
  properties?: SubscriptionUpdateParameterProperties;
}

@doc("Parameters supplied to the Update subscription operation.")
model SubscriptionUpdateParameterProperties {
  @doc("User identifier path: /users/{userId}")
  ownerId?: string;

  @doc("Scope like /products/{productId} or /apis or /apis/{apiId}")
  scope?: string;

  @doc("Subscription expiration date. The setting is for audit purposes only and the subscription is not automatically expired. The subscription lifecycle can be managed by using the `state` property. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDate?: utcDateTime;

  @doc("Subscription name.")
  displayName?: string;

  @doc("Primary subscription key.")
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  @doc("Secondary subscription key.")
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;

  @doc("Subscription state. Possible states are * active – the subscription is active, * suspended – the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted – the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected – the subscription request has been denied by an administrator, * cancelled – the subscription has been cancelled by the developer or administrator, * expired – the subscription reached its expiration date and was deactivated.")
  state?: SubscriptionState;

  @doc("Comments describing subscription state change by the administrator when the state is changed to the 'rejected'.")
  stateComment?: string;

  @doc("Determines whether tracing can be enabled")
  allowTracing?: boolean;
}

@doc("Subscription keys.")
model SubscriptionKeysContract {
  @doc("Subscription primary key.")
  @maxLength(256)
  @minLength(1)
  primaryKey?: string;

  @doc("Subscription secondary key.")
  @maxLength(256)
  @minLength(1)
  secondaryKey?: string;
}

@doc("Parameters supplied to Create/Update Tag operations.")
model TagCreateUpdateParameters {
  @doc("Properties supplied to Create Tag operation.")
  properties?: TagContractProperties;
}

@doc("Tenant access information contract of the API Management service.")
model AccessInformationContractProperties {
  @doc("Access Information type ('access' or 'gitAccess')")
  id?: string;

  @doc("Principal (User) Identifier.")
  principalId?: string;

  @doc("Determines whether direct access is enabled.")
  enabled?: boolean;
}

@doc("Tenant access information update parameters.")
model AccessInformationCreateParameters {
  @doc("Tenant access information update parameter properties.")
  properties?: AccessInformationCreateParameterProperties;
}

@doc("Tenant access information update parameters of the API Management service")
model AccessInformationCreateParameterProperties {
  @doc("Principal (User) Identifier.")
  principalId?: string;

  @doc("Primary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  primaryKey?: string;

  @doc("Secondary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  secondaryKey?: string;

  @doc("Determines whether direct access is enabled.")
  enabled?: boolean;
}

@doc("Tenant access information update parameters.")
model AccessInformationUpdateParameters {
  @doc("Tenant access information update parameter properties.")
  properties?: AccessInformationUpdateParameterProperties;
}

@doc("Tenant access information update parameters of the API Management service")
model AccessInformationUpdateParameterProperties {
  @doc("Determines whether direct access is enabled.")
  enabled?: boolean;
}

@doc("Tenant access information contract of the API Management service.")
model AccessInformationSecretsContract {
  @doc("Access Information type ('access' or 'gitAccess')")
  id?: string;

  @doc("Principal (User) Identifier.")
  principalId?: string;

  @doc("Primary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  primaryKey?: string;

  @doc("Secondary access key. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.")
  secondaryKey?: string;

  @doc("Determines whether direct access is enabled.")
  enabled?: boolean;
}

@doc("Deploy Tenant Configuration Contract.")
model DeployConfigurationParameters {
  @doc("Deploy Configuration Parameter contract properties.")
  properties?: DeployConfigurationParameterProperties;
}

@doc("Parameters supplied to the Deploy Configuration operation.")
model DeployConfigurationParameterProperties {
  @doc("The name of the Git branch from which the configuration is to be deployed to the configuration database.")
  branch: string;

  @doc("The value enforcing deleting subscriptions to products that are deleted in this update.")
  force?: boolean;
}

@doc("Long Running Git Operation Results.")
model OperationResultContract extends Resource {
  @doc("Properties of the Operation Contract.")
  properties?: OperationResultContractProperties;
}

@doc("Operation Result.")
model OperationResultContractProperties {
  @doc("Operation result identifier.")
  id?: string;

  @doc("Status of an async operation.")
  status?: AsyncOperationStatus;

  @doc("""
Start time of an async operation. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  started?: utcDateTime;

  @doc("""
Last update time of an async operation. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updated?: utcDateTime;

  @doc("Optional result info.")
  resultInfo?: string;

  @doc("Error Body Contract")
  error?: ErrorResponseBody;

  @doc("This property if only provided as part of the TenantConfiguration_Validate operation. It contains the log the entities which will be updated/created/deleted as part of the TenantConfiguration_Deploy operation.")
  @visibility("read")
  actionLog?: OperationResultLogItemContract[];
}

@doc("Log of the entity being created, updated or deleted.")
model OperationResultLogItemContract {
  @doc("The type of entity contract.")
  objectType?: string;

  @doc("Action like create/update/delete.")
  action?: string;

  @doc("Identifier of the entity being created/updated/deleted.")
  objectKey?: string;
}

@doc("Save Tenant Configuration Contract details.")
model SaveConfigurationParameter {
  @doc("Properties of the Save Configuration Parameters.")
  properties?: SaveConfigurationParameterProperties;
}

@doc("Parameters supplied to the Save Tenant Configuration operation.")
model SaveConfigurationParameterProperties {
  @doc("The name of the Git branch in which to commit the current configuration snapshot.")
  branch: string;

  @doc("The value if true, the current configuration database is committed to the Git repository, even if the Git repository has newer changes that would be overwritten.")
  force?: boolean;
}

@doc("Result of Tenant Configuration Sync State.")
model TenantConfigurationSyncStateContract extends Resource {
  @doc("Properties returned Tenant Configuration Sync State check.")
  properties?: TenantConfigurationSyncStateContractProperties;
}

@doc("Tenant Configuration Synchronization State.")
model TenantConfigurationSyncStateContractProperties {
  @doc("The name of Git branch.")
  branch?: string;

  @doc("The latest commit Id.")
  commitId?: string;

  @doc("value indicating if last sync was save (true) or deploy (false) operation.")
  isExport?: boolean;

  @doc("value indicating if last synchronization was later than the configuration change.")
  isSynced?: boolean;

  @doc("value indicating whether Git configuration access is enabled.")
  isGitEnabled?: boolean;

  @doc("""
The date of the latest synchronization. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  syncDate?: utcDateTime;

  @doc("""
The date of the latest configuration change. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  configurationChangeDate?: utcDateTime;

  @doc("Most recent tenant configuration operation identifier")
  lastOperationId?: string;
}

@doc("User create details.")
model UserCreateParameters {
  @doc("User entity create contract properties.")
  properties?: UserCreateParameterProperties;
}

@doc("Parameters supplied to the Create User operation.")
model UserCreateParameterProperties extends UserEntityBaseParameters {
  @doc("Email address. Must not be empty and must be unique within the service instance.")
  @maxLength(254)
  @minLength(1)
  email: string;

  @doc("First name.")
  @maxLength(100)
  @minLength(1)
  firstName: string;

  @doc("Last name.")
  @maxLength(100)
  @minLength(1)
  lastName: string;

  @doc("User Password. If no value is provided, a default password is generated.")
  password?: string;

  @doc("Determines the type of application which send the create user request. Default is legacy portal.")
  appType?: AppType;

  @doc("Determines the type of confirmation e-mail that will be sent to the newly created user.")
  confirmation?: Confirmation;
}

@doc("User update parameters.")
model UserUpdateParameters {
  @doc("User entity update contract properties.")
  properties?: UserUpdateParametersProperties;
}

@doc("Parameters supplied to the Update User operation.")
model UserUpdateParametersProperties extends UserEntityBaseParameters {
  @doc("Email address. Must not be empty and must be unique within the service instance.")
  @maxLength(254)
  @minLength(1)
  email?: string;

  @doc("User Password.")
  password?: string;

  @doc("First name.")
  @maxLength(100)
  @minLength(1)
  firstName?: string;

  @doc("Last name.")
  @maxLength(100)
  @minLength(1)
  lastName?: string;
}

@doc("Generate SSO Url operations response details.")
model GenerateSsoUrlResult {
  @doc("Redirect Url containing the SSO URL value.")
  value?: string;
}

@doc("List of Users Identity list representation.")
model UserIdentityListResult is Azure.Core.Page<UserIdentityContract> {
  @doc("Total record count number across all pages.")
  count?: int64;
}

@doc("Get User Token parameters.")
model UserTokenParameters {
  @doc("User Token Parameter contract properties.")
  properties?: UserTokenParameterProperties;
}

@doc("Parameters supplied to the Get User Token operation.")
model UserTokenParameterProperties {
  @doc("The Key to be used to generate token for user.")
  keyType: KeyType;

  @doc("""
The Expiry time of the Token. Maximum token expiry time is set to 30 days. The date conforms to the following format: `yyyy-MM-ddTHH:mm:ssZ` as specified by the ISO 8601 standard.

""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiry: utcDateTime;
}

@doc("Get User Token response details.")
model UserTokenResult {
  @doc("Shared Access Authorization token for the User.")
  value?: string;
}

@doc("Object used to create an API Revision or Version based on an existing API Revision")
model ApiRevisionInfoContract {
  @doc("Resource identifier of API to be used to create the revision from.")
  sourceApiId?: string;

  @doc("Version identifier for the new API Version.")
  @maxLength(100)
  apiVersionName?: string;

  @doc("Description of new API Revision.")
  @maxLength(256)
  apiRevisionDescription?: string;

  @doc("Version set details")
  apiVersionSet?: ApiVersionSetContractDetails;
}

@doc("Quota counter value details.")
model QuotaCounterValueContract {
  @doc("Quota counter Value Properties.")
  value?: QuotaCounterValueContractProperties;
}
