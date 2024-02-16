import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Storage;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * The SKU name. Required for account creation; optional for update. Note that in older versions, SKU name was called accountType.
 */
enum SkuName {
  Standard_LRS,
  Standard_GRS,
  Standard_RAGRS,
  Standard_ZRS,
  Premium_LRS,
  Premium_ZRS,
  Standard_GZRS,
  Standard_RAGZRS,
}

/**
 * Indicates the type of storage account.
 */
enum Kind {
  Storage,
  StorageV2,
  BlobStorage,
  FileStorage,
  BlockBlobStorage,
}

/**
 * The reason for the restriction. As of now this can be "QuotaId" or "NotAvailableForSubscription". Quota Id is set when the SKU has requiredQuotas parameter as the subscription does not belong to that quota. The "NotAvailableForSubscription" is related to capacity at DC.
 */
enum ReasonCode {
  QuotaId,
  NotAvailableForSubscription,
}

/**
 * The type of extendedLocation.
 */
enum ExtendedLocationTypes {
  EdgeZone,
}

/**
 * The identity type.
 */
enum IdentityType {
  None,
  SystemAssigned,
  UserAssigned,
  `SystemAssigned,UserAssigned`,
}

/**
 * Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.
 */
enum AllowedCopyScope {
  PrivateLink,
  AAD,
}

/**
 * Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be 'Enabled' or 'Disabled'.
 */
enum PublicNetworkAccess {
  Enabled,
  Disabled,
}

/**
 * The SAS expiration action. Can only be Log.
 */
enum ExpirationAction {
  Log,
}

/**
 * Encryption key type to be used for the encryption service. 'Account' key type implies that an account-scoped encryption key will be used. 'Service' key type implies that a default service key is used.
 */
enum KeyType {
  Service,
  Account,
}

/**
 * The encryption keySource (provider). Possible values (case-insensitive):  Microsoft.Storage, Microsoft.Keyvault
 */
enum KeySource {
  `Microsoft.Storage`,
  `Microsoft.Keyvault`,
}

/**
 * Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging|Metrics|AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.
 */
enum Bypass {
  None,
  Logging,
  Metrics,
  AzureServices,
}

/**
 * Gets the state of virtual network rule.
 */
enum State {
  Provisioning,
  Deprovisioning,
  Succeeded,
  Failed,
  NetworkSourceDeleted,
}

/**
 * Indicates the directory service used. Note that this enum may be extended in the future.
 */
enum DirectoryServiceOptions {
  None,
  AADDS,
  AD,
  AADKERB,
}

/**
 * Specifies the Active Directory account type for Azure Storage.
 */
enum AccountType {
  User,
  Computer,
}

/**
 * Default share permission for users using Kerberos authentication if RBAC role is not assigned.
 */
enum DefaultSharePermission {
  None,
  StorageFileDataSmbShareReader,
  StorageFileDataSmbShareContributor,
  StorageFileDataSmbShareElevatedContributor,
}

/**
 * Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.
 */
enum LargeFileSharesState {
  Disabled,
  Enabled,
}

/**
 * Routing Choice defines the kind of network routing opted by the user.
 */
enum RoutingChoice {
  MicrosoftRouting,
  InternetRouting,
}

/**
 * Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.
 */
enum MinimumTlsVersion {
  TLS1_0,
  TLS1_1,
  TLS1_2,
}

/**
 * The ImmutabilityPolicy state defines the mode of the policy. Disabled state disables the policy, Unlocked state allows increase and decrease of immutability retention time and also allows toggling allowProtectedAppendWrites property, Locked state only allows the increase of the immutability retention time. A policy can only be created in a Disabled or Unlocked state and can be toggled between the two states. Only a policy in an Unlocked state can transition to a Locked state which cannot be reverted.
 */
enum AccountImmutabilityPolicyState {
  Unlocked,
  Locked,
  Disabled,
}

/**
 * Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.
 */
enum DnsEndpointType {
  Standard,
  AzureDnsZone,
}

/**
 * The status of the secondary location. Possible values are: - Live: Indicates that the secondary location is active and operational. - Bootstrap: Indicates initial synchronization from the primary location to the secondary location is in progress.This typically occurs when replication is first enabled. - Unavailable: Indicates that the secondary location is temporarily unavailable.
 */
enum GeoReplicationStatus {
  Live,
  Bootstrap,
  Unavailable,
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
 * The current provisioning state.
 */
enum PrivateEndpointConnectionProvisioningState {
  Succeeded,
  Creating,
  Deleting,
  Failed,
}

/**
 * The status of blob restore progress. Possible values are: - InProgress: Indicates that blob restore is ongoing. - Complete: Indicates that blob restore has been completed successfully. - Failed: Indicates that blob restore is failed.
 */
enum BlobRestoreProgressStatus {
  InProgress,
  Complete,
  Failed,
}

/**
 * This property indicates the current sku conversion status.
 */
enum SkuConversionStatus {
  InProgress,
  Succeeded,
  Failed,
}

/**
 * The signed services accessible with the account SAS. Possible values include: Blob (b), Queue (q), Table (t), File (f).
 */
enum Services {
  b,
  q,
  t,
  f,
}

/**
 * The signed resource types that are accessible with the account SAS. Service (s): Access to service-level APIs; Container (c): Access to container-level APIs; Object (o): Access to object-level APIs for blobs, queue messages, table entities, and files.
 */
enum SignedResourceTypes {
  s,
  c,
  o,
}

/**
 * The signed permissions for the account SAS. Possible values include: Read (r), Write (w), Delete (d), List (l), Add (a), Create (c), Update (u) and Process (p).
 */
enum Permissions {
  r,
  d,
  w,
  l,
  a,
  c,
  u,
  p,
}

/**
 * The signed services accessible with the service SAS. Possible values include: Blob (b), Container (c), File (f), Share (s).
 */
enum SignedResource {
  b,
  c,
  f,
  s,
}

enum ManagementPolicyName {
  default,
}

/**
 * The valid value is Lifecycle
 */
enum RuleType {
  Lifecycle,
}

enum BlobInventoryPolicyName {
  default,
}

/**
 * The valid value is Inventory
 */
enum InventoryRuleType {
  Inventory,
}

/**
 * This is a required field, it specifies the format for the inventory files.
 */
enum Format {
  Csv,
  Parquet,
}

/**
 * This is a required field. This field is used to schedule an inventory formation.
 */
enum Schedule {
  Daily,
  Weekly,
}

/**
 * This is a required field. This field specifies the scope of the inventory created either at the blob or container level.
 */
enum ObjectType {
  Blob,
  Container,
}

/**
 * The provider for the encryption scope. Possible values (case-insensitive):  Microsoft.Storage, Microsoft.KeyVault.
 */
enum EncryptionScopeSource {
  `Microsoft.Storage`,
  `Microsoft.KeyVault`,
}

/**
 * The state of the encryption scope. Possible values (case-insensitive):  Enabled, Disabled.
 */
enum EncryptionScopeState {
  Enabled,
  Disabled,
}

enum ListEncryptionScopesInclude {
  All,
  Enabled,
  Disabled,
}

enum AllowedMethods {
  DELETE,
  GET,
  HEAD,
  MERGE,
  POST,
  OPTIONS,
  PUT,
  PATCH,
}

/**
 * Name of the policy. The valid value is AccessTimeTracking. This field is currently read only
 */
enum Name {
  AccessTimeTracking,
}

enum ListContainersInclude {
  deleted,
}

/**
 * The lease status of the container.
 */
enum LeaseStatus {
  Locked,
  Unlocked,
}

/**
 * Lease state of the container.
 */
enum LeaseState {
  Available,
  Leased,
  Expired,
  Breaking,
  Broken,
}

/**
 * Specifies whether the lease on a container is of infinite or fixed duration, only when the container is leased.
 */
enum LeaseDuration {
  Infinite,
  Fixed,
}

/**
 * The ImmutabilityPolicy state of a blob container, possible values include: Locked and Unlocked.
 */
enum ImmutabilityPolicyState {
  Locked,
  Unlocked,
}

/**
 * The ImmutabilityPolicy update type of a blob container, possible values include: put, lock and extend.
 */
enum ImmutabilityPolicyUpdateType {
  put,
  lock,
  extend,
}

/**
 * This property denotes the container level immutability to object level immutability migration state.
 */
enum MigrationState {
  InProgress,
  Completed,
}

/**
 * Specifies the lease action. Can be one of the available actions.
 */
enum LeaseContainerRequestAction {
  Acquire,
  Renew,
  Change,
  Release,
  Break,
}

/**
 * The authentication protocol that is used for the file share. Can only be specified when creating a share.
 */
enum EnabledProtocols {
  SMB,
  NFS,
}

/**
 * The property is for NFS share only. The default is NoRootSquash.
 */
enum RootSquashType {
  NoRootSquash,
  RootSquash,
  AllSquash,
}

/**
 * Access tier for specific share. GpV2 account can choose between TransactionOptimized (default), Hot, and Cool. FileStorage account can choose Premium.
 */
enum ShareAccessTier {
  TransactionOptimized,
  Hot,
  Cool,
  Premium,
}

/**
 * Specifies the lease action. Can be one of the available actions.
 */
enum LeaseShareAction {
  Acquire,
  Renew,
  Change,
  Release,
  Break,
}

/**
 * Gets the reason that a storage account name could not be used. The Reason element is only returned if NameAvailable is false.
 */
@fixed
enum Reason {
  AccountNameInvalid,
  AlreadyExists,
}

/**
 * Specifies the default action of allow or deny when no other rules match.
 */
@fixed
enum DefaultAction {
  Allow,
  Deny,
}

/**
 * Required for storage accounts where kind = BlobStorage. The access tier is used for billing. The 'Premium' access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
 */
@fixed
enum AccessTier {
  Hot,
  Cool,
  Premium,
}

/**
 * Gets the status of the storage account at the time the operation was called.
 */
@fixed
enum ProvisioningState {
  Creating,
  ResolvingDNS,
  Succeeded,
}

/**
 * Gets the status indicating whether the primary location of the storage account is available or unavailable.
 */
@fixed
enum AccountStatus {
  available,
  unavailable,
}

@fixed
enum StorageAccountExpand {
  geoReplicationStats,
  blobRestoreStatus,
}

/**
 * Permissions for the key -- read-only or full permissions.
 */
@fixed
enum KeyPermission {
  Read,
  Full,
}

/**
 * Gets the unit of measurement.
 */
@fixed
enum UsageUnit {
  Count,
  Bytes,
  Seconds,
  Percent,
  CountsPerSecond,
  BytesPerSecond,
}

/**
 * The protocol permitted for a request made with the account SAS.
 */
@fixed
enum HttpProtocol {
  `https,http`,
  https,
}

/**
 * Specifies whether data in the container may be accessed publicly and the level of access.
 */
@fixed
enum PublicAccess {
  Container,
  Blob,
  None,
}

/**
 * Properties of operation, include metric specifications.
 */
model OperationProperties {
  /**
   * One property of operation, include metric specifications.
   */
  serviceSpecification?: ServiceSpecification;
}

/**
 * One property of operation, include metric specifications.
 */
model ServiceSpecification {
  /**
   * Metric specifications of operation.
   */
  metricSpecifications?: MetricSpecification[];
}

/**
 * Metric specification of operation.
 */
model MetricSpecification {
  /**
   * Name of metric specification.
   */
  name?: string;

  /**
   * Display name of metric specification.
   */
  displayName?: string;

  /**
   * Display description of metric specification.
   */
  displayDescription?: string;

  /**
   * Unit could be Bytes or Count.
   */
  unit?: string;

  /**
   * Dimensions of blobs, including blob type and access tier.
   */
  dimensions?: Dimension[];

  /**
   * Aggregation type could be Average.
   */
  aggregationType?: string;

  /**
   * The property to decide fill gap with zero or not.
   */
  fillGapWithZero?: boolean;

  /**
   * The category this metric specification belong to, could be Capacity.
   */
  category?: string;

  /**
   * Account Resource Id.
   */
  resourceIdDimensionNameOverride?: string;
}

/**
 * Dimension of blobs, possibly be blob type or access tier.
 */
model Dimension {
  /**
   * Display name of dimension.
   */
  name?: string;

  /**
   * Display name of dimension.
   */
  displayName?: string;
}

/**
 * The response from the List Storage SKUs operation.
 */
@pagedResult
model StorageSkuListResult {
  /**
   * Get the list result of storage SKUs and their properties.
   */
  @visibility("read")
  @items
  value?: SkuInformation[];
}

/**
 * Storage SKU and its properties
 */
model SkuInformation {
  /**
   * The SKU name. Required for account creation; optional for update. Note that in older versions, SKU name was called accountType.
   */
  name: SkuName;

  /**
   * The SKU tier. This is based on the SKU name.
   */
  @visibility("read")
  tier?: SkuTier;

  /**
   * The type of the resource, usually it is 'storageAccounts'.
   */
  @visibility("read")
  resourceType?: string;

  /**
   * Indicates the type of storage account.
   */
  @visibility("read")
  kind?: Kind;

  /**
   * The set of locations that the SKU is available. This will be supported and registered Azure Geo Regions (e.g. West US, East US, Southeast Asia, etc.).
   */
  @visibility("read")
  locations?: string[];

  /**
   * The capability information in the specified SKU, including file encryption, network ACLs, change notification, etc.
   */
  @visibility("read")
  capabilities?: SKUCapability[];

  /**
   * The restrictions because of which SKU cannot be used. This is empty if there are no restrictions.
   */
  restrictions?: Restriction[];
}

/**
 * The capability information in the specified SKU, including file encryption, network ACLs, change notification, etc.
 */
model SKUCapability {
  /**
   * The name of capability, The capability information in the specified SKU, including file encryption, network ACLs, change notification, etc.
   */
  @visibility("read")
  name?: string;

  /**
   * A string value to indicate states of given capability. Possibly 'true' or 'false'.
   */
  @visibility("read")
  value?: string;
}

/**
 * The restriction because of which SKU cannot be used.
 */
model Restriction {
  /**
   * The type of restrictions. As of now only possible value for this is location.
   */
  @visibility("read")
  type?: string;

  /**
   * The value of restrictions. If the restriction type is set to location. This would be different locations where the SKU is restricted.
   */
  @visibility("read")
  values?: string[];

  /**
   * The reason for the restriction. As of now this can be "QuotaId" or "NotAvailableForSubscription". Quota Id is set when the SKU has requiredQuotas parameter as the subscription does not belong to that quota. The "NotAvailableForSubscription" is related to capacity at DC.
   */
  reasonCode?: ReasonCode;
}

/**
 * The parameters used to check the availability of the storage account name.
 */
model StorageAccountCheckNameAvailabilityParameters {
  /**
   * The storage account name.
   */
  name: string;

  /**
   * The type of resource, Microsoft.Storage/storageAccounts
   */
  type: "Microsoft.Storage/storageAccounts";
}

/**
 * The CheckNameAvailability operation response.
 */
model CheckNameAvailabilityResult {
  /**
   * Gets a boolean value that indicates whether the name is available for you to use. If true, the name is available. If false, the name has already been taken or is invalid and cannot be used.
   */
  @visibility("read")
  nameAvailable?: boolean;

  /**
   * Gets the reason that a storage account name could not be used. The Reason element is only returned if NameAvailable is false.
   */
  @visibility("read")
  reason?: Reason;

  /**
   * Gets an error message explaining the Reason value in more detail.
   */
  @visibility("read")
  message?: string;
}

/**
 * The parameters used when creating a storage account.
 */
model StorageAccountCreateParameters {
  /**
   * Required. Gets or sets the SKU name.
   */
  sku: Sku;

  /**
   * Required. Indicates the type of storage account.
   */
  kind: Kind;

  /**
   * Required. Gets or sets the location of the resource. This will be one of the supported and registered Azure Geo Regions (e.g. West US, East US, Southeast Asia, etc.). The geo region of a resource cannot be changed once it is created, but if an identical geo region is specified on update, the request will succeed.
   */
  location: string;

  /**
   * Optional. Set the extended location of the resource. If not set, the storage account will be created in Azure main region. Otherwise it will be created in the specified extended location
   */
  extendedLocation?: ExtendedLocation;

  /**
   * Gets or sets a list of key value pairs that describe the resource. These tags can be used for viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key with a length no greater than 128 characters and a value with a length no greater than 256 characters.
   */
  tags?: Record<string>;

  /**
   * The identity of the resource.
   */
  identity?: Identity;

  /**
   * The parameters used to create the storage account.
   */
  properties?: StorageAccountPropertiesCreateParameters;
}

/**
 * The SKU of the storage account.
 */
model Sku {
  /**
   * The SKU name. Required for account creation; optional for update. Note that in older versions, SKU name was called accountType.
   */
  name: SkuName;

  /**
   * The SKU tier. This is based on the SKU name.
   */
  @visibility("read")
  tier?: SkuTier;
}

/**
 * The complex type of the extended location.
 */
model ExtendedLocation {
  /**
   * The name of the extended location.
   */
  name?: string;

  /**
   * The type of the extended location.
   */
  type?: ExtendedLocationTypes;
}

/**
 * Identity for the resource.
 */
model Identity {
  /**
   * The principal ID of resource identity.
   */
  @visibility("read")
  principalId?: string;

  /**
   * The tenant ID of resource.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * The identity type.
   */
  type: IdentityType;

  /**
   * Gets or sets a list of key value pairs that describe the set of User Assigned identities that will be used with this storage account. The key is the ARM resource identifier of the identity. Only 1 User Assigned identity is permitted here.
   */
  userAssignedIdentities?: Record<UserAssignedIdentity>;
}

/**
 * The parameters used to create the storage account.
 */
model StorageAccountPropertiesCreateParameters {
  /**
   * Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.
   */
  allowedCopyScope?: AllowedCopyScope;

  /**
   * Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be 'Enabled' or 'Disabled'.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * SasPolicy assigned to the storage account.
   */
  sasPolicy?: SasPolicy;

  /**
   * KeyPolicy assigned to the storage account.
   */
  keyPolicy?: KeyPolicy;

  /**
   * User domain assigned to the storage account. Name is the CNAME source. Only one custom domain is supported per storage account at this time. To clear the existing custom domain, use an empty string for the custom domain name property.
   */
  customDomain?: CustomDomain;

  /**
   * Encryption settings to be used for server-side encryption for the storage account.
   */
  encryption?: Encryption;

  /**
   * Network rule set
   */
  @projectedName("json", "networkAcls")
  networkRuleSet?: NetworkRuleSet;

  /**
   * Required for storage accounts where kind = BlobStorage. The access tier is used for billing. The 'Premium' access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
   */
  accessTier?: AccessTier;

  /**
   * Provides the identity based authentication settings for Azure Files.
   */
  azureFilesIdentityBasedAuthentication?: AzureFilesIdentityBasedAuthentication;

  /**
   * Allows https traffic only to storage service if sets to true. The default value is true since API version 2019-04-01.
   */
  @projectedName("json", "supportsHttpsTrafficOnly")
  enableHttpsTrafficOnly?: boolean;

  /**
   * Enables Secure File Transfer Protocol, if set to true
   */
  @projectedName("json", "isSftpEnabled")
  IsSftpEnabled?: boolean;

  /**
   * Enables local users feature, if set to true
   */
  @projectedName("json", "isLocalUserEnabled")
  IsLocalUserEnabled?: boolean;

  /**
   * Account HierarchicalNamespace enabled if sets to true.
   */
  @projectedName("json", "isHnsEnabled")
  IsHnsEnabled?: boolean;

  /**
   * Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.
   */
  largeFileSharesState?: LargeFileSharesState;

  /**
   * Maintains information about the network routing choice opted by the user for data transfer
   */
  routingPreference?: RoutingPreference;

  /**
   * Allow or disallow public access to all blobs or containers in the storage account. The default interpretation is true for this property.
   */
  allowBlobPublicAccess?: boolean;

  /**
   * Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.
   */
  minimumTlsVersion?: MinimumTlsVersion;

  /**
   * Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.
   */
  allowSharedKeyAccess?: boolean;

  /**
   * NFS 3.0 protocol support enabled if set to true.
   */
  @projectedName("json", "isNfsV3Enabled")
  enableNfsV3?: boolean;

  /**
   * Allow or disallow cross AAD tenant object replication. The default interpretation is true for this property.
   */
  allowCrossTenantReplication?: boolean;

  /**
   * A boolean flag which indicates whether the default authentication is OAuth or not. The default interpretation is false for this property.
   */
  defaultToOAuthAuthentication?: boolean;

  /**
   * The property is immutable and can only be set to true at the account creation time. When set to true, it enables object level immutability for all the new containers in the account by default.
   */
  immutableStorageWithVersioning?: ImmutableStorageAccount;

  /**
   * Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.
   */
  dnsEndpointType?: DnsEndpointType;
}

/**
 * SasPolicy assigned to the storage account.
 */
model SasPolicy {
  /**
   * The SAS expiration period, DD.HH:MM:SS.
   */
  sasExpirationPeriod: string;

  /**
   * The SAS expiration action. Can only be Log.
   */
  expirationAction: ExpirationAction = ExpirationAction.Log;
}

/**
 * KeyPolicy assigned to the storage account.
 */
model KeyPolicy {
  /**
   * The key expiration period in days.
   */
  keyExpirationPeriodInDays: int32;
}

/**
 * The custom domain assigned to this storage account. This can be set via Update.
 */
model CustomDomain {
  /**
   * Gets or sets the custom domain name assigned to the storage account. Name is the CNAME source.
   */
  name: string;

  /**
   * Indicates whether indirect CName validation is enabled. Default value is false. This should only be set on updates.
   */
  useSubDomainName?: boolean;
}

/**
 * The encryption settings on the storage account.
 */
model Encryption {
  /**
   * List of services which support encryption.
   */
  services?: EncryptionServices;

  /**
   * The encryption keySource (provider). Possible values (case-insensitive):  Microsoft.Storage, Microsoft.Keyvault
   */
  keySource?: KeySource = KeySource.`Microsoft.Storage`;

  /**
   * A boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest.
   */
  requireInfrastructureEncryption?: boolean;

  /**
   * Properties provided by key vault.
   */
  @projectedName("json", "keyvaultproperties")
  keyVaultProperties?: KeyVaultProperties;

  /**
   * The identity to be used with service-side encryption at rest.
   */
  @projectedName("json", "identity")
  encryptionIdentity?: EncryptionIdentity;
}

/**
 * A list of services that support encryption.
 */
model EncryptionServices {
  /**
   * The encryption function of the blob storage service.
   */
  blob?: EncryptionService;

  /**
   * The encryption function of the file storage service.
   */
  file?: EncryptionService;

  /**
   * The encryption function of the table storage service.
   */
  table?: EncryptionService;

  /**
   * The encryption function of the queue storage service.
   */
  queue?: EncryptionService;
}

/**
 * A service that allows server-side encryption to be used.
 */
model EncryptionService {
  /**
   * A boolean indicating whether or not the service encrypts the data as it is stored. Encryption at rest is enabled by default today and cannot be disabled.
   */
  enabled?: boolean;

  /**
   * Gets a rough estimate of the date/time when the encryption was last enabled by the user. Data is encrypted at rest by default today and cannot be disabled.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastEnabledTime?: utcDateTime;

  /**
   * Encryption key type to be used for the encryption service. 'Account' key type implies that an account-scoped encryption key will be used. 'Service' key type implies that a default service key is used.
   */
  @visibility("read", "create")
  keyType?: KeyType;
}

/**
 * Properties of key vault.
 */
model KeyVaultProperties {
  /**
   * The name of KeyVault key.
   */
  @projectedName("json", "keyname")
  keyName?: string;

  /**
   * The version of KeyVault key.
   */
  @projectedName("json", "keyversion")
  keyVersion?: string;

  /**
   * The Uri of KeyVault.
   */
  @projectedName("json", "keyvaulturi")
  keyVaultUri?: string;

  /**
   * The object identifier of the current versioned Key Vault Key in use.
   */
  @visibility("read")
  currentVersionedKeyIdentifier?: string;

  /**
   * Timestamp of last rotation of the Key Vault Key.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastKeyRotationTimestamp?: utcDateTime;

  /**
   * This is a read only property that represents the expiration time of the current version of the customer managed key used for encryption.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  currentVersionedKeyExpirationTimestamp?: utcDateTime;
}

/**
 * Encryption identity for the storage account.
 */
model EncryptionIdentity {
  /**
   * Resource identifier of the UserAssigned identity to be associated with server-side encryption on the storage account.
   */
  @projectedName("json", "userAssignedIdentity")
  encryptionUserAssignedIdentity?: string;

  /**
   * ClientId of the multi-tenant application to be used in conjunction with the user-assigned identity for cross-tenant customer-managed-keys server-side encryption on the storage account.
   */
  @projectedName("json", "federatedIdentityClientId")
  encryptionFederatedIdentityClientId?: string;
}

/**
 * Network rule set
 */
model NetworkRuleSet {
  /**
   * Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging|Metrics|AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.
   */
  bypass?: Bypass = Bypass.AzureServices;

  /**
   * Sets the resource access rules
   */
  resourceAccessRules?: ResourceAccessRule[];

  /**
   * Sets the virtual network rules
   */
  virtualNetworkRules?: VirtualNetworkRule[];

  /**
   * Sets the IP ACL rules
   */
  ipRules?: IPRule[];

  /**
   * Specifies the default action of allow or deny when no other rules match.
   */
  defaultAction: DefaultAction = DefaultAction.Allow;
}

/**
 * Resource Access Rule.
 */
model ResourceAccessRule {
  /**
   * Tenant Id
   */
  tenantId?: string;

  /**
   * Resource Id
   */
  resourceId?: string;
}

/**
 * Virtual Network rule.
 */
model VirtualNetworkRule {
  /**
   * Resource ID of a subnet, for example: /subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.
   */
  @projectedName("json", "id")
  virtualNetworkResourceId: string;

  /**
   * The action of virtual network rule.
   */
  action?: "Allow";

  /**
   * Gets the state of virtual network rule.
   */
  state?: State;
}

/**
 * IP rule with specific IP or IP range in CIDR format.
 */
model IPRule {
  /**
   * Specifies the IP or IP range in CIDR format. Only IPV4 address is allowed.
   */
  @projectedName("json", "value")
  IPAddressOrRange: string;

  /**
   * The action of IP ACL rule.
   */
  action?: "Allow";
}

/**
 * Settings for Azure Files identity based authentication.
 */
model AzureFilesIdentityBasedAuthentication {
  /**
   * Indicates the directory service used. Note that this enum may be extended in the future.
   */
  directoryServiceOptions: DirectoryServiceOptions;

  /**
   * Required if directoryServiceOptions are AD, optional if they are AADKERB.
   */
  activeDirectoryProperties?: ActiveDirectoryProperties;

  /**
   * Default share permission for users using Kerberos authentication if RBAC role is not assigned.
   */
  defaultSharePermission?: DefaultSharePermission;
}

/**
 * Settings properties for Active Directory (AD).
 */
model ActiveDirectoryProperties {
  /**
   * Specifies the primary domain that the AD DNS server is authoritative for.
   */
  domainName: string;

  /**
   * Specifies the NetBIOS domain name.
   */
  netBiosDomainName?: string;

  /**
   * Specifies the Active Directory forest to get.
   */
  forestName?: string;

  /**
   * Specifies the domain GUID.
   */
  domainGuid: string;

  /**
   * Specifies the security identifier (SID).
   */
  domainSid?: string;

  /**
   * Specifies the security identifier (SID) for Azure Storage.
   */
  azureStorageSid?: string;

  /**
   * Specifies the Active Directory SAMAccountName for Azure Storage.
   */
  samAccountName?: string;

  /**
   * Specifies the Active Directory account type for Azure Storage.
   */
  accountType?: AccountType;
}

/**
 * Routing preference defines the type of network, either microsoft or internet routing to be used to deliver the user data, the default option is microsoft routing
 */
model RoutingPreference {
  /**
   * Routing Choice defines the kind of network routing opted by the user.
   */
  routingChoice?: RoutingChoice;

  /**
   * A boolean flag which indicates whether microsoft routing storage endpoints are to be published
   */
  publishMicrosoftEndpoints?: boolean;

  /**
   * A boolean flag which indicates whether internet routing storage endpoints are to be published
   */
  publishInternetEndpoints?: boolean;
}

/**
 * This property enables and defines account-level immutability. Enabling the feature auto-enables Blob Versioning.
 */
model ImmutableStorageAccount {
  /**
   * A boolean flag which enables account-level immutability. All the containers under such an account have object-level immutability enabled by default.
   */
  enabled?: boolean;

  /**
   * Specifies the default account-level immutability policy which is inherited and applied to objects that do not possess an explicit immutability policy at the object level. The object-level immutability policy has higher precedence than the container-level immutability policy, which has a higher precedence than the account-level immutability policy.
   */
  immutabilityPolicy?: AccountImmutabilityPolicyProperties;
}

/**
 * This defines account-level immutability policy properties.
 */
model AccountImmutabilityPolicyProperties {
  /**
   * The immutability period for the blobs in the container since the policy creation, in days.
   */
  @maxValue(146000)
  @minValue(1)
  immutabilityPeriodSinceCreationInDays?: int32;

  /**
   * The ImmutabilityPolicy state defines the mode of the policy. Disabled state disables the policy, Unlocked state allows increase and decrease of immutability retention time and also allows toggling allowProtectedAppendWrites property, Locked state only allows the increase of the immutability retention time. A policy can only be created in a Disabled or Unlocked state and can be toggled between the two states. Only a policy in an Unlocked state can transition to a Locked state which cannot be reverted.
   */
  state?: AccountImmutabilityPolicyState;

  /**
   * This property can only be changed for disabled and unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted.
   */
  allowProtectedAppendWrites?: boolean;
}

/**
 * Properties of the storage account.
 */
model StorageAccountProperties {
  /**
   * Gets the status of the storage account at the time the operation was called.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Gets the URLs that are used to perform a retrieval of a public blob, queue, or table object. Note that Standard_ZRS and Premium_LRS accounts only return the blob endpoint.
   */
  @visibility("read")
  primaryEndpoints?: Endpoints;

  /**
   * Gets the location of the primary data center for the storage account.
   */
  @visibility("read")
  primaryLocation?: string;

  /**
   * Gets the status indicating whether the primary location of the storage account is available or unavailable.
   */
  @visibility("read")
  statusOfPrimary?: AccountStatus;

  /**
   * Gets the timestamp of the most recent instance of a failover to the secondary location. Only the most recent timestamp is retained. This element is not returned if there has never been a failover instance. Only available if the accountType is Standard_GRS or Standard_RAGRS.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastGeoFailoverTime?: utcDateTime;

  /**
   * Gets the location of the geo-replicated secondary for the storage account. Only available if the accountType is Standard_GRS or Standard_RAGRS.
   */
  @visibility("read")
  secondaryLocation?: string;

  /**
   * Gets the status indicating whether the secondary location of the storage account is available or unavailable. Only available if the SKU name is Standard_GRS or Standard_RAGRS.
   */
  @visibility("read")
  statusOfSecondary?: AccountStatus;

  /**
   * Gets the creation date and time of the storage account in UTC.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  /**
   * Gets the custom domain the user assigned to this storage account.
   */
  @visibility("read")
  customDomain?: CustomDomain;

  /**
   * SasPolicy assigned to the storage account.
   */
  @visibility("read")
  sasPolicy?: SasPolicy;

  /**
   * KeyPolicy assigned to the storage account.
   */
  @visibility("read")
  keyPolicy?: KeyPolicy;

  /**
   * Storage account keys creation time.
   */
  @visibility("read")
  keyCreationTime?: KeyCreationTime;

  /**
   * Gets the URLs that are used to perform a retrieval of a public blob, queue, or table object from the secondary location of the storage account. Only available if the SKU name is Standard_RAGRS.
   */
  @visibility("read")
  secondaryEndpoints?: Endpoints;

  /**
   * Encryption settings to be used for server-side encryption for the storage account.
   */
  @visibility("read")
  encryption?: Encryption;

  /**
   * Required for storage accounts where kind = BlobStorage. The access tier is used for billing. The 'Premium' access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
   */
  @visibility("read")
  accessTier?: AccessTier;

  /**
   * Provides the identity based authentication settings for Azure Files.
   */
  azureFilesIdentityBasedAuthentication?: AzureFilesIdentityBasedAuthentication;

  /**
   * Allows https traffic only to storage service if sets to true.
   */
  @projectedName("json", "supportsHttpsTrafficOnly")
  enableHttpsTrafficOnly?: boolean;

  /**
   * Network rule set
   */
  @visibility("read")
  @projectedName("json", "networkAcls")
  networkRuleSet?: NetworkRuleSet;

  /**
   * Enables Secure File Transfer Protocol, if set to true
   */
  @projectedName("json", "isSftpEnabled")
  IsSftpEnabled?: boolean;

  /**
   * Enables local users feature, if set to true
   */
  @projectedName("json", "isLocalUserEnabled")
  IsLocalUserEnabled?: boolean;

  /**
   * Account HierarchicalNamespace enabled if sets to true.
   */
  @projectedName("json", "isHnsEnabled")
  IsHnsEnabled?: boolean;

  /**
   * Geo Replication Stats
   */
  @visibility("read")
  geoReplicationStats?: GeoReplicationStats;

  /**
   * If the failover is in progress, the value will be true, otherwise, it will be null.
   */
  @visibility("read")
  failoverInProgress?: boolean;

  /**
   * Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.
   */
  largeFileSharesState?: LargeFileSharesState;

  /**
   * List of private endpoint connection associated with the specified storage account
   */
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];

  /**
   * Maintains information about the network routing choice opted by the user for data transfer
   */
  routingPreference?: RoutingPreference;

  /**
   * Blob restore status
   */
  @visibility("read")
  blobRestoreStatus?: BlobRestoreStatus;

  /**
   * Allow or disallow public access to all blobs or containers in the storage account. The default interpretation is true for this property.
   */
  allowBlobPublicAccess?: boolean;

  /**
   * Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.
   */
  minimumTlsVersion?: MinimumTlsVersion;

  /**
   * Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.
   */
  allowSharedKeyAccess?: boolean;

  /**
   * NFS 3.0 protocol support enabled if set to true.
   */
  @projectedName("json", "isNfsV3Enabled")
  enableNfsV3?: boolean;

  /**
   * Allow or disallow cross AAD tenant object replication. The default interpretation is true for this property.
   */
  allowCrossTenantReplication?: boolean;

  /**
   * A boolean flag which indicates whether the default authentication is OAuth or not. The default interpretation is false for this property.
   */
  defaultToOAuthAuthentication?: boolean;

  /**
   * Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be 'Enabled' or 'Disabled'.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * The property is immutable and can only be set to true at the account creation time. When set to true, it enables object level immutability for all the containers in the account by default.
   */
  immutableStorageWithVersioning?: ImmutableStorageAccount;

  /**
   * Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.
   */
  allowedCopyScope?: AllowedCopyScope;

  /**
   * This property is readOnly and is set by server during asynchronous storage account sku conversion operations.
   */
  storageAccountSkuConversionStatus?: StorageAccountSkuConversionStatus;

  /**
   * Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.
   */
  dnsEndpointType?: DnsEndpointType;
}

/**
 * The URIs that are used to perform a retrieval of a public blob, queue, table, web or dfs object.
 */
model Endpoints {
  /**
   * Gets the blob endpoint.
   */
  @visibility("read")
  blob?: string;

  /**
   * Gets the queue endpoint.
   */
  @visibility("read")
  queue?: string;

  /**
   * Gets the table endpoint.
   */
  @visibility("read")
  table?: string;

  /**
   * Gets the file endpoint.
   */
  @visibility("read")
  file?: string;

  /**
   * Gets the web endpoint.
   */
  @visibility("read")
  web?: string;

  /**
   * Gets the dfs endpoint.
   */
  @visibility("read")
  dfs?: string;

  /**
   * Gets the microsoft routing storage endpoints.
   */
  microsoftEndpoints?: StorageAccountMicrosoftEndpoints;

  /**
   * Gets the internet routing storage endpoints
   */
  internetEndpoints?: StorageAccountInternetEndpoints;
}

/**
 * The URIs that are used to perform a retrieval of a public blob, queue, table, web or dfs object via a microsoft routing endpoint.
 */
model StorageAccountMicrosoftEndpoints {
  /**
   * Gets the blob endpoint.
   */
  @visibility("read")
  blob?: string;

  /**
   * Gets the queue endpoint.
   */
  @visibility("read")
  queue?: string;

  /**
   * Gets the table endpoint.
   */
  @visibility("read")
  table?: string;

  /**
   * Gets the file endpoint.
   */
  @visibility("read")
  file?: string;

  /**
   * Gets the web endpoint.
   */
  @visibility("read")
  web?: string;

  /**
   * Gets the dfs endpoint.
   */
  @visibility("read")
  dfs?: string;
}

/**
 * The URIs that are used to perform a retrieval of a public blob, file, web or dfs object via a internet routing endpoint.
 */
model StorageAccountInternetEndpoints {
  /**
   * Gets the blob endpoint.
   */
  @visibility("read")
  blob?: string;

  /**
   * Gets the file endpoint.
   */
  @visibility("read")
  file?: string;

  /**
   * Gets the web endpoint.
   */
  @visibility("read")
  web?: string;

  /**
   * Gets the dfs endpoint.
   */
  @visibility("read")
  dfs?: string;
}

/**
 * Storage account keys creation time.
 */
model KeyCreationTime {
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  key1?: utcDateTime;

  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  key2?: utcDateTime;
}

/**
 * Statistics related to replication for storage account's Blob, Table, Queue and File services. It is only available when geo-redundant replication is enabled for the storage account.
 */
model GeoReplicationStats {
  /**
   * The status of the secondary location. Possible values are: - Live: Indicates that the secondary location is active and operational. - Bootstrap: Indicates initial synchronization from the primary location to the secondary location is in progress.This typically occurs when replication is first enabled. - Unavailable: Indicates that the secondary location is temporarily unavailable.
   */
  @visibility("read")
  status?: GeoReplicationStatus;

  /**
   * All primary writes preceding this UTC date/time value are guaranteed to be available for read operations. Primary writes following this point in time may or may not be available for reads. Element may be default value if value of LastSyncTime is not available, this can happen if secondary is offline or we are in bootstrap.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastSyncTime?: utcDateTime;

  /**
   * A boolean flag which indicates whether or not account failover is supported for the account.
   */
  @visibility("read")
  canFailover?: boolean;
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
  actionRequired?: string;
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
 * Blob restore status.
 */
model BlobRestoreStatus {
  /**
   * The status of blob restore progress. Possible values are: - InProgress: Indicates that blob restore is ongoing. - Complete: Indicates that blob restore has been completed successfully. - Failed: Indicates that blob restore is failed.
   */
  @visibility("read")
  status?: BlobRestoreProgressStatus;

  /**
   * Failure reason when blob restore is failed.
   */
  @visibility("read")
  failureReason?: string;

  /**
   * Id for tracking blob restore request.
   */
  @visibility("read")
  restoreId?: string;

  /**
   * Blob restore request parameters.
   */
  @visibility("read")
  parameters?: BlobRestoreParameters;
}

/**
 * Blob restore parameters
 */
model BlobRestoreParameters {
  /**
   * Restore blob to the specified time.
   */
  @projectedName("json", "timetoRestore")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeToRestore: utcDateTime;

  /**
   * Blob ranges to restore.
   */
  blobRanges: BlobRestoreRange[];
}

/**
 * Blob range
 */
model BlobRestoreRange {
  /**
   * Blob start range. This is inclusive. Empty means account start.
   */
  startRange: string;

  /**
   * Blob end range. This is exclusive. Empty means account end.
   */
  endRange: string;
}

/**
 * This defines the sku conversion status object for asynchronous sku conversions.
 */
model StorageAccountSkuConversionStatus {
  /**
   * This property indicates the current sku conversion status.
   */
  @visibility("read")
  skuConversionStatus?: SkuConversionStatus;

  /**
   * This property represents the target sku name to which the account sku is being converted asynchronously.
   */
  targetSkuName?: SkuName;

  /**
   * This property represents the sku conversion start time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * This property represents the sku conversion end time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;
}

/**
 * The parameters that can be provided when updating the storage account properties.
 */
model StorageAccountUpdateParameters {
  /**
   * Gets or sets the SKU name. Note that the SKU name cannot be updated to Standard_ZRS, Premium_LRS or Premium_ZRS, nor can accounts of those SKU names be updated to any other value.
   */
  sku?: Sku;

  /**
   * Gets or sets a list of key value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater in length than 128 characters and a value no greater in length than 256 characters.
   */
  tags?: Record<string>;

  /**
   * The identity of the resource.
   */
  identity?: Identity;

  /**
   * The parameters used when updating a storage account.
   */
  properties?: StorageAccountPropertiesUpdateParameters;

  /**
   * Optional. Indicates the type of storage account. Currently only StorageV2 value supported by server.
   */
  kind?: Kind;
}

/**
 * The parameters used when updating a storage account.
 */
model StorageAccountPropertiesUpdateParameters {
  /**
   * Custom domain assigned to the storage account by the user. Name is the CNAME source. Only one custom domain is supported per storage account at this time. To clear the existing custom domain, use an empty string for the custom domain name property.
   */
  customDomain?: CustomDomain;

  /**
   * Not applicable. Azure Storage encryption at rest is enabled by default for all storage accounts and cannot be disabled.
   */
  encryption?: Encryption;

  /**
   * SasPolicy assigned to the storage account.
   */
  sasPolicy?: SasPolicy;

  /**
   * KeyPolicy assigned to the storage account.
   */
  keyPolicy?: KeyPolicy;

  /**
   * Required for storage accounts where kind = BlobStorage. The access tier is used for billing. The 'Premium' access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
   */
  accessTier?: AccessTier;

  /**
   * Provides the identity based authentication settings for Azure Files.
   */
  azureFilesIdentityBasedAuthentication?: AzureFilesIdentityBasedAuthentication;

  /**
   * Allows https traffic only to storage service if sets to true.
   */
  @projectedName("json", "supportsHttpsTrafficOnly")
  enableHttpsTrafficOnly?: boolean;

  /**
   * Enables Secure File Transfer Protocol, if set to true
   */
  @projectedName("json", "isSftpEnabled")
  IsSftpEnabled?: boolean;

  /**
   * Enables local users feature, if set to true
   */
  @projectedName("json", "isLocalUserEnabled")
  IsLocalUserEnabled?: boolean;

  /**
   * Network rule set
   */
  @projectedName("json", "networkAcls")
  networkRuleSet?: NetworkRuleSet;

  /**
   * Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.
   */
  largeFileSharesState?: LargeFileSharesState;

  /**
   * Maintains information about the network routing choice opted by the user for data transfer
   */
  routingPreference?: RoutingPreference;

  /**
   * Allow or disallow public access to all blobs or containers in the storage account. The default interpretation is true for this property.
   */
  allowBlobPublicAccess?: boolean;

  /**
   * Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.
   */
  minimumTlsVersion?: MinimumTlsVersion;

  /**
   * Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.
   */
  allowSharedKeyAccess?: boolean;

  /**
   * Allow or disallow cross AAD tenant object replication. The default interpretation is true for this property.
   */
  allowCrossTenantReplication?: boolean;

  /**
   * A boolean flag which indicates whether the default authentication is OAuth or not. The default interpretation is false for this property.
   */
  defaultToOAuthAuthentication?: boolean;

  /**
   * Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be 'Enabled' or 'Disabled'.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * The property is immutable and can only be set to true at the account creation time. When set to true, it enables object level immutability for all the containers in the account by default.
   */
  immutableStorageWithVersioning?: ImmutableStorageAccount;

  /**
   * Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.
   */
  allowedCopyScope?: AllowedCopyScope;

  /**
   * Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.
   */
  dnsEndpointType?: DnsEndpointType;
}

/**
 * Attributes of a deleted storage account.
 */
model DeletedAccountProperties {
  /**
   * Full resource id of the original storage account.
   */
  @visibility("read")
  storageAccountResourceId?: string;

  /**
   * Location of the deleted account.
   */
  @visibility("read")
  location?: string;

  /**
   * Can be used to attempt recovering this deleted account via PutStorageAccount API.
   */
  @visibility("read")
  restoreReference?: string;

  /**
   * Creation time of the deleted account.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  /**
   * Deletion time of the deleted account.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deletionTime?: utcDateTime;
}

/**
 * Error response body contract.
 */
model ErrorResponseBody {
  /**
   * An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
   */
  code?: string;

  /**
   * A message describing the error, intended to be suitable for display in a user interface.
   */
  message?: string;
}

/**
 * The response from the ListKeys operation.
 */
@pagedResult
model StorageAccountListKeysResult {
  /**
   * Gets the list of storage account keys and their properties for the specified storage account.
   */
  @visibility("read")
  @items
  keys?: StorageAccountKey[];
}

/**
 * An access key for the storage account.
 */
model StorageAccountKey {
  /**
   * Name of the key.
   */
  @visibility("read")
  keyName?: string;

  /**
   * Base 64-encoded value of the key.
   */
  @visibility("read")
  value?: string;

  /**
   * Permissions for the key -- read-only or full permissions.
   */
  @visibility("read")
  permissions?: KeyPermission;

  /**
   * Creation time of the key, in round trip date format.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;
}

/**
 * The parameters used to regenerate the storage account key.
 */
model StorageAccountRegenerateKeyParameters {
  /**
   * The name of storage keys that want to be regenerated, possible values are key1, key2, kerb1, kerb2.
   */
  keyName: string;
}

/**
 * The response from the List Usages operation.
 */
@pagedResult
model UsageListResult {
  /**
   * Gets or sets the list of Storage Resource Usages.
   */
  @items
  value?: Usage[];
}

/**
 * Describes Storage Resource Usage.
 */
model Usage {
  /**
   * Gets the unit of measurement.
   */
  @visibility("read")
  unit?: UsageUnit;

  /**
   * Gets the current count of the allocated resources in the subscription.
   */
  @visibility("read")
  currentValue?: int32;

  /**
   * Gets the maximum count of the resources that can be allocated in the subscription.
   */
  @visibility("read")
  limit?: int32;

  /**
   * Gets the name of the type of usage.
   */
  @visibility("read")
  name?: UsageName;
}

/**
 * The usage names that can be used; currently limited to StorageAccount.
 */
model UsageName {
  /**
   * Gets a string describing the resource name.
   */
  @visibility("read")
  value?: string;

  /**
   * Gets a localized string describing the resource name.
   */
  @visibility("read")
  localizedValue?: string;
}

/**
 * The parameters to list SAS credentials of a storage account.
 */
model AccountSasParameters {
  /**
   * The signed services accessible with the account SAS. Possible values include: Blob (b), Queue (q), Table (t), File (f).
   */
  @projectedName("json", "signedServices")
  services: Services;

  /**
   * The signed resource types that are accessible with the account SAS. Service (s): Access to service-level APIs; Container (c): Access to container-level APIs; Object (o): Access to object-level APIs for blobs, queue messages, table entities, and files.
   */
  @projectedName("json", "signedResourceTypes")
  resourceTypes: SignedResourceTypes;

  /**
   * The signed permissions for the account SAS. Possible values include: Read (r), Write (w), Delete (d), List (l), Add (a), Create (c), Update (u) and Process (p).
   */
  @projectedName("json", "signedPermission")
  permissions: Permissions;

  /**
   * An IP address or a range of IP addresses from which to accept requests.
   */
  @projectedName("json", "signedIp")
  IPAddressOrRange?: string;

  /**
   * The protocol permitted for a request made with the account SAS.
   */
  @projectedName("json", "signedProtocol")
  protocols?: HttpProtocol;

  /**
   * The time at which the SAS becomes valid.
   */
  @projectedName("json", "signedStart")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  sharedAccessStartTime?: utcDateTime;

  /**
   * The time at which the shared access signature becomes invalid.
   */
  @projectedName("json", "signedExpiry")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  sharedAccessExpiryTime: utcDateTime;

  /**
   * The key to sign the account SAS token with.
   */
  keyToSign?: string;
}

/**
 * The List SAS credentials operation response.
 */
model ListAccountSasResponse {
  /**
   * List SAS credentials of storage account.
   */
  @visibility("read")
  accountSasToken?: string;
}

/**
 * The parameters to list service SAS credentials of a specific resource.
 */
model ServiceSasParameters {
  /**
   * The canonical path to the signed resource.
   */
  canonicalizedResource: string;

  /**
   * The signed services accessible with the service SAS. Possible values include: Blob (b), Container (c), File (f), Share (s).
   */
  @projectedName("json", "signedResource")
  resource?: SignedResource;

  /**
   * The signed permissions for the service SAS. Possible values include: Read (r), Write (w), Delete (d), List (l), Add (a), Create (c), Update (u) and Process (p).
   */
  @projectedName("json", "signedPermission")
  permissions?: Permissions;

  /**
   * An IP address or a range of IP addresses from which to accept requests.
   */
  @projectedName("json", "signedIp")
  IPAddressOrRange?: string;

  /**
   * The protocol permitted for a request made with the account SAS.
   */
  @projectedName("json", "signedProtocol")
  protocols?: HttpProtocol;

  /**
   * The time at which the SAS becomes valid.
   */
  @projectedName("json", "signedStart")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  sharedAccessStartTime?: utcDateTime;

  /**
   * The time at which the shared access signature becomes invalid.
   */
  @projectedName("json", "signedExpiry")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  sharedAccessExpiryTime?: utcDateTime;

  /**
   * A unique value up to 64 characters in length that correlates to an access policy specified for the container, queue, or table.
   */
  @maxLength(64)
  @projectedName("json", "signedIdentifier")
  identifier?: string;

  /**
   * The start of partition key.
   */
  @projectedName("json", "startPk")
  partitionKeyStart?: string;

  /**
   * The end of partition key.
   */
  @projectedName("json", "endPk")
  partitionKeyEnd?: string;

  /**
   * The start of row key.
   */
  @projectedName("json", "startRk")
  rowKeyStart?: string;

  /**
   * The end of row key.
   */
  @projectedName("json", "endRk")
  rowKeyEnd?: string;

  /**
   * The key to sign the account SAS token with.
   */
  keyToSign?: string;

  /**
   * The response header override for cache control.
   */
  @projectedName("json", "rscc")
  cacheControl?: string;

  /**
   * The response header override for content disposition.
   */
  @projectedName("json", "rscd")
  contentDisposition?: string;

  /**
   * The response header override for content encoding.
   */
  @projectedName("json", "rsce")
  contentEncoding?: string;

  /**
   * The response header override for content language.
   */
  @projectedName("json", "rscl")
  contentLanguage?: string;

  /**
   * The response header override for content type.
   */
  @projectedName("json", "rsct")
  contentType?: string;
}

/**
 * The List service SAS credentials operation response.
 */
model ListServiceSasResponse {
  /**
   * List service SAS credentials of specific resource.
   */
  @visibility("read")
  serviceSasToken?: string;
}

/**
 * The Storage Account ManagementPolicy properties.
 */
model ManagementPolicyProperties {
  /**
   * Returns the date and time the ManagementPolicies was last modified.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * The Storage Account ManagementPolicy, in JSON format. See more details in: https://docs.microsoft.com/en-us/azure/storage/common/storage-lifecycle-managment-concepts.
   */
  policy: ManagementPolicySchema;
}

/**
 * The Storage Account ManagementPolicies Rules. See more details in: https://docs.microsoft.com/en-us/azure/storage/common/storage-lifecycle-managment-concepts.
 */
model ManagementPolicySchema {
  /**
   * The Storage Account ManagementPolicies Rules. See more details in: https://docs.microsoft.com/en-us/azure/storage/common/storage-lifecycle-managment-concepts.
   */
  rules: ManagementPolicyRule[];
}

/**
 * An object that wraps the Lifecycle rule. Each rule is uniquely defined by name.
 */
model ManagementPolicyRule {
  /**
   * Rule is enabled if set to true.
   */
  enabled?: boolean;

  /**
   * A rule name can contain any combination of alpha numeric characters. Rule name is case-sensitive. It must be unique within a policy.
   */
  name: string;

  /**
   * The valid value is Lifecycle
   */
  type: RuleType;

  /**
   * An object that defines the Lifecycle rule.
   */
  definition: ManagementPolicyDefinition;
}

/**
 * An object that defines the Lifecycle rule. Each definition is made up with a filters set and an actions set.
 */
model ManagementPolicyDefinition {
  /**
   * An object that defines the action set.
   */
  actions: ManagementPolicyAction;

  /**
   * An object that defines the filter set.
   */
  filters?: ManagementPolicyFilter;
}

/**
 * Actions are applied to the filtered blobs when the execution condition is met.
 */
model ManagementPolicyAction {
  /**
   * The management policy action for base blob
   */
  baseBlob?: ManagementPolicyBaseBlob;

  /**
   * The management policy action for snapshot
   */
  snapshot?: ManagementPolicySnapShot;

  /**
   * The management policy action for version
   */
  version?: ManagementPolicyVersion;
}

/**
 * Management policy action for base blob.
 */
model ManagementPolicyBaseBlob {
  /**
   * The function to tier blobs to cool storage.
   */
  tierToCool?: DateAfterModification;

  /**
   * The function to tier blobs to archive storage.
   */
  tierToArchive?: DateAfterModification;

  /**
   * The function to tier blobs to cold storage.
   */
  tierToCold?: DateAfterModification;

  /**
   * The function to tier blobs to hot storage. This action can only be used with Premium Block Blob Storage Accounts
   */
  tierToHot?: DateAfterModification;

  /**
   * The function to delete the blob
   */
  delete?: DateAfterModification;

  /**
   * This property enables auto tiering of a blob from cool to hot on a blob access. This property requires tierToCool.daysAfterLastAccessTimeGreaterThan.
   */
  enableAutoTierToHotFromCool?: boolean;
}

/**
 * Object to define the base blob action conditions. Properties daysAfterModificationGreaterThan, daysAfterLastAccessTimeGreaterThan and daysAfterCreationGreaterThan are mutually exclusive. The daysAfterLastTierChangeGreaterThan property is only applicable for tierToArchive actions which requires daysAfterModificationGreaterThan to be set, also it cannot be used in conjunction with daysAfterLastAccessTimeGreaterThan or daysAfterCreationGreaterThan.
 */
model DateAfterModification {
  /**
   * Value indicating the age in days after last modification
   */
  daysAfterModificationGreaterThan?: float32;

  /**
   * Value indicating the age in days after last blob access. This property can only be used in conjunction with last access time tracking policy
   */
  daysAfterLastAccessTimeGreaterThan?: float32;

  /**
   * Value indicating the age in days after last blob tier change time. This property is only applicable for tierToArchive actions and requires daysAfterModificationGreaterThan to be set for baseBlobs based actions. The blob will be archived if both the conditions are satisfied.
   */
  daysAfterLastTierChangeGreaterThan?: float32;

  /**
   * Value indicating the age in days after blob creation.
   */
  daysAfterCreationGreaterThan?: float32;
}

/**
 * Management policy action for snapshot.
 */
model ManagementPolicySnapShot {
  /**
   * The function to tier blob snapshot to cool storage.
   */
  tierToCool?: DateAfterCreation;

  /**
   * The function to tier blob snapshot to archive storage.
   */
  tierToArchive?: DateAfterCreation;

  /**
   * The function to tier blobs to cold storage.
   */
  tierToCold?: DateAfterCreation;

  /**
   * The function to tier blobs to hot storage. This action can only be used with Premium Block Blob Storage Accounts
   */
  tierToHot?: DateAfterCreation;

  /**
   * The function to delete the blob snapshot
   */
  delete?: DateAfterCreation;
}

/**
 * Object to define snapshot and version action conditions.
 */
model DateAfterCreation {
  /**
   * Value indicating the age in days after creation
   */
  daysAfterCreationGreaterThan: float32;

  /**
   * Value indicating the age in days after last blob tier change time. This property is only applicable for tierToArchive actions and requires daysAfterCreationGreaterThan to be set for snapshots and blob version based actions. The blob will be archived if both the conditions are satisfied.
   */
  daysAfterLastTierChangeGreaterThan?: float32;
}

/**
 * Management policy action for blob version.
 */
model ManagementPolicyVersion {
  /**
   * The function to tier blob version to cool storage.
   */
  tierToCool?: DateAfterCreation;

  /**
   * The function to tier blob version to archive storage.
   */
  tierToArchive?: DateAfterCreation;

  /**
   * The function to tier blobs to cold storage.
   */
  tierToCold?: DateAfterCreation;

  /**
   * The function to tier blobs to hot storage. This action can only be used with Premium Block Blob Storage Accounts
   */
  tierToHot?: DateAfterCreation;

  /**
   * The function to delete the blob version
   */
  delete?: DateAfterCreation;
}

/**
 * Filters limit rule actions to a subset of blobs within the storage account. If multiple filters are defined, a logical AND is performed on all filters.
 */
model ManagementPolicyFilter {
  /**
   * An array of strings for prefixes to be match.
   */
  prefixMatch?: string[];

  /**
   * An array of predefined enum values. Currently blockBlob supports all tiering and delete actions. Only delete actions are supported for appendBlob.
   */
  blobTypes: string[];

  /**
   * An array of blob index tag based filters, there can be at most 10 tag filters
   */
  blobIndexMatch?: TagFilter[];
}

/**
 * Blob index tag based filtering for blob objects
 */
model TagFilter {
  /**
   * This is the filter tag name, it can have 1 - 128 characters
   */
  @maxLength(128)
  @minLength(1)
  name: string;

  /**
   * This is the comparison operator which is used for object comparison and filtering. Only == (equality operator) is currently supported
   */
  `op`: string;

  /**
   * This is the filter tag value field used for tag based filtering, it can have 0 - 256 characters
   */
  @maxLength(256)
  value: string;
}

/**
 * The storage account blob inventory policy properties.
 */
model BlobInventoryPolicyProperties {
  /**
   * Returns the last modified date and time of the blob inventory policy.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * The storage account blob inventory policy object. It is composed of policy rules.
   */
  policy: BlobInventoryPolicySchema;
}

/**
 * The storage account blob inventory policy rules.
 */
model BlobInventoryPolicySchema {
  /**
   * Policy is enabled if set to true.
   */
  enabled: boolean;

  /**
   * Deprecated Property from API version 2021-04-01 onwards, the required destination container name must be specified at the rule level 'policy.rule.destination'
   */
  @visibility("read")
  destination?: string;

  /**
   * The valid value is Inventory
   */
  type: InventoryRuleType;

  /**
   * The storage account blob inventory policy rules. The rule is applied when it is enabled.
   */
  rules: BlobInventoryPolicyRule[];
}

/**
 * An object that wraps the blob inventory rule. Each rule is uniquely defined by name.
 */
model BlobInventoryPolicyRule {
  /**
   * Rule is enabled when set to true.
   */
  enabled: boolean;

  /**
   * A rule name can contain any combination of alpha numeric characters. Rule name is case-sensitive. It must be unique within a policy.
   */
  name: string;

  /**
   * Container name where blob inventory files are stored. Must be pre-created.
   */
  destination: string;

  /**
   * An object that defines the blob inventory policy rule.
   */
  definition: BlobInventoryPolicyDefinition;
}

/**
 * An object that defines the blob inventory rule.
 */
model BlobInventoryPolicyDefinition {
  /**
   * An object that defines the filter set.
   */
  filters?: BlobInventoryPolicyFilter;

  /**
   * This is a required field, it specifies the format for the inventory files.
   */
  format: Format;

  /**
   * This is a required field. This field is used to schedule an inventory formation.
   */
  schedule: Schedule;

  /**
   * This is a required field. This field specifies the scope of the inventory created either at the blob or container level.
   */
  objectType: ObjectType;

  /**
   * This is a required field. This field specifies the fields and properties of the object to be included in the inventory. The Schema field value 'Name' is always required. The valid values for this field for the 'Blob' definition.objectType include 'Name, Creation-Time, Last-Modified, Content-Length, Content-MD5, BlobType, AccessTier, AccessTierChangeTime, AccessTierInferred, Tags, Expiry-Time, hdi_isfolder, Owner, Group, Permissions, Acl, Snapshot, VersionId, IsCurrentVersion, Metadata, LastAccessTime, Tags, Etag, ContentType, ContentEncoding, ContentLanguage, ContentCRC64, CacheControl, ContentDisposition, LeaseStatus, LeaseState, LeaseDuration, ServerEncrypted, Deleted, DeletionId, DeletedTime, RemainingRetentionDays, ImmutabilityPolicyUntilDate, ImmutabilityPolicyMode, LegalHold, CopyId, CopyStatus, CopySource, CopyProgress, CopyCompletionTime, CopyStatusDescription, CustomerProvidedKeySha256, RehydratePriority, ArchiveStatus, XmsBlobSequenceNumber, EncryptionScope, IncrementalCopy, TagCount'. For Blob object type schema field value 'DeletedTime' is applicable only for Hns enabled accounts. The valid values for 'Container' definition.objectType include 'Name, Last-Modified, Metadata, LeaseStatus, LeaseState, LeaseDuration, PublicAccess, HasImmutabilityPolicy, HasLegalHold, Etag, DefaultEncryptionScope, DenyEncryptionScopeOverride, ImmutableStorageWithVersioningEnabled, Deleted, Version, DeletedTime, RemainingRetentionDays'. Schema field values 'Expiry-Time, hdi_isfolder, Owner, Group, Permissions, Acl, DeletionId' are valid only for Hns enabled accounts.Schema field values 'Tags, TagCount' are only valid for Non-Hns accounts.
   */
  schemaFields: string[];
}

/**
 * An object that defines the blob inventory rule filter conditions. For 'Blob' definition.objectType all filter properties are applicable, 'blobTypes' is required and others are optional. For 'Container' definition.objectType only prefixMatch is applicable and is optional.
 */
model BlobInventoryPolicyFilter {
  /**
   * An array of strings with maximum 10 blob prefixes to be included in the inventory.
   */
  prefixMatch?: string[];

  /**
   * An array of strings with maximum 10 blob prefixes to be excluded from the inventory.
   */
  excludePrefix?: string[];

  /**
   * An array of predefined enum values. Valid values include blockBlob, appendBlob, pageBlob. Hns accounts does not support pageBlobs. This field is required when definition.objectType property is set to 'Blob'.
   */
  blobTypes?: string[];

  /**
   * Includes blob versions in blob inventory when value is set to true. The definition.schemaFields values 'VersionId and IsCurrentVersion' are required if this property is set to true, else they must be excluded.
   */
  includeBlobVersions?: boolean;

  /**
   * Includes blob snapshots in blob inventory when value is set to true. The definition.schemaFields value 'Snapshot' is required if this property is set to true, else it must be excluded.
   */
  includeSnapshots?: boolean;

  /**
   * For 'Container' definition.objectType the definition.schemaFields must include 'Deleted, Version, DeletedTime and RemainingRetentionDays'. For 'Blob' definition.objectType and HNS enabled storage accounts the definition.schemaFields must include 'DeletionId, Deleted, DeletedTime and RemainingRetentionDays' and for Hns disabled accounts the definition.schemaFields must include 'Deleted and RemainingRetentionDays', else it must be excluded.
   */
  includeDeleted?: boolean;
}

/**
 * An error response from the Storage service.
 */
@error
model CloudError {
  /**
   * An error response from the Storage service.
   */
  error?: CloudErrorBody;
}

/**
 * An error response from the Storage service.
 */
model CloudErrorBody {
  /**
   * An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
   */
  code?: string;

  /**
   * A message describing the error, intended to be suitable for display in a user interface.
   */
  message?: string;

  /**
   * The target of the particular error. For example, the name of the property in error.
   */
  target?: string;

  /**
   * A list of additional details about the error.
   */
  details?: CloudErrorBody[];
}

/**
 * A list of private link resources
 */
model PrivateLinkResourceListResult {
  /**
   * Array of private link resources
   */
  value?: PrivateLinkResource[];
}

/**
 * A private link resource
 */
model PrivateLinkResource extends Resource {
  /**
   * Resource properties.
   */
  properties?: PrivateLinkResourceProperties;
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
 * The Storage Account ObjectReplicationPolicy properties.
 */
model ObjectReplicationPolicyProperties {
  /**
   * A unique id for object replication policy.
   */
  @visibility("read")
  policyId?: string;

  /**
   * Indicates when the policy is enabled on the source account.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  enabledTime?: utcDateTime;

  /**
   * Required. Source account name. It should be full resource id if allowCrossTenantReplication set to false.
   */
  sourceAccount: string;

  /**
   * Required. Destination account name. It should be full resource id if allowCrossTenantReplication set to false.
   */
  destinationAccount: string;

  /**
   * The storage account object replication rules.
   */
  rules?: ObjectReplicationPolicyRule[];
}

/**
 * The replication policy rule between two containers.
 */
model ObjectReplicationPolicyRule {
  /**
   * Rule Id is auto-generated for each new rule on destination account. It is required for put policy on source account.
   */
  ruleId?: string;

  /**
   * Required. Source container name.
   */
  sourceContainer: string;

  /**
   * Required. Destination container name.
   */
  destinationContainer: string;

  /**
   * Optional. An object that defines the filter set.
   */
  filters?: ObjectReplicationPolicyFilter;
}

/**
 * Filters limit replication to a subset of blobs within the storage account. A logical OR is performed on values in the filter. If multiple filters are defined, a logical AND is performed on all filters.
 */
model ObjectReplicationPolicyFilter {
  /**
   * Optional. Filters the results to replicate only blobs whose names begin with the specified prefix.
   */
  prefixMatch?: string[];

  /**
   * Blobs created after the time will be replicated to the destination. It must be in datetime format 'yyyy-MM-ddTHH:mm:ssZ'. Example: 2020-02-19T16:05:00Z
   */
  minCreationTime?: string;
}

/**
 * The Storage Account Local User properties.
 */
model LocalUserProperties {
  /**
   * The permission scopes of the local user.
   */
  permissionScopes?: PermissionScope[];

  /**
   * Optional, local user home directory.
   */
  homeDirectory?: string;

  /**
   * Optional, local user ssh authorized keys for SFTP.
   */
  sshAuthorizedKeys?: SshPublicKey[];

  /**
   * A unique Security Identifier that is generated by the server.
   */
  @visibility("read")
  sid?: string;

  /**
   * Indicates whether shared key exists. Set it to false to remove existing shared key.
   */
  hasSharedKey?: boolean;

  /**
   * Indicates whether ssh key exists. Set it to false to remove existing SSH key.
   */
  hasSshKey?: boolean;

  /**
   * Indicates whether ssh password exists. Set it to false to remove existing SSH password.
   */
  hasSshPassword?: boolean;
}

model PermissionScope {
  /**
   * The permissions for the local user. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c).
   */
  permissions: string;

  /**
   * The service used by the local user, e.g. blob, file.
   */
  service: string;

  /**
   * The name of resource, normally the container name or the file share name, used by the local user.
   */
  resourceName: string;
}

model SshPublicKey {
  /**
   * Optional. It is used to store the function/usage of the key
   */
  description?: string;

  /**
   * Ssh public key base64 encoded. The format should be: '<keyType> <keyData>', e.g. ssh-rsa AAAABBBB
   */
  key?: string;
}

/**
 * The Storage Account Local User keys.
 */
model LocalUserKeys {
  /**
   * Optional, local user ssh authorized keys for SFTP.
   */
  sshAuthorizedKeys?: SshPublicKey[];

  /**
   * Auto generated by the server for SMB authentication.
   */
  @visibility("read")
  sharedKey?: string;
}

/**
 * The secrets of Storage Account Local User.
 */
model LocalUserRegeneratePasswordResult {
  /**
   * Auto generated password by the server for SSH authentication if hasSshPassword is set to true on the creation of local user.
   */
  @visibility("read")
  sshPassword?: string;
}

/**
 * Properties of the encryption scope.
 */
model EncryptionScopeProperties {
  /**
   * The provider for the encryption scope. Possible values (case-insensitive):  Microsoft.Storage, Microsoft.KeyVault.
   */
  source?: EncryptionScopeSource;

  /**
   * The state of the encryption scope. Possible values (case-insensitive):  Enabled, Disabled.
   */
  state?: EncryptionScopeState;

  /**
   * Gets the creation date and time of the encryption scope in UTC.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  /**
   * Gets the last modification date and time of the encryption scope in UTC.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * The key vault properties for the encryption scope. This is a required field if encryption scope 'source' attribute is set to 'Microsoft.KeyVault'.
   */
  keyVaultProperties?: EncryptionScopeKeyVaultProperties;

  /**
   * A boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest.
   */
  requireInfrastructureEncryption?: boolean;
}

/**
 * The key vault properties for the encryption scope. This is a required field if encryption scope 'source' attribute is set to 'Microsoft.KeyVault'.
 */
model EncryptionScopeKeyVaultProperties {
  /**
   * The object identifier for a key vault key object. When applied, the encryption scope will use the key referenced by the identifier to enable customer-managed key support on this encryption scope.
   */
  keyUri?: string;

  /**
   * The object identifier of the current versioned Key Vault Key in use.
   */
  @visibility("read")
  currentVersionedKeyIdentifier?: string;

  /**
   * Timestamp of last rotation of the Key Vault Key.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastKeyRotationTimestamp?: utcDateTime;
}

/**
 * The properties of a storage account’s Blob service.
 */
model BlobServicePropertiesProperties {
  /**
   * Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.
   */
  cors?: CorsRules;

  /**
   * DefaultServiceVersion indicates the default version to use for requests to the Blob service if an incoming request’s version is not specified. Possible values include version 2008-10-27 and all more recent versions.
   */
  defaultServiceVersion?: string;

  /**
   * The blob service properties for blob soft delete.
   */
  deleteRetentionPolicy?: DeleteRetentionPolicy;

  /**
   * Versioning is enabled if set to true.
   */
  isVersioningEnabled?: boolean;

  /**
   * Deprecated in favor of isVersioningEnabled property.
   */
  automaticSnapshotPolicyEnabled?: boolean;

  /**
   * The blob service properties for change feed events.
   */
  changeFeed?: ChangeFeed;

  /**
   * The blob service properties for blob restore policy.
   */
  restorePolicy?: RestorePolicyProperties;

  /**
   * The blob service properties for container soft delete.
   */
  containerDeleteRetentionPolicy?: DeleteRetentionPolicy;

  /**
   * The blob service property to configure last access time based tracking policy.
   */
  lastAccessTimeTrackingPolicy?: LastAccessTimeTrackingPolicy;
}

/**
 * Sets the CORS rules. You can include up to five CorsRule elements in the request.
 */
model CorsRules {
  /**
   * The List of CORS rules. You can include up to five CorsRule elements in the request.
   */
  corsRules?: CorsRule[];
}

/**
 * Specifies a CORS rule for the Blob service.
 */
model CorsRule {
  /**
   * Required if CorsRule element is present. A list of origin domains that will be allowed via CORS, or "*" to allow all domains
   */
  allowedOrigins: string[];

  /**
   * Required if CorsRule element is present. A list of HTTP methods that are allowed to be executed by the origin.
   */
  allowedMethods: AllowedMethods[];

  /**
   * Required if CorsRule element is present. The number of seconds that the client/browser should cache a preflight response.
   */
  maxAgeInSeconds: int32;

  /**
   * Required if CorsRule element is present. A list of response headers to expose to CORS clients.
   */
  exposedHeaders: string[];

  /**
   * Required if CorsRule element is present. A list of headers allowed to be part of the cross-origin request.
   */
  allowedHeaders: string[];
}

/**
 * The service properties for soft delete.
 */
model DeleteRetentionPolicy {
  /**
   * Indicates whether DeleteRetentionPolicy is enabled.
   */
  enabled?: boolean;

  /**
   * Indicates the number of days that the deleted item should be retained. The minimum specified value can be 1 and the maximum value can be 365.
   */
  @maxValue(365)
  @minValue(1)
  days?: int32;

  /**
   * This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used blob restore policy. This property only applies to blob service and does not apply to containers or file share.
   */
  allowPermanentDelete?: boolean;
}

/**
 * The blob service properties for change feed events.
 */
model ChangeFeed {
  /**
   * Indicates whether change feed event logging is enabled for the Blob service.
   */
  enabled?: boolean;

  /**
   * Indicates the duration of changeFeed retention in days. Minimum value is 1 day and maximum value is 146000 days (400 years). A null value indicates an infinite retention of the change feed.
   */
  @maxValue(146000)
  @minValue(1)
  retentionInDays?: int32;
}

/**
 * The blob service properties for blob restore policy
 */
model RestorePolicyProperties {
  /**
   * Blob restore is enabled if set to true.
   */
  enabled: boolean;

  /**
   * how long this blob can be restored. It should be great than zero and less than DeleteRetentionPolicy.days.
   */
  @maxValue(365)
  @minValue(1)
  days?: int32;

  /**
   * Deprecated in favor of minRestoreTime property.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastEnabledTime?: utcDateTime;

  /**
   * Returns the minimum date and time that the restore can be started.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  minRestoreTime?: utcDateTime;
}

/**
 * The blob service properties for Last access time based tracking policy.
 */
model LastAccessTimeTrackingPolicy {
  /**
   * When set to true last access time based tracking is enabled.
   */
  enable: boolean;

  /**
   * Name of the policy. The valid value is AccessTimeTracking. This field is currently read only
   */
  name?: Name;

  /**
   * The field specifies blob object tracking granularity in days, typically how often the blob object should be tracked.This field is currently read only with value as 1
   */
  trackingGranularityInDays?: int32;

  /**
   * An array of predefined supported blob types. Only blockBlob is the supported value. This field is currently read only
   */
  blobType?: string[];
}

/**
 * The properties of a container.
 */
model ContainerProperties {
  /**
   * The version of the deleted blob container.
   */
  @visibility("read")
  version?: string;

  /**
   * Indicates whether the blob container was deleted.
   */
  @visibility("read")
  deleted?: boolean;

  /**
   * Blob container deletion time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deletedTime?: utcDateTime;

  /**
   * Remaining retention days for soft deleted blob container.
   */
  @visibility("read")
  remainingRetentionDays?: int32;

  /**
   * Default the container to use specified encryption scope for all writes.
   */
  defaultEncryptionScope?: string;

  /**
   * Block override of encryption scope from the container default.
   */
  denyEncryptionScopeOverride?: boolean;

  /**
   * Specifies whether data in the container may be accessed publicly and the level of access.
   */
  publicAccess?: PublicAccess;

  /**
   * Returns the date and time the container was last modified.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * The lease status of the container.
   */
  @visibility("read")
  leaseStatus?: LeaseStatus;

  /**
   * Lease state of the container.
   */
  @visibility("read")
  leaseState?: LeaseState;

  /**
   * Specifies whether the lease on a container is of infinite or fixed duration, only when the container is leased.
   */
  @visibility("read")
  leaseDuration?: LeaseDuration;

  /**
   * A name-value pair to associate with the container as metadata.
   */
  metadata?: Record<string>;

  /**
   * The ImmutabilityPolicy property of the container.
   */
  @visibility("read")
  immutabilityPolicy?: ImmutabilityPolicyProperties;

  /**
   * The LegalHold property of the container.
   */
  @visibility("read")
  legalHold?: LegalHoldProperties;

  /**
   * The hasLegalHold public property is set to true by SRP if there are at least one existing tag. The hasLegalHold public property is set to false by SRP if all existing legal hold tags are cleared out. There can be a maximum of 1000 blob containers with hasLegalHold=true for a given account.
   */
  @visibility("read")
  hasLegalHold?: boolean;

  /**
   * The hasImmutabilityPolicy public property is set to true by SRP if ImmutabilityPolicy has been created for this container. The hasImmutabilityPolicy public property is set to false by SRP if ImmutabilityPolicy has not been created for this container.
   */
  @visibility("read")
  hasImmutabilityPolicy?: boolean;

  /**
   * The object level immutability property of the container. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.
   */
  immutableStorageWithVersioning?: ImmutableStorageWithVersioning;

  /**
   * Enable NFSv3 root squash on blob container.
   */
  enableNfsV3RootSquash?: boolean;

  /**
   * Enable NFSv3 all squash on blob container.
   */
  enableNfsV3AllSquash?: boolean;
}

/**
 * The properties of an ImmutabilityPolicy of a blob container.
 */
model ImmutabilityPolicyProperties {
  /**
   * The properties of an ImmutabilityPolicy of a blob container.
   */
  properties?: ImmutabilityPolicyProperty;

  /**
   * ImmutabilityPolicy Etag.
   */
  @visibility("read")
  etag?: string;

  /**
   * The ImmutabilityPolicy update history of the blob container.
   */
  @visibility("read")
  updateHistory?: UpdateHistoryProperty[];
}

/**
 * The properties of an ImmutabilityPolicy of a blob container.
 */
model ImmutabilityPolicyProperty {
  /**
   * The immutability period for the blobs in the container since the policy creation, in days.
   */
  immutabilityPeriodSinceCreationInDays?: int32;

  /**
   * The ImmutabilityPolicy state of a blob container, possible values include: Locked and Unlocked.
   */
  @visibility("read")
  state?: ImmutabilityPolicyState;

  /**
   * This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API.
   */
  allowProtectedAppendWrites?: boolean;

  /**
   * This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both 'Append and Bock Blobs' while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The 'allowProtectedAppendWrites' and 'allowProtectedAppendWritesAll' properties are mutually exclusive.
   */
  allowProtectedAppendWritesAll?: boolean;
}

/**
 * An update history of the ImmutabilityPolicy of a blob container.
 */
model UpdateHistoryProperty {
  /**
   * The ImmutabilityPolicy update type of a blob container, possible values include: put, lock and extend.
   */
  @visibility("read")
  update?: ImmutabilityPolicyUpdateType;

  /**
   * The immutability period for the blobs in the container since the policy creation, in days.
   */
  @visibility("read")
  immutabilityPeriodSinceCreationInDays?: int32;

  /**
   * Returns the date and time the ImmutabilityPolicy was updated.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  /**
   * Returns the Object ID of the user who updated the ImmutabilityPolicy.
   */
  @visibility("read")
  objectIdentifier?: string;

  /**
   * Returns the Tenant ID that issued the token for the user who updated the ImmutabilityPolicy.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * Returns the User Principal Name of the user who updated the ImmutabilityPolicy.
   */
  @visibility("read")
  upn?: string;

  /**
   * This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API.
   */
  allowProtectedAppendWrites?: boolean;

  /**
   * This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both 'Append and Bock Blobs' while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The 'allowProtectedAppendWrites' and 'allowProtectedAppendWritesAll' properties are mutually exclusive.
   */
  allowProtectedAppendWritesAll?: boolean;
}

/**
 * The LegalHold property of a blob container.
 */
model LegalHoldProperties {
  /**
   * The hasLegalHold public property is set to true by SRP if there are at least one existing tag. The hasLegalHold public property is set to false by SRP if all existing legal hold tags are cleared out. There can be a maximum of 1000 blob containers with hasLegalHold=true for a given account.
   */
  @visibility("read")
  hasLegalHold?: boolean;

  /**
   * The list of LegalHold tags of a blob container.
   */
  tags?: TagProperty[];

  /**
   * Protected append blob writes history.
   */
  protectedAppendWritesHistory?: ProtectedAppendWritesHistory;
}

/**
 * A tag of the LegalHold of a blob container.
 */
model TagProperty {
  /**
   * The tag value.
   */
  @visibility("read")
  tag?: string;

  /**
   * Returns the date and time the tag was added.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  /**
   * Returns the Object ID of the user who added the tag.
   */
  @visibility("read")
  objectIdentifier?: string;

  /**
   * Returns the Tenant ID that issued the token for the user who added the tag.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * Returns the User Principal Name of the user who added the tag.
   */
  @visibility("read")
  upn?: string;
}

/**
 * Protected append writes history setting for the blob container with Legal holds.
 */
model ProtectedAppendWritesHistory {
  /**
   * When enabled, new blocks can be written to both 'Append and Bock Blobs' while maintaining legal hold protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted.
   */
  allowProtectedAppendWritesAll?: boolean;

  /**
   * Returns the date and time the tag was added.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;
}

/**
 * Object level immutability properties of the container.
 */
model ImmutableStorageWithVersioning {
  /**
   * This is an immutable property, when set to true it enables object level immutability at the container level.
   */
  enabled?: boolean;

  /**
   * Returns the date and time the object level immutability was enabled.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeStamp?: utcDateTime;

  /**
   * This property denotes the container level immutability to object level immutability migration state.
   */
  @visibility("read")
  migrationState?: MigrationState;
}

/**
 * The resource model definition for an Azure Resource Manager resource with an etag.
 */
model AzureEntityResource extends Resource {
  /**
   * Resource Etag.
   */
  @visibility("read")
  etag?: string;
}

/**
 * The LegalHold property of a blob container.
 */
model LegalHold {
  /**
   * The hasLegalHold public property is set to true by SRP if there are at least one existing tag. The hasLegalHold public property is set to false by SRP if all existing legal hold tags are cleared out. There can be a maximum of 1000 blob containers with hasLegalHold=true for a given account.
   */
  @visibility("read")
  hasLegalHold?: boolean;

  /**
   * Each tag should be 3 to 23 alphanumeric characters and is normalized to lower case at SRP.
   */
  tags: string[];

  /**
   * When enabled, new blocks can be written to both 'Append and Bock Blobs' while maintaining legal hold protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted.
   */
  allowProtectedAppendWritesAll?: boolean;
}

/**
 * Lease Container request schema.
 */
model LeaseContainerRequest {
  /**
   * Specifies the lease action. Can be one of the available actions.
   */
  action: LeaseContainerRequestAction;

  /**
   * Identifies the lease. Can be specified in any valid GUID string format.
   */
  leaseId?: string;

  /**
   * Optional. For a break action, proposed duration the lease should continue before it is broken, in seconds, between 0 and 60.
   */
  breakPeriod?: int32;

  /**
   * Required for acquire. Specifies the duration of the lease, in seconds, or negative one (-1) for a lease that never expires.
   */
  leaseDuration?: int32;

  /**
   * Optional for acquire, required for change. Proposed lease ID, in a GUID string format.
   */
  proposedLeaseId?: string;
}

/**
 * Lease Container response schema.
 */
model LeaseContainerResponse {
  /**
   * Returned unique lease ID that must be included with any request to delete the container, or to renew, change, or release the lease.
   */
  leaseId?: string;

  /**
   * Approximate time remaining in the lease period, in seconds.
   */
  leaseTimeSeconds?: string;
}

/**
 * The properties of File services in storage account.
 */
model FileServicePropertiesProperties {
  /**
   * Specifies CORS rules for the File service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the File service.
   */
  cors?: CorsRules;

  /**
   * The file service properties for share soft delete.
   */
  shareDeleteRetentionPolicy?: DeleteRetentionPolicy;

  /**
   * Protocol settings for file service
   */
  protocolSettings?: ProtocolSettings;
}

/**
 * Protocol settings for file service
 */
model ProtocolSettings {
  /**
   * Setting for SMB protocol
   */
  smb?: SmbSetting;
}

/**
 * Setting for SMB protocol
 */
model SmbSetting {
  /**
   * Multichannel setting. Applies to Premium FileStorage only.
   */
  multichannel?: Multichannel;

  /**
   * SMB protocol versions supported by server. Valid values are SMB2.1, SMB3.0, SMB3.1.1. Should be passed as a string with delimiter ';'.
   */
  versions?: string;

  /**
   * SMB authentication methods supported by server. Valid values are NTLMv2, Kerberos. Should be passed as a string with delimiter ';'.
   */
  authenticationMethods?: string;

  /**
   * Kerberos ticket encryption supported by server. Valid values are RC4-HMAC, AES-256. Should be passed as a string with delimiter ';'
   */
  kerberosTicketEncryption?: string;

  /**
   * SMB channel encryption supported by server. Valid values are AES-128-CCM, AES-128-GCM, AES-256-GCM. Should be passed as a string with delimiter ';'.
   */
  channelEncryption?: string;
}

/**
 * Multichannel setting. Applies to Premium FileStorage only.
 */
model Multichannel {
  /**
   * Indicates whether multichannel is enabled
   */
  enabled?: boolean;
}

/**
 * The properties of the file share.
 */
model FileShareProperties {
  /**
   * Returns the date and time the share was last modified.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * A name-value pair to associate with the share as metadata.
   */
  metadata?: Record<string>;

  /**
   * The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5TB (5120). For Large File Shares, the maximum size is 102400.
   */
  @maxValue(102400)
  @minValue(1)
  shareQuota?: int32;

  /**
   * The authentication protocol that is used for the file share. Can only be specified when creating a share.
   */
  @visibility("read", "create")
  enabledProtocols?: EnabledProtocols;

  /**
   * The property is for NFS share only. The default is NoRootSquash.
   */
  rootSquash?: RootSquashType;

  /**
   * The version of the share.
   */
  @visibility("read")
  version?: string;

  /**
   * Indicates whether the share was deleted.
   */
  @visibility("read")
  deleted?: boolean;

  /**
   * The deleted time if the share was deleted.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deletedTime?: utcDateTime;

  /**
   * Remaining retention days for share that was soft deleted.
   */
  @visibility("read")
  remainingRetentionDays?: int32;

  /**
   * Access tier for specific share. GpV2 account can choose between TransactionOptimized (default), Hot, and Cool. FileStorage account can choose Premium.
   */
  accessTier?: ShareAccessTier;

  /**
   * Indicates the last modification time for share access tier.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  accessTierChangeTime?: utcDateTime;

  /**
   * Indicates if there is a pending transition for access tier.
   */
  @visibility("read")
  accessTierStatus?: string;

  /**
   * The approximate size of the data stored on the share. Note that this value may not include all recently created or recently resized files.
   */
  @visibility("read")
  shareUsageBytes?: int64;

  /**
   * The lease status of the share.
   */
  @visibility("read")
  leaseStatus?: LeaseStatus;

  /**
   * Lease state of the share.
   */
  @visibility("read")
  leaseState?: LeaseState;

  /**
   * Specifies whether the lease on a share is of infinite or fixed duration, only when the share is leased.
   */
  @visibility("read")
  leaseDuration?: LeaseDuration;

  /**
   * List of stored access policies specified on the share.
   */
  signedIdentifiers?: SignedIdentifier[];

  /**
   * Creation time of share snapshot returned in the response of list shares with expand param "snapshots".
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  snapshotTime?: utcDateTime;
}

model SignedIdentifier {
  /**
   * An unique identifier of the stored access policy.
   */
  id?: string;

  /**
   * Access policy
   */
  accessPolicy?: AccessPolicy;
}

model AccessPolicy {
  /**
   * Start time of the access policy
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * Expiry time of the access policy
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTime?: utcDateTime;

  /**
   * List of abbreviated permissions.
   */
  permission?: string;
}

/**
 * The deleted share to be restored.
 */
model DeletedShare {
  /**
   * Required. Identify the name of the deleted share that will be restored.
   */
  deletedShareName: string;

  /**
   * Required. Identify the version of the deleted share that will be restored.
   */
  deletedShareVersion: string;
}

/**
 * Lease Share request schema.
 */
model LeaseShareRequest {
  /**
   * Specifies the lease action. Can be one of the available actions.
   */
  action: LeaseShareAction;

  /**
   * Identifies the lease. Can be specified in any valid GUID string format.
   */
  leaseId?: string;

  /**
   * Optional. For a break action, proposed duration the lease should continue before it is broken, in seconds, between 0 and 60.
   */
  breakPeriod?: int32;

  /**
   * Required for acquire. Specifies the duration of the lease, in seconds, or negative one (-1) for a lease that never expires.
   */
  leaseDuration?: int32;

  /**
   * Optional for acquire, required for change. Proposed lease ID, in a GUID string format.
   */
  proposedLeaseId?: string;
}

/**
 * Lease Share response schema.
 */
model LeaseShareResponse {
  /**
   * Returned unique lease ID that must be included with any request to delete the share, or to renew, change, or release the lease.
   */
  leaseId?: string;

  /**
   * Approximate time remaining in the lease period, in seconds.
   */
  leaseTimeSeconds?: string;
}

/**
 * The properties of a storage account’s Queue service.
 */
model QueueServicePropertiesProperties {
  /**
   * Specifies CORS rules for the Queue service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Queue service.
   */
  cors?: CorsRules;
}

model QueueProperties {
  /**
   * A name-value pair that represents queue metadata.
   */
  metadata?: Record<string>;

  /**
   * Integer indicating an approximate number of messages in the queue. This number is not lower than the actual number of messages in the queue, but could be higher.
   */
  @visibility("read")
  approximateMessageCount?: int32;
}

/**
 * The properties of a storage account’s Table service.
 */
model TableServicePropertiesProperties {
  /**
   * Specifies CORS rules for the Table service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Table service.
   */
  cors?: CorsRules;
}

model TableProperties {
  /**
   * Table name under the specified account
   */
  @visibility("read")
  tableName?: string;

  /**
   * List of stored access policies specified on the table.
   */
  signedIdentifiers?: TableSignedIdentifier[];
}

/**
 * Object to set Table Access Policy.
 */
model TableSignedIdentifier {
  /**
   * unique-64-character-value of the stored access policy.
   */
  id: string;

  /**
   * Access policy
   */
  accessPolicy?: TableAccessPolicy;
}

/**
 * Table Access Policy Properties Object.
 */
model TableAccessPolicy {
  /**
   * Start time of the access policy
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * Expiry time of the access policy
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTime?: utcDateTime;

  /**
   * Required. List of abbreviated permissions. Supported permission values include 'r','a','u','d'
   */
  permission: string;
}

/**
 * The blob container properties be listed out.
 */
model ListContainerItem extends AzureEntityResource {
  /**
   * The blob container properties be listed out.
   */
  properties?: ContainerProperties;
}

/**
 * The file share properties be listed out.
 */
model FileShareItem extends AzureEntityResource {
  /**
   * The file share properties be listed out.
   */
  properties?: FileShareProperties;
}

model ListQueue extends Resource {
  /**
   * List Queue resource properties.
   */
  @projectedName("json", "properties")
  queueProperties?: ListQueueProperties;
}

model ListQueueProperties {
  /**
   * A name-value pair that represents queue metadata.
   */
  metadata?: Record<string>;
}
