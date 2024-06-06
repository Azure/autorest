import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.AgFoodPlatform;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * Enum for different types of AuthCredentials supported.
 */
union AuthCredentialsKind {
  string,
  OAuthClientCredentials: "OAuthClientCredentials",
  ApiKeyAuthCredentials: "ApiKeyAuthCredentials",
}

/**
 * Data Manager For Agriculture instance provisioning state.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
union ProvisioningState {
  string,
  Creating: "Creating",
  Updating: "Updating",
  Deleting: "Deleting",
  Succeeded: "Succeeded",
  Failed: "Failed",
  Running: "Running",
}

/**
 * Property to allow or block public traffic for an Azure Data Manager For Agriculture resource.
 */
union PublicNetworkAccess {
  string,
  Enabled: "Enabled",
  Disabled: "Disabled",
}

/**
 * The private endpoint connection status.
 */
union PrivateEndpointServiceConnectionStatus {
  string,
  Pending: "Pending",
  Approved: "Approved",
  Rejected: "Rejected",
}

/**
 * The current provisioning state.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
union PrivateEndpointConnectionProvisioningState {
  string,
  Succeeded: "Succeeded",
  Creating: "Creating",
  Deleting: "Deleting",
  Failed: "Failed",
}

/**
 * The check availability request body.
 */
model CheckNameAvailabilityRequest {
  /**
   * The name of the resource for which availability needs to be checked.
   */
  name?: string;

  /**
   * The resource type.
   */
  type?: string;
}

/**
 * The check availability result.
 */
model CheckNameAvailabilityResponse {
  /**
   * Indicates if the resource name is available.
   */
  nameAvailable?: boolean;

  /**
   * The reason why the given name is not available.
   */
  reason?: CheckNameAvailabilityReason;

  /**
   * Detailed reason why the given name is available.
   */
  message?: string;
}

/**
 * DataConnector Properties.
 */
model DataConnectorProperties {
  /**
   * AuthCredentials abstract base class for Auth Purpose.
   */
  credentials: AuthCredentials;
}

/**
 * AuthCredentials abstract base class for Auth Purpose.
 */
@discriminator("kind")
model AuthCredentials {}

/**
 * Common fields that are returned in the response for all Azure Resource Manager resources
 */
model Resource {
  /**
   * Fully qualified resource ID for the resource. E.g. "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}"
   */
  @visibility("read")
  id?: Azure.Core.armResourceIdentifier;

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

  /**
   * Azure Resource Manager metadata containing createdBy and modifiedBy information.
   */
  @visibility("read")
  systemData?: SystemData;
}

/**
 * DataManagerForAgricultureExtension properties.
 */
model DataManagerForAgricultureExtensionProperties {
  /**
   * Target ResourceType of the Data Manager For Agriculture Extension.
   */
  @visibility("read")
  targetResourceType?: string;

  /**
   * Data Manager For Agriculture Extension ID.
   */
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  farmBeatsExtensionId?: string;

  /**
   * Data Manager For Agriculture Extension name.
   */
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  farmBeatsExtensionName?: string;

  /**
   * Data Manager For Agriculture Extension version.
   */
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  @pattern("^([1-9]|10).\\d$")
  farmBeatsExtensionVersion?: string;

  /**
   * Publisher ID.
   */
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  publisherId?: string;

  /**
   * Textual description.
   */
  @visibility("read")
  @maxLength(500)
  @minLength(2)
  description?: string;

  /**
   * Category of the extension. e.g. weather/sensor/satellite.
   */
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  extensionCategory?: string;

  /**
   * Data Manager For Agriculture Extension auth link.
   */
  @visibility("read")
  extensionAuthLink?: string;

  /**
   * Data Manager For Agriculture Extension api docs link.
   */
  @visibility("read")
  extensionApiDocsLink?: string;

  /**
   * Detailed information which shows summary of requested data.
   * Used in descriptive get extension metadata call.
   * Information for weather category per api included are apisSupported,
   * customParameters, PlatformParameters and Units supported.
   */
  @visibility("read")
  @OpenAPI.extension("x-ms-identifiers", [])
  detailedInformation?: DetailedInformation[];
}

/**
 * Model to capture detailed information for Data Manager For AgricultureExtensions.
 */
model DetailedInformation {
  /**
   * ApiName available for the Data Manager For Agriculture Extension.
   */
  apiName?: string;

  /**
   * Extension provider's API documentation link.
   */
  apiDocsLink?: string;

  /**
   * Type of Api in Extension.
   */
  apiType?: string;

  /**
   * List of customParameters.
   */
  customParameters?: string[];

  /**
   * List of platformParameters.
   */
  platformParameters?: string[];

  /**
   * List of defaultParameters.
   */
  apiDefaultInputParameters?: string[];

  /**
   * Unit systems info for the data provider.
   */
  unitsSupported?: UnitSystemsInfo;

  /**
   * List of apiInputParameters.
   */
  apiInputParameters?: string[];
}

/**
 * Unit systems info for the data provider.
 */
model UnitSystemsInfo {
  /**
   * UnitSystem key sent as part of ProviderInput.
   */
  @maxLength(100)
  @minLength(1)
  key: string;

  /**
   * List of unit systems supported by this data provider.
   */
  values: string[];
}

/**
 * Identity for the resource.
 */
model Identity {
  /**
   * The principal ID of resource identity. The value must be an UUID.
   */
  @visibility("read")
  principalId?: string;

  /**
   * The tenant ID of resource. The value must be an UUID.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * The identity type.
   */
  type?: "SystemAssigned";
}

/**
 * Data Manager For Agriculture ARM Resource properties.
 */
model DataManagerForAgricultureProperties {
  /**
   * Uri of the Data Manager For Agriculture instance.
   */
  @visibility("read")
  instanceUri?: url;

  /**
   * Data Manager For Agriculture instance provisioning state.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Sensor integration request model.
   */
  sensorIntegration?: SensorIntegration;

  /**
   * Property to allow or block public traffic for an Azure Data Manager For Agriculture resource.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * Private endpoints.
   */
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];
}

/**
 * Sensor integration request model.
 */
model SensorIntegration {
  /**
   * Sensor integration enable state.
   */
  enabled?: string;

  /**
   * Sensor integration instance provisioning state.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Common error response for all Azure Resource Manager APIs to return error details for failed operations. (This also follows the OData error response format.).
   */
  provisioningInfo?: ErrorResponse;
}

/**
 * Properties of the private endpoint connection.
 */
model PrivateEndpointConnectionProperties {
  /**
   * The group ids for the private endpoint resource.
   */
  @visibility("read")
  groupIds?: string[];

  /**
   * The private endpoint resource.
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
 * The private endpoint resource.
 */
model PrivateEndpoint {
  /**
   * The ARM identifier for private endpoint.
   */
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
 * DataManagerForAgriculture update request.
 */
model DataManagerForAgricultureUpdateRequestModel {
  /**
   * Geo-location where the resource lives.
   */
  location?: string;

  /**
   * Identity for the resource.
   */
  identity?: Identity;

  /**
   * Data Manager For Agriculture ARM Resource properties.
   */
  properties?: DataManagerForAgricultureUpdateProperties;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Data Manager For Agriculture ARM Resource properties.
 */
model DataManagerForAgricultureUpdateProperties {
  /**
   * Sensor integration request model.
   */
  sensorIntegration?: SensorIntegration;

  /**
   * Property to allow or block public traffic for an Azure Data Manager For Agriculture resource.
   */
  publicNetworkAccess?: PublicNetworkAccess;
}

/**
 * Arm async operation class.
 * Ref: https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/async-operations.
 */
model ArmAsyncOperation {
  /**
   * Status of the async operation.
   */
  status?: string;

  /**
   * Arm async operation error class.
   * Ref: https://github.com/Azure/azure-resource-manager-rpc/blob/master/v1.0/async-api-reference.md#azure-asyncoperation-resource-format.
   */
  error?: ArmAsyncOperationError;
}

/**
 * Arm async operation error class.
 * Ref: https://github.com/Azure/azure-resource-manager-rpc/blob/master/v1.0/async-api-reference.md#azure-asyncoperation-resource-format.
 */
model ArmAsyncOperationError {
  /**
   * Status of the async operation.
   */
  code?: string;

  /**
   * Status of the async operation.
   */
  message?: string;
}

/**
 * Extension Installation Request Body.
 */
model ExtensionInstallationRequest {
  /**
   * Extension Version.
   */
  @maxLength(10)
  @minLength(3)
  extensionVersion?: string;

  /**
   * Additional Api Properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  additionalApiProperties?: Record<ApiProperties>;
}

/**
 * Api properties.
 */
model ApiProperties {
  /**
   * Interval in minutes for which the weather data for the api needs to be refreshed.
   */
  @maxValue(10080)
  apiFreshnessTimeInMinutes?: int32;
}

/**
 * Extension resource properties.
 */
model ExtensionProperties {
  /**
   * Extension Id.
   */
  @visibility("read")
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  extensionId?: string;

  /**
   * Extension category. e.g. weather/sensor/satellite.
   */
  @visibility("read")
  extensionCategory?: string;

  /**
   * Installed extension version.
   */
  @visibility("read")
  @pattern("^([1-9]|10).\\d$")
  installedExtensionVersion?: string;

  /**
   * Extension auth link.
   */
  @visibility("read")
  extensionAuthLink?: string;

  /**
   * Extension api docs link.
   */
  @visibility("read")
  extensionApiDocsLink?: string;

  /**
   * Additional Api Properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read")
  additionalApiProperties?: Record<ApiProperties>;
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
   * The private link resource private link DNS zone name.
   */
  requiredZoneNames?: string[];
}

/**
 * Solution resource properties.
 */
model SolutionProperties {
  ...Record<unknown>;

  /**
   * Partner Id of the Solution.
   */
  @visibility("read")
  partnerId?: string;

  /**
   * SaaS subscriptionId of the installed SaaS application.
   */
  @minLength(1)
  saasSubscriptionId: string;

  /**
   * SaaS subscription name of the installed SaaS application.
   */
  @minLength(1)
  saasSubscriptionName: string;

  /**
   * SaaS application Marketplace Publisher Id.
   */
  @minLength(1)
  marketplacePublisherId: string;

  /**
   * SaaS application Plan Id.
   */
  @minLength(1)
  planId: string;

  /**
   * Role Assignment Id.
   */
  roleAssignmentId?: string;

  /**
   * SaaS application Offer Id.
   */
  @minLength(1)
  offerId: string;

  /**
   * SaaS application Term Id.
   */
  @minLength(1)
  termId: string;
}

/**
 * DataManagerForAgricultureSolution properties.
 */
model DataManagerForAgricultureSolutionProperties {
  /**
   * Solution Partner Id.
   */
  @visibility("read")
  partnerId?: string;

  /**
   * Solution Partner Tenant Id.
   */
  @visibility("read")
  partnerTenantId?: string;

  /**
   * Gets scope of the Data manager For Agriculture data access that's required for processing solution request to partner.
   * Example: For gdd they might need weatherScope and satelliteScope.
   */
  @visibility("read")
  dataAccessScopes?: string[];

  marketplaceOfferDetails?: MarketplaceOfferDetails;

  /**
   * Gets api-version Swagger Document Dictionary to capture all api-versions of swagger exposed by partner to Data Manager For Agriculture.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read")
  openApiSpecsDictionary?: Record<unknown>;

  /**
   * Application id of the multi tenant application to be used by partner to access Data Manager For Agriculture data.
   */
  @visibility("read")
  accessFBApplicationId?: string;

  /**
   * Application id of the SaaS multi tenant application.
   */
  @visibility("read")
  saaSApplicationId?: string;

  /**
   * List of ActionIds needed to make the SaaS multi tenant application access relevant fb data.
   */
  @visibility("read")
  actionIds?: string[];

  /**
   * Role Id of the SaaS multi tenant application to access relevant fb data.
   */
  @visibility("read")
  roleId?: string;

  /**
   * Role Name of the SaaS multi tenant application to access relevant fb data.
   */
  @visibility("read")
  roleName?: string;

  /**
   * Application name of the multi tenant application to be used by partner to access Data Manager For Agriculture Data.
   */
  @visibility("read")
  accessFBApplicationName?: string;
}

model MarketplaceOfferDetails {
  saasOfferId?: string;
  publisherId?: string;
}

/**
 * ApiKeyAuthCredentials class for ApiKey based Auth.
 */
model ApiKeyAuthCredentials extends AuthCredentials {
  /**
   * Properties of the key vault.
   */
  apiKey: KeyVaultProperties;

  /**
   * Enum for different types of AuthCredentials supported.
   */
  kind: "ApiKeyAuthCredentials";
}

/**
 * Properties of the key vault.
 */
model KeyVaultProperties {
  /**
   * Uri of the key vault.
   */
  @minLength(1)
  keyVaultUri: string;

  /**
   * Name of Key Vault key.
   */
  @minLength(1)
  keyName: string;

  /**
   * Version of Key Vault key.
   */
  @minLength(1)
  keyVersion: string;
}

/**
 * OAuthClientCredentials for clientId clientSecret auth.
 */
model OAuthClientCredentials extends AuthCredentials {
  /**
   * ClientId associated with the provider.
   */
  @minLength(1)
  clientId: string;

  /**
   * Properties of the key vault.
   */
  clientSecret: KeyVaultProperties;

  /**
   * Enum for different types of AuthCredentials supported.
   */
  kind: "OAuthClientCredentials";
}
