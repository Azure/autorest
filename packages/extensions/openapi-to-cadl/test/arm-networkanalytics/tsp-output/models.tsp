import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.ResourceManager.NetworkAnalytics;

interface Operations extends Azure.ResourceManager.Operations {}

enum Origin {
  user,
  system,
  `user,system`,
}

enum ActionType {
  Internal,
}

enum ProvisioningState {
  @doc("Represents a succeeded operation.") Succeeded,
  @doc("Represents a failed operation.") Failed,
  @doc("Represents a canceled operation.") Canceled,
  @doc("Represents a pending operation.") Provisioning,
  @doc("Represents a pending operation.") Updating,
  @doc("Represents an operation under deletion.") Deleting,
  @doc("Represents an accepted operation.") Accepted,
}

enum ControlState {
  @doc("Field to enable a setting.") Enabled,
  @doc("Field to disable a setting.") Disabled,
}

enum DefaultAction {
  @doc("Represents allow action.") Allow,
  @doc("Represents deny action.") Deny,
}

enum ManagedServiceIdentityType {
  None,
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum DataProductUserRole {
  @doc("Field to specify user of type Reader.") Reader,
  @doc("""
Field to specify user of type SensitiveReader.
This user has privileged access
to read sensitive data of a data product.
""")
  SensitiveReader,
}

enum DataTypeState {
  @doc("Field to specify stopped state.") Stopped,
  @doc("Field to specify running state.") Running,
}

enum Bypass {
  @doc("Represents no bypassing of traffic.") None,
  @doc("Represents bypassing logging traffic.") Logging,
  @doc("Represents bypassing metrics traffic.") Metrics,
  @doc("Represents bypassing azure services traffic.") AzureServices,
}

enum Versions {
  @doc("The 2023-11-15 stable version.") v2023_11_15: "2023-11-15",
}

@doc("The data product properties.")
model DataProductProperties {
  @doc("The resource GUID property of the data product resource.")
  @visibility("read")
  resourceGuid?: string;

  @doc("Latest provisioning state  of data product.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("Data product publisher name.")
  @visibility("read", "create")
  publisher: string;

  @doc("Product name of data product.")
  @visibility("read", "create")
  product: string;

  @doc("Major version of data product.")
  @visibility("read", "create")
  majorVersion: string;

  @doc("List of name or email associated with data product resource deployment.")
  @visibility("read", "create", "update")
  owners?: string[];

  @doc("Flag to enable or disable redundancy for data product.")
  @visibility("read", "create")
  redundancy?: ControlState;

  @doc("Purview account url for data product to connect to.")
  @visibility("read", "create", "update")
  purviewAccount?: string;

  @doc("Purview collection url for data product to connect to.")
  @visibility("read", "create", "update")
  purviewCollection?: string;

  @doc("Flag to enable or disable private link for data product resource.")
  @visibility("read", "create", "update")
  privateLinksEnabled?: ControlState;

  @doc("Flag to enable or disable public access of data product resource.")
  @visibility("read", "create")
  publicNetworkAccess?: ControlState;

  @doc("Flag to enable customer managed key encryption for data product.")
  @visibility("read", "create")
  customerManagedKeyEncryptionEnabled?: ControlState;

  @doc("Customer managed encryption key details for data product.")
  @visibility("read", "create")
  customerEncryptionKey?: EncryptionKeyDetails;

  @doc("Network rule set for data product.")
  @visibility("read", "create")
  networkacls?: DataProductNetworkAcls;

  @doc("Managed resource group configuration.")
  @visibility("create")
  managedResourceGroupConfiguration?: ManagedResourceGroupConfiguration;

  @doc("List of available minor versions of the data product resource.")
  @visibility("read")
  availableMinorVersions?: string[];

  @doc("Current configured minor version of the data product resource.")
  @visibility("read", "update")
  currentMinorVersion?: string;

  @doc("Documentation link for the data product based on definition file.")
  @visibility("read")
  documentation?: string;

  @doc("Resource links which exposed to the customer to query the data.")
  @visibility("read")
  consumptionEndpoints?: ConsumptionEndpointsProperties;

  @doc("Key vault url.")
  @visibility("read")
  keyVaultUrl?: string;
}

@doc("Encryption key details.")
model EncryptionKeyDetails {
  @doc("The Uri of the key vault.")
  keyVaultUri: string;

  @doc("The name of the key vault key.")
  keyName: string;

  @doc("The version of the key vault key.")
  keyVersion: string;
}

@doc("Data Product Network rule set")
model DataProductNetworkAcls {
  @doc("Virtual Network Rule")
  virtualNetworkRule: VirtualNetworkRule[];

  @doc("IP rule with specific IP or IP range in CIDR format.")
  ipRules: IPRules[];

  @doc("""
The list of query ips in the format of CIDR allowed to connect to
query/visualization endpoint.
""")
  allowedQueryIpRangeList: string[];

  @doc("Default Action")
  defaultAction: DefaultAction;
}

@doc("Virtual Network Rule")
model VirtualNetworkRule {
  @doc("Resource ID of a subnet")
  id: string;

  @doc("The action of virtual network rule.")
  action?: string;

  @doc("Gets the state of virtual network rule.")
  state?: string;
}

@doc("IP rule with specific IP or IP range in CIDR format.")
model IPRules {
  @doc("IP Rules Value")
  value?: string;

  @doc("The action of virtual network rule.")
  action: string;
}

@doc("ManagedResourceGroup related properties")
model ManagedResourceGroupConfiguration {
  @doc("Name of managed resource group")
  name: string;

  @doc("Managed Resource Group location")
  location: string;
}

@doc("Details of Consumption Properties")
model ConsumptionEndpointsProperties {
  @doc("Ingestion url to upload the data.")
  @visibility("read")
  ingestionUrl?: string;

  @doc("Resource Id of ingestion endpoint.")
  @visibility("read")
  ingestionResourceId?: ResourceIdentifier<[
    {
      type: "Microsoft.Storage/storageAccounts";
    }
  ]>;

  @doc("Url to consume file type.")
  @visibility("read")
  fileAccessUrl?: string;

  @doc("Resource Id of file access endpoint.")
  @visibility("read")
  fileAccessResourceId?: ResourceIdentifier<[
    {
      type: "Microsoft.Storage/storageAccounts";
    }
  ]>;

  @doc("Url to consume the processed data.")
  @visibility("read")
  queryUrl?: string;

  @doc("Resource Id of query endpoint.")
  @visibility("read")
  queryResourceId?: ResourceIdentifier<[
    {
      type: "Microsoft.Kusto/clusters";
    }
  ]>;
}

@doc("Managed service identity (system assigned and/or user assigned identities)")
model ManagedServiceIdentity {
  @doc("""
The service principal ID of the system assigned identity. This property will
only be provided for a system assigned identity.
""")
  @visibility("read")
  principalId?: string;

  @doc("""
The tenant ID of the system assigned identity. This property will only be
provided for a system assigned identity.
""")
  @visibility("read")
  tenantId?: string;

  @doc("""
Type of managed service identity (where both SystemAssigned and UserAssigned
types are allowed).
""")
  type: ManagedServiceIdentityType;

  @doc("""
The set of user assigned identities associated with the resource. The
userAssignedIdentities dictionary keys will be ARM resource ids in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}.
The dictionary values can be empty objects ({}) in requests.
""")
  userAssignedIdentities?: Record<UserAssignedIdentity>;
}

@doc("User assigned identity properties")
model UserAssignedIdentity {
  @doc("The principal ID of the assigned identity.")
  @visibility("read")
  principalId?: string;

  @doc("The client ID of the assigned identity.")
  @visibility("read")
  clientId?: string;
}

@doc("Details for data catalog properties.")
model DataProductsCatalogProperties {
  @doc("The data catalog provisioning state.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The data product publisher information.")
  publishers: PublisherInformation[];
}

@doc("Details for Publisher Information.")
model PublisherInformation {
  @doc("Name of the publisher.")
  publisherName: string;

  @doc("Data product information.")
  dataProducts: DataProductInformation[];
}

@doc("Data Product Information")
model DataProductInformation {
  @doc("Name of data product.")
  dataProductName: string;

  @doc("Description about data product.")
  description: string;

  @doc("Version information of data product.")
  dataProductVersions: DataProductVersion[];
}

@doc("Data Product Version.")
model DataProductVersion {
  @doc("Version of data product")
  version: string;
}

@doc("The updatable properties of the DataProduct.")
model DataProductUpdateProperties {
  @doc("List of name or email associated with data product resource deployment.")
  @visibility("read", "create", "update")
  owners?: string[];

  @doc("Purview account url for data product to connect to.")
  @visibility("read", "create", "update")
  purviewAccount?: string;

  @doc("Purview collection url for data product to connect to.")
  @visibility("read", "create", "update")
  purviewCollection?: string;

  @doc("Flag to enable or disable private link for data product resource.")
  @visibility("read", "create", "update")
  privateLinksEnabled?: ControlState;

  @doc("Current configured minor version of the data product resource.")
  @visibility("read", "update")
  currentMinorVersion?: string;
}

@doc("The details for role assignment common properties.")
model RoleAssignmentCommonProperties {
  @doc("Role Id of the Built-In Role")
  roleId: string;

  @doc("Object ID of the AAD principal or security-group.")
  principalId: string;

  @doc("User name.")
  userName: string;

  @doc("Data Type Scope at which the role assignment is created.")
  dataTypeScope: string[];

  @doc("Type of the principal Id: User, Group or ServicePrincipal")
  principalType: string;

  @doc("Data Product role to be assigned to a user.")
  role: DataProductUserRole;
}

@doc("The details for role assignment response.")
model RoleAssignmentDetail {
  @doc("Role Id of the Built-In Role")
  roleId: string;

  @doc("Object ID of the AAD principal or security-group.")
  principalId: string;

  @doc("User name.")
  userName: string;

  @doc("Data Type Scope at which the role assignment is created.")
  dataTypeScope: string[];

  @doc("Type of the principal Id: User, Group or ServicePrincipal")
  principalType: string;

  @doc("Data Product role to be assigned to a user.")
  role: DataProductUserRole;

  @doc("Id of role assignment request")
  roleAssignmentId: string;
}

@doc("The data type properties")
model DataTypeProperties {
  @doc("Latest provisioning state  of data product.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("State of data type.")
  @visibility("read", "create", "update")
  state?: DataTypeState;

  @doc("Reason for the state of data type.")
  @visibility("read")
  stateReason?: string;

  @doc("Field for storage output retention in days.")
  @visibility("read", "create", "update")
  storageOutputRetention?: int32;

  @doc("Field for database cache retention in days.")
  @visibility("read", "create", "update")
  databaseCacheRetention?: int32;

  @doc("Field for database data retention in days.")
  @visibility("read", "create", "update")
  databaseRetention?: int32;

  @doc("Url for data visualization.")
  @visibility("read")
  visualizationUrl?: string;
}

@doc("The updatable properties of the DataType.")
model DataTypeUpdateProperties {
  @doc("State of data type.")
  @visibility("read", "create", "update")
  state?: DataTypeState;

  @doc("Field for storage output retention in days.")
  @visibility("read", "create", "update")
  storageOutputRetention?: int32;

  @doc("Field for database cache retention in days.")
  @visibility("read", "create", "update")
  databaseCacheRetention?: int32;

  @doc("Field for database data retention in days.")
  @visibility("read", "create", "update")
  databaseRetention?: int32;
}

@doc("The details for container sas creation.")
model ContainerSaS {
  @doc("Sas token start timestamp.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTimeStamp: utcDateTime;

  @doc("Sas token expiry timestamp.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTimeStamp: utcDateTime;

  @doc("Ip Address")
  ipAddress: string;
}

@doc("Details of storage container account sas token .")
model ContainerSasToken {
  @doc("Field to specify storage container sas token.")
  @secret
  storageContainerSasToken: string;
}

@doc("The details for storage account sas creation.")
model AccountSas {
  @doc("Sas token start timestamp.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTimeStamp: utcDateTime;

  @doc("Sas token expiry timestamp.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTimeStamp: utcDateTime;

  @doc("Ip Address")
  ipAddress: string;
}

@doc("Details of storage account sas token .")
model AccountSasToken {
  @doc("Field to specify storage account sas token.")
  @secret
  storageAccountSasToken: string;
}

@doc("list role assignments.")
model ListRoleAssignments {
  @doc("Count of role assignments.")
  count: int32;

  @doc("list of role assignments")
  roleAssignmentResponse: RoleAssignmentDetail[];
}

@doc("Details for KeyVault.")
model KeyVaultInfo {
  @doc("key vault url.")
  keyVaultUrl: string;
}

@doc("Resource Access Rules.")
model ResourceAccessRules {
  @doc("The tenant ID of resource.")
  tenantId: string;

  @doc("Resource ID")
  resourceId: string;
}
