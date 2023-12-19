import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.AgFoodPlatform;

interface Operations extends Azure.ResourceManager.Operations {}

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
}

enum PublicNetworkAccess {
  Enabled,
  Hybrid,
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

enum CheckNameAvailabilityReason {
  Invalid,
  AlreadyExists,
}

enum Origin {
  user,
  system,
  `user,system`,
}

enum ActionType {
  Internal,
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
}

@doc("FarmBeatsExtension properties.")
model FarmBeatsExtensionProperties {
  @doc("Target ResourceType of the farmBeatsExtension.")
  @visibility("read")
  targetResourceType?: string;

  @doc("FarmBeatsExtension ID.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  farmBeatsExtensionId?: string;

  @doc("FarmBeatsExtension name.")
  @visibility("read")
  @maxLength(100)
  @minLength(2)
  farmBeatsExtensionName?: string;

  @doc("FarmBeatsExtension version.")
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

  @doc("FarmBeatsExtension auth link.")
  @visibility("read")
  extensionAuthLink?: string;

  @doc("FarmBeatsExtension api docs link.")
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

@doc("Model to capture detailed information for farmBeatsExtensions.")
model DetailedInformation {
  @doc("ApiName available for the farmBeatsExtension.")
  apiName?: string;

  @doc("List of customParameters.")
  customParameters?: string[];

  @doc("List of platformParameters.")
  platformParameters?: string[];

  @doc("Unit systems info for the data provider.")
  unitsSupported?: UnitSystemsInfo;

  @doc("List of apiInputParameters.")
  apiInputParameters?: string[];
}

@doc("Unit systems info for the data provider.")
model UnitSystemsInfo {
  @doc("UnitSystem key sent as part of ProviderInput.")
  @maxLength(100)
  @minLength(2)
  key: string;

  @doc("List of unit systems supported by this data provider.")
  values: string[];
}

@doc("Identity for the resource.")
model Identity {
  @doc("The principal ID of resource identity.")
  @visibility("read")
  principalId?: string;

  @doc("The tenant ID of resource.")
  @visibility("read")
  tenantId?: string;

  @doc("The identity type.")
  type?: "SystemAssigned";
}

@doc("FarmBeats ARM Resource properties.")
model FarmBeatsProperties {
  @doc("Uri of the FarmBeats instance.")
  @visibility("read")
  instanceUri?: string;

  @doc("FarmBeats instance provisioning state.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("Sensor integration request model.")
  sensorIntegration?: SensorIntegration;

  @doc("Property to allow or block public traffic for an Azure FarmBeats resource.")
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("The Private Endpoint Connection resource.")
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection;
}

@doc("Sensor integration request model.")
model SensorIntegration {
  @doc("Sensor integration enable state. Allowed values are True, None")
  enabled?: string;

  @doc("Sensor integration instance provisioning state.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("Common error response for all Azure Resource Manager APIs to return error details for failed operations. (This also follows the OData error response format.).")
  provisioningInfo?: ErrorResponse;
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
