import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.NetworkAnalytics;

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
 * The status of the current operation.
 */
union ProvisioningState {
  string,

  /**
   * Represents a succeeded operation.
   */
  Succeeded: "Succeeded",

  /**
   * Represents a failed operation.
   */
  Failed: "Failed",

  /**
   * Represents a canceled operation.
   */
  Canceled: "Canceled",

  /**
   * Represents a pending operation.
   */
  Provisioning: "Provisioning",

  /**
   * Represents a pending operation.
   */
  Updating: "Updating",

  /**
   * Represents an operation under deletion.
   */
  Deleting: "Deleting",

  /**
   * Represents an accepted operation.
   */
  Accepted: "Accepted",
}

/**
 * The data type state
 */
union ControlState {
  string,

  /**
   * Field to enable a setting.
   */
  Enabled: "Enabled",

  /**
   * Field to disable a setting.
   */
  Disabled: "Disabled",
}

/**
 * Specifies the default action of allow or deny when no other rules match.
 */
union DefaultAction {
  string,

  /**
   * Represents allow action.
   */
  Allow: "Allow",

  /**
   * Represents deny action.
   */
  Deny: "Deny",
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
 * The data type state
 */
union DataProductUserRole {
  string,

  /**
   * Field to specify user of type Reader.
   */
  Reader: "Reader",

  /**
   * Field to specify user of type SensitiveReader.
   * This user has privileged access to read sensitive data of a data product.
   */
  SensitiveReader: "SensitiveReader",
}

/**
 * The data type state
 */
union DataTypeState {
  string,

  /**
   * Field to specify stopped state.
   */
  Stopped: "Stopped",

  /**
   * Field to specify running state.
   */
  Running: "Running",
}

/**
 * Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging|Metrics|AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.
 */
union Bypass {
  string,

  /**
   * Represents no bypassing of traffic.
   */
  None: "None",

  /**
   * Represents bypassing logging traffic.
   */
  Logging: "Logging",

  /**
   * Represents bypassing metrics traffic.
   */
  Metrics: "Metrics",

  /**
   * Represents bypassing azure services traffic.
   */
  AzureServices: "AzureServices",
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
 * The data product properties.
 */
model DataProductProperties {
  /**
   * The resource GUID property of the data product resource.
   */
  @visibility(Lifecycle.Read)
  resourceGuid?: string;

  /**
   * Latest provisioning state  of data product.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * Data product publisher name.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  publisher: string;

  /**
   * Product name of data product.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  product: string;

  /**
   * Major version of data product.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  majorVersion: string;

  /**
   * List of name or email associated with data product resource deployment.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  owners?: string[];

  /**
   * Flag to enable or disable redundancy for data product.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  redundancy?: ControlState;

  /**
   * Purview account url for data product to connect to.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  purviewAccount?: string;

  /**
   * Purview collection url for data product to connect to.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  purviewCollection?: string;

  /**
   * Flag to enable or disable private link for data product resource.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  privateLinksEnabled?: ControlState;

  /**
   * Flag to enable or disable public access of data product resource.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  publicNetworkAccess?: ControlState;

  /**
   * Flag to enable customer managed key encryption for data product.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  customerManagedKeyEncryptionEnabled?: ControlState;

  /**
   * Customer managed encryption key details for data product.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  customerEncryptionKey?: EncryptionKeyDetails;

  /**
   * Network rule set for data product.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  networkacls?: DataProductNetworkAcls;

  /**
   * Managed resource group configuration.
   */
  @visibility(Lifecycle.Create)
  managedResourceGroupConfiguration?: ManagedResourceGroupConfiguration;

  /**
   * List of available minor versions of the data product resource.
   */
  @visibility(Lifecycle.Read)
  availableMinorVersions?: string[];

  /**
   * Current configured minor version of the data product resource.
   */
  @visibility(Lifecycle.Read, Lifecycle.Update)
  currentMinorVersion?: string;

  /**
   * Documentation link for the data product based on definition file.
   */
  @visibility(Lifecycle.Read)
  documentation?: string;

  /**
   * Resource links which exposed to the customer to query the data.
   */
  @visibility(Lifecycle.Read)
  consumptionEndpoints?: ConsumptionEndpointsProperties;

  /**
   * Key vault url.
   */
  @visibility(Lifecycle.Read)
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
  @identifiers(#[])
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
  @visibility(Lifecycle.Read)
  ingestionUrl?: string;

  /**
   * Resource Id of ingestion endpoint.
   */
  @visibility(Lifecycle.Read)
  ingestionResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Storage/storageAccounts";
    }
  ]>;

  /**
   * Url to consume file type.
   */
  @visibility(Lifecycle.Read)
  fileAccessUrl?: string;

  /**
   * Resource Id of file access endpoint.
   */
  @visibility(Lifecycle.Read)
  fileAccessResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Storage/storageAccounts";
    }
  ]>;

  /**
   * Url to consume the processed data.
   */
  @visibility(Lifecycle.Read)
  queryUrl?: string;

  /**
   * Resource Id of query endpoint.
   */
  @visibility(Lifecycle.Read)
  queryResourceId?: Azure.Core.armResourceIdentifier<[
    {
      type: "Microsoft.Kusto/clusters";
    }
  ]>;
}

/**
 * Details for data catalog properties.
 */
model DataProductsCatalogProperties {
  /**
   * The data catalog provisioning state.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * The data product publisher information.
   */
  @identifiers(#[])
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
  @identifiers(#[])
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
  @identifiers(#[])
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
  identity?: Azure.ResourceManager.CommonTypes.ManagedServiceIdentity;

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
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  owners?: string[];

  /**
   * Purview account url for data product to connect to.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  purviewAccount?: string;

  /**
   * Purview collection url for data product to connect to.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  purviewCollection?: string;

  /**
   * Flag to enable or disable private link for data product resource.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  privateLinksEnabled?: ControlState;

  /**
   * Current configured minor version of the data product resource.
   */
  @visibility(Lifecycle.Read, Lifecycle.Update)
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
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * State of data type.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  state?: DataTypeState;

  /**
   * Reason for the state of data type.
   */
  @visibility(Lifecycle.Read)
  stateReason?: string;

  /**
   * Field for storage output retention in days.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  storageOutputRetention?: int32;

  /**
   * Field for database cache retention in days.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  databaseCacheRetention?: int32;

  /**
   * Field for database data retention in days.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  databaseRetention?: int32;

  /**
   * Url for data visualization.
   */
  @visibility(Lifecycle.Read)
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
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  state?: DataTypeState;

  /**
   * Field for storage output retention in days.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  storageOutputRetention?: int32;

  /**
   * Field for database cache retention in days.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
  databaseCacheRetention?: int32;

  /**
   * Field for database data retention in days.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create, Lifecycle.Update)
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
  @identifiers(#["roleAssignmentId"])
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
