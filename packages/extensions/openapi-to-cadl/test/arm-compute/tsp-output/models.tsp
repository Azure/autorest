import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace Azure.ResourceManager.Compute;

interface Operations extends Azure.ResourceManager.Operations {}

enum RepairAction {
  Replace,
  Restart,
  Reimage,
}

enum WindowsVMGuestPatchMode {
  Manual,
  AutomaticByOS,
  AutomaticByPlatform,
}

enum WindowsPatchAssessmentMode {
  ImageDefault,
  AutomaticByPlatform,
}

enum WindowsVMGuestPatchAutomaticByPlatformRebootSetting {
  Unknown,
  IfRequired,
  Never,
  Always,
}

enum LinuxVMGuestPatchMode {
  ImageDefault,
  AutomaticByPlatform,
}

enum LinuxPatchAssessmentMode {
  ImageDefault,
  AutomaticByPlatform,
}

enum LinuxVMGuestPatchAutomaticByPlatformRebootSetting {
  Unknown,
  IfRequired,
  Never,
  Always,
}

enum DiskCreateOptionTypes {
  FromImage,
  Empty,
  Attach,
}

enum DiffDiskOptions {
  Local,
}

enum DiffDiskPlacement {
  CacheDisk,
  ResourceDisk,
}

enum StorageAccountTypes {
  Standard_LRS,
  Premium_LRS,
  StandardSSD_LRS,
  UltraSSD_LRS,
  Premium_ZRS,
  StandardSSD_ZRS,
  PremiumV2_LRS,
}

enum SecurityEncryptionTypes {
  VMGuestStateOnly,
  DiskWithVMGuestState,
}

enum DiskDeleteOptionTypes {
  Delete,
  Detach,
}

enum DomainNameLabelScopeTypes {
  TenantReuse,
  SubscriptionReuse,
  ResourceGroupReuse,
  NoReuse,
}

enum IPVersion {
  IPv4,
  IPv6,
}

enum DeleteOptions {
  Delete,
  Detach,
}

enum PublicIPAddressSkuName {
  Basic,
  Standard,
}

enum PublicIPAddressSkuTier {
  Regional,
  Global,
}

enum NetworkInterfaceAuxiliaryMode {
  None,
  AcceleratedConnections,
  Floating,
}

enum NetworkInterfaceAuxiliarySku {
  None,
  A1,
  A2,
  A4,
  A8,
}

enum NetworkApiVersion {
  `2020-11-01`,
}

enum SecurityTypes {
  TrustedLaunch,
  ConfidentialVM,
}

enum VirtualMachinePriorityTypes {
  Regular,
  Low,
  Spot,
}

enum VirtualMachineEvictionPolicyTypes {
  Deallocate,
  Delete,
}

enum VirtualMachineScaleSetScaleInRules {
  Default,
  OldestVM,
  NewestVM,
}

enum OrchestrationMode {
  Uniform,
  Flexible,
}

enum ExtendedLocationTypes {
  EdgeZone,
}

enum ExpandTypesForGetVMScaleSets {
  userData,
}

enum OrchestrationServiceNames {
  AutomaticRepairs,
}

enum OrchestrationServiceState {
  NotRunning,
  Running,
  Suspended,
}

enum OrchestrationServiceStateAction {
  Resume,
  Suspend,
}

enum HyperVGeneration {
  V1,
  V2,
}

enum VirtualMachineSizeTypes {
  Basic_A0,
  Basic_A1,
  Basic_A2,
  Basic_A3,
  Basic_A4,
  Standard_A0,
  Standard_A1,
  Standard_A2,
  Standard_A3,
  Standard_A4,
  Standard_A5,
  Standard_A6,
  Standard_A7,
  Standard_A8,
  Standard_A9,
  Standard_A10,
  Standard_A11,
  Standard_A1_v2,
  Standard_A2_v2,
  Standard_A4_v2,
  Standard_A8_v2,
  Standard_A2m_v2,
  Standard_A4m_v2,
  Standard_A8m_v2,
  Standard_B1s,
  Standard_B1ms,
  Standard_B2s,
  Standard_B2ms,
  Standard_B4ms,
  Standard_B8ms,
  Standard_D1,
  Standard_D2,
  Standard_D3,
  Standard_D4,
  Standard_D11,
  Standard_D12,
  Standard_D13,
  Standard_D14,
  Standard_D1_v2,
  Standard_D2_v2,
  Standard_D3_v2,
  Standard_D4_v2,
  Standard_D5_v2,
  Standard_D2_v3,
  Standard_D4_v3,
  Standard_D8_v3,
  Standard_D16_v3,
  Standard_D32_v3,
  Standard_D64_v3,
  Standard_D2s_v3,
  Standard_D4s_v3,
  Standard_D8s_v3,
  Standard_D16s_v3,
  Standard_D32s_v3,
  Standard_D64s_v3,
  Standard_D11_v2,
  Standard_D12_v2,
  Standard_D13_v2,
  Standard_D14_v2,
  Standard_D15_v2,
  Standard_DS1,
  Standard_DS2,
  Standard_DS3,
  Standard_DS4,
  Standard_DS11,
  Standard_DS12,
  Standard_DS13,
  Standard_DS14,
  Standard_DS1_v2,
  Standard_DS2_v2,
  Standard_DS3_v2,
  Standard_DS4_v2,
  Standard_DS5_v2,
  Standard_DS11_v2,
  Standard_DS12_v2,
  Standard_DS13_v2,
  Standard_DS14_v2,
  Standard_DS15_v2,
  `Standard_DS13-4_v2`,
  `Standard_DS13-2_v2`,
  `Standard_DS14-8_v2`,
  `Standard_DS14-4_v2`,
  Standard_E2_v3,
  Standard_E4_v3,
  Standard_E8_v3,
  Standard_E16_v3,
  Standard_E32_v3,
  Standard_E64_v3,
  Standard_E2s_v3,
  Standard_E4s_v3,
  Standard_E8s_v3,
  Standard_E16s_v3,
  Standard_E32s_v3,
  Standard_E64s_v3,
  `Standard_E32-16_v3`,
  `Standard_E32-8s_v3`,
  `Standard_E64-32s_v3`,
  `Standard_E64-16s_v3`,
  Standard_F1,
  Standard_F2,
  Standard_F4,
  Standard_F8,
  Standard_F16,
  Standard_F1s,
  Standard_F2s,
  Standard_F4s,
  Standard_F8s,
  Standard_F16s,
  Standard_F2s_v2,
  Standard_F4s_v2,
  Standard_F8s_v2,
  Standard_F16s_v2,
  Standard_F32s_v2,
  Standard_F64s_v2,
  Standard_F72s_v2,
  Standard_G1,
  Standard_G2,
  Standard_G3,
  Standard_G4,
  Standard_G5,
  Standard_GS1,
  Standard_GS2,
  Standard_GS3,
  Standard_GS4,
  Standard_GS5,
  `Standard_GS4-8`,
  `Standard_GS4-4`,
  `Standard_GS5-16`,
  `Standard_GS5-8`,
  Standard_H8,
  Standard_H16,
  Standard_H8m,
  Standard_H16m,
  Standard_H16r,
  Standard_H16mr,
  Standard_L4s,
  Standard_L8s,
  Standard_L16s,
  Standard_L32s,
  Standard_M64s,
  Standard_M64ms,
  Standard_M128s,
  Standard_M128ms,
  `Standard_M64-32ms`,
  `Standard_M64-16ms`,
  `Standard_M128-64ms`,
  `Standard_M128-32ms`,
  Standard_NC6,
  Standard_NC12,
  Standard_NC24,
  Standard_NC24r,
  Standard_NC6s_v2,
  Standard_NC12s_v2,
  Standard_NC24s_v2,
  Standard_NC24rs_v2,
  Standard_NC6s_v3,
  Standard_NC12s_v3,
  Standard_NC24s_v3,
  Standard_NC24rs_v3,
  Standard_ND6s,
  Standard_ND12s,
  Standard_ND24s,
  Standard_ND24rs,
  Standard_NV6,
  Standard_NV12,
  Standard_NV24,
}

enum DiskDetachOptionTypes {
  ForceDetach,
}

enum DiskControllerTypes {
  SCSI,
  NVMe,
}

enum IPVersions {
  IPv4,
  IPv6,
}

enum PublicIPAllocationMethod {
  Dynamic,
  Static,
}

enum HyperVGenerationType {
  V1,
  V2,
}

enum PatchOperationStatus {
  Unknown,
  InProgress,
  Failed,
  Succeeded,
  CompletedWithWarnings,
}

enum ExpandTypeForListVMs {
  instanceView,
}

enum ExpandTypesForListVMs {
  instanceView,
}

enum VMGuestPatchRebootBehavior {
  Unknown,
  NeverReboots,
  AlwaysRequiresReboot,
  CanRequestReboot,
}

enum PatchAssessmentState {
  Unknown,
  Available,
}

enum VMGuestPatchRebootSetting {
  IfRequired,
  Never,
  Always,
}

enum VMGuestPatchClassificationWindows {
  Critical,
  Security,
  UpdateRollUp,
  FeaturePack,
  ServicePack,
  Definition,
  Tools,
  Updates,
}

enum VMGuestPatchClassificationLinux {
  Critical,
  Security,
  Other,
}

enum VMGuestPatchRebootStatus {
  Unknown,
  NotNeeded,
  Required,
  Started,
  Failed,
  Completed,
}

enum PatchInstallationState {
  Unknown,
  Installed,
  Failed,
  Excluded,
  NotSelected,
  Pending,
}

enum HyperVGenerationTypes {
  V1,
  V2,
}

enum VmDiskTypes {
  None,
  Unmanaged,
}

enum ArchitectureTypes {
  x64,
  Arm64,
}

enum ImageState {
  Active,
  ScheduledForDeprecation,
  Deprecated,
}

enum AlternativeType {
  None,
  Offer,
  Plan,
}

enum ProximityPlacementGroupType {
  Standard,
  Ultra,
}

enum OperatingSystemType {
  Windows,
  Linux,
}

enum RestorePointEncryptionType {
  @doc("Disk Restore Point is encrypted at rest with Platform managed key. ")
  EncryptionAtRestWithPlatformKey,
  @doc("""
Disk Restore Point is encrypted at rest with Customer managed key that can be
changed and revoked by a customer.
""")
  EncryptionAtRestWithCustomerKey,
  @doc("""
Disk Restore Point is encrypted at rest with 2 layers of encryption. One of the
keys is Customer managed and the other key is Platform managed.
""")
  EncryptionAtRestWithPlatformAndCustomerKeys,
}

enum ConsistencyModeTypes {
  CrashConsistent,
  FileSystemConsistent,
  ApplicationConsistent,
}

enum RestorePointCollectionExpandOptions {
  restorePoints,
}

enum RestorePointExpandOptions {
  instanceView,
}

enum CapacityReservationGroupInstanceViewTypes {
  instanceView,
}

enum ExpandTypesForGetCapacityReservationGroups {
  `virtualMachineScaleSetVMs/$ref`,
  `virtualMachines/$ref`,
}

enum CapacityReservationInstanceViewTypes {
  instanceView,
}

enum ExecutionState {
  Unknown,
  Pending,
  Running,
  Failed,
  Succeeded,
  TimedOut,
  Canceled,
}

enum DiskStorageAccountTypes {
  @doc("""
Standard HDD locally redundant storage. Best for backup, non-critical, and
infrequent access.
""")
  Standard_LRS,
  @doc("""
Premium SSD locally redundant storage. Best for production and performance
sensitive workloads.
""")
  Premium_LRS,
  @doc("""
Standard SSD locally redundant storage. Best for web servers, lightly used
enterprise applications and dev/test.
""")
  StandardSSD_LRS,
  @doc("""
Ultra SSD locally redundant storage. Best for IO-intensive workloads such as
SAP HANA, top tier databases (for example, SQL, Oracle), and other
transaction-heavy workloads.
""")
  UltraSSD_LRS,
  @doc("""
Premium SSD zone redundant storage. Best for the production workloads that need
storage resiliency against zone failures.
""")
  Premium_ZRS,
  @doc("""
Standard SSD zone redundant storage. Best for web servers, lightly used
enterprise applications and dev/test that need storage resiliency against zone
failures.
""")
  StandardSSD_ZRS,
  @doc("""
Premium SSD v2 locally redundant storage. Best for production and
performance-sensitive workloads that consistently require low latency and high
IOPS and throughput.
""")
  PremiumV2_LRS,
}

enum Architecture {
  x64,
  Arm64,
}

enum DiskCreateOption {
  @doc("Create an empty data disk of a size given by diskSizeGB.") Empty,
  @doc("Disk will be attached to a VM.") Attach,
  @doc("""
Create a new disk from a platform image specified by the given imageReference
or galleryImageReference.
""")
  FromImage,
  @doc("""
Create a disk by importing from a blob specified by a sourceUri in a storage
account specified by storageAccountId.
""")
  Import,
  @doc("""
Create a new disk or snapshot by copying from a disk or snapshot specified by
the given sourceResourceId.
""")
  Copy,
  @doc("Create a new disk by copying from a backup recovery point.") Restore,
  @doc("""
Create a new disk by obtaining a write token and using it to directly upload
the contents of the disk.
""")
  Upload,
  @doc("""
Create a new disk by using a deep copy process, where the resource creation is
considered complete only after all data has been copied from the source.
""")
  CopyStart,
  @doc("""
Similar to Import create option. Create a new Trusted Launch VM or Confidential
VM supported disk by importing additional blob for VM guest state specified by
securityDataUri in storage account specified by storageAccountId
""")
  ImportSecure,
  @doc("""
Similar to Upload create option. Create a new Trusted Launch VM or Confidential
VM supported disk and upload using write token in both disk and VM guest state
""")
  UploadPreparedSecure,
  @doc("Create a new disk by exporting from elastic san volume snapshot")
  CopyFromSanSnapshot,
}

enum DiskState {
  @doc("The disk is not being used and can be attached to a VM.") Unattached,
  @doc("The disk is currently attached to a running VM.") Attached,
  @doc("The disk is attached to a stopped-deallocated VM.") Reserved,
  @doc("The disk is attached to a VM which is in hibernated state.") Frozen,
  @doc("The disk currently has an Active SAS Uri associated with it.")
  ActiveSAS,
  @doc("""
The disk is attached to a VM in hibernated state and has an active SAS URI
associated with it.
""")
  ActiveSASFrozen,
  @doc("A disk is ready to be created by upload by requesting a write token.")
  ReadyToUpload,
  @doc("""
A disk is created for upload and a write token has been issued for uploading to
it.
""")
  ActiveUpload,
}

enum EncryptionType {
  @doc("""
Disk is encrypted at rest with Platform managed key. It is the default
encryption type. This is not a valid encryption type for disk encryption sets.
""")
  EncryptionAtRestWithPlatformKey,
  @doc("""
Disk is encrypted at rest with Customer managed key that can be changed and
revoked by a customer.
""")
  EncryptionAtRestWithCustomerKey,
  @doc("""
Disk is encrypted at rest with 2 layers of encryption. One of the keys is
Customer managed and the other key is Platform managed.
""")
  EncryptionAtRestWithPlatformAndCustomerKeys,
}

enum NetworkAccessPolicy {
  @doc("The disk can be exported or uploaded to from any network.") AllowAll,
  @doc("""
The disk can be exported or uploaded to using a DiskAccess resource's private
endpoints.
""")
  AllowPrivate,
  @doc("The disk cannot be exported.") DenyAll,
}

enum DiskSecurityTypes {
  @doc("""
Trusted Launch provides security features such as secure boot and virtual
Trusted Platform Module (vTPM)
""")
  TrustedLaunch,
  @doc("Indicates Confidential VM disk with only VM guest state encrypted")
  ConfidentialVM_VMGuestStateOnlyEncryptedWithPlatformKey,
  @doc("""
Indicates Confidential VM disk with both OS disk and VM guest state encrypted
with a platform managed key
""")
  ConfidentialVM_DiskEncryptedWithPlatformKey,
  @doc("""
Indicates Confidential VM disk with both OS disk and VM guest state encrypted
with a customer managed key
""")
  ConfidentialVM_DiskEncryptedWithCustomerKey,
}

enum PublicNetworkAccess {
  @doc("""
You can generate a SAS URI to access the underlying data of the disk publicly
on the internet when NetworkAccessPolicy is set to AllowAll. You can access the
data via the SAS URI only from your trusted Azure VNET when NetworkAccessPolicy
is set to AllowPrivate.
""")
  Enabled,
  @doc("""
You cannot access the underlying data of the disk publicly on the internet even
when NetworkAccessPolicy is set to AllowAll. You can access the data via the
SAS URI only from your trusted Azure VNET when NetworkAccessPolicy is set to
AllowPrivate.
""")
  Disabled,
}

enum DataAccessAuthMode {
  @doc("""
When export/upload URL is used, the system checks if the user has an identity
in Azure Active Directory and has necessary permissions to export/upload the
data. Please refer to aka.ms/DisksAzureADAuth.
""")
  AzureActiveDirectory,
  @doc("""
No additional authentication would be performed when accessing export/upload
URL.
""")
  None,
}

enum AccessLevel {
  None,
  Read,
  Write,
}

enum FileFormat {
  @doc("A VHD file is a disk image file in the Virtual Hard Disk file format.")
  VHD,
  @doc("A VHDX file is a disk image file in the Virtual Hard Disk v2 file format.")
  VHDX,
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

enum DiskEncryptionSetIdentityType {
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
  None,
}

enum DiskEncryptionSetType {
  @doc("""
Resource using diskEncryptionSet would be encrypted at rest with Customer
managed key that can be changed and revoked by a customer.
""")
  EncryptionAtRestWithCustomerKey,
  @doc("""
Resource using diskEncryptionSet would be encrypted at rest with two layers of
encryption. One of the keys is Customer managed and the other key is Platform
managed.
""")
  EncryptionAtRestWithPlatformAndCustomerKeys,
  @doc("""
Confidential VM supported disk and VM guest state would be encrypted with
customer managed key.
""")
  ConfidentialVmEncryptedWithCustomerKey,
}

enum SnapshotStorageAccountTypes {
  @doc("Standard HDD locally redundant storage") Standard_LRS,
  @doc("Premium SSD locally redundant storage") Premium_LRS,
  @doc("Standard zone redundant storage") Standard_ZRS,
}

enum CopyCompletionErrorReason {
  @doc("""
Indicates that the source snapshot was deleted while the background copy of the
resource created via CopyStart operation was in progress.
""")
  CopySourceNotFound,
}

enum ExtendedLocationType {
  EdgeZone,
}

enum GalleryProvisioningState {
  Creating,
  Updating,
  Failed,
  Succeeded,
  Deleting,
  Migrating,
}

enum GallerySharingPermissionTypes {
  Private,
  Groups,
  Community,
}

enum SharingProfileGroupTypes {
  Subscriptions,
  AADTenants,
}

enum SharingState {
  Succeeded,
  InProgress,
  Failed,
  Unknown,
}

enum SelectPermissions {
  Permissions,
}

enum GalleryExpandParams {
  `SharingProfile/Groups`,
}

enum StorageAccountType {
  Standard_LRS,
  Standard_ZRS,
  Premium_LRS,
}

enum ConfidentialVMEncryptionType {
  EncryptedVMGuestStateOnlyWithPmk,
  EncryptedWithPmk,
  EncryptedWithCmk,
}

enum ReplicationMode {
  Full,
  Shallow,
}

enum GalleryExtendedLocationType {
  EdgeZone,
  Unknown,
}

enum EdgeZoneStorageAccountType {
  Standard_LRS,
  Standard_ZRS,
  StandardSSD_LRS,
  Premium_LRS,
}

enum PolicyViolationCategory {
  Other,
  ImageFlaggedUnsafe,
  CopyrightValidation,
  IpTheft,
}

enum AggregatedReplicationState {
  Unknown,
  InProgress,
  Completed,
  Failed,
}

enum ReplicationState {
  Unknown,
  Replicating,
  Completed,
  Failed,
}

enum ReplicationStatusTypes {
  ReplicationStatus,
}

enum SharingUpdateOperationTypes {
  Add,
  Remove,
  Reset,
  EnableCommunity,
}

enum SharedToValues {
  tenant,
}

enum SharedGalleryHostCaching {
  None,
  ReadOnly,
  ReadWrite,
}

enum CloudServiceUpgradeMode {
  Auto,
  Manual,
  Simultaneous,
}

enum CloudServiceSlotType {
  Production,
  Staging,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum AvailabilitySetSkuTypes {
  Classic,
  Aligned,
}
@Azure.Core.fixed
enum UpgradeMode {
  Automatic,
  Manual,
  Rolling,
}
@Azure.Core.fixed
enum SettingNames {
  AutoLogon,
  FirstLogonCommands,
}
@Azure.Core.fixed
enum ProtocolTypes {
  Http,
  Https,
}
@Azure.Core.fixed
enum CachingTypes {
  None,
  ReadOnly,
  ReadWrite,
}
@Azure.Core.fixed
enum OperatingSystemTypes {
  Windows,
  Linux,
}
@Azure.Core.fixed
enum StatusLevelTypes {
  Info,
  Warning,
  Error,
}
@Azure.Core.fixed
enum ResourceIdentityType {
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
  None,
}
@Azure.Core.fixed
enum VirtualMachineScaleSetSkuScaleType {
  Automatic,
  None,
}
@Azure.Core.fixed
enum UpgradeState {
  RollingForward,
  Cancelled,
  Completed,
  Faulted,
}
@Azure.Core.fixed
enum UpgradeOperationInvoker {
  Unknown,
  User,
  Platform,
}
@Azure.Core.fixed
enum RollingUpgradeStatusCode {
  RollingForward,
  Cancelled,
  Completed,
  Faulted,
}
@Azure.Core.fixed
enum RollingUpgradeActionType {
  Start,
  Cancel,
}
@Azure.Core.fixed
enum MaintenanceOperationResultCodeTypes {
  None,
  RetryLater,
  MaintenanceAborted,
  MaintenanceCompleted,
}
@Azure.Core.fixed
enum InstanceViewTypes {
  instanceView,
  userData,
}
@Azure.Core.fixed
enum DedicatedHostLicenseTypes {
  None,
  Windows_Server_Hybrid,
  Windows_Server_Perpetual,
}
@Azure.Core.fixed
enum OperatingSystemStateTypes {
  Generalized,
  Specialized,
}
@Azure.Core.fixed
enum IntervalInMins {
  ThreeMins,
  FiveMins,
  ThirtyMins,
  SixtyMins,
}
@Azure.Core.fixed
enum ResourceSkuCapacityScaleType {
  Automatic,
  Manual,
  None,
}
@Azure.Core.fixed
enum ResourceSkuRestrictionsType {
  Location,
  Zone,
}
@Azure.Core.fixed
enum ResourceSkuRestrictionsReasonCode {
  QuotaId,
  NotAvailableForSubscription,
}
@Azure.Core.fixed
enum HostCaching {
  None,
  ReadOnly,
  ReadWrite,
}
@Azure.Core.fixed
enum GalleryApplicationCustomActionParameterType {
  String,
  ConfigurationDataBlob,
  LogOutputBlob,
}

@doc("The List Compute Operation operation response.")
@pagedResult
model ComputeOperationListResult {
  @doc("The list of compute operations")
  @visibility("read")
  @items
  value?: ComputeOperationValue[];
}

@doc("Describes the properties of a Compute Operation value.")
model ComputeOperationValue {
  @doc("The origin of the compute operation.")
  @visibility("read")
  origin?: string;

  @doc("The name of the compute operation.")
  @visibility("read")
  name?: string;

  @doc("Describes the properties of a Compute Operation Value Display.")
  display?: ComputeOperationValueDisplay;
}

@doc("Describes the properties of a Compute Operation Value Display.")
model ComputeOperationValueDisplay {
  @doc("The display name of the compute operation.")
  @visibility("read")
  operation?: string;

  @doc("The display name of the resource the operation applies to.")
  @visibility("read")
  resource?: string;

  @doc("The description of the operation.")
  @visibility("read")
  description?: string;

  @doc("The resource provider for the operation.")
  @visibility("read")
  provider?: string;
}

@doc("An error response from the Compute service.")
@error
model CloudError {
  @doc("Api error.")
  error?: ApiError;
}

@doc("Api error.")
model ApiError {
  @doc("The Api error details")
  details?: ApiErrorBase[];

  @doc("The Api inner error")
  innererror?: InnerError;

  @doc("The error code.")
  code?: string;

  @doc("The target of the particular error.")
  target?: string;

  @doc("The error message.")
  message?: string;
}

@doc("Api error base.")
model ApiErrorBase {
  @doc("The error code.")
  code?: string;

  @doc("The target of the particular error.")
  target?: string;

  @doc("The error message.")
  message?: string;
}

@doc("Inner error details.")
model InnerError {
  @doc("The exception type.")
  exceptiontype?: string;

  @doc("The internal error message or exception dump.")
  errordetail?: string;
}

@doc("The List Usages operation response.")
model ListUsagesResult is Azure.Core.Page<Usage>;

@doc("Describes Compute Resource Usage.")
model Usage {
  @doc("An enum describing the unit of usage measurement.")
  unit: "Count";

  @doc("The current usage of the resource.")
  currentValue: int32;

  @doc("The maximum permitted usage of the resource.")
  limit: int32;

  @doc("The name of the type of usage.")
  name: UsageName;
}

@doc("The Usage Names.")
model UsageName {
  @doc("The name of the resource.")
  value?: string;

  @doc("The localized name of the resource.")
  localizedValue?: string;
}

@doc("The List Virtual Machine operation response.")
@pagedResult
model VirtualMachineSizeListResult {
  @doc("The list of virtual machine sizes.")
  @items
  value?: VirtualMachineSize[];
}

@doc("Describes the properties of a VM size.")
model VirtualMachineSize {
  @doc("The name of the virtual machine size.")
  name?: string;

  @doc("""
The number of cores supported by the virtual machine size. For Constrained vCPU
capable VM sizes, this number represents the total vCPUs of quota that the VM
uses. For accurate vCPU count, please refer to
https://docs.microsoft.com/azure/virtual-machines/constrained-vcpu or
https://docs.microsoft.com/rest/api/compute/resourceskus/list
""")
  numberOfCores?: int32;

  @doc("The OS disk size, in MB, allowed by the virtual machine size.")
  osDiskSizeInMB?: int32;

  @doc("The resource disk size, in MB, allowed by the virtual machine size.")
  resourceDiskSizeInMB?: int32;

  @doc("The amount of memory, in MB, supported by the virtual machine size.")
  memoryInMB?: int32;

  @doc("""
The maximum number of data disks that can be attached to the virtual machine
size.
""")
  maxDataDiskCount?: int32;
}

@doc("""
Describes a virtual machine scale set sku. NOTE: If the new VM SKU is not
supported on the hardware the scale set is currently on, you need to deallocate
the VMs in the scale set before you modify the SKU name.
""")
model Sku {
  @doc("The sku name.")
  name?: string;

  @doc("""
Specifies the tier of virtual machines in a scale set.<br /><br /> Possible
Values:<br /><br /> **Standard**<br /><br /> **Basic**
""")
  tier?: string;

  @doc("Specifies the number of virtual machines in the scale set.")
  capacity?: int32;
}

@doc("""
Specifies information about the marketplace image used to create the virtual
machine. This element is only used for marketplace images. Before you can use a
marketplace image from an API, you must enable the image for programmatic use. 
In the Azure portal, find the marketplace image that you want to use and then
click **Want to deploy programmatically, Get Started ->**. Enter any required
information and then click **Save**.
""")
model Plan {
  @doc("The plan ID.")
  name?: string;

  @doc("The publisher ID.")
  publisher?: string;

  @doc("""
Specifies the product of the image from the marketplace. This is the same value
as Offer under the imageReference element.
""")
  product?: string;

  @doc("The promotion code.")
  promotionCode?: string;
}

@doc("Describes the properties of a Virtual Machine Scale Set.")
model VirtualMachineScaleSetProperties {
  @doc("The upgrade policy.")
  upgradePolicy?: UpgradePolicy;

  @doc("Policy for automatic repairs.")
  automaticRepairsPolicy?: AutomaticRepairsPolicy;

  @doc("The virtual machine profile.")
  virtualMachineProfile?: VirtualMachineScaleSetVMProfile;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("Specifies whether the Virtual Machine Scale Set should be overprovisioned.")
  overprovision?: boolean;

  @doc("""
When Overprovision is enabled, extensions are launched only on the requested
number of VMs which are finally kept. This property will hence ensure that the
extensions do not run on the extra overprovisioned VMs.
""")
  doNotRunExtensionsOnOverprovisionedVMs?: boolean;

  @doc("Specifies the ID which uniquely identifies a Virtual Machine Scale Set.")
  @visibility("read")
  uniqueId?: string;

  @doc("""
When true this limits the scale set to a single placement group, of max size
100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified
to false. However, if singlePlacementGroup is false, it may not be modified to
true.
""")
  singlePlacementGroup?: boolean;

  @doc("""
Whether to force strictly even Virtual Machine distribution cross x-zones in
case there is zone outage. zoneBalance property can only be set if the zones
property of the scale set contains more than one zone. If there are no zones or
only one zone specified, then zoneBalance property should not be set.
""")
  zoneBalance?: boolean;

  @doc("Fault Domain count for each placement group.")
  platformFaultDomainCount?: int32;

  @doc("""
Specifies information about the proximity placement group that the virtual
machine scale set should be assigned to. Minimum api-version: 2018-04-01.
""")
  proximityPlacementGroup?: SubResource;

  @doc("""
Specifies information about the dedicated host group that the virtual machine
scale set resides in. Minimum api-version: 2020-06-01.
""")
  hostGroup?: SubResource;

  @doc("""
Specifies additional capabilities enabled or disabled on the Virtual Machines
in the Virtual Machine Scale Set. For instance: whether the Virtual Machines
have the capability to support attaching managed data disks with UltraSSD_LRS
storage account type.
""")
  additionalCapabilities?: AdditionalCapabilities;

  @doc("""
Specifies the policies applied when scaling in Virtual Machines in the Virtual
Machine Scale Set.
""")
  scaleInPolicy?: ScaleInPolicy;

  @doc("Specifies the orchestration mode for the virtual machine scale set.")
  orchestrationMode?: OrchestrationMode;

  @doc("Specifies the Spot Restore properties for the virtual machine scale set.")
  spotRestorePolicy?: SpotRestorePolicy;

  @doc("""
Specifies the desired targets for mixing Spot and Regular priority VMs within
the same VMSS Flex instance.
""")
  priorityMixPolicy?: PriorityMixPolicy;

  @doc("""
Specifies the time at which the Virtual Machine Scale Set resource was created.
Minimum api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  @doc("Optional property which must either be set to True or omitted.")
  constrainedMaximumCapacity?: boolean;
}

@doc("Describes an upgrade policy - automatic, manual, or rolling.")
model UpgradePolicy {
  @doc("""
Specifies the mode of an upgrade to virtual machines in the scale set.<br /><br
/> Possible values are:<br /><br /> **Manual** - You  control the application
of updates to virtual machines in the scale set. You do this by using the
manualUpgrade action.<br /><br /> **Automatic** - All virtual machines in the
scale set are  automatically updated at the same time.
""")
  mode?: UpgradeMode;

  @doc("The configuration parameters used while performing a rolling upgrade.")
  rollingUpgradePolicy?: RollingUpgradePolicy;

  @doc("Configuration parameters used for performing automatic OS Upgrade.")
  automaticOSUpgradePolicy?: AutomaticOSUpgradePolicy;
}

@doc("The configuration parameters used while performing a rolling upgrade.")
model RollingUpgradePolicy {
  @doc("""
The maximum percent of total virtual machine instances that will be upgraded
simultaneously by the rolling upgrade in one batch. As this is a maximum,
unhealthy instances in previous or future batches can cause the percentage of
instances in a batch to decrease to ensure higher reliability. The default
value for this parameter is 20%.
""")
  maxBatchInstancePercent?: int32;

  @doc("""
The maximum percentage of the total virtual machine instances in the scale set
that can be simultaneously unhealthy, either as a result of being upgraded, or
by being found in an unhealthy state by the virtual machine health checks
before the rolling upgrade aborts. This constraint will be checked prior to
starting any batch. The default value for this parameter is 20%.
""")
  maxUnhealthyInstancePercent?: int32;

  @doc("""
The maximum percentage of upgraded virtual machine instances that can be found
to be in an unhealthy state. This check will happen after each batch is
upgraded. If this percentage is ever exceeded, the rolling update aborts. The
default value for this parameter is 20%.
""")
  maxUnhealthyUpgradedInstancePercent?: int32;

  @doc("""
The wait time between completing the update for all virtual machines in one
batch and starting the next batch. The time duration should be specified in ISO
8601 format. The default value is 0 seconds (PT0S).
""")
  pauseTimeBetweenBatches?: string;

  @doc("""
Allow VMSS to ignore AZ boundaries when constructing upgrade batches. Take into
consideration the Update Domain and maxBatchInstancePercent to determine the
batch size.
""")
  enableCrossZoneUpgrade?: boolean;

  @doc("Upgrade all unhealthy instances in a scale set before any healthy instances.")
  prioritizeUnhealthyInstances?: boolean;

  @doc("""
Rollback failed instances to previous model if the Rolling Upgrade policy is
violated.
""")
  rollbackFailedInstancesOnPolicyBreach?: boolean;

  @doc("""
Create new virtual machines to upgrade the scale set, rather than updating the
existing virtual machines. Existing virtual machines will be deleted once the
new virtual machines are created for each batch.
""")
  maxSurge?: boolean;
}

@doc("The configuration parameters used for performing automatic OS upgrade.")
model AutomaticOSUpgradePolicy {
  @doc("""
Indicates whether OS upgrades should automatically be applied to scale set
instances in a rolling fashion when a newer version of the OS image becomes
available. Default value is false. If this is set to true for Windows based
scale sets,
[enableAutomaticUpdates](https://docs.microsoft.com/dotnet/api/microsoft.azure.management.compute.models.windowsconfiguration.enableautomaticupdates?view=azure-dotnet)
is automatically set to false and cannot be set to true.
""")
  enableAutomaticOSUpgrade?: boolean;

  @doc("Whether OS image rollback feature should be disabled. Default value is false.")
  disableAutomaticRollback?: boolean;

  @doc("""
Indicates whether rolling upgrade policy should be used during Auto OS Upgrade.
Default value is false. Auto OS Upgrade will fallback to the default policy if
no policy is defined on the VMSS.
""")
  useRollingUpgradePolicy?: boolean;
}

@doc("""
Specifies the configuration parameters for automatic repairs on the virtual
machine scale set.
""")
model AutomaticRepairsPolicy {
  @doc("""
Specifies whether automatic repairs should be enabled on the virtual machine
scale set. The default value is false.
""")
  enabled?: boolean;

  @doc("""
The amount of time for which automatic repairs are suspended due to a state
change on VM. The grace time starts after the state change has completed. This
helps avoid premature or accidental repairs. The time duration should be
specified in ISO 8601 format. The minimum allowed grace period is 10 minutes
(PT10M), which is also the default value. The maximum allowed grace period is
90 minutes (PT90M).
""")
  gracePeriod?: string;

  @doc("""
Type of repair action (replace, restart, reimage) that will be used for
repairing unhealthy virtual machines in the scale set. Default value is
replace.
""")
  repairAction?: RepairAction;
}

@doc("Describes a virtual machine scale set virtual machine profile.")
model VirtualMachineScaleSetVMProfile {
  @doc("""
Specifies the operating system settings for the virtual machines in the scale
set.
""")
  osProfile?: VirtualMachineScaleSetOSProfile;

  @doc("Specifies the storage settings for the virtual machine disks.")
  storageProfile?: VirtualMachineScaleSetStorageProfile;

  @doc("""
Specifies properties of the network interfaces of the virtual machines in the
scale set.
""")
  networkProfile?: VirtualMachineScaleSetNetworkProfile;

  @doc("""
Specifies the Security related profile settings for the virtual machines in the
scale set.
""")
  securityProfile?: SecurityProfile;

  @doc("Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("""
Specifies a collection of settings for extensions installed on virtual machines
in the scale set.
""")
  extensionProfile?: VirtualMachineScaleSetExtensionProfile;

  @doc("""
Specifies that the image or disk that is being used was licensed on-premises.
<br><br> Possible values for Windows Server operating system are: <br><br>
Windows_Client <br><br> Windows_Server <br><br> Possible values for Linux
Server operating system are: <br><br> RHEL_BYOS (for RHEL) <br><br> SLES_BYOS
(for SUSE) <br><br> For more information, see [Azure Hybrid Use Benefit for
Windows
Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing)
<br><br> [Azure Hybrid Use Benefit for Linux
Server](https://docs.microsoft.com/azure/virtual-machines/linux/azure-hybrid-benefit-linux)
<br><br> Minimum api-version: 2015-06-15
""")
  licenseType?: string;

  @doc("""
Specifies the priority for the virtual machines in the scale set. Minimum
api-version: 2017-10-30-preview.
""")
  priority?: VirtualMachinePriorityTypes;

  @doc("""
Specifies the eviction policy for the Azure Spot virtual machine and Azure Spot
scale set. For Azure Spot virtual machines, both 'Deallocate' and 'Delete' are
supported and the minimum api-version is 2019-03-01. For Azure Spot scale sets,
both 'Deallocate' and 'Delete' are supported and the minimum api-version is
2017-10-30-preview.
""")
  evictionPolicy?: VirtualMachineEvictionPolicyTypes;

  @doc("""
Specifies the billing related details of a Azure Spot VMSS. Minimum
api-version: 2019-03-01.
""")
  billingProfile?: BillingProfile;

  @doc("Specifies Scheduled Event related configurations.")
  scheduledEventsProfile?: ScheduledEventsProfile;

  @doc("""
UserData for the virtual machines in the scale set, which must be base-64
encoded. Customer should not pass any secrets in here. Minimum api-version:
2021-03-01.
""")
  userData?: string;

  @doc("""
Specifies the capacity reservation related details of a scale set. Minimum
api-version: 2021-04-01.
""")
  capacityReservation?: CapacityReservationProfile;

  @doc("Specifies the gallery applications that should be made available to the VM/VMSS")
  applicationProfile?: ApplicationProfile;

  @doc("""
Specifies the hardware profile related details of a scale set. Minimum
api-version: 2021-11-01.
""")
  hardwareProfile?: VirtualMachineScaleSetHardwareProfile;

  @doc("""
Specifies the service artifact reference id used to set same image version for
all virtual machines in the scale set when using 'latest' image version.
Minimum api-version: 2022-11-01
""")
  serviceArtifactReference?: ServiceArtifactReference;

  @doc("""
Specifies the security posture to be used for all virtual machines in the scale
set. Minimum api-version: 2023-03-01
""")
  securityPostureReference?: SecurityPostureReference;
}

@doc("Describes a virtual machine scale set OS profile.")
model VirtualMachineScaleSetOSProfile {
  @doc("""
Specifies the computer name prefix for all of the virtual machines in the scale
set. Computer name prefixes must be 1 to 15 characters long.
""")
  computerNamePrefix?: string;

  @doc("""
Specifies the name of the administrator account. <br><br> **Windows-only
restriction:** Cannot end in \".\" <br><br> **Disallowed values:**
\"administrator\", \"admin\", \"user\", \"user1\", \"test\", \"user2\",
\"test1\", \"user3\", \"admin1\", \"1\", \"123\", \"a\", \"actuser\", \"adm\",
\"admin2\", \"aspnet\", \"backup\", \"console\", \"david\", \"guest\",
\"john\", \"owner\", \"root\", \"server\", \"sql\", \"support\",
\"support_388945a0\", \"sys\", \"test2\", \"test3\", \"user4\", \"user5\".
<br><br> **Minimum-length (Linux):** 1  character <br><br> **Max-length
(Linux):** 64 characters <br><br> **Max-length (Windows):** 20 characters
""")
  adminUsername?: string;

  @doc("""
Specifies the password of the administrator account. <br><br> **Minimum-length
(Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters
<br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length
(Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4
conditions below need to be fulfilled <br> Has lower characters <br>Has upper
characters <br> Has a digit <br> Has a special character (Regex match [\\W_])
<br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\",
\"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\",
\"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to
reset the Remote Desktop service or its login password in a Windows
VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp)
<br><br> For resetting root password, see [Manage users, SSH, and check or
repair disks on Azure Linux VMs using the VMAccess
Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)
""")
  adminPassword?: string;

  @doc("""
Specifies a base-64 encoded string of custom data. The base-64 encoded string
is decoded to a binary array that is saved as a file on the Virtual Machine.
The maximum length of the binary array is 65535 bytes. For using cloud-init for
your VM, see [Using cloud-init to customize a Linux VM during
creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init)
""")
  customData?: string;

  @doc("Specifies Windows operating system settings on the virtual machine.")
  windowsConfiguration?: WindowsConfiguration;

  @doc("""
Specifies the Linux operating system settings on the virtual machine. For a
list of supported Linux distributions, see [Linux on Azure-Endorsed
Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
""")
  linuxConfiguration?: LinuxConfiguration;

  @doc("""
Specifies set of certificates that should be installed onto the virtual
machines in the scale set. To install certificates on a virtual machine it is
recommended to use the [Azure Key Vault virtual machine extension for
Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux)
or the [Azure Key Vault virtual machine extension for
Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
""")
  secrets?: VaultSecretGroup[];

  @doc("""
Specifies whether extension operations should be allowed on the virtual machine
scale set. This may only be set to False when no extensions are present on the
virtual machine scale set.
""")
  allowExtensionOperations?: boolean;

  @doc("Optional property which must either be set to True or omitted.")
  requireGuestProvisionSignal?: boolean;
}

@doc("Specifies Windows operating system settings on the virtual machine.")
model WindowsConfiguration {
  @doc("""
Indicates whether virtual machine agent should be provisioned on the virtual
machine. When this property is not specified in the request body, it is set to
true by default. This will ensure that VM Agent is installed on the VM so that
extensions can be added to the VM later.
""")
  provisionVMAgent?: boolean;

  @doc("""
Indicates whether Automatic Updates is enabled for the Windows virtual machine.
Default value is true. For virtual machine scale sets, this property can be
updated and updates will take effect on OS reprovisioning.
""")
  enableAutomaticUpdates?: boolean;

  @doc("""
Specifies the time zone of the virtual machine. e.g. \"Pacific Standard Time\".
Possible values can be
[TimeZoneInfo.Id](https://docs.microsoft.com/dotnet/api/system.timezoneinfo.id?#System_TimeZoneInfo_Id)
value from time zones returned by
[TimeZoneInfo.GetSystemTimeZones](https://docs.microsoft.com/dotnet/api/system.timezoneinfo.getsystemtimezones).
""")
  timeZone?: string;

  @doc("""
Specifies additional base-64 encoded XML formatted information that can be
included in the Unattend.xml file, which is used by Windows Setup.
""")
  additionalUnattendContent?: AdditionalUnattendContent[];

  @doc("[Preview Feature] Specifies settings related to VM Guest Patching on Windows.")
  patchSettings?: PatchSettings;

  @doc("""
Specifies the Windows Remote Management listeners. This enables remote Windows
PowerShell.
""")
  winRM?: WinRMConfiguration;

  @doc("""
Indicates whether VMAgent Platform Updates is enabled for the Windows virtual
machine. Default value is false.
""")
  enableVMAgentPlatformUpdates?: boolean;
}

@doc("""
Specifies additional XML formatted information that can be included in the
Unattend.xml file, which is used by Windows Setup. Contents are defined by
setting name, component name, and the pass in which the content is applied.
""")
model AdditionalUnattendContent {
  @doc("The pass name. Currently, the only allowable value is OobeSystem.")
  passName?: "OobeSystem";

  @doc("""
The component name. Currently, the only allowable value is
Microsoft-Windows-Shell-Setup.
""")
  componentName?: "Microsoft-Windows-Shell-Setup";

  @doc("""
Specifies the name of the setting to which the content applies. Possible values
are: FirstLogonCommands and AutoLogon.
""")
  settingName?: SettingNames;

  @doc("""
Specifies the XML formatted content that is added to the unattend.xml file for
the specified path and component. The XML must be less than 4KB and must
include the root element for the setting or feature that is being inserted.
""")
  content?: string;
}

@doc("Specifies settings related to VM Guest Patching on Windows.")
model PatchSettings {
  @doc("""
Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual
machines associated to virtual machine scale set with OrchestrationMode as
Flexible.<br /><br /> Possible values are:<br /><br /> **Manual** - You 
control the application of patches to a virtual machine. You do this by
applying patches manually inside the VM. In this mode, automatic updates are
disabled; the property WindowsConfiguration.enableAutomaticUpdates must be
false<br /><br /> **AutomaticByOS** - The virtual machine will automatically be
updated by the OS. The property WindowsConfiguration.enableAutomaticUpdates
must be true. <br /><br /> **AutomaticByPlatform** - the virtual machine will
automatically updated by the platform. The properties provisionVMAgent and
WindowsConfiguration.enableAutomaticUpdates must be true 
""")
  patchMode?: WindowsVMGuestPatchMode;

  @doc("""
Enables customers to patch their Azure VMs without requiring a reboot. For
enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode'
must be set to 'AutomaticByPlatform'.
""")
  enableHotpatching?: boolean;

  @doc("""
Specifies the mode of VM Guest patch assessment for the IaaS virtual
machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You
control the timing of patch assessments on a virtual machine.<br /><br />
**AutomaticByPlatform** - The platform will trigger periodic patch assessments.
The property provisionVMAgent must be true. 
""")
  assessmentMode?: WindowsPatchAssessmentMode;

  @doc("""
Specifies additional settings for patch mode AutomaticByPlatform in VM Guest
Patching on Windows.
""")
  automaticByPlatformSettings?: WindowsVMGuestPatchAutomaticByPlatformSettings;
}

@doc("""
Specifies additional settings to be applied when patch mode AutomaticByPlatform
is selected in Windows patch settings.
""")
model WindowsVMGuestPatchAutomaticByPlatformSettings {
  @doc("""
Specifies the reboot setting for all AutomaticByPlatform patch installation
operations.
""")
  rebootSetting?: WindowsVMGuestPatchAutomaticByPlatformRebootSetting;

  @doc("Enables customer to schedule patching without accidental upgrades")
  bypassPlatformSafetyChecksOnUserSchedule?: boolean;
}

@doc("Describes Windows Remote Management configuration of the VM")
model WinRMConfiguration {
  @doc("The list of Windows Remote Management listeners")
  listeners?: WinRMListener[];
}

@doc("Describes Protocol and thumbprint of Windows Remote Management listener")
model WinRMListener {
  @doc("""
Specifies the protocol of WinRM listener. Possible values are: **http,**
**https.**
""")
  protocol?: ProtocolTypes;

  @doc("""
This is the URL of a certificate that has been uploaded to Key Vault as a
secret. For adding a secret to the Key Vault, see [Add a key or secret to the
key
vault](https://docs.microsoft.com/azure/key-vault/key-vault-get-started/#add).
In this case, your certificate needs to be the Base64 encoding of the following
JSON Object which is encoded in UTF-8: <br><br> {<br> 
\"data\":\"<Base64-encoded-certificate>\",<br>  \"dataType\":\"pfx\",<br> 
\"password\":\"<pfx-file-password>\"<br>} <br> To install certificates on a
virtual machine it is recommended to use the [Azure Key Vault virtual machine
extension for
Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux)
or the [Azure Key Vault virtual machine extension for
Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
""")
  certificateUrl?: string;
}

@doc("""
Specifies the Linux operating system settings on the virtual machine. For a
list of supported Linux distributions, see [Linux on Azure-Endorsed
Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
""")
model LinuxConfiguration {
  @doc("Specifies whether password authentication should be disabled.")
  disablePasswordAuthentication?: boolean;

  @doc("Specifies the ssh key configuration for a Linux OS.")
  ssh?: SshConfiguration;

  @doc("""
Indicates whether virtual machine agent should be provisioned on the virtual
machine. When this property is not specified in the request body, default
behavior is to set it to true. This will ensure that VM Agent is installed on
the VM so that extensions can be added to the VM later.
""")
  provisionVMAgent?: boolean;

  @doc("[Preview Feature] Specifies settings related to VM Guest Patching on Linux.")
  patchSettings?: LinuxPatchSettings;

  @doc("""
Indicates whether VMAgent Platform Updates is enabled for the Linux virtual
machine. Default value is false.
""")
  enableVMAgentPlatformUpdates?: boolean;
}

@doc("SSH configuration for Linux based VMs running on Azure")
model SshConfiguration {
  @doc("The list of SSH public keys used to authenticate with linux based VMs.")
  publicKeys?: SshPublicKey[];
}

@doc("""
Contains information about SSH certificate public key and the path on the Linux
VM where the public key is placed.
""")
model SshPublicKey {
  @doc("""
Specifies the full path on the created VM where ssh public key is stored. If
the file already exists, the specified key is appended to the file. Example:
/home/user/.ssh/authorized_keys
""")
  path?: string;

  @doc("""
SSH public key certificate used to authenticate with the VM through ssh. The
key needs to be at least 2048-bit and in ssh-rsa format. For creating ssh keys,
see [Create SSH keys on Linux and Mac for Linux VMs in
Azure]https://docs.microsoft.com/azure/virtual-machines/linux/create-ssh-keys-detailed).
""")
  keyData?: string;
}

@doc("Specifies settings related to VM Guest Patching on Linux.")
model LinuxPatchSettings {
  @doc("""
Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual
machines associated to virtual machine scale set with OrchestrationMode as
Flexible.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - The
virtual machine's default patching configuration is used. <br /><br />
**AutomaticByPlatform** - The virtual machine will be automatically updated by
the platform. The property provisionVMAgent must be true
""")
  patchMode?: LinuxVMGuestPatchMode;

  @doc("""
Specifies the mode of VM Guest Patch Assessment for the IaaS virtual
machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You
control the timing of patch assessments on a virtual machine. <br /><br />
**AutomaticByPlatform** - The platform will trigger periodic patch assessments.
The property provisionVMAgent must be true.
""")
  assessmentMode?: LinuxPatchAssessmentMode;

  @doc("""
Specifies additional settings for patch mode AutomaticByPlatform in VM Guest
Patching on Linux.
""")
  automaticByPlatformSettings?: LinuxVMGuestPatchAutomaticByPlatformSettings;
}

@doc("""
Specifies additional settings to be applied when patch mode AutomaticByPlatform
is selected in Linux patch settings.
""")
model LinuxVMGuestPatchAutomaticByPlatformSettings {
  @doc("""
Specifies the reboot setting for all AutomaticByPlatform patch installation
operations.
""")
  rebootSetting?: LinuxVMGuestPatchAutomaticByPlatformRebootSetting;

  @doc("Enables customer to schedule patching without accidental upgrades")
  bypassPlatformSafetyChecksOnUserSchedule?: boolean;
}

@doc("Describes a set of certificates which are all in the same Key Vault.")
model VaultSecretGroup {
  @doc("""
The relative URL of the Key Vault containing all of the certificates in
VaultCertificates.
""")
  sourceVault?: SubResource;

  @doc("The list of key vault references in SourceVault which contain certificates.")
  vaultCertificates?: VaultCertificate[];
}

model SubResource {
  @doc("Resource Id")
  id?: string;
}

@doc("""
Describes a single certificate reference in a Key Vault, and where the
certificate should reside on the VM.
""")
model VaultCertificate {
  @doc("""
This is the URL of a certificate that has been uploaded to Key Vault as a
secret. For adding a secret to the Key Vault, see [Add a key or secret to the
key
vault](https://docs.microsoft.com/azure/key-vault/key-vault-get-started/#add).
In this case, your certificate needs to be It is the Base64 encoding of the
following JSON Object which is encoded in UTF-8: <br><br> {<br> 
\"data\":\"<Base64-encoded-certificate>\",<br>  \"dataType\":\"pfx\",<br> 
\"password\":\"<pfx-file-password>\"<br>} <br> To install certificates on a
virtual machine it is recommended to use the [Azure Key Vault virtual machine
extension for
Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux)
or the [Azure Key Vault virtual machine extension for
Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
""")
  certificateUrl?: string;

  @doc("""
For Windows VMs, specifies the certificate store on the Virtual Machine to
which the certificate should be added. The specified certificate store is
implicitly in the LocalMachine account. For Linux VMs, the certificate file is
placed under the /var/lib/waagent directory, with the file name
&lt;UppercaseThumbprint&gt;.crt for the X509 certificate file and
&lt;UppercaseThumbprint&gt;.prv for private key. Both of these files are .pem
formatted.
""")
  certificateStore?: string;
}

@doc("Describes a virtual machine scale set storage profile.")
model VirtualMachineScaleSetStorageProfile {
  @doc("""
Specifies information about the image to use. You can specify information about
platform images, marketplace images, or virtual machine images. This element is
required when you want to use a platform image, marketplace image, or virtual
machine image, but is not used in other creation operations.
""")
  imageReference?: ImageReference;

  @doc("""
Specifies information about the operating system disk used by the virtual
machines in the scale set. For more information about disks, see [About disks
and VHDs for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  osDisk?: VirtualMachineScaleSetOSDisk;

  @doc("""
Specifies the parameters that are used to add data disks to the virtual
machines in the scale set. For more information about disks, see [About disks
and VHDs for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  dataDisks?: VirtualMachineScaleSetDataDisk[];

  diskControllerType?: string;
}

@doc("""
Specifies information about the image to use. You can specify information about
platform images, marketplace images, or virtual machine images. This element is
required when you want to use a platform image, marketplace image, or virtual
machine image, but is not used in other creation operations. NOTE: Image
reference publisher and offer can only be set when you create the scale set.
""")
model ImageReference {
  ...SubResource;

  @doc("The image publisher.")
  publisher?: string;

  @doc("""
Specifies the offer of the platform image or marketplace image used to create
the virtual machine.
""")
  offer?: string;

  @doc("The image SKU.")
  sku?: string;

  @doc("""
Specifies the version of the platform image or marketplace image used to create
the virtual machine. The allowed formats are Major.Minor.Build or 'latest'.
Major, Minor, and Build are decimal numbers. Specify 'latest' to use the latest
version of an image available at deploy time. Even if you use 'latest', the VM
image will not automatically update after deploy time even if a new version
becomes available. Please do not use field 'version' for gallery image
deployment, gallery image should always use 'id' field for deployment, to use
'latest' version of gallery image, just set
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{imageName}'
in the 'id' field without version input.
""")
  version?: string;

  @doc("""
Specifies in decimal numbers, the version of platform image or marketplace
image used to create the virtual machine. This readonly field differs from
'version', only if the value specified in 'version' field is 'latest'.
""")
  @visibility("read")
  exactVersion?: string;

  @doc("""
Specified the shared gallery image unique id for vm deployment. This can be
fetched from shared gallery image GET call.
""")
  sharedGalleryImageId?: string;

  @doc("""
Specified the community gallery image unique id for vm deployment. This can be
fetched from community gallery image GET call.
""")
  communityGalleryImageId?: string;
}

@doc("Describes a virtual machine scale set operating system disk.")
model VirtualMachineScaleSetOSDisk {
  @doc("The disk name.")
  name?: string;

  @doc("""
Specifies the caching requirements. Possible values are: **None,**
**ReadOnly,** **ReadWrite.** The default values are: **None for Standard
storage. ReadOnly for Premium storage.**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("""
Specifies how the virtual machines in the scale set should be created. The only
allowed value is: **FromImage.** This value is used when you are using an image
to create the virtual machine. If you are using a platform image, you also use
the imageReference element described above. If you are using a marketplace
image, you  also use the plan element previously described.
""")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the ephemeral disk Settings for the operating system disk used by the
virtual machine scale set.
""")
  diffDiskSettings?: DiffDiskSettings;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. The property
'diskSizeGB' is the number of bytes x 1024^3 for the disk and the value cannot
be larger than 1023.
""")
  diskSizeGB?: int32;

  @doc("""
This property allows you to specify the type of the OS that is included in the
disk if creating a VM from user-image or a specialized VHD. Possible values
are: **Windows,** **Linux.**
""")
  osType?: OperatingSystemTypes;

  @doc("Specifies information about the unmanaged user image to base the scale set on.")
  image?: VirtualHardDisk;

  @doc("""
Specifies the container urls that are used to store operating system disks for
the scale set.
""")
  vhdContainers?: string[];

  @doc("The managed disk parameters.")
  managedDisk?: VirtualMachineScaleSetManagedDiskParameters;

  @doc("""
Specifies whether OS Disk should be deleted or detached upon VMSS Flex deletion
(This feature is available for VMSS with Flexible OrchestrationMode only).
<br><br> Possible values: <br><br> **Delete** If this value is used, the OS
disk is deleted when VMSS Flex VM is deleted.<br><br> **Detach** If this value
is used, the OS disk is retained after VMSS Flex VM is deleted. <br><br> The
default value is set to **Delete**. For an Ephemeral OS Disk, the default value
is set to **Delete**. User cannot change the delete option for Ephemeral OS
Disk.
""")
  deleteOption?: DiskDeleteOptionTypes;
}

@doc("""
Describes the parameters of ephemeral disk settings that can be specified for
operating system disk. **Note:** The ephemeral disk settings can only be
specified for managed disk.
""")
model DiffDiskSettings {
  @doc("Specifies the ephemeral disk settings for operating system disk.")
  option?: DiffDiskOptions;

  @doc("""
Specifies the ephemeral disk placement for operating system disk. Possible
values are: **CacheDisk,** **ResourceDisk.** The defaulting behavior is:
**CacheDisk** if one is configured for the VM size otherwise **ResourceDisk**
is used. Refer to the VM size documentation for Windows VM at
https://docs.microsoft.com/azure/virtual-machines/windows/sizes and Linux VM at
https://docs.microsoft.com/azure/virtual-machines/linux/sizes to check which VM
sizes exposes a cache disk.
""")
  placement?: DiffDiskPlacement;
}

@doc("Describes the uri of a disk.")
model VirtualHardDisk {
  @doc("Specifies the virtual hard disk's uri.")
  uri?: string;
}

@doc("Describes the parameters of a ScaleSet managed disk.")
model VirtualMachineScaleSetManagedDiskParameters {
  @doc("""
Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can
only be used with data disks, it cannot be used with OS Disk.
""")
  storageAccountType?: StorageAccountTypes;

  @doc("""
Specifies the customer managed disk encryption set resource id for the managed
disk.
""")
  diskEncryptionSet?: DiskEncryptionSetParameters;

  @doc("Specifies the security profile for the managed disk.")
  securityProfile?: VMDiskSecurityProfile;
}

@doc("""
Describes the parameter of customer managed disk encryption set resource id
that can be specified for disk. **Note:** The disk encryption set resource id
can only be specified for managed disk. Please refer
https://aka.ms/mdssewithcmkoverview for more details.
""")
model DiskEncryptionSetParameters {
  ...SubResource;
}

@doc("""
Specifies the security profile settings for the managed disk. **Note:** It can
only be set for Confidential VMs.
""")
model VMDiskSecurityProfile {
  @doc("""
Specifies the EncryptionType of the managed disk. It is set to
DiskWithVMGuestState for encryption of the managed disk along with VMGuestState
blob, and VMGuestStateOnly for encryption of just the VMGuestState blob.
**Note:** It can be set for only Confidential VMs.
""")
  securityEncryptionType?: SecurityEncryptionTypes;

  @doc("""
Specifies the customer managed disk encryption set resource id for the managed
disk that is used for Customer Managed Key encrypted ConfidentialVM OS Disk and
VMGuest blob.
""")
  diskEncryptionSet?: DiskEncryptionSetParameters;
}

@doc("Describes a virtual machine scale set data disk.")
model VirtualMachineScaleSetDataDisk {
  @doc("The disk name.")
  name?: string;

  @doc("""
Specifies the logical unit number of the data disk. This value is used to
identify data disks within the VM and therefore must be unique for each data
disk attached to a VM.
""")
  lun: int32;

  @doc("""
Specifies the caching requirements. Possible values are: **None,**
**ReadOnly,** **ReadWrite.** The default values are: **None for Standard
storage. ReadOnly for Premium storage.**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("The create option.")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. The property
diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be
larger than 1023.
""")
  diskSizeGB?: int32;

  @doc("The managed disk parameters.")
  managedDisk?: VirtualMachineScaleSetManagedDiskParameters;

  @doc("""
Specifies the Read-Write IOPS for the managed disk. Should be used only when
StorageAccountType is UltraSSD_LRS. If not specified, a default value would be
assigned based on diskSizeGB.
""")
  @projectedName("json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int32;

  @doc("""
Specifies the bandwidth in MB per second for the managed disk. Should be used
only when StorageAccountType is UltraSSD_LRS. If not specified, a default value
would be assigned based on diskSizeGB.
""")
  diskMBpsReadWrite?: int32;

  @doc("""
Specifies whether data disk should be deleted or detached upon VMSS Flex
deletion (This feature is available for VMSS with Flexible OrchestrationMode
only).<br><br> Possible values: <br><br> **Delete** If this value is used, the
data disk is deleted when the VMSS Flex VM is deleted.<br><br> **Detach** If
this value is used, the data disk is retained after VMSS Flex VM is
deleted.<br><br> The default value is set to **Delete**.
""")
  deleteOption?: DiskDeleteOptionTypes;
}

@doc("Describes a virtual machine scale set network profile.")
model VirtualMachineScaleSetNetworkProfile {
  @doc("""
A reference to a load balancer probe used to determine the health of an
instance in the virtual machine scale set. The reference will be in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}'.
""")
  healthProbe?: ApiEntityReference;

  @doc("The list of network configurations.")
  networkInterfaceConfigurations?: VirtualMachineScaleSetNetworkConfiguration[];

  @doc("""
specifies the Microsoft.Network API version used when creating networking
resources in the Network Interface Configurations for Virtual Machine Scale Set
with orchestration mode 'Flexible'
""")
  networkApiVersion?: NetworkApiVersion;
}

@doc("The API entity reference.")
model ApiEntityReference {
  @doc("""
The ARM resource id in the form of
/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/...
""")
  id?: string;
}

@doc("Describes a virtual machine scale set network profile's network configurations.")
model VirtualMachineScaleSetNetworkConfiguration {
  @doc("The network configuration name.")
  name: string;

  @doc("Describes a virtual machine scale set network profile's IP configuration.")
  properties?: VirtualMachineScaleSetNetworkConfigurationProperties;
}

@doc("Describes a virtual machine scale set network profile's IP configuration.")
model VirtualMachineScaleSetNetworkConfigurationProperties {
  @doc("""
Specifies the primary network interface in case the virtual machine has more
than 1 network interface.
""")
  primary?: boolean;

  @doc("Specifies whether the network interface is accelerated networking-enabled.")
  enableAcceleratedNetworking?: boolean;

  @doc("Specifies whether the network interface is disabled for tcp state tracking.")
  disableTcpStateTracking?: boolean;

  @doc("Specifies whether the network interface is FPGA networking-enabled.")
  enableFpga?: boolean;

  @doc("The network security group.")
  networkSecurityGroup?: SubResource;

  @doc("The dns settings to be applied on the network interfaces.")
  dnsSettings?: VirtualMachineScaleSetNetworkConfigurationDnsSettings;

  @doc("Specifies the IP configurations of the network interface.")
  ipConfigurations: VirtualMachineScaleSetIPConfiguration[];

  @doc("Whether IP forwarding enabled on this NIC.")
  enableIPForwarding?: boolean;

  @doc("Specify what happens to the network interface when the VM is deleted")
  deleteOption?: DeleteOptions;

  @doc("""
Specifies whether the Auxiliary mode is enabled for the Network Interface
resource.
""")
  auxiliaryMode?: NetworkInterfaceAuxiliaryMode;

  @doc("""
Specifies whether the Auxiliary sku is enabled for the Network Interface
resource.
""")
  auxiliarySku?: NetworkInterfaceAuxiliarySku;
}

@doc("Describes a virtual machines scale sets network configuration's DNS settings.")
model VirtualMachineScaleSetNetworkConfigurationDnsSettings {
  @doc("List of DNS servers IP addresses")
  dnsServers?: string[];
}

@doc("Describes a virtual machine scale set network profile's IP configuration.")
model VirtualMachineScaleSetIPConfiguration {
  @doc("The IP configuration name.")
  name: string;

  @doc("""
Describes a virtual machine scale set network profile's IP configuration
properties.
""")
  properties?: VirtualMachineScaleSetIPConfigurationProperties;
}

@doc("""
Describes a virtual machine scale set network profile's IP configuration
properties.
""")
model VirtualMachineScaleSetIPConfigurationProperties {
  @doc("Specifies the identifier of the subnet.")
  subnet?: ApiEntityReference;

  @doc("""
Specifies the primary network interface in case the virtual machine has more
than 1 network interface.
""")
  primary?: boolean;

  @doc("The publicIPAddressConfiguration.")
  publicIPAddressConfiguration?: VirtualMachineScaleSetPublicIPAddressConfiguration;

  @doc("""
Available from Api-Version 2017-03-30 onwards, it represents whether the
specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible
values are: 'IPv4' and 'IPv6'.
""")
  privateIPAddressVersion?: IPVersion;

  @doc("""
Specifies an array of references to backend address pools of application
gateways. A scale set can reference backend address pools of multiple
application gateways. Multiple scale sets cannot use the same application
gateway.
""")
  applicationGatewayBackendAddressPools?: SubResource[];

  @doc("Specifies an array of references to application security group.")
  applicationSecurityGroups?: SubResource[];

  @doc("""
Specifies an array of references to backend address pools of load balancers. A
scale set can reference backend address pools of one public and one internal
load balancer. Multiple scale sets cannot use the same basic sku load balancer.
""")
  loadBalancerBackendAddressPools?: SubResource[];

  @doc("""
Specifies an array of references to inbound Nat pools of the load balancers. A
scale set can reference inbound nat pools of one public and one internal load
balancer. Multiple scale sets cannot use the same basic sku load balancer.
""")
  loadBalancerInboundNatPools?: SubResource[];
}

@doc("""
Describes a virtual machines scale set IP Configuration's PublicIPAddress
configuration
""")
model VirtualMachineScaleSetPublicIPAddressConfiguration {
  @doc("The publicIP address configuration name.")
  name: string;

  @doc("""
Describes a virtual machines scale set IP Configuration's PublicIPAddress
configuration
""")
  properties?: VirtualMachineScaleSetPublicIPAddressConfigurationProperties;

  @doc("""
Describes the public IP Sku. It can only be set with OrchestrationMode as
Flexible.
""")
  sku?: PublicIPAddressSku;
}

@doc("""
Describes a virtual machines scale set IP Configuration's PublicIPAddress
configuration
""")
model VirtualMachineScaleSetPublicIPAddressConfigurationProperties {
  @doc("The idle timeout of the public IP address.")
  idleTimeoutInMinutes?: int32;

  @doc("The dns settings to be applied on the publicIP addresses .")
  dnsSettings?: VirtualMachineScaleSetPublicIPAddressConfigurationDnsSettings;

  @doc("The list of IP tags associated with the public IP address.")
  ipTags?: VirtualMachineScaleSetIpTag[];

  @doc("The PublicIPPrefix from which to allocate publicIP addresses.")
  publicIPPrefix?: SubResource;

  @doc("""
Available from Api-Version 2019-07-01 onwards, it represents whether the
specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4. Possible
values are: 'IPv4' and 'IPv6'.
""")
  publicIPAddressVersion?: IPVersion;

  @doc("Specify what happens to the public IP when the VM is deleted")
  deleteOption?: DeleteOptions;
}

@doc("Describes a virtual machines scale sets network configuration's DNS settings.")
model VirtualMachineScaleSetPublicIPAddressConfigurationDnsSettings {
  @doc("""
The Domain name label.The concatenation of the domain name label and vm index
will be the domain name labels of the PublicIPAddress resources that will be
created
""")
  domainNameLabel: string;

  @doc("""
The Domain name label scope.The concatenation of the hashed domain name label
that generated according to the policy from domain name label scope and vm
index will be the domain name labels of the PublicIPAddress resources that will
be created
""")
  domainNameLabelScope?: DomainNameLabelScopeTypes;
}

@doc("Contains the IP tag associated with the public IP address.")
model VirtualMachineScaleSetIpTag {
  @doc("IP tag type. Example: FirstPartyUsage.")
  ipTagType?: string;

  @doc("IP tag associated with the public IP. Example: SQL, Storage etc.")
  tag?: string;
}

@doc("""
Describes the public IP Sku. It can only be set with OrchestrationMode as
Flexible.
""")
model PublicIPAddressSku {
  @doc("Specify public IP sku name")
  name?: PublicIPAddressSkuName;

  @doc("Specify public IP sku tier")
  tier?: PublicIPAddressSkuTier;
}

@doc("""
Specifies the Security profile settings for the virtual machine or virtual
machine scale set.
""")
model SecurityProfile {
  @doc("""
Specifies the security settings like secure boot and vTPM used while creating
the virtual machine. Minimum api-version: 2020-12-01.
""")
  uefiSettings?: UefiSettings;

  @doc("""
This property can be used by user in the request to enable or disable the Host
Encryption for the virtual machine or virtual machine scale set. This will
enable the encryption for all the disks including Resource/Temp disk at host
itself. The default behavior is: The Encryption at host will be disabled unless
this property is set to true for the resource.
""")
  encryptionAtHost?: boolean;

  @doc("""
Specifies the SecurityType of the virtual machine. It has to be set to any
specified value to enable UefiSettings. The default behavior is: UefiSettings
will not be enabled unless this property is set.
""")
  securityType?: SecurityTypes;
}

@doc("""
Specifies the security settings like secure boot and vTPM used while creating
the virtual machine. Minimum api-version: 2020-12-01.
""")
model UefiSettings {
  @doc("""
Specifies whether secure boot should be enabled on the virtual machine. Minimum
api-version: 2020-12-01.
""")
  secureBootEnabled?: boolean;

  @doc("""
Specifies whether vTPM should be enabled on the virtual machine. Minimum
api-version: 2020-12-01.
""")
  vTpmEnabled?: boolean;
}

@doc("Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.")
model DiagnosticsProfile {
  @doc("""
Boot Diagnostics is a debugging feature which allows you to view Console Output
and Screenshot to diagnose VM status. **NOTE**: If storageUri is being
specified then ensure that the storage account is in the same region and
subscription as the VM. You can easily view the output of your console log.
Azure also enables you to see a screenshot of the VM from the hypervisor.
""")
  bootDiagnostics?: BootDiagnostics;
}

@doc("""
Boot Diagnostics is a debugging feature which allows you to view Console Output
and Screenshot to diagnose VM status. You can easily view the output of your
console log. Azure also enables you to see a screenshot of the VM from the
hypervisor.
""")
model BootDiagnostics {
  @doc("Whether boot diagnostics should be enabled on the Virtual Machine.")
  enabled?: boolean;

  @doc("""
Uri of the storage account to use for placing the console output and
screenshot. If storageUri is not specified while enabling boot diagnostics,
managed storage will be used.
""")
  storageUri?: string;
}

@doc("Describes a virtual machine scale set extension profile.")
model VirtualMachineScaleSetExtensionProfile {
  @doc("The virtual machine scale set child extension resources.")
  extensions?: VirtualMachineScaleSetExtension[];

  @doc("""
Specifies the time alloted for all extensions to start. The time duration
should be between 15 minutes and 120 minutes (inclusive) and should be
specified in ISO 8601 format. The default value is 90 minutes (PT1H30M).
Minimum api-version: 2020-06-01.
""")
  extensionsTimeBudget?: string;
}

@doc("Describes the properties of a Virtual Machine Scale Set Extension.")
model VirtualMachineScaleSetExtensionProperties {
  @doc("""
If a value is provided and is different from the previous value, the extension
handler will be forced to update even if the extension configuration has not
changed.
""")
  forceUpdateTag?: string;

  @doc("The name of the extension handler publisher.")
  publisher?: string;

  @doc("Specifies the type of the extension; an example is \"CustomScriptExtension\".")
  type?: string;

  @doc("Specifies the version of the script handler.")
  typeHandlerVersion?: string;

  @doc("""
Indicates whether the extension should use a newer minor version if one is
available at deployment time. Once deployed, however, the extension will not
upgrade minor versions unless redeployed, even with this property set to true.
""")
  autoUpgradeMinorVersion?: boolean;

  @doc("""
Indicates whether the extension should be automatically upgraded by the
platform if there is a newer version of the extension available.
""")
  enableAutomaticUpgrade?: boolean;

  @doc("Json formatted public settings for the extension.")
  settings?: Record<unknown>;

  @doc("""
The extension can contain either protectedSettings or
protectedSettingsFromKeyVault or no protected settings at all.
""")
  protectedSettings?: Record<unknown>;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
Collection of extension names after which this extension needs to be
provisioned.
""")
  provisionAfterExtensions?: string[];

  @doc("""
Indicates whether failures stemming from the extension will be suppressed
(Operational failures such as not connecting to the VM will not be suppressed
regardless of this value). The default is false.
""")
  suppressFailures?: boolean;

  @doc("""
The extensions protected settings that are passed by reference, and consumed
from key vault
""")
  protectedSettingsFromKeyVault?: KeyVaultSecretReference;
}

@doc("Describes a reference to Key Vault Secret")
model KeyVaultSecretReference {
  @doc("The URL referencing a secret in a Key Vault.")
  secretUrl: string;

  @doc("The relative URL of the Key Vault containing the secret.")
  sourceVault: SubResource;
}

model SubResourceReadOnly {
  @doc("Resource Id")
  @visibility("read")
  id?: string;
}

@doc("""
Specifies the billing related details of a Azure Spot VM or VMSS. Minimum
api-version: 2019-03-01.
""")
model BillingProfile {
  @doc("""
Specifies the maximum price you are willing to pay for a Azure Spot VM/VMSS.
This price is in US Dollars. <br><br> This price will be compared with the
current Azure Spot price for the VM size. Also, the prices are compared at the
time of create/update of Azure Spot VM/VMSS and the operation will only succeed
if  the maxPrice is greater than the current Azure Spot price. <br><br> The
maxPrice will also be used for evicting a Azure Spot VM/VMSS if the current
Azure Spot price goes beyond the maxPrice after creation of VM/VMSS. <br><br>
Possible values are: <br><br> - Any decimal value greater than zero. Example:
0.01538 <br><br> -1 – indicates default price to be up-to on-demand. <br><br>
You can set the maxPrice to -1 to indicate that the Azure Spot VM/VMSS should
not be evicted for price reasons. Also, the default max price is -1 if it is
not provided by you. <br><br>Minimum api-version: 2019-03-01.
""")
  maxPrice?: float32;
}

model ScheduledEventsProfile {
  @doc("Specifies Terminate Scheduled Event related configurations.")
  terminateNotificationProfile?: TerminateNotificationProfile;

  @doc("Specifies OS Image Scheduled Event related configurations.")
  osImageNotificationProfile?: OSImageNotificationProfile;
}

model TerminateNotificationProfile {
  @doc("""
Configurable length of time a Virtual Machine being deleted will have to
potentially approve the Terminate Scheduled Event before the event is auto
approved (timed out). The configuration must be specified in ISO 8601 format,
the default value is 5 minutes (PT5M)
""")
  notBeforeTimeout?: string;

  @doc("Specifies whether the Terminate Scheduled event is enabled or disabled.")
  enable?: boolean;
}

model OSImageNotificationProfile {
  @doc("""
Length of time a Virtual Machine being reimaged or having its OS upgraded will
have to potentially approve the OS Image Scheduled Event before the event is
auto approved (timed out). The configuration is specified in ISO 8601 format,
and the value must be 15 minutes (PT15M)
""")
  notBeforeTimeout?: string;

  @doc("Specifies whether the OS Image Scheduled event is enabled or disabled.")
  enable?: boolean;
}

@doc("The parameters of a capacity reservation Profile.")
model CapacityReservationProfile {
  @doc("""
Specifies the capacity reservation group resource id that should be used for
allocating the virtual machine or scaleset vm instances provided enough
capacity has been reserved. Please refer to https://aka.ms/CapacityReservation
for more details.
""")
  capacityReservationGroup?: SubResource;
}

@doc("""
Contains the list of gallery applications that should be made available to the
VM/VMSS
""")
model ApplicationProfile {
  @doc("Specifies the gallery applications that should be made available to the VM/VMSS")
  galleryApplications?: VMGalleryApplication[];
}

@doc("""
Specifies the required information to reference a compute gallery application
version
""")
model VMGalleryApplication {
  @doc("Optional, Specifies a passthrough value for more generic context.")
  tags?: string;

  @doc("Optional, Specifies the order in which the packages have to be installed")
  order?: int32;

  @doc("""
Specifies the GalleryApplicationVersion resource id on the form of
/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{application}/versions/{version}
""")
  packageReferenceId: string;

  @doc("""
Optional, Specifies the uri to an azure blob that will replace the default
configuration for the package if provided
""")
  configurationReference?: string;

  @doc("""
Optional, If true, any failure for any operation in the VmApplication will fail
the deployment
""")
  treatFailureAsDeploymentFailure?: boolean;

  @doc("""
If set to true, when a new Gallery Application version is available in PIR/SIG,
it will be automatically updated for the VM/VMSS
""")
  enableAutomaticUpgrade?: boolean;
}

@doc("Specifies the hardware settings for the virtual machine scale set.")
model VirtualMachineScaleSetHardwareProfile {
  @doc("""
Specifies the properties for customizing the size of the virtual machine.
Minimum api-version: 2021-11-01. Please follow the instructions in [VM
Customization](https://aka.ms/vmcustomization) for more details.
""")
  vmSizeProperties?: VMSizeProperties;
}

@doc("Specifies VM Size Property settings on the virtual machine.")
model VMSizeProperties {
  @doc("""
Specifies the number of vCPUs available for the VM. When this property is not
specified in the request body the default behavior is to set it to the value of
vCPUs available for that VM size exposed in api response of [List all available
virtual machine sizes in a
region](https://docs.microsoft.com/en-us/rest/api/compute/resource-skus/list).
""")
  vCPUsAvailable?: int32;

  @doc("""
Specifies the vCPU to physical core ratio. When this property is not specified
in the request body the default behavior is set to the value of vCPUsPerCore
for the VM Size exposed in api response of [List all available virtual machine
sizes in a
region](https://docs.microsoft.com/en-us/rest/api/compute/resource-skus/list).
**Setting this property to 1 also means that hyper-threading is disabled.**
""")
  vCPUsPerCore?: int32;
}

@doc("""
Specifies the service artifact reference id used to set same image version for
all virtual machines in the scale set when using 'latest' image version.
Minimum api-version: 2022-11-01
""")
model ServiceArtifactReference {
  @doc("""
The service artifact reference id in the form of
/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/galleries/{galleryName}/serviceArtifacts/{serviceArtifactName}/vmArtifactsProfiles/{vmArtifactsProfilesName}
""")
  id?: string;
}

@doc("""
Specifies the security posture to be used for all virtual machines in the scale
set. Minimum api-version: 2023-03-01
""")
model SecurityPostureReference {
  @doc("""
The security posture reference id in the form of
/CommunityGalleries/{communityGalleryName}/securityPostures/{securityPostureName}/versions/{major.minor.patch}|{major.*}|latest
""")
  id?: string;

  @doc("""
List of virtual machine extensions to exclude when applying the Security
Posture.
""")
  excludeExtensions?: VirtualMachineExtension[];
}

@doc("Describes the properties of a Virtual Machine Extension.")
model VirtualMachineExtensionProperties {
  @doc("""
How the extension handler should be forced to update even if the extension
configuration has not changed.
""")
  forceUpdateTag?: string;

  @doc("The name of the extension handler publisher.")
  publisher?: string;

  @doc("Specifies the type of the extension; an example is \"CustomScriptExtension\".")
  type?: string;

  @doc("Specifies the version of the script handler.")
  typeHandlerVersion?: string;

  @doc("""
Indicates whether the extension should use a newer minor version if one is
available at deployment time. Once deployed, however, the extension will not
upgrade minor versions unless redeployed, even with this property set to true.
""")
  autoUpgradeMinorVersion?: boolean;

  @doc("""
Indicates whether the extension should be automatically upgraded by the
platform if there is a newer version of the extension available.
""")
  enableAutomaticUpgrade?: boolean;

  @doc("Json formatted public settings for the extension.")
  settings?: Record<unknown>;

  @doc("""
The extension can contain either protectedSettings or
protectedSettingsFromKeyVault or no protected settings at all.
""")
  protectedSettings?: Record<unknown>;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("The virtual machine extension instance view.")
  instanceView?: VirtualMachineExtensionInstanceView;

  @doc("""
Indicates whether failures stemming from the extension will be suppressed
(Operational failures such as not connecting to the VM will not be suppressed
regardless of this value). The default is false.
""")
  suppressFailures?: boolean;

  @doc("""
The extensions protected settings that are passed by reference, and consumed
from key vault
""")
  protectedSettingsFromKeyVault?: KeyVaultSecretReference;

  @doc("""
Collection of extension names after which this extension needs to be
provisioned.
""")
  provisionAfterExtensions?: string[];
}

@doc("The instance view of a virtual machine extension.")
model VirtualMachineExtensionInstanceView {
  @doc("The virtual machine extension name.")
  name?: string;

  @doc("Specifies the type of the extension; an example is \"CustomScriptExtension\".")
  type?: string;

  @doc("Specifies the version of the script handler.")
  typeHandlerVersion?: string;

  @doc("The resource status information.")
  substatuses?: InstanceViewStatus[];

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("Instance view status.")
model InstanceViewStatus {
  @doc("The status code.")
  code?: string;

  @doc("The level code.")
  level?: StatusLevelTypes;

  @doc("The short localizable label for the status.")
  displayStatus?: string;

  @doc("The detailed status message, including for alerts and error messages.")
  message?: string;

  @doc("The time of the status.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  time?: utcDateTime;
}

@doc("The Resource model definition with location property as optional.")
model ResourceWithOptionalLocation {
  @doc("Resource location")
  location?: string;

  @doc("Resource Id")
  @visibility("read")
  id?: string;

  @doc("Resource name")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Resource tags")
  tags?: Record<string>;
}

@doc("""
Enables or disables a capability on the virtual machine or virtual machine
scale set.
""")
model AdditionalCapabilities {
  @doc("""
The flag that enables or disables a capability to have one or more managed data
disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks
with storage account type UltraSSD_LRS can be added to a virtual machine or
virtual machine scale set only if this property is enabled.
""")
  ultraSSDEnabled?: boolean;

  @doc("The flag that enables or disables hibernation capability on the VM.")
  hibernationEnabled?: boolean;
}

@doc("Describes a scale-in policy for a virtual machine scale set.")
model ScaleInPolicy {
  @doc("""
The rules to be followed when scaling-in a virtual machine scale set. <br><br>
Possible values are: <br><br> **Default** When a virtual machine scale set is
scaled in, the scale set will first be balanced across zones if it is a zonal
scale set. Then, it will be balanced across Fault Domains as far as possible.
Within each Fault Domain, the virtual machines chosen for removal will be the
newest ones that are not protected from scale-in. <br><br> **OldestVM** When a
virtual machine scale set is being scaled-in, the oldest virtual machines that
are not protected from scale-in will be chosen for removal. For zonal virtual
machine scale sets, the scale set will first be balanced across zones. Within
each zone, the oldest virtual machines that are not protected will be chosen
for removal. <br><br> **NewestVM** When a virtual machine scale set is being
scaled-in, the newest virtual machines that are not protected from scale-in
will be chosen for removal. For zonal virtual machine scale sets, the scale set
will first be balanced across zones. Within each zone, the newest virtual
machines that are not protected will be chosen for removal. <br><br>
""")
  rules?: VirtualMachineScaleSetScaleInRules[];

  @doc("""
This property allows you to specify if virtual machines chosen for removal have
to be force deleted when a virtual machine scale set is being
scaled-in.(Feature in Preview)
""")
  forceDeletion?: boolean;
}

@doc("""
Specifies the Spot-Try-Restore properties for the virtual machine scale set.
With this property customer can enable or disable automatic restore of the
evicted Spot VMSS VM instances opportunistically based on capacity availability
and pricing constraint.
""")
model SpotRestorePolicy {
  @doc("""
Enables the Spot-Try-Restore feature where evicted VMSS SPOT instances will be
tried to be restored opportunistically based on capacity availability and
pricing constraints
""")
  enabled?: boolean;

  @doc("""
Timeout value expressed as an ISO 8601 time duration after which the platform
will not try to restore the VMSS SPOT instances
""")
  restoreTimeout?: string;
}

@doc("""
Specifies the target splits for Spot and Regular priority VMs within a scale
set with flexible orchestration mode. With this property the customer is able
to specify the base number of regular priority VMs created as the VMSS flex
instance scales out and the split between Spot and Regular priority VMs after
this base target has been reached.
""")
model PriorityMixPolicy {
  @doc("""
The base number of regular priority VMs that will be created in this scale set
as it scales out.
""")
  baseRegularPriorityCount?: int32;

  @doc("""
The percentage of VM instances, after the base regular priority count has been
reached, that are expected to use regular priority.
""")
  regularPriorityPercentageAboveBase?: int32;
}

@doc("Identity for the virtual machine scale set.")
model VirtualMachineScaleSetIdentity {
  @doc("""
The principal id of virtual machine scale set identity. This property will only
be provided for a system assigned identity.
""")
  @visibility("read")
  principalId?: string;

  @doc("""
The tenant id associated with the virtual machine scale set. This property will
only be provided for a system assigned identity.
""")
  @visibility("read")
  tenantId?: string;

  @doc("""
The type of identity used for the virtual machine scale set. The type
'SystemAssigned, UserAssigned' includes both an implicitly created identity and
a set of user assigned identities. The type 'None' will remove any identities
from the virtual machine scale set.
""")
  type?: ResourceIdentityType;

  @doc("""
The list of user identities associated with the virtual machine scale set. The
user identity dictionary key references will be ARM resource ids in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

model UserAssignedIdentitiesValue {
  @doc("The principal id of user assigned identity.")
  @visibility("read")
  principalId?: string;

  @doc("The client id of user assigned identity.")
  @visibility("read")
  clientId?: string;
}

@doc("The complex type of the extended location.")
model ExtendedLocation {
  @doc("The name of the extended location.")
  name?: string;

  @doc("The type of the extended location.")
  type?: ExtendedLocationTypes;
}

@doc("Describes a virtual machine scale set virtual machine profile.")
model VirtualMachineScaleSetUpdateVMProfile {
  @doc("The virtual machine scale set OS profile.")
  osProfile?: VirtualMachineScaleSetUpdateOSProfile;

  @doc("The virtual machine scale set storage profile.")
  storageProfile?: VirtualMachineScaleSetUpdateStorageProfile;

  @doc("The virtual machine scale set network profile.")
  networkProfile?: VirtualMachineScaleSetUpdateNetworkProfile;

  @doc("The virtual machine scale set Security profile")
  securityProfile?: SecurityProfile;

  @doc("The virtual machine scale set diagnostics profile.")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("The virtual machine scale set extension profile.")
  extensionProfile?: VirtualMachineScaleSetExtensionProfile;

  @doc("The license type, which is for bring your own license scenario.")
  licenseType?: string;

  @doc("""
Specifies the billing related details of a Azure Spot VMSS. Minimum
api-version: 2019-03-01.
""")
  billingProfile?: BillingProfile;

  @doc("Specifies Scheduled Event related configurations.")
  scheduledEventsProfile?: ScheduledEventsProfile;

  @doc("""
UserData for the VM, which must be base-64 encoded. Customer should not pass
any secrets in here. <br><br>Minimum api-version: 2021-03-01
""")
  userData?: string;

  @doc("""
Specifies the hardware profile related details of a scale set. Minimum
api-version: 2021-11-01.
""")
  hardwareProfile?: VirtualMachineScaleSetHardwareProfile;
}

@doc("Describes a virtual machine scale set OS profile.")
model VirtualMachineScaleSetUpdateOSProfile {
  @doc("A base-64 encoded string of custom data.")
  customData?: string;

  @doc("The Windows Configuration of the OS profile.")
  windowsConfiguration?: WindowsConfiguration;

  @doc("The Linux Configuration of the OS profile.")
  linuxConfiguration?: LinuxConfiguration;

  @doc("The List of certificates for addition to the VM.")
  secrets?: VaultSecretGroup[];
}

@doc("Describes a virtual machine scale set storage profile.")
model VirtualMachineScaleSetUpdateStorageProfile {
  @doc("The image reference.")
  imageReference?: ImageReference;

  @doc("The OS disk.")
  osDisk?: VirtualMachineScaleSetUpdateOSDisk;

  @doc("The data disks.")
  dataDisks?: VirtualMachineScaleSetDataDisk[];

  diskControllerType?: string;
}

@doc("""
Describes virtual machine scale set operating system disk Update Object. This
should be used for Updating VMSS OS Disk.
""")
model VirtualMachineScaleSetUpdateOSDisk {
  @doc("The caching type.")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. <br><br>
diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be
larger than 1023
""")
  diskSizeGB?: int32;

  @doc("""
The Source User Image VirtualHardDisk. This VirtualHardDisk will be copied
before using it to attach to the Virtual Machine. If SourceImage is provided,
the destination VirtualHardDisk should not exist.
""")
  image?: VirtualHardDisk;

  @doc("The list of virtual hard disk container uris.")
  vhdContainers?: string[];

  @doc("The managed disk parameters.")
  managedDisk?: VirtualMachineScaleSetManagedDiskParameters;

  @doc("""
Specifies whether OS Disk should be deleted or detached upon VMSS Flex deletion
(This feature is available for VMSS with Flexible OrchestrationMode only).
<br><br> Possible values: <br><br> **Delete** If this value is used, the OS
disk is deleted when VMSS Flex VM is deleted.<br><br> **Detach** If this value
is used, the OS disk is retained after VMSS Flex VM is deleted. <br><br> The
default value is set to **Delete**. For an Ephemeral OS Disk, the default value
is set to **Delete**. User cannot change the delete option for Ephemeral OS
Disk.
""")
  deleteOption?: DiskDeleteOptionTypes;
}

@doc("Describes a virtual machine scale set network profile.")
model VirtualMachineScaleSetUpdateNetworkProfile {
  @doc("""
A reference to a load balancer probe used to determine the health of an
instance in the virtual machine scale set. The reference will be in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}'.
""")
  healthProbe?: ApiEntityReference;

  @doc("The list of network configurations.")
  networkInterfaceConfigurations?: VirtualMachineScaleSetUpdateNetworkConfiguration[];

  @doc("""
specifies the Microsoft.Network API version used when creating networking
resources in the Network Interface Configurations for Virtual Machine Scale Set
with orchestration mode 'Flexible'
""")
  networkApiVersion?: NetworkApiVersion;
}

@doc("Describes a virtual machine scale set network profile's network configurations.")
model VirtualMachineScaleSetUpdateNetworkConfiguration {
  @doc("The network configuration name.")
  name?: string;

  @doc("""
Describes a virtual machine scale set updatable network profile's IP
configuration.Use this object for updating network profile's IP Configuration.
""")
  properties?: VirtualMachineScaleSetUpdateNetworkConfigurationProperties;
}

@doc("""
Describes a virtual machine scale set updatable network profile's IP
configuration.Use this object for updating network profile's IP Configuration.
""")
model VirtualMachineScaleSetUpdateNetworkConfigurationProperties {
  @doc("Whether this is a primary NIC on a virtual machine.")
  primary?: boolean;

  @doc("Specifies whether the network interface is accelerated networking-enabled.")
  enableAcceleratedNetworking?: boolean;

  @doc("Specifies whether the network interface is disabled for tcp state tracking.")
  disableTcpStateTracking?: boolean;

  @doc("Specifies whether the network interface is FPGA networking-enabled.")
  enableFpga?: boolean;

  @doc("The network security group.")
  networkSecurityGroup?: SubResource;

  @doc("The dns settings to be applied on the network interfaces.")
  dnsSettings?: VirtualMachineScaleSetNetworkConfigurationDnsSettings;

  @doc("The virtual machine scale set IP Configuration.")
  ipConfigurations?: VirtualMachineScaleSetUpdateIPConfiguration[];

  @doc("Whether IP forwarding enabled on this NIC.")
  enableIPForwarding?: boolean;

  @doc("Specify what happens to the network interface when the VM is deleted")
  deleteOption?: DeleteOptions;

  @doc("""
Specifies whether the Auxiliary mode is enabled for the Network Interface
resource.
""")
  auxiliaryMode?: NetworkInterfaceAuxiliaryMode;

  @doc("""
Specifies whether the Auxiliary sku is enabled for the Network Interface
resource.
""")
  auxiliarySku?: NetworkInterfaceAuxiliarySku;
}

@doc("""
Describes a virtual machine scale set network profile's IP configuration. NOTE:
The subnet of a scale set may be modified as long as the original subnet and
the new subnet are in the same virtual network
""")
model VirtualMachineScaleSetUpdateIPConfiguration {
  @doc("The IP configuration name.")
  name?: string;

  @doc("""
Describes a virtual machine scale set network profile's IP configuration
properties.
""")
  properties?: VirtualMachineScaleSetUpdateIPConfigurationProperties;
}

@doc("""
Describes a virtual machine scale set network profile's IP configuration
properties.
""")
model VirtualMachineScaleSetUpdateIPConfigurationProperties {
  @doc("The subnet.")
  subnet?: ApiEntityReference;

  @doc("""
Specifies the primary IP Configuration in case the network interface has more
than one IP Configuration.
""")
  primary?: boolean;

  @doc("The publicIPAddressConfiguration.")
  publicIPAddressConfiguration?: VirtualMachineScaleSetUpdatePublicIPAddressConfiguration;

  @doc("""
Available from Api-Version 2017-03-30 onwards, it represents whether the
specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible
values are: 'IPv4' and 'IPv6'.
""")
  privateIPAddressVersion?: IPVersion;

  @doc("The application gateway backend address pools.")
  applicationGatewayBackendAddressPools?: SubResource[];

  @doc("Specifies an array of references to application security group.")
  applicationSecurityGroups?: SubResource[];

  @doc("The load balancer backend address pools.")
  loadBalancerBackendAddressPools?: SubResource[];

  @doc("The load balancer inbound nat pools.")
  loadBalancerInboundNatPools?: SubResource[];
}

@doc("""
Describes a virtual machines scale set IP Configuration's PublicIPAddress
configuration
""")
model VirtualMachineScaleSetUpdatePublicIPAddressConfiguration {
  @doc("The publicIP address configuration name.")
  name?: string;

  @doc("""
Describes a virtual machines scale set IP Configuration's PublicIPAddress
configuration
""")
  properties?: VirtualMachineScaleSetUpdatePublicIPAddressConfigurationProperties;
}

@doc("""
Describes a virtual machines scale set IP Configuration's PublicIPAddress
configuration
""")
model VirtualMachineScaleSetUpdatePublicIPAddressConfigurationProperties {
  @doc("The idle timeout of the public IP address.")
  idleTimeoutInMinutes?: int32;

  @doc("The dns settings to be applied on the publicIP addresses .")
  dnsSettings?: VirtualMachineScaleSetPublicIPAddressConfigurationDnsSettings;

  @doc("The PublicIPPrefix from which to allocate publicIP addresses.")
  publicIPPrefix?: SubResource;

  @doc("Specify what happens to the public IP when the VM is deleted")
  deleteOption?: DeleteOptions;
}

@doc("The Update Resource model definition.")
model UpdateResource {
  @doc("Resource tags")
  tags?: Record<string>;
}

@doc("Specifies a list of virtual machine instance IDs from the VM scale set.")
model VirtualMachineScaleSetVMInstanceIDs {
  @doc("""
The virtual machine scale set instance ids. Omitting the virtual machine scale
set instance ids will result in the operation being performed on all virtual
machines in the virtual machine scale set.
""")
  instanceIds?: string[];
}

@doc("Specifies a list of virtual machine instance IDs from the VM scale set.")
model VirtualMachineScaleSetVMInstanceRequiredIDs {
  @doc("The virtual machine scale set instance ids.")
  instanceIds: string[];
}

@doc("The instance view of a virtual machine scale set.")
model VirtualMachineScaleSetInstanceView {
  @doc("The instance view status summary for the virtual machine scale set.")
  @visibility("read")
  virtualMachine?: VirtualMachineScaleSetInstanceViewStatusesSummary;

  @doc("The extensions information.")
  @visibility("read")
  extensions?: VirtualMachineScaleSetVMExtensionsSummary[];

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];

  @doc("The orchestration services information.")
  @visibility("read")
  orchestrationServices?: OrchestrationServiceSummary[];
}

@doc("""
Instance view statuses summary for virtual machines of a virtual machine scale
set.
""")
model VirtualMachineScaleSetInstanceViewStatusesSummary {
  @doc("The extensions information.")
  @visibility("read")
  statusesSummary?: VirtualMachineStatusCodeCount[];
}

@doc("""
The status code and count of the virtual machine scale set instance view status
summary.
""")
model VirtualMachineStatusCodeCount {
  @doc("The instance view status code.")
  @visibility("read")
  code?: string;

  @doc("The number of instances having a particular status code.")
  @visibility("read")
  count?: int32;
}

@doc("Extensions summary for virtual machines of a virtual machine scale set.")
model VirtualMachineScaleSetVMExtensionsSummary {
  @doc("The extension name.")
  @visibility("read")
  name?: string;

  @doc("The extensions information.")
  @visibility("read")
  statusesSummary?: VirtualMachineStatusCodeCount[];
}

@doc("Summary for an orchestration service of a virtual machine scale set.")
model OrchestrationServiceSummary {
  @doc("The name of the service.")
  @visibility("read")
  serviceName?: OrchestrationServiceNames;

  @doc("The current state of the service.")
  @visibility("read")
  serviceState?: OrchestrationServiceState;
}

@doc("The Virtual Machine Scale Set List Skus operation response.")
model VirtualMachineScaleSetListSkusResult
  is Azure.Core.Page<VirtualMachineScaleSetSku>;

@doc("Describes an available virtual machine scale set sku.")
model VirtualMachineScaleSetSku {
  @doc("The type of resource the sku applies to.")
  @visibility("read")
  resourceType?: string;

  @doc("The Sku.")
  @visibility("read")
  sku?: Sku;

  @doc("Specifies the number of virtual machines in the scale set.")
  @visibility("read")
  capacity?: VirtualMachineScaleSetSkuCapacity;
}

@doc("Describes scaling information of a sku.")
model VirtualMachineScaleSetSkuCapacity {
  @doc("The minimum capacity.")
  @visibility("read")
  minimum?: int32;

  @doc("The maximum capacity that can be set.")
  @visibility("read")
  maximum?: int32;

  @doc("The default capacity.")
  @visibility("read")
  defaultCapacity?: int32;

  @doc("The scale type applicable to the sku.")
  @visibility("read")
  scaleType?: VirtualMachineScaleSetSkuScaleType;
}

@doc("List of Virtual Machine Scale Set OS Upgrade History operation response.")
model VirtualMachineScaleSetListOSUpgradeHistory
  is Azure.Core.Page<UpgradeOperationHistoricalStatusInfo>;

@doc("Virtual Machine Scale Set OS Upgrade History operation response.")
model UpgradeOperationHistoricalStatusInfo {
  @doc("Information about the properties of the upgrade operation.")
  @visibility("read")
  properties?: UpgradeOperationHistoricalStatusInfoProperties;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Resource location")
  @visibility("read")
  location?: string;
}

@doc("Describes each OS upgrade on the Virtual Machine Scale Set.")
model UpgradeOperationHistoricalStatusInfoProperties {
  @doc("Information about the overall status of the upgrade operation.")
  @visibility("read")
  runningStatus?: UpgradeOperationHistoryStatus;

  @doc("Counts of the VMs in each state.")
  @visibility("read")
  progress?: RollingUpgradeProgressInfo;

  @doc("Error Details for this upgrade if there are any.")
  @visibility("read")
  error?: ApiError;

  @doc("Invoker of the Upgrade Operation")
  @visibility("read")
  startedBy?: UpgradeOperationInvoker;

  @doc("Image Reference details")
  @visibility("read")
  targetImageReference?: ImageReference;

  @doc("Information about OS rollback if performed")
  @visibility("read")
  rollbackInfo?: RollbackStatusInfo;
}

@doc("Information about the current running state of the overall upgrade.")
model UpgradeOperationHistoryStatus {
  @doc("Code indicating the current status of the upgrade.")
  @visibility("read")
  code?: UpgradeState;

  @doc("Start time of the upgrade.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("End time of the upgrade.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;
}

@doc("Information about the number of virtual machine instances in each upgrade state.")
model RollingUpgradeProgressInfo {
  @doc("The number of instances that have been successfully upgraded.")
  @visibility("read")
  successfulInstanceCount?: int32;

  @doc("The number of instances that have failed to be upgraded successfully.")
  @visibility("read")
  failedInstanceCount?: int32;

  @doc("The number of instances that are currently being upgraded.")
  @visibility("read")
  inProgressInstanceCount?: int32;

  @doc("The number of instances that have not yet begun to be upgraded.")
  @visibility("read")
  pendingInstanceCount?: int32;
}

@doc("Information about rollback on failed VM instances after a OS Upgrade operation.")
model RollbackStatusInfo {
  @doc("The number of instances which have been successfully rolled back.")
  @visibility("read")
  successfullyRolledbackInstanceCount?: int32;

  @doc("The number of instances which failed to rollback.")
  @visibility("read")
  failedRolledbackInstanceCount?: int32;

  @doc("Error details if OS rollback failed.")
  @visibility("read")
  rollbackError?: ApiError;
}

@doc("Describes a Virtual Machine Scale Set VM Reimage Parameters.")
model VirtualMachineScaleSetReimageParameters {
  ...VirtualMachineScaleSetVMReimageParameters;

  @doc("""
The virtual machine scale set instance ids. Omitting the virtual machine scale
set instance ids will result in the operation being performed on all virtual
machines in the virtual machine scale set.
""")
  instanceIds?: string[];
}

@doc("Describes a Virtual Machine Scale Set VM Reimage Parameters.")
model VirtualMachineScaleSetVMReimageParameters {
  ...VirtualMachineReimageParameters;
}

@doc("""
Parameters for Reimaging Virtual Machine. NOTE: Virtual Machine OS disk will
always be reimaged
""")
model VirtualMachineReimageParameters {
  @doc("""
Specifies whether to reimage temp disk. Default value: false. Note: This temp
disk reimage parameter is only supported for VM/VMSS with Ephemeral OS disk.
""")
  tempDisk?: boolean;

  @doc("""
Specifies in decimal number, the version the OS disk should be reimaged to. If
exact version is not provided, the OS disk is reimaged to the existing version
of OS Disk.
""")
  exactVersion?: string;

  @doc("Specifies information required for reimaging the non-ephemeral OS disk.")
  osProfile?: OSProfileProvisioningData;
}

@doc("Additional parameters for Reimaging Non-Ephemeral Virtual Machine.")
model OSProfileProvisioningData {
  @doc("""
Specifies the password of the administrator account. <br><br> **Minimum-length
(Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters
<br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length
(Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4
conditions below need to be fulfilled <br> Has lower characters <br>Has upper
characters <br> Has a digit <br> Has a special character (Regex match [\\W_])
<br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\",
\"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\",
\"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to
reset the Remote Desktop service or its login password in a Windows
VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp)
<br><br> For resetting root password, see [Manage users, SSH, and check or
repair disks on Azure Linux VMs using the VMAccess
Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)
""")
  adminPassword?: string;

  @doc("""
Specifies a base-64 encoded string of custom data. The base-64 encoded string
is decoded to a binary array that is saved as a file on the Virtual Machine.
The maximum length of the binary array is 65535 bytes. **Note: Do not pass any
secrets or passwords in customData property.** This property cannot be updated
after the VM is created. The property customData is passed to the VM to be
saved as a file, for more information see [Custom Data on Azure
VMs](https://azure.microsoft.com/blog/custom-data-and-cloud-init-on-windows-azure/).
If using cloud-init for your Linux VM, see [Using cloud-init to customize a
Linux VM during
creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init).
""")
  customData?: string;
}

@doc("The status of the latest virtual machine scale set rolling upgrade.")
model RollingUpgradeStatusInfoProperties {
  @doc("The rolling upgrade policies applied for this upgrade.")
  @visibility("read")
  policy?: RollingUpgradePolicy;

  @doc("Information about the current running state of the overall upgrade.")
  @visibility("read")
  runningStatus?: RollingUpgradeRunningStatus;

  @doc("Information about the number of virtual machine instances in each upgrade state.")
  @visibility("read")
  progress?: RollingUpgradeProgressInfo;

  @doc("Error details for this upgrade, if there are any.")
  @visibility("read")
  error?: ApiError;
}

@doc("Information about the current running state of the overall upgrade.")
model RollingUpgradeRunningStatus {
  @doc("Code indicating the current status of the upgrade.")
  @visibility("read")
  code?: RollingUpgradeStatusCode;

  @doc("Start time of the upgrade.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("The last action performed on the rolling upgrade.")
  @visibility("read")
  lastAction?: RollingUpgradeActionType;

  @doc("Last action time of the upgrade.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastActionTime?: utcDateTime;
}

@doc("Response after calling a manual recovery walk")
model RecoveryWalkResponse {
  @doc("Whether the recovery walk was performed")
  @visibility("read")
  walkPerformed?: boolean;

  @doc("""
The next update domain that needs to be walked. Null means walk spanning all
update domains has been completed
""")
  @visibility("read")
  nextPlatformUpdateDomain?: int32;
}

model VMScaleSetConvertToSinglePlacementGroupInput {
  @doc("""
Id of the placement group in which you want future virtual machine instances to
be placed. To query placement group Id, please use Virtual Machine Scale Set
VMs - Get API. If not provided, the platform will choose one with maximum
number of virtual machine instances.
""")
  activePlacementGroupId?: string;
}

@doc("The input for OrchestrationServiceState")
model OrchestrationServiceStateInput {
  @doc("The name of the service.")
  serviceName: OrchestrationServiceNames;

  @doc("The action to be performed.")
  action: OrchestrationServiceStateAction;
}

@doc("Describes the properties of a virtual machine scale set virtual machine.")
model VirtualMachineScaleSetVMProperties {
  @doc("Specifies whether the latest model has been applied to the virtual machine.")
  @visibility("read")
  latestModelApplied?: boolean;

  @doc("Azure VM unique ID.")
  @visibility("read")
  vmId?: string;

  @doc("The virtual machine instance view.")
  @visibility("read")
  instanceView?: VirtualMachineScaleSetVMInstanceView;

  @doc("Specifies the hardware settings for the virtual machine.")
  hardwareProfile?: HardwareProfile;

  @doc("Specifies the storage settings for the virtual machine disks.")
  storageProfile?: StorageProfile;

  @doc("""
Specifies additional capabilities enabled or disabled on the virtual machine in
the scale set. For instance: whether the virtual machine has the capability to
support attaching managed data disks with UltraSSD_LRS storage account type.
""")
  additionalCapabilities?: AdditionalCapabilities;

  @doc("Specifies the operating system settings for the virtual machine.")
  osProfile?: OSProfile;

  @doc("Specifies the Security related profile settings for the virtual machine.")
  securityProfile?: SecurityProfile;

  @doc("Specifies the network interfaces of the virtual machine.")
  networkProfile?: NetworkProfile;

  @doc("Specifies the network profile configuration of the virtual machine.")
  networkProfileConfiguration?: VirtualMachineScaleSetVMNetworkProfileConfiguration;

  @doc("Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Virtual machines specified in the same availability set
are allocated to different nodes to maximize availability. For more information
about availability sets, see [Availability sets
overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview).
For more information on Azure planned maintenance, see [Maintenance and updates
for Virtual Machines in
Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates).
Currently, a VM can only be added to availability set at creation time. An
existing VM cannot be added to an availability set.
""")
  availabilitySet?: SubResource;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
Specifies that the image or disk that is being used was licensed on-premises.
<br><br> Possible values for Windows Server operating system are: <br><br>
Windows_Client <br><br> Windows_Server <br><br> Possible values for Linux
Server operating system are: <br><br> RHEL_BYOS (for RHEL) <br><br> SLES_BYOS
(for SUSE) <br><br> For more information, see [Azure Hybrid Use Benefit for
Windows
Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing)
<br><br> [Azure Hybrid Use Benefit for Linux
Server](https://docs.microsoft.com/azure/virtual-machines/linux/azure-hybrid-benefit-linux)
<br><br> Minimum api-version: 2015-06-15
""")
  licenseType?: string;

  @doc("""
Specifies whether the model applied to the virtual machine is the model of the
virtual machine scale set or the customized model for the virtual machine.
""")
  @visibility("read")
  modelDefinitionApplied?: string;

  @doc("Specifies the protection policy of the virtual machine.")
  protectionPolicy?: VirtualMachineScaleSetVMProtectionPolicy;

  @doc("""
UserData for the VM, which must be base-64 encoded. Customer should not pass
any secrets in here. <br><br>Minimum api-version: 2021-03-01
""")
  userData?: string;

  @doc("""
Specifies the time at which the Virtual Machine resource was
created.<br><br>Minimum api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("The instance view of a virtual machine scale set VM.")
model VirtualMachineScaleSetVMInstanceView {
  @doc("The Update Domain count.")
  platformUpdateDomain?: int32;

  @doc("The Fault Domain count.")
  platformFaultDomain?: int32;

  @doc("The Remote desktop certificate thumbprint.")
  rdpThumbPrint?: string;

  @doc("The VM Agent running on the virtual machine.")
  vmAgent?: VirtualMachineAgentInstanceView;

  @doc("The Maintenance Operation status on the virtual machine.")
  maintenanceRedeployStatus?: MaintenanceRedeployStatus;

  @doc("The disks information.")
  disks?: DiskInstanceView[];

  @doc("The extensions information.")
  extensions?: VirtualMachineExtensionInstanceView[];

  @doc("The health status for the VM.")
  @visibility("read")
  vmHealth?: VirtualMachineHealthStatus;

  @doc("""
Boot Diagnostics is a debugging feature which allows you to view Console Output
and Screenshot to diagnose VM status. You can easily view the output of your
console log. Azure also enables you to see a screenshot of the VM from the
hypervisor.
""")
  bootDiagnostics?: BootDiagnosticsInstanceView;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];

  @doc("""
Resource id of the dedicated host, on which the virtual machine is allocated
through automatic placement, when the virtual machine is associated with a
dedicated host group that has automatic placement enabled. Minimum api-version:
2020-06-01.
""")
  @visibility("read")
  assignedHost?: string;

  @doc("""
The placement group in which the VM is running. If the VM is deallocated it
will not have a placementGroupId.
""")
  placementGroupId?: string;

  @doc("""
Specifies the host OS name of the virtual machine. <br><br> This name cannot be
updated after the VM is created. <br><br> **Max-length (Windows):** 15
characters <br><br> **Max-length (Linux):** 64 characters. <br><br> For naming
conventions and restrictions see [Azure infrastructure services implementation
guidelines](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-linux-infrastructure-subscription-accounts-guidelines?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json#1-naming-conventions).
""")
  computerName?: string;

  @doc("The Operating System running on the hybrid machine.")
  osName?: string;

  @doc("The version of Operating System running on the hybrid machine.")
  osVersion?: string;

  @doc("The hypervisor generation of the Virtual Machine [V1, V2]")
  hyperVGeneration?: HyperVGeneration;
}

@doc("The instance view of the VM Agent running on the virtual machine.")
model VirtualMachineAgentInstanceView {
  @doc("The VM Agent full version.")
  vmAgentVersion?: string;

  @doc("The virtual machine extension handler instance view.")
  extensionHandlers?: VirtualMachineExtensionHandlerInstanceView[];

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("The instance view of a virtual machine extension handler.")
model VirtualMachineExtensionHandlerInstanceView {
  @doc("Specifies the type of the extension; an example is \"CustomScriptExtension\".")
  type?: string;

  @doc("Specifies the version of the script handler.")
  typeHandlerVersion?: string;

  @doc("The extension handler status.")
  status?: InstanceViewStatus;
}

@doc("Maintenance Operation Status.")
model MaintenanceRedeployStatus {
  @doc("True, if customer is allowed to perform Maintenance.")
  isCustomerInitiatedMaintenanceAllowed?: boolean;

  @doc("Start Time for the Pre Maintenance Window.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  preMaintenanceWindowStartTime?: utcDateTime;

  @doc("End Time for the Pre Maintenance Window.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  preMaintenanceWindowEndTime?: utcDateTime;

  @doc("Start Time for the Maintenance Window.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  maintenanceWindowStartTime?: utcDateTime;

  @doc("End Time for the Maintenance Window.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  maintenanceWindowEndTime?: utcDateTime;

  @doc("The Last Maintenance Operation Result Code.")
  lastOperationResultCode?: MaintenanceOperationResultCodeTypes;

  @doc("Message returned for the last Maintenance Operation.")
  lastOperationMessage?: string;
}

@doc("The instance view of the disk.")
model DiskInstanceView {
  @doc("The disk name.")
  name?: string;

  @doc("""
Specifies the encryption settings for the OS Disk. <br><br> Minimum
api-version: 2015-06-15
""")
  encryptionSettings?: DiskEncryptionSettings[];

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("Describes a Encryption Settings for a Disk")
model DiskEncryptionSettings {
  @doc("Specifies the location of the disk encryption key, which is a Key Vault Secret.")
  diskEncryptionKey?: KeyVaultSecretReference;

  @doc("Specifies the location of the key encryption key in Key Vault.")
  keyEncryptionKey?: KeyVaultKeyReference;

  @doc("Specifies whether disk encryption should be enabled on the virtual machine.")
  enabled?: boolean;
}

@doc("Describes a reference to Key Vault Key")
model KeyVaultKeyReference {
  @doc("The URL referencing a key encryption key in Key Vault.")
  keyUrl: string;

  @doc("The relative URL of the Key Vault containing the key.")
  sourceVault: SubResource;
}

@doc("The health status of the VM.")
model VirtualMachineHealthStatus {
  @doc("The health status information for the VM.")
  @visibility("read")
  status?: InstanceViewStatus;
}

@doc("The instance view of a virtual machine boot diagnostics.")
model BootDiagnosticsInstanceView {
  @doc("""
The console screenshot blob URI. **Note:** This will **not** be set if boot
diagnostics is currently enabled with managed storage.
""")
  @visibility("read")
  consoleScreenshotBlobUri?: string;

  @doc("""
The serial console log blob Uri. **Note:** This will **not** be set if boot
diagnostics is currently enabled with managed storage.
""")
  @visibility("read")
  serialConsoleLogBlobUri?: string;

  @doc("""
The boot diagnostics status information for the VM. **Note:** It will be set
only if there are errors encountered in enabling boot diagnostics.
""")
  @visibility("read")
  status?: InstanceViewStatus;
}

@doc("Specifies the hardware settings for the virtual machine.")
model HardwareProfile {
  @doc("""
Specifies the size of the virtual machine. The enum data type is currently
deprecated and will be removed by December 23rd 2023. The recommended way to
get the list of available sizes is using these APIs: [List all available
virtual machine sizes in an availability
set](https://docs.microsoft.com/rest/api/compute/availabilitysets/listavailablesizes),
[List all available virtual machine sizes in a region](
https://docs.microsoft.com/rest/api/compute/resourceskus/list), [List all
available virtual machine sizes for
resizing](https://docs.microsoft.com/rest/api/compute/virtualmachines/listavailablesizes).
For more information about virtual machine sizes, see [Sizes for virtual
machines](https://docs.microsoft.com/azure/virtual-machines/sizes). The
available VM sizes depend on region and availability set.
""")
  vmSize?: VirtualMachineSizeTypes;

  @doc("""
Specifies the properties for customizing the size of the virtual machine.
Minimum api-version: 2021-07-01. This feature is still in preview mode and is
not supported for VirtualMachineScaleSet. Please follow the instructions in [VM
Customization](https://aka.ms/vmcustomization) for more details.
""")
  vmSizeProperties?: VMSizeProperties;
}

@doc("Specifies the storage settings for the virtual machine disks.")
model StorageProfile {
  @doc("""
Specifies information about the image to use. You can specify information about
platform images, marketplace images, or virtual machine images. This element is
required when you want to use a platform image, marketplace image, or virtual
machine image, but is not used in other creation operations.
""")
  imageReference?: ImageReference;

  @doc("""
Specifies information about the operating system disk used by the virtual
machine. For more information about disks, see [About disks and VHDs for Azure
virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  osDisk?: OSDisk;

  @doc("""
Specifies the parameters that are used to add a data disk to a virtual machine.
For more information about disks, see [About disks and VHDs for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  dataDisks?: DataDisk[];

  @doc("""
Specifies the disk controller type configured for the VM. **Note:** This
property will be set to the default disk controller type if not specified
provided virtual machine is being created with 'hyperVGeneration' set to V2
based on the capabilities of the operating system disk and VM size from the the
specified minimum api version. You need to deallocate the VM before updating
its disk controller type unless you are updating the VM size in the VM
configuration which implicitly deallocates and reallocates the VM. Minimum
api-version: 2022-08-01.
""")
  diskControllerType?: DiskControllerTypes;
}

@doc("""
Specifies information about the operating system disk used by the virtual
machine. For more information about disks, see [About disks and VHDs for Azure
virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
model OSDisk {
  @doc("""
This property allows you to specify the type of the OS that is included in the
disk if creating a VM from user-image or a specialized VHD. Possible values
are: **Windows,** **Linux.**
""")
  osType?: OperatingSystemTypes;

  @doc("""
Specifies the encryption settings for the OS Disk. Minimum api-version:
2015-06-15.
""")
  encryptionSettings?: DiskEncryptionSettings;

  @doc("The disk name.")
  name?: string;

  @doc("The virtual hard disk.")
  vhd?: VirtualHardDisk;

  @doc("""
The source user image virtual hard disk. The virtual hard disk will be copied
before being attached to the virtual machine. If SourceImage is provided, the
destination virtual hard drive must not exist.
""")
  image?: VirtualHardDisk;

  @doc("""
Specifies the caching requirements. Possible values are: **None,**
**ReadOnly,** **ReadWrite.** The defaulting behavior is: **None for Standard
storage. ReadOnly for Premium storage.**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("""
Specifies the ephemeral Disk Settings for the operating system disk used by the
virtual machine.
""")
  diffDiskSettings?: DiffDiskSettings;

  @doc("""
Specifies how the virtual machine should be created. Possible values are:
**Attach.** This value is used when you are using a specialized disk to create
the virtual machine. **FromImage.** This value is used when you are using an
image to create the virtual machine. If you are using a platform image, you
should also use the imageReference element described above. If you are using a
marketplace image, you should also use the plan element previously described.
""")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. The property
'diskSizeGB' is the number of bytes x 1024^3 for the disk and the value cannot
be larger than 1023.
""")
  diskSizeGB?: int32;

  @doc("The managed disk parameters.")
  managedDisk?: ManagedDiskParameters;

  @doc("""
Specifies whether OS Disk should be deleted or detached upon VM deletion.
Possible values are: **Delete.** If this value is used, the OS disk is deleted
when VM is deleted. **Detach.** If this value is used, the os disk is retained
after VM is deleted. The default value is set to **Detach**. For an ephemeral
OS Disk, the default value is set to **Delete**. The user cannot change the
delete option for an ephemeral OS Disk.
""")
  deleteOption?: DiskDeleteOptionTypes;
}

@doc("The parameters of a managed disk.")
model ManagedDiskParameters {
  ...SubResource;

  @doc("""
Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can
only be used with data disks, it cannot be used with OS Disk.
""")
  storageAccountType?: StorageAccountTypes;

  @doc("""
Specifies the customer managed disk encryption set resource id for the managed
disk.
""")
  diskEncryptionSet?: DiskEncryptionSetParameters;

  @doc("Specifies the security profile for the managed disk.")
  securityProfile?: VMDiskSecurityProfile;
}

@doc("Describes a data disk.")
model DataDisk {
  @doc("""
Specifies the logical unit number of the data disk. This value is used to
identify data disks within the VM and therefore must be unique for each data
disk attached to a VM.
""")
  lun: int32;

  @doc("The disk name.")
  name?: string;

  @doc("The virtual hard disk.")
  vhd?: VirtualHardDisk;

  @doc("""
The source user image virtual hard disk. The virtual hard disk will be copied
before being attached to the virtual machine. If SourceImage is provided, the
destination virtual hard drive must not exist.
""")
  image?: VirtualHardDisk;

  @doc("""
Specifies the caching requirements. Possible values are: **None,**
**ReadOnly,** **ReadWrite.** The defaulting behavior is: **None for Standard
storage. ReadOnly for Premium storage.**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("""
Specifies how the virtual machine should be created. Possible values are:
**Attach.** This value is used when you are using a specialized disk to create
the virtual machine. **FromImage.** This value is used when you are using an
image to create the virtual machine. If you are using a platform image, you
should also use the imageReference element described above. If you are using a
marketplace image, you should also use the plan element previously described.
""")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. The property
'diskSizeGB' is the number of bytes x 1024^3 for the disk and the value cannot
be larger than 1023.
""")
  diskSizeGB?: int32;

  @doc("The managed disk parameters.")
  managedDisk?: ManagedDiskParameters;

  @doc("""
Specifies whether the data disk is in process of detachment from the
VirtualMachine/VirtualMachineScaleset
""")
  toBeDetached?: boolean;

  @doc("""
Specifies the Read-Write IOPS for the managed disk when StorageAccountType is
UltraSSD_LRS. Returned only for VirtualMachine ScaleSet VM disks. Can be
updated only via updates to the VirtualMachine Scale Set.
""")
  @visibility("read")
  @projectedName("json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int32;

  @doc("""
Specifies the bandwidth in MB per second for the managed disk when
StorageAccountType is UltraSSD_LRS. Returned only for VirtualMachine ScaleSet
VM disks. Can be updated only via updates to the VirtualMachine Scale Set.
""")
  @visibility("read")
  diskMBpsReadWrite?: int32;

  @doc("""
Specifies the detach behavior to be used while detaching a disk or which is
already in the process of detachment from the virtual machine. Supported
values: **ForceDetach.** detachOption: **ForceDetach** is applicable only for
managed data disks. If a previous detachment attempt of the data disk did not
complete due to an unexpected failure from the virtual machine and the disk is
still not released then use force-detach as a last resort option to detach the
disk forcibly from the VM. All writes might not have been flushed when using
this detach behavior. **This feature is still in preview** mode and is not
supported for VirtualMachineScaleSet. To force-detach a data disk update
toBeDetached to 'true' along with setting detachOption: 'ForceDetach'.
""")
  detachOption?: DiskDetachOptionTypes;

  @doc("""
Specifies whether data disk should be deleted or detached upon VM deletion.
Possible values are: **Delete.** If this value is used, the data disk is
deleted when VM is deleted. **Detach.** If this value is used, the data disk is
retained after VM is deleted. The default value is set to **Detach**.
""")
  deleteOption?: DiskDeleteOptionTypes;
}

@doc("""
Specifies the operating system settings for the virtual machine. Some of the
settings cannot be changed once VM is provisioned.
""")
model OSProfile {
  @doc("""
Specifies the host OS name of the virtual machine. This name cannot be updated
after the VM is created. **Max-length (Windows):** 15 characters. **Max-length
(Linux):** 64 characters. For naming conventions and restrictions see [Azure
infrastructure services implementation
guidelines](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-name-rules).
""")
  computerName?: string;

  @doc("""
Specifies the name of the administrator account. <br><br> This property cannot
be updated after the VM is created. <br><br> **Windows-only restriction:**
Cannot end in \".\" <br><br> **Disallowed values:** \"administrator\",
\"admin\", \"user\", \"user1\", \"test\", \"user2\", \"test1\", \"user3\",
\"admin1\", \"1\", \"123\", \"a\", \"actuser\", \"adm\", \"admin2\",
\"aspnet\", \"backup\", \"console\", \"david\", \"guest\", \"john\", \"owner\",
\"root\", \"server\", \"sql\", \"support\", \"support_388945a0\", \"sys\",
\"test2\", \"test3\", \"user4\", \"user5\". <br><br> **Minimum-length
(Linux):** 1  character <br><br> **Max-length (Linux):** 64 characters <br><br>
**Max-length (Windows):** 20 characters.
""")
  adminUsername?: string;

  @doc("""
Specifies the password of the administrator account. <br><br> **Minimum-length
(Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters
<br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length
(Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4
conditions below need to be fulfilled <br> Has lower characters <br>Has upper
characters <br> Has a digit <br> Has a special character (Regex match [\\W_])
<br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\",
\"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\",
\"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to
reset the Remote Desktop service or its login password in a Windows
VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp)
<br><br> For resetting root password, see [Manage users, SSH, and check or
repair disks on Azure Linux VMs using the VMAccess
Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)
""")
  adminPassword?: string;

  @doc("""
Specifies a base-64 encoded string of custom data. The base-64 encoded string
is decoded to a binary array that is saved as a file on the Virtual Machine.
The maximum length of the binary array is 65535 bytes. **Note: Do not pass any
secrets or passwords in customData property.** This property cannot be updated
after the VM is created. The property 'customData' is passed to the VM to be
saved as a file, for more information see [Custom Data on Azure
VMs](https://azure.microsoft.com/blog/custom-data-and-cloud-init-on-windows-azure/).
For using cloud-init for your Linux VM, see [Using cloud-init to customize a
Linux VM during
creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init).
""")
  customData?: string;

  @doc("Specifies Windows operating system settings on the virtual machine.")
  windowsConfiguration?: WindowsConfiguration;

  @doc("""
Specifies the Linux operating system settings on the virtual machine. For a
list of supported Linux distributions, see [Linux on Azure-Endorsed
Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
""")
  linuxConfiguration?: LinuxConfiguration;

  @doc("""
Specifies set of certificates that should be installed onto the virtual
machine. To install certificates on a virtual machine it is recommended to use
the [Azure Key Vault virtual machine extension for
Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux)
or the [Azure Key Vault virtual machine extension for
Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
""")
  secrets?: VaultSecretGroup[];

  @doc("""
Specifies whether extension operations should be allowed on the virtual
machine. This may only be set to False when no extensions are present on the
virtual machine.
""")
  allowExtensionOperations?: boolean;

  @doc("Optional property which must either be set to True or omitted.")
  requireGuestProvisionSignal?: boolean;
}

@doc("""
Specifies the network interfaces or the networking configuration of the virtual
machine.
""")
model NetworkProfile {
  @doc("""
Specifies the list of resource Ids for the network interfaces associated with
the virtual machine.
""")
  networkInterfaces?: NetworkInterfaceReference[];

  @doc("""
specifies the Microsoft.Network API version used when creating networking
resources in the Network Interface Configurations
""")
  networkApiVersion?: NetworkApiVersion;

  @doc("""
Specifies the networking configurations that will be used to create the virtual
machine networking resources.
""")
  networkInterfaceConfigurations?: VirtualMachineNetworkInterfaceConfiguration[];
}

@doc("Describes a network interface reference.")
model NetworkInterfaceReference {
  ...SubResource;

  @doc("Describes a network interface reference properties.")
  properties?: NetworkInterfaceReferenceProperties;
}

@doc("Describes a network interface reference properties.")
model NetworkInterfaceReferenceProperties {
  @doc("""
Specifies the primary network interface in case the virtual machine has more
than 1 network interface.
""")
  primary?: boolean;

  @doc("Specify what happens to the network interface when the VM is deleted")
  deleteOption?: DeleteOptions;
}

@doc("Describes a virtual machine network interface configurations.")
model VirtualMachineNetworkInterfaceConfiguration {
  @doc("The network interface configuration name.")
  name: string;

  @doc("Describes a virtual machine network profile's IP configuration.")
  properties?: VirtualMachineNetworkInterfaceConfigurationProperties;
}

@doc("Describes a virtual machine network profile's IP configuration.")
model VirtualMachineNetworkInterfaceConfigurationProperties {
  @doc("""
Specifies the primary network interface in case the virtual machine has more
than 1 network interface.
""")
  primary?: boolean;

  @doc("Specify what happens to the network interface when the VM is deleted")
  deleteOption?: DeleteOptions;

  @doc("Specifies whether the network interface is accelerated networking-enabled.")
  enableAcceleratedNetworking?: boolean;

  @doc("Specifies whether the network interface is disabled for tcp state tracking.")
  disableTcpStateTracking?: boolean;

  @doc("Specifies whether the network interface is FPGA networking-enabled.")
  enableFpga?: boolean;

  @doc("Whether IP forwarding enabled on this NIC.")
  enableIPForwarding?: boolean;

  @doc("The network security group.")
  networkSecurityGroup?: SubResource;

  @doc("The dns settings to be applied on the network interfaces.")
  dnsSettings?: VirtualMachineNetworkInterfaceDnsSettingsConfiguration;

  @doc("Specifies the IP configurations of the network interface.")
  ipConfigurations: VirtualMachineNetworkInterfaceIPConfiguration[];

  dscpConfiguration?: SubResource;

  @doc("""
Specifies whether the Auxiliary mode is enabled for the Network Interface
resource.
""")
  auxiliaryMode?: NetworkInterfaceAuxiliaryMode;

  @doc("""
Specifies whether the Auxiliary sku is enabled for the Network Interface
resource.
""")
  auxiliarySku?: NetworkInterfaceAuxiliarySku;
}

@doc("Describes a virtual machines network configuration's DNS settings.")
model VirtualMachineNetworkInterfaceDnsSettingsConfiguration {
  @doc("List of DNS servers IP addresses")
  dnsServers?: string[];
}

@doc("Describes a virtual machine network profile's IP configuration.")
model VirtualMachineNetworkInterfaceIPConfiguration {
  @doc("The IP configuration name.")
  name: string;

  @doc("Describes a virtual machine network interface IP configuration properties.")
  properties?: VirtualMachineNetworkInterfaceIPConfigurationProperties;
}

@doc("Describes a virtual machine network interface IP configuration properties.")
model VirtualMachineNetworkInterfaceIPConfigurationProperties {
  @doc("Specifies the identifier of the subnet.")
  subnet?: SubResource;

  @doc("""
Specifies the primary network interface in case the virtual machine has more
than 1 network interface.
""")
  primary?: boolean;

  @doc("The publicIPAddressConfiguration.")
  publicIPAddressConfiguration?: VirtualMachinePublicIPAddressConfiguration;

  @doc("""
Available from Api-Version 2017-03-30 onwards, it represents whether the
specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible
values are: 'IPv4' and 'IPv6'.
""")
  privateIPAddressVersion?: IPVersions;

  @doc("Specifies an array of references to application security group.")
  applicationSecurityGroups?: SubResource[];

  @doc("""
Specifies an array of references to backend address pools of application
gateways. A virtual machine can reference backend address pools of multiple
application gateways. Multiple virtual machines cannot use the same application
gateway.
""")
  applicationGatewayBackendAddressPools?: SubResource[];

  @doc("""
Specifies an array of references to backend address pools of load balancers. A
virtual machine can reference backend address pools of one public and one
internal load balancer. [Multiple virtual machines cannot use the same basic
sku load balancer].
""")
  loadBalancerBackendAddressPools?: SubResource[];
}

@doc("Describes a virtual machines IP Configuration's PublicIPAddress configuration")
model VirtualMachinePublicIPAddressConfiguration {
  @doc("The publicIP address configuration name.")
  name: string;

  @doc("Describes a virtual machines IP Configuration's PublicIPAddress configuration")
  properties?: VirtualMachinePublicIPAddressConfigurationProperties;

  @doc("""
Describes the public IP Sku. It can only be set with OrchestrationMode as
Flexible.
""")
  sku?: PublicIPAddressSku;
}

@doc("Describes a virtual machines IP Configuration's PublicIPAddress configuration")
model VirtualMachinePublicIPAddressConfigurationProperties {
  @doc("The idle timeout of the public IP address.")
  idleTimeoutInMinutes?: int32;

  @doc("Specify what happens to the public IP address when the VM is deleted")
  deleteOption?: DeleteOptions;

  @doc("The dns settings to be applied on the publicIP addresses .")
  dnsSettings?: VirtualMachinePublicIPAddressDnsSettingsConfiguration;

  @doc("The list of IP tags associated with the public IP address.")
  ipTags?: VirtualMachineIpTag[];

  @doc("The PublicIPPrefix from which to allocate publicIP addresses.")
  publicIPPrefix?: SubResource;

  @doc("""
Available from Api-Version 2019-07-01 onwards, it represents whether the
specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4. Possible
values are: 'IPv4' and 'IPv6'.
""")
  publicIPAddressVersion?: IPVersions;

  @doc("Specify the public IP allocation type")
  publicIPAllocationMethod?: PublicIPAllocationMethod;
}

@doc("Describes a virtual machines network configuration's DNS settings.")
model VirtualMachinePublicIPAddressDnsSettingsConfiguration {
  @doc("""
The Domain name label prefix of the PublicIPAddress resources that will be
created. The generated name label is the concatenation of the domain name label
and vm network profile unique ID.
""")
  domainNameLabel: string;

  @doc("""
The Domain name label scope of the PublicIPAddress resources that will be
created. The generated name label is the concatenation of the hashed domain
name label with policy according to the domain name label scope and vm network
profile unique ID.
""")
  domainNameLabelScope?: DomainNameLabelScopeTypes;
}

@doc("Contains the IP tag associated with the public IP address.")
model VirtualMachineIpTag {
  @doc("IP tag type. Example: FirstPartyUsage.")
  ipTagType?: string;

  @doc("IP tag associated with the public IP. Example: SQL, Storage etc.")
  tag?: string;
}

@doc("Describes a virtual machine scale set VM network profile.")
model VirtualMachineScaleSetVMNetworkProfileConfiguration {
  @doc("The list of network configurations.")
  networkInterfaceConfigurations?: VirtualMachineScaleSetNetworkConfiguration[];
}

@doc("The protection policy of a virtual machine scale set VM.")
model VirtualMachineScaleSetVMProtectionPolicy {
  @doc("""
Indicates that the virtual machine scale set VM shouldn't be considered for
deletion during a scale-in operation.
""")
  protectFromScaleIn?: boolean;

  @doc("""
Indicates that model updates or actions (including scale-in) initiated on the
virtual machine scale set should not be applied to the virtual machine scale
set VM.
""")
  protectFromScaleSetActions?: boolean;
}

@doc("Identity for the virtual machine.")
model VirtualMachineIdentity {
  @doc("""
The principal id of virtual machine identity. This property will only be
provided for a system assigned identity.
""")
  @visibility("read")
  principalId?: string;

  @doc("""
The tenant id associated with the virtual machine. This property will only be
provided for a system assigned identity.
""")
  @visibility("read")
  tenantId?: string;

  @doc("""
The type of identity used for the virtual machine. The type 'SystemAssigned,
UserAssigned' includes both an implicitly created identity and a set of user
assigned identities. The type 'None' will remove any identities from the
virtual machine.
""")
  type?: ResourceIdentityType;

  @doc("""
The list of user identities associated with the Virtual Machine. The user
identity dictionary key references will be ARM resource ids in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

@doc("The SAS URIs of the console screenshot and serial log blobs.")
model RetrieveBootDiagnosticsDataResult {
  @doc("The console screenshot blob URI")
  @visibility("read")
  consoleScreenshotBlobUri?: string;

  @doc("The serial console log blob URI.")
  @visibility("read")
  serialConsoleLogBlobUri?: string;
}

@doc("Describes the properties of a Virtual Machine.")
model VirtualMachineProperties {
  @doc("Specifies the hardware settings for the virtual machine.")
  hardwareProfile?: HardwareProfile;

  @doc("Specifies the storage settings for the virtual machine disks.")
  storageProfile?: StorageProfile;

  @doc("Specifies additional capabilities enabled or disabled on the virtual machine.")
  additionalCapabilities?: AdditionalCapabilities;

  @doc("""
Specifies the operating system settings used while creating the virtual
machine. Some of the settings cannot be changed once VM is provisioned.
""")
  osProfile?: OSProfile;

  @doc("Specifies the network interfaces of the virtual machine.")
  networkProfile?: NetworkProfile;

  @doc("Specifies the Security related profile settings for the virtual machine.")
  securityProfile?: SecurityProfile;

  @doc("Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Virtual machines specified in the same availability set
are allocated to different nodes to maximize availability. For more information
about availability sets, see [Availability sets
overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview).
For more information on Azure planned maintenance, see [Maintenance and updates
for Virtual Machines in
Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates).
Currently, a VM can only be added to availability set at creation time. The
availability set to which the VM is being added should be under the same
resource group as the availability set resource. An existing VM cannot be added
to an availability set. This property cannot exist along with a non-null
properties.virtualMachineScaleSet reference.
""")
  availabilitySet?: SubResource;

  @doc("""
Specifies information about the virtual machine scale set that the virtual
machine should be assigned to. Virtual machines specified in the same virtual
machine scale set are allocated to different nodes to maximize availability.
Currently, a VM can only be added to virtual machine scale set at creation
time. An existing VM cannot be added to a virtual machine scale set. This
property cannot exist along with a non-null properties.availabilitySet
reference. Minimum api‐version: 2019‐03‐01.
""")
  virtualMachineScaleSet?: SubResource;

  @doc("""
Specifies information about the proximity placement group that the virtual
machine should be assigned to. Minimum api-version: 2018-04-01.
""")
  proximityPlacementGroup?: SubResource;

  @doc("Specifies the priority for the virtual machine. Minimum api-version: 2019-03-01")
  priority?: VirtualMachinePriorityTypes;

  @doc("""
Specifies the eviction policy for the Azure Spot virtual machine and Azure Spot
scale set. For Azure Spot virtual machines, both 'Deallocate' and 'Delete' are
supported and the minimum api-version is 2019-03-01. For Azure Spot scale sets,
both 'Deallocate' and 'Delete' are supported and the minimum api-version is
2017-10-30-preview.
""")
  evictionPolicy?: VirtualMachineEvictionPolicyTypes;

  @doc("""
Specifies the billing related details of a Azure Spot virtual machine. Minimum
api-version: 2019-03-01.
""")
  billingProfile?: BillingProfile;

  @doc("""
Specifies information about the dedicated host that the virtual machine resides
in. Minimum api-version: 2018-10-01.
""")
  host?: SubResource;

  @doc("""
Specifies information about the dedicated host group that the virtual machine
resides in. **Note:** User cannot specify both host and hostGroup properties.
Minimum api-version: 2020-06-01.
""")
  hostGroup?: SubResource;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("The virtual machine instance view.")
  @visibility("read")
  instanceView?: VirtualMachineInstanceView;

  @doc("""
Specifies that the image or disk that is being used was licensed on-premises.
<br><br> Possible values for Windows Server operating system are: <br><br>
Windows_Client <br><br> Windows_Server <br><br> Possible values for Linux
Server operating system are: <br><br> RHEL_BYOS (for RHEL) <br><br> SLES_BYOS
(for SUSE) <br><br> For more information, see [Azure Hybrid Use Benefit for
Windows
Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing)
<br><br> [Azure Hybrid Use Benefit for Linux
Server](https://docs.microsoft.com/azure/virtual-machines/linux/azure-hybrid-benefit-linux)
<br><br> Minimum api-version: 2015-06-15
""")
  licenseType?: string;

  @doc("""
Specifies the VM unique ID which is a 128-bits identifier that is encoded and
stored in all Azure IaaS VMs SMBIOS and can be read using platform BIOS
commands.
""")
  @visibility("read")
  vmId?: string;

  @doc("""
Specifies the time alloted for all extensions to start. The time duration
should be between 15 minutes and 120 minutes (inclusive) and should be
specified in ISO 8601 format. The default value is 90 minutes (PT1H30M).
Minimum api-version: 2020-06-01.
""")
  extensionsTimeBudget?: string;

  @doc("""
Specifies the scale set logical fault domain into which the Virtual Machine
will be created. By default, the Virtual Machine will by automatically assigned
to a fault domain that best maintains balance across available fault domains.
This is applicable only if the 'virtualMachineScaleSet' property of this
Virtual Machine is set. The Virtual Machine Scale Set that is referenced, must
have 'platformFaultDomainCount' greater than 1. This property cannot be updated
once the Virtual Machine is created. Fault domain assignment can be viewed in
the Virtual Machine Instance View. Minimum api‐version: 2020‐12‐01.
""")
  platformFaultDomain?: int32;

  @doc("Specifies Scheduled Event related configurations.")
  scheduledEventsProfile?: ScheduledEventsProfile;

  @doc("""
UserData for the VM, which must be base-64 encoded. Customer should not pass
any secrets in here. Minimum api-version: 2021-03-01.
""")
  userData?: string;

  @doc("""
Specifies information about the capacity reservation that is used to allocate
virtual machine. Minimum api-version: 2021-04-01.
""")
  capacityReservation?: CapacityReservationProfile;

  @doc("Specifies the gallery applications that should be made available to the VM/VMSS.")
  applicationProfile?: ApplicationProfile;

  @doc("""
Specifies the time at which the Virtual Machine resource was created. Minimum
api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("The instance view of a virtual machine.")
model VirtualMachineInstanceView {
  @doc("Specifies the update domain of the virtual machine.")
  platformUpdateDomain?: int32;

  @doc("Specifies the fault domain of the virtual machine.")
  platformFaultDomain?: int32;

  @doc("The computer name assigned to the virtual machine.")
  computerName?: string;

  @doc("The Operating System running on the virtual machine.")
  osName?: string;

  @doc("The version of Operating System running on the virtual machine.")
  osVersion?: string;

  @doc("Specifies the HyperVGeneration Type associated with a resource")
  hyperVGeneration?: HyperVGenerationType;

  @doc("The Remote desktop certificate thumbprint.")
  rdpThumbPrint?: string;

  @doc("The VM Agent running on the virtual machine.")
  vmAgent?: VirtualMachineAgentInstanceView;

  @doc("The Maintenance Operation status on the virtual machine.")
  maintenanceRedeployStatus?: MaintenanceRedeployStatus;

  @doc("The virtual machine disk information.")
  disks?: DiskInstanceView[];

  @doc("The extensions information.")
  extensions?: VirtualMachineExtensionInstanceView[];

  @doc("The health status for the VM.")
  @visibility("read")
  vmHealth?: VirtualMachineHealthStatus;

  @doc("""
Boot Diagnostics is a debugging feature which allows you to view Console Output
and Screenshot to diagnose VM status. You can easily view the output of your
console log. Azure also enables you to see a screenshot of the VM from the
hypervisor.
""")
  bootDiagnostics?: BootDiagnosticsInstanceView;

  @doc("""
Resource id of the dedicated host, on which the virtual machine is allocated
through automatic placement, when the virtual machine is associated with a
dedicated host group that has automatic placement enabled. Minimum api-version:
2020-06-01.
""")
  @visibility("read")
  assignedHost?: string;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];

  @doc("[Preview Feature] The status of virtual machine patch operations.")
  patchStatus?: VirtualMachinePatchStatus;
}

@doc("The status of virtual machine patch operations.")
model VirtualMachinePatchStatus {
  @doc("""
The available patch summary of the latest assessment operation for the virtual
machine.
""")
  availablePatchSummary?: AvailablePatchSummary;

  @doc("""
The installation summary of the latest installation operation for the virtual
machine.
""")
  lastPatchInstallationSummary?: LastPatchInstallationSummary;

  @doc("The enablement status of the specified patchMode")
  @visibility("read")
  configurationStatuses?: InstanceViewStatus[];
}

@doc("""
Describes the properties of an virtual machine instance view for available
patch summary.
""")
model AvailablePatchSummary {
  @doc("""
The overall success or failure status of the operation. It remains
\"InProgress\" until the operation completes. At that point it will become
\"Unknown\", \"Failed\", \"Succeeded\", or \"CompletedWithWarnings.\"
""")
  @visibility("read")
  status?: PatchOperationStatus;

  @doc("""
The activity ID of the operation that produced this result. It is used to
correlate across CRP and extension logs.
""")
  @visibility("read")
  assessmentActivityId?: string;

  @doc("""
The overall reboot status of the VM. It will be true when partially installed
patches require a reboot to complete installation but the reboot has not yet
occurred.
""")
  @visibility("read")
  rebootPending?: boolean;

  @doc("""
The number of critical or security patches that have been detected as available
and not yet installed.
""")
  @visibility("read")
  criticalAndSecurityPatchCount?: int32;

  @doc("The number of all available patches excluding critical and security.")
  @visibility("read")
  otherPatchCount?: int32;

  @doc("The UTC timestamp when the operation began.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("The UTC timestamp when the operation began.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  @doc("""
The errors that were encountered during execution of the operation. The details
array contains the list of them.
""")
  @visibility("read")
  error?: ApiError;
}

@doc("Describes the properties of the last installed patch summary.")
model LastPatchInstallationSummary {
  @doc("""
The overall success or failure status of the operation. It remains
\"InProgress\" until the operation completes. At that point it will become
\"Unknown\", \"Failed\", \"Succeeded\", or \"CompletedWithWarnings.\"
""")
  @visibility("read")
  status?: PatchOperationStatus;

  @doc("""
The activity ID of the operation that produced this result. It is used to
correlate across CRP and extension logs.
""")
  @visibility("read")
  installationActivityId?: string;

  @doc("""
Describes whether the operation ran out of time before it completed all its
intended actions
""")
  @visibility("read")
  maintenanceWindowExceeded?: boolean;

  @doc("""
The number of all available patches but not going to be installed because it
didn't match a classification or inclusion list entry.
""")
  @visibility("read")
  notSelectedPatchCount?: int32;

  @doc("""
The number of all available patches but excluded explicitly by a
customer-specified exclusion list match.
""")
  @visibility("read")
  excludedPatchCount?: int32;

  @doc("""
The number of all available patches expected to be installed over the course of
the patch installation operation.
""")
  @visibility("read")
  pendingPatchCount?: int32;

  @doc("The count of patches that successfully installed.")
  @visibility("read")
  installedPatchCount?: int32;

  @doc("The count of patches that failed installation.")
  @visibility("read")
  failedPatchCount?: int32;

  @doc("The UTC timestamp when the operation began.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("The UTC timestamp when the operation began.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  @doc("""
The errors that were encountered during execution of the operation. The details
array contains the list of them.
""")
  @visibility("read")
  error?: ApiError;
}

@doc("Capture Virtual Machine parameters.")
model VirtualMachineCaptureParameters {
  @doc("The captured virtual hard disk's name prefix.")
  vhdPrefix: string;

  @doc("The destination container name.")
  destinationContainerName: string;

  @doc("""
Specifies whether to overwrite the destination virtual hard disk, in case of
conflict.
""")
  overwriteVhds: boolean;
}

@doc("Output of virtual machine capture operation.")
model VirtualMachineCaptureResult {
  ...SubResource;

  @doc("the schema of the captured virtual machine")
  @visibility("read")
  @projectedName("json", "$schema")
  schema?: string;

  @doc("the version of the content")
  @visibility("read")
  contentVersion?: string;

  @doc("parameters of the captured virtual machine")
  @visibility("read")
  parameters?: Record<unknown>;

  @doc("a list of resource items of the captured virtual machine")
  @visibility("read")
  resources?: Record<unknown>[];
}

@doc("Describes the properties of an AssessPatches result.")
model VirtualMachineAssessPatchesResult {
  @doc("""
The overall success or failure status of the operation. It remains
\"InProgress\" until the operation completes. At that point it will become
\"Unknown\", \"Failed\", \"Succeeded\", or \"CompletedWithWarnings.\"
""")
  @visibility("read")
  status?: PatchOperationStatus;

  @doc("""
The activity ID of the operation that produced this result. It is used to
correlate across CRP and extension logs.
""")
  @visibility("read")
  assessmentActivityId?: string;

  @doc("""
The overall reboot status of the VM. It will be true when partially installed
patches require a reboot to complete installation but the reboot has not yet
occurred.
""")
  @visibility("read")
  rebootPending?: boolean;

  @doc("""
The number of critical or security patches that have been detected as available
and not yet installed.
""")
  @visibility("read")
  criticalAndSecurityPatchCount?: int32;

  @doc("The number of all available patches excluding critical and security.")
  @visibility("read")
  otherPatchCount?: int32;

  @doc("The UTC timestamp when the operation began.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("The list of patches that have been detected as available for installation.")
  @visibility("read")
  availablePatches?: VirtualMachineSoftwarePatchProperties[];

  @doc("""
The errors that were encountered during execution of the operation. The details
array contains the list of them.
""")
  @visibility("read")
  error?: ApiError;
}

@doc("Describes the properties of a Virtual Machine software patch.")
model VirtualMachineSoftwarePatchProperties {
  @doc("A unique identifier for the patch.")
  @visibility("read")
  patchId?: string;

  @doc("The friendly name of the patch.")
  @visibility("read")
  name?: string;

  @doc("The version number of the patch. This property applies only to Linux patches.")
  @visibility("read")
  version?: string;

  @doc("The KBID of the patch. Only applies to Windows patches.")
  @visibility("read")
  kbId?: string;

  @doc("The classification(s) of the patch as provided by the patch publisher.")
  @visibility("read")
  classifications?: string[];

  @doc("Describes the reboot requirements of the patch.")
  @visibility("read")
  rebootBehavior?: VMGuestPatchRebootBehavior;

  @doc("""
The activity ID of the operation that produced this result. It is used to
correlate across CRP and extension logs.
""")
  @visibility("read")
  activityId?: string;

  @doc("The UTC timestamp when the repository published this patch.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  @doc("The UTC timestamp of the last update to this patch record.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("Describes the availability of a given patch.")
  @visibility("read")
  assessmentState?: PatchAssessmentState;
}

@doc("Input for InstallPatches as directly received by the API")
model VirtualMachineInstallPatchesParameters {
  @doc("""
Specifies the maximum amount of time that the operation will run. It must be an
ISO 8601-compliant duration string such as PT4H (4 hours)
""")
  maximumDuration?: duration;

  @doc("Defines when it is acceptable to reboot a VM during a software update operation.")
  rebootSetting: VMGuestPatchRebootSetting;

  @doc("Input for InstallPatches on a Windows VM, as directly received by the API")
  windowsParameters?: WindowsParameters;

  @doc("Input for InstallPatches on a Linux VM, as directly received by the API")
  linuxParameters?: LinuxParameters;
}

@doc("Input for InstallPatches on a Windows VM, as directly received by the API")
model WindowsParameters {
  @doc("The update classifications to select when installing patches for Windows.")
  classificationsToInclude?: VMGuestPatchClassificationWindows[];

  @doc("Kbs to include in the patch operation")
  kbNumbersToInclude?: string[];

  @doc("Kbs to exclude in the patch operation")
  kbNumbersToExclude?: string[];

  @doc("""
Filters out Kbs that don't have an InstallationRebootBehavior of 'NeverReboots'
when this is set to true.
""")
  excludeKbsRequiringReboot?: boolean;

  @doc("""
This is used to install patches that were published on or before this given max
published date.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  maxPatchPublishDate?: utcDateTime;
}

@doc("Input for InstallPatches on a Linux VM, as directly received by the API")
model LinuxParameters {
  @doc("The update classifications to select when installing patches for Linux.")
  classificationsToInclude?: VMGuestPatchClassificationLinux[];

  @doc("packages to include in the patch operation. Format: packageName_packageVersion")
  packageNameMasksToInclude?: string[];

  @doc("packages to exclude in the patch operation. Format: packageName_packageVersion")
  packageNameMasksToExclude?: string[];

  @doc("""
This is used as a maintenance run identifier for Auto VM Guest Patching in
Linux.
""")
  maintenanceRunId?: string;
}

@doc("The result summary of an installation operation.")
model VirtualMachineInstallPatchesResult {
  @doc("""
The overall success or failure status of the operation. It remains
\"InProgress\" until the operation completes. At that point it will become
\"Failed\", \"Succeeded\", \"Unknown\" or \"CompletedWithWarnings.\"
""")
  @visibility("read")
  status?: PatchOperationStatus;

  @doc("""
The activity ID of the operation that produced this result. It is used to
correlate across CRP and extension logs.
""")
  @visibility("read")
  installationActivityId?: string;

  @doc("The reboot state of the VM following completion of the operation.")
  @visibility("read")
  rebootStatus?: VMGuestPatchRebootStatus;

  @doc("""
Whether the operation ran out of time before it completed all its intended
actions.
""")
  @visibility("read")
  maintenanceWindowExceeded?: boolean;

  @doc("""
The number of patches that were not installed due to the user blocking their
installation.
""")
  @visibility("read")
  excludedPatchCount?: int32;

  @doc("""
The number of patches that were detected as available for install, but did not
meet the operation's criteria.
""")
  @visibility("read")
  notSelectedPatchCount?: int32;

  @doc("""
The number of patches that were identified as meeting the installation
criteria, but were not able to be installed. Typically this happens when
maintenanceWindowExceeded == true.
""")
  @visibility("read")
  pendingPatchCount?: int32;

  @doc("The number of patches successfully installed.")
  @visibility("read")
  installedPatchCount?: int32;

  @doc("""
The number of patches that could not be installed due to some issue. See errors
for details.
""")
  @visibility("read")
  failedPatchCount?: int32;

  @doc("The patches that were installed during the operation.")
  @visibility("read")
  patches?: PatchInstallationDetail[];

  @doc("The UTC timestamp when the operation began.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("""
The errors that were encountered during execution of the operation. The details
array contains the list of them.
""")
  @visibility("read")
  error?: ApiError;
}

@doc("""
Information about a specific patch that was encountered during an installation
action.
""")
model PatchInstallationDetail {
  @doc("A unique identifier for the patch.")
  @visibility("read")
  patchId?: string;

  @doc("The friendly name of the patch.")
  @visibility("read")
  name?: string;

  @doc("""
The version string of the package. It may conform to Semantic Versioning. Only
applies to Linux.
""")
  @visibility("read")
  version?: string;

  @doc("The KBID of the patch. Only applies to Windows patches.")
  @visibility("read")
  kbId?: string;

  @doc("The classification(s) of the patch as provided by the patch publisher.")
  @visibility("read")
  classifications?: string[];

  @doc("The state of the patch after the installation operation completed.")
  @visibility("read")
  installationState?: PatchInstallationState;
}

@doc("Describes a Virtual Machine Image.")
model VirtualMachineImage {
  ...VirtualMachineImageResource;

  @doc("Describes the properties of a Virtual Machine Image.")
  properties?: VirtualMachineImageProperties;
}

@doc("Describes the properties of a Virtual Machine Image.")
model VirtualMachineImageProperties {
  @doc("""
Used for establishing the purchase context of any 3rd Party artifact through
MarketPlace.
""")
  plan?: PurchasePlan;

  @doc("Contains the os disk image information.")
  osDiskImage?: OSDiskImage;

  @doc("The list of data disk images information.")
  dataDiskImages?: DataDiskImage[];

  @doc("Describes automatic OS upgrade properties on the image.")
  automaticOSUpgradeProperties?: AutomaticOSUpgradeProperties;

  @doc("Specifies the HyperVGeneration Type")
  hyperVGeneration?: HyperVGenerationTypes;

  @doc("Specifies disallowed configuration for the VirtualMachine created from the image")
  disallowed?: DisallowedConfiguration;

  features?: VirtualMachineImageFeature[];

  @doc("Specifies the Architecture Type")
  architecture?: ArchitectureTypes;

  @doc("Describes image deprecation status properties on the image.")
  imageDeprecationStatus?: ImageDeprecationStatus;
}

@doc("""
Used for establishing the purchase context of any 3rd Party artifact through
MarketPlace.
""")
model PurchasePlan {
  @doc("The publisher ID.")
  publisher: string;

  @doc("The plan ID.")
  name: string;

  @doc("""
Specifies the product of the image from the marketplace. This is the same value
as Offer under the imageReference element.
""")
  product: string;
}

@doc("Contains the os disk image information.")
model OSDiskImage {
  @doc("The operating system of the osDiskImage.")
  operatingSystem: OperatingSystemTypes;
}

@doc("Contains the data disk images information.")
model DataDiskImage {
  @doc("""
Specifies the logical unit number of the data disk. This value is used to
identify data disks within the VM and therefore must be unique for each data
disk attached to a VM.
""")
  @visibility("read")
  lun?: int32;
}

@doc("Describes automatic OS upgrade properties on the image.")
model AutomaticOSUpgradeProperties {
  @doc("Specifies whether automatic OS upgrade is supported on the image.")
  automaticOSUpgradeSupported: boolean;
}

@doc("Specifies the disallowed configuration for a virtual machine image.")
model DisallowedConfiguration {
  @doc("VM disk types which are disallowed.")
  vmDiskType?: VmDiskTypes;
}

@doc("Specifies additional capabilities supported by the image")
model VirtualMachineImageFeature {
  @doc("The name of the feature.")
  name?: string;

  @doc("The corresponding value for the feature.")
  value?: string;
}

@doc("Describes image deprecation status properties on the image.")
model ImageDeprecationStatus {
  @doc("Describes the state of the image.")
  imageState?: ImageState;

  @doc("""
The time, in future, at which this image will be marked as deprecated. This
scheduled time is chosen by the Publisher.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  scheduledDeprecationTime?: utcDateTime;

  @doc("""
Describes the alternative option specified by the Publisher for this image when
this image is deprecated.
""")
  alternativeOption?: AlternativeOption;
}

@doc("""
Describes the alternative option specified by the Publisher for this image when
this image is deprecated.
""")
model AlternativeOption {
  @doc("Describes the type of the alternative option.")
  type?: AlternativeType;

  @doc("""
Indicates the alternative option value specified by the Publisher. This is the
Offer name when the type is Offer or the Plan name when the type is Plan.
""")
  value?: string;
}

@doc("Virtual machine image resource information.")
model VirtualMachineImageResource {
  ...SubResource;

  @doc("The name of the resource.")
  name: string;

  @doc("The supported Azure location of the resource.")
  location: string;

  @doc("""
Specifies the tags that are assigned to the virtual machine. For more
information about using tags, see [Using tags to organize your Azure
resources](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-using-tags.md).
""")
  tags?: Record<string>;

  @doc("The extended location of the Virtual Machine.")
  extendedLocation?: ExtendedLocation;
}

@doc("The List VmImages in EdgeZone operation response.")
model VmImagesInEdgeZoneListResult {
  @doc("The list of VMImages in EdgeZone")
  value?: VirtualMachineImageResource[];

  @doc("""
The URI to fetch the next page of VMImages in EdgeZone. Call ListNext() with
this URI to fetch the next page of VmImages.
""")
  nextLink?: string;
}

@doc("Describes the properties of a Virtual Machine Extension Image.")
model VirtualMachineExtensionImageProperties {
  @doc("The operating system this extension supports.")
  operatingSystem: string;

  @doc("The type of role (IaaS or PaaS) this extension supports.")
  computeRole: string;

  @doc("""
The schema defined by publisher, where extension consumers should provide
settings in a matching schema.
""")
  handlerSchema: string;

  @doc("""
Whether the extension can be used on xRP VMScaleSets. By default existing
extensions are usable on scalesets, but there might be cases where a publisher
wants to explicitly indicate the extension is only enabled for CRP VMs but not
VMSS.
""")
  vmScaleSetEnabled?: boolean;

  @doc("Whether the handler can support multiple extensions.")
  supportsMultipleExtensions?: boolean;
}

@doc("The instance view of a resource.")
model AvailabilitySetProperties {
  @doc("Update Domain count.")
  platformUpdateDomainCount?: int32;

  @doc("Fault Domain count.")
  platformFaultDomainCount?: int32;

  @doc("A list of references to all virtual machines in the availability set.")
  virtualMachines?: SubResource[];

  @doc("""
Specifies information about the proximity placement group that the availability
set should be assigned to. Minimum api-version: 2018-04-01.
""")
  proximityPlacementGroup?: SubResource;

  @doc("The resource status information.")
  @visibility("read")
  statuses?: InstanceViewStatus[];
}

@doc("Describes the properties of a Proximity Placement Group.")
model ProximityPlacementGroupProperties {
  @doc("""
Specifies the type of the proximity placement group. Possible values are:
**Standard** : Co-locate resources within an Azure region or Availability Zone.
**Ultra** : For future use.
""")
  proximityPlacementGroupType?: ProximityPlacementGroupType;

  @doc("A list of references to all virtual machines in the proximity placement group.")
  @visibility("read")
  virtualMachines?: SubResourceWithColocationStatus[];

  @doc("""
A list of references to all virtual machine scale sets in the proximity
placement group.
""")
  @visibility("read")
  virtualMachineScaleSets?: SubResourceWithColocationStatus[];

  @doc("A list of references to all availability sets in the proximity placement group.")
  @visibility("read")
  availabilitySets?: SubResourceWithColocationStatus[];

  @doc("Describes colocation status of the Proximity Placement Group.")
  colocationStatus?: InstanceViewStatus;

  @doc("Specifies the user intent of the proximity placement group.")
  intent?: ProximityPlacementGroupPropertiesIntent;
}

model SubResourceWithColocationStatus {
  ...SubResource;

  @doc("Describes colocation status of a resource in the Proximity Placement Group.")
  colocationStatus?: InstanceViewStatus;
}

@doc("Specifies the user intent of the proximity placement group.")
model ProximityPlacementGroupPropertiesIntent {
  @doc("""
Specifies possible sizes of virtual machines that can be created in the
proximity placement group.
""")
  vmSizes?: string[];
}

@doc("Specifies information about the proximity placement group.")
model ProximityPlacementGroupUpdate {
  ...UpdateResource;
}

@doc("Dedicated Host Group Properties.")
model DedicatedHostGroupProperties {
  @doc("Number of fault domains that the host group can span.")
  platformFaultDomainCount: int32;

  @doc("A list of references to all dedicated hosts in the dedicated host group.")
  @visibility("read")
  hosts?: SubResourceReadOnly[];

  @doc("""
The dedicated host group instance view, which has the list of instance view of
the dedicated hosts under the dedicated host group.
""")
  @visibility("read")
  instanceView?: DedicatedHostGroupInstanceView;

  @doc("""
Specifies whether virtual machines or virtual machine scale sets can be placed
automatically on the dedicated host group. Automatic placement means resources
are allocated on dedicated hosts, that are chosen by Azure, under the dedicated
host group. The value is defaulted to 'false' when not provided. Minimum
api-version: 2020-06-01.
""")
  supportAutomaticPlacement?: boolean;

  @doc("""
Enables or disables a capability on the dedicated host group. Minimum
api-version: 2022-03-01.
""")
  additionalCapabilities?: DedicatedHostGroupPropertiesAdditionalCapabilities;
}

model DedicatedHostGroupInstanceView {
  @doc("List of instance view of the dedicated hosts under the dedicated host group.")
  hosts?: DedicatedHostInstanceViewWithName[];
}

@doc("""
The instance view of a dedicated host that includes the name of the dedicated
host. It is used for the response to the instance view of a dedicated host
group.
""")
model DedicatedHostInstanceViewWithName {
  ...DedicatedHostInstanceView;

  @doc("The name of the dedicated host.")
  @visibility("read")
  name?: string;
}

@doc("The instance view of a dedicated host.")
model DedicatedHostInstanceView {
  @doc("""
Specifies the unique id of the dedicated physical machine on which the
dedicated host resides.
""")
  @visibility("read")
  assetId?: string;

  @doc("Unutilized capacity of the dedicated host.")
  availableCapacity?: DedicatedHostAvailableCapacity;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("Dedicated host unutilized capacity.")
model DedicatedHostAvailableCapacity {
  @doc("""
The unutilized capacity of the dedicated host represented in terms of each VM
size that is allowed to be deployed to the dedicated host.
""")
  allocatableVMs?: DedicatedHostAllocatableVM[];
}

@doc("""
Represents the dedicated host unutilized capacity in terms of a specific VM
size.
""")
model DedicatedHostAllocatableVM {
  @doc("VM size in terms of which the unutilized capacity is represented.")
  vmSize?: string;

  @doc("""
Maximum number of VMs of size vmSize that can fit in the dedicated host's
remaining capacity.
""")
  count?: float32;
}

@doc("""
Enables or disables a capability on the dedicated host group. Minimum
api-version: 2022-03-01.
""")
model DedicatedHostGroupPropertiesAdditionalCapabilities {
  @doc("""
The flag that enables or disables a capability to have UltraSSD Enabled Virtual
Machines on Dedicated Hosts of the Dedicated Host Group. For the Virtual
Machines to be UltraSSD Enabled, UltraSSDEnabled flag for the resource needs to
be set true as well. The value is defaulted to 'false' when not provided.
Please refer to
https://docs.microsoft.com/en-us/azure/virtual-machines/disks-enable-ultra-ssd
for more details on Ultra SSD feature. **Note:** The ultraSSDEnabled setting
can only be enabled for Host Groups that are created as zonal. Minimum
api-version: 2022-03-01.
""")
  ultraSSDEnabled?: boolean;
}

@doc("Properties of the dedicated host.")
model DedicatedHostProperties {
  @doc("Fault domain of the dedicated host within a dedicated host group.")
  platformFaultDomain?: int32;

  @doc("""
Specifies whether the dedicated host should be replaced automatically in case
of a failure. The value is defaulted to 'true' when not provided.
""")
  autoReplaceOnFailure?: boolean;

  @doc("""
A unique id generated and assigned to the dedicated host by the platform. Does
not change throughout the lifetime of the host.
""")
  @visibility("read")
  hostId?: string;

  @doc("A list of references to all virtual machines in the Dedicated Host.")
  @visibility("read")
  virtualMachines?: SubResourceReadOnly[];

  @doc("""
Specifies the software license type that will be applied to the VMs deployed on
the dedicated host. Possible values are: **None,** **Windows_Server_Hybrid,**
**Windows_Server_Perpetual.** The default value is: **None.**
""")
  licenseType?: DedicatedHostLicenseTypes;

  @doc("The date when the host was first provisioned.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  provisioningTime?: utcDateTime;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("The dedicated host instance view.")
  @visibility("read")
  instanceView?: DedicatedHostInstanceView;

  @doc("""
Specifies the time at which the Dedicated Host resource was created. Minimum
api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("The List Dedicated Host sizes operation response.")
@pagedResult
model DedicatedHostSizeListResult {
  @doc("The list of dedicated host sizes.")
  @items
  value?: string[];
}

@doc("Properties of the SSH public key.")
model SshPublicKeyResourceProperties {
  @doc("""
SSH public key used to authenticate to a virtual machine through ssh. If this
property is not initially provided when the resource is created, the publicKey
property will be populated when generateKeyPair is called. If the public key is
provided upon resource creation, the provided public key needs to be at least
2048-bit and in ssh-rsa format.
""")
  publicKey?: string;
}

@doc("Response from generation of an SSH key pair.")
model SshPublicKeyGenerateKeyPairResult {
  @doc("""
Private key portion of the key pair used to authenticate to a virtual machine
through ssh. The private key is returned in RFC3447 format and should be
treated as a secret.
""")
  privateKey: string;

  @doc("""
Public key portion of the key pair used to authenticate to a virtual machine
through ssh. The public key is in ssh-rsa format.
""")
  publicKey: string;

  @doc("""
The ARM resource id in the form of
/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{SshPublicKeyName}
""")
  id: string;
}

@doc("Describes the properties of an Image.")
model ImageProperties {
  @doc("The source virtual machine from which Image is created.")
  sourceVirtualMachine?: SubResource;

  @doc("Specifies the storage settings for the virtual machine disks.")
  storageProfile?: ImageStorageProfile;

  @doc("The provisioning state.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
Specifies the HyperVGenerationType of the VirtualMachine created from the
image. From API Version 2019-03-01 if the image source is a blob, then we need
the user to specify the value, if the source is managed resource like disk or
snapshot, we may require the user to specify the property if we cannot deduce
it from the source managed resource.
""")
  hyperVGeneration?: HyperVGenerationTypes;
}

@doc("Describes a storage profile.")
model ImageStorageProfile {
  @doc("""
Specifies information about the operating system disk used by the virtual
machine. <br><br> For more information about disks, see [About disks and VHDs
for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  osDisk?: ImageOSDisk;

  @doc("""
Specifies the parameters that are used to add a data disk to a virtual machine.
<br><br> For more information about disks, see [About disks and VHDs for Azure
virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  dataDisks?: ImageDataDisk[];

  @doc("""
Specifies whether an image is zone resilient or not. Default is false. Zone
resilient images can be created only in regions that provide Zone Redundant
Storage (ZRS).
""")
  zoneResilient?: boolean;
}

@doc("Describes an Operating System disk.")
model ImageOSDisk {
  ...ImageDisk;

  @doc("""
This property allows you to specify the type of the OS that is included in the
disk if creating a VM from a custom image. Possible values are: **Windows,**
**Linux.**
""")
  osType: OperatingSystemTypes;

  @doc("The OS State. For managed images, use Generalized.")
  osState: OperatingSystemStateTypes;
}

@doc("Describes a image disk.")
model ImageDisk {
  @doc("The snapshot.")
  snapshot?: SubResource;

  @doc("The managedDisk.")
  managedDisk?: SubResource;

  @doc("The Virtual Hard Disk.")
  blobUri?: string;

  @doc("""
Specifies the caching requirements. Possible values are: **None,**
**ReadOnly,** **ReadWrite.** The default values are: **None for Standard
storage. ReadOnly for Premium storage.**
""")
  caching?: CachingTypes;

  @doc("""
Specifies the size of empty data disks in gigabytes. This element can be used
to overwrite the name of the disk in a virtual machine image. This value cannot
be larger than 1023 GB.
""")
  diskSizeGB?: int32;

  @doc("""
Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can
only be used with data disks, it cannot be used with OS Disk.
""")
  storageAccountType?: StorageAccountTypes;

  @doc("""
Specifies the customer managed disk encryption set resource id for the managed
image disk.
""")
  diskEncryptionSet?: DiskEncryptionSetParameters;
}

@doc("Describes a data disk.")
model ImageDataDisk {
  ...ImageDisk;

  @doc("""
Specifies the logical unit number of the data disk. This value is used to
identify data disks within the VM and therefore must be unique for each data
disk attached to a VM.
""")
  lun: int32;
}

@doc("The restore point collection properties.")
model RestorePointCollectionProperties {
  @doc("""
The properties of the source resource that this restore point collection is
created from.
""")
  source?: RestorePointCollectionSourceProperties;

  @doc("The provisioning state of the restore point collection.")
  @visibility("read")
  provisioningState?: string;

  @doc("The unique id of the restore point collection.")
  @visibility("read")
  restorePointCollectionId?: string;

  @doc("""
A list containing all restore points created under this restore point
collection.
""")
  @visibility("read")
  restorePoints?: RestorePoint[];
}

@doc("""
The properties of the source resource that this restore point collection is
created from.
""")
model RestorePointCollectionSourceProperties {
  @doc("Location of the source resource used to create this restore point collection.")
  @visibility("read")
  location?: string;

  @doc("Resource Id of the source resource used to create this restore point collection")
  id?: string;
}

@doc("The restore point properties.")
model RestorePointProperties {
  @doc("""
List of disk resource ids that the customer wishes to exclude from the restore
point. If no disks are specified, all disks will be included.
""")
  excludeDisks?: ApiEntityReference[];

  @doc("Gets the details of the VM captured at the time of the restore point creation.")
  sourceMetadata?: RestorePointSourceMetadata;

  @doc("Gets the provisioning state of the restore point.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
ConsistencyMode of the RestorePoint. Can be specified in the input while
creating a restore point. For now, only CrashConsistent is accepted as a valid
input. Please refer to https://aka.ms/RestorePoints for more details.
""")
  consistencyMode?: ConsistencyModeTypes;

  @doc("Gets the creation time of the restore point.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  @doc("Resource Id of the source restore point from which a copy needs to be created.")
  sourceRestorePoint?: ApiEntityReference;

  @doc("The restore point instance view.")
  @visibility("read")
  instanceView?: RestorePointInstanceView;
}

@doc("""
Describes the properties of the Virtual Machine for which the restore point was
created. The properties provided are a subset and the snapshot of the overall
Virtual Machine properties captured at the time of the restore point creation.
""")
model RestorePointSourceMetadata {
  @doc("Gets the hardware profile.")
  @visibility("read")
  hardwareProfile?: HardwareProfile;

  @doc("Gets the storage profile.")
  storageProfile?: RestorePointSourceVMStorageProfile;

  @doc("Gets the OS profile.")
  @visibility("read")
  osProfile?: OSProfile;

  @doc("Gets the diagnostics profile.")
  @visibility("read")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("Gets the license type, which is for bring your own license scenario.")
  @visibility("read")
  licenseType?: string;

  @doc("Gets the virtual machine unique id.")
  @visibility("read")
  vmId?: string;

  @doc("Gets the security profile.")
  @visibility("read")
  securityProfile?: SecurityProfile;

  @doc("Location of the VM from which the restore point was created.")
  @visibility("read")
  location?: string;

  @doc("""
UserData associated with the source VM for which restore point is captured,
which is a base-64 encoded value.
""")
  @visibility("read")
  userData?: string;

  @doc("HyperVGeneration of the source VM for which restore point is captured.")
  @visibility("read")
  hyperVGeneration?: HyperVGenerationTypes;
}

@doc("Describes the storage profile.")
model RestorePointSourceVMStorageProfile {
  @doc("Gets the OS disk of the VM captured at the time of the restore point creation.")
  osDisk?: RestorePointSourceVmosDisk;

  @doc("""
Gets the data disks of the VM captured at the time of the restore point
creation.
""")
  @projectedName("json", "dataDisks")
  dataDiskList?: RestorePointSourceVMDataDisk[];
}

@doc("Describes an Operating System disk.")
model RestorePointSourceVmosDisk {
  @doc("Gets the Operating System type.")
  @visibility("read")
  osType?: OperatingSystemType;

  @doc("Gets the disk encryption settings.")
  @visibility("read")
  encryptionSettings?: DiskEncryptionSettings;

  @doc("Gets the disk name.")
  @visibility("read")
  name?: string;

  @doc("Gets the caching type.")
  @visibility("read")
  caching?: CachingTypes;

  @doc("Gets the disk size in GB.")
  @visibility("read")
  diskSizeGB?: int32;

  @doc("Gets the managed disk details")
  managedDisk?: ManagedDiskParameters;

  @doc("Contains Disk Restore Point properties.")
  diskRestorePoint?: DiskRestorePointAttributes;

  @doc("Shows true if the disk is write-accelerator enabled.")
  @visibility("read")
  writeAcceleratorEnabled?: boolean;
}

@doc("Disk Restore Point details.")
model DiskRestorePointAttributes {
  ...SubResourceReadOnly;

  @doc("""
Encryption at rest settings for disk restore point. It is an optional property
that can be specified in the input while creating a restore point.
""")
  encryption?: RestorePointEncryption;

  @doc("Resource Id of the source disk restore point.")
  sourceDiskRestorePoint?: ApiEntityReference;
}

@doc("""
Encryption at rest settings for disk restore point. It is an optional property
that can be specified in the input while creating a restore point.
""")
model RestorePointEncryption {
  @doc("""
Describes the parameter of customer managed disk encryption set resource id
that can be specified for disk. **Note:** The disk encryption set resource id
can only be specified for managed disk. Please refer
https://aka.ms/mdssewithcmkoverview for more details.
""")
  diskEncryptionSet?: DiskEncryptionSetParameters;

  @doc("The type of key used to encrypt the data of the disk restore point.")
  type?: RestorePointEncryptionType;
}

@doc("Describes a data disk.")
model RestorePointSourceVMDataDisk {
  @doc("Gets the logical unit number.")
  @visibility("read")
  lun?: int32;

  @doc("Gets the disk name.")
  @visibility("read")
  name?: string;

  @doc("Gets the caching type.")
  @visibility("read")
  caching?: CachingTypes;

  @doc("""
Gets the initial disk size in GB for blank data disks, and the new desired size
for existing OS and Data disks.
""")
  @visibility("read")
  diskSizeGB?: int32;

  @doc("Contains the managed disk details.")
  managedDisk?: ManagedDiskParameters;

  @doc("Contains Disk Restore Point properties.")
  diskRestorePoint?: DiskRestorePointAttributes;

  @doc("Shows true if the disk is write-accelerator enabled.")
  @visibility("read")
  writeAcceleratorEnabled?: boolean;
}

@doc("The instance view of a restore point.")
model RestorePointInstanceView {
  @doc("The disk restore points information.")
  diskRestorePoints?: DiskRestorePointInstanceView[];

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("The instance view of a disk restore point.")
model DiskRestorePointInstanceView {
  @doc("Disk restore point Id.")
  id?: string;

  @doc("The disk restore point replication status information.")
  replicationStatus?: DiskRestorePointReplicationStatus;
}

@doc("The instance view of a disk restore point.")
model DiskRestorePointReplicationStatus {
  @doc("The resource status information.")
  status?: InstanceViewStatus;

  @doc("Replication completion percentage.")
  completionPercent?: int32;
}

@doc("capacity reservation group Properties.")
model CapacityReservationGroupProperties {
  @doc("""
A list of all capacity reservation resource ids that belong to capacity
reservation group.
""")
  @visibility("read")
  capacityReservations?: SubResourceReadOnly[];

  @doc("""
A list of references to all virtual machines associated to the capacity
reservation group.
""")
  @visibility("read")
  virtualMachinesAssociated?: SubResourceReadOnly[];

  @doc("""
The capacity reservation group instance view which has the list of instance
views for all the capacity reservations that belong to the capacity reservation
group.
""")
  @visibility("read")
  instanceView?: CapacityReservationGroupInstanceView;
}

model CapacityReservationGroupInstanceView {
  @doc("""
List of instance view of the capacity reservations under the capacity
reservation group.
""")
  @visibility("read")
  capacityReservations?: CapacityReservationInstanceViewWithName[];
}

@doc("""
The instance view of a capacity reservation that includes the name of the
capacity reservation. It is used for the response to the instance view of a
capacity reservation group.
""")
model CapacityReservationInstanceViewWithName {
  ...CapacityReservationInstanceView;

  @doc("The name of the capacity reservation.")
  @visibility("read")
  name?: string;
}

@doc("""
The instance view of a capacity reservation that provides as snapshot of the
runtime properties of the capacity reservation that is managed by the platform
and can change outside of control plane operations.
""")
model CapacityReservationInstanceView {
  @doc("Unutilized capacity of the capacity reservation.")
  utilizationInfo?: CapacityReservationUtilization;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("Represents the capacity reservation utilization in terms of resources allocated.")
model CapacityReservationUtilization {
  @doc("""
The value provides the current capacity of the VM size which was reserved
successfully and for which the customer is getting billed. Minimum api-version:
2022-08-01.
""")
  @visibility("read")
  currentCapacity?: int32;

  @doc("""
A list of all virtual machines resource ids allocated against the capacity
reservation.
""")
  @visibility("read")
  virtualMachinesAllocated?: SubResourceReadOnly[];
}

@doc("Properties of the Capacity reservation.")
model CapacityReservationProperties {
  @doc("""
A unique id generated and assigned to the capacity reservation by the platform
which does not change throughout the lifetime of the resource.
""")
  @visibility("read")
  reservationId?: string;

  @doc("""
Specifies the value of fault domain count that Capacity Reservation supports
for requested VM size. **Note:** The fault domain count specified for a
resource (like virtual machines scale set) must be less than or equal to this
value if it deploys using capacity reservation. Minimum api-version:
2022-08-01.
""")
  @visibility("read")
  platformFaultDomainCount?: int32;

  @doc("""
A list of all virtual machine resource ids that are associated with the
capacity reservation.
""")
  @visibility("read")
  virtualMachinesAssociated?: SubResourceReadOnly[];

  @doc("The date time when the capacity reservation was last updated.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  provisioningTime?: utcDateTime;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("The Capacity reservation instance view.")
  @visibility("read")
  instanceView?: CapacityReservationInstanceView;

  @doc("""
Specifies the time at which the Capacity Reservation resource was created.
Minimum api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("Api request input for LogAnalytics getRequestRateByInterval Api.")
model RequestRateByIntervalInput {
  ...LogAnalyticsInputBase;

  @doc("Interval value in minutes used to create LogAnalytics call rate logs.")
  intervalLength: IntervalInMins;
}

@doc("Api input base class for LogAnalytics Api.")
model LogAnalyticsInputBase {
  @doc("""
SAS Uri of the logging blob container to which LogAnalytics Api writes output
logs to.
""")
  blobContainerSasUri: string;

  @doc("From time of the query")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  fromTime: utcDateTime;

  @doc("To time of the query")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  toTime: utcDateTime;

  @doc("Group query result by Throttle Policy applied.")
  groupByThrottlePolicy?: boolean;

  @doc("Group query result by Operation Name.")
  groupByOperationName?: boolean;

  @doc("Group query result by Resource Name.")
  groupByResourceName?: boolean;

  @doc("Group query result by Client Application ID.")
  groupByClientApplicationId?: boolean;

  @doc("Group query result by User Agent.")
  groupByUserAgent?: boolean;
}

@doc("LogAnalytics operation status response")
model LogAnalyticsOperationResult {
  @doc("LogAnalyticsOutput")
  @visibility("read")
  properties?: LogAnalyticsOutput;
}

@doc("LogAnalytics output properties")
model LogAnalyticsOutput {
  @doc("Output file Uri path to blob container.")
  @visibility("read")
  output?: string;
}

@doc("Api request input for LogAnalytics getThrottledRequests Api.")
model ThrottledRequestsInput {
  ...LogAnalyticsInputBase;
}

@doc("Describes the properties of a Run Command metadata.")
model RunCommandDocumentBase {
  @doc("The VM run command schema.")
  @projectedName("json", "$schema")
  schema: string;

  @doc("The VM run command id.")
  id: string;

  @doc("The Operating System type.")
  osType: OperatingSystemTypes;

  @doc("The VM run command label.")
  label: string;

  @doc("The VM run command description.")
  description: string;
}

@doc("Describes the properties of a Run Command.")
model RunCommandDocument {
  ...RunCommandDocumentBase;

  @doc("The script to be executed.")
  script: string[];

  @doc("The parameters used by the script.")
  parameters?: RunCommandParameterDefinition[];
}

@doc("Describes the properties of a run command parameter.")
model RunCommandParameterDefinition {
  @doc("The run command parameter name.")
  name: string;

  @doc("The run command parameter type.")
  type: string;

  @doc("The run command parameter default value.")
  defaultValue?: string;

  @doc("The run command parameter required.")
  required?: boolean;
}

@doc("Capture Virtual Machine parameters.")
model RunCommandInput {
  @doc("The run command id.")
  commandId: string;

  @doc("""
Optional. The script to be executed.  When this value is given, the given
script will override the default script of the command.
""")
  script?: string[];

  @doc("The run command parameters.")
  parameters?: RunCommandInputParameter[];
}

@doc("Describes the properties of a run command parameter.")
model RunCommandInputParameter {
  @doc("The run command parameter name.")
  name: string;

  @doc("The run command parameter value.")
  value: string;
}

model RunCommandResult {
  @doc("Run command operation response.")
  value?: InstanceViewStatus[];
}

@doc("Describes the properties of a Virtual Machine run command.")
model VirtualMachineRunCommandProperties {
  @doc("The source of the run command script.")
  source?: VirtualMachineRunCommandScriptSource;

  @doc("The parameters used by the script.")
  parameters?: RunCommandInputParameter[];

  @doc("The parameters used by the script.")
  protectedParameters?: RunCommandInputParameter[];

  @doc("""
Optional. If set to true, provisioning will complete as soon as the script
starts and will not wait for script to complete.
""")
  asyncExecution?: boolean;

  @doc("Specifies the user account on the VM when executing the run command.")
  runAsUser?: string;

  @doc("Specifies the user account password on the VM when executing the run command.")
  runAsPassword?: string;

  @doc("The timeout in seconds to execute the run command.")
  timeoutInSeconds?: int32;

  @doc("""
Specifies the Azure storage blob where script output stream will be uploaded.
Use a SAS URI with read, append, create, write access OR use managed identity
to provide the VM access to the blob. Refer outputBlobManagedIdentity
parameter. 
""")
  outputBlobUri?: string;

  @doc("""
Specifies the Azure storage blob where script error stream will be uploaded.
Use a SAS URI with read, append, create, write access OR use managed identity
to provide the VM access to the blob. Refer errorBlobManagedIdentity parameter.
""")
  errorBlobUri?: string;

  @doc("""
User-assigned managed identity that has access to outputBlobUri storage blob.
Use an empty object in case of system-assigned identity. Make sure managed
identity has been given access to blob's container with 'Storage Blob Data
Contributor' role assignment. In case of user-assigned identity, make sure you
add it under VM's identity. For more info on managed identity and Run Command,
refer https://aka.ms/ManagedIdentity and https://aka.ms/RunCommandManaged 
""")
  outputBlobManagedIdentity?: RunCommandManagedIdentity;

  @doc("""
User-assigned managed identity that has access to errorBlobUri storage blob.
Use an empty object in case of system-assigned identity. Make sure managed
identity has been given access to blob's container with 'Storage Blob Data
Contributor' role assignment. In case of user-assigned identity, make sure you
add it under VM's identity. For more info on managed identity and Run Command,
refer https://aka.ms/ManagedIdentity and https://aka.ms/RunCommandManaged 
""")
  errorBlobManagedIdentity?: RunCommandManagedIdentity;

  @doc("""
The provisioning state, which only appears in the response. If
treatFailureAsDeploymentFailure set to true, any failure in the script will
fail the deployment and ProvisioningState will be marked as Failed. If
treatFailureAsDeploymentFailure set to false, ProvisioningState would only
reflect whether the run command was run or not by the extensions platform, it
would not indicate whether script failed in case of script failures. See
instance view of run command in case of script failures to see
executionMessage, output, error:
https://aka.ms/runcommandmanaged#get-execution-status-and-results 
""")
  @visibility("read")
  provisioningState?: string;

  @doc("The virtual machine run command instance view.")
  @visibility("read")
  instanceView?: VirtualMachineRunCommandInstanceView;

  @doc("""
Optional. If set to true, any failure in the script will fail the deployment
and ProvisioningState will be marked as Failed. If set to false,
ProvisioningState would only reflect whether the run command was run or not by
the extensions platform, it would not indicate whether script failed in case of
script failures. See instance view of run command in case of script failures to
see executionMessage, output, error:
https://aka.ms/runcommandmanaged#get-execution-status-and-results 
""")
  treatFailureAsDeploymentFailure?: boolean;
}

@doc("""
Describes the script sources for run command. Use only one of script,
scriptUri, commandId.
""")
model VirtualMachineRunCommandScriptSource {
  @doc("Specifies the script content to be executed on the VM.")
  script?: string;

  @doc("""
Specifies the script download location. It can be either SAS URI of an Azure
storage blob with read access or public URI.
""")
  scriptUri?: string;

  @doc("Specifies a commandId of predefined built-in script.")
  commandId?: string;

  @doc("""
User-assigned managed identity that has access to scriptUri in case of Azure
storage blob. Use an empty object in case of system-assigned identity. Make
sure the Azure storage blob exists, and managed identity has been given access
to blob's container with 'Storage Blob Data Reader' role assignment. In case of
user-assigned identity, make sure you add it under VM's identity. For more info
on managed identity and Run Command, refer https://aka.ms/ManagedIdentity and
https://aka.ms/RunCommandManaged.
""")
  scriptUriManagedIdentity?: RunCommandManagedIdentity;
}

@doc("""
 Contains clientId or objectId (use only one, not both) of a user-assigned
managed identity that has access to storage blob used in Run Command. Use an
empty RunCommandManagedIdentity object in case of system-assigned identity.
Make sure the Azure storage blob exists in case of scriptUri, and managed
identity has been given access to blob's container with 'Storage Blob Data
Reader' role assignment with scriptUri blob and 'Storage Blob Data Contributor'
for Append blobs(outputBlobUri, errorBlobUri). In case of user assigned
identity, make sure you add it under VM's identity. For more info on managed
identity and Run Command, refer https://aka.ms/ManagedIdentity and
https://aka.ms/RunCommandManaged.
""")
model RunCommandManagedIdentity {
  @doc("""
Client Id (GUID value) of the user-assigned managed identity. ObjectId should
not be used if this is provided.
""")
  clientId?: string;

  @doc("""
Object Id (GUID value) of the user-assigned managed identity. ClientId should
not be used if this is provided.
""")
  objectId?: string;
}

@doc("The instance view of a virtual machine run command.")
model VirtualMachineRunCommandInstanceView {
  @doc("Script execution status.")
  executionState?: ExecutionState;

  @doc("Communicate script configuration errors or execution messages.")
  executionMessage?: string;

  @doc("Exit code returned from script execution.")
  exitCode?: int32;

  @doc("Script output stream.")
  output?: string;

  @doc("Script error stream.")
  error?: string;

  @doc("Script start time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("Script end time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];
}

@doc("""
The disks sku name. Can be Standard_LRS, Premium_LRS, StandardSSD_LRS,
UltraSSD_LRS, Premium_ZRS, StandardSSD_ZRS, or PremiumV2_LRS.
""")
model DiskSku {
  @doc("The sku name.")
  name?: DiskStorageAccountTypes;

  @doc("The sku tier.")
  @visibility("read")
  tier?: string;
}

@doc("Disk resource properties.")
model DiskProperties {
  @doc("The time when the disk was created.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  @doc("The Operating System type.")
  osType?: OperatingSystemTypes;

  @doc("The hypervisor generation of the Virtual Machine. Applicable to OS disks only.")
  hyperVGeneration?: HyperVGeneration;

  @doc("""
Purchase plan information for the the image from which the OS disk was created.
E.g. - {name: 2019-Datacenter, publisher: MicrosoftWindowsServer, product:
WindowsServer}
""")
  purchasePlan?: DiskPurchasePlan;

  @doc("List of supported capabilities for the image from which the OS disk was created.")
  supportedCapabilities?: SupportedCapabilities;

  @doc("""
Disk source information. CreationData information cannot be changed after the
disk has been created.
""")
  creationData: CreationData;

  @doc("""
If creationData.createOption is Empty, this field is mandatory and it indicates
the size of the disk to create. If this field is present for updates or
creation with other options, it indicates a resize. Resizes are only allowed if
the disk is not attached to a running VM, and can only increase the disk's
size.
""")
  diskSizeGB?: int32;

  @doc("The size of the disk in bytes. This field is read only.")
  @visibility("read")
  diskSizeBytes?: int32;

  @doc("Unique Guid identifying the resource.")
  @visibility("read")
  uniqueId?: string;

  @doc("""
Encryption settings collection used for Azure Disk Encryption, can contain
multiple encryption settings per disk or snapshot.
""")
  encryptionSettingsCollection?: EncryptionSettingsCollection;

  @doc("The disk provisioning state.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
The number of IOPS allowed for this disk; only settable for UltraSSD disks. One
operation can transfer between 4k and 256k bytes.
""")
  @projectedName("json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int32;

  @doc("""
The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps
means millions of bytes per second - MB here uses the ISO notation, of powers
of 10.
""")
  diskMBpsReadWrite?: int32;

  @doc("""
The total number of IOPS that will be allowed across all VMs mounting the
shared disk as ReadOnly. One operation can transfer between 4k and 256k bytes.
""")
  @projectedName("json", "diskIOPSReadOnly")
  diskIopsReadOnly?: int32;

  @doc("""
The total throughput (MBps) that will be allowed across all VMs mounting the
shared disk as ReadOnly. MBps means millions of bytes per second - MB here uses
the ISO notation, of powers of 10.
""")
  diskMBpsReadOnly?: int32;

  @doc("The state of the disk.")
  @visibility("read")
  diskState?: DiskState;

  @doc("""
Encryption property can be used to encrypt data at rest with customer managed
keys or platform managed keys.
""")
  encryption?: Encryption;

  @doc("""
The maximum number of VMs that can attach to the disk at the same time. Value
greater than one indicates a disk that can be mounted on multiple VMs at the
same time.
""")
  maxShares?: int32;

  @doc("""
Details of the list of all VMs that have the disk attached. maxShares should be
set to a value greater than one for disks to allow attaching them to multiple
VMs.
""")
  @visibility("read")
  shareInfo?: ShareInfoElement[];

  @doc("Policy for accessing the disk via network.")
  networkAccessPolicy?: NetworkAccessPolicy;

  @doc("ARM id of the DiskAccess resource for using private endpoints on disks.")
  diskAccessId?: string;

  @doc("Latest time when bursting was last enabled on a disk.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  burstingEnabledTime?: utcDateTime;

  @doc("""
Performance tier of the disk (e.g, P4, S10) as described here:
https://azure.microsoft.com/en-us/pricing/details/managed-disks/. Does not
apply to Ultra disks.
""")
  tier?: string;

  @doc("""
Set to true to enable bursting beyond the provisioned performance target of the
disk. Bursting is disabled by default. Does not apply to Ultra disks.
""")
  burstingEnabled?: boolean;

  @doc("Properties of the disk for which update is pending.")
  @visibility("read")
  propertyUpdatesInProgress?: PropertyUpdatesInProgress;

  @doc("Indicates the OS on a disk supports hibernation.")
  supportsHibernation?: boolean;

  @doc("Contains the security related information for the resource.")
  securityProfile?: DiskSecurityProfile;

  @doc("""
Percentage complete for the background copy when a resource is created via the
CopyStart operation.
""")
  completionPercent?: float32;

  @doc("Policy for controlling export on the disk.")
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("""
Additional authentication requirements when exporting or uploading to a disk or
snapshot.
""")
  dataAccessAuthMode?: DataAccessAuthMode;

  @doc("""
Setting this property to true improves reliability and performance of data
disks that are frequently (more than 5 times a day) by detached from one
virtual machine and attached to another. This property should not be set for
disks that are not detached and attached frequently as it causes the disks to
not align with the fault domain of the virtual machine.
""")
  optimizedForFrequentAttach?: boolean;

  @doc("""
The UTC time when the ownership state of the disk was last changed i.e., the
time the disk was last attached or detached from a VM or the time when the VM
to which the disk was attached was deallocated or started.
""")
  @visibility("read")
  @projectedName("json", "LastOwnershipUpdateTime")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastOwnershipUpdateTime?: utcDateTime;
}

@doc("""
Used for establishing the purchase context of any 3rd Party artifact through
MarketPlace.
""")
model DiskPurchasePlan {
  @doc("The plan ID.")
  name: string;

  @doc("The publisher ID.")
  publisher: string;

  @doc("""
Specifies the product of the image from the marketplace. This is the same value
as Offer under the imageReference element.
""")
  product: string;

  @doc("The Offer Promotion Code.")
  promotionCode?: string;
}

@doc("List of supported capabilities persisted on the disk resource for VM use.")
model SupportedCapabilities {
  @doc("""
The disk controllers that an OS disk supports. If set it can be SCSI or SCSI,
NVME or NVME, SCSI.
""")
  diskControllerTypes?: string;

  @doc("""
True if the image from which the OS disk is created supports accelerated
networking.
""")
  acceleratedNetwork?: boolean;

  @doc("CPU architecture supported by an OS disk.")
  architecture?: Architecture;
}

@doc("Data used when creating a disk.")
model CreationData {
  @doc("This enumerates the possible sources of a disk's creation.")
  createOption: DiskCreateOption;

  @doc("""
Required if createOption is Import. The Azure Resource Manager identifier of
the storage account containing the blob to import as a disk.
""")
  storageAccountId?: string;

  @doc("Disk source information for PIR or user images.")
  imageReference?: ImageDiskReference;

  @doc("""
Required if creating from a Gallery Image. The
id/sharedGalleryImageId/communityGalleryImageId of the ImageDiskReference will
be the ARM id of the shared galley image version from which to create a disk.
""")
  galleryImageReference?: ImageDiskReference;

  @doc("""
If createOption is Import, this is the URI of a blob to be imported into a
managed disk.
""")
  sourceUri?: string;

  @doc("If createOption is Copy, this is the ARM id of the source snapshot or disk.")
  sourceResourceId?: string;

  @doc("""
If this field is set, this is the unique id identifying the source of this
resource.
""")
  @visibility("read")
  sourceUniqueId?: string;

  @doc("""
If createOption is Upload, this is the size of the contents of the upload
including the VHD footer. This value should be between 20972032 (20 MiB + 512
bytes for the VHD footer) and 35183298347520 bytes (32 TiB + 512 bytes for the
VHD footer).
""")
  uploadSizeBytes?: int32;

  @doc("""
Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096.
4096 is the default.
""")
  logicalSectorSize?: int32;

  @doc("""
If createOption is ImportSecure, this is the URI of a blob to be imported into
VM guest state.
""")
  securityDataUri?: string;

  @doc("""
Set this flag to true to get a boost on the performance target of the disk
deployed, see here on the respective performance target. This flag can only be
set on disk creation time and cannot be disabled after enabled.
""")
  performancePlus?: boolean;

  @doc("""
Required if createOption is CopyFromSanSnapshot. This is the ARM id of the
source elastic san volume snapshot.
""")
  elasticSanResourceId?: string;
}

@doc("The source image used for creating the disk.")
model ImageDiskReference {
  @doc("""
A relative uri containing either a Platform Image Repository, user image, or
Azure Compute Gallery image reference.
""")
  id?: string;

  @doc("A relative uri containing a direct shared Azure Compute Gallery image reference.")
  sharedGalleryImageId?: string;

  @doc("A relative uri containing a community Azure Compute Gallery image reference.")
  communityGalleryImageId?: string;

  @doc("""
If the disk is created from an image's data disk, this is an index that
indicates which of the data disks in the image to use. For OS disks, this field
is null.
""")
  lun?: int32;
}

@doc("Encryption settings for disk or snapshot")
model EncryptionSettingsCollection {
  @doc("""
Set this flag to true and provide DiskEncryptionKey and optional
KeyEncryptionKey to enable encryption. Set this flag to false and remove
DiskEncryptionKey and KeyEncryptionKey to disable encryption. If
EncryptionSettings is null in the request object, the existing settings remain
unchanged.
""")
  enabled: boolean;

  @doc("A collection of encryption settings, one for each disk volume.")
  encryptionSettings?: EncryptionSettingsElement[];

  @doc("""
Describes what type of encryption is used for the disks. Once this field is
set, it cannot be overwritten. '1.0' corresponds to Azure Disk Encryption with
AAD app.'1.1' corresponds to Azure Disk Encryption.
""")
  encryptionSettingsVersion?: string;
}

@doc("Encryption settings for one disk volume.")
model EncryptionSettingsElement {
  @doc("Key Vault Secret Url and vault id of the disk encryption key")
  diskEncryptionKey?: KeyVaultAndSecretReference;

  @doc("""
Key Vault Key Url and vault id of the key encryption key. KeyEncryptionKey is
optional and when provided is used to unwrap the disk encryption key.
""")
  keyEncryptionKey?: KeyVaultAndKeyReference;
}

@doc("Key Vault Secret Url and vault id of the encryption key ")
model KeyVaultAndSecretReference {
  @doc("Resource id of the KeyVault containing the key or secret")
  sourceVault: SourceVault;

  @doc("Url pointing to a key or secret in KeyVault")
  secretUrl: string;
}

@doc("""
The vault id is an Azure Resource Manager Resource id in the form
/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}
""")
model SourceVault {
  @doc("Resource Id")
  id?: string;
}

@doc("""
Key Vault Key Url and vault id of KeK, KeK is optional and when provided is
used to unwrap the encryptionKey
""")
model KeyVaultAndKeyReference {
  @doc("Resource id of the KeyVault containing the key or secret")
  sourceVault: SourceVault;

  @doc("Url pointing to a key or secret in KeyVault")
  keyUrl: string;
}

@doc("Encryption at rest settings for disk or snapshot")
model Encryption {
  @doc("ResourceId of the disk encryption set to use for enabling encryption at rest.")
  diskEncryptionSetId?: string;

  @doc("The type of key used to encrypt the data of the disk.")
  type?: EncryptionType;
}

model ShareInfoElement {
  @doc("A relative URI containing the ID of the VM that has the disk attached.")
  @visibility("read")
  vmUri?: string;
}

@doc("Properties of the disk for which update is pending.")
model PropertyUpdatesInProgress {
  @doc("""
The target performance tier of the disk if a tier change operation is in
progress.
""")
  targetTier?: string;
}

@doc("Contains the security related information for the resource.")
model DiskSecurityProfile {
  @doc("Specifies the SecurityType of the VM. Applicable for OS disks only.")
  securityType?: DiskSecurityTypes;

  @doc("""
ResourceId of the disk encryption set associated to Confidential VM supported
disk encrypted with customer managed key
""")
  secureVMDiskEncryptionSetId?: string;
}

@doc("Data used for requesting a SAS.")
model GrantAccessData {
  @doc("The Access Level, accepted values include None, Read, Write.")
  access: AccessLevel;

  @doc("Time duration in seconds until the SAS access expires.")
  durationInSeconds: int32;

  @doc("Set this flag to true to get additional SAS for VM guest state")
  getSecureVMGuestStateSAS?: boolean;

  @doc("""
Used to specify the file format when making request for SAS on a VHDX file
format snapshot
""")
  fileFormat?: FileFormat;
}

@doc("A disk access SAS uri.")
model AccessUri {
  @doc("A SAS uri for accessing a disk.")
  @visibility("read")
  accessSAS?: string;

  @doc("A SAS uri for accessing a VM guest state.")
  @visibility("read")
  securityDataAccessSAS?: string;
}

model DiskAccessProperties {
  @doc("""
A readonly collection of private endpoint connections created on the disk.
Currently only one endpoint connection is supported.
""")
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];

  @doc("The disk access resource provisioning state.")
  @visibility("read")
  provisioningState?: string;

  @doc("The time when the disk access was created.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("Properties of the PrivateEndpointConnectProperties.")
model PrivateEndpointConnectionProperties {
  @doc("The resource of private end point.")
  @visibility("read")
  privateEndpoint?: PrivateEndpoint;

  @doc("""
A collection of information about the state of the connection between
DiskAccess and Virtual Network.
""")
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

@doc("""
A collection of information about the state of the connection between service
consumer and provider.
""")
model PrivateLinkServiceConnectionState {
  @doc("""
Indicates whether the connection has been Approved/Rejected/Removed by the
owner of the service.
""")
  status?: PrivateEndpointServiceConnectionStatus;

  @doc("The reason for approval/rejection of the connection.")
  description?: string;

  @doc("""
A message indicating if changes on the service provider require any updates on
the consumer.
""")
  actionsRequired?: string;
}

@doc("A list of private link resources")
model PrivateLinkResourceListResult {
  @doc("Array of private link resources")
  value?: PrivateLinkResource[];
}

@doc("A private link resource")
model PrivateLinkResource {
  @doc("Resource properties.")
  properties?: PrivateLinkResourceProperties;

  @doc("private link resource Id")
  @visibility("read")
  id?: string;

  @doc("private link resource name")
  @visibility("read")
  name?: string;

  @doc("private link resource type")
  @visibility("read")
  type?: string;
}

@doc("Properties of a private link resource.")
model PrivateLinkResourceProperties {
  @doc("The private link resource group id.")
  @visibility("read")
  groupId?: string;

  @doc("The private link resource required member names.")
  @visibility("read")
  requiredMembers?: string[];

  @doc("The private link resource DNS zone name.")
  requiredZoneNames?: string[];
}

@doc("""
The managed identity for the disk encryption set. It should be given permission
on the key vault before it can be used to encrypt disks.
""")
model EncryptionSetIdentity {
  @doc("""
The type of Managed Identity used by the DiskEncryptionSet. Only SystemAssigned
is supported for new creations. Disk Encryption Sets can be updated with
Identity type None during migration of subscription to a new Azure Active
Directory tenant; it will cause the encrypted resources to lose access to the
keys.
""")
  type?: DiskEncryptionSetIdentityType;

  @doc("""
The object id of the Managed Identity Resource. This will be sent to the RP
from ARM via the x-ms-identity-principal-id header in the PUT request if the
resource has a systemAssigned(implicit) identity
""")
  @visibility("read")
  principalId?: string;

  @doc("""
The tenant id of the Managed Identity Resource. This will be sent to the RP
from ARM via the x-ms-client-tenant-id header in the PUT request if the
resource has a systemAssigned(implicit) identity
""")
  @visibility("read")
  tenantId?: string;

  @doc("""
The list of user identities associated with the disk encryption set. The user
identity dictionary key references will be ARM resource ids in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

model EncryptionSetProperties {
  @doc("The type of key used to encrypt the data of the disk.")
  encryptionType?: DiskEncryptionSetType;

  @doc("The key vault key which is currently used by this disk encryption set.")
  activeKey?: KeyForDiskEncryptionSet;

  @doc("""
A readonly collection of key vault keys previously used by this disk encryption
set while a key rotation is in progress. It will be empty if there is no
ongoing key rotation.
""")
  @visibility("read")
  previousKeys?: KeyForDiskEncryptionSet[];

  @doc("The disk encryption set provisioning state.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
Set this flag to true to enable auto-updating of this disk encryption set to
the latest key version.
""")
  rotationToLatestKeyVersionEnabled?: boolean;

  @doc("The time when the active key of this disk encryption set was updated.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastKeyRotationTimestamp?: utcDateTime;

  @doc("""
The error that was encountered during auto-key rotation. If an error is
present, then auto-key rotation will not be attempted until the error on this
disk encryption set is fixed.
""")
  @visibility("read")
  autoKeyRotationError?: ApiError;

  @doc("""
Multi-tenant application client id to access key vault in a different tenant.
Setting the value to 'None' will clear the property.
""")
  federatedClientId?: string;
}

@doc("""
Key Vault Key Url to be used for server side encryption of Managed Disks and
Snapshots
""")
model KeyForDiskEncryptionSet {
  @doc("""
Resource id of the KeyVault containing the key or secret. This property is
optional and cannot be used if the KeyVault subscription is not the same as the
Disk Encryption Set subscription.
""")
  sourceVault?: SourceVault;

  @doc("""
Fully versioned Key Url pointing to a key in KeyVault. Version segment of the
Url is required regardless of rotationToLatestKeyVersionEnabled value.
""")
  keyUrl: string;
}

@doc("The List resources which are encrypted with the disk encryption set.")
model ResourceUriList is Azure.Core.Page<string>;

@doc("Properties of an incremental disk restore point")
model DiskRestorePointProperties {
  @doc("The timestamp of restorePoint creation")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  @doc("arm id of source disk or source disk restore point.")
  @visibility("read")
  sourceResourceId?: string;

  @doc("The Operating System type.")
  @visibility("read")
  osType?: OperatingSystemTypes;

  @doc("The hypervisor generation of the Virtual Machine. Applicable to OS disks only.")
  hyperVGeneration?: HyperVGeneration;

  @doc("Purchase plan information for the the image from which the OS disk was created.")
  purchasePlan?: DiskPurchasePlan;

  @doc("List of supported capabilities for the image from which the OS disk was created.")
  supportedCapabilities?: SupportedCapabilities;

  @doc("id of the backing snapshot's MIS family")
  @visibility("read")
  familyId?: string;

  @doc("unique incarnation id of the source disk")
  @visibility("read")
  sourceUniqueId?: string;

  @doc("""
Encryption property can be used to encrypt data at rest with customer managed
keys or platform managed keys.
""")
  @visibility("read")
  encryption?: Encryption;

  @doc("Indicates the OS on a disk supports hibernation.")
  supportsHibernation?: boolean;

  @doc("Policy for accessing the disk via network.")
  networkAccessPolicy?: NetworkAccessPolicy;

  @doc("Policy for controlling export on the disk.")
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("ARM id of the DiskAccess resource for using private endpoints on disks.")
  diskAccessId?: string;

  @doc("""
Percentage complete for the background copy of disk restore point when source
resource is from a different region.
""")
  completionPercent?: float32;

  @doc("""
Replication state of disk restore point when source resource is from a
different region.
""")
  @visibility("read")
  replicationState?: string;

  @doc("""
Location of source disk or source disk restore point when source resource is
from a different region.
""")
  @visibility("read")
  sourceResourceLocation?: string;

  @doc("Contains the security related information for the resource.")
  securityProfile?: DiskSecurityProfile;
}

@doc("The ProxyOnly Resource model definition.")
model ProxyOnlyResource {
  @doc("Resource Id")
  @visibility("read")
  id?: string;

  @doc("Resource name")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;
}

@doc("""
The snapshots sku name. Can be Standard_LRS, Premium_LRS, or Standard_ZRS. This
is an optional parameter for incremental snapshot and the default behavior is
the SKU will be set to the same sku as the previous snapshot
""")
model SnapshotSku {
  @doc("The sku name.")
  name?: SnapshotStorageAccountTypes;

  @doc("The sku tier.")
  @visibility("read")
  tier?: string;
}

@doc("Snapshot resource properties.")
model SnapshotProperties {
  @doc("The time when the snapshot was created.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  @doc("The Operating System type.")
  osType?: OperatingSystemTypes;

  @doc("The hypervisor generation of the Virtual Machine. Applicable to OS disks only.")
  hyperVGeneration?: HyperVGeneration;

  @doc("""
Purchase plan information for the image from which the source disk for the
snapshot was originally created.
""")
  purchasePlan?: DiskPurchasePlan;

  @doc("""
List of supported capabilities for the image from which the source disk from
the snapshot was originally created.
""")
  supportedCapabilities?: SupportedCapabilities;

  @doc("""
Disk source information. CreationData information cannot be changed after the
disk has been created.
""")
  creationData: CreationData;

  @doc("""
If creationData.createOption is Empty, this field is mandatory and it indicates
the size of the disk to create. If this field is present for updates or
creation with other options, it indicates a resize. Resizes are only allowed if
the disk is not attached to a running VM, and can only increase the disk's
size.
""")
  diskSizeGB?: int32;

  @doc("The size of the disk in bytes. This field is read only.")
  @visibility("read")
  diskSizeBytes?: int32;

  @doc("The state of the snapshot.")
  @visibility("read")
  diskState?: DiskState;

  @doc("Unique Guid identifying the resource.")
  @visibility("read")
  uniqueId?: string;

  @doc("""
Encryption settings collection used be Azure Disk Encryption, can contain
multiple encryption settings per disk or snapshot.
""")
  encryptionSettingsCollection?: EncryptionSettingsCollection;

  @doc("The disk provisioning state.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
Whether a snapshot is incremental. Incremental snapshots on the same disk
occupy less space than full snapshots and can be diffed.
""")
  incremental?: boolean;

  @doc("""
Incremental snapshots for a disk share an incremental snapshot family id. The
Get Page Range Diff API can only be called on incremental snapshots with the
same family id.
""")
  @visibility("read")
  incrementalSnapshotFamilyId?: string;

  @doc("""
Encryption property can be used to encrypt data at rest with customer managed
keys or platform managed keys.
""")
  encryption?: Encryption;

  @doc("Policy for accessing the disk via network.")
  networkAccessPolicy?: NetworkAccessPolicy;

  @doc("ARM id of the DiskAccess resource for using private endpoints on disks.")
  diskAccessId?: string;

  @doc("Contains the security related information for the resource.")
  securityProfile?: DiskSecurityProfile;

  @doc("Indicates the OS on a snapshot supports hibernation.")
  supportsHibernation?: boolean;

  @doc("Policy for controlling export on the disk.")
  publicNetworkAccess?: PublicNetworkAccess;

  @doc("""
Percentage complete for the background copy when a resource is created via the
CopyStart operation.
""")
  completionPercent?: float32;

  @doc("""
Indicates the error details if the background copy of a resource created via
the CopyStart operation fails.
""")
  copyCompletionError?: CopyCompletionError;

  @doc("""
Additional authentication requirements when exporting or uploading to a disk or
snapshot.
""")
  dataAccessAuthMode?: DataAccessAuthMode;
}

@doc("""
Indicates the error details if the background copy of a resource created via
the CopyStart operation fails.
""")
model CopyCompletionError {
  @doc("""
Indicates the error code if the background copy of a resource created via the
CopyStart operation fails.
""")
  errorCode: CopyCompletionErrorReason;

  @doc("""
Indicates the error message if the background copy of a resource created via
the CopyStart operation fails.
""")
  errorMessage: string;
}

@doc("The List Resource Skus operation response.")
model ResourceSkusResult is Azure.Core.Page<ResourceSku>;

@doc("Describes an available Compute SKU.")
model ResourceSku {
  @doc("The type of resource the SKU applies to.")
  @visibility("read")
  resourceType?: string;

  @doc("The name of SKU.")
  @visibility("read")
  name?: string;

  @doc("""
Specifies the tier of virtual machines in a scale set.<br /><br /> Possible
Values:<br /><br /> **Standard**<br /><br /> **Basic**
""")
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
  capacity?: ResourceSkuCapacity;

  @doc("The set of locations that the SKU is available.")
  @visibility("read")
  locations?: string[];

  @doc("""
A list of locations and availability zones in those locations where the SKU is
available.
""")
  @visibility("read")
  locationInfo?: ResourceSkuLocationInfo[];

  @doc("The api versions that support this SKU.")
  @visibility("read")
  apiVersions?: string[];

  @doc("Metadata for retrieving price info.")
  @visibility("read")
  costs?: ResourceSkuCosts[];

  @doc("A name value pair to describe the capability.")
  @visibility("read")
  capabilities?: ResourceSkuCapabilities[];

  @doc("""
The restrictions because of which SKU cannot be used. This is empty if there
are no restrictions.
""")
  @visibility("read")
  restrictions?: ResourceSkuRestrictions[];
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

@doc("Describes an available Compute SKU Location Information.")
model ResourceSkuLocationInfo {
  @doc("Location of the SKU")
  @visibility("read")
  location?: string;

  @doc("List of availability zones where the SKU is supported.")
  @visibility("read")
  zones?: string[];

  @doc("Details of capabilities available to a SKU in specific zones.")
  @visibility("read")
  zoneDetails?: ResourceSkuZoneDetails[];

  @doc("The names of extended locations.")
  @visibility("read")
  extendedLocations?: string[];

  @doc("The type of the extended location.")
  @visibility("read")
  type?: ExtendedLocationType;
}

@doc("Describes The zonal capabilities of a SKU.")
model ResourceSkuZoneDetails {
  @doc("The set of zones that the SKU is available in with the specified capabilities.")
  @visibility("read")
  name?: string[];

  @doc("""
A list of capabilities that are available for the SKU in the specified list of
zones.
""")
  @visibility("read")
  capabilities?: ResourceSkuCapabilities[];
}

@doc("Describes The SKU capabilities object.")
model ResourceSkuCapabilities {
  @doc("An invariant to describe the feature.")
  @visibility("read")
  name?: string;

  @doc("An invariant if the feature is measured by quantity.")
  @visibility("read")
  value?: string;
}

@doc("Describes metadata for retrieving price info.")
model ResourceSkuCosts {
  @doc("Used for querying price from commerce.")
  @visibility("read")
  meterID?: string;

  @doc("The multiplier is needed to extend the base metered cost.")
  @visibility("read")
  quantity?: int32;

  @doc("An invariant to show the extended unit.")
  @visibility("read")
  extendedUnit?: string;
}

@doc("Describes scaling information of a SKU.")
model ResourceSkuRestrictions {
  @doc("The type of restrictions.")
  @visibility("read")
  type?: ResourceSkuRestrictionsType;

  @doc("""
The value of restrictions. If the restriction type is set to location. This
would be different locations where the SKU is restricted.
""")
  @visibility("read")
  values?: string[];

  @doc("The information about the restriction where the SKU cannot be used.")
  @visibility("read")
  restrictionInfo?: ResourceSkuRestrictionInfo;

  @doc("The reason for restriction.")
  @visibility("read")
  reasonCode?: ResourceSkuRestrictionsReasonCode;
}

@doc("Describes an available Compute SKU Restriction Information.")
model ResourceSkuRestrictionInfo {
  @doc("Locations where the SKU is restricted")
  @visibility("read")
  locations?: string[];

  @doc("List of availability zones where the SKU is restricted.")
  @visibility("read")
  zones?: string[];
}

@doc("Describes the properties of a Shared Image Gallery.")
model GalleryProperties {
  @doc("""
The description of this Shared Image Gallery resource. This property is
updatable.
""")
  description?: string;

  @doc("Describes the gallery unique name.")
  identifier?: GalleryIdentifier;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  @doc("Profile for gallery sharing to subscription or tenant")
  sharingProfile?: SharingProfile;

  @doc("Contains information about the soft deletion policy of the gallery.")
  softDeletePolicy?: SoftDeletePolicy;

  @doc("Sharing status of current gallery.")
  @visibility("read")
  sharingStatus?: SharingStatus;
}

@doc("Describes the gallery unique name.")
model GalleryIdentifier {
  @doc("""
The unique name of the Shared Image Gallery. This name is generated
automatically by Azure.
""")
  @visibility("read")
  uniqueName?: string;
}

@doc("Profile for gallery sharing to subscription or tenant")
model SharingProfile {
  @doc("""
This property allows you to specify the permission of sharing gallery. <br><br>
Possible values are: <br><br> **Private** <br><br> **Groups** <br><br>
**Community**
""")
  permissions?: GallerySharingPermissionTypes;

  @doc("A list of sharing profile groups.")
  @visibility("read")
  groups?: SharingProfileGroup[];

  @doc("Information of community gallery if current gallery is shared to community.")
  communityGalleryInfo?: CommunityGalleryInfo;
}

@doc("Group of the gallery sharing profile")
model SharingProfileGroup {
  @doc("""
This property allows you to specify the type of sharing group. <br><br>
Possible values are: <br><br> **Subscriptions** <br><br> **AADTenants**
""")
  type?: SharingProfileGroupTypes;

  @doc("A list of subscription/tenant ids the gallery is aimed to be shared to.")
  ids?: string[];
}

@doc("Information of community gallery if current gallery is shared to community")
model CommunityGalleryInfo {
  @doc("The link to the publisher website. Visible to all users.")
  publisherUri?: string;

  @doc("""
Community gallery publisher support email. The email address of the publisher.
Visible to all users.
""")
  publisherContact?: string;

  @doc("End-user license agreement for community gallery image.")
  eula?: string;

  @doc("""
The prefix of the gallery name that will be displayed publicly. Visible to all
users.
""")
  publicNamePrefix?: string;

  @doc("Contains info about whether community gallery sharing is enabled.")
  @visibility("read")
  communityGalleryEnabled?: boolean;

  @doc("Community gallery public name list.")
  @visibility("read")
  publicNames?: string[];
}

@doc("Contains information about the soft deletion policy of the gallery.")
model SoftDeletePolicy {
  @doc("""
Enables soft-deletion for resources in this gallery, allowing them to be
recovered within retention time.
""")
  isSoftDeleteEnabled?: boolean;
}

@doc("Sharing status of current gallery.")
model SharingStatus {
  @doc("Aggregated sharing state of current gallery.")
  @visibility("read")
  aggregatedState?: SharingState;

  @doc("Summary of all regional sharing status.")
  summary?: RegionalSharingStatus[];
}

@doc("Gallery regional sharing status")
model RegionalSharingStatus {
  @doc("Region name")
  region?: string;

  @doc("Gallery sharing state in current region")
  @visibility("read")
  state?: SharingState;

  @doc("Details of gallery regional sharing failure.")
  details?: string;
}

@doc("The Update Resource model definition.")
model UpdateResourceDefinition {
  @doc("Resource Id")
  @visibility("read")
  id?: string;

  @doc("Resource name")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Resource tags")
  tags?: Record<string>;
}

@doc("Describes the properties of a gallery image definition.")
model GalleryImageProperties {
  @doc("""
The description of this gallery image definition resource. This property is
updatable.
""")
  description?: string;

  @doc("The Eula agreement for the gallery image definition.")
  eula?: string;

  @doc("The privacy statement uri.")
  privacyStatementUri?: string;

  @doc("The release note uri.")
  releaseNoteUri?: string;

  @doc("""
This property allows you to specify the type of the OS that is included in the
disk when creating a VM from a managed image. <br><br> Possible values are:
<br><br> **Windows** <br><br> **Linux**
""")
  osType: OperatingSystemTypes;

  @doc("""
This property allows the user to specify whether the virtual machines created
under this image are 'Generalized' or 'Specialized'.
""")
  osState: OperatingSystemStateTypes;

  @doc("The hypervisor generation of the Virtual Machine. Applicable to OS disks only.")
  hyperVGeneration?: HyperVGeneration;

  @doc("""
The end of life date of the gallery image definition. This property can be used
for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("This is the gallery image definition identifier.")
  identifier: GalleryImageIdentifier;

  @doc("""
The properties describe the recommended machine configuration for this Image
Definition. These properties are updatable.
""")
  recommended?: RecommendedMachineConfiguration;

  @doc("Describes the disallowed disk types.")
  disallowed?: Disallowed;

  @doc("""
Describes the gallery image definition purchase plan. This is used by
marketplace images.
""")
  purchasePlan?: ImagePurchasePlan;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  @doc("A list of gallery image features.")
  features?: GalleryImageFeature[];

  @doc("The architecture of the image. Applicable to OS disks only.")
  architecture?: Architecture;
}

@doc("This is the gallery image definition identifier.")
model GalleryImageIdentifier {
  @doc("The name of the gallery image definition publisher.")
  publisher: string;

  @doc("The name of the gallery image definition offer.")
  offer: string;

  @doc("The name of the gallery image definition SKU.")
  sku: string;
}

@doc("""
The properties describe the recommended machine configuration for this Image
Definition. These properties are updatable.
""")
model RecommendedMachineConfiguration {
  @doc("Describes the resource range.")
  vCPUs?: ResourceRange;

  @doc("Describes the resource range.")
  memory?: ResourceRange;
}

@doc("Describes the resource range.")
model ResourceRange {
  @doc("The minimum number of the resource.")
  min?: int32;

  @doc("The maximum number of the resource.")
  max?: int32;
}

@doc("Describes the disallowed disk types.")
model Disallowed {
  @doc("A list of disk types.")
  diskTypes?: string[];
}

@doc("""
Describes the gallery image definition purchase plan. This is used by
marketplace images.
""")
model ImagePurchasePlan {
  @doc("The plan ID.")
  name?: string;

  @doc("The publisher ID.")
  publisher?: string;

  @doc("The product ID.")
  product?: string;
}

@doc("A feature for gallery image.")
model GalleryImageFeature {
  @doc("The name of the gallery image feature.")
  name?: string;

  @doc("The value of the gallery image feature.")
  value?: string;
}

@doc("Describes the properties of a gallery image version.")
model GalleryImageVersionProperties {
  @doc("The publishing profile of a gallery image Version.")
  publishingProfile?: GalleryImageVersionPublishingProfile;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  @doc("This is the storage profile of a Gallery Image Version.")
  storageProfile: GalleryImageVersionStorageProfile;

  @doc("This is the safety profile of the Gallery Image Version.")
  safetyProfile?: GalleryImageVersionSafetyProfile;

  @doc("This is the replication status of the gallery image version.")
  @visibility("read")
  replicationStatus?: ReplicationStatus;
}

@doc("The publishing profile of a gallery image Version.")
model GalleryImageVersionPublishingProfile {
  ...GalleryArtifactPublishingProfileBase;
}

@doc("Describes the basic gallery artifact publishing profile.")
model GalleryArtifactPublishingProfileBase {
  @doc("""
The target regions where the Image Version is going to be replicated to. This
property is updatable.
""")
  targetRegions?: TargetRegion[];

  @doc("""
The number of replicas of the Image Version to be created per region. This
property would take effect for a region when regionalReplicaCount is not
specified. This property is updatable.
""")
  replicaCount?: int32;

  @doc("""
If set to true, Virtual Machines deployed from the latest version of the Image
Definition won't use this Image Version.
""")
  excludeFromLatest?: boolean;

  @doc("The timestamp for when the gallery image version is published.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  @doc("""
The end of life date of the gallery image version. This property can be used
for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("""
Specifies the storage account type to be used to store the image. This property
is not updatable.
""")
  storageAccountType?: StorageAccountType;

  @doc("""
Optional parameter which specifies the mode to be used for replication. This
property is not updatable.
""")
  replicationMode?: ReplicationMode;

  @doc("""
The target extended locations where the Image Version is going to be replicated
to. This property is updatable.
""")
  targetExtendedLocations?: GalleryTargetExtendedLocation[];
}

@doc("Describes the target region information.")
model TargetRegion {
  @doc("The name of the region.")
  name: string;

  @doc("""
The number of replicas of the Image Version to be created per region. This
property is updatable.
""")
  regionalReplicaCount?: int32;

  @doc("""
Specifies the storage account type to be used to store the image. This property
is not updatable.
""")
  storageAccountType?: StorageAccountType;

  @doc("""
Optional. Allows users to provide customer managed keys for encrypting the OS
and data disks in the gallery artifact.
""")
  encryption?: EncryptionImages;

  @doc("Contains the flag setting to hide an image when users specify version='latest'")
  excludeFromLatest?: boolean;
}

@doc("""
Optional. Allows users to provide customer managed keys for encrypting the OS
and data disks in the gallery artifact.
""")
model EncryptionImages {
  @doc("Contains encryption settings for an OS disk image.")
  osDiskImage?: OSDiskImageEncryption;

  @doc("A list of encryption specifications for data disk images.")
  dataDiskImages?: DataDiskImageEncryption[];
}

@doc("Contains encryption settings for an OS disk image.")
model OSDiskImageEncryption {
  ...DiskImageEncryption;

  @doc("This property specifies the security profile of an OS disk image.")
  securityProfile?: OSDiskImageSecurityProfile;
}

@doc("Contains security profile for an OS disk image.")
model OSDiskImageSecurityProfile {
  @doc("confidential VM encryption types")
  confidentialVMEncryptionType?: ConfidentialVMEncryptionType;

  @doc("secure VM disk encryption set id")
  secureVMDiskEncryptionSetId?: string;
}

@doc("This is the disk image encryption base class.")
model DiskImageEncryption {
  @doc("A relative URI containing the resource ID of the disk encryption set.")
  diskEncryptionSetId?: string;
}

@doc("Contains encryption settings for a data disk image.")
model DataDiskImageEncryption {
  ...DiskImageEncryption;

  @doc("""
This property specifies the logical unit number of the data disk. This value is
used to identify data disks within the Virtual Machine and therefore must be
unique for each data disk attached to the Virtual Machine.
""")
  lun: int32;
}

model GalleryTargetExtendedLocation {
  @doc("The name of the region.")
  name?: string;

  @doc("The name of the extended location.")
  extendedLocation?: GalleryExtendedLocation;

  @doc("""
The number of replicas of the Image Version to be created per extended
location. This property is updatable.
""")
  extendedLocationReplicaCount?: int32;

  @doc("""
Specifies the storage account type to be used to store the image. This property
is not updatable.
""")
  storageAccountType?: EdgeZoneStorageAccountType;

  @doc("""
Optional. Allows users to provide customer managed keys for encrypting the OS
and data disks in the gallery artifact.
""")
  encryption?: EncryptionImages;
}

@doc("The name of the extended location.")
model GalleryExtendedLocation {
  name?: string;

  @doc("It is type of the extended location.")
  type?: GalleryExtendedLocationType;
}

@doc("This is the storage profile of a Gallery Image Version.")
model GalleryImageVersionStorageProfile {
  @doc("The source of the gallery artifact version.")
  source?: GalleryArtifactVersionFullSource;

  @doc("This is the OS disk image.")
  osDiskImage?: GalleryOSDiskImage;

  @doc("A list of data disk images.")
  dataDiskImages?: GalleryDataDiskImage[];
}

@doc("The source of the gallery artifact version.")
model GalleryArtifactVersionFullSource {
  ...GalleryArtifactVersionSource;

  @doc("""
The resource Id of the source Community Gallery Image.  Only required when
using Community Gallery Image as a source.
""")
  communityGalleryImageId?: string;
}

@doc("The gallery artifact version source.")
model GalleryArtifactVersionSource {
  @doc("""
The id of the gallery artifact version source. Can specify a disk uri, snapshot
uri, user image or storage account resource.
""")
  id?: string;
}

@doc("This is the OS disk image.")
model GalleryOSDiskImage {
  ...GalleryDiskImage;
}

@doc("This is the disk image base class.")
model GalleryDiskImage {
  @doc("This property indicates the size of the VHD to be created.")
  @visibility("read")
  sizeInGB?: int32;

  @doc("""
The host caching of the disk. Valid values are 'None', 'ReadOnly', and
'ReadWrite'
""")
  hostCaching?: HostCaching;

  @doc("The source for the disk image.")
  source?: GalleryDiskImageSource;
}

@doc("The source for the disk image.")
model GalleryDiskImageSource {
  ...GalleryArtifactVersionSource;

  @doc("""
The uri of the gallery artifact version source. Currently used to specify
vhd/blob source.
""")
  uri?: string;

  @doc("""
The Storage Account Id that contains the vhd blob being used as a source for
this artifact version.
""")
  storageAccountId?: string;
}

@doc("This is the data disk image.")
model GalleryDataDiskImage {
  ...GalleryDiskImage;

  @doc("""
This property specifies the logical unit number of the data disk. This value is
used to identify data disks within the Virtual Machine and therefore must be
unique for each data disk attached to the Virtual Machine.
""")
  lun: int32;
}

@doc("This is the safety profile of the Gallery Image Version.")
model GalleryImageVersionSafetyProfile {
  ...GalleryArtifactSafetyProfileBase;

  @doc("""
Indicates whether this image has been reported as violating Microsoft's
policies.
""")
  @visibility("read")
  reportedForPolicyViolation?: boolean;

  @doc("""
A list of Policy Violations that have been reported for this Gallery Image
Version.
""")
  @visibility("read")
  policyViolations?: PolicyViolation[];
}

@doc("A policy violation reported against a gallery artifact.")
model PolicyViolation {
  @doc("Describes the nature of the policy violation.")
  category?: PolicyViolationCategory;

  @doc("Describes specific details about why this policy violation was reported.")
  details?: string;
}

@doc("This is the safety profile of the Gallery Artifact Version.")
model GalleryArtifactSafetyProfileBase {
  @doc("""
Indicates whether or not removing this Gallery Image Version from replicated
regions is allowed.
""")
  allowDeletionOfReplicatedLocations?: boolean;
}

@doc("This is the replication status of the gallery image version.")
model ReplicationStatus {
  @doc("""
This is the aggregated replication status based on all the regional replication
status flags.
""")
  @visibility("read")
  aggregatedState?: AggregatedReplicationState;

  @doc("This is a summary of replication status for each region.")
  @visibility("read")
  summary?: RegionalReplicationStatus[];
}

@doc("This is the regional replication status.")
model RegionalReplicationStatus {
  @doc("The region to which the gallery image version is being replicated to.")
  @visibility("read")
  region?: string;

  @doc("This is the regional replication state.")
  @visibility("read")
  state?: ReplicationState;

  @doc("The details of the replication status.")
  @visibility("read")
  details?: string;

  @doc("It indicates progress of the replication job.")
  @visibility("read")
  progress?: int32;
}

@doc("Describes the properties of a gallery Application Definition.")
model GalleryApplicationProperties {
  @doc("""
The description of this gallery Application Definition resource. This property
is updatable.
""")
  description?: string;

  @doc("The Eula agreement for the gallery Application Definition.")
  eula?: string;

  @doc("The privacy statement uri.")
  privacyStatementUri?: string;

  @doc("The release note uri.")
  releaseNoteUri?: string;

  @doc("""
The end of life date of the gallery Application Definition. This property can
be used for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("""
This property allows you to specify the supported type of the OS that
application is built for. <br><br> Possible values are: <br><br> **Windows**
<br><br> **Linux**
""")
  supportedOSType: OperatingSystemTypes;

  @doc("""
A list of custom actions that can be performed with all of the Gallery
Application Versions within this Gallery Application.
""")
  customActions?: GalleryApplicationCustomAction[];
}

@doc("A custom action that can be performed with a Gallery Application Version.")
model GalleryApplicationCustomAction {
  @doc("""
The name of the custom action.  Must be unique within the Gallery Application
Version.
""")
  name: string;

  @doc("The script to run when executing this custom action.")
  script: string;

  @doc("Description to help the users understand what this custom action does.")
  description?: string;

  @doc("The parameters that this custom action uses")
  parameters?: GalleryApplicationCustomActionParameter[];
}

@doc("""
The definition of a parameter that can be passed to a custom action of a
Gallery Application Version.
""")
model GalleryApplicationCustomActionParameter {
  @doc("""
The name of the custom action.  Must be unique within the Gallery Application
Version.
""")
  name: string;

  @doc("Indicates whether this parameter must be passed when running the custom action.")
  required?: boolean;

  @doc("""
Specifies the type of the custom action parameter. Possible values are: String,
ConfigurationDataBlob or LogOutputBlob
""")
  type?: GalleryApplicationCustomActionParameterType;

  @doc("The default value of the parameter.  Only applies to string types")
  defaultValue?: string;

  @doc("A description to help users understand what this parameter means")
  description?: string;
}

@doc("Describes the properties of a gallery image version.")
model GalleryApplicationVersionProperties {
  @doc("The publishing profile of a gallery image version.")
  publishingProfile: GalleryApplicationVersionPublishingProfile;

  @doc("The safety profile of the Gallery Application Version.")
  safetyProfile?: GalleryApplicationVersionSafetyProfile;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  @doc("This is the replication status of the gallery image version.")
  @visibility("read")
  replicationStatus?: ReplicationStatus;
}

@doc("The publishing profile of a gallery image version.")
model GalleryApplicationVersionPublishingProfile {
  ...GalleryArtifactPublishingProfileBase;

  @doc("The source image from which the Image Version is going to be created.")
  source: UserArtifactSource;

  manageActions?: UserArtifactManage;

  @doc("""
Additional settings for the VM app that contains the target package and config
file name when it is deployed to target VM or VM scale set.
""")
  settings?: UserArtifactSettings;

  @doc("""
Optional. Additional settings to pass to the vm-application-manager extension.
For advanced use only.
""")
  advancedSettings?: Record<string>;

  @doc("Optional. Whether or not this application reports health.")
  enableHealthCheck?: boolean;

  @doc("""
A list of custom actions that can be performed with this Gallery Application
Version.
""")
  customActions?: GalleryApplicationCustomAction[];
}

@doc("The source image from which the Image Version is going to be created.")
model UserArtifactSource {
  @doc("Required. The mediaLink of the artifact, must be a readable storage page blob.")
  mediaLink: string;

  @doc("""
Optional. The defaultConfigurationLink of the artifact, must be a readable
storage page blob.
""")
  defaultConfigurationLink?: string;
}

model UserArtifactManage {
  @doc("""
Required. The path and arguments to install the gallery application. This is
limited to 4096 characters.
""")
  install: string;

  @doc("""
Required. The path and arguments to remove the gallery application. This is
limited to 4096 characters.
""")
  remove: string;

  @doc("""
Optional. The path and arguments to update the gallery application. If not
present, then update operation will invoke remove command on the previous
version and install command on the current version of the gallery application.
This is limited to 4096 characters.
""")
  update?: string;
}

@doc("""
Additional settings for the VM app that contains the target package and config
file name when it is deployed to target VM or VM scale set.
""")
model UserArtifactSettings {
  @doc("""
Optional. The name to assign the downloaded package file on the VM. This is
limited to 4096 characters. If not specified, the package file will be named
the same as the Gallery Application name.
""")
  packageFileName?: string;

  @doc("""
Optional. The name to assign the downloaded config file on the VM. This is
limited to 4096 characters. If not specified, the config file will be named the
Gallery Application name appended with \"_config\".
""")
  configFileName?: string;
}

@doc("The safety profile of the Gallery Application Version.")
model GalleryApplicationVersionSafetyProfile {
  ...GalleryArtifactSafetyProfileBase;
}

@doc("Specifies information about the gallery sharing profile update.")
model SharingUpdate {
  @doc("""
This property allows you to specify the operation type of gallery sharing
update. <br><br> Possible values are: <br><br> **Add** <br><br> **Remove**
<br><br> **Reset**
""")
  operationType: SharingUpdateOperationTypes;

  @doc("A list of sharing profile groups.")
  groups?: SharingProfileGroup[];
}

@doc("Base information about the shared gallery resource in pir.")
model PirSharedGalleryResource {
  ...PirResource;

  @doc("The identifier information of shared gallery.")
  identifier?: SharedGalleryIdentifier;
}

@doc("The identifier information of shared gallery.")
model SharedGalleryIdentifier {
  @doc("The unique id of this shared gallery.")
  uniqueId?: string;
}

@doc("The Resource model definition.")
model PirResource {
  @doc("Resource name")
  @visibility("read")
  name?: string;

  @doc("Resource location")
  @visibility("read")
  location?: string;
}

@doc("Describes the properties of a gallery image definition.")
model SharedGalleryImageProperties {
  @doc("""
This property allows you to specify the type of the OS that is included in the
disk when creating a VM from a managed image. <br><br> Possible values are:
<br><br> **Windows** <br><br> **Linux**
""")
  osType: OperatingSystemTypes;

  @doc("""
This property allows the user to specify whether the virtual machines created
under this image are 'Generalized' or 'Specialized'.
""")
  osState: OperatingSystemStateTypes;

  @doc("""
The end of life date of the gallery image definition. This property can be used
for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("This is the gallery image definition identifier.")
  identifier: GalleryImageIdentifier;

  @doc("""
The properties describe the recommended machine configuration for this Image
Definition. These properties are updatable.
""")
  recommended?: RecommendedMachineConfiguration;

  @doc("Describes the disallowed disk types.")
  disallowed?: Disallowed;

  @doc("The hypervisor generation of the Virtual Machine. Applicable to OS disks only.")
  hyperVGeneration?: HyperVGeneration;

  @doc("A list of gallery image features.")
  features?: GalleryImageFeature[];

  @doc("""
Describes the gallery image definition purchase plan. This is used by
marketplace images.
""")
  purchasePlan?: ImagePurchasePlan;

  @doc("The architecture of the image. Applicable to OS disks only.")
  architecture?: Architecture;

  @doc("Privacy statement uri for the current community gallery image.")
  privacyStatementUri?: string;

  @doc("End-user license agreement for the current community gallery image.")
  eula?: string;
}

@doc("Describes the properties of a gallery image version.")
model SharedGalleryImageVersionProperties {
  @doc("""
The published date of the gallery image version Definition. This property can
be used for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  @doc("""
The end of life date of the gallery image version Definition. This property can
be used for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("""
If set to true, Virtual Machines deployed from the latest version of the Image
Definition won't use this Image Version.
""")
  excludeFromLatest?: boolean;

  @doc("Describes the storage profile of the image version.")
  storageProfile?: SharedGalleryImageVersionStorageProfile;
}

@doc("This is the storage profile of a Gallery Image Version.")
model SharedGalleryImageVersionStorageProfile {
  @doc("This is the OS disk image.")
  osDiskImage?: SharedGalleryOSDiskImage;

  @doc("A list of data disk images.")
  dataDiskImages?: SharedGalleryDataDiskImage[];
}

@doc("This is the OS disk image.")
model SharedGalleryOSDiskImage {
  ...SharedGalleryDiskImage;
}

@doc("This is the disk image base class.")
model SharedGalleryDiskImage {
  @doc("This property indicates the size of the VHD to be created.")
  @visibility("read")
  diskSizeGB?: int32;

  @doc("""
The host caching of the disk. Valid values are 'None', 'ReadOnly', and
'ReadWrite'
""")
  hostCaching?: SharedGalleryHostCaching;
}

@doc("This is the data disk image.")
model SharedGalleryDataDiskImage {
  ...SharedGalleryDiskImage;

  @doc("""
This property specifies the logical unit number of the data disk. This value is
used to identify data disks within the Virtual Machine and therefore must be
unique for each data disk attached to the Virtual Machine.
""")
  lun: int32;
}

@doc("Base information about the community gallery resource in pir.")
model PirCommunityGalleryResource {
  @doc("Resource name")
  @visibility("read")
  name?: string;

  @doc("Resource location")
  @visibility("read")
  location?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("The identifier information of community gallery.")
  identifier?: CommunityGalleryIdentifier;
}

@doc("The identifier information of community gallery.")
model CommunityGalleryIdentifier {
  @doc("The unique id of this community gallery.")
  uniqueId?: string;
}

@doc("Describes the properties of a gallery image definition.")
model CommunityGalleryImageProperties {
  @doc("""
This property allows you to specify the type of the OS that is included in the
disk when creating a VM from a managed image. <br><br> Possible values are:
<br><br> **Windows** <br><br> **Linux**
""")
  osType: OperatingSystemTypes;

  @doc("""
This property allows the user to specify whether the virtual machines created
under this image are 'Generalized' or 'Specialized'.
""")
  osState: OperatingSystemStateTypes;

  @doc("""
The end of life date of the gallery image definition. This property can be used
for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("This is the community gallery image definition identifier.")
  identifier: CommunityGalleryImageIdentifier;

  @doc("""
The properties describe the recommended machine configuration for this Image
Definition. These properties are updatable.
""")
  recommended?: RecommendedMachineConfiguration;

  @doc("Describes the disallowed disk types.")
  disallowed?: Disallowed;

  @doc("The hypervisor generation of the Virtual Machine. Applicable to OS disks only.")
  hyperVGeneration?: HyperVGeneration;

  @doc("A list of gallery image features.")
  features?: GalleryImageFeature[];

  @doc("""
Describes the gallery image definition purchase plan. This is used by
marketplace images.
""")
  purchasePlan?: ImagePurchasePlan;

  @doc("The architecture of the image. Applicable to OS disks only.")
  architecture?: Architecture;

  @doc("Privacy statement uri for the current community gallery image.")
  privacyStatementUri?: string;

  @doc("End-user license agreement for the current community gallery image.")
  eula?: string;
}

@doc("This is the community gallery image definition identifier.")
model CommunityGalleryImageIdentifier {
  @doc("The name of the gallery image definition publisher.")
  publisher?: string;

  @doc("The name of the gallery image definition offer.")
  offer?: string;

  @doc("The name of the gallery image definition SKU.")
  sku?: string;
}

@doc("Describes the properties of a gallery image version.")
model CommunityGalleryImageVersionProperties {
  @doc("""
The published date of the gallery image version Definition. This property can
be used for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  @doc("""
The end of life date of the gallery image version Definition. This property can
be used for decommissioning purposes. This property is updatable.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  @doc("""
If set to true, Virtual Machines deployed from the latest version of the Image
Definition won't use this Image Version.
""")
  excludeFromLatest?: boolean;

  @doc("Describes the storage profile of the image version.")
  storageProfile?: SharedGalleryImageVersionStorageProfile;
}

@doc("The role instance SKU.")
model InstanceSku {
  @doc("The sku name.")
  @visibility("read")
  name?: string;

  @doc("The tier of the cloud service role instance.")
  @visibility("read")
  tier?: string;
}

@doc("Role instance properties.")
model RoleInstanceProperties {
  @doc("Describes the network profile for the role instance.")
  networkProfile?: RoleInstanceNetworkProfile;

  @doc("The instance view of the role instance.")
  instanceView?: RoleInstanceInstanceView;
}

@doc("Describes the network profile for the role instance.")
model RoleInstanceNetworkProfile {
  @doc("""
Specifies the list of resource Ids for the network interfaces associated with
the role instance.
""")
  @visibility("read")
  networkInterfaces?: SubResource[];
}

@doc("The instance view of the role instance.")
model RoleInstanceInstanceView {
  @doc("The Update Domain.")
  @visibility("read")
  platformUpdateDomain?: int32;

  @doc("The Fault Domain.")
  @visibility("read")
  platformFaultDomain?: int32;

  @doc("""
Specifies a unique identifier generated internally for the cloud service
associated with this role instance. <br /><br /> NOTE: If you are using Azure
Diagnostics extension, this property can be used as 'DeploymentId' for querying
details.
""")
  @visibility("read")
  privateId?: string;

  @visibility("read")
  statuses?: ResourceInstanceViewStatus[];
}

@doc("Instance view status.")
model ResourceInstanceViewStatus {
  @doc("The status code.")
  @visibility("read")
  code?: string;

  @doc("The short localizable label for the status.")
  @visibility("read")
  displayStatus?: string;

  @doc("The detailed status message, including for alerts and error messages.")
  @visibility("read")
  message?: string;

  @doc("The time of the status.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  time?: utcDateTime;

  @doc("The level code.")
  level?: StatusLevelTypes;
}

@doc("Describes the cloud service role sku.")
model CloudServiceRoleSku {
  @doc("""
The sku name. NOTE: If the new SKU is not supported on the hardware the cloud
service is currently on, you need to delete and recreate the cloud service or
move back to the old sku.
""")
  name?: string;

  @doc("""
Specifies the tier of the cloud service. Possible Values are <br /><br />
**Standard** <br /><br /> **Basic**
""")
  tier?: string;

  @doc("Specifies the number of role instances in the cloud service.")
  capacity?: int32;
}

@doc("The cloud service role properties.")
model CloudServiceRoleProperties {
  @doc("Specifies the ID which uniquely identifies a cloud service role.")
  @visibility("read")
  uniqueId?: string;
}

@doc("Cloud service properties")
model CloudServiceProperties {
  @doc("""
Specifies a URL that refers to the location of the service package in the Blob
service. The service package URL can be Shared Access Signature (SAS) URI from
any storage account.
This is a write-only property and is not returned in GET
calls.
""")
  packageUrl?: string;

  @doc("Specifies the XML service configuration (.cscfg) for the cloud service.")
  configuration?: string;

  @doc("""
Specifies a URL that refers to the location of the service configuration in the
Blob service. The service package URL  can be Shared Access Signature (SAS) URI
from any storage account.
This is a write-only property and is not returned in
GET calls.
""")
  configurationUrl?: string;

  @doc("""
(Optional) Indicates whether to start the cloud service immediately after it is
created. The default value is `true`.
If false, the service model is still
deployed, but the code is not run immediately. Instead, the service is
PoweredOff until you call Start, at which time the service will be started. A
deployed service still incurs charges, even if it is poweredoff.
""")
  startCloudService?: boolean;

  @doc("""
(Optional) Indicates whether the role sku properties (roleProfile.roles.sku)
specified in the model/template should override the role instance count and vm
size specified in the .cscfg and .csdef respectively.
The default value is
`false`.
""")
  allowModelOverride?: boolean;

  @doc("""
Update mode for the cloud service. Role instances are allocated to update
domains when the service is deployed. Updates can be initiated manually in each
update domain or initiated automatically in all update domains.
Possible Values
are <br /><br />**Auto**<br /><br />**Manual** <br /><br />**Simultaneous**<br
/><br />
If not specified, the default value is Auto. If set to Manual, PUT
UpdateDomain must be called to apply the update. If set to Auto, the update is
automatically applied to each update domain in sequence.
""")
  upgradeMode?: CloudServiceUpgradeMode;

  @doc("Describes the role profile for the cloud service.")
  roleProfile?: CloudServiceRoleProfile;

  @doc("Describes the OS profile for the cloud service.")
  osProfile?: CloudServiceOsProfile;

  @doc("Network Profile for the cloud service.")
  networkProfile?: CloudServiceNetworkProfile;

  @doc("Describes a cloud service extension profile.")
  extensionProfile?: CloudServiceExtensionProfile;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("The unique identifier for the cloud service.")
  @visibility("read")
  uniqueId?: string;
}

@doc("Describes the role profile for the cloud service.")
model CloudServiceRoleProfile {
  @doc("List of roles for the cloud service.")
  roles?: CloudServiceRoleProfileProperties[];
}

@doc("Describes the role properties.")
model CloudServiceRoleProfileProperties {
  @doc("Resource name.")
  name?: string;

  @doc("Describes the cloud service role sku.")
  sku?: CloudServiceRoleSku;
}

@doc("Describes the OS profile for the cloud service.")
model CloudServiceOsProfile {
  @doc("Specifies set of certificates that should be installed onto the role instances.")
  secrets?: CloudServiceVaultSecretGroup[];
}

@doc("Describes a set of certificates which are all in the same Key Vault.")
model CloudServiceVaultSecretGroup {
  @doc("""
The relative URL of the Key Vault containing all of the certificates in
VaultCertificates.
""")
  sourceVault?: SubResource;

  @doc("The list of key vault references in SourceVault which contain certificates.")
  vaultCertificates?: CloudServiceVaultCertificate[];
}

@doc("""
Describes a single certificate reference in a Key Vault, and where the
certificate should reside on the role instance.
""")
model CloudServiceVaultCertificate {
  @doc("""
This is the URL of a certificate that has been uploaded to Key Vault as a
secret.
""")
  certificateUrl?: string;
}

@doc("Network Profile for the cloud service.")
model CloudServiceNetworkProfile {
  @doc("""
List of Load balancer configurations. Cloud service can have up to two load
balancer configurations, corresponding to a Public Load Balancer and an
Internal Load Balancer.
""")
  loadBalancerConfigurations?: LoadBalancerConfiguration[];

  @doc("""
Slot type for the cloud service.
Possible values are <br /><br
/>**Production**<br /><br />**Staging**<br /><br />
If not specified, the
default value is Production.
""")
  slotType?: CloudServiceSlotType;

  @doc("""
The id reference of the cloud service containing the target IP with which the
subject cloud service can perform a swap. This property cannot be updated once
it is set. The swappable cloud service referred by this id must be present
otherwise an error will be thrown.
""")
  swappableCloudService?: SubResource;
}

@doc("Describes the load balancer configuration.")
model LoadBalancerConfiguration {
  @doc("Resource Id")
  id?: string;

  @doc("The name of the Load balancer")
  name: string;

  @doc("Properties of the load balancer configuration.")
  properties: LoadBalancerConfigurationProperties;
}

@doc("Describes the properties of the load balancer configuration.")
model LoadBalancerConfigurationProperties {
  @doc("""
Specifies the frontend IP to be used for the load balancer. Only IPv4 frontend
IP address is supported. Each load balancer configuration must have exactly one
frontend IP configuration.
""")
  frontendIpConfigurations: LoadBalancerFrontendIpConfiguration[];
}

@doc("""
Specifies the frontend IP to be used for the load balancer. Only IPv4 frontend
IP address is supported. Each load balancer configuration must have exactly one
frontend IP configuration.
""")
model LoadBalancerFrontendIpConfiguration {
  @doc("""
The name of the resource that is unique within the set of frontend IP
configurations used by the load balancer. This name can be used to access the
resource.
""")
  name: string;

  @doc("Properties of load balancer frontend ip configuration.")
  properties: LoadBalancerFrontendIpConfigurationProperties;
}

@doc("Describes a cloud service IP Configuration")
model LoadBalancerFrontendIpConfigurationProperties {
  @doc("The reference to the public ip address resource.")
  publicIPAddress?: SubResource;

  @doc("The reference to the virtual network subnet resource.")
  subnet?: SubResource;

  @doc("The virtual network private IP address of the IP configuration.")
  privateIPAddress?: string;
}

@doc("Describes a cloud service extension profile.")
model CloudServiceExtensionProfile {
  @doc("List of extensions for the cloud service.")
  extensions?: Extension[];
}

@doc("Describes a cloud service Extension.")
model Extension {
  @doc("The name of the extension.")
  name?: string;

  @doc("Extension Properties.")
  properties?: CloudServiceExtensionProperties;
}

@doc("Extension Properties.")
model CloudServiceExtensionProperties {
  @doc("The name of the extension handler publisher.")
  publisher?: string;

  @doc("Specifies the type of the extension.")
  type?: string;

  @doc("""
Specifies the version of the extension. Specifies the version of the extension.
If this element is not specified or an asterisk (*) is used as the value, the
latest version of the extension is used. If the value is specified with a major
version number and an asterisk as the minor version number (X.), the latest
minor version of the specified major version is selected. If a major version
number and a minor version number are specified (X.Y), the specific extension
version is selected. If a version is specified, an auto-upgrade is performed on
the role instance.
""")
  typeHandlerVersion?: string;

  @doc("""
Explicitly specify whether platform can automatically upgrade
typeHandlerVersion to higher minor versions when they become available.
""")
  autoUpgradeMinorVersion?: boolean;

  @doc("""
Public settings for the extension. For JSON extensions, this is the JSON
settings for the extension. For XML Extension (like RDP), this is the XML
setting for the extension.
""")
  settings?: Record<unknown>;

  @doc("""
Protected settings for the extension which are encrypted before sent to the
role instance.
""")
  protectedSettings?: Record<unknown>;

  @doc("""
Protected settings for the extension, referenced using KeyVault which are
encrypted before sent to the role instance.
""")
  protectedSettingsFromKeyVault?: CloudServiceVaultAndSecretReference;

  @doc("""
Tag to force apply the provided public and protected settings.
Changing the tag
value allows for re-running the extension without changing any of the public or
protected settings.
If forceUpdateTag is not changed, updates to public or
protected settings would still be applied by the handler.
If neither
forceUpdateTag nor any of public or protected settings change, extension would
flow to the role instance with the same sequence-number, and
it is up to
handler implementation whether to re-run it or not
""")
  forceUpdateTag?: string;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("""
Optional list of roles to apply this extension. If property is not specified or
'*' is specified, extension is applied to all roles in the cloud service.
""")
  rolesAppliedTo?: string[];
}

@doc("""
Protected settings for the extension, referenced using KeyVault which are
encrypted before sent to the role instance.
""")
model CloudServiceVaultAndSecretReference {
  @doc("The ARM Resource ID of the Key Vault")
  sourceVault?: SubResource;

  @doc("Secret URL which contains the protected settings of the extension")
  secretUrl?: string;
}

@doc("InstanceView of CloudService as a whole")
model CloudServiceInstanceView {
  @doc("Instance view statuses.")
  roleInstance?: InstanceViewStatusesSummary;

  @doc("""
The version of the SDK that was used to generate the package for the cloud
service.
""")
  @visibility("read")
  sdkVersion?: string;

  @doc("""
Specifies a list of unique identifiers generated internally for the cloud
service. <br /><br /> NOTE: If you are using Azure Diagnostics extension, this
property can be used as 'DeploymentId' for querying details.
""")
  @visibility("read")
  privateIds?: string[];

  @visibility("read")
  statuses?: ResourceInstanceViewStatus[];
}

@doc("Instance view statuses.")
model InstanceViewStatusesSummary {
  @doc("The summary.")
  @visibility("read")
  statusesSummary?: StatusCodeCount[];
}

@doc("The status code and count of the cloud service instance view statuses")
model StatusCodeCount {
  @doc("The instance view status code")
  @visibility("read")
  code?: string;

  @doc("Number of instances having this status code")
  @visibility("read")
  count?: int32;
}

@doc("Specifies a list of role instances from the cloud service.")
model RoleInstances {
  @doc("""
List of cloud service role instance names. Value of '*' will signify all role
instances of the cloud service.
""")
  roleInstances: string[];
}

@doc("Defines an update domain for the cloud service.")
model UpdateDomain {
  @doc("Resource Id")
  @visibility("read")
  id?: string;

  @doc("Resource Name")
  @visibility("read")
  name?: string;
}

@doc("The list operation result.")
model UpdateDomainListResult is Azure.Core.Page<UpdateDomain>;

@doc("OS version properties.")
model OSVersionProperties {
  @doc("The family of this OS version.")
  @visibility("read")
  family?: string;

  @doc("The family label of this OS version.")
  @visibility("read")
  familyLabel?: string;

  @doc("The OS version.")
  @visibility("read")
  version?: string;

  @doc("The OS version label.")
  @visibility("read")
  label?: string;

  @doc("Specifies whether this is the default OS version for its family.")
  @visibility("read")
  isDefault?: boolean;

  @doc("Specifies whether this OS version is active.")
  @visibility("read")
  isActive?: boolean;
}

@doc("OS family properties.")
model OSFamilyProperties {
  @doc("The OS family name.")
  @visibility("read")
  name?: string;

  @doc("The OS family label.")
  @visibility("read")
  label?: string;

  @doc("List of OS versions belonging to this family.")
  @visibility("read")
  versions?: OSVersionPropertiesBase[];
}

@doc("Configuration view of an OS version.")
model OSVersionPropertiesBase {
  @doc("The OS version.")
  @visibility("read")
  version?: string;

  @doc("The OS version label.")
  @visibility("read")
  label?: string;

  @doc("Specifies whether this is the default OS version for its family.")
  @visibility("read")
  isDefault?: boolean;

  @doc("Specifies whether this OS version is active.")
  @visibility("read")
  isActive?: boolean;
}

@doc("The source image from which the Image Version is going to be created.")
model GalleryArtifactSource {
  @doc("The managed artifact.")
  managedImage: ManagedArtifact;
}

@doc("The managed artifact.")
model ManagedArtifact {
  @doc("The managed artifact id.")
  id: string;
}

@doc("The gallery image version with latest version in a particular region.")
model LatestGalleryImageVersion {
  @doc("The name of the latest version in the region.")
  latestVersionName?: string;

  @doc("region of the Gallery Image Version.")
  location?: string;
}
