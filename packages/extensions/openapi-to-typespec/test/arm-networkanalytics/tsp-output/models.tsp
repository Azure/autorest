import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.NetworkAnalytics;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * The status of the current operation.
 */
enum ProvisioningState {
  /**
   * Represents a succeeded operation.
   */
  Succeeded,

  /**
   * Represents a failed operation.
   */
  Failed,

  /**
   * Represents a canceled operation.
   */
  Canceled,

  /**
   * Represents a pending operation.
   */
  Provisioning,

  /**
   * Represents a pending operation.
   */
  Updating,

  /**
   * Represents an operation under deletion.
   */
  Deleting,

  /**
   * Represents an accepted operation.
   */
  Accepted,
}

/**
 * The data type state
 */
enum ControlState {
  /**
   * Field to enable a setting.
   */
  Enabled,

  /**
   * Field to disable a setting.
   */
  Disabled,
}

/**
 * Specifies the default action of allow or deny when no other rules match.
 */
enum DefaultAction {
  /**
   * Represents allow action.
   */
  Allow,

  /**
   * Represents deny action.
   */
  Deny,
}

/**
 * Type of managed service identity (where both SystemAssigned and UserAssigned types are allowed).
 */
enum ManagedServiceIdentityType {
  None,
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
}

/**
 * The data type state
 */
enum DataProductUserRole {
  /**
   * Field to specify user of type Reader.
   */
  Reader,

  /**
   * Field to specify user of type SensitiveReader.
   * This user has privileged access to read sensitive data of a data product.
   */
  SensitiveReader,
}

/**
 * The data type state
 */
enum DataTypeState {
  /**
   * Field to specify stopped state.
   */
  Stopped,

  /**
   * Field to specify running state.
   */
  Running,
}

/**
 * Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging|Metrics|AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.
 */
enum Bypass {
  /**
   * Represents no bypassing of traffic.
   */
  None,

  /**
   * Represents bypassing logging traffic.
   */
  Logging,

  /**
   * Represents bypassing metrics traffic.
   */
  Metrics,

  /**
   * Represents bypassing azure services traffic.
   */
  AzureServices,
}

/**
 * The data product properties.
 */
model DataProductProperties {
  /**
   * The resource GUID property of the data product resource.
   */
  @visibility("read")
  resourceGuid?: string;

  /**
   * Latest provisioning state  of data product.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Data product publisher name.
   */
  @visibility("read", "create")
  publisher: string;

  /**
   * Product name of data product.
   */
  @visibility("read", "create")
  product: string;

  /**
   * Major version of data product.
   */
  @visibility("read", "create")
  majorVersion: string;

  /**
   * List of name or email associated with data product resource deployment.
   */
  @visibility("read", "create", "update")
  owners?: string[];

  /**
   * Flag to enable or disable redundancy for data product.
   */
  @visibility("read", "create")
  redundancy?: ControlState;

  /**
   * Purview account url for data product to connect to.
   */
  @visibility("read", "create", "update")
  purviewAccount?: string;

  /**
   * Purview collection url for data product to connect to.
   */
  @visibility("read", "create", "update")
  purviewCollection?: string;

  /**
   * Flag to enable or disable private link for data product resource.
   */
  @visibility("read", "create", "update")
  privateLinksEnabled?: ControlState;

  /**
   * Flag to enable or disable public access of data product resource.
   */
  @visibility("read", "create")
  publicNetworkAccess?: ControlState;

  /**
   * Flag to enable customer managed key encryption for data product.
   */
  @visibility("read", "create")
  customerManagedKeyEncryptionEnabled?: ControlState;

  /**
   * Customer managed encryption key details for data product.
   */
  @visibility("read", "create")
  customerEncryptionKey?: EncryptionKeyDetails;

  /**
   * Network rule set for data product.
   */
  @visibility("read", "create")
  networkacls?: DataProductNetworkAcls;

  /**
   * Managed resource group configuration.
   */
  @visibility("create")
  managedResourceGroupConfiguration?: ManagedResourceGroupConfiguration;

  /**
   * List of available minor versions of the data product resource.
   */
  @visibility("read")
  availableMinorVersions?: string[];

  /**
   * Current configured minor version of the data product resource.
   */
  @visibility("read", "update")
  currentMinorVersion?: string;

  /**
   * Documentation link for the data product based on definition file.
   */
  @visibility("read")
  documentation?: string;

  /**
   * Resource links which exposed to the customer to query the data.
   */
  @visibility("read")
  consumptionEndpoints?: ConsumptionEndpointsProperties;

  /**
   * Key vault url.
   */
  @visibility("read")
  keyVaultUrl?: string;
}

/**
 * Encryption key details.
 */
model EncryptionKeyDetails {
  /**
   * The Uri of the key vault.
   */
  keyVaultUri: string;

  /**
   * The name of the key vault key.
   */
  keyName: string;

  /**
   * The version of the key vault key.
   */
  keyVersion: string;
}

/**
 * Data Product Network rule set
 */
model DataProductNetworkAcls {
  /**
   * Virtual Network Rule
   */
  virtualNetworkRule: VirtualNetworkRule[];

  /**
   * IP rule with specific IP or IP range in CIDR format.
   */
  ipRules: IPRules[];

  /**
   * The list of query ips in the format of CIDR allowed to connect to query/visualization endpoint.
   */
  allowedQueryIpRangeList: string[];

  /**
   * Default Action
   */
  defaultAction: DefaultAction;
}

/**
 * Virtual Network Rule
 */
model VirtualNetworkRule {
  /**
   * Resource ID of a subnet
   */
  id: string;

  /**
   * The action of virtual network rule.
   */
  action?: string;

  /**
   * Gets the state of virtual network rule.
   */
  state?: string;
}

/**
 * IP rule with specific IP or IP range in CIDR format.
 */
model IPRules {
  /**
   * IP Rules Value
   */
  value?: string;

  /**
   * The action of virtual network rule.
   */
  action: string;
}

/**
 * ManagedResourceGroup related properties
 */
model ManagedResourceGroupConfiguration {
  /**
   * Name of managed resource group
   */
  name: string;

  /**
   * Managed Resource Group location
   */
  location: string;
}

/**
 * Details of Consumption Properties
 */
model ConsumptionEndpointsProperties {
  /**
   * Ingestion url to upload the data.
   */
  @visibility("read")
  ingestionUrl?: string;

  /**
   * Resource Id of ingestion endpoint.
   */
  @visibility("read")
  ingestionResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Storage/storageAccounts";
    }
  ]>;

  /**
   * Url to consume file type.
   */
  @visibility("read")
  fileAccessUrl?: string;

  /**
   * Resource Id of file access endpoint.
   */
  @visibility("read")
  fileAccessResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Storage/storageAccounts";
    }
  ]>;

  /**
   * Url to consume the processed data.
   */
  @visibility("read")
  queryUrl?: string;

  /**
   * Resource Id of query endpoint.
   */
  @visibility("read")
  queryResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Kusto/clusters";
    }
  ]>;
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

  /**
   * Azure Resource Manager metadata containing createdBy and modifiedBy information.
   */
  @visibility("read")
  systemData?: SystemData;
}

/**
 * Details for data catalog properties.
 */
model DataProductsCatalogProperties {
  /**
   * The data catalog provisioning state.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * The data product publisher information.
   */
  publishers: PublisherInformation[];
}

/**
 * Details for Publisher Information.
 */
model PublisherInformation {
  /**
   * Name of the publisher.
   */
  publisherName: string;

  /**
   * Data product information.
   */
  dataProducts: DataProductInformation[];
}

/**
 * Data Product Information
 */
model DataProductInformation {
  /**
   * Name of data product.
   */
  dataProductName: string;

  /**
   * Description about data product.
   */
  description: string;

  /**
   * Version information of data product.
   */
  dataProductVersions: DataProductVersion[];
}

/**
 * Data Product Version.
 */
model DataProductVersion {
  /**
   * Version of data product
   */
  version: string;
}

/**
 * The type used for update operations of the DataProduct.
 */
model DataProductUpdate {
  /**
   * The managed service identities assigned to this resource.
   */
  identity?: Azure.ResourceManager.Foundations.ManagedServiceIdentity;

  /**
   * Resource tags.
   */
  tags?: Record<string>;

  /**
   * The updatable properties of the DataProduct.
   */
  properties?: DataProductUpdateProperties;
}

/**
 * The updatable properties of the DataProduct.
 */
model DataProductUpdateProperties {
  /**
   * List of name or email associated with data product resource deployment.
   */
  @visibility("read", "create", "update")
  owners?: string[];

  /**
   * Purview account url for data product to connect to.
   */
  @visibility("read", "create", "update")
  purviewAccount?: string;

  /**
   * Purview collection url for data product to connect to.
   */
  @visibility("read", "create", "update")
  purviewCollection?: string;

  /**
   * Flag to enable or disable private link for data product resource.
   */
  @visibility("read", "create", "update")
  privateLinksEnabled?: ControlState;

  /**
   * Current configured minor version of the data product resource.
   */
  @visibility("read", "update")
  currentMinorVersion?: string;
}

/**
 * The details for role assignment common properties.
 */
model RoleAssignmentCommonProperties {
  /**
   * Role Id of the Built-In Role
   */
  roleId: string;

  /**
   * Object ID of the AAD principal or security-group.
   */
  principalId: string;

  /**
   * User name.
   */
  userName: string;

  /**
   * Data Type Scope at which the role assignment is created.
   */
  dataTypeScope: string[];

  /**
   * Type of the principal Id: User, Group or ServicePrincipal
   */
  principalType: string;

  /**
   * Data Product role to be assigned to a user.
   */
  role: DataProductUserRole;
}

/**
 * The details for role assignment response.
 */
model RoleAssignmentDetail {
  /**
   * Role Id of the Built-In Role
   */
  roleId: string;

  /**
   * Object ID of the AAD principal or security-group.
   */
  principalId: string;

  /**
   * User name.
   */
  userName: string;

  /**
   * Data Type Scope at which the role assignment is created.
   */
  dataTypeScope: string[];

  /**
   * Type of the principal Id: User, Group or ServicePrincipal
   */
  principalType: string;

  /**
   * Data Product role to be assigned to a user.
   */
  role: DataProductUserRole;

  /**
   * Id of role assignment request
   */
  roleAssignmentId: string;
}

/**
 * The data type properties
 */
model DataTypeProperties {
  /**
   * Latest provisioning state  of data product.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * State of data type.
   */
  @visibility("read", "create", "update")
  state?: DataTypeState;

  /**
   * Reason for the state of data type.
   */
  @visibility("read")
  stateReason?: string;

  /**
   * Field for storage output retention in days.
   */
  @visibility("read", "create", "update")
  storageOutputRetention?: int32;

  /**
   * Field for database cache retention in days.
   */
  @visibility("read", "create", "update")
  databaseCacheRetention?: int32;

  /**
   * Field for database data retention in days.
   */
  @visibility("read", "create", "update")
  databaseRetention?: int32;

  /**
   * Url for data visualization.
   */
  @visibility("read")
  visualizationUrl?: string;
}

/**
 * The type used for update operations of the DataType.
 */
model DataTypeUpdate {
  /**
   * The updatable properties of the DataType.
   */
  properties?: DataTypeUpdateProperties;
}

/**
 * The updatable properties of the DataType.
 */
model DataTypeUpdateProperties {
  /**
   * State of data type.
   */
  @visibility("read", "create", "update")
  state?: DataTypeState;

  /**
   * Field for storage output retention in days.
   */
  @visibility("read", "create", "update")
  storageOutputRetention?: int32;

  /**
   * Field for database cache retention in days.
   */
  @visibility("read", "create", "update")
  databaseCacheRetention?: int32;

  /**
   * Field for database data retention in days.
   */
  @visibility("read", "create", "update")
  databaseRetention?: int32;
}

/**
 * The details for container sas creation.
 */
model ContainerSaS {
  /**
   * Sas token start timestamp.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTimeStamp: utcDateTime;

  /**
   * Sas token expiry timestamp.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTimeStamp: utcDateTime;

  /**
   * Ip Address
   */
  ipAddress: string;
}

/**
 * Details of storage container account sas token .
 */
model ContainerSasToken {
  /**
   * Field to specify storage container sas token.
   */
  @secret
  storageContainerSasToken: string;
}

/**
 * The details for storage account sas creation.
 */
model AccountSas {
  /**
   * Sas token start timestamp.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTimeStamp: utcDateTime;

  /**
   * Sas token expiry timestamp.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTimeStamp: utcDateTime;

  /**
   * Ip Address
   */
  ipAddress: string;
}

/**
 * Details of storage account sas token .
 */
model AccountSasToken {
  /**
   * Field to specify storage account sas token.
   */
  @secret
  storageAccountSasToken: string;
}

/**
 * list role assignments.
 */
model ListRoleAssignments {
  /**
   * Count of role assignments.
   */
  count: int32;

  /**
   * list of role assignments
   */
  roleAssignmentResponse: RoleAssignmentDetail[];
}

/**
 * Details for KeyVault.
 */
model KeyVaultInfo {
  /**
   * key vault url.
   */
  keyVaultUrl: string;
}

/**
 * Resource Access Rules.
 */
model ResourceAccessRules {
  /**
   * The tenant ID of resource.
   */
  tenantId: string;

  /**
   * Resource ID
   */
  resourceId: string;
}
