import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.AgFoodPlatform;

/**
 * The reason why the given name is not available.
 */
union CheckNameAvailabilityReason {
  string,

  /**
   * Invalid
   */
  Invalid: "Invalid",

  /**
   * AlreadyExists
   */
  AlreadyExists: "AlreadyExists",
}

/**
 * Enum for different types of AuthCredentials supported.
 */
union AuthCredentialsKind {
  string,

  /**
   * OAuthClientCredentials
   */
  OAuthClientCredentials: "OAuthClientCredentials",

  /**
   * ApiKeyAuthCredentials
   */
  ApiKeyAuthCredentials: "ApiKeyAuthCredentials",
}

/**
 * The type of identity that created the resource.
 */
union CreatedByType {
  string,

  /**
   * User
   */
  User: "User",

  /**
   * Application
   */
  Application: "Application",

  /**
   * ManagedIdentity
   */
  ManagedIdentity: "ManagedIdentity",

  /**
   * Key
   */
  Key: "Key",
}

/**
 * Data Manager For Agriculture instance provisioning state.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
union ProvisioningState {
  string,

  /**
   * Creating
   */
  Creating: "Creating",

  /**
   * Updating
   */
  Updating: "Updating",

  /**
   * Deleting
   */
  Deleting: "Deleting",

  /**
   * Succeeded
   */
  Succeeded: "Succeeded",

  /**
   * Failed
   */
  Failed: "Failed",

  /**
   * Running
   */
  Running: "Running",
}

/**
 * Property to allow or block public traffic for an Azure Data Manager For Agriculture resource.
 */
union PublicNetworkAccess {
  string,

  /**
   * Enabled
   */
  Enabled: "Enabled",

  /**
   * Disabled
   */
  Disabled: "Disabled",
}

/**
 * The intended executor of the operation; as in Resource Based Access Control (RBAC) and audit logs UX. Default value is "user,system"
 */
union Origin {
  string,

  /**
   * user
   */
  user: "user",

  /**
   * system
   */
  system: "system",

  /**
   * user,system
   */
  `user,system`: "user,system",
}

/**
 * Enum. Indicates the action type. "Internal" refers to actions that are for internal only APIs.
 */
union ActionType {
  string,

  /**
   * Internal
   */
  Internal: "Internal",
}

/**
 * DataConnector Properties.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
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
model AuthCredentials {
  /**
   * Enum for different types of AuthCredentials supported.
   */
  kind: AuthCredentialsKind;
}

/**
 * Paged response contains list of requested objects and a URL link to get the next set of results.
 */
model DataConnectorListResponse is Azure.Core.Page<DataConnector>;

/**
 * Paged response contains list of requested objects and a URL link to get the next set of results.
 */
model DataManagerForAgricultureExtensionListResponse
  is Azure.Core.Page<DataManagerForAgricultureExtension> {
  /**
   * Token used in retrieving the next page. If null, there are no additional pages.
   */
  $skipToken?: string;
}

/**
 * DataManagerForAgricultureExtension properties.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model DataManagerForAgricultureExtensionProperties {
  /**
   * Target ResourceType of the Data Manager For Agriculture Extension.
   */
  @visibility(Lifecycle.Read)
  targetResourceType?: string;

  /**
   * Data Manager For Agriculture Extension ID.
   */
  @visibility(Lifecycle.Read)
  @maxLength(100)
  @minLength(2)
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  farmBeatsExtensionId?: string;

  /**
   * Data Manager For Agriculture Extension name.
   */
  @visibility(Lifecycle.Read)
  @maxLength(100)
  @minLength(2)
  farmBeatsExtensionName?: string;

  /**
   * Data Manager For Agriculture Extension version.
   */
  @visibility(Lifecycle.Read)
  @maxLength(100)
  @minLength(2)
  @pattern("^([1-9]|10).\\d$")
  farmBeatsExtensionVersion?: string;

  /**
   * Publisher ID.
   */
  @visibility(Lifecycle.Read)
  @maxLength(100)
  @minLength(2)
  publisherId?: string;

  /**
   * Textual description.
   */
  @visibility(Lifecycle.Read)
  @maxLength(500)
  @minLength(2)
  description?: string;

  /**
   * Category of the extension. e.g. weather/sensor/satellite.
   */
  @visibility(Lifecycle.Read)
  @maxLength(100)
  @minLength(2)
  extensionCategory?: string;

  /**
   * Data Manager For Agriculture Extension auth link.
   */
  @visibility(Lifecycle.Read)
  extensionAuthLink?: string;

  /**
   * Data Manager For Agriculture Extension api docs link.
   */
  @visibility(Lifecycle.Read)
  extensionApiDocsLink?: string;

  /**
   * Detailed information which shows summary of requested data.
   * Used in descriptive get extension metadata call.
   * Information for weather category per api included are apisSupported,
   * customParameters, PlatformParameters and Units supported.
   */
  @visibility(Lifecycle.Read)
  @identifiers(#[])
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
 * Data Manager For Agriculture ARM Resource properties.
 */
model DataManagerForAgricultureProperties {
  /**
   * Uri of the Data Manager For Agriculture instance.
   */
  @visibility(Lifecycle.Read)
  instanceUri?: url;

  /**
   * Data Manager For Agriculture instance provisioning state.
   */
  @visibility(Lifecycle.Read)
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
  @visibility(Lifecycle.Read)
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
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * Common error response for all Azure Resource Manager APIs to return error details for failed operations. (This also follows the OData error response format.).
   */
  provisioningInfo?: Azure.ResourceManager.CommonTypes.ErrorResponse;
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
  identity?: Azure.ResourceManager.CommonTypes.Identity;

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
 * Paged response contains list of requested objects and a URL link to get the next set of results.
 */
model DataManagerForAgricultureListResponse
  is Azure.Core.Page<DataManagerForAgriculture> {
  /**
   * Token used in retrieving the next page. If null, there are no additional pages.
   */
  $skipToken?: string;
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
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model ExtensionProperties {
  /**
   * Extension Id.
   */
  @visibility(Lifecycle.Read)
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  extensionId?: string;

  /**
   * Extension category. e.g. weather/sensor/satellite.
   */
  @visibility(Lifecycle.Read)
  extensionCategory?: string;

  /**
   * Installed extension version.
   */
  @visibility(Lifecycle.Read)
  @pattern("^([1-9]|10).\\d$")
  installedExtensionVersion?: string;

  /**
   * Extension auth link.
   */
  @visibility(Lifecycle.Read)
  extensionAuthLink?: string;

  /**
   * Extension api docs link.
   */
  @visibility(Lifecycle.Read)
  extensionApiDocsLink?: string;

  /**
   * Additional Api Properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility(Lifecycle.Read)
  additionalApiProperties?: Record<ApiProperties>;
}

/**
 * Paged response contains list of requested objects and a URL link to get the next set of results.
 */
model ExtensionListResponse is Azure.Core.Page<Extension> {
  /**
   * Token used in retrieving the next page. If null, there are no additional pages.
   */
  $skipToken?: string;
}

/**
 * Localized display information for this particular operation.
 */
model OperationDisplay {
  /**
   * The localized friendly form of the resource provider name, e.g. "Microsoft Monitoring Insights" or "Microsoft Compute".
   */
  @visibility(Lifecycle.Read)
  provider?: string;

  /**
   * The localized friendly name of the resource type related to this operation. E.g. "Virtual Machines" or "Job Schedule Collections".
   */
  @visibility(Lifecycle.Read)
  resource?: string;

  /**
   * The concise, localized friendly name for the operation; suitable for dropdowns. E.g. "Create or Update Virtual Machine", "Restart Virtual Machine".
   */
  @visibility(Lifecycle.Read)
  operation?: string;

  /**
   * The short, localized friendly description of the operation; suitable for tool tips and detailed views.
   */
  @visibility(Lifecycle.Read)
  description?: string;
}

/**
 * Solution resource properties.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model SolutionProperties {
  ...Record<unknown>;

  /**
   * Partner Id of the Solution.
   */
  @visibility(Lifecycle.Read)
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
 * Paged response contains list of requested objects and a URL link to get the next set of results.
 */
model SolutionListResponse is Azure.Core.Page<Solution> {
  /**
   * Token used in retrieving the next page. If null, there are no additional pages.
   */
  $skipToken?: string;
}

/**
 * Paged response contains list of requested objects and a URL link to get the next set of results.
 */
model DataManagerForAgricultureSolutionListResponse
  is Azure.Core.Page<DataManagerForAgricultureSolution> {
  /**
   * Token used in retrieving the next page. If null, there are no additional pages.
   */
  $skipToken?: string;
}

/**
 * DataManagerForAgricultureSolution properties.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model DataManagerForAgricultureSolutionProperties {
  /**
   * Solution Partner Id.
   */
  @visibility(Lifecycle.Read)
  partnerId?: string;

  /**
   * Solution Partner Tenant Id.
   */
  @visibility(Lifecycle.Read)
  partnerTenantId?: string;

  /**
   * Gets scope of the Data manager For Agriculture data access that's required for processing solution request to partner.
   * Example: For gdd they might need weatherScope and satelliteScope.
   */
  @visibility(Lifecycle.Read)
  dataAccessScopes?: string[];

  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  marketplaceOfferDetails?: MarketplaceOfferDetails;

  /**
   * Gets api-version Swagger Document Dictionary to capture all api-versions of swagger exposed by partner to Data Manager For Agriculture.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility(Lifecycle.Read)
  openApiSpecsDictionary?: Record<unknown>;

  /**
   * Application id of the multi tenant application to be used by partner to access Data Manager For Agriculture data.
   */
  #suppress "@azure-tools/typespec-azure-core/no-format"
  @visibility(Lifecycle.Read)
  @format("uuid")
  accessFBApplicationId?: string;

  /**
   * Application id of the SaaS multi tenant application.
   */
  @visibility(Lifecycle.Read)
  saaSApplicationId?: string;

  /**
   * List of ActionIds needed to make the SaaS multi tenant application access relevant fb data.
   */
  @visibility(Lifecycle.Read)
  actionIds?: string[];

  /**
   * Role Id of the SaaS multi tenant application to access relevant fb data.
   */
  @visibility(Lifecycle.Read)
  roleId?: string;

  /**
   * Role Name of the SaaS multi tenant application to access relevant fb data.
   */
  @visibility(Lifecycle.Read)
  roleName?: string;

  /**
   * Application name of the multi tenant application to be used by partner to access Data Manager For Agriculture Data.
   */
  @visibility(Lifecycle.Read)
  accessFBApplicationName?: string;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model MarketplaceOfferDetails {
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  saasOfferId?: string;
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
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
