import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.AgFoodPlatform;

interface Operations extends Azure.ResourceManager.Operations {}

enum CheckNameAvailabilityReason {
  Invalid,
  AlreadyExists,
}

enum AuthCredentialsKind {
  OAuthClientCredentials,
  ApiKeyAuthCredentials,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum ProvisioningState {
  Creating,
  Updating,
  Deleting,
  Succeeded,
  Failed,
  Running,
}

enum PublicNetworkAccess {
  Enabled,
  Disabled,
}

enum PrivateEndpointServiceConnectionStatus {
  Pending,
  Approved,
  Rejected,
}

enum PrivateEndpointConnectionProvisioningState {
  Succeeded,
  Creating,
  Deleting,
  Failed,
}

enum Origin {
  user,
  system,
  `user,system`,
}

enum ActionType {
  Internal,
}

@doc("The check availability request body.")
model CheckNameAvailabilityRequest {
  @doc("The name of the resource for which availability needs to be checked.")
  name?: string;

  @doc("The resource type.")
  type?: string;
}

@doc("The check availability result.")
model CheckNameAvailabilityResponse {
  @doc("Indicates if the resource name is available.")
  nameAvailable?: boolean;

  @doc("The reason why the given name is not available.")
  reason?: CheckNameAvailabilityReason;

  @doc("Detailed reason why the given name is available.")
  message?: string;
}

@doc("DataConnector Properties.")
model DataConnectorProperties {
  @doc("AuthCredentials abstract base class for Auth Purpose.")
  credentials: AuthCredentials;
}

@doc("AuthCredentials abstract base class for Auth Purpose.")
@discriminator("kind")
model AuthCredentials {}

@doc("Common fields that are returned in the response for all Azure Resource Manager resources")
model Resource {
  @doc("Fully qualified resource ID for the resource. E.g. \"/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}\"")
  @visibility("read")
  id?: string;

  @doc("The name of the resource")
  @visibility("read")
  name?: string;

  @doc("The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\"")
  @visibility("read")
  type?: string;

  @doc("Azure Resource Manager metadata containing createdBy and modifiedBy information.")
  @visibility("read")
  systemData?: SystemData;
}

@doc("DataManagerForAgricultureExtension properties.")
model DataManagerForAgricultureExtensionProperties {
  @doc("Target ResourceType of the Data Manager For Agriculture Extension.")
  @visibility("read")
  targetResourceType?: string;

  @doc("Data Manager For Agriculture Extension ID.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  farmBeatsExtensionId?: string;

  @doc("Data Manager For Agriculture Extension name.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  farmBeatsExtensionName?: string;

  @doc("Data Manager For Agriculture Extension version.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  @pattern("^([1-9]|10).\\d$")
  farmBeatsExtensionVersion?: string;

  @doc("Publisher ID.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  publisherId?: string;

  @doc("Textual description.")
  @visibility("read")
  @maxLength(500)
  @minLength(2)
  description?: string;

  @doc("Category of the extension. e.g. weather/sensor/satellite.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  extensionCategory?: string;

  @doc("Data Manager For Agriculture Extension auth link.")
  @visibility("read")
  extensionAuthLink?: string;

  @doc("Data Manager For Agriculture Extension api docs link.")
  @visibility("read")
  extensionApiDocsLink?: string;

  @doc("""
Detailed information which shows summary of requested data.
Used in descriptive get extension metadata call.
Information for weather category per api included are apisSupported,
customParameters, PlatformParameters and Units supported.
""")
  @visibility("read")
  detailedInformation?: DetailedInformation[];
}

@doc("Model to capture detailed information for Data Manager For AgricultureExtensions.")
model DetailedInformation {
  @doc("ApiName available for the Data Manager For Agriculture Extension.")
  apiName?: string;

  @doc("Extension provider's API documentation link.")
  apiDocsLink?: string;

  @doc("Type of Api in Extension.")
  apiType?: string;

  @doc("List of customParameters.")
  customParameters?: string[];

  @doc("List of platformParameters.")
  platformParameters?: string[];

  @doc("List of defaultParameters.")
  apiDefaultInputParameters?: string[];

  @doc("Unit systems info for the data provider.")
  unitsSupported?: UnitSystemsInfo;

  @doc("List of apiInputParameters.")
  apiInputParameters?: string[];
}

@doc("Unit systems info for the data provider.")
model UnitSystemsInfo {
  @doc("UnitSystem key sent as part of ProviderInput.")
  @maxLength(100)
  @minLength(1)
  key: string;

  @doc("List of unit systems supported by this data provider.")
  values: string[];
}

@doc("Identity for the resource.")
model Identity {
  @doc("The principal ID of resource identity. The value must be an UUID.")
  @visibility("read")
  principalId?: string;

  @doc("The tenant ID of resource. The value must be an UUID.")
  @visibility("read")
  tenantId?: string;

  @doc("The identity type.")
  type?: "SystemAssigned";
}

@doc("Data Manager For Agriculture ARM Resource properties.")
model DataManagerForAgricultureProperties {
  @doc("Uri of the Data Manager For Agriculture instance.")
  @visibility("read")
  instanceUri?: string;

  @doc("Data Manager For Agriculture instance provisioning state.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("Sensor integration request model.")
  sensorIntegration?: SensorIntegration;

  @doc("Property to allow or block public traffic for an Azure Data Manager For Agriculture resource.")
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("Private endpoints.")
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];
}

@doc("Sensor integration request model.")
model SensorIntegration {
  @doc("Sensor integration enable state.")
  enabled?: string;

  @doc("Sensor integration instance provisioning state.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("Common error response for all Azure Resource Manager APIs to return error details for failed operations. (This also follows the OData error response format.).")
  provisioningInfo?: ErrorResponse;
}

@doc("Properties of the private endpoint connection.")
model PrivateEndpointConnectionProperties {
  @doc("The group ids for the private endpoint resource.")
  @visibility("read")
  groupIds?: string[];

  @doc("The private endpoint resource.")
  privateEndpoint?: PrivateEndpoint;

  @doc("A collection of information about the state of the connection between service consumer and provider.")
  privateLinkServiceConnectionState: PrivateLinkServiceConnectionState;

  @doc("The provisioning state of the private endpoint connection resource.")
  @visibility("read")
  provisioningState?: PrivateEndpointConnectionProvisioningState;
}

@doc("The private endpoint resource.")
model PrivateEndpoint {
  @doc("The ARM identifier for private endpoint.")
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

@doc("""
Arm async operation class.
Ref: https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/async-operations.
""")
model ArmAsyncOperation {
  @doc("Status of the async operation.")
  status?: string;

  @doc("""
Arm async operation error class.
Ref: https://github.com/Azure/azure-resource-manager-rpc/blob/master/v1.0/async-api-reference.md#azure-asyncoperation-resource-format.
""")
  error?: ArmAsyncOperationError;
}

@doc("""
Arm async operation error class.
Ref: https://github.com/Azure/azure-resource-manager-rpc/blob/master/v1.0/async-api-reference.md#azure-asyncoperation-resource-format.
""")
model ArmAsyncOperationError {
  @doc("Status of the async operation.")
  code?: string;

  @doc("Status of the async operation.")
  message?: string;
}

@doc("Extension Installation Request Body.")
model ExtensionInstallationRequest {
  @doc("Extension Version.")
  @maxLength(10)
  @minLength(3)
  extensionVersion?: string;

  @doc("Additional Api Properties.")
  additionalApiProperties?: Record<ApiProperties>;
}

@doc("Api properties.")
model ApiProperties {
  @doc("Interval in minutes for which the weather data for the api needs to be refreshed.")
  @maxValue(10080)
  apiFreshnessTimeInMinutes?: int32;
}

@doc("Extension resource properties.")
model ExtensionProperties {
  @doc("Extension Id.")
  @visibility("read")
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  extensionId?: string;

  @doc("Extension category. e.g. weather/sensor/satellite.")
  @visibility("read")
  extensionCategory?: string;

  @doc("Installed extension version.")
  @visibility("read")
  @pattern("^([1-9]|10).\\d$")
  installedExtensionVersion?: string;

  @doc("Extension auth link.")
  @visibility("read")
  extensionAuthLink?: string;

  @doc("Extension api docs link.")
  @visibility("read")
  extensionApiDocsLink?: string;

  @doc("Additional Api Properties.")
  @visibility("read")
  additionalApiProperties?: Record<ApiProperties>;
}

@doc("Properties of a private link resource.")
model PrivateLinkResourceProperties {
  @doc("The private link resource group id.")
  @visibility("read")
  groupId?: string;

  @doc("The private link resource required member names.")
  @visibility("read")
  requiredMembers?: string[];

  @doc("The private link resource private link DNS zone name.")
  requiredZoneNames?: string[];
}

@doc("Solution resource properties.")
model SolutionProperties extends Record<unknown> {
  @doc("Partner Id of the Solution.")
  @visibility("read")
  partnerId?: string;

  @doc("SaaS subscriptionId of the installed SaaS application.")
  @minLength(1)
  saasSubscriptionId: string;

  @doc("SaaS subscription name of the installed SaaS application.")
  @minLength(1)
  saasSubscriptionName: string;

  @doc("SaaS application Marketplace Publisher Id.")
  @minLength(1)
  marketplacePublisherId: string;

  @doc("SaaS application Plan Id.")
  @minLength(1)
  planId: string;

  @doc("Role Assignment Id.")
  roleAssignmentId?: string;

  @doc("SaaS application Offer Id.")
  @minLength(1)
  offerId: string;

  @doc("SaaS application Term Id.")
  @minLength(1)
  termId: string;
}

@doc("DataManagerForAgricultureSolution properties.")
model DataManagerForAgricultureSolutionProperties {
  @doc("Solution Partner Id.")
  @visibility("read")
  partnerId?: string;

  @doc("Solution Partner Tenant Id.")
  @visibility("read")
  partnerTenantId?: string;

  @doc("""
Gets scope of the Data manager For Agriculture data access that's required for processing solution request to partner.
Example: For gdd they might need weatherScope and satelliteScope.
""")
  @visibility("read")
  dataAccessScopes?: string[];

  marketplaceOfferDetails?: MarketplaceOfferDetails;

  @doc("Gets api-version Swagger Document Dictionary to capture all api-versions of swagger exposed by partner to Data Manager For Agriculture.")
  @visibility("read")
  openApiSpecsDictionary?: Record<unknown>;

  @doc("Application id of the multi tenant application to be used by partner to access Data Manager For Agriculture data.")
  @visibility("read")
  accessFBApplicationId?: string;

  @doc("Application id of the SaaS multi tenant application.")
  @visibility("read")
  saaSApplicationId?: string;

  @doc("List of ActionIds needed to make the SaaS multi tenant application access relevant fb data.")
  @visibility("read")
  actionIds?: string[];

  @doc("Role Id of the SaaS multi tenant application to access relevant fb data.")
  @visibility("read")
  roleId?: string;

  @doc("Role Name of the SaaS multi tenant application to access relevant fb data.")
  @visibility("read")
  roleName?: string;

  @doc("Application name of the multi tenant application to be used by partner to access Data Manager For Agriculture Data.")
  @visibility("read")
  accessFBApplicationName?: string;
}

model MarketplaceOfferDetails {
  saasOfferId?: string;
  publisherId?: string;
}

@doc("ApiKeyAuthCredentials class for ApiKey based Auth.")
model ApiKeyAuthCredentials extends AuthCredentials {
  @doc("Properties of the key vault.")
  apiKey: KeyVaultProperties;

  @doc("Enum for different types of AuthCredentials supported.")
  kind: "ApiKeyAuthCredentials";
}

@doc("Properties of the key vault.")
model KeyVaultProperties {
  @doc("Uri of the key vault.")
  @minLength(1)
  keyVaultUri: string;

  @doc("Name of Key Vault key.")
  @minLength(1)
  keyName: string;

  @doc("Version of Key Vault key.")
  @minLength(1)
  keyVersion: string;
}

@doc("OAuthClientCredentials for clientId clientSecret auth.")
model OAuthClientCredentials extends AuthCredentials {
  @doc("ClientId associated with the provider.")
  @minLength(1)
  clientId: string;

  @doc("Properties of the key vault.")
  clientSecret: KeyVaultProperties;

  @doc("Enum for different types of AuthCredentials supported.")
  kind: "OAuthClientCredentials";
}
