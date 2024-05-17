import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Compute;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * Type of repair action (replace, restart, reimage) that will be used for repairing unhealthy virtual machines in the scale set. Default value is replace.
 */
enum RepairAction {
  Replace,
  Restart,
  Reimage,
}

/**
 * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **Manual** - You  control the application of patches to a virtual machine. You do this by applying patches manually inside the VM. In this mode, automatic updates are disabled; the property WindowsConfiguration.enableAutomaticUpdates must be false<br /><br /> **AutomaticByOS** - The virtual machine will automatically be updated by the OS. The property WindowsConfiguration.enableAutomaticUpdates must be true. <br /><br /> **AutomaticByPlatform** - the virtual machine will automatically updated by the platform. The properties provisionVMAgent and WindowsConfiguration.enableAutomaticUpdates must be true
 */
enum WindowsVMGuestPatchMode {
  Manual,
  AutomaticByOS,
  AutomaticByPlatform,
}

/**
 * Specifies the mode of VM Guest patch assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine.<br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
 */
enum WindowsPatchAssessmentMode {
  ImageDefault,
  AutomaticByPlatform,
}

/**
 * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
 */
enum WindowsVMGuestPatchAutomaticByPlatformRebootSetting {
  Unknown,
  IfRequired,
  Never,
  Always,
}

/**
 * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - The virtual machine's default patching configuration is used. <br /><br /> **AutomaticByPlatform** - The virtual machine will be automatically updated by the platform. The property provisionVMAgent must be true
 */
enum LinuxVMGuestPatchMode {
  ImageDefault,
  AutomaticByPlatform,
}

/**
 * Specifies the mode of VM Guest Patch Assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine. <br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
 */
enum LinuxPatchAssessmentMode {
  ImageDefault,
  AutomaticByPlatform,
}

/**
 * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
 */
enum LinuxVMGuestPatchAutomaticByPlatformRebootSetting {
  Unknown,
  IfRequired,
  Never,
  Always,
}

/**
 * Specifies how the virtual machine should be created. Possible values are: **Attach.** This value is used when you are using a specialized disk to create the virtual machine. **FromImage.** This value is used when you are using an image to create the virtual machine. If you are using a platform image, you also use the imageReference element described above. If you are using a marketplace image, you also use the plan element previously described.
 */
enum DiskCreateOptionTypes {
  FromImage,
  Empty,
  Attach,
}

/**
 * Specifies the ephemeral disk option for operating system disk.
 */
enum DiffDiskOptions {
  Local,
}

/**
 * Specifies the ephemeral disk placement for operating system disk. This property can be used by user in the request to choose the location i.e, cache disk or resource disk space for Ephemeral OS disk provisioning. For more information on Ephemeral OS disk size requirements, please refer Ephemeral OS disk size requirements for Windows VM at https://docs.microsoft.com/azure/virtual-machines/windows/ephemeral-os-disks#size-requirements and Linux VM at https://docs.microsoft.com/azure/virtual-machines/linux/ephemeral-os-disks#size-requirements
 */
enum DiffDiskPlacement {
  CacheDisk,
  ResourceDisk,
}

/**
 * Specifies the storage account type for the managed disk. Managed OS disk storage account type can only be set when you create the scale set. NOTE: UltraSSD_LRS can only be used with data disks. It cannot be used with OS Disk. Standard_LRS uses Standard HDD. StandardSSD_LRS uses Standard SSD. Premium_LRS uses Premium SSD. UltraSSD_LRS uses Ultra disk. Premium_ZRS uses Premium SSD zone redundant storage. StandardSSD_ZRS uses Standard SSD zone redundant storage. For more information regarding disks supported for Windows Virtual Machines, refer to https://docs.microsoft.com/azure/virtual-machines/windows/disks-types and, for Linux Virtual Machines, refer to https://docs.microsoft.com/azure/virtual-machines/linux/disks-types
 */
enum StorageAccountTypes {
  Standard_LRS,
  Premium_LRS,
  StandardSSD_LRS,
  UltraSSD_LRS,
  Premium_ZRS,
  StandardSSD_ZRS,
  PremiumV2_LRS,
}

/**
 * Specifies the EncryptionType of the managed disk. It is set to DiskWithVMGuestState for encryption of the managed disk along with VMGuestState blob, and VMGuestStateOnly for encryption of just the VMGuestState blob. **Note:** It can be set for only Confidential VMs.
 */
enum SecurityEncryptionTypes {
  VMGuestStateOnly,
  DiskWithVMGuestState,
}

/**
 * Specifies the behavior of the managed disk when the VM gets deleted, for example whether the managed disk is deleted or detached. Supported values are: **Delete.** If this value is used, the managed disk is deleted when VM gets deleted. **Detach.** If this value is used, the managed disk is retained after VM gets deleted. Minimum api-version: 2021-03-01.
 */
enum DiskDeleteOptionTypes {
  Delete,
  Detach,
}

/**
 * The Domain name label scope.The concatenation of the hashed domain name label that generated according to the policy from domain name label scope and vm index will be the domain name labels of the PublicIPAddress resources that will be created
 */
enum DomainNameLabelScopeTypes {
  TenantReuse,
  SubscriptionReuse,
  ResourceGroupReuse,
  NoReuse,
}

/**
 * Available from Api-Version 2017-03-30 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible values are: 'IPv4' and 'IPv6'.
 */
enum IPVersion {
  IPv4,
  IPv6,
}

/**
 * Specify what happens to the network interface when the VM is deleted
 */
enum DeleteOptions {
  Delete,
  Detach,
}

/**
 * Specify public IP sku name
 */
enum PublicIPAddressSkuName {
  Basic,
  Standard,
}

/**
 * Specify public IP sku tier
 */
enum PublicIPAddressSkuTier {
  Regional,
  Global,
}

/**
 * Specifies whether the Auxiliary mode is enabled for the Network Interface resource.
 */
enum NetworkInterfaceAuxiliaryMode {
  None,
  AcceleratedConnections,
  Floating,
}

/**
 * Specifies whether the Auxiliary sku is enabled for the Network Interface resource.
 */
enum NetworkInterfaceAuxiliarySku {
  None,
  A1,
  A2,
  A4,
  A8,
}

/**
 * specifies the Microsoft.Network API version used when creating networking resources in the Network Interface Configurations
 */
enum NetworkApiVersion {
  `2020-11-01`,
}

/**
 * Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set.
 */
enum SecurityTypes {
  TrustedLaunch,
  ConfidentialVM,
}

/**
 * Specifies the priority for a standalone virtual machine or the virtual machines in the scale set. 'Low' enum will be deprecated in the future, please use 'Spot' as the enum to deploy Azure Spot VM/VMSS.
 */
enum VirtualMachinePriorityTypes {
  Regular,
  Low,
  Spot,
}

/**
 * Specifies the eviction policy for the Azure Spot VM/VMSS
 */
enum VirtualMachineEvictionPolicyTypes {
  Deallocate,
  Delete,
}

enum VirtualMachineScaleSetScaleInRules {
  Default,
  OldestVM,
  NewestVM,
}

/**
 * Specifies the orchestration mode for the virtual machine scale set.
 */
enum OrchestrationMode {
  Uniform,
  Flexible,
}

/**
 * The type of extendedLocation.
 */
enum ExtendedLocationTypes {
  EdgeZone,
}

enum ExpandTypesForGetVMScaleSets {
  userData,
}

/**
 * The name of the service.
 */
enum OrchestrationServiceNames {
  AutomaticRepairs,
}

/**
 * The current state of the service.
 */
enum OrchestrationServiceState {
  NotRunning,
  Running,
  Suspended,
}

/**
 * The action to be performed.
 */
enum OrchestrationServiceStateAction {
  Resume,
  Suspend,
}

/**
 * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
 */
enum HyperVGeneration {
  V1,
  V2,
}

/**
 * Specifies the size of the virtual machine. The enum data type is currently deprecated and will be removed by December 23rd 2023. The recommended way to get the list of available sizes is using these APIs: [List all available virtual machine sizes in an availability set](https://docs.microsoft.com/rest/api/compute/availabilitysets/listavailablesizes), [List all available virtual machine sizes in a region]( https://docs.microsoft.com/rest/api/compute/resourceskus/list), [List all available virtual machine sizes for resizing](https://docs.microsoft.com/rest/api/compute/virtualmachines/listavailablesizes). For more information about virtual machine sizes, see [Sizes for virtual machines](https://docs.microsoft.com/azure/virtual-machines/sizes). The available VM sizes depend on region and availability set.
 */
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

/**
 * Specifies the detach behavior to be used while detaching a disk or which is already in the process of detachment from the virtual machine. Supported values are: **ForceDetach.** detachOption: **ForceDetach** is applicable only for managed data disks. If a previous detachment attempt of the data disk did not complete due to an unexpected failure from the virtual machine and the disk is still not released then use force-detach as a last resort option to detach the disk forcibly from the VM. All writes might not have been flushed when using this detach behavior. **This feature is still in preview** mode and is not supported for VirtualMachineScaleSet. To force-detach a data disk update toBeDetached to 'true' along with setting detachOption: 'ForceDetach'.
 */
enum DiskDetachOptionTypes {
  ForceDetach,
}

/**
 * Specifies the disk controller type configured for the VM and VirtualMachineScaleSet. This property is only supported for virtual machines whose operating system disk and VM sku supports Generation 2 (https://docs.microsoft.com/en-us/azure/virtual-machines/generation-2), please check the HyperVGenerations capability returned as part of VM sku capabilities in the response of Microsoft.Compute SKUs api for the region contains V2 (https://docs.microsoft.com/rest/api/compute/resourceskus/list). For more information about Disk Controller Types supported please refer to https://aka.ms/azure-diskcontrollertypes.
 */
enum DiskControllerTypes {
  SCSI,
  NVMe,
}

/**
 * Available from Api-Version 2019-07-01 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4. Possible values are: 'IPv4' and 'IPv6'.
 */
enum IPVersions {
  IPv4,
  IPv6,
}

/**
 * Specify the public IP allocation type
 */
enum PublicIPAllocationMethod {
  Dynamic,
  Static,
}

/**
 * Specifies the HyperVGeneration Type associated with a resource
 */
enum HyperVGenerationType {
  V1,
  V2,
}

/**
 * The overall success or failure status of the operation. It remains "InProgress" until the operation completes. At that point it will become "Unknown", "Failed", "Succeeded", or "CompletedWithWarnings."
 */
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

/**
 * Describes the reboot requirements of the patch.
 */
enum VMGuestPatchRebootBehavior {
  Unknown,
  NeverReboots,
  AlwaysRequiresReboot,
  CanRequestReboot,
}

/**
 * Describes the availability of a given patch.
 */
enum PatchAssessmentState {
  Unknown,
  Available,
}

/**
 * Defines when it is acceptable to reboot a VM during a software update operation.
 */
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

/**
 * The reboot state of the VM following completion of the operation.
 */
enum VMGuestPatchRebootStatus {
  Unknown,
  NotNeeded,
  Required,
  Started,
  Failed,
  Completed,
}

/**
 * The state of the patch after the installation operation completed.
 */
enum PatchInstallationState {
  Unknown,
  Installed,
  Failed,
  Excluded,
  NotSelected,
  Pending,
}

/**
 * Specifies the HyperVGeneration Type
 */
enum HyperVGenerationTypes {
  V1,
  V2,
}

/**
 * VM disk types which are disallowed.
 */
enum VmDiskTypes {
  None,
  Unmanaged,
}

/**
 * Specifies the Architecture Type
 */
enum ArchitectureTypes {
  x64,
  Arm64,
}

/**
 * Describes the state of the image.
 */
enum ImageState {
  Active,
  ScheduledForDeprecation,
  Deprecated,
}

/**
 * Describes the type of the alternative option.
 */
enum AlternativeType {
  None,
  Offer,
  Plan,
}

/**
 * Specifies the type of the proximity placement group. Possible values are: **Standard** : Co-locate resources within an Azure region or Availability Zone. **Ultra** : For future use.
 */
enum ProximityPlacementGroupType {
  Standard,
  Ultra,
}

/**
 * Gets the Operating System type.
 */
enum OperatingSystemType {
  Windows,
  Linux,
}

/**
 * The type of key used to encrypt the data of the disk restore point.
 */
enum RestorePointEncryptionType {
  /**
   * Disk Restore Point is encrypted at rest with Platform managed key.
   */
  EncryptionAtRestWithPlatformKey,

  /**
   * Disk Restore Point is encrypted at rest with Customer managed key that can be changed and revoked by a customer.
   */
  EncryptionAtRestWithCustomerKey,

  /**
   * Disk Restore Point is encrypted at rest with 2 layers of encryption. One of the keys is Customer managed and the other key is Platform managed.
   */
  EncryptionAtRestWithPlatformAndCustomerKeys,
}

/**
 * ConsistencyMode of the RestorePoint. Can be specified in the input while creating a restore point. For now, only CrashConsistent is accepted as a valid input. Please refer to https://aka.ms/RestorePoints for more details.
 */
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

/**
 * Script execution status.
 */
enum ExecutionState {
  Unknown,
  Pending,
  Running,
  Failed,
  Succeeded,
  TimedOut,
  Canceled,
}

/**
 * The sku name.
 */
enum DiskStorageAccountTypes {
  /**
   * Standard HDD locally redundant storage. Best for backup, non-critical, and infrequent access.
   */
  Standard_LRS,

  /**
   * Premium SSD locally redundant storage. Best for production and performance sensitive workloads.
   */
  Premium_LRS,

  /**
   * Standard SSD locally redundant storage. Best for web servers, lightly used enterprise applications and dev/test.
   */
  StandardSSD_LRS,

  /**
   * Ultra SSD locally redundant storage. Best for IO-intensive workloads such as SAP HANA, top tier databases (for example, SQL, Oracle), and other transaction-heavy workloads.
   */
  UltraSSD_LRS,

  /**
   * Premium SSD zone redundant storage. Best for the production workloads that need storage resiliency against zone failures.
   */
  Premium_ZRS,

  /**
   * Standard SSD zone redundant storage. Best for web servers, lightly used enterprise applications and dev/test that need storage resiliency against zone failures.
   */
  StandardSSD_ZRS,

  /**
   * Premium SSD v2 locally redundant storage. Best for production and performance-sensitive workloads that consistently require low latency and high IOPS and throughput.
   */
  PremiumV2_LRS,
}

/**
 * The architecture of the image. Applicable to OS disks only.
 */
enum Architecture {
  x64,
  Arm64,
}

/**
 * This enumerates the possible sources of a disk's creation.
 */
enum DiskCreateOption {
  /**
   * Create an empty data disk of a size given by diskSizeGB.
   */
  Empty,

  /**
   * Disk will be attached to a VM.
   */
  Attach,

  /**
   * Create a new disk from a platform image specified by the given imageReference or galleryImageReference.
   */
  FromImage,

  /**
   * Create a disk by importing from a blob specified by a sourceUri in a storage account specified by storageAccountId.
   */
  Import,

  /**
   * Create a new disk or snapshot by copying from a disk or snapshot specified by the given sourceResourceId.
   */
  Copy,

  /**
   * Create a new disk by copying from a backup recovery point.
   */
  Restore,

  /**
   * Create a new disk by obtaining a write token and using it to directly upload the contents of the disk.
   */
  Upload,

  /**
   * Create a new disk by using a deep copy process, where the resource creation is considered complete only after all data has been copied from the source.
   */
  CopyStart,

  /**
   * Similar to Import create option. Create a new Trusted Launch VM or Confidential VM supported disk by importing additional blob for VM guest state specified by securityDataUri in storage account specified by storageAccountId
   */
  ImportSecure,

  /**
   * Similar to Upload create option. Create a new Trusted Launch VM or Confidential VM supported disk and upload using write token in both disk and VM guest state
   */
  UploadPreparedSecure,

  /**
   * Create a new disk by exporting from elastic san volume snapshot
   */
  CopyFromSanSnapshot,
}

/**
 * This enumerates the possible state of the disk.
 */
enum DiskState {
  /**
   * The disk is not being used and can be attached to a VM.
   */
  Unattached,

  /**
   * The disk is currently attached to a running VM.
   */
  Attached,

  /**
   * The disk is attached to a stopped-deallocated VM.
   */
  Reserved,

  /**
   * The disk is attached to a VM which is in hibernated state.
   */
  Frozen,

  /**
   * The disk currently has an Active SAS Uri associated with it.
   */
  ActiveSAS,

  /**
   * The disk is attached to a VM in hibernated state and has an active SAS URI associated with it.
   */
  ActiveSASFrozen,

  /**
   * A disk is ready to be created by upload by requesting a write token.
   */
  ReadyToUpload,

  /**
   * A disk is created for upload and a write token has been issued for uploading to it.
   */
  ActiveUpload,
}

/**
 * The type of key used to encrypt the data of the disk.
 */
enum EncryptionType {
  /**
   * Disk is encrypted at rest with Platform managed key. It is the default encryption type. This is not a valid encryption type for disk encryption sets.
   */
  EncryptionAtRestWithPlatformKey,

  /**
   * Disk is encrypted at rest with Customer managed key that can be changed and revoked by a customer.
   */
  EncryptionAtRestWithCustomerKey,

  /**
   * Disk is encrypted at rest with 2 layers of encryption. One of the keys is Customer managed and the other key is Platform managed.
   */
  EncryptionAtRestWithPlatformAndCustomerKeys,
}

/**
 * Policy for accessing the disk via network.
 */
enum NetworkAccessPolicy {
  /**
   * The disk can be exported or uploaded to from any network.
   */
  AllowAll,

  /**
   * The disk can be exported or uploaded to using a DiskAccess resource's private endpoints.
   */
  AllowPrivate,

  /**
   * The disk cannot be exported.
   */
  DenyAll,
}

/**
 * Specifies the SecurityType of the VM. Applicable for OS disks only.
 */
enum DiskSecurityTypes {
  /**
   * Trusted Launch provides security features such as secure boot and virtual Trusted Platform Module (vTPM)
   */
  TrustedLaunch,

  /**
   * Indicates Confidential VM disk with only VM guest state encrypted
   */
  ConfidentialVM_VMGuestStateOnlyEncryptedWithPlatformKey,

  /**
   * Indicates Confidential VM disk with both OS disk and VM guest state encrypted with a platform managed key
   */
  ConfidentialVM_DiskEncryptedWithPlatformKey,

  /**
   * Indicates Confidential VM disk with both OS disk and VM guest state encrypted with a customer managed key
   */
  ConfidentialVM_DiskEncryptedWithCustomerKey,
}

/**
 * Policy for controlling export on the disk.
 */
enum PublicNetworkAccess {
  /**
   * You can generate a SAS URI to access the underlying data of the disk publicly on the internet when NetworkAccessPolicy is set to AllowAll. You can access the data via the SAS URI only from your trusted Azure VNET when NetworkAccessPolicy is set to AllowPrivate.
   */
  Enabled,

  /**
   * You cannot access the underlying data of the disk publicly on the internet even when NetworkAccessPolicy is set to AllowAll. You can access the data via the SAS URI only from your trusted Azure VNET when NetworkAccessPolicy is set to AllowPrivate.
   */
  Disabled,
}

/**
 * Additional authentication requirements when exporting or uploading to a disk or snapshot.
 */
enum DataAccessAuthMode {
  /**
   * When export/upload URL is used, the system checks if the user has an identity in Azure Active Directory and has necessary permissions to export/upload the data. Please refer to aka.ms/DisksAzureADAuth.
   */
  AzureActiveDirectory,

  /**
   * No additional authentication would be performed when accessing export/upload URL.
   */
  None,
}

/**
 * The Access Level, accepted values include None, Read, Write.
 */
enum AccessLevel {
  None,
  Read,
  Write,
}

/**
 * Used to specify the file format when making request for SAS on a VHDX file format snapshot
 */
enum FileFormat {
  /**
   * A VHD file is a disk image file in the Virtual Hard Disk file format.
   */
  VHD,

  /**
   * A VHDX file is a disk image file in the Virtual Hard Disk v2 file format.
   */
  VHDX,
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
 * The type of Managed Identity used by the DiskEncryptionSet. Only SystemAssigned is supported for new creations. Disk Encryption Sets can be updated with Identity type None during migration of subscription to a new Azure Active Directory tenant; it will cause the encrypted resources to lose access to the keys.
 */
enum DiskEncryptionSetIdentityType {
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
  None,
}

/**
 * The type of key used to encrypt the data of the disk.
 */
enum DiskEncryptionSetType {
  /**
   * Resource using diskEncryptionSet would be encrypted at rest with Customer managed key that can be changed and revoked by a customer.
   */
  EncryptionAtRestWithCustomerKey,

  /**
   * Resource using diskEncryptionSet would be encrypted at rest with two layers of encryption. One of the keys is Customer managed and the other key is Platform managed.
   */
  EncryptionAtRestWithPlatformAndCustomerKeys,

  /**
   * Confidential VM supported disk and VM guest state would be encrypted with customer managed key.
   */
  ConfidentialVmEncryptedWithCustomerKey,
}

/**
 * The sku name.
 */
enum SnapshotStorageAccountTypes {
  /**
   * Standard HDD locally redundant storage
   */
  Standard_LRS,

  /**
   * Premium SSD locally redundant storage
   */
  Premium_LRS,

  /**
   * Standard zone redundant storage
   */
  Standard_ZRS,
}

/**
 * Indicates the error code if the background copy of a resource created via the CopyStart operation fails.
 */
enum CopyCompletionErrorReason {
  /**
   * Indicates that the source snapshot was deleted while the background copy of the resource created via CopyStart operation was in progress.
   */
  CopySourceNotFound,
}

/**
 * The type of the extended location.
 */
enum ExtendedLocationType {
  EdgeZone,
}

/**
 * The provisioning state, which only appears in the response.
 */
enum GalleryProvisioningState {
  Creating,
  Updating,
  Failed,
  Succeeded,
  Deleting,
  Migrating,
}

/**
 * This property allows you to specify the permission of sharing gallery. <br><br> Possible values are: <br><br> **Private** <br><br> **Groups** <br><br> **Community**
 */
enum GallerySharingPermissionTypes {
  Private,
  Groups,
  Community,
}

/**
 * This property allows you to specify the type of sharing group. <br><br> Possible values are: <br><br> **Subscriptions** <br><br> **AADTenants**
 */
enum SharingProfileGroupTypes {
  Subscriptions,
  AADTenants,
}

/**
 * The sharing state of the gallery, which only appears in the response.
 */
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

/**
 * Specifies the storage account type to be used to store the image. This property is not updatable.
 */
enum StorageAccountType {
  Standard_LRS,
  Standard_ZRS,
  Premium_LRS,
}

/**
 * confidential VM encryption types
 */
enum ConfidentialVMEncryptionType {
  EncryptedVMGuestStateOnlyWithPmk,
  EncryptedWithPmk,
  EncryptedWithCmk,
}

/**
 * Optional parameter which specifies the mode to be used for replication. This property is not updatable.
 */
enum ReplicationMode {
  Full,
  Shallow,
}

/**
 * It is type of the extended location.
 */
enum GalleryExtendedLocationType {
  EdgeZone,
  Unknown,
}

/**
 * Specifies the storage account type to be used to store the image. This property is not updatable.
 */
enum EdgeZoneStorageAccountType {
  Standard_LRS,
  Standard_ZRS,
  StandardSSD_LRS,
  Premium_LRS,
}

/**
 * Describes the nature of the policy violation.
 */
enum PolicyViolationCategory {
  Other,
  ImageFlaggedUnsafe,
  CopyrightValidation,
  IpTheft,
}

/**
 * This is the aggregated replication status based on all the regional replication status flags.
 */
enum AggregatedReplicationState {
  Unknown,
  InProgress,
  Completed,
  Failed,
}

/**
 * This is the regional replication state.
 */
enum ReplicationState {
  Unknown,
  Replicating,
  Completed,
  Failed,
}

enum ReplicationStatusTypes {
  ReplicationStatus,
}

/**
 * This property allows you to specify the operation type of gallery sharing update. <br><br> Possible values are: <br><br> **Add** <br><br> **Remove** <br><br> **Reset**
 */
enum SharingUpdateOperationTypes {
  Add,
  Remove,
  Reset,
  EnableCommunity,
}

enum SharedToValues {
  tenant,
}

/**
 * The host caching of the disk. Valid values are 'None', 'ReadOnly', and 'ReadWrite'
 */
enum SharedGalleryHostCaching {
  None,
  ReadOnly,
  ReadWrite,
}

/**
 * Update mode for the cloud service. Role instances are allocated to update domains when the service is deployed. Updates can be initiated manually in each update domain or initiated automatically in all update domains.
 * Possible Values are <br /><br />**Auto**<br /><br />**Manual** <br /><br />**Simultaneous**<br /><br />
 * If not specified, the default value is Auto. If set to Manual, PUT UpdateDomain must be called to apply the update. If set to Auto, the update is automatically applied to each update domain in sequence.
 */
enum CloudServiceUpgradeMode {
  Auto,
  Manual,
  Simultaneous,
}

/**
 * Slot type for the cloud service.
 * Possible values are <br /><br />**Production**<br /><br />**Staging**<br /><br />
 * If not specified, the default value is Production.
 */
enum CloudServiceSlotType {
  Production,
  Staging,
}

/**
 * Specifies the sku of an Availability Set. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks. Default value is 'Classic'.
 */
enum AvailabilitySetSkuTypes {
  Classic,
  Aligned,
}

/**
 * Specifies the mode of an upgrade to virtual machines in the scale set.<br /><br /> Possible values are:<br /><br /> **Manual** - You  control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action.<br /><br /> **Automatic** - All virtual machines in the scale set are  automatically updated at the same time.
 */
@fixed
enum UpgradeMode {
  Automatic,
  Manual,
  Rolling,
}

/**
 * Specifies the name of the setting to which the content applies. Possible values are: FirstLogonCommands and AutoLogon.
 */
@fixed
enum SettingNames {
  AutoLogon,
  FirstLogonCommands,
}

/**
 * Specifies the protocol of WinRM listener. Possible values are: **http,** **https.**
 */
@fixed
enum ProtocolTypes {
  Http,
  Https,
}

/**
 * Specifies the caching requirements. Possible values are: **None,** **ReadOnly,** **ReadWrite.** The default values are: **None for Standard storage. ReadOnly for Premium storage**
 */
@fixed
enum CachingTypes {
  None,
  ReadOnly,
  ReadWrite,
}

/**
 * This property allows you to specify the supported type of the OS that application is built for. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**
 */
@fixed
enum OperatingSystemTypes {
  Windows,
  Linux,
}

/**
 * The level code.
 */
@fixed
enum StatusLevelTypes {
  Info,
  Warning,
  Error,
}

/**
 * The type of identity used for the virtual machine scale set. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the virtual machine scale set.
 */
@fixed
enum ResourceIdentityType {
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
  None,
}

/**
 * The scale type applicable to the sku.
 */
@fixed
enum VirtualMachineScaleSetSkuScaleType {
  Automatic,
  None,
}

/**
 * Code indicating the current status of the upgrade.
 */
@fixed
enum UpgradeState {
  RollingForward,
  Cancelled,
  Completed,
  Faulted,
}

/**
 * Invoker of the Upgrade Operation
 */
@fixed
enum UpgradeOperationInvoker {
  Unknown,
  User,
  Platform,
}

/**
 * Code indicating the current status of the upgrade.
 */
@fixed
enum RollingUpgradeStatusCode {
  RollingForward,
  Cancelled,
  Completed,
  Faulted,
}

/**
 * The last action performed on the rolling upgrade.
 */
@fixed
enum RollingUpgradeActionType {
  Start,
  Cancel,
}

/**
 * The Last Maintenance Operation Result Code.
 */
@fixed
enum MaintenanceOperationResultCodeTypes {
  None,
  RetryLater,
  MaintenanceAborted,
  MaintenanceCompleted,
}

@fixed
enum InstanceViewTypes {
  instanceView,
  userData,
}

/**
 * Specifies the software license type that will be applied to the VMs deployed on the dedicated host. Possible values are: **None,** **Windows_Server_Hybrid,** **Windows_Server_Perpetual.** The default value is: **None.**
 */
@fixed
enum DedicatedHostLicenseTypes {
  None,
  Windows_Server_Hybrid,
  Windows_Server_Perpetual,
}

/**
 * This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'.
 */
@fixed
enum OperatingSystemStateTypes {
  Generalized,
  Specialized,
}

/**
 * Interval value in minutes used to create LogAnalytics call rate logs.
 */
@fixed
enum IntervalInMins {
  ThreeMins,
  FiveMins,
  ThirtyMins,
  SixtyMins,
}

/**
 * The scale type applicable to the sku.
 */
@fixed
enum ResourceSkuCapacityScaleType {
  Automatic,
  Manual,
  None,
}

/**
 * The type of restrictions.
 */
@fixed
enum ResourceSkuRestrictionsType {
  Location,
  Zone,
}

/**
 * The reason for restriction.
 */
@fixed
enum ResourceSkuRestrictionsReasonCode {
  QuotaId,
  NotAvailableForSubscription,
}

/**
 * The host caching of the disk. Valid values are 'None', 'ReadOnly', and 'ReadWrite'
 */
@fixed
enum HostCaching {
  None,
  ReadOnly,
  ReadWrite,
}

/**
 * Specifies the type of the custom action parameter. Possible values are: String, ConfigurationDataBlob or LogOutputBlob
 */
@fixed
enum GalleryApplicationCustomActionParameterType {
  String,
  ConfigurationDataBlob,
  LogOutputBlob,
}

/**
 * Describes the properties of a Compute Operation value.
 */
model ComputeOperationValue {
  /**
   * The origin of the compute operation.
   */
  @visibility("read")
  origin?: string;

  /**
   * The name of the compute operation.
   */
  @visibility("read")
  name?: string;

  /**
   * Describes the properties of a Compute Operation Value Display.
   */
  display?: ComputeOperationValueDisplay;
}

/**
 * Describes the properties of a Compute Operation Value Display.
 */
model ComputeOperationValueDisplay {
  /**
   * The display name of the compute operation.
   */
  @visibility("read")
  operation?: string;

  /**
   * The display name of the resource the operation applies to.
   */
  @visibility("read")
  resource?: string;

  /**
   * The description of the operation.
   */
  @visibility("read")
  description?: string;

  /**
   * The resource provider for the operation.
   */
  @visibility("read")
  provider?: string;
}

/**
 * An error response from the Compute service.
 */
@error
model CloudError {
  /**
   * Api error.
   */
  error?: ApiError;
}

/**
 * Api error.
 */
model ApiError {
  /**
   * The Api error details
   */
  details?: ApiErrorBase[];

  /**
   * The Api inner error
   */
  innererror?: InnerError;

  /**
   * The error code.
   */
  code?: string;

  /**
   * The target of the particular error.
   */
  target?: string;

  /**
   * The error message.
   */
  message?: string;
}

/**
 * Api error base.
 */
model ApiErrorBase {
  /**
   * The error code.
   */
  code?: string;

  /**
   * The target of the particular error.
   */
  target?: string;

  /**
   * The error message.
   */
  message?: string;
}

/**
 * Inner error details.
 */
model InnerError {
  /**
   * The exception type.
   */
  exceptiontype?: string;

  /**
   * The internal error message or exception dump.
   */
  errordetail?: string;
}

/**
 * The List Usages operation response.
 */
model ListUsagesResult is Azure.Core.Page<Usage>;

/**
 * Describes Compute Resource Usage.
 */
model Usage {
  /**
   * An enum describing the unit of usage measurement.
   */
  unit: "Count";

  /**
   * The current usage of the resource.
   */
  currentValue: int32;

  /**
   * The maximum permitted usage of the resource.
   */
  limit: int64;

  /**
   * The name of the type of usage.
   */
  name: UsageName;
}

/**
 * The Usage Names.
 */
model UsageName {
  /**
   * The name of the resource.
   */
  value?: string;

  /**
   * The localized name of the resource.
   */
  localizedValue?: string;
}

/**
 * The List Virtual Machine operation response.
 */
@pagedResult
model VirtualMachineSizeListResult {
  /**
   * The list of virtual machine sizes.
   */
  @items
  value?: VirtualMachineSize[];
}

/**
 * Describes the properties of a VM size.
 */
model VirtualMachineSize {
  /**
   * The name of the virtual machine size.
   */
  name?: string;

  /**
   * The number of cores supported by the virtual machine size. For Constrained vCPU capable VM sizes, this number represents the total vCPUs of quota that the VM uses. For accurate vCPU count, please refer to https://docs.microsoft.com/azure/virtual-machines/constrained-vcpu or https://docs.microsoft.com/rest/api/compute/resourceskus/list
   */
  numberOfCores?: int32;

  /**
   * The OS disk size, in MB, allowed by the virtual machine size.
   */
  osDiskSizeInMB?: int32;

  /**
   * The resource disk size, in MB, allowed by the virtual machine size.
   */
  resourceDiskSizeInMB?: int32;

  /**
   * The amount of memory, in MB, supported by the virtual machine size.
   */
  memoryInMB?: int32;

  /**
   * The maximum number of data disks that can be attached to the virtual machine size.
   */
  maxDataDiskCount?: int32;
}

/**
 * Describes a virtual machine scale set sku. NOTE: If the new VM SKU is not supported on the hardware the scale set is currently on, you need to deallocate the VMs in the scale set before you modify the SKU name.
 */
model Sku {
  /**
   * The sku name.
   */
  name?: string;

  /**
   * Specifies the tier of virtual machines in a scale set.<br /><br /> Possible Values:<br /><br /> **Standard**<br /><br /> **Basic**
   */
  tier?: string;

  /**
   * Specifies the number of virtual machines in the scale set.
   */
  capacity?: int64;
}

/**
 * Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.  In the Azure portal, find the marketplace image that you want to use and then click **Want to deploy programmatically, Get Started ->**. Enter any required information and then click **Save**.
 */
model Plan {
  /**
   * The plan ID.
   */
  name?: string;

  /**
   * The publisher ID.
   */
  publisher?: string;

  /**
   * Specifies the product of the image from the marketplace. This is the same value as Offer under the imageReference element.
   */
  product?: string;

  /**
   * The promotion code.
   */
  promotionCode?: string;
}

/**
 * Describes the properties of a Virtual Machine Scale Set.
 */
model VirtualMachineScaleSetProperties {
  /**
   * The upgrade policy.
   */
  upgradePolicy?: UpgradePolicy;

  /**
   * Policy for automatic repairs.
   */
  automaticRepairsPolicy?: AutomaticRepairsPolicy;

  /**
   * The virtual machine profile.
   */
  virtualMachineProfile?: VirtualMachineScaleSetVMProfile;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Specifies whether the Virtual Machine Scale Set should be overprovisioned.
   */
  overprovision?: boolean;

  /**
   * When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs.
   */
  doNotRunExtensionsOnOverprovisionedVMs?: boolean;

  /**
   * Specifies the ID which uniquely identifies a Virtual Machine Scale Set.
   */
  @visibility("read")
  uniqueId?: string;

  /**
   * When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true.
   */
  singlePlacementGroup?: boolean;

  /**
   * Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage. zoneBalance property can only be set if the zones property of the scale set contains more than one zone. If there are no zones or only one zone specified, then zoneBalance property should not be set.
   */
  zoneBalance?: boolean;

  /**
   * Fault Domain count for each placement group.
   */
  platformFaultDomainCount?: int32;

  /**
   * Specifies information about the proximity placement group that the virtual machine scale set should be assigned to. Minimum api-version: 2018-04-01.
   */
  proximityPlacementGroup?: SubResource;

  /**
   * Specifies information about the dedicated host group that the virtual machine scale set resides in. Minimum api-version: 2020-06-01.
   */
  hostGroup?: SubResource;

  /**
   * Specifies additional capabilities enabled or disabled on the Virtual Machines in the Virtual Machine Scale Set. For instance: whether the Virtual Machines have the capability to support attaching managed data disks with UltraSSD_LRS storage account type.
   */
  additionalCapabilities?: AdditionalCapabilities;

  /**
   * Specifies the policies applied when scaling in Virtual Machines in the Virtual Machine Scale Set.
   */
  scaleInPolicy?: ScaleInPolicy;

  /**
   * Specifies the orchestration mode for the virtual machine scale set.
   */
  orchestrationMode?: OrchestrationMode;

  /**
   * Specifies the Spot Restore properties for the virtual machine scale set.
   */
  spotRestorePolicy?: SpotRestorePolicy;

  /**
   * Specifies the desired targets for mixing Spot and Regular priority VMs within the same VMSS Flex instance.
   */
  priorityMixPolicy?: PriorityMixPolicy;

  /**
   * Specifies the time at which the Virtual Machine Scale Set resource was created. Minimum api-version: 2021-11-01.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  /**
   * Optional property which must either be set to True or omitted.
   */
  constrainedMaximumCapacity?: boolean;
}

/**
 * Describes an upgrade policy - automatic, manual, or rolling.
 */
model UpgradePolicy {
  /**
   * Specifies the mode of an upgrade to virtual machines in the scale set.<br /><br /> Possible values are:<br /><br /> **Manual** - You  control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action.<br /><br /> **Automatic** - All virtual machines in the scale set are  automatically updated at the same time.
   */
  mode?: UpgradeMode;

  /**
   * The configuration parameters used while performing a rolling upgrade.
   */
  rollingUpgradePolicy?: RollingUpgradePolicy;

  /**
   * Configuration parameters used for performing automatic OS Upgrade.
   */
  automaticOSUpgradePolicy?: AutomaticOSUpgradePolicy;
}

/**
 * The configuration parameters used while performing a rolling upgrade.
 */
model RollingUpgradePolicy {
  /**
   * The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability. The default value for this parameter is 20%.
   */
  @maxValue(100)
  @minValue(5)
  maxBatchInstancePercent?: int32;

  /**
   * The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. The default value for this parameter is 20%.
   */
  @maxValue(100)
  @minValue(5)
  maxUnhealthyInstancePercent?: int32;

  /**
   * The maximum percentage of upgraded virtual machine instances that can be found to be in an unhealthy state. This check will happen after each batch is upgraded. If this percentage is ever exceeded, the rolling update aborts. The default value for this parameter is 20%.
   */
  @maxValue(100)
  maxUnhealthyUpgradedInstancePercent?: int32;

  /**
   * The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format. The default value is 0 seconds (PT0S).
   */
  pauseTimeBetweenBatches?: string;

  /**
   * Allow VMSS to ignore AZ boundaries when constructing upgrade batches. Take into consideration the Update Domain and maxBatchInstancePercent to determine the batch size.
   */
  enableCrossZoneUpgrade?: boolean;

  /**
   * Upgrade all unhealthy instances in a scale set before any healthy instances.
   */
  prioritizeUnhealthyInstances?: boolean;

  /**
   * Rollback failed instances to previous model if the Rolling Upgrade policy is violated.
   */
  rollbackFailedInstancesOnPolicyBreach?: boolean;

  /**
   * Create new virtual machines to upgrade the scale set, rather than updating the existing virtual machines. Existing virtual machines will be deleted once the new virtual machines are created for each batch.
   */
  maxSurge?: boolean;
}

/**
 * The configuration parameters used for performing automatic OS upgrade.
 */
model AutomaticOSUpgradePolicy {
  /**
   * Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, [enableAutomaticUpdates](https://docs.microsoft.com/dotnet/api/microsoft.azure.management.compute.models.windowsconfiguration.enableautomaticupdates?view=azure-dotnet) is automatically set to false and cannot be set to true.
   */
  enableAutomaticOSUpgrade?: boolean;

  /**
   * Whether OS image rollback feature should be disabled. Default value is false.
   */
  disableAutomaticRollback?: boolean;

  /**
   * Indicates whether rolling upgrade policy should be used during Auto OS Upgrade. Default value is false. Auto OS Upgrade will fallback to the default policy if no policy is defined on the VMSS.
   */
  useRollingUpgradePolicy?: boolean;
}

/**
 * Specifies the configuration parameters for automatic repairs on the virtual machine scale set.
 */
model AutomaticRepairsPolicy {
  /**
   * Specifies whether automatic repairs should be enabled on the virtual machine scale set. The default value is false.
   */
  enabled?: boolean;

  /**
   * The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 10 minutes (PT10M), which is also the default value. The maximum allowed grace period is 90 minutes (PT90M).
   */
  gracePeriod?: string;

  /**
   * Type of repair action (replace, restart, reimage) that will be used for repairing unhealthy virtual machines in the scale set. Default value is replace.
   */
  repairAction?: RepairAction;
}

/**
 * Describes a virtual machine scale set virtual machine profile.
 */
model VirtualMachineScaleSetVMProfile {
  /**
   * Specifies the operating system settings for the virtual machines in the scale set.
   */
  osProfile?: VirtualMachineScaleSetOSProfile;

  /**
   * Specifies the storage settings for the virtual machine disks.
   */
  storageProfile?: VirtualMachineScaleSetStorageProfile;

  /**
   * Specifies properties of the network interfaces of the virtual machines in the scale set.
   */
  networkProfile?: VirtualMachineScaleSetNetworkProfile;

  /**
   * Specifies the Security related profile settings for the virtual machines in the scale set.
   */
  securityProfile?: SecurityProfile;

  /**
   * Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.
   */
  diagnosticsProfile?: DiagnosticsProfile;

  /**
   * Specifies a collection of settings for extensions installed on virtual machines in the scale set.
   */
  extensionProfile?: VirtualMachineScaleSetExtensionProfile;

  /**
   * Specifies that the image or disk that is being used was licensed on-premises. <br><br> Possible values for Windows Server operating system are: <br><br> Windows_Client <br><br> Windows_Server <br><br> Possible values for Linux Server operating system are: <br><br> RHEL_BYOS (for RHEL) <br><br> SLES_BYOS (for SUSE) <br><br> For more information, see [Azure Hybrid Use Benefit for Windows Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing) <br><br> [Azure Hybrid Use Benefit for Linux Server](https://docs.microsoft.com/azure/virtual-machines/linux/azure-hybrid-benefit-linux) <br><br> Minimum api-version: 2015-06-15
   */
  licenseType?: string;

  /**
   * Specifies the priority for the virtual machines in the scale set. Minimum api-version: 2017-10-30-preview.
   */
  priority?: VirtualMachinePriorityTypes;

  /**
   * Specifies the eviction policy for the Azure Spot virtual machine and Azure Spot scale set. For Azure Spot virtual machines, both 'Deallocate' and 'Delete' are supported and the minimum api-version is 2019-03-01. For Azure Spot scale sets, both 'Deallocate' and 'Delete' are supported and the minimum api-version is 2017-10-30-preview.
   */
  evictionPolicy?: VirtualMachineEvictionPolicyTypes;

  /**
   * Specifies the billing related details of a Azure Spot VMSS. Minimum api-version: 2019-03-01.
   */
  billingProfile?: BillingProfile;

  /**
   * Specifies Scheduled Event related configurations.
   */
  scheduledEventsProfile?: ScheduledEventsProfile;

  /**
   * UserData for the virtual machines in the scale set, which must be base-64 encoded. Customer should not pass any secrets in here. Minimum api-version: 2021-03-01.
   */
  userData?: string;

  /**
   * Specifies the capacity reservation related details of a scale set. Minimum api-version: 2021-04-01.
   */
  capacityReservation?: CapacityReservationProfile;

  /**
   * Specifies the gallery applications that should be made available to the VM/VMSS
   */
  applicationProfile?: ApplicationProfile;

  /**
   * Specifies the hardware profile related details of a scale set. Minimum api-version: 2021-11-01.
   */
  hardwareProfile?: VirtualMachineScaleSetHardwareProfile;

  /**
   * Specifies the service artifact reference id used to set same image version for all virtual machines in the scale set when using 'latest' image version. Minimum api-version: 2022-11-01
   */
  serviceArtifactReference?: ServiceArtifactReference;

  /**
   * Specifies the security posture to be used for all virtual machines in the scale set. Minimum api-version: 2023-03-01
   */
  securityPostureReference?: SecurityPostureReference;
}

/**
 * Describes a virtual machine scale set OS profile.
 */
model VirtualMachineScaleSetOSProfile {
  /**
   * Specifies the computer name prefix for all of the virtual machines in the scale set. Computer name prefixes must be 1 to 15 characters long.
   */
  computerNamePrefix?: string;

  /**
   * Specifies the name of the administrator account. <br><br> **Windows-only restriction:** Cannot end in "." <br><br> **Disallowed values:** "administrator", "admin", "user", "user1", "test", "user2", "test1", "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console", "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0", "sys", "test2", "test3", "user4", "user5". <br><br> **Minimum-length (Linux):** 1  character <br><br> **Max-length (Linux):** 64 characters <br><br> **Max-length (Windows):** 20 characters
   */
  adminUsername?: string;

  @doc("Specifies the password of the administrator account. <br><br> **Minimum-length (Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters <br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length (Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4 conditions below need to be fulfilled <br> Has lower characters <br>Has upper characters <br> Has a digit <br> Has a special character (Regex match [\\W_]) <br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\", \"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\", \"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to reset the Remote Desktop service or its login password in a Windows VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp) <br><br> For resetting root password, see [Manage users, SSH, and check or repair disks on Azure Linux VMs using the VMAccess Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)")
  adminPassword?: string;

  /**
   * Specifies a base-64 encoded string of custom data. The base-64 encoded string is decoded to a binary array that is saved as a file on the Virtual Machine. The maximum length of the binary array is 65535 bytes. For using cloud-init for your VM, see [Using cloud-init to customize a Linux VM during creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init)
   */
  customData?: string;

  /**
   * Specifies Windows operating system settings on the virtual machine.
   */
  windowsConfiguration?: WindowsConfiguration;

  /**
   * Specifies the Linux operating system settings on the virtual machine. For a list of supported Linux distributions, see [Linux on Azure-Endorsed Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
   */
  linuxConfiguration?: LinuxConfiguration;

  /**
   * Specifies set of certificates that should be installed onto the virtual machines in the scale set. To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  secrets?: VaultSecretGroup[];

  /**
   * Specifies whether extension operations should be allowed on the virtual machine scale set. This may only be set to False when no extensions are present on the virtual machine scale set.
   */
  allowExtensionOperations?: boolean;

  /**
   * Optional property which must either be set to True or omitted.
   */
  requireGuestProvisionSignal?: boolean;
}

/**
 * Specifies Windows operating system settings on the virtual machine.
 */
model WindowsConfiguration {
  /**
   * Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, it is set to true by default. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.
   */
  provisionVMAgent?: boolean;

  /**
   * Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.
   */
  enableAutomaticUpdates?: boolean;

  /**
   * Specifies the time zone of the virtual machine. e.g. "Pacific Standard Time". Possible values can be [TimeZoneInfo.Id](https://docs.microsoft.com/dotnet/api/system.timezoneinfo.id?#System_TimeZoneInfo_Id) value from time zones returned by [TimeZoneInfo.GetSystemTimeZones](https://docs.microsoft.com/dotnet/api/system.timezoneinfo.getsystemtimezones).
   */
  timeZone?: string;

  /**
   * Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup.
   */
  additionalUnattendContent?: AdditionalUnattendContent[];

  /**
   * [Preview Feature] Specifies settings related to VM Guest Patching on Windows.
   */
  patchSettings?: PatchSettings;

  /**
   * Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell.
   */
  winRM?: WinRMConfiguration;

  /**
   * Indicates whether VMAgent Platform Updates is enabled for the Windows virtual machine. Default value is false.
   */
  enableVMAgentPlatformUpdates?: boolean;
}

/**
 * Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied.
 */
model AdditionalUnattendContent {
  /**
   * The pass name. Currently, the only allowable value is OobeSystem.
   */
  passName?: "OobeSystem";

  /**
   * The component name. Currently, the only allowable value is Microsoft-Windows-Shell-Setup.
   */
  componentName?: "Microsoft-Windows-Shell-Setup";

  /**
   * Specifies the name of the setting to which the content applies. Possible values are: FirstLogonCommands and AutoLogon.
   */
  settingName?: SettingNames;

  /**
   * Specifies the XML formatted content that is added to the unattend.xml file for the specified path and component. The XML must be less than 4KB and must include the root element for the setting or feature that is being inserted.
   */
  content?: string;
}

/**
 * Specifies settings related to VM Guest Patching on Windows.
 */
model PatchSettings {
  /**
   * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **Manual** - You  control the application of patches to a virtual machine. You do this by applying patches manually inside the VM. In this mode, automatic updates are disabled; the property WindowsConfiguration.enableAutomaticUpdates must be false<br /><br /> **AutomaticByOS** - The virtual machine will automatically be updated by the OS. The property WindowsConfiguration.enableAutomaticUpdates must be true. <br /><br /> **AutomaticByPlatform** - the virtual machine will automatically updated by the platform. The properties provisionVMAgent and WindowsConfiguration.enableAutomaticUpdates must be true
   */
  patchMode?: WindowsVMGuestPatchMode;

  /**
   * Enables customers to patch their Azure VMs without requiring a reboot. For enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode' must be set to 'AutomaticByPlatform'.
   */
  enableHotpatching?: boolean;

  /**
   * Specifies the mode of VM Guest patch assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine.<br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
   */
  assessmentMode?: WindowsPatchAssessmentMode;

  /**
   * Specifies additional settings for patch mode AutomaticByPlatform in VM Guest Patching on Windows.
   */
  automaticByPlatformSettings?: WindowsVMGuestPatchAutomaticByPlatformSettings;
}

/**
 * Specifies additional settings to be applied when patch mode AutomaticByPlatform is selected in Windows patch settings.
 */
model WindowsVMGuestPatchAutomaticByPlatformSettings {
  /**
   * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
   */
  rebootSetting?: WindowsVMGuestPatchAutomaticByPlatformRebootSetting;

  /**
   * Enables customer to schedule patching without accidental upgrades
   */
  bypassPlatformSafetyChecksOnUserSchedule?: boolean;
}

/**
 * Describes Windows Remote Management configuration of the VM
 */
model WinRMConfiguration {
  /**
   * The list of Windows Remote Management listeners
   */
  listeners?: WinRMListener[];
}

/**
 * Describes Protocol and thumbprint of Windows Remote Management listener
 */
model WinRMListener {
  /**
   * Specifies the protocol of WinRM listener. Possible values are: **http,** **https.**
   */
  protocol?: ProtocolTypes;

  /**
   * This is the URL of a certificate that has been uploaded to Key Vault as a secret. For adding a secret to the Key Vault, see [Add a key or secret to the key vault](https://docs.microsoft.com/azure/key-vault/key-vault-get-started/#add). In this case, your certificate needs to be the Base64 encoding of the following JSON Object which is encoded in UTF-8: <br><br> {<br>  "data":"<Base64-encoded-certificate>",<br>  "dataType":"pfx",<br>  "password":"<pfx-file-password>"<br>} <br> To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  certificateUrl?: string;
}

/**
 * Specifies the Linux operating system settings on the virtual machine. For a list of supported Linux distributions, see [Linux on Azure-Endorsed Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
 */
model LinuxConfiguration {
  /**
   * Specifies whether password authentication should be disabled.
   */
  disablePasswordAuthentication?: boolean;

  /**
   * Specifies the ssh key configuration for a Linux OS.
   */
  ssh?: SshConfiguration;

  /**
   * Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.
   */
  provisionVMAgent?: boolean;

  /**
   * [Preview Feature] Specifies settings related to VM Guest Patching on Linux.
   */
  patchSettings?: LinuxPatchSettings;

  /**
   * Indicates whether VMAgent Platform Updates is enabled for the Linux virtual machine. Default value is false.
   */
  enableVMAgentPlatformUpdates?: boolean;
}

/**
 * SSH configuration for Linux based VMs running on Azure
 */
model SshConfiguration {
  /**
   * The list of SSH public keys used to authenticate with linux based VMs.
   */
  publicKeys?: SshPublicKey[];
}

/**
 * Contains information about SSH certificate public key and the path on the Linux VM where the public key is placed.
 */
model SshPublicKey {
  /**
   * Specifies the full path on the created VM where ssh public key is stored. If the file already exists, the specified key is appended to the file. Example: /home/user/.ssh/authorized_keys
   */
  path?: string;

  /**
   * SSH public key certificate used to authenticate with the VM through ssh. The key needs to be at least 2048-bit and in ssh-rsa format. For creating ssh keys, see [Create SSH keys on Linux and Mac for Linux VMs in Azure]https://docs.microsoft.com/azure/virtual-machines/linux/create-ssh-keys-detailed).
   */
  keyData?: string;
}

/**
 * Specifies settings related to VM Guest Patching on Linux.
 */
model LinuxPatchSettings {
  /**
   * Specifies the mode of VM Guest Patching to IaaS virtual machine or virtual machines associated to virtual machine scale set with OrchestrationMode as Flexible.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - The virtual machine's default patching configuration is used. <br /><br /> **AutomaticByPlatform** - The virtual machine will be automatically updated by the platform. The property provisionVMAgent must be true
   */
  patchMode?: LinuxVMGuestPatchMode;

  /**
   * Specifies the mode of VM Guest Patch Assessment for the IaaS virtual machine.<br /><br /> Possible values are:<br /><br /> **ImageDefault** - You control the timing of patch assessments on a virtual machine. <br /><br /> **AutomaticByPlatform** - The platform will trigger periodic patch assessments. The property provisionVMAgent must be true.
   */
  assessmentMode?: LinuxPatchAssessmentMode;

  /**
   * Specifies additional settings for patch mode AutomaticByPlatform in VM Guest Patching on Linux.
   */
  automaticByPlatformSettings?: LinuxVMGuestPatchAutomaticByPlatformSettings;
}

/**
 * Specifies additional settings to be applied when patch mode AutomaticByPlatform is selected in Linux patch settings.
 */
model LinuxVMGuestPatchAutomaticByPlatformSettings {
  /**
   * Specifies the reboot setting for all AutomaticByPlatform patch installation operations.
   */
  rebootSetting?: LinuxVMGuestPatchAutomaticByPlatformRebootSetting;

  /**
   * Enables customer to schedule patching without accidental upgrades
   */
  bypassPlatformSafetyChecksOnUserSchedule?: boolean;
}

/**
 * Describes a set of certificates which are all in the same Key Vault.
 */
model VaultSecretGroup {
  /**
   * The relative URL of the Key Vault containing all of the certificates in VaultCertificates.
   */
  sourceVault?: SubResource;

  /**
   * The list of key vault references in SourceVault which contain certificates.
   */
  vaultCertificates?: VaultCertificate[];
}

model SubResource {
  /**
   * Resource Id
   */
  id?: string;
}

/**
 * Describes a single certificate reference in a Key Vault, and where the certificate should reside on the VM.
 */
model VaultCertificate {
  /**
   * This is the URL of a certificate that has been uploaded to Key Vault as a secret. For adding a secret to the Key Vault, see [Add a key or secret to the key vault](https://docs.microsoft.com/azure/key-vault/key-vault-get-started/#add). In this case, your certificate needs to be It is the Base64 encoding of the following JSON Object which is encoded in UTF-8: <br><br> {<br>  "data":"<Base64-encoded-certificate>",<br>  "dataType":"pfx",<br>  "password":"<pfx-file-password>"<br>} <br> To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  certificateUrl?: string;

  /**
   * For Windows VMs, specifies the certificate store on the Virtual Machine to which the certificate should be added. The specified certificate store is implicitly in the LocalMachine account. For Linux VMs, the certificate file is placed under the /var/lib/waagent directory, with the file name &lt;UppercaseThumbprint&gt;.crt for the X509 certificate file and &lt;UppercaseThumbprint&gt;.prv for private key. Both of these files are .pem formatted.
   */
  certificateStore?: string;
}

/**
 * Describes a virtual machine scale set storage profile.
 */
model VirtualMachineScaleSetStorageProfile {
  /**
   * Specifies information about the image to use. You can specify information about platform images, marketplace images, or virtual machine images. This element is required when you want to use a platform image, marketplace image, or virtual machine image, but is not used in other creation operations.
   */
  imageReference?: ImageReference;

  /**
   * Specifies information about the operating system disk used by the virtual machines in the scale set. For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
   */
  osDisk?: VirtualMachineScaleSetOSDisk;

  /**
   * Specifies the parameters that are used to add data disks to the virtual machines in the scale set. For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
   */
  dataDisks?: VirtualMachineScaleSetDataDisk[];

  diskControllerType?: string;
}

/**
 * Specifies information about the image to use. You can specify information about platform images, marketplace images, or virtual machine images. This element is required when you want to use a platform image, marketplace image, or virtual machine image, but is not used in other creation operations. NOTE: Image reference publisher and offer can only be set when you create the scale set.
 */
model ImageReference extends SubResource {
  /**
   * The image publisher.
   */
  publisher?: string;

  /**
   * Specifies the offer of the platform image or marketplace image used to create the virtual machine.
   */
  offer?: string;

  /**
   * The image SKU.
   */
  sku?: string;

  /**
   * Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor, and Build are decimal numbers. Specify 'latest' to use the latest version of an image available at deploy time. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available. Please do not use field 'version' for gallery image deployment, gallery image should always use 'id' field for deployment, to use 'latest' version of gallery image, just set '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/{imageName}' in the 'id' field without version input.
   */
  version?: string;

  /**
   * Specifies in decimal numbers, the version of platform image or marketplace image used to create the virtual machine. This readonly field differs from 'version', only if the value specified in 'version' field is 'latest'.
   */
  @visibility("read")
  exactVersion?: string;

  /**
   * Specified the shared gallery image unique id for vm deployment. This can be fetched from shared gallery image GET call.
   */
  sharedGalleryImageId?: string;

  /**
   * Specified the community gallery image unique id for vm deployment. This can be fetched from community gallery image GET call.
   */
  communityGalleryImageId?: string;
}

/**
 * Describes a virtual machine scale set operating system disk.
 */
model VirtualMachineScaleSetOSDisk {
  /**
   * The disk name.
   */
  name?: string;

  /**
   * Specifies the caching requirements. Possible values are: **None,** **ReadOnly,** **ReadWrite.** The default values are: **None for Standard storage. ReadOnly for Premium storage.**
   */
  caching?: CachingTypes;

  /**
   * Specifies whether writeAccelerator should be enabled or disabled on the disk.
   */
  writeAcceleratorEnabled?: boolean;

  /**
   * Specifies how the virtual machines in the scale set should be created. The only allowed value is: **FromImage.** This value is used when you are using an image to create the virtual machine. If you are using a platform image, you also use the imageReference element described above. If you are using a marketplace image, you  also use the plan element previously described.
   */
  createOption: DiskCreateOptionTypes;

  /**
   * Specifies the ephemeral disk Settings for the operating system disk used by the virtual machine scale set.
   */
  diffDiskSettings?: DiffDiskSettings;

  /**
   * Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. The property 'diskSizeGB' is the number of bytes x 1024^3 for the disk and the value cannot be larger than 1023.
   */
  diskSizeGB?: int32;

  /**
   * This property allows you to specify the type of the OS that is included in the disk if creating a VM from user-image or a specialized VHD. Possible values are: **Windows,** **Linux.**
   */
  osType?: OperatingSystemTypes;

  /**
   * Specifies information about the unmanaged user image to base the scale set on.
   */
  image?: VirtualHardDisk;

  /**
   * Specifies the container urls that are used to store operating system disks for the scale set.
   */
  vhdContainers?: string[];

  /**
   * The managed disk parameters.
   */
  managedDisk?: VirtualMachineScaleSetManagedDiskParameters;

  /**
   * Specifies whether OS Disk should be deleted or detached upon VMSS Flex deletion (This feature is available for VMSS with Flexible OrchestrationMode only). <br><br> Possible values: <br><br> **Delete** If this value is used, the OS disk is deleted when VMSS Flex VM is deleted.<br><br> **Detach** If this value is used, the OS disk is retained after VMSS Flex VM is deleted. <br><br> The default value is set to **Delete**. For an Ephemeral OS Disk, the default value is set to **Delete**. User cannot change the delete option for Ephemeral OS Disk.
   */
  deleteOption?: DiskDeleteOptionTypes;
}

/**
 * Describes the parameters of ephemeral disk settings that can be specified for operating system disk. **Note:** The ephemeral disk settings can only be specified for managed disk.
 */
model DiffDiskSettings {
  /**
   * Specifies the ephemeral disk settings for operating system disk.
   */
  option?: DiffDiskOptions;

  /**
   * Specifies the ephemeral disk placement for operating system disk. Possible values are: **CacheDisk,** **ResourceDisk.** The defaulting behavior is: **CacheDisk** if one is configured for the VM size otherwise **ResourceDisk** is used. Refer to the VM size documentation for Windows VM at https://docs.microsoft.com/azure/virtual-machines/windows/sizes and Linux VM at https://docs.microsoft.com/azure/virtual-machines/linux/sizes to check which VM sizes exposes a cache disk.
   */
  placement?: DiffDiskPlacement;
}

/**
 * Describes the uri of a disk.
 */
model VirtualHardDisk {
  /**
   * Specifies the virtual hard disk's uri.
   */
  uri?: string;
}

/**
 * Describes the parameters of a ScaleSet managed disk.
 */
model VirtualMachineScaleSetManagedDiskParameters {
  /**
   * Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk.
   */
  storageAccountType?: StorageAccountTypes;

  /**
   * Specifies the customer managed disk encryption set resource id for the managed disk.
   */
  diskEncryptionSet?: DiskEncryptionSetParameters;

  /**
   * Specifies the security profile for the managed disk.
   */
  securityProfile?: VMDiskSecurityProfile;
}

/**
 * Describes the parameter of customer managed disk encryption set resource id that can be specified for disk. **Note:** The disk encryption set resource id can only be specified for managed disk. Please refer https://aka.ms/mdssewithcmkoverview for more details.
 */
model DiskEncryptionSetParameters extends SubResource {}

/**
 * Specifies the security profile settings for the managed disk. **Note:** It can only be set for Confidential VMs.
 */
model VMDiskSecurityProfile {
  /**
   * Specifies the EncryptionType of the managed disk. It is set to DiskWithVMGuestState for encryption of the managed disk along with VMGuestState blob, and VMGuestStateOnly for encryption of just the VMGuestState blob. **Note:** It can be set for only Confidential VMs.
   */
  securityEncryptionType?: SecurityEncryptionTypes;

  /**
   * Specifies the customer managed disk encryption set resource id for the managed disk that is used for Customer Managed Key encrypted ConfidentialVM OS Disk and VMGuest blob.
   */
  diskEncryptionSet?: DiskEncryptionSetParameters;
}

/**
 * Describes a virtual machine scale set data disk.
 */
model VirtualMachineScaleSetDataDisk {
  /**
   * The disk name.
   */
  name?: string;

  /**
   * Specifies the logical unit number of the data disk. This value is used to identify data disks within the VM and therefore must be unique for each data disk attached to a VM.
   */
  lun: int32;

  /**
   * Specifies the caching requirements. Possible values are: **None,** **ReadOnly,** **ReadWrite.** The default values are: **None for Standard storage. ReadOnly for Premium storage.**
   */
  caching?: CachingTypes;

  /**
   * Specifies whether writeAccelerator should be enabled or disabled on the disk.
   */
  writeAcceleratorEnabled?: boolean;

  /**
   * The create option.
   */
  createOption: DiskCreateOptionTypes;

  /**
   * Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. The property diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be larger than 1023.
   */
  diskSizeGB?: int32;

  /**
   * The managed disk parameters.
   */
  managedDisk?: VirtualMachineScaleSetManagedDiskParameters;

  /**
   * Specifies the Read-Write IOPS for the managed disk. Should be used only when StorageAccountType is UltraSSD_LRS. If not specified, a default value would be assigned based on diskSizeGB.
   */
  @encodedName("application/json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int64;

  /**
   * Specifies the bandwidth in MB per second for the managed disk. Should be used only when StorageAccountType is UltraSSD_LRS. If not specified, a default value would be assigned based on diskSizeGB.
   */
  diskMBpsReadWrite?: int64;

  /**
   * Specifies whether data disk should be deleted or detached upon VMSS Flex deletion (This feature is available for VMSS with Flexible OrchestrationMode only).<br><br> Possible values: <br><br> **Delete** If this value is used, the data disk is deleted when the VMSS Flex VM is deleted.<br><br> **Detach** If this value is used, the data disk is retained after VMSS Flex VM is deleted.<br><br> The default value is set to **Delete**.
   */
  deleteOption?: DiskDeleteOptionTypes;
}

/**
 * Describes a virtual machine scale set network profile.
 */
model VirtualMachineScaleSetNetworkProfile {
  /**
   * A reference to a load balancer probe used to determine the health of an instance in the virtual machine scale set. The reference will be in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}'.
   */
  healthProbe?: ApiEntityReference;

  /**
   * The list of network configurations.
   */
  networkInterfaceConfigurations?: VirtualMachineScaleSetNetworkConfiguration[];

  /**
   * specifies the Microsoft.Network API version used when creating networking resources in the Network Interface Configurations for Virtual Machine Scale Set with orchestration mode 'Flexible'
   */
  networkApiVersion?: NetworkApiVersion;
}

/**
 * The API entity reference.
 */
model ApiEntityReference {
  /**
   * The ARM resource id in the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/...
   */
  id?: string;
}

/**
 * Describes a virtual machine scale set network profile's network configurations.
 */
model VirtualMachineScaleSetNetworkConfiguration {
  /**
   * The network configuration name.
   */
  name: string;

  /**
   * Describes a virtual machine scale set network profile's IP configuration.
   */
  properties?: VirtualMachineScaleSetNetworkConfigurationProperties;
}

/**
 * Describes a virtual machine scale set network profile's IP configuration.
 */
model VirtualMachineScaleSetNetworkConfigurationProperties {
  /**
   * Specifies the primary network interface in case the virtual machine has more than 1 network interface.
   */
  primary?: boolean;

  /**
   * Specifies whether the network interface is accelerated networking-enabled.
   */
  enableAcceleratedNetworking?: boolean;

  /**
   * Specifies whether the network interface is disabled for tcp state tracking.
   */
  disableTcpStateTracking?: boolean;

  /**
   * Specifies whether the network interface is FPGA networking-enabled.
   */
  enableFpga?: boolean;

  /**
   * The network security group.
   */
  networkSecurityGroup?: SubResource;

  /**
   * The dns settings to be applied on the network interfaces.
   */
  dnsSettings?: VirtualMachineScaleSetNetworkConfigurationDnsSettings;

  /**
   * Specifies the IP configurations of the network interface.
   */
  ipConfigurations: VirtualMachineScaleSetIPConfiguration[];

  /**
   * Whether IP forwarding enabled on this NIC.
   */
  enableIPForwarding?: boolean;

  /**
   * Specify what happens to the network interface when the VM is deleted
   */
  deleteOption?: DeleteOptions;

  /**
   * Specifies whether the Auxiliary mode is enabled for the Network Interface resource.
   */
  auxiliaryMode?: NetworkInterfaceAuxiliaryMode;

  /**
   * Specifies whether the Auxiliary sku is enabled for the Network Interface resource.
   */
  auxiliarySku?: NetworkInterfaceAuxiliarySku;
}

/**
 * Describes a virtual machines scale sets network configuration's DNS settings.
 */
model VirtualMachineScaleSetNetworkConfigurationDnsSettings {
  /**
   * List of DNS servers IP addresses
   */
  dnsServers?: string[];
}

/**
 * Describes a virtual machine scale set network profile's IP configuration.
 */
model VirtualMachineScaleSetIPConfiguration {
  /**
   * The IP configuration name.
   */
  name: string;

  /**
   * Describes a virtual machine scale set network profile's IP configuration properties.
   */
  properties?: VirtualMachineScaleSetIPConfigurationProperties;
}

/**
 * Describes a virtual machine scale set network profile's IP configuration properties.
 */
model VirtualMachineScaleSetIPConfigurationProperties {
  /**
   * Specifies the identifier of the subnet.
   */
  subnet?: ApiEntityReference;

  /**
   * Specifies the primary network interface in case the virtual machine has more than 1 network interface.
   */
  primary?: boolean;

  /**
   * The publicIPAddressConfiguration.
   */
  publicIPAddressConfiguration?: VirtualMachineScaleSetPublicIPAddressConfiguration;

  /**
   * Available from Api-Version 2017-03-30 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible values are: 'IPv4' and 'IPv6'.
   */
  privateIPAddressVersion?: IPVersion;

  /**
   * Specifies an array of references to backend address pools of application gateways. A scale set can reference backend address pools of multiple application gateways. Multiple scale sets cannot use the same application gateway.
   */
  applicationGatewayBackendAddressPools?: SubResource[];

  /**
   * Specifies an array of references to application security group.
   */
  applicationSecurityGroups?: SubResource[];

  /**
   * Specifies an array of references to backend address pools of load balancers. A scale set can reference backend address pools of one public and one internal load balancer. Multiple scale sets cannot use the same basic sku load balancer.
   */
  loadBalancerBackendAddressPools?: SubResource[];

  /**
   * Specifies an array of references to inbound Nat pools of the load balancers. A scale set can reference inbound nat pools of one public and one internal load balancer. Multiple scale sets cannot use the same basic sku load balancer.
   */
  loadBalancerInboundNatPools?: SubResource[];
}

/**
 * Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration
 */
model VirtualMachineScaleSetPublicIPAddressConfiguration {
  /**
   * The publicIP address configuration name.
   */
  name: string;

  /**
   * Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration
   */
  properties?: VirtualMachineScaleSetPublicIPAddressConfigurationProperties;

  /**
   * Describes the public IP Sku. It can only be set with OrchestrationMode as Flexible.
   */
  sku?: PublicIPAddressSku;
}

/**
 * Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration
 */
model VirtualMachineScaleSetPublicIPAddressConfigurationProperties {
  /**
   * The idle timeout of the public IP address.
   */
  idleTimeoutInMinutes?: int32;

  /**
   * The dns settings to be applied on the publicIP addresses .
   */
  dnsSettings?: VirtualMachineScaleSetPublicIPAddressConfigurationDnsSettings;

  /**
   * The list of IP tags associated with the public IP address.
   */
  ipTags?: VirtualMachineScaleSetIpTag[];

  /**
   * The PublicIPPrefix from which to allocate publicIP addresses.
   */
  publicIPPrefix?: SubResource;

  /**
   * Available from Api-Version 2019-07-01 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4. Possible values are: 'IPv4' and 'IPv6'.
   */
  publicIPAddressVersion?: IPVersion;

  /**
   * Specify what happens to the public IP when the VM is deleted
   */
  deleteOption?: DeleteOptions;
}

/**
 * Describes a virtual machines scale sets network configuration's DNS settings.
 */
model VirtualMachineScaleSetPublicIPAddressConfigurationDnsSettings {
  /**
   * The Domain name label.The concatenation of the domain name label and vm index will be the domain name labels of the PublicIPAddress resources that will be created
   */
  domainNameLabel: string;

  /**
   * The Domain name label scope.The concatenation of the hashed domain name label that generated according to the policy from domain name label scope and vm index will be the domain name labels of the PublicIPAddress resources that will be created
   */
  domainNameLabelScope?: DomainNameLabelScopeTypes;
}

/**
 * Contains the IP tag associated with the public IP address.
 */
model VirtualMachineScaleSetIpTag {
  /**
   * IP tag type. Example: FirstPartyUsage.
   */
  ipTagType?: string;

  /**
   * IP tag associated with the public IP. Example: SQL, Storage etc.
   */
  tag?: string;
}

/**
 * Describes the public IP Sku. It can only be set with OrchestrationMode as Flexible.
 */
model PublicIPAddressSku {
  /**
   * Specify public IP sku name
   */
  name?: PublicIPAddressSkuName;

  /**
   * Specify public IP sku tier
   */
  tier?: PublicIPAddressSkuTier;
}

/**
 * Specifies the Security profile settings for the virtual machine or virtual machine scale set.
 */
model SecurityProfile {
  /**
   * Specifies the security settings like secure boot and vTPM used while creating the virtual machine. Minimum api-version: 2020-12-01.
   */
  uefiSettings?: UefiSettings;

  /**
   * This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine or virtual machine scale set. This will enable the encryption for all the disks including Resource/Temp disk at host itself. The default behavior is: The Encryption at host will be disabled unless this property is set to true for the resource.
   */
  encryptionAtHost?: boolean;

  /**
   * Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set.
   */
  securityType?: SecurityTypes;
}

/**
 * Specifies the security settings like secure boot and vTPM used while creating the virtual machine. Minimum api-version: 2020-12-01.
 */
model UefiSettings {
  /**
   * Specifies whether secure boot should be enabled on the virtual machine. Minimum api-version: 2020-12-01.
   */
  secureBootEnabled?: boolean;

  /**
   * Specifies whether vTPM should be enabled on the virtual machine. Minimum api-version: 2020-12-01.
   */
  vTpmEnabled?: boolean;
}

/**
 * Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.
 */
model DiagnosticsProfile {
  /**
   * Boot Diagnostics is a debugging feature which allows you to view Console Output and Screenshot to diagnose VM status. **NOTE**: If storageUri is being specified then ensure that the storage account is in the same region and subscription as the VM. You can easily view the output of your console log. Azure also enables you to see a screenshot of the VM from the hypervisor.
   */
  bootDiagnostics?: BootDiagnostics;
}

/**
 * Boot Diagnostics is a debugging feature which allows you to view Console Output and Screenshot to diagnose VM status. You can easily view the output of your console log. Azure also enables you to see a screenshot of the VM from the hypervisor.
 */
model BootDiagnostics {
  /**
   * Whether boot diagnostics should be enabled on the Virtual Machine.
   */
  enabled?: boolean;

  /**
   * Uri of the storage account to use for placing the console output and screenshot. If storageUri is not specified while enabling boot diagnostics, managed storage will be used.
   */
  storageUri?: string;
}

/**
 * Describes a virtual machine scale set extension profile.
 */
model VirtualMachineScaleSetExtensionProfile {
  /**
   * The virtual machine scale set child extension resources.
   */
  extensions?: VirtualMachineScaleSetExtension[];

  /**
   * Specifies the time alloted for all extensions to start. The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format. The default value is 90 minutes (PT1H30M). Minimum api-version: 2020-06-01.
   */
  extensionsTimeBudget?: string;
}

/**
 * Describes the properties of a Virtual Machine Scale Set Extension.
 */
model VirtualMachineScaleSetExtensionProperties {
  /**
   * If a value is provided and is different from the previous value, the extension handler will be forced to update even if the extension configuration has not changed.
   */
  forceUpdateTag?: string;

  /**
   * The name of the extension handler publisher.
   */
  publisher?: string;

  /**
   * Specifies the type of the extension; an example is "CustomScriptExtension".
   */
  type?: string;

  /**
   * Specifies the version of the script handler.
   */
  typeHandlerVersion?: string;

  /**
   * Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.
   */
  autoUpgradeMinorVersion?: boolean;

  /**
   * Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.
   */
  enableAutomaticUpgrade?: boolean;

  /**
   * Json formatted public settings for the extension.
   */
  settings?: Record<unknown>;

  /**
   * The extension can contain either protectedSettings or protectedSettingsFromKeyVault or no protected settings at all.
   */
  protectedSettings?: Record<unknown>;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Collection of extension names after which this extension needs to be provisioned.
   */
  provisionAfterExtensions?: string[];

  /**
   * Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false.
   */
  suppressFailures?: boolean;

  /**
   * The extensions protected settings that are passed by reference, and consumed from key vault
   */
  protectedSettingsFromKeyVault?: KeyVaultSecretReference;
}

/**
 * Describes a reference to Key Vault Secret
 */
model KeyVaultSecretReference {
  /**
   * The URL referencing a secret in a Key Vault.
   */
  secretUrl: string;

  /**
   * The relative URL of the Key Vault containing the secret.
   */
  sourceVault: SubResource;
}

model SubResourceReadOnly {
  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;
}

/**
 * Specifies the billing related details of a Azure Spot VM or VMSS. Minimum api-version: 2019-03-01.
 */
model BillingProfile {
  /**
   * Specifies the maximum price you are willing to pay for a Azure Spot VM/VMSS. This price is in US Dollars. <br><br> This price will be compared with the current Azure Spot price for the VM size. Also, the prices are compared at the time of create/update of Azure Spot VM/VMSS and the operation will only succeed if  the maxPrice is greater than the current Azure Spot price. <br><br> The maxPrice will also be used for evicting a Azure Spot VM/VMSS if the current Azure Spot price goes beyond the maxPrice after creation of VM/VMSS. <br><br> Possible values are: <br><br> - Any decimal value greater than zero. Example: 0.01538 <br><br> -1 – indicates default price to be up-to on-demand. <br><br> You can set the maxPrice to -1 to indicate that the Azure Spot VM/VMSS should not be evicted for price reasons. Also, the default max price is -1 if it is not provided by you. <br><br>Minimum api-version: 2019-03-01.
   */
  maxPrice?: float64;
}

model ScheduledEventsProfile {
  /**
   * Specifies Terminate Scheduled Event related configurations.
   */
  terminateNotificationProfile?: TerminateNotificationProfile;

  /**
   * Specifies OS Image Scheduled Event related configurations.
   */
  osImageNotificationProfile?: OSImageNotificationProfile;
}

model TerminateNotificationProfile {
  /**
   * Configurable length of time a Virtual Machine being deleted will have to potentially approve the Terminate Scheduled Event before the event is auto approved (timed out). The configuration must be specified in ISO 8601 format, the default value is 5 minutes (PT5M)
   */
  notBeforeTimeout?: string;

  /**
   * Specifies whether the Terminate Scheduled event is enabled or disabled.
   */
  enable?: boolean;
}

model OSImageNotificationProfile {
  /**
   * Length of time a Virtual Machine being reimaged or having its OS upgraded will have to potentially approve the OS Image Scheduled Event before the event is auto approved (timed out). The configuration is specified in ISO 8601 format, and the value must be 15 minutes (PT15M)
   */
  notBeforeTimeout?: string;

  /**
   * Specifies whether the OS Image Scheduled event is enabled or disabled.
   */
  enable?: boolean;
}

/**
 * The parameters of a capacity reservation Profile.
 */
model CapacityReservationProfile {
  /**
   * Specifies the capacity reservation group resource id that should be used for allocating the virtual machine or scaleset vm instances provided enough capacity has been reserved. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  capacityReservationGroup?: SubResource;
}

/**
 * Contains the list of gallery applications that should be made available to the VM/VMSS
 */
model ApplicationProfile {
  /**
   * Specifies the gallery applications that should be made available to the VM/VMSS
   */
  galleryApplications?: VMGalleryApplication[];
}

/**
 * Specifies the required information to reference a compute gallery application version
 */
model VMGalleryApplication {
  /**
   * Optional, Specifies a passthrough value for more generic context.
   */
  tags?: string;

  /**
   * Optional, Specifies the order in which the packages have to be installed
   */
  order?: int32;

  /**
   * Specifies the GalleryApplicationVersion resource id on the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{application}/versions/{version}
   */
  packageReferenceId: string;

  /**
   * Optional, Specifies the uri to an azure blob that will replace the default configuration for the package if provided
   */
  configurationReference?: string;

  /**
   * Optional, If true, any failure for any operation in the VmApplication will fail the deployment
   */
  treatFailureAsDeploymentFailure?: boolean;

  /**
   * If set to true, when a new Gallery Application version is available in PIR/SIG, it will be automatically updated for the VM/VMSS
   */
  enableAutomaticUpgrade?: boolean;
}

/**
 * Specifies the hardware settings for the virtual machine scale set.
 */
model VirtualMachineScaleSetHardwareProfile {
  /**
   * Specifies the properties for customizing the size of the virtual machine. Minimum api-version: 2021-11-01. Please follow the instructions in [VM Customization](https://aka.ms/vmcustomization) for more details.
   */
  vmSizeProperties?: VMSizeProperties;
}

/**
 * Specifies VM Size Property settings on the virtual machine.
 */
model VMSizeProperties {
  /**
   * Specifies the number of vCPUs available for the VM. When this property is not specified in the request body the default behavior is to set it to the value of vCPUs available for that VM size exposed in api response of [List all available virtual machine sizes in a region](https://docs.microsoft.com/en-us/rest/api/compute/resource-skus/list).
   */
  vCPUsAvailable?: int32;

  /**
   * Specifies the vCPU to physical core ratio. When this property is not specified in the request body the default behavior is set to the value of vCPUsPerCore for the VM Size exposed in api response of [List all available virtual machine sizes in a region](https://docs.microsoft.com/en-us/rest/api/compute/resource-skus/list). **Setting this property to 1 also means that hyper-threading is disabled.**
   */
  vCPUsPerCore?: int32;
}

/**
 * Specifies the service artifact reference id used to set same image version for all virtual machines in the scale set when using 'latest' image version. Minimum api-version: 2022-11-01
 */
model ServiceArtifactReference {
  /**
   * The service artifact reference id in the form of /subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/galleries/{galleryName}/serviceArtifacts/{serviceArtifactName}/vmArtifactsProfiles/{vmArtifactsProfilesName}
   */
  id?: string;
}

/**
 * Specifies the security posture to be used for all virtual machines in the scale set. Minimum api-version: 2023-03-01
 */
model SecurityPostureReference {
  /**
   * The security posture reference id in the form of /CommunityGalleries/{communityGalleryName}/securityPostures/{securityPostureName}/versions/{major.minor.patch}|{major.*}|latest
   */
  id?: string;

  /**
   * List of virtual machine extensions to exclude when applying the Security Posture.
   */
  excludeExtensions?: VirtualMachineExtension[];
}

/**
 * Describes the properties of a Virtual Machine Extension.
 */
model VirtualMachineExtensionProperties {
  /**
   * How the extension handler should be forced to update even if the extension configuration has not changed.
   */
  forceUpdateTag?: string;

  /**
   * The name of the extension handler publisher.
   */
  publisher?: string;

  /**
   * Specifies the type of the extension; an example is "CustomScriptExtension".
   */
  type?: string;

  /**
   * Specifies the version of the script handler.
   */
  typeHandlerVersion?: string;

  /**
   * Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.
   */
  autoUpgradeMinorVersion?: boolean;

  /**
   * Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.
   */
  enableAutomaticUpgrade?: boolean;

  /**
   * Json formatted public settings for the extension.
   */
  settings?: Record<unknown>;

  /**
   * The extension can contain either protectedSettings or protectedSettingsFromKeyVault or no protected settings at all.
   */
  protectedSettings?: Record<unknown>;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The virtual machine extension instance view.
   */
  instanceView?: VirtualMachineExtensionInstanceView;

  /**
   * Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false.
   */
  suppressFailures?: boolean;

  /**
   * The extensions protected settings that are passed by reference, and consumed from key vault
   */
  protectedSettingsFromKeyVault?: KeyVaultSecretReference;

  /**
   * Collection of extension names after which this extension needs to be provisioned.
   */
  provisionAfterExtensions?: string[];
}

/**
 * The instance view of a virtual machine extension.
 */
model VirtualMachineExtensionInstanceView {
  /**
   * The virtual machine extension name.
   */
  name?: string;

  /**
   * Specifies the type of the extension; an example is "CustomScriptExtension".
   */
  type?: string;

  /**
   * Specifies the version of the script handler.
   */
  typeHandlerVersion?: string;

  /**
   * The resource status information.
   */
  substatuses?: InstanceViewStatus[];

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * Instance view status.
 */
model InstanceViewStatus {
  /**
   * The status code.
   */
  code?: string;

  /**
   * The level code.
   */
  level?: StatusLevelTypes;

  /**
   * The short localizable label for the status.
   */
  displayStatus?: string;

  /**
   * The detailed status message, including for alerts and error messages.
   */
  message?: string;

  /**
   * The time of the status.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  time?: utcDateTime;
}

/**
 * The Resource model definition with location property as optional.
 */
model ResourceWithOptionalLocation {
  /**
   * Resource location
   */
  location?: string;

  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Enables or disables a capability on the virtual machine or virtual machine scale set.
 */
model AdditionalCapabilities {
  /**
   * The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.
   */
  ultraSSDEnabled?: boolean;

  /**
   * The flag that enables or disables hibernation capability on the VM.
   */
  hibernationEnabled?: boolean;
}

/**
 * Describes a scale-in policy for a virtual machine scale set.
 */
model ScaleInPolicy {
  /**
   * The rules to be followed when scaling-in a virtual machine scale set. <br><br> Possible values are: <br><br> **Default** When a virtual machine scale set is scaled in, the scale set will first be balanced across zones if it is a zonal scale set. Then, it will be balanced across Fault Domains as far as possible. Within each Fault Domain, the virtual machines chosen for removal will be the newest ones that are not protected from scale-in. <br><br> **OldestVM** When a virtual machine scale set is being scaled-in, the oldest virtual machines that are not protected from scale-in will be chosen for removal. For zonal virtual machine scale sets, the scale set will first be balanced across zones. Within each zone, the oldest virtual machines that are not protected will be chosen for removal. <br><br> **NewestVM** When a virtual machine scale set is being scaled-in, the newest virtual machines that are not protected from scale-in will be chosen for removal. For zonal virtual machine scale sets, the scale set will first be balanced across zones. Within each zone, the newest virtual machines that are not protected will be chosen for removal. <br><br>
   */
  rules?: VirtualMachineScaleSetScaleInRules[];

  /**
   * This property allows you to specify if virtual machines chosen for removal have to be force deleted when a virtual machine scale set is being scaled-in.(Feature in Preview)
   */
  forceDeletion?: boolean;
}

/**
 * Specifies the Spot-Try-Restore properties for the virtual machine scale set. With this property customer can enable or disable automatic restore of the evicted Spot VMSS VM instances opportunistically based on capacity availability and pricing constraint.
 */
model SpotRestorePolicy {
  /**
   * Enables the Spot-Try-Restore feature where evicted VMSS SPOT instances will be tried to be restored opportunistically based on capacity availability and pricing constraints
   */
  enabled?: boolean;

  /**
   * Timeout value expressed as an ISO 8601 time duration after which the platform will not try to restore the VMSS SPOT instances
   */
  restoreTimeout?: string;
}

/**
 * Specifies the target splits for Spot and Regular priority VMs within a scale set with flexible orchestration mode. With this property the customer is able to specify the base number of regular priority VMs created as the VMSS flex instance scales out and the split between Spot and Regular priority VMs after this base target has been reached.
 */
model PriorityMixPolicy {
  /**
   * The base number of regular priority VMs that will be created in this scale set as it scales out.
   */
  baseRegularPriorityCount?: int32;

  /**
   * The percentage of VM instances, after the base regular priority count has been reached, that are expected to use regular priority.
   */
  @maxValue(100)
  regularPriorityPercentageAboveBase?: int32;
}

/**
 * Identity for the virtual machine scale set.
 */
model VirtualMachineScaleSetIdentity {
  /**
   * The principal id of virtual machine scale set identity. This property will only be provided for a system assigned identity.
   */
  @visibility("read")
  principalId?: string;

  /**
   * The tenant id associated with the virtual machine scale set. This property will only be provided for a system assigned identity.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * The type of identity used for the virtual machine scale set. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the virtual machine scale set.
   */
  type?: ResourceIdentityType;

  /**
   * The list of user identities associated with the virtual machine scale set. The user identity dictionary key references will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

model UserAssignedIdentitiesValue {
  /**
   * The principal id of user assigned identity.
   */
  @visibility("read")
  principalId?: string;

  /**
   * The client id of user assigned identity.
   */
  @visibility("read")
  clientId?: string;
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
 * The Resource model definition.
 */
model Resource {
  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Resource location
   */
  location: string;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Describes a Virtual Machine Scale Set.
 */
model VirtualMachineScaleSetUpdate extends UpdateResource {
  /**
   * The virtual machine scale set sku.
   */
  sku?: Sku;

  /**
   * The purchase plan when deploying a virtual machine scale set from VM Marketplace images.
   */
  plan?: Plan;

  /**
   * Describes the properties of a Virtual Machine Scale Set.
   */
  properties?: VirtualMachineScaleSetUpdateProperties;

  /**
   * The identity of the virtual machine scale set, if configured.
   */
  identity?: VirtualMachineScaleSetIdentity;
}

/**
 * Describes the properties of a Virtual Machine Scale Set.
 */
model VirtualMachineScaleSetUpdateProperties {
  /**
   * The upgrade policy.
   */
  upgradePolicy?: UpgradePolicy;

  /**
   * Policy for automatic repairs.
   */
  automaticRepairsPolicy?: AutomaticRepairsPolicy;

  /**
   * The virtual machine profile.
   */
  virtualMachineProfile?: VirtualMachineScaleSetUpdateVMProfile;

  /**
   * Specifies whether the Virtual Machine Scale Set should be overprovisioned.
   */
  overprovision?: boolean;

  /**
   * When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs.
   */
  doNotRunExtensionsOnOverprovisionedVMs?: boolean;

  /**
   * When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true.
   */
  singlePlacementGroup?: boolean;

  /**
   * Specifies additional capabilities enabled or disabled on the Virtual Machines in the Virtual Machine Scale Set. For instance: whether the Virtual Machines have the capability to support attaching managed data disks with UltraSSD_LRS storage account type.
   */
  additionalCapabilities?: AdditionalCapabilities;

  /**
   * Specifies the policies applied when scaling in Virtual Machines in the Virtual Machine Scale Set.
   */
  scaleInPolicy?: ScaleInPolicy;

  /**
   * Specifies information about the proximity placement group that the virtual machine scale set should be assigned to. <br><br>Minimum api-version: 2018-04-01.
   */
  proximityPlacementGroup?: SubResource;

  /**
   * Specifies the desired targets for mixing Spot and Regular priority VMs within the same VMSS Flex instance.
   */
  priorityMixPolicy?: PriorityMixPolicy;

  /**
   * Specifies the Spot Restore properties for the virtual machine scale set.
   */
  spotRestorePolicy?: SpotRestorePolicy;
}

/**
 * Describes a virtual machine scale set virtual machine profile.
 */
model VirtualMachineScaleSetUpdateVMProfile {
  /**
   * The virtual machine scale set OS profile.
   */
  osProfile?: VirtualMachineScaleSetUpdateOSProfile;

  /**
   * The virtual machine scale set storage profile.
   */
  storageProfile?: VirtualMachineScaleSetUpdateStorageProfile;

  /**
   * The virtual machine scale set network profile.
   */
  networkProfile?: VirtualMachineScaleSetUpdateNetworkProfile;

  /**
   * The virtual machine scale set Security profile
   */
  securityProfile?: SecurityProfile;

  /**
   * The virtual machine scale set diagnostics profile.
   */
  diagnosticsProfile?: DiagnosticsProfile;

  /**
   * The virtual machine scale set extension profile.
   */
  extensionProfile?: VirtualMachineScaleSetExtensionProfile;

  /**
   * The license type, which is for bring your own license scenario.
   */
  licenseType?: string;

  /**
   * Specifies the billing related details of a Azure Spot VMSS. Minimum api-version: 2019-03-01.
   */
  billingProfile?: BillingProfile;

  /**
   * Specifies Scheduled Event related configurations.
   */
  scheduledEventsProfile?: ScheduledEventsProfile;

  /**
   * UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here. <br><br>Minimum api-version: 2021-03-01
   */
  userData?: string;

  /**
   * Specifies the hardware profile related details of a scale set. Minimum api-version: 2021-11-01.
   */
  hardwareProfile?: VirtualMachineScaleSetHardwareProfile;
}

/**
 * Describes a virtual machine scale set OS profile.
 */
model VirtualMachineScaleSetUpdateOSProfile {
  /**
   * A base-64 encoded string of custom data.
   */
  customData?: string;

  /**
   * The Windows Configuration of the OS profile.
   */
  windowsConfiguration?: WindowsConfiguration;

  /**
   * The Linux Configuration of the OS profile.
   */
  linuxConfiguration?: LinuxConfiguration;

  /**
   * The List of certificates for addition to the VM.
   */
  secrets?: VaultSecretGroup[];
}

/**
 * Describes a virtual machine scale set storage profile.
 */
model VirtualMachineScaleSetUpdateStorageProfile {
  /**
   * The image reference.
   */
  imageReference?: ImageReference;

  /**
   * The OS disk.
   */
  osDisk?: VirtualMachineScaleSetUpdateOSDisk;

  /**
   * The data disks.
   */
  dataDisks?: VirtualMachineScaleSetDataDisk[];

  diskControllerType?: string;
}

/**
 * Describes virtual machine scale set operating system disk Update Object. This should be used for Updating VMSS OS Disk.
 */
model VirtualMachineScaleSetUpdateOSDisk {
  /**
   * The caching type.
   */
  caching?: CachingTypes;

  /**
   * Specifies whether writeAccelerator should be enabled or disabled on the disk.
   */
  writeAcceleratorEnabled?: boolean;

  /**
   * Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. <br><br> diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be larger than 1023
   */
  diskSizeGB?: int32;

  /**
   * The Source User Image VirtualHardDisk. This VirtualHardDisk will be copied before using it to attach to the Virtual Machine. If SourceImage is provided, the destination VirtualHardDisk should not exist.
   */
  image?: VirtualHardDisk;

  /**
   * The list of virtual hard disk container uris.
   */
  vhdContainers?: string[];

  /**
   * The managed disk parameters.
   */
  managedDisk?: VirtualMachineScaleSetManagedDiskParameters;

  /**
   * Specifies whether OS Disk should be deleted or detached upon VMSS Flex deletion (This feature is available for VMSS with Flexible OrchestrationMode only). <br><br> Possible values: <br><br> **Delete** If this value is used, the OS disk is deleted when VMSS Flex VM is deleted.<br><br> **Detach** If this value is used, the OS disk is retained after VMSS Flex VM is deleted. <br><br> The default value is set to **Delete**. For an Ephemeral OS Disk, the default value is set to **Delete**. User cannot change the delete option for Ephemeral OS Disk.
   */
  deleteOption?: DiskDeleteOptionTypes;
}

/**
 * Describes a virtual machine scale set network profile.
 */
model VirtualMachineScaleSetUpdateNetworkProfile {
  /**
   * A reference to a load balancer probe used to determine the health of an instance in the virtual machine scale set. The reference will be in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}/probes/{probeName}'.
   */
  healthProbe?: ApiEntityReference;

  /**
   * The list of network configurations.
   */
  networkInterfaceConfigurations?: VirtualMachineScaleSetUpdateNetworkConfiguration[];

  /**
   * specifies the Microsoft.Network API version used when creating networking resources in the Network Interface Configurations for Virtual Machine Scale Set with orchestration mode 'Flexible'
   */
  networkApiVersion?: NetworkApiVersion;
}

/**
 * Describes a virtual machine scale set network profile's network configurations.
 */
model VirtualMachineScaleSetUpdateNetworkConfiguration {
  /**
   * The network configuration name.
   */
  name?: string;

  /**
   * Describes a virtual machine scale set updatable network profile's IP configuration.Use this object for updating network profile's IP Configuration.
   */
  properties?: VirtualMachineScaleSetUpdateNetworkConfigurationProperties;
}

/**
 * Describes a virtual machine scale set updatable network profile's IP configuration.Use this object for updating network profile's IP Configuration.
 */
model VirtualMachineScaleSetUpdateNetworkConfigurationProperties {
  /**
   * Whether this is a primary NIC on a virtual machine.
   */
  primary?: boolean;

  /**
   * Specifies whether the network interface is accelerated networking-enabled.
   */
  enableAcceleratedNetworking?: boolean;

  /**
   * Specifies whether the network interface is disabled for tcp state tracking.
   */
  disableTcpStateTracking?: boolean;

  /**
   * Specifies whether the network interface is FPGA networking-enabled.
   */
  enableFpga?: boolean;

  /**
   * The network security group.
   */
  networkSecurityGroup?: SubResource;

  /**
   * The dns settings to be applied on the network interfaces.
   */
  dnsSettings?: VirtualMachineScaleSetNetworkConfigurationDnsSettings;

  /**
   * The virtual machine scale set IP Configuration.
   */
  ipConfigurations?: VirtualMachineScaleSetUpdateIPConfiguration[];

  /**
   * Whether IP forwarding enabled on this NIC.
   */
  enableIPForwarding?: boolean;

  /**
   * Specify what happens to the network interface when the VM is deleted
   */
  deleteOption?: DeleteOptions;

  /**
   * Specifies whether the Auxiliary mode is enabled for the Network Interface resource.
   */
  auxiliaryMode?: NetworkInterfaceAuxiliaryMode;

  /**
   * Specifies whether the Auxiliary sku is enabled for the Network Interface resource.
   */
  auxiliarySku?: NetworkInterfaceAuxiliarySku;
}

/**
 * Describes a virtual machine scale set network profile's IP configuration. NOTE: The subnet of a scale set may be modified as long as the original subnet and the new subnet are in the same virtual network
 */
model VirtualMachineScaleSetUpdateIPConfiguration {
  /**
   * The IP configuration name.
   */
  name?: string;

  /**
   * Describes a virtual machine scale set network profile's IP configuration properties.
   */
  properties?: VirtualMachineScaleSetUpdateIPConfigurationProperties;
}

/**
 * Describes a virtual machine scale set network profile's IP configuration properties.
 */
model VirtualMachineScaleSetUpdateIPConfigurationProperties {
  /**
   * The subnet.
   */
  subnet?: ApiEntityReference;

  /**
   * Specifies the primary IP Configuration in case the network interface has more than one IP Configuration.
   */
  primary?: boolean;

  /**
   * The publicIPAddressConfiguration.
   */
  publicIPAddressConfiguration?: VirtualMachineScaleSetUpdatePublicIPAddressConfiguration;

  /**
   * Available from Api-Version 2017-03-30 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible values are: 'IPv4' and 'IPv6'.
   */
  privateIPAddressVersion?: IPVersion;

  /**
   * The application gateway backend address pools.
   */
  applicationGatewayBackendAddressPools?: SubResource[];

  /**
   * Specifies an array of references to application security group.
   */
  applicationSecurityGroups?: SubResource[];

  /**
   * The load balancer backend address pools.
   */
  loadBalancerBackendAddressPools?: SubResource[];

  /**
   * The load balancer inbound nat pools.
   */
  loadBalancerInboundNatPools?: SubResource[];
}

/**
 * Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration
 */
model VirtualMachineScaleSetUpdatePublicIPAddressConfiguration {
  /**
   * The publicIP address configuration name.
   */
  name?: string;

  /**
   * Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration
   */
  properties?: VirtualMachineScaleSetUpdatePublicIPAddressConfigurationProperties;
}

/**
 * Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration
 */
model VirtualMachineScaleSetUpdatePublicIPAddressConfigurationProperties {
  /**
   * The idle timeout of the public IP address.
   */
  idleTimeoutInMinutes?: int32;

  /**
   * The dns settings to be applied on the publicIP addresses .
   */
  dnsSettings?: VirtualMachineScaleSetPublicIPAddressConfigurationDnsSettings;

  /**
   * The PublicIPPrefix from which to allocate publicIP addresses.
   */
  publicIPPrefix?: SubResource;

  /**
   * Specify what happens to the public IP when the VM is deleted
   */
  deleteOption?: DeleteOptions;
}

/**
 * The Update Resource model definition.
 */
model UpdateResource {
  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Specifies a list of virtual machine instance IDs from the VM scale set.
 */
model VirtualMachineScaleSetVMInstanceIDs {
  /**
   * The virtual machine scale set instance ids. Omitting the virtual machine scale set instance ids will result in the operation being performed on all virtual machines in the virtual machine scale set.
   */
  instanceIds?: string[];
}

/**
 * Specifies a list of virtual machine instance IDs from the VM scale set.
 */
model VirtualMachineScaleSetVMInstanceRequiredIDs {
  /**
   * The virtual machine scale set instance ids.
   */
  instanceIds: string[];
}

/**
 * The instance view of a virtual machine scale set.
 */
model VirtualMachineScaleSetInstanceView {
  /**
   * The instance view status summary for the virtual machine scale set.
   */
  @visibility("read")
  virtualMachine?: VirtualMachineScaleSetInstanceViewStatusesSummary;

  /**
   * The extensions information.
   */
  @visibility("read")
  extensions?: VirtualMachineScaleSetVMExtensionsSummary[];

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];

  /**
   * The orchestration services information.
   */
  @visibility("read")
  orchestrationServices?: OrchestrationServiceSummary[];
}

/**
 * Instance view statuses summary for virtual machines of a virtual machine scale set.
 */
model VirtualMachineScaleSetInstanceViewStatusesSummary {
  /**
   * The extensions information.
   */
  @visibility("read")
  statusesSummary?: VirtualMachineStatusCodeCount[];
}

/**
 * The status code and count of the virtual machine scale set instance view status summary.
 */
model VirtualMachineStatusCodeCount {
  /**
   * The instance view status code.
   */
  @visibility("read")
  code?: string;

  /**
   * The number of instances having a particular status code.
   */
  @visibility("read")
  count?: int32;
}

/**
 * Extensions summary for virtual machines of a virtual machine scale set.
 */
model VirtualMachineScaleSetVMExtensionsSummary {
  /**
   * The extension name.
   */
  @visibility("read")
  name?: string;

  /**
   * The extensions information.
   */
  @visibility("read")
  statusesSummary?: VirtualMachineStatusCodeCount[];
}

/**
 * Summary for an orchestration service of a virtual machine scale set.
 */
model OrchestrationServiceSummary {
  /**
   * The name of the service.
   */
  @visibility("read")
  serviceName?: OrchestrationServiceNames;

  /**
   * The current state of the service.
   */
  @visibility("read")
  serviceState?: OrchestrationServiceState;
}

/**
 * Describes a Virtual Machine Scale Set Extension.
 */
model VirtualMachineScaleSetExtensionUpdate extends SubResourceReadOnly {
  /**
   * The name of the extension.
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Describes the properties of a Virtual Machine Scale Set Extension.
   */
  properties?: VirtualMachineScaleSetExtensionProperties;
}

/**
 * The Virtual Machine Scale Set List Skus operation response.
 */
model VirtualMachineScaleSetListSkusResult
  is Azure.Core.Page<VirtualMachineScaleSetSku>;

/**
 * Describes an available virtual machine scale set sku.
 */
model VirtualMachineScaleSetSku {
  /**
   * The type of resource the sku applies to.
   */
  @visibility("read")
  resourceType?: string;

  /**
   * The Sku.
   */
  @visibility("read")
  sku?: Sku;

  /**
   * Specifies the number of virtual machines in the scale set.
   */
  @visibility("read")
  capacity?: VirtualMachineScaleSetSkuCapacity;
}

/**
 * Describes scaling information of a sku.
 */
model VirtualMachineScaleSetSkuCapacity {
  /**
   * The minimum capacity.
   */
  @visibility("read")
  minimum?: int64;

  /**
   * The maximum capacity that can be set.
   */
  @visibility("read")
  maximum?: int64;

  /**
   * The default capacity.
   */
  @visibility("read")
  defaultCapacity?: int64;

  /**
   * The scale type applicable to the sku.
   */
  @visibility("read")
  scaleType?: VirtualMachineScaleSetSkuScaleType;
}

/**
 * List of Virtual Machine Scale Set OS Upgrade History operation response.
 */
model VirtualMachineScaleSetListOSUpgradeHistory
  is Azure.Core.Page<UpgradeOperationHistoricalStatusInfo>;

/**
 * Virtual Machine Scale Set OS Upgrade History operation response.
 */
model UpgradeOperationHistoricalStatusInfo {
  /**
   * Information about the properties of the upgrade operation.
   */
  @visibility("read")
  properties?: UpgradeOperationHistoricalStatusInfoProperties;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Resource location
   */
  @visibility("read")
  location?: string;
}

/**
 * Describes each OS upgrade on the Virtual Machine Scale Set.
 */
model UpgradeOperationHistoricalStatusInfoProperties {
  /**
   * Information about the overall status of the upgrade operation.
   */
  @visibility("read")
  runningStatus?: UpgradeOperationHistoryStatus;

  /**
   * Counts of the VMs in each state.
   */
  @visibility("read")
  progress?: RollingUpgradeProgressInfo;

  /**
   * Error Details for this upgrade if there are any.
   */
  @visibility("read")
  error?: ApiError;

  /**
   * Invoker of the Upgrade Operation
   */
  @visibility("read")
  startedBy?: UpgradeOperationInvoker;

  /**
   * Image Reference details
   */
  @visibility("read")
  targetImageReference?: ImageReference;

  /**
   * Information about OS rollback if performed
   */
  @visibility("read")
  rollbackInfo?: RollbackStatusInfo;
}

/**
 * Information about the current running state of the overall upgrade.
 */
model UpgradeOperationHistoryStatus {
  /**
   * Code indicating the current status of the upgrade.
   */
  @visibility("read")
  code?: UpgradeState;

  /**
   * Start time of the upgrade.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * End time of the upgrade.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;
}

/**
 * Information about the number of virtual machine instances in each upgrade state.
 */
model RollingUpgradeProgressInfo {
  /**
   * The number of instances that have been successfully upgraded.
   */
  @visibility("read")
  successfulInstanceCount?: int32;

  /**
   * The number of instances that have failed to be upgraded successfully.
   */
  @visibility("read")
  failedInstanceCount?: int32;

  /**
   * The number of instances that are currently being upgraded.
   */
  @visibility("read")
  inProgressInstanceCount?: int32;

  /**
   * The number of instances that have not yet begun to be upgraded.
   */
  @visibility("read")
  pendingInstanceCount?: int32;
}

/**
 * Information about rollback on failed VM instances after a OS Upgrade operation.
 */
model RollbackStatusInfo {
  /**
   * The number of instances which have been successfully rolled back.
   */
  @visibility("read")
  successfullyRolledbackInstanceCount?: int32;

  /**
   * The number of instances which failed to rollback.
   */
  @visibility("read")
  failedRolledbackInstanceCount?: int32;

  /**
   * Error details if OS rollback failed.
   */
  @visibility("read")
  rollbackError?: ApiError;
}

/**
 * Describes a Virtual Machine Scale Set VM Reimage Parameters.
 */
model VirtualMachineScaleSetReimageParameters
  extends VirtualMachineScaleSetVMReimageParameters {
  /**
   * The virtual machine scale set instance ids. Omitting the virtual machine scale set instance ids will result in the operation being performed on all virtual machines in the virtual machine scale set.
   */
  instanceIds?: string[];
}

/**
 * Describes a Virtual Machine Scale Set VM Reimage Parameters.
 */
model VirtualMachineScaleSetVMReimageParameters
  extends VirtualMachineReimageParameters {}

/**
 * Parameters for Reimaging Virtual Machine. NOTE: Virtual Machine OS disk will always be reimaged
 */
model VirtualMachineReimageParameters {
  /**
   * Specifies whether to reimage temp disk. Default value: false. Note: This temp disk reimage parameter is only supported for VM/VMSS with Ephemeral OS disk.
   */
  tempDisk?: boolean;

  /**
   * Specifies in decimal number, the version the OS disk should be reimaged to. If exact version is not provided, the OS disk is reimaged to the existing version of OS Disk.
   */
  exactVersion?: string;

  /**
   * Specifies information required for reimaging the non-ephemeral OS disk.
   */
  osProfile?: OSProfileProvisioningData;
}

/**
 * Additional parameters for Reimaging Non-Ephemeral Virtual Machine.
 */
model OSProfileProvisioningData {
  @doc("Specifies the password of the administrator account. <br><br> **Minimum-length (Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters <br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length (Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4 conditions below need to be fulfilled <br> Has lower characters <br>Has upper characters <br> Has a digit <br> Has a special character (Regex match [\\W_]) <br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\", \"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\", \"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to reset the Remote Desktop service or its login password in a Windows VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp) <br><br> For resetting root password, see [Manage users, SSH, and check or repair disks on Azure Linux VMs using the VMAccess Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)")
  adminPassword?: string;

  /**
   * Specifies a base-64 encoded string of custom data. The base-64 encoded string is decoded to a binary array that is saved as a file on the Virtual Machine. The maximum length of the binary array is 65535 bytes. **Note: Do not pass any secrets or passwords in customData property.** This property cannot be updated after the VM is created. The property customData is passed to the VM to be saved as a file, for more information see [Custom Data on Azure VMs](https://azure.microsoft.com/blog/custom-data-and-cloud-init-on-windows-azure/). If using cloud-init for your Linux VM, see [Using cloud-init to customize a Linux VM during creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init).
   */
  customData?: string;
}

/**
 * The status of the latest virtual machine scale set rolling upgrade.
 */
model RollingUpgradeStatusInfoProperties {
  /**
   * The rolling upgrade policies applied for this upgrade.
   */
  @visibility("read")
  policy?: RollingUpgradePolicy;

  /**
   * Information about the current running state of the overall upgrade.
   */
  @visibility("read")
  runningStatus?: RollingUpgradeRunningStatus;

  /**
   * Information about the number of virtual machine instances in each upgrade state.
   */
  @visibility("read")
  progress?: RollingUpgradeProgressInfo;

  /**
   * Error details for this upgrade, if there are any.
   */
  @visibility("read")
  error?: ApiError;
}

/**
 * Information about the current running state of the overall upgrade.
 */
model RollingUpgradeRunningStatus {
  /**
   * Code indicating the current status of the upgrade.
   */
  @visibility("read")
  code?: RollingUpgradeStatusCode;

  /**
   * Start time of the upgrade.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * The last action performed on the rolling upgrade.
   */
  @visibility("read")
  lastAction?: RollingUpgradeActionType;

  /**
   * Last action time of the upgrade.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastActionTime?: utcDateTime;
}

/**
 * Response after calling a manual recovery walk
 */
model RecoveryWalkResponse {
  /**
   * Whether the recovery walk was performed
   */
  @visibility("read")
  walkPerformed?: boolean;

  /**
   * The next update domain that needs to be walked. Null means walk spanning all update domains has been completed
   */
  @visibility("read")
  nextPlatformUpdateDomain?: int32;
}

model VMScaleSetConvertToSinglePlacementGroupInput {
  /**
   * Id of the placement group in which you want future virtual machine instances to be placed. To query placement group Id, please use Virtual Machine Scale Set VMs - Get API. If not provided, the platform will choose one with maximum number of virtual machine instances.
   */
  activePlacementGroupId?: string;
}

/**
 * The input for OrchestrationServiceState
 */
model OrchestrationServiceStateInput {
  /**
   * The name of the service.
   */
  serviceName: OrchestrationServiceNames;

  /**
   * The action to be performed.
   */
  action: OrchestrationServiceStateAction;
}

/**
 * Describes a VMSS VM Extension.
 */
model VirtualMachineScaleSetVMExtensionUpdate extends SubResourceReadOnly {
  /**
   * The name of the extension.
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Describes the properties of a Virtual Machine Extension.
   */
  properties?: VirtualMachineExtensionUpdateProperties;
}

/**
 * Describes the properties of a Virtual Machine Extension.
 */
model VirtualMachineExtensionUpdateProperties {
  /**
   * How the extension handler should be forced to update even if the extension configuration has not changed.
   */
  forceUpdateTag?: string;

  /**
   * The name of the extension handler publisher.
   */
  publisher?: string;

  /**
   * Specifies the type of the extension; an example is "CustomScriptExtension".
   */
  type?: string;

  /**
   * Specifies the version of the script handler.
   */
  typeHandlerVersion?: string;

  /**
   * Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.
   */
  autoUpgradeMinorVersion?: boolean;

  /**
   * Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.
   */
  enableAutomaticUpgrade?: boolean;

  /**
   * Json formatted public settings for the extension.
   */
  settings?: Record<unknown>;

  /**
   * The extension can contain either protectedSettings or protectedSettingsFromKeyVault or no protected settings at all.
   */
  protectedSettings?: Record<unknown>;

  /**
   * Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false.
   */
  suppressFailures?: boolean;

  /**
   * The extensions protected settings that are passed by reference, and consumed from key vault
   */
  protectedSettingsFromKeyVault?: KeyVaultSecretReference;
}

/**
 * Describes the properties of a virtual machine scale set virtual machine.
 */
model VirtualMachineScaleSetVMProperties {
  /**
   * Specifies whether the latest model has been applied to the virtual machine.
   */
  @visibility("read")
  latestModelApplied?: boolean;

  /**
   * Azure VM unique ID.
   */
  @visibility("read")
  vmId?: string;

  /**
   * The virtual machine instance view.
   */
  @visibility("read")
  instanceView?: VirtualMachineScaleSetVMInstanceView;

  /**
   * Specifies the hardware settings for the virtual machine.
   */
  hardwareProfile?: HardwareProfile;

  /**
   * Specifies the storage settings for the virtual machine disks.
   */
  storageProfile?: StorageProfile;

  /**
   * Specifies additional capabilities enabled or disabled on the virtual machine in the scale set. For instance: whether the virtual machine has the capability to support attaching managed data disks with UltraSSD_LRS storage account type.
   */
  additionalCapabilities?: AdditionalCapabilities;

  /**
   * Specifies the operating system settings for the virtual machine.
   */
  osProfile?: OSProfile;

  /**
   * Specifies the Security related profile settings for the virtual machine.
   */
  securityProfile?: SecurityProfile;

  /**
   * Specifies the network interfaces of the virtual machine.
   */
  networkProfile?: NetworkProfile;

  /**
   * Specifies the network profile configuration of the virtual machine.
   */
  networkProfileConfiguration?: VirtualMachineScaleSetVMNetworkProfileConfiguration;

  /**
   * Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.
   */
  diagnosticsProfile?: DiagnosticsProfile;

  /**
   * Specifies information about the availability set that the virtual machine should be assigned to. Virtual machines specified in the same availability set are allocated to different nodes to maximize availability. For more information about availability sets, see [Availability sets overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview). For more information on Azure planned maintenance, see [Maintenance and updates for Virtual Machines in Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates). Currently, a VM can only be added to availability set at creation time. An existing VM cannot be added to an availability set.
   */
  availabilitySet?: SubResource;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Specifies that the image or disk that is being used was licensed on-premises. <br><br> Possible values for Windows Server operating system are: <br><br> Windows_Client <br><br> Windows_Server <br><br> Possible values for Linux Server operating system are: <br><br> RHEL_BYOS (for RHEL) <br><br> SLES_BYOS (for SUSE) <br><br> For more information, see [Azure Hybrid Use Benefit for Windows Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing) <br><br> [Azure Hybrid Use Benefit for Linux Server](https://docs.microsoft.com/azure/virtual-machines/linux/azure-hybrid-benefit-linux) <br><br> Minimum api-version: 2015-06-15
   */
  licenseType?: string;

  /**
   * Specifies whether the model applied to the virtual machine is the model of the virtual machine scale set or the customized model for the virtual machine.
   */
  @visibility("read")
  modelDefinitionApplied?: string;

  /**
   * Specifies the protection policy of the virtual machine.
   */
  protectionPolicy?: VirtualMachineScaleSetVMProtectionPolicy;

  /**
   * UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here. <br><br>Minimum api-version: 2021-03-01
   */
  userData?: string;

  /**
   * Specifies the time at which the Virtual Machine resource was created.<br><br>Minimum api-version: 2021-11-01.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

/**
 * The instance view of a virtual machine scale set VM.
 */
model VirtualMachineScaleSetVMInstanceView {
  /**
   * The Update Domain count.
   */
  platformUpdateDomain?: int32;

  /**
   * The Fault Domain count.
   */
  platformFaultDomain?: int32;

  /**
   * The Remote desktop certificate thumbprint.
   */
  rdpThumbPrint?: string;

  /**
   * The VM Agent running on the virtual machine.
   */
  vmAgent?: VirtualMachineAgentInstanceView;

  /**
   * The Maintenance Operation status on the virtual machine.
   */
  maintenanceRedeployStatus?: MaintenanceRedeployStatus;

  /**
   * The disks information.
   */
  disks?: DiskInstanceView[];

  /**
   * The extensions information.
   */
  extensions?: VirtualMachineExtensionInstanceView[];

  /**
   * The health status for the VM.
   */
  @visibility("read")
  vmHealth?: VirtualMachineHealthStatus;

  /**
   * Boot Diagnostics is a debugging feature which allows you to view Console Output and Screenshot to diagnose VM status. You can easily view the output of your console log. Azure also enables you to see a screenshot of the VM from the hypervisor.
   */
  bootDiagnostics?: BootDiagnosticsInstanceView;

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];

  /**
   * Resource id of the dedicated host, on which the virtual machine is allocated through automatic placement, when the virtual machine is associated with a dedicated host group that has automatic placement enabled. Minimum api-version: 2020-06-01.
   */
  @visibility("read")
  assignedHost?: string;

  /**
   * The placement group in which the VM is running. If the VM is deallocated it will not have a placementGroupId.
   */
  placementGroupId?: string;

  /**
   * Specifies the host OS name of the virtual machine. <br><br> This name cannot be updated after the VM is created. <br><br> **Max-length (Windows):** 15 characters <br><br> **Max-length (Linux):** 64 characters. <br><br> For naming conventions and restrictions see [Azure infrastructure services implementation guidelines](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-linux-infrastructure-subscription-accounts-guidelines?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json#1-naming-conventions).
   */
  computerName?: string;

  /**
   * The Operating System running on the hybrid machine.
   */
  osName?: string;

  /**
   * The version of Operating System running on the hybrid machine.
   */
  osVersion?: string;

  /**
   * The hypervisor generation of the Virtual Machine [V1, V2]
   */
  hyperVGeneration?: HyperVGeneration;
}

/**
 * The instance view of the VM Agent running on the virtual machine.
 */
model VirtualMachineAgentInstanceView {
  /**
   * The VM Agent full version.
   */
  vmAgentVersion?: string;

  /**
   * The virtual machine extension handler instance view.
   */
  extensionHandlers?: VirtualMachineExtensionHandlerInstanceView[];

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * The instance view of a virtual machine extension handler.
 */
model VirtualMachineExtensionHandlerInstanceView {
  /**
   * Specifies the type of the extension; an example is "CustomScriptExtension".
   */
  type?: string;

  /**
   * Specifies the version of the script handler.
   */
  typeHandlerVersion?: string;

  /**
   * The extension handler status.
   */
  status?: InstanceViewStatus;
}

/**
 * Maintenance Operation Status.
 */
model MaintenanceRedeployStatus {
  /**
   * True, if customer is allowed to perform Maintenance.
   */
  isCustomerInitiatedMaintenanceAllowed?: boolean;

  /**
   * Start Time for the Pre Maintenance Window.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  preMaintenanceWindowStartTime?: utcDateTime;

  /**
   * End Time for the Pre Maintenance Window.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  preMaintenanceWindowEndTime?: utcDateTime;

  /**
   * Start Time for the Maintenance Window.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  maintenanceWindowStartTime?: utcDateTime;

  /**
   * End Time for the Maintenance Window.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  maintenanceWindowEndTime?: utcDateTime;

  /**
   * The Last Maintenance Operation Result Code.
   */
  lastOperationResultCode?: MaintenanceOperationResultCodeTypes;

  /**
   * Message returned for the last Maintenance Operation.
   */
  lastOperationMessage?: string;
}

/**
 * The instance view of the disk.
 */
model DiskInstanceView {
  /**
   * The disk name.
   */
  name?: string;

  /**
   * Specifies the encryption settings for the OS Disk. <br><br> Minimum api-version: 2015-06-15
   */
  encryptionSettings?: DiskEncryptionSettings[];

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * Describes a Encryption Settings for a Disk
 */
model DiskEncryptionSettings {
  /**
   * Specifies the location of the disk encryption key, which is a Key Vault Secret.
   */
  diskEncryptionKey?: KeyVaultSecretReference;

  /**
   * Specifies the location of the key encryption key in Key Vault.
   */
  keyEncryptionKey?: KeyVaultKeyReference;

  /**
   * Specifies whether disk encryption should be enabled on the virtual machine.
   */
  enabled?: boolean;
}

/**
 * Describes a reference to Key Vault Key
 */
model KeyVaultKeyReference {
  /**
   * The URL referencing a key encryption key in Key Vault.
   */
  keyUrl: string;

  /**
   * The relative URL of the Key Vault containing the key.
   */
  sourceVault: SubResource;
}

/**
 * The health status of the VM.
 */
model VirtualMachineHealthStatus {
  /**
   * The health status information for the VM.
   */
  @visibility("read")
  status?: InstanceViewStatus;
}

/**
 * The instance view of a virtual machine boot diagnostics.
 */
model BootDiagnosticsInstanceView {
  /**
   * The console screenshot blob URI. **Note:** This will **not** be set if boot diagnostics is currently enabled with managed storage.
   */
  @visibility("read")
  consoleScreenshotBlobUri?: string;

  /**
   * The serial console log blob Uri. **Note:** This will **not** be set if boot diagnostics is currently enabled with managed storage.
   */
  @visibility("read")
  serialConsoleLogBlobUri?: string;

  /**
   * The boot diagnostics status information for the VM. **Note:** It will be set only if there are errors encountered in enabling boot diagnostics.
   */
  @visibility("read")
  status?: InstanceViewStatus;
}

/**
 * Specifies the hardware settings for the virtual machine.
 */
model HardwareProfile {
  /**
   * Specifies the size of the virtual machine. The enum data type is currently deprecated and will be removed by December 23rd 2023. The recommended way to get the list of available sizes is using these APIs: [List all available virtual machine sizes in an availability set](https://docs.microsoft.com/rest/api/compute/availabilitysets/listavailablesizes), [List all available virtual machine sizes in a region]( https://docs.microsoft.com/rest/api/compute/resourceskus/list), [List all available virtual machine sizes for resizing](https://docs.microsoft.com/rest/api/compute/virtualmachines/listavailablesizes). For more information about virtual machine sizes, see [Sizes for virtual machines](https://docs.microsoft.com/azure/virtual-machines/sizes). The available VM sizes depend on region and availability set.
   */
  vmSize?: VirtualMachineSizeTypes;

  /**
   * Specifies the properties for customizing the size of the virtual machine. Minimum api-version: 2021-07-01. This feature is still in preview mode and is not supported for VirtualMachineScaleSet. Please follow the instructions in [VM Customization](https://aka.ms/vmcustomization) for more details.
   */
  vmSizeProperties?: VMSizeProperties;
}

/**
 * Specifies the storage settings for the virtual machine disks.
 */
model StorageProfile {
  /**
   * Specifies information about the image to use. You can specify information about platform images, marketplace images, or virtual machine images. This element is required when you want to use a platform image, marketplace image, or virtual machine image, but is not used in other creation operations.
   */
  imageReference?: ImageReference;

  /**
   * Specifies information about the operating system disk used by the virtual machine. For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
   */
  osDisk?: OSDisk;

  /**
   * Specifies the parameters that are used to add a data disk to a virtual machine. For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
   */
  dataDisks?: DataDisk[];

  /**
   * Specifies the disk controller type configured for the VM. **Note:** This property will be set to the default disk controller type if not specified provided virtual machine is being created with 'hyperVGeneration' set to V2 based on the capabilities of the operating system disk and VM size from the the specified minimum api version. You need to deallocate the VM before updating its disk controller type unless you are updating the VM size in the VM configuration which implicitly deallocates and reallocates the VM. Minimum api-version: 2022-08-01.
   */
  diskControllerType?: DiskControllerTypes;
}

/**
 * Specifies information about the operating system disk used by the virtual machine. For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
 */
model OSDisk {
  /**
   * This property allows you to specify the type of the OS that is included in the disk if creating a VM from user-image or a specialized VHD. Possible values are: **Windows,** **Linux.**
   */
  osType?: OperatingSystemTypes;

  /**
   * Specifies the encryption settings for the OS Disk. Minimum api-version: 2015-06-15.
   */
  encryptionSettings?: DiskEncryptionSettings;

  /**
   * The disk name.
   */
  name?: string;

  /**
   * The virtual hard disk.
   */
  vhd?: VirtualHardDisk;

  /**
   * The source user image virtual hard disk. The virtual hard disk will be copied before being attached to the virtual machine. If SourceImage is provided, the destination virtual hard drive must not exist.
   */
  image?: VirtualHardDisk;

  /**
   * Specifies the caching requirements. Possible values are: **None,** **ReadOnly,** **ReadWrite.** The defaulting behavior is: **None for Standard storage. ReadOnly for Premium storage.**
   */
  caching?: CachingTypes;

  /**
   * Specifies whether writeAccelerator should be enabled or disabled on the disk.
   */
  writeAcceleratorEnabled?: boolean;

  /**
   * Specifies the ephemeral Disk Settings for the operating system disk used by the virtual machine.
   */
  diffDiskSettings?: DiffDiskSettings;

  /**
   * Specifies how the virtual machine should be created. Possible values are: **Attach.** This value is used when you are using a specialized disk to create the virtual machine. **FromImage.** This value is used when you are using an image to create the virtual machine. If you are using a platform image, you should also use the imageReference element described above. If you are using a marketplace image, you should also use the plan element previously described.
   */
  createOption: DiskCreateOptionTypes;

  /**
   * Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. The property 'diskSizeGB' is the number of bytes x 1024^3 for the disk and the value cannot be larger than 1023.
   */
  diskSizeGB?: int32;

  /**
   * The managed disk parameters.
   */
  managedDisk?: ManagedDiskParameters;

  /**
   * Specifies whether OS Disk should be deleted or detached upon VM deletion. Possible values are: **Delete.** If this value is used, the OS disk is deleted when VM is deleted. **Detach.** If this value is used, the os disk is retained after VM is deleted. The default value is set to **Detach**. For an ephemeral OS Disk, the default value is set to **Delete**. The user cannot change the delete option for an ephemeral OS Disk.
   */
  deleteOption?: DiskDeleteOptionTypes;
}

/**
 * The parameters of a managed disk.
 */
model ManagedDiskParameters extends SubResource {
  /**
   * Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk.
   */
  storageAccountType?: StorageAccountTypes;

  /**
   * Specifies the customer managed disk encryption set resource id for the managed disk.
   */
  diskEncryptionSet?: DiskEncryptionSetParameters;

  /**
   * Specifies the security profile for the managed disk.
   */
  securityProfile?: VMDiskSecurityProfile;
}

/**
 * Describes a data disk.
 */
model DataDisk {
  /**
   * Specifies the logical unit number of the data disk. This value is used to identify data disks within the VM and therefore must be unique for each data disk attached to a VM.
   */
  lun: int32;

  /**
   * The disk name.
   */
  name?: string;

  /**
   * The virtual hard disk.
   */
  vhd?: VirtualHardDisk;

  /**
   * The source user image virtual hard disk. The virtual hard disk will be copied before being attached to the virtual machine. If SourceImage is provided, the destination virtual hard drive must not exist.
   */
  image?: VirtualHardDisk;

  /**
   * Specifies the caching requirements. Possible values are: **None,** **ReadOnly,** **ReadWrite.** The defaulting behavior is: **None for Standard storage. ReadOnly for Premium storage.**
   */
  caching?: CachingTypes;

  /**
   * Specifies whether writeAccelerator should be enabled or disabled on the disk.
   */
  writeAcceleratorEnabled?: boolean;

  /**
   * Specifies how the virtual machine should be created. Possible values are: **Attach.** This value is used when you are using a specialized disk to create the virtual machine. **FromImage.** This value is used when you are using an image to create the virtual machine. If you are using a platform image, you should also use the imageReference element described above. If you are using a marketplace image, you should also use the plan element previously described.
   */
  createOption: DiskCreateOptionTypes;

  /**
   * Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. The property 'diskSizeGB' is the number of bytes x 1024^3 for the disk and the value cannot be larger than 1023.
   */
  diskSizeGB?: int32;

  /**
   * The managed disk parameters.
   */
  managedDisk?: ManagedDiskParameters;

  /**
   * Specifies whether the data disk is in process of detachment from the VirtualMachine/VirtualMachineScaleset
   */
  toBeDetached?: boolean;

  /**
   * Specifies the Read-Write IOPS for the managed disk when StorageAccountType is UltraSSD_LRS. Returned only for VirtualMachine ScaleSet VM disks. Can be updated only via updates to the VirtualMachine Scale Set.
   */
  @visibility("read")
  @encodedName("application/json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int64;

  /**
   * Specifies the bandwidth in MB per second for the managed disk when StorageAccountType is UltraSSD_LRS. Returned only for VirtualMachine ScaleSet VM disks. Can be updated only via updates to the VirtualMachine Scale Set.
   */
  @visibility("read")
  diskMBpsReadWrite?: int64;

  /**
   * Specifies the detach behavior to be used while detaching a disk or which is already in the process of detachment from the virtual machine. Supported values: **ForceDetach.** detachOption: **ForceDetach** is applicable only for managed data disks. If a previous detachment attempt of the data disk did not complete due to an unexpected failure from the virtual machine and the disk is still not released then use force-detach as a last resort option to detach the disk forcibly from the VM. All writes might not have been flushed when using this detach behavior. **This feature is still in preview** mode and is not supported for VirtualMachineScaleSet. To force-detach a data disk update toBeDetached to 'true' along with setting detachOption: 'ForceDetach'.
   */
  detachOption?: DiskDetachOptionTypes;

  /**
   * Specifies whether data disk should be deleted or detached upon VM deletion. Possible values are: **Delete.** If this value is used, the data disk is deleted when VM is deleted. **Detach.** If this value is used, the data disk is retained after VM is deleted. The default value is set to **Detach**.
   */
  deleteOption?: DiskDeleteOptionTypes;
}

/**
 * Specifies the operating system settings for the virtual machine. Some of the settings cannot be changed once VM is provisioned.
 */
model OSProfile {
  /**
   * Specifies the host OS name of the virtual machine. This name cannot be updated after the VM is created. **Max-length (Windows):** 15 characters. **Max-length (Linux):** 64 characters. For naming conventions and restrictions see [Azure infrastructure services implementation guidelines](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-name-rules).
   */
  computerName?: string;

  /**
   * Specifies the name of the administrator account. <br><br> This property cannot be updated after the VM is created. <br><br> **Windows-only restriction:** Cannot end in "." <br><br> **Disallowed values:** "administrator", "admin", "user", "user1", "test", "user2", "test1", "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console", "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0", "sys", "test2", "test3", "user4", "user5". <br><br> **Minimum-length (Linux):** 1  character <br><br> **Max-length (Linux):** 64 characters <br><br> **Max-length (Windows):** 20 characters.
   */
  adminUsername?: string;

  @doc("Specifies the password of the administrator account. <br><br> **Minimum-length (Windows):** 8 characters <br><br> **Minimum-length (Linux):** 6 characters <br><br> **Max-length (Windows):** 123 characters <br><br> **Max-length (Linux):** 72 characters <br><br> **Complexity requirements:** 3 out of 4 conditions below need to be fulfilled <br> Has lower characters <br>Has upper characters <br> Has a digit <br> Has a special character (Regex match [\\W_]) <br><br> **Disallowed values:** \"abc@123\", \"P@$$w0rd\", \"P@ssw0rd\", \"P@ssword123\", \"Pa$$word\", \"pass@word1\", \"Password!\", \"Password1\", \"Password22\", \"iloveyou!\" <br><br> For resetting the password, see [How to reset the Remote Desktop service or its login password in a Windows VM](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/reset-rdp) <br><br> For resetting root password, see [Manage users, SSH, and check or repair disks on Azure Linux VMs using the VMAccess Extension](https://docs.microsoft.com/troubleshoot/azure/virtual-machines/troubleshoot-ssh-connection)")
  adminPassword?: string;

  /**
   * Specifies a base-64 encoded string of custom data. The base-64 encoded string is decoded to a binary array that is saved as a file on the Virtual Machine. The maximum length of the binary array is 65535 bytes. **Note: Do not pass any secrets or passwords in customData property.** This property cannot be updated after the VM is created. The property 'customData' is passed to the VM to be saved as a file, for more information see [Custom Data on Azure VMs](https://azure.microsoft.com/blog/custom-data-and-cloud-init-on-windows-azure/). For using cloud-init for your Linux VM, see [Using cloud-init to customize a Linux VM during creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init).
   */
  customData?: string;

  /**
   * Specifies Windows operating system settings on the virtual machine.
   */
  windowsConfiguration?: WindowsConfiguration;

  /**
   * Specifies the Linux operating system settings on the virtual machine. For a list of supported Linux distributions, see [Linux on Azure-Endorsed Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
   */
  linuxConfiguration?: LinuxConfiguration;

  /**
   * Specifies set of certificates that should be installed onto the virtual machine. To install certificates on a virtual machine it is recommended to use the [Azure Key Vault virtual machine extension for Linux](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-linux) or the [Azure Key Vault virtual machine extension for Windows](https://docs.microsoft.com/azure/virtual-machines/extensions/key-vault-windows).
   */
  secrets?: VaultSecretGroup[];

  /**
   * Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.
   */
  allowExtensionOperations?: boolean;

  /**
   * Optional property which must either be set to True or omitted.
   */
  requireGuestProvisionSignal?: boolean;
}

/**
 * Specifies the network interfaces or the networking configuration of the virtual machine.
 */
model NetworkProfile {
  /**
   * Specifies the list of resource Ids for the network interfaces associated with the virtual machine.
   */
  networkInterfaces?: NetworkInterfaceReference[];

  /**
   * specifies the Microsoft.Network API version used when creating networking resources in the Network Interface Configurations
   */
  networkApiVersion?: NetworkApiVersion;

  /**
   * Specifies the networking configurations that will be used to create the virtual machine networking resources.
   */
  networkInterfaceConfigurations?: VirtualMachineNetworkInterfaceConfiguration[];
}

/**
 * Describes a network interface reference.
 */
model NetworkInterfaceReference extends SubResource {
  /**
   * Describes a network interface reference properties.
   */
  properties?: NetworkInterfaceReferenceProperties;
}

/**
 * Describes a network interface reference properties.
 */
model NetworkInterfaceReferenceProperties {
  /**
   * Specifies the primary network interface in case the virtual machine has more than 1 network interface.
   */
  primary?: boolean;

  /**
   * Specify what happens to the network interface when the VM is deleted
   */
  deleteOption?: DeleteOptions;
}

/**
 * Describes a virtual machine network interface configurations.
 */
model VirtualMachineNetworkInterfaceConfiguration {
  /**
   * The network interface configuration name.
   */
  name: string;

  /**
   * Describes a virtual machine network profile's IP configuration.
   */
  properties?: VirtualMachineNetworkInterfaceConfigurationProperties;
}

/**
 * Describes a virtual machine network profile's IP configuration.
 */
model VirtualMachineNetworkInterfaceConfigurationProperties {
  /**
   * Specifies the primary network interface in case the virtual machine has more than 1 network interface.
   */
  primary?: boolean;

  /**
   * Specify what happens to the network interface when the VM is deleted
   */
  deleteOption?: DeleteOptions;

  /**
   * Specifies whether the network interface is accelerated networking-enabled.
   */
  enableAcceleratedNetworking?: boolean;

  /**
   * Specifies whether the network interface is disabled for tcp state tracking.
   */
  disableTcpStateTracking?: boolean;

  /**
   * Specifies whether the network interface is FPGA networking-enabled.
   */
  enableFpga?: boolean;

  /**
   * Whether IP forwarding enabled on this NIC.
   */
  enableIPForwarding?: boolean;

  /**
   * The network security group.
   */
  networkSecurityGroup?: SubResource;

  /**
   * The dns settings to be applied on the network interfaces.
   */
  dnsSettings?: VirtualMachineNetworkInterfaceDnsSettingsConfiguration;

  /**
   * Specifies the IP configurations of the network interface.
   */
  ipConfigurations: VirtualMachineNetworkInterfaceIPConfiguration[];

  dscpConfiguration?: SubResource;

  /**
   * Specifies whether the Auxiliary mode is enabled for the Network Interface resource.
   */
  auxiliaryMode?: NetworkInterfaceAuxiliaryMode;

  /**
   * Specifies whether the Auxiliary sku is enabled for the Network Interface resource.
   */
  auxiliarySku?: NetworkInterfaceAuxiliarySku;
}

/**
 * Describes a virtual machines network configuration's DNS settings.
 */
model VirtualMachineNetworkInterfaceDnsSettingsConfiguration {
  /**
   * List of DNS servers IP addresses
   */
  dnsServers?: string[];
}

/**
 * Describes a virtual machine network profile's IP configuration.
 */
model VirtualMachineNetworkInterfaceIPConfiguration {
  /**
   * The IP configuration name.
   */
  name: string;

  /**
   * Describes a virtual machine network interface IP configuration properties.
   */
  properties?: VirtualMachineNetworkInterfaceIPConfigurationProperties;
}

/**
 * Describes a virtual machine network interface IP configuration properties.
 */
model VirtualMachineNetworkInterfaceIPConfigurationProperties {
  /**
   * Specifies the identifier of the subnet.
   */
  subnet?: SubResource;

  /**
   * Specifies the primary network interface in case the virtual machine has more than 1 network interface.
   */
  primary?: boolean;

  /**
   * The publicIPAddressConfiguration.
   */
  publicIPAddressConfiguration?: VirtualMachinePublicIPAddressConfiguration;

  /**
   * Available from Api-Version 2017-03-30 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.  Possible values are: 'IPv4' and 'IPv6'.
   */
  privateIPAddressVersion?: IPVersions;

  /**
   * Specifies an array of references to application security group.
   */
  applicationSecurityGroups?: SubResource[];

  /**
   * Specifies an array of references to backend address pools of application gateways. A virtual machine can reference backend address pools of multiple application gateways. Multiple virtual machines cannot use the same application gateway.
   */
  applicationGatewayBackendAddressPools?: SubResource[];

  /**
   * Specifies an array of references to backend address pools of load balancers. A virtual machine can reference backend address pools of one public and one internal load balancer. [Multiple virtual machines cannot use the same basic sku load balancer].
   */
  loadBalancerBackendAddressPools?: SubResource[];
}

/**
 * Describes a virtual machines IP Configuration's PublicIPAddress configuration
 */
model VirtualMachinePublicIPAddressConfiguration {
  /**
   * The publicIP address configuration name.
   */
  name: string;

  /**
   * Describes a virtual machines IP Configuration's PublicIPAddress configuration
   */
  properties?: VirtualMachinePublicIPAddressConfigurationProperties;

  /**
   * Describes the public IP Sku. It can only be set with OrchestrationMode as Flexible.
   */
  sku?: PublicIPAddressSku;
}

/**
 * Describes a virtual machines IP Configuration's PublicIPAddress configuration
 */
model VirtualMachinePublicIPAddressConfigurationProperties {
  /**
   * The idle timeout of the public IP address.
   */
  idleTimeoutInMinutes?: int32;

  /**
   * Specify what happens to the public IP address when the VM is deleted
   */
  deleteOption?: DeleteOptions;

  /**
   * The dns settings to be applied on the publicIP addresses .
   */
  dnsSettings?: VirtualMachinePublicIPAddressDnsSettingsConfiguration;

  /**
   * The list of IP tags associated with the public IP address.
   */
  ipTags?: VirtualMachineIpTag[];

  /**
   * The PublicIPPrefix from which to allocate publicIP addresses.
   */
  publicIPPrefix?: SubResource;

  /**
   * Available from Api-Version 2019-07-01 onwards, it represents whether the specific ipconfiguration is IPv4 or IPv6. Default is taken as IPv4. Possible values are: 'IPv4' and 'IPv6'.
   */
  publicIPAddressVersion?: IPVersions;

  /**
   * Specify the public IP allocation type
   */
  publicIPAllocationMethod?: PublicIPAllocationMethod;
}

/**
 * Describes a virtual machines network configuration's DNS settings.
 */
model VirtualMachinePublicIPAddressDnsSettingsConfiguration {
  /**
   * The Domain name label prefix of the PublicIPAddress resources that will be created. The generated name label is the concatenation of the domain name label and vm network profile unique ID.
   */
  domainNameLabel: string;

  /**
   * The Domain name label scope of the PublicIPAddress resources that will be created. The generated name label is the concatenation of the hashed domain name label with policy according to the domain name label scope and vm network profile unique ID.
   */
  domainNameLabelScope?: DomainNameLabelScopeTypes;
}

/**
 * Contains the IP tag associated with the public IP address.
 */
model VirtualMachineIpTag {
  /**
   * IP tag type. Example: FirstPartyUsage.
   */
  ipTagType?: string;

  /**
   * IP tag associated with the public IP. Example: SQL, Storage etc.
   */
  tag?: string;
}

/**
 * Describes a virtual machine scale set VM network profile.
 */
model VirtualMachineScaleSetVMNetworkProfileConfiguration {
  /**
   * The list of network configurations.
   */
  networkInterfaceConfigurations?: VirtualMachineScaleSetNetworkConfiguration[];
}

/**
 * The protection policy of a virtual machine scale set VM.
 */
model VirtualMachineScaleSetVMProtectionPolicy {
  /**
   * Indicates that the virtual machine scale set VM shouldn't be considered for deletion during a scale-in operation.
   */
  protectFromScaleIn?: boolean;

  /**
   * Indicates that model updates or actions (including scale-in) initiated on the virtual machine scale set should not be applied to the virtual machine scale set VM.
   */
  protectFromScaleSetActions?: boolean;
}

/**
 * Identity for the virtual machine.
 */
model VirtualMachineIdentity {
  /**
   * The principal id of virtual machine identity. This property will only be provided for a system assigned identity.
   */
  @visibility("read")
  principalId?: string;

  /**
   * The tenant id associated with the virtual machine. This property will only be provided for a system assigned identity.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * The type of identity used for the virtual machine. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the virtual machine.
   */
  type?: ResourceIdentityType;

  /**
   * The list of user identities associated with the Virtual Machine. The user identity dictionary key references will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

/**
 * The SAS URIs of the console screenshot and serial log blobs.
 */
model RetrieveBootDiagnosticsDataResult {
  /**
   * The console screenshot blob URI
   */
  @visibility("read")
  consoleScreenshotBlobUri?: string;

  /**
   * The serial console log blob URI.
   */
  @visibility("read")
  serialConsoleLogBlobUri?: string;
}

/**
 * Describes a Virtual Machine Extension.
 */
model VirtualMachineExtensionUpdate extends UpdateResource {
  /**
   * Describes the properties of a Virtual Machine Extension.
   */
  properties?: VirtualMachineExtensionUpdateProperties;
}

/**
 * Describes the properties of a Virtual Machine.
 */
model VirtualMachineProperties {
  /**
   * Specifies the hardware settings for the virtual machine.
   */
  hardwareProfile?: HardwareProfile;

  /**
   * Specifies the storage settings for the virtual machine disks.
   */
  storageProfile?: StorageProfile;

  /**
   * Specifies additional capabilities enabled or disabled on the virtual machine.
   */
  additionalCapabilities?: AdditionalCapabilities;

  /**
   * Specifies the operating system settings used while creating the virtual machine. Some of the settings cannot be changed once VM is provisioned.
   */
  osProfile?: OSProfile;

  /**
   * Specifies the network interfaces of the virtual machine.
   */
  networkProfile?: NetworkProfile;

  /**
   * Specifies the Security related profile settings for the virtual machine.
   */
  securityProfile?: SecurityProfile;

  /**
   * Specifies the boot diagnostic settings state. Minimum api-version: 2015-06-15.
   */
  diagnosticsProfile?: DiagnosticsProfile;

  /**
   * Specifies information about the availability set that the virtual machine should be assigned to. Virtual machines specified in the same availability set are allocated to different nodes to maximize availability. For more information about availability sets, see [Availability sets overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview). For more information on Azure planned maintenance, see [Maintenance and updates for Virtual Machines in Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates). Currently, a VM can only be added to availability set at creation time. The availability set to which the VM is being added should be under the same resource group as the availability set resource. An existing VM cannot be added to an availability set. This property cannot exist along with a non-null properties.virtualMachineScaleSet reference.
   */
  availabilitySet?: SubResource;

  /**
   * Specifies information about the virtual machine scale set that the virtual machine should be assigned to. Virtual machines specified in the same virtual machine scale set are allocated to different nodes to maximize availability. Currently, a VM can only be added to virtual machine scale set at creation time. An existing VM cannot be added to a virtual machine scale set. This property cannot exist along with a non-null properties.availabilitySet reference. Minimum api‐version: 2019‐03‐01.
   */
  virtualMachineScaleSet?: SubResource;

  /**
   * Specifies information about the proximity placement group that the virtual machine should be assigned to. Minimum api-version: 2018-04-01.
   */
  proximityPlacementGroup?: SubResource;

  /**
   * Specifies the priority for the virtual machine. Minimum api-version: 2019-03-01
   */
  priority?: VirtualMachinePriorityTypes;

  /**
   * Specifies the eviction policy for the Azure Spot virtual machine and Azure Spot scale set. For Azure Spot virtual machines, both 'Deallocate' and 'Delete' are supported and the minimum api-version is 2019-03-01. For Azure Spot scale sets, both 'Deallocate' and 'Delete' are supported and the minimum api-version is 2017-10-30-preview.
   */
  evictionPolicy?: VirtualMachineEvictionPolicyTypes;

  /**
   * Specifies the billing related details of a Azure Spot virtual machine. Minimum api-version: 2019-03-01.
   */
  billingProfile?: BillingProfile;

  /**
   * Specifies information about the dedicated host that the virtual machine resides in. Minimum api-version: 2018-10-01.
   */
  host?: SubResource;

  /**
   * Specifies information about the dedicated host group that the virtual machine resides in. **Note:** User cannot specify both host and hostGroup properties. Minimum api-version: 2020-06-01.
   */
  hostGroup?: SubResource;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The virtual machine instance view.
   */
  @visibility("read")
  instanceView?: VirtualMachineInstanceView;

  /**
   * Specifies that the image or disk that is being used was licensed on-premises. <br><br> Possible values for Windows Server operating system are: <br><br> Windows_Client <br><br> Windows_Server <br><br> Possible values for Linux Server operating system are: <br><br> RHEL_BYOS (for RHEL) <br><br> SLES_BYOS (for SUSE) <br><br> For more information, see [Azure Hybrid Use Benefit for Windows Server](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing) <br><br> [Azure Hybrid Use Benefit for Linux Server](https://docs.microsoft.com/azure/virtual-machines/linux/azure-hybrid-benefit-linux) <br><br> Minimum api-version: 2015-06-15
   */
  licenseType?: string;

  /**
   * Specifies the VM unique ID which is a 128-bits identifier that is encoded and stored in all Azure IaaS VMs SMBIOS and can be read using platform BIOS commands.
   */
  @visibility("read")
  vmId?: string;

  /**
   * Specifies the time alloted for all extensions to start. The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format. The default value is 90 minutes (PT1H30M). Minimum api-version: 2020-06-01.
   */
  extensionsTimeBudget?: string;

  /**
   * Specifies the scale set logical fault domain into which the Virtual Machine will be created. By default, the Virtual Machine will by automatically assigned to a fault domain that best maintains balance across available fault domains. This is applicable only if the 'virtualMachineScaleSet' property of this Virtual Machine is set. The Virtual Machine Scale Set that is referenced, must have 'platformFaultDomainCount' greater than 1. This property cannot be updated once the Virtual Machine is created. Fault domain assignment can be viewed in the Virtual Machine Instance View. Minimum api‐version: 2020‐12‐01.
   */
  platformFaultDomain?: int32;

  /**
   * Specifies Scheduled Event related configurations.
   */
  scheduledEventsProfile?: ScheduledEventsProfile;

  /**
   * UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here. Minimum api-version: 2021-03-01.
   */
  userData?: string;

  /**
   * Specifies information about the capacity reservation that is used to allocate virtual machine. Minimum api-version: 2021-04-01.
   */
  capacityReservation?: CapacityReservationProfile;

  /**
   * Specifies the gallery applications that should be made available to the VM/VMSS.
   */
  applicationProfile?: ApplicationProfile;

  /**
   * Specifies the time at which the Virtual Machine resource was created. Minimum api-version: 2021-11-01.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

/**
 * The instance view of a virtual machine.
 */
model VirtualMachineInstanceView {
  /**
   * Specifies the update domain of the virtual machine.
   */
  platformUpdateDomain?: int32;

  /**
   * Specifies the fault domain of the virtual machine.
   */
  platformFaultDomain?: int32;

  /**
   * The computer name assigned to the virtual machine.
   */
  computerName?: string;

  /**
   * The Operating System running on the virtual machine.
   */
  osName?: string;

  /**
   * The version of Operating System running on the virtual machine.
   */
  osVersion?: string;

  /**
   * Specifies the HyperVGeneration Type associated with a resource
   */
  hyperVGeneration?: HyperVGenerationType;

  /**
   * The Remote desktop certificate thumbprint.
   */
  rdpThumbPrint?: string;

  /**
   * The VM Agent running on the virtual machine.
   */
  vmAgent?: VirtualMachineAgentInstanceView;

  /**
   * The Maintenance Operation status on the virtual machine.
   */
  maintenanceRedeployStatus?: MaintenanceRedeployStatus;

  /**
   * The virtual machine disk information.
   */
  disks?: DiskInstanceView[];

  /**
   * The extensions information.
   */
  extensions?: VirtualMachineExtensionInstanceView[];

  /**
   * The health status for the VM.
   */
  @visibility("read")
  vmHealth?: VirtualMachineHealthStatus;

  /**
   * Boot Diagnostics is a debugging feature which allows you to view Console Output and Screenshot to diagnose VM status. You can easily view the output of your console log. Azure also enables you to see a screenshot of the VM from the hypervisor.
   */
  bootDiagnostics?: BootDiagnosticsInstanceView;

  /**
   * Resource id of the dedicated host, on which the virtual machine is allocated through automatic placement, when the virtual machine is associated with a dedicated host group that has automatic placement enabled. Minimum api-version: 2020-06-01.
   */
  @visibility("read")
  assignedHost?: string;

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];

  /**
   * [Preview Feature] The status of virtual machine patch operations.
   */
  patchStatus?: VirtualMachinePatchStatus;
}

/**
 * The status of virtual machine patch operations.
 */
model VirtualMachinePatchStatus {
  /**
   * The available patch summary of the latest assessment operation for the virtual machine.
   */
  availablePatchSummary?: AvailablePatchSummary;

  /**
   * The installation summary of the latest installation operation for the virtual machine.
   */
  lastPatchInstallationSummary?: LastPatchInstallationSummary;

  /**
   * The enablement status of the specified patchMode
   */
  @visibility("read")
  configurationStatuses?: InstanceViewStatus[];
}

/**
 * Describes the properties of an virtual machine instance view for available patch summary.
 */
model AvailablePatchSummary {
  /**
   * The overall success or failure status of the operation. It remains "InProgress" until the operation completes. At that point it will become "Unknown", "Failed", "Succeeded", or "CompletedWithWarnings."
   */
  @visibility("read")
  status?: PatchOperationStatus;

  /**
   * The activity ID of the operation that produced this result. It is used to correlate across CRP and extension logs.
   */
  @visibility("read")
  assessmentActivityId?: string;

  /**
   * The overall reboot status of the VM. It will be true when partially installed patches require a reboot to complete installation but the reboot has not yet occurred.
   */
  @visibility("read")
  rebootPending?: boolean;

  /**
   * The number of critical or security patches that have been detected as available and not yet installed.
   */
  @visibility("read")
  criticalAndSecurityPatchCount?: int32;

  /**
   * The number of all available patches excluding critical and security.
   */
  @visibility("read")
  otherPatchCount?: int32;

  /**
   * The UTC timestamp when the operation began.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * The UTC timestamp when the operation began.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * The errors that were encountered during execution of the operation. The details array contains the list of them.
   */
  @visibility("read")
  error?: ApiError;
}

/**
 * Describes the properties of the last installed patch summary.
 */
model LastPatchInstallationSummary {
  /**
   * The overall success or failure status of the operation. It remains "InProgress" until the operation completes. At that point it will become "Unknown", "Failed", "Succeeded", or "CompletedWithWarnings."
   */
  @visibility("read")
  status?: PatchOperationStatus;

  /**
   * The activity ID of the operation that produced this result. It is used to correlate across CRP and extension logs.
   */
  @visibility("read")
  installationActivityId?: string;

  /**
   * Describes whether the operation ran out of time before it completed all its intended actions
   */
  @visibility("read")
  maintenanceWindowExceeded?: boolean;

  /**
   * The number of all available patches but not going to be installed because it didn't match a classification or inclusion list entry.
   */
  @visibility("read")
  notSelectedPatchCount?: int32;

  /**
   * The number of all available patches but excluded explicitly by a customer-specified exclusion list match.
   */
  @visibility("read")
  excludedPatchCount?: int32;

  /**
   * The number of all available patches expected to be installed over the course of the patch installation operation.
   */
  @visibility("read")
  pendingPatchCount?: int32;

  /**
   * The count of patches that successfully installed.
   */
  @visibility("read")
  installedPatchCount?: int32;

  /**
   * The count of patches that failed installation.
   */
  @visibility("read")
  failedPatchCount?: int32;

  /**
   * The UTC timestamp when the operation began.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * The UTC timestamp when the operation began.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedTime?: utcDateTime;

  /**
   * The errors that were encountered during execution of the operation. The details array contains the list of them.
   */
  @visibility("read")
  error?: ApiError;
}

/**
 * Capture Virtual Machine parameters.
 */
model VirtualMachineCaptureParameters {
  /**
   * The captured virtual hard disk's name prefix.
   */
  vhdPrefix: string;

  /**
   * The destination container name.
   */
  destinationContainerName: string;

  /**
   * Specifies whether to overwrite the destination virtual hard disk, in case of conflict.
   */
  overwriteVhds: boolean;
}

/**
 * Output of virtual machine capture operation.
 */
model VirtualMachineCaptureResult extends SubResource {
  /**
   * the schema of the captured virtual machine
   */
  @visibility("read")
  @encodedName("application/json", "$schema")
  schema?: string;

  /**
   * the version of the content
   */
  @visibility("read")
  contentVersion?: string;

  /**
   * parameters of the captured virtual machine
   */
  @visibility("read")
  parameters?: Record<unknown>;

  /**
   * a list of resource items of the captured virtual machine
   */
  @visibility("read")
  resources?: Record<unknown>[];
}

/**
 * Describes a Virtual Machine Update.
 */
model VirtualMachineUpdate extends UpdateResource {
  /**
   * Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.  In the Azure portal, find the marketplace image that you want to use and then click **Want to deploy programmatically, Get Started ->**. Enter any required information and then click **Save**.
   */
  plan?: Plan;

  /**
   * Describes the properties of a Virtual Machine.
   */
  properties?: VirtualMachineProperties;

  /**
   * The identity of the virtual machine, if configured.
   */
  identity?: VirtualMachineIdentity;

  /**
   * The virtual machine zones.
   */
  zones?: string[];
}

/**
 * Describes the properties of an AssessPatches result.
 */
model VirtualMachineAssessPatchesResult {
  /**
   * The overall success or failure status of the operation. It remains "InProgress" until the operation completes. At that point it will become "Unknown", "Failed", "Succeeded", or "CompletedWithWarnings."
   */
  @visibility("read")
  status?: PatchOperationStatus;

  /**
   * The activity ID of the operation that produced this result. It is used to correlate across CRP and extension logs.
   */
  @visibility("read")
  assessmentActivityId?: string;

  /**
   * The overall reboot status of the VM. It will be true when partially installed patches require a reboot to complete installation but the reboot has not yet occurred.
   */
  @visibility("read")
  rebootPending?: boolean;

  /**
   * The number of critical or security patches that have been detected as available and not yet installed.
   */
  @visibility("read")
  criticalAndSecurityPatchCount?: int32;

  /**
   * The number of all available patches excluding critical and security.
   */
  @visibility("read")
  otherPatchCount?: int32;

  /**
   * The UTC timestamp when the operation began.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * The list of patches that have been detected as available for installation.
   */
  @visibility("read")
  availablePatches?: VirtualMachineSoftwarePatchProperties[];

  /**
   * The errors that were encountered during execution of the operation. The details array contains the list of them.
   */
  @visibility("read")
  error?: ApiError;
}

/**
 * Describes the properties of a Virtual Machine software patch.
 */
model VirtualMachineSoftwarePatchProperties {
  /**
   * A unique identifier for the patch.
   */
  @visibility("read")
  patchId?: string;

  /**
   * The friendly name of the patch.
   */
  @visibility("read")
  name?: string;

  /**
   * The version number of the patch. This property applies only to Linux patches.
   */
  @visibility("read")
  version?: string;

  /**
   * The KBID of the patch. Only applies to Windows patches.
   */
  @visibility("read")
  kbId?: string;

  /**
   * The classification(s) of the patch as provided by the patch publisher.
   */
  @visibility("read")
  classifications?: string[];

  /**
   * Describes the reboot requirements of the patch.
   */
  @visibility("read")
  rebootBehavior?: VMGuestPatchRebootBehavior;

  /**
   * The activity ID of the operation that produced this result. It is used to correlate across CRP and extension logs.
   */
  @visibility("read")
  activityId?: string;

  /**
   * The UTC timestamp when the repository published this patch.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  /**
   * The UTC timestamp of the last update to this patch record.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * Describes the availability of a given patch.
   */
  @visibility("read")
  assessmentState?: PatchAssessmentState;
}

/**
 * Input for InstallPatches as directly received by the API
 */
model VirtualMachineInstallPatchesParameters {
  /**
   * Specifies the maximum amount of time that the operation will run. It must be an ISO 8601-compliant duration string such as PT4H (4 hours)
   */
  maximumDuration?: duration;

  /**
   * Defines when it is acceptable to reboot a VM during a software update operation.
   */
  rebootSetting: VMGuestPatchRebootSetting;

  /**
   * Input for InstallPatches on a Windows VM, as directly received by the API
   */
  windowsParameters?: WindowsParameters;

  /**
   * Input for InstallPatches on a Linux VM, as directly received by the API
   */
  linuxParameters?: LinuxParameters;
}

/**
 * Input for InstallPatches on a Windows VM, as directly received by the API
 */
model WindowsParameters {
  /**
   * The update classifications to select when installing patches for Windows.
   */
  classificationsToInclude?: VMGuestPatchClassificationWindows[];

  /**
   * Kbs to include in the patch operation
   */
  kbNumbersToInclude?: string[];

  /**
   * Kbs to exclude in the patch operation
   */
  kbNumbersToExclude?: string[];

  /**
   * Filters out Kbs that don't have an InstallationRebootBehavior of 'NeverReboots' when this is set to true.
   */
  excludeKbsRequiringReboot?: boolean;

  /**
   * This is used to install patches that were published on or before this given max published date.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  maxPatchPublishDate?: utcDateTime;
}

/**
 * Input for InstallPatches on a Linux VM, as directly received by the API
 */
model LinuxParameters {
  /**
   * The update classifications to select when installing patches for Linux.
   */
  classificationsToInclude?: VMGuestPatchClassificationLinux[];

  /**
   * packages to include in the patch operation. Format: packageName_packageVersion
   */
  packageNameMasksToInclude?: string[];

  /**
   * packages to exclude in the patch operation. Format: packageName_packageVersion
   */
  packageNameMasksToExclude?: string[];

  /**
   * This is used as a maintenance run identifier for Auto VM Guest Patching in Linux.
   */
  maintenanceRunId?: string;
}

/**
 * The result summary of an installation operation.
 */
model VirtualMachineInstallPatchesResult {
  /**
   * The overall success or failure status of the operation. It remains "InProgress" until the operation completes. At that point it will become "Failed", "Succeeded", "Unknown" or "CompletedWithWarnings."
   */
  @visibility("read")
  status?: PatchOperationStatus;

  /**
   * The activity ID of the operation that produced this result. It is used to correlate across CRP and extension logs.
   */
  @visibility("read")
  installationActivityId?: string;

  /**
   * The reboot state of the VM following completion of the operation.
   */
  @visibility("read")
  rebootStatus?: VMGuestPatchRebootStatus;

  /**
   * Whether the operation ran out of time before it completed all its intended actions.
   */
  @visibility("read")
  maintenanceWindowExceeded?: boolean;

  /**
   * The number of patches that were not installed due to the user blocking their installation.
   */
  @visibility("read")
  excludedPatchCount?: int32;

  /**
   * The number of patches that were detected as available for install, but did not meet the operation's criteria.
   */
  @visibility("read")
  notSelectedPatchCount?: int32;

  /**
   * The number of patches that were identified as meeting the installation criteria, but were not able to be installed. Typically this happens when maintenanceWindowExceeded == true.
   */
  @visibility("read")
  pendingPatchCount?: int32;

  /**
   * The number of patches successfully installed.
   */
  @visibility("read")
  installedPatchCount?: int32;

  /**
   * The number of patches that could not be installed due to some issue. See errors for details.
   */
  @visibility("read")
  failedPatchCount?: int32;

  /**
   * The patches that were installed during the operation.
   */
  @visibility("read")
  patches?: PatchInstallationDetail[];

  /**
   * The UTC timestamp when the operation began.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * The errors that were encountered during execution of the operation. The details array contains the list of them.
   */
  @visibility("read")
  error?: ApiError;
}

/**
 * Information about a specific patch that was encountered during an installation action.
 */
model PatchInstallationDetail {
  /**
   * A unique identifier for the patch.
   */
  @visibility("read")
  patchId?: string;

  /**
   * The friendly name of the patch.
   */
  @visibility("read")
  name?: string;

  /**
   * The version string of the package. It may conform to Semantic Versioning. Only applies to Linux.
   */
  @visibility("read")
  version?: string;

  /**
   * The KBID of the patch. Only applies to Windows patches.
   */
  @visibility("read")
  kbId?: string;

  /**
   * The classification(s) of the patch as provided by the patch publisher.
   */
  @visibility("read")
  classifications?: string[];

  /**
   * The state of the patch after the installation operation completed.
   */
  @visibility("read")
  installationState?: PatchInstallationState;
}

/**
 * Describes a Virtual Machine Image.
 */
model VirtualMachineImage extends VirtualMachineImageResource {
  /**
   * Describes the properties of a Virtual Machine Image.
   */
  properties?: VirtualMachineImageProperties;
}

/**
 * Describes the properties of a Virtual Machine Image.
 */
model VirtualMachineImageProperties {
  /**
   * Used for establishing the purchase context of any 3rd Party artifact through MarketPlace.
   */
  plan?: PurchasePlan;

  /**
   * Contains the os disk image information.
   */
  osDiskImage?: OSDiskImage;

  /**
   * The list of data disk images information.
   */
  dataDiskImages?: DataDiskImage[];

  /**
   * Describes automatic OS upgrade properties on the image.
   */
  automaticOSUpgradeProperties?: AutomaticOSUpgradeProperties;

  /**
   * Specifies the HyperVGeneration Type
   */
  hyperVGeneration?: HyperVGenerationTypes;

  /**
   * Specifies disallowed configuration for the VirtualMachine created from the image
   */
  disallowed?: DisallowedConfiguration;

  features?: VirtualMachineImageFeature[];

  /**
   * Specifies the Architecture Type
   */
  architecture?: ArchitectureTypes;

  /**
   * Describes image deprecation status properties on the image.
   */
  imageDeprecationStatus?: ImageDeprecationStatus;
}

/**
 * Used for establishing the purchase context of any 3rd Party artifact through MarketPlace.
 */
model PurchasePlan {
  /**
   * The publisher ID.
   */
  publisher: string;

  /**
   * The plan ID.
   */
  name: string;

  /**
   * Specifies the product of the image from the marketplace. This is the same value as Offer under the imageReference element.
   */
  product: string;
}

/**
 * Contains the os disk image information.
 */
model OSDiskImage {
  /**
   * The operating system of the osDiskImage.
   */
  operatingSystem: OperatingSystemTypes;
}

/**
 * Contains the data disk images information.
 */
model DataDiskImage {
  /**
   * Specifies the logical unit number of the data disk. This value is used to identify data disks within the VM and therefore must be unique for each data disk attached to a VM.
   */
  @visibility("read")
  lun?: int32;
}

/**
 * Describes automatic OS upgrade properties on the image.
 */
model AutomaticOSUpgradeProperties {
  /**
   * Specifies whether automatic OS upgrade is supported on the image.
   */
  automaticOSUpgradeSupported: boolean;
}

/**
 * Specifies the disallowed configuration for a virtual machine image.
 */
model DisallowedConfiguration {
  /**
   * VM disk types which are disallowed.
   */
  vmDiskType?: VmDiskTypes;
}

/**
 * Specifies additional capabilities supported by the image
 */
model VirtualMachineImageFeature {
  /**
   * The name of the feature.
   */
  name?: string;

  /**
   * The corresponding value for the feature.
   */
  value?: string;
}

/**
 * Describes image deprecation status properties on the image.
 */
model ImageDeprecationStatus {
  /**
   * Describes the state of the image.
   */
  imageState?: ImageState;

  /**
   * The time, in future, at which this image will be marked as deprecated. This scheduled time is chosen by the Publisher.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  scheduledDeprecationTime?: utcDateTime;

  /**
   * Describes the alternative option specified by the Publisher for this image when this image is deprecated.
   */
  alternativeOption?: AlternativeOption;
}

/**
 * Describes the alternative option specified by the Publisher for this image when this image is deprecated.
 */
model AlternativeOption {
  /**
   * Describes the type of the alternative option.
   */
  type?: AlternativeType;

  /**
   * Indicates the alternative option value specified by the Publisher. This is the Offer name when the type is Offer or the Plan name when the type is Plan.
   */
  value?: string;
}

/**
 * Virtual machine image resource information.
 */
model VirtualMachineImageResource extends SubResource {
  /**
   * The name of the resource.
   */
  name: string;

  /**
   * The supported Azure location of the resource.
   */
  location: string;

  /**
   * Specifies the tags that are assigned to the virtual machine. For more information about using tags, see [Using tags to organize your Azure resources](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-using-tags.md).
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * The extended location of the Virtual Machine.
   */
  extendedLocation?: ExtendedLocation;
}

/**
 * The List VmImages in EdgeZone operation response.
 */
model VmImagesInEdgeZoneListResult {
  /**
   * The list of VMImages in EdgeZone
   */
  value?: VirtualMachineImageResource[];

  /**
   * The URI to fetch the next page of VMImages in EdgeZone. Call ListNext() with this URI to fetch the next page of VmImages.
   */
  nextLink?: string;
}

/**
 * Describes the properties of a Virtual Machine Extension Image.
 */
model VirtualMachineExtensionImageProperties {
  /**
   * The operating system this extension supports.
   */
  operatingSystem: string;

  /**
   * The type of role (IaaS or PaaS) this extension supports.
   */
  computeRole: string;

  /**
   * The schema defined by publisher, where extension consumers should provide settings in a matching schema.
   */
  handlerSchema: string;

  /**
   * Whether the extension can be used on xRP VMScaleSets. By default existing extensions are usable on scalesets, but there might be cases where a publisher wants to explicitly indicate the extension is only enabled for CRP VMs but not VMSS.
   */
  vmScaleSetEnabled?: boolean;

  /**
   * Whether the handler can support multiple extensions.
   */
  supportsMultipleExtensions?: boolean;
}

/**
 * The instance view of a resource.
 */
model AvailabilitySetProperties {
  /**
   * Update Domain count.
   */
  platformUpdateDomainCount?: int32;

  /**
   * Fault Domain count.
   */
  platformFaultDomainCount?: int32;

  /**
   * A list of references to all virtual machines in the availability set.
   */
  virtualMachines?: SubResource[];

  /**
   * Specifies information about the proximity placement group that the availability set should be assigned to. Minimum api-version: 2018-04-01.
   */
  proximityPlacementGroup?: SubResource;

  /**
   * The resource status information.
   */
  @visibility("read")
  statuses?: InstanceViewStatus[];
}

/**
 * Specifies information about the availability set that the virtual machine should be assigned to. Only tags may be updated.
 */
model AvailabilitySetUpdate extends UpdateResource {
  /**
   * The instance view of a resource.
   */
  properties?: AvailabilitySetProperties;

  /**
   * Sku of the availability set
   */
  sku?: Sku;
}

/**
 * Describes the properties of a Proximity Placement Group.
 */
model ProximityPlacementGroupProperties {
  /**
   * Specifies the type of the proximity placement group. Possible values are: **Standard** : Co-locate resources within an Azure region or Availability Zone. **Ultra** : For future use.
   */
  proximityPlacementGroupType?: ProximityPlacementGroupType;

  /**
   * A list of references to all virtual machines in the proximity placement group.
   */
  @visibility("read")
  virtualMachines?: SubResourceWithColocationStatus[];

  /**
   * A list of references to all virtual machine scale sets in the proximity placement group.
   */
  @visibility("read")
  virtualMachineScaleSets?: SubResourceWithColocationStatus[];

  /**
   * A list of references to all availability sets in the proximity placement group.
   */
  @visibility("read")
  availabilitySets?: SubResourceWithColocationStatus[];

  /**
   * Describes colocation status of the Proximity Placement Group.
   */
  colocationStatus?: InstanceViewStatus;

  /**
   * Specifies the user intent of the proximity placement group.
   */
  intent?: ProximityPlacementGroupPropertiesIntent;
}

model SubResourceWithColocationStatus extends SubResource {
  /**
   * Describes colocation status of a resource in the Proximity Placement Group.
   */
  colocationStatus?: InstanceViewStatus;
}

/**
 * Specifies the user intent of the proximity placement group.
 */
model ProximityPlacementGroupPropertiesIntent {
  /**
   * Specifies possible sizes of virtual machines that can be created in the proximity placement group.
   */
  vmSizes?: string[];
}

/**
 * Specifies information about the proximity placement group.
 */
model ProximityPlacementGroupUpdate extends UpdateResource {}

/**
 * Dedicated Host Group Properties.
 */
model DedicatedHostGroupProperties {
  /**
   * Number of fault domains that the host group can span.
   */
  @minValue(1)
  platformFaultDomainCount: int32;

  /**
   * A list of references to all dedicated hosts in the dedicated host group.
   */
  @visibility("read")
  hosts?: SubResourceReadOnly[];

  /**
   * The dedicated host group instance view, which has the list of instance view of the dedicated hosts under the dedicated host group.
   */
  @visibility("read")
  instanceView?: DedicatedHostGroupInstanceView;

  /**
   * Specifies whether virtual machines or virtual machine scale sets can be placed automatically on the dedicated host group. Automatic placement means resources are allocated on dedicated hosts, that are chosen by Azure, under the dedicated host group. The value is defaulted to 'false' when not provided. Minimum api-version: 2020-06-01.
   */
  supportAutomaticPlacement?: boolean;

  /**
   * Enables or disables a capability on the dedicated host group. Minimum api-version: 2022-03-01.
   */
  additionalCapabilities?: DedicatedHostGroupPropertiesAdditionalCapabilities;
}

model DedicatedHostGroupInstanceView {
  /**
   * List of instance view of the dedicated hosts under the dedicated host group.
   */
  hosts?: DedicatedHostInstanceViewWithName[];
}

/**
 * The instance view of a dedicated host that includes the name of the dedicated host. It is used for the response to the instance view of a dedicated host group.
 */
model DedicatedHostInstanceViewWithName extends DedicatedHostInstanceView {
  /**
   * The name of the dedicated host.
   */
  @visibility("read")
  name?: string;
}

/**
 * The instance view of a dedicated host.
 */
model DedicatedHostInstanceView {
  /**
   * Specifies the unique id of the dedicated physical machine on which the dedicated host resides.
   */
  @visibility("read")
  assetId?: string;

  /**
   * Unutilized capacity of the dedicated host.
   */
  availableCapacity?: DedicatedHostAvailableCapacity;

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * Dedicated host unutilized capacity.
 */
model DedicatedHostAvailableCapacity {
  /**
   * The unutilized capacity of the dedicated host represented in terms of each VM size that is allowed to be deployed to the dedicated host.
   */
  allocatableVMs?: DedicatedHostAllocatableVM[];
}

/**
 * Represents the dedicated host unutilized capacity in terms of a specific VM size.
 */
model DedicatedHostAllocatableVM {
  /**
   * VM size in terms of which the unutilized capacity is represented.
   */
  vmSize?: string;

  /**
   * Maximum number of VMs of size vmSize that can fit in the dedicated host's remaining capacity.
   */
  count?: float64;
}

/**
 * Enables or disables a capability on the dedicated host group. Minimum api-version: 2022-03-01.
 */
model DedicatedHostGroupPropertiesAdditionalCapabilities {
  /**
   * The flag that enables or disables a capability to have UltraSSD Enabled Virtual Machines on Dedicated Hosts of the Dedicated Host Group. For the Virtual Machines to be UltraSSD Enabled, UltraSSDEnabled flag for the resource needs to be set true as well. The value is defaulted to 'false' when not provided. Please refer to https://docs.microsoft.com/en-us/azure/virtual-machines/disks-enable-ultra-ssd for more details on Ultra SSD feature. **Note:** The ultraSSDEnabled setting can only be enabled for Host Groups that are created as zonal. Minimum api-version: 2022-03-01.
   */
  ultraSSDEnabled?: boolean;
}

/**
 * Specifies information about the dedicated host group that the dedicated host should be assigned to. Only tags may be updated.
 */
model DedicatedHostGroupUpdate extends UpdateResource {
  /**
   * Dedicated Host Group Properties.
   */
  properties?: DedicatedHostGroupProperties;

  /**
   * Availability Zone to use for this host group. Only single zone is supported. The zone can be assigned only during creation. If not provided, the group supports all zones in the region. If provided, enforces each host in the group to be in the same zone.
   */
  zones?: string[];
}

/**
 * Properties of the dedicated host.
 */
model DedicatedHostProperties {
  /**
   * Fault domain of the dedicated host within a dedicated host group.
   */
  platformFaultDomain?: int32;

  /**
   * Specifies whether the dedicated host should be replaced automatically in case of a failure. The value is defaulted to 'true' when not provided.
   */
  autoReplaceOnFailure?: boolean;

  /**
   * A unique id generated and assigned to the dedicated host by the platform. Does not change throughout the lifetime of the host.
   */
  @visibility("read")
  hostId?: string;

  /**
   * A list of references to all virtual machines in the Dedicated Host.
   */
  @visibility("read")
  virtualMachines?: SubResourceReadOnly[];

  /**
   * Specifies the software license type that will be applied to the VMs deployed on the dedicated host. Possible values are: **None,** **Windows_Server_Hybrid,** **Windows_Server_Perpetual.** The default value is: **None.**
   */
  licenseType?: DedicatedHostLicenseTypes;

  /**
   * The date when the host was first provisioned.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  provisioningTime?: utcDateTime;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The dedicated host instance view.
   */
  @visibility("read")
  instanceView?: DedicatedHostInstanceView;

  /**
   * Specifies the time at which the Dedicated Host resource was created. Minimum api-version: 2021-11-01.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

/**
 * Specifies information about the dedicated host. Only tags, autoReplaceOnFailure and licenseType may be updated.
 */
model DedicatedHostUpdate extends UpdateResource {
  /**
   * Properties of the dedicated host.
   */
  properties?: DedicatedHostProperties;

  /**
   * [List all available dedicated host sizes for resizing] (https://docs.microsoft.com/rest/api/compute/dedicated-hosts/listavailablesizes). Resizing can be only used to scale up DedicatedHost. Only name is required to be set.
   */
  sku?: Sku;
}

/**
 * The List Dedicated Host sizes operation response.
 */
@pagedResult
model DedicatedHostSizeListResult {
  /**
   * The list of dedicated host sizes.
   */
  @items
  value?: string[];
}

/**
 * Properties of the SSH public key.
 */
model SshPublicKeyResourceProperties {
  /**
   * SSH public key used to authenticate to a virtual machine through ssh. If this property is not initially provided when the resource is created, the publicKey property will be populated when generateKeyPair is called. If the public key is provided upon resource creation, the provided public key needs to be at least 2048-bit and in ssh-rsa format.
   */
  publicKey?: string;
}

/**
 * Specifies information about the SSH public key.
 */
model SshPublicKeyUpdateResource extends UpdateResource {
  /**
   * Properties of the SSH public key.
   */
  properties?: SshPublicKeyResourceProperties;
}

/**
 * Response from generation of an SSH key pair.
 */
model SshPublicKeyGenerateKeyPairResult {
  /**
   * Private key portion of the key pair used to authenticate to a virtual machine through ssh. The private key is returned in RFC3447 format and should be treated as a secret.
   */
  privateKey: string;

  /**
   * Public key portion of the key pair used to authenticate to a virtual machine through ssh. The public key is in ssh-rsa format.
   */
  publicKey: string;

  /**
   * The ARM resource id in the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{SshPublicKeyName}
   */
  id: string;
}

/**
 * Describes the properties of an Image.
 */
model ImageProperties {
  /**
   * The source virtual machine from which Image is created.
   */
  sourceVirtualMachine?: SubResource;

  /**
   * Specifies the storage settings for the virtual machine disks.
   */
  storageProfile?: ImageStorageProfile;

  /**
   * The provisioning state.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Specifies the HyperVGenerationType of the VirtualMachine created from the image. From API Version 2019-03-01 if the image source is a blob, then we need the user to specify the value, if the source is managed resource like disk or snapshot, we may require the user to specify the property if we cannot deduce it from the source managed resource.
   */
  hyperVGeneration?: HyperVGenerationTypes;
}

/**
 * Describes a storage profile.
 */
model ImageStorageProfile {
  /**
   * Specifies information about the operating system disk used by the virtual machine. <br><br> For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
   */
  osDisk?: ImageOSDisk;

  /**
   * Specifies the parameters that are used to add a data disk to a virtual machine. <br><br> For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
   */
  dataDisks?: ImageDataDisk[];

  /**
   * Specifies whether an image is zone resilient or not. Default is false. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS).
   */
  zoneResilient?: boolean;
}

/**
 * Describes an Operating System disk.
 */
model ImageOSDisk extends ImageDisk {
  /**
   * This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image. Possible values are: **Windows,** **Linux.**
   */
  osType: OperatingSystemTypes;

  /**
   * The OS State. For managed images, use Generalized.
   */
  osState: OperatingSystemStateTypes;
}

/**
 * Describes a image disk.
 */
model ImageDisk {
  /**
   * The snapshot.
   */
  snapshot?: SubResource;

  /**
   * The managedDisk.
   */
  managedDisk?: SubResource;

  /**
   * The Virtual Hard Disk.
   */
  blobUri?: string;

  /**
   * Specifies the caching requirements. Possible values are: **None,** **ReadOnly,** **ReadWrite.** The default values are: **None for Standard storage. ReadOnly for Premium storage.**
   */
  caching?: CachingTypes;

  /**
   * Specifies the size of empty data disks in gigabytes. This element can be used to overwrite the name of the disk in a virtual machine image. This value cannot be larger than 1023 GB.
   */
  diskSizeGB?: int32;

  /**
   * Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk.
   */
  storageAccountType?: StorageAccountTypes;

  /**
   * Specifies the customer managed disk encryption set resource id for the managed image disk.
   */
  diskEncryptionSet?: DiskEncryptionSetParameters;
}

/**
 * Describes a data disk.
 */
model ImageDataDisk extends ImageDisk {
  /**
   * Specifies the logical unit number of the data disk. This value is used to identify data disks within the VM and therefore must be unique for each data disk attached to a VM.
   */
  lun: int32;
}

/**
 * The source user image virtual hard disk. Only tags may be updated.
 */
model ImageUpdate extends UpdateResource {
  /**
   * Describes the properties of an Image.
   */
  properties?: ImageProperties;
}

/**
 * The restore point collection properties.
 */
model RestorePointCollectionProperties {
  /**
   * The properties of the source resource that this restore point collection is created from.
   */
  source?: RestorePointCollectionSourceProperties;

  /**
   * The provisioning state of the restore point collection.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The unique id of the restore point collection.
   */
  @visibility("read")
  restorePointCollectionId?: string;

  /**
   * A list containing all restore points created under this restore point collection.
   */
  @visibility("read")
  restorePoints?: RestorePoint[];
}

/**
 * The properties of the source resource that this restore point collection is created from.
 */
model RestorePointCollectionSourceProperties {
  /**
   * Location of the source resource used to create this restore point collection.
   */
  @visibility("read")
  location?: string;

  /**
   * Resource Id of the source resource used to create this restore point collection
   */
  id?: string;
}

/**
 * The restore point properties.
 */
model RestorePointProperties {
  /**
   * List of disk resource ids that the customer wishes to exclude from the restore point. If no disks are specified, all disks will be included.
   */
  excludeDisks?: ApiEntityReference[];

  /**
   * Gets the details of the VM captured at the time of the restore point creation.
   */
  sourceMetadata?: RestorePointSourceMetadata;

  /**
   * Gets the provisioning state of the restore point.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * ConsistencyMode of the RestorePoint. Can be specified in the input while creating a restore point. For now, only CrashConsistent is accepted as a valid input. Please refer to https://aka.ms/RestorePoints for more details.
   */
  consistencyMode?: ConsistencyModeTypes;

  /**
   * Gets the creation time of the restore point.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  /**
   * Resource Id of the source restore point from which a copy needs to be created.
   */
  sourceRestorePoint?: ApiEntityReference;

  /**
   * The restore point instance view.
   */
  @visibility("read")
  instanceView?: RestorePointInstanceView;
}

/**
 * Describes the properties of the Virtual Machine for which the restore point was created. The properties provided are a subset and the snapshot of the overall Virtual Machine properties captured at the time of the restore point creation.
 */
model RestorePointSourceMetadata {
  /**
   * Gets the hardware profile.
   */
  @visibility("read")
  hardwareProfile?: HardwareProfile;

  /**
   * Gets the storage profile.
   */
  storageProfile?: RestorePointSourceVMStorageProfile;

  /**
   * Gets the OS profile.
   */
  @visibility("read")
  osProfile?: OSProfile;

  /**
   * Gets the diagnostics profile.
   */
  @visibility("read")
  diagnosticsProfile?: DiagnosticsProfile;

  /**
   * Gets the license type, which is for bring your own license scenario.
   */
  @visibility("read")
  licenseType?: string;

  /**
   * Gets the virtual machine unique id.
   */
  @visibility("read")
  vmId?: string;

  /**
   * Gets the security profile.
   */
  @visibility("read")
  securityProfile?: SecurityProfile;

  /**
   * Location of the VM from which the restore point was created.
   */
  @visibility("read")
  location?: string;

  /**
   * UserData associated with the source VM for which restore point is captured, which is a base-64 encoded value.
   */
  @visibility("read")
  userData?: string;

  /**
   * HyperVGeneration of the source VM for which restore point is captured.
   */
  @visibility("read")
  hyperVGeneration?: HyperVGenerationTypes;
}

/**
 * Describes the storage profile.
 */
model RestorePointSourceVMStorageProfile {
  /**
   * Gets the OS disk of the VM captured at the time of the restore point creation.
   */
  osDisk?: RestorePointSourceVmosDisk;

  /**
   * Gets the data disks of the VM captured at the time of the restore point creation.
   */
  @encodedName("application/json", "dataDisks")
  dataDiskList?: RestorePointSourceVMDataDisk[];
}

/**
 * Describes an Operating System disk.
 */
model RestorePointSourceVmosDisk {
  /**
   * Gets the Operating System type.
   */
  @visibility("read")
  osType?: OperatingSystemType;

  /**
   * Gets the disk encryption settings.
   */
  @visibility("read")
  encryptionSettings?: DiskEncryptionSettings;

  /**
   * Gets the disk name.
   */
  @visibility("read")
  name?: string;

  /**
   * Gets the caching type.
   */
  @visibility("read")
  caching?: CachingTypes;

  /**
   * Gets the disk size in GB.
   */
  @visibility("read")
  diskSizeGB?: int32;

  /**
   * Gets the managed disk details
   */
  managedDisk?: ManagedDiskParameters;

  /**
   * Contains Disk Restore Point properties.
   */
  diskRestorePoint?: DiskRestorePointAttributes;

  /**
   * Shows true if the disk is write-accelerator enabled.
   */
  @visibility("read")
  writeAcceleratorEnabled?: boolean;
}

/**
 * Disk Restore Point details.
 */
model DiskRestorePointAttributes extends SubResourceReadOnly {
  /**
   * Encryption at rest settings for disk restore point. It is an optional property that can be specified in the input while creating a restore point.
   */
  encryption?: RestorePointEncryption;

  /**
   * Resource Id of the source disk restore point.
   */
  sourceDiskRestorePoint?: ApiEntityReference;
}

/**
 * Encryption at rest settings for disk restore point. It is an optional property that can be specified in the input while creating a restore point.
 */
model RestorePointEncryption {
  /**
   * Describes the parameter of customer managed disk encryption set resource id that can be specified for disk. **Note:** The disk encryption set resource id can only be specified for managed disk. Please refer https://aka.ms/mdssewithcmkoverview for more details.
   */
  diskEncryptionSet?: DiskEncryptionSetParameters;

  /**
   * The type of key used to encrypt the data of the disk restore point.
   */
  type?: RestorePointEncryptionType;
}

/**
 * Describes a data disk.
 */
model RestorePointSourceVMDataDisk {
  /**
   * Gets the logical unit number.
   */
  @visibility("read")
  lun?: int32;

  /**
   * Gets the disk name.
   */
  @visibility("read")
  name?: string;

  /**
   * Gets the caching type.
   */
  @visibility("read")
  caching?: CachingTypes;

  /**
   * Gets the initial disk size in GB for blank data disks, and the new desired size for existing OS and Data disks.
   */
  @visibility("read")
  diskSizeGB?: int32;

  /**
   * Contains the managed disk details.
   */
  managedDisk?: ManagedDiskParameters;

  /**
   * Contains Disk Restore Point properties.
   */
  diskRestorePoint?: DiskRestorePointAttributes;

  /**
   * Shows true if the disk is write-accelerator enabled.
   */
  @visibility("read")
  writeAcceleratorEnabled?: boolean;
}

/**
 * The instance view of a restore point.
 */
model RestorePointInstanceView {
  /**
   * The disk restore points information.
   */
  diskRestorePoints?: DiskRestorePointInstanceView[];

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * The instance view of a disk restore point.
 */
model DiskRestorePointInstanceView {
  /**
   * Disk restore point Id.
   */
  id?: string;

  /**
   * The disk restore point replication status information.
   */
  replicationStatus?: DiskRestorePointReplicationStatus;
}

/**
 * The instance view of a disk restore point.
 */
model DiskRestorePointReplicationStatus {
  /**
   * The resource status information.
   */
  status?: InstanceViewStatus;

  /**
   * Replication completion percentage.
   */
  completionPercent?: int32;
}

/**
 * The resource model definition for an Azure Resource Manager proxy resource. It will not have tags and a location
 */
model ProxyResource {
  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;
}

/**
 * Update Restore Point collection parameters.
 */
model RestorePointCollectionUpdate extends UpdateResource {
  /**
   * The restore point collection properties.
   */
  properties?: RestorePointCollectionProperties;
}

/**
 * capacity reservation group Properties.
 */
model CapacityReservationGroupProperties {
  /**
   * A list of all capacity reservation resource ids that belong to capacity reservation group.
   */
  @visibility("read")
  capacityReservations?: SubResourceReadOnly[];

  /**
   * A list of references to all virtual machines associated to the capacity reservation group.
   */
  @visibility("read")
  virtualMachinesAssociated?: SubResourceReadOnly[];

  /**
   * The capacity reservation group instance view which has the list of instance views for all the capacity reservations that belong to the capacity reservation group.
   */
  @visibility("read")
  instanceView?: CapacityReservationGroupInstanceView;
}

model CapacityReservationGroupInstanceView {
  /**
   * List of instance view of the capacity reservations under the capacity reservation group.
   */
  @visibility("read")
  capacityReservations?: CapacityReservationInstanceViewWithName[];
}

/**
 * The instance view of a capacity reservation that includes the name of the capacity reservation. It is used for the response to the instance view of a capacity reservation group.
 */
model CapacityReservationInstanceViewWithName
  extends CapacityReservationInstanceView {
  /**
   * The name of the capacity reservation.
   */
  @visibility("read")
  name?: string;
}

/**
 * The instance view of a capacity reservation that provides as snapshot of the runtime properties of the capacity reservation that is managed by the platform and can change outside of control plane operations.
 */
model CapacityReservationInstanceView {
  /**
   * Unutilized capacity of the capacity reservation.
   */
  utilizationInfo?: CapacityReservationUtilization;

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * Represents the capacity reservation utilization in terms of resources allocated.
 */
model CapacityReservationUtilization {
  /**
   * The value provides the current capacity of the VM size which was reserved successfully and for which the customer is getting billed. Minimum api-version: 2022-08-01.
   */
  @visibility("read")
  currentCapacity?: int32;

  /**
   * A list of all virtual machines resource ids allocated against the capacity reservation.
   */
  @visibility("read")
  virtualMachinesAllocated?: SubResourceReadOnly[];
}

/**
 * Specifies information about the capacity reservation group. Only tags can be updated.
 */
model CapacityReservationGroupUpdate extends UpdateResource {
  /**
   * capacity reservation group Properties.
   */
  properties?: CapacityReservationGroupProperties;
}

/**
 * Properties of the Capacity reservation.
 */
model CapacityReservationProperties {
  /**
   * A unique id generated and assigned to the capacity reservation by the platform which does not change throughout the lifetime of the resource.
   */
  @visibility("read")
  reservationId?: string;

  /**
   * Specifies the value of fault domain count that Capacity Reservation supports for requested VM size. **Note:** The fault domain count specified for a resource (like virtual machines scale set) must be less than or equal to this value if it deploys using capacity reservation. Minimum api-version: 2022-08-01.
   */
  @visibility("read")
  platformFaultDomainCount?: int32;

  /**
   * A list of all virtual machine resource ids that are associated with the capacity reservation.
   */
  @visibility("read")
  virtualMachinesAssociated?: SubResourceReadOnly[];

  /**
   * The date time when the capacity reservation was last updated.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  provisioningTime?: utcDateTime;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The Capacity reservation instance view.
   */
  @visibility("read")
  instanceView?: CapacityReservationInstanceView;

  /**
   * Specifies the time at which the Capacity Reservation resource was created. Minimum api-version: 2021-11-01.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

/**
 * Specifies information about the capacity reservation. Only tags and sku.capacity can be updated.
 */
model CapacityReservationUpdate extends UpdateResource {
  /**
   * Properties of the Capacity reservation.
   */
  properties?: CapacityReservationProperties;

  /**
   * SKU of the resource for which capacity needs be reserved. The SKU name and capacity is required to be set. Currently VM Skus with the capability called 'CapacityReservationSupported' set to true are supported. Refer to List Microsoft.Compute SKUs in a region (https://docs.microsoft.com/rest/api/compute/resourceskus/list) for supported values.
   */
  sku?: Sku;
}

/**
 * Api request input for LogAnalytics getRequestRateByInterval Api.
 */
model RequestRateByIntervalInput extends LogAnalyticsInputBase {
  /**
   * Interval value in minutes used to create LogAnalytics call rate logs.
   */
  intervalLength: IntervalInMins;
}

/**
 * Api input base class for LogAnalytics Api.
 */
model LogAnalyticsInputBase {
  /**
   * SAS Uri of the logging blob container to which LogAnalytics Api writes output logs to.
   */
  blobContainerSasUri: string;

  /**
   * From time of the query
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  fromTime: utcDateTime;

  /**
   * To time of the query
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  toTime: utcDateTime;

  /**
   * Group query result by Throttle Policy applied.
   */
  groupByThrottlePolicy?: boolean;

  /**
   * Group query result by Operation Name.
   */
  groupByOperationName?: boolean;

  /**
   * Group query result by Resource Name.
   */
  groupByResourceName?: boolean;

  /**
   * Group query result by Client Application ID.
   */
  groupByClientApplicationId?: boolean;

  /**
   * Group query result by User Agent.
   */
  groupByUserAgent?: boolean;
}

/**
 * LogAnalytics operation status response
 */
model LogAnalyticsOperationResult {
  /**
   * LogAnalyticsOutput
   */
  @visibility("read")
  properties?: LogAnalyticsOutput;
}

/**
 * LogAnalytics output properties
 */
model LogAnalyticsOutput {
  /**
   * Output file Uri path to blob container.
   */
  @visibility("read")
  output?: string;
}

/**
 * Api request input for LogAnalytics getThrottledRequests Api.
 */
model ThrottledRequestsInput extends LogAnalyticsInputBase {}

/**
 * Describes the properties of a Run Command metadata.
 */
model RunCommandDocumentBase {
  /**
   * The VM run command schema.
   */
  @encodedName("application/json", "$schema")
  schema: string;

  /**
   * The VM run command id.
   */
  id: string;

  /**
   * The Operating System type.
   */
  osType: OperatingSystemTypes;

  /**
   * The VM run command label.
   */
  label: string;

  /**
   * The VM run command description.
   */
  description: string;
}

/**
 * Describes the properties of a Run Command.
 */
model RunCommandDocument extends RunCommandDocumentBase {
  /**
   * The script to be executed.
   */
  script: string[];

  /**
   * The parameters used by the script.
   */
  parameters?: RunCommandParameterDefinition[];
}

/**
 * Describes the properties of a run command parameter.
 */
model RunCommandParameterDefinition {
  /**
   * The run command parameter name.
   */
  name: string;

  /**
   * The run command parameter type.
   */
  type: string;

  /**
   * The run command parameter default value.
   */
  defaultValue?: string;

  /**
   * The run command parameter required.
   */
  required?: boolean;
}

/**
 * Capture Virtual Machine parameters.
 */
model RunCommandInput {
  /**
   * The run command id.
   */
  commandId: string;

  /**
   * Optional. The script to be executed.  When this value is given, the given script will override the default script of the command.
   */
  script?: string[];

  /**
   * The run command parameters.
   */
  parameters?: RunCommandInputParameter[];
}

/**
 * Describes the properties of a run command parameter.
 */
model RunCommandInputParameter {
  /**
   * The run command parameter name.
   */
  name: string;

  /**
   * The run command parameter value.
   */
  value: string;
}

model RunCommandResult {
  /**
   * Run command operation response.
   */
  value?: InstanceViewStatus[];
}

/**
 * Describes the properties of a Virtual Machine run command.
 */
model VirtualMachineRunCommandProperties {
  /**
   * The source of the run command script.
   */
  source?: VirtualMachineRunCommandScriptSource;

  /**
   * The parameters used by the script.
   */
  parameters?: RunCommandInputParameter[];

  /**
   * The parameters used by the script.
   */
  protectedParameters?: RunCommandInputParameter[];

  /**
   * Optional. If set to true, provisioning will complete as soon as the script starts and will not wait for script to complete.
   */
  asyncExecution?: boolean;

  /**
   * Specifies the user account on the VM when executing the run command.
   */
  runAsUser?: string;

  /**
   * Specifies the user account password on the VM when executing the run command.
   */
  runAsPassword?: string;

  /**
   * The timeout in seconds to execute the run command.
   */
  timeoutInSeconds?: int32;

  /**
   * Specifies the Azure storage blob where script output stream will be uploaded. Use a SAS URI with read, append, create, write access OR use managed identity to provide the VM access to the blob. Refer outputBlobManagedIdentity parameter.
   */
  outputBlobUri?: string;

  /**
   * Specifies the Azure storage blob where script error stream will be uploaded. Use a SAS URI with read, append, create, write access OR use managed identity to provide the VM access to the blob. Refer errorBlobManagedIdentity parameter.
   */
  errorBlobUri?: string;

  /**
   * User-assigned managed identity that has access to outputBlobUri storage blob. Use an empty object in case of system-assigned identity. Make sure managed identity has been given access to blob's container with 'Storage Blob Data Contributor' role assignment. In case of user-assigned identity, make sure you add it under VM's identity. For more info on managed identity and Run Command, refer https://aka.ms/ManagedIdentity and https://aka.ms/RunCommandManaged
   */
  outputBlobManagedIdentity?: RunCommandManagedIdentity;

  /**
   * User-assigned managed identity that has access to errorBlobUri storage blob. Use an empty object in case of system-assigned identity. Make sure managed identity has been given access to blob's container with 'Storage Blob Data Contributor' role assignment. In case of user-assigned identity, make sure you add it under VM's identity. For more info on managed identity and Run Command, refer https://aka.ms/ManagedIdentity and https://aka.ms/RunCommandManaged
   */
  errorBlobManagedIdentity?: RunCommandManagedIdentity;

  /**
   * The provisioning state, which only appears in the response. If treatFailureAsDeploymentFailure set to true, any failure in the script will fail the deployment and ProvisioningState will be marked as Failed. If treatFailureAsDeploymentFailure set to false, ProvisioningState would only reflect whether the run command was run or not by the extensions platform, it would not indicate whether script failed in case of script failures. See instance view of run command in case of script failures to see executionMessage, output, error: https://aka.ms/runcommandmanaged#get-execution-status-and-results
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The virtual machine run command instance view.
   */
  @visibility("read")
  instanceView?: VirtualMachineRunCommandInstanceView;

  /**
   * Optional. If set to true, any failure in the script will fail the deployment and ProvisioningState will be marked as Failed. If set to false, ProvisioningState would only reflect whether the run command was run or not by the extensions platform, it would not indicate whether script failed in case of script failures. See instance view of run command in case of script failures to see executionMessage, output, error: https://aka.ms/runcommandmanaged#get-execution-status-and-results
   */
  treatFailureAsDeploymentFailure?: boolean;
}

/**
 * Describes the script sources for run command. Use only one of script, scriptUri, commandId.
 */
model VirtualMachineRunCommandScriptSource {
  /**
   * Specifies the script content to be executed on the VM.
   */
  script?: string;

  /**
   * Specifies the script download location. It can be either SAS URI of an Azure storage blob with read access or public URI.
   */
  scriptUri?: string;

  /**
   * Specifies a commandId of predefined built-in script.
   */
  commandId?: string;

  /**
   * User-assigned managed identity that has access to scriptUri in case of Azure storage blob. Use an empty object in case of system-assigned identity. Make sure the Azure storage blob exists, and managed identity has been given access to blob's container with 'Storage Blob Data Reader' role assignment. In case of user-assigned identity, make sure you add it under VM's identity. For more info on managed identity and Run Command, refer https://aka.ms/ManagedIdentity and https://aka.ms/RunCommandManaged.
   */
  scriptUriManagedIdentity?: RunCommandManagedIdentity;
}

/**
 *  Contains clientId or objectId (use only one, not both) of a user-assigned managed identity that has access to storage blob used in Run Command. Use an empty RunCommandManagedIdentity object in case of system-assigned identity. Make sure the Azure storage blob exists in case of scriptUri, and managed identity has been given access to blob's container with 'Storage Blob Data Reader' role assignment with scriptUri blob and 'Storage Blob Data Contributor' for Append blobs(outputBlobUri, errorBlobUri). In case of user assigned identity, make sure you add it under VM's identity. For more info on managed identity and Run Command, refer https://aka.ms/ManagedIdentity and https://aka.ms/RunCommandManaged.
 */
model RunCommandManagedIdentity {
  /**
   * Client Id (GUID value) of the user-assigned managed identity. ObjectId should not be used if this is provided.
   */
  clientId?: string;

  /**
   * Object Id (GUID value) of the user-assigned managed identity. ClientId should not be used if this is provided.
   */
  objectId?: string;
}

/**
 * The instance view of a virtual machine run command.
 */
model VirtualMachineRunCommandInstanceView {
  /**
   * Script execution status.
   */
  executionState?: ExecutionState;

  /**
   * Communicate script configuration errors or execution messages.
   */
  executionMessage?: string;

  /**
   * Exit code returned from script execution.
   */
  exitCode?: int32;

  /**
   * Script output stream.
   */
  output?: string;

  /**
   * Script error stream.
   */
  error?: string;

  /**
   * Script start time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * Script end time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  /**
   * The resource status information.
   */
  statuses?: InstanceViewStatus[];
}

/**
 * Describes a Virtual Machine run command.
 */
model VirtualMachineRunCommandUpdate extends UpdateResource {
  /**
   * Describes the properties of a Virtual Machine run command.
   */
  properties?: VirtualMachineRunCommandProperties;
}

/**
 * The disks sku name. Can be Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, StandardSSD_ZRS, or PremiumV2_LRS.
 */
model DiskSku {
  /**
   * The sku name.
   */
  name?: DiskStorageAccountTypes;

  /**
   * The sku tier.
   */
  @visibility("read")
  tier?: string;
}

/**
 * Disk resource properties.
 */
model DiskProperties {
  /**
   * The time when the disk was created.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  /**
   * The Operating System type.
   */
  osType?: OperatingSystemTypes;

  /**
   * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
   */
  hyperVGeneration?: HyperVGeneration;

  /**
   * Purchase plan information for the the image from which the OS disk was created. E.g. - {name: 2019-Datacenter, publisher: MicrosoftWindowsServer, product: WindowsServer}
   */
  purchasePlan?: DiskPurchasePlan;

  /**
   * List of supported capabilities for the image from which the OS disk was created.
   */
  supportedCapabilities?: SupportedCapabilities;

  /**
   * Disk source information. CreationData information cannot be changed after the disk has been created.
   */
  creationData: CreationData;

  /**
   * If creationData.createOption is Empty, this field is mandatory and it indicates the size of the disk to create. If this field is present for updates or creation with other options, it indicates a resize. Resizes are only allowed if the disk is not attached to a running VM, and can only increase the disk's size.
   */
  diskSizeGB?: int32;

  /**
   * The size of the disk in bytes. This field is read only.
   */
  @visibility("read")
  diskSizeBytes?: int64;

  /**
   * Unique Guid identifying the resource.
   */
  @visibility("read")
  uniqueId?: string;

  /**
   * Encryption settings collection used for Azure Disk Encryption, can contain multiple encryption settings per disk or snapshot.
   */
  encryptionSettingsCollection?: EncryptionSettingsCollection;

  /**
   * The disk provisioning state.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes.
   */
  @encodedName("application/json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int64;

  /**
   * The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10.
   */
  diskMBpsReadWrite?: int64;

  /**
   * The total number of IOPS that will be allowed across all VMs mounting the shared disk as ReadOnly. One operation can transfer between 4k and 256k bytes.
   */
  @encodedName("application/json", "diskIOPSReadOnly")
  diskIopsReadOnly?: int64;

  /**
   * The total throughput (MBps) that will be allowed across all VMs mounting the shared disk as ReadOnly. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10.
   */
  diskMBpsReadOnly?: int64;

  /**
   * The state of the disk.
   */
  @visibility("read")
  diskState?: DiskState;

  /**
   * Encryption property can be used to encrypt data at rest with customer managed keys or platform managed keys.
   */
  encryption?: Encryption;

  /**
   * The maximum number of VMs that can attach to the disk at the same time. Value greater than one indicates a disk that can be mounted on multiple VMs at the same time.
   */
  maxShares?: int32;

  /**
   * Details of the list of all VMs that have the disk attached. maxShares should be set to a value greater than one for disks to allow attaching them to multiple VMs.
   */
  @visibility("read")
  shareInfo?: ShareInfoElement[];

  /**
   * Policy for accessing the disk via network.
   */
  networkAccessPolicy?: NetworkAccessPolicy;

  /**
   * ARM id of the DiskAccess resource for using private endpoints on disks.
   */
  diskAccessId?: string;

  /**
   * Latest time when bursting was last enabled on a disk.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  burstingEnabledTime?: utcDateTime;

  /**
   * Performance tier of the disk (e.g, P4, S10) as described here: https://azure.microsoft.com/en-us/pricing/details/managed-disks/. Does not apply to Ultra disks.
   */
  tier?: string;

  /**
   * Set to true to enable bursting beyond the provisioned performance target of the disk. Bursting is disabled by default. Does not apply to Ultra disks.
   */
  burstingEnabled?: boolean;

  /**
   * Properties of the disk for which update is pending.
   */
  @visibility("read")
  propertyUpdatesInProgress?: PropertyUpdatesInProgress;

  /**
   * Indicates the OS on a disk supports hibernation.
   */
  supportsHibernation?: boolean;

  /**
   * Contains the security related information for the resource.
   */
  securityProfile?: DiskSecurityProfile;

  /**
   * Percentage complete for the background copy when a resource is created via the CopyStart operation.
   */
  completionPercent?: float32;

  /**
   * Policy for controlling export on the disk.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * Additional authentication requirements when exporting or uploading to a disk or snapshot.
   */
  dataAccessAuthMode?: DataAccessAuthMode;

  /**
   * Setting this property to true improves reliability and performance of data disks that are frequently (more than 5 times a day) by detached from one virtual machine and attached to another. This property should not be set for disks that are not detached and attached frequently as it causes the disks to not align with the fault domain of the virtual machine.
   */
  optimizedForFrequentAttach?: boolean;

  /**
   * The UTC time when the ownership state of the disk was last changed i.e., the time the disk was last attached or detached from a VM or the time when the VM to which the disk was attached was deallocated or started.
   */
  @visibility("read")
  @encodedName("application/json", "LastOwnershipUpdateTime")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastOwnershipUpdateTime?: utcDateTime;
}

/**
 * Used for establishing the purchase context of any 3rd Party artifact through MarketPlace.
 */
model DiskPurchasePlan {
  /**
   * The plan ID.
   */
  name: string;

  /**
   * The publisher ID.
   */
  publisher: string;

  /**
   * Specifies the product of the image from the marketplace. This is the same value as Offer under the imageReference element.
   */
  product: string;

  /**
   * The Offer Promotion Code.
   */
  promotionCode?: string;
}

/**
 * List of supported capabilities persisted on the disk resource for VM use.
 */
model SupportedCapabilities {
  /**
   * The disk controllers that an OS disk supports. If set it can be SCSI or SCSI, NVME or NVME, SCSI.
   */
  diskControllerTypes?: string;

  /**
   * True if the image from which the OS disk is created supports accelerated networking.
   */
  acceleratedNetwork?: boolean;

  /**
   * CPU architecture supported by an OS disk.
   */
  architecture?: Architecture;
}

/**
 * Data used when creating a disk.
 */
model CreationData {
  /**
   * This enumerates the possible sources of a disk's creation.
   */
  createOption: DiskCreateOption;

  /**
   * Required if createOption is Import. The Azure Resource Manager identifier of the storage account containing the blob to import as a disk.
   */
  storageAccountId?: string;

  /**
   * Disk source information for PIR or user images.
   */
  imageReference?: ImageDiskReference;

  /**
   * Required if creating from a Gallery Image. The id/sharedGalleryImageId/communityGalleryImageId of the ImageDiskReference will be the ARM id of the shared galley image version from which to create a disk.
   */
  galleryImageReference?: ImageDiskReference;

  /**
   * If createOption is Import, this is the URI of a blob to be imported into a managed disk.
   */
  sourceUri?: string;

  /**
   * If createOption is Copy, this is the ARM id of the source snapshot or disk.
   */
  sourceResourceId?: string;

  /**
   * If this field is set, this is the unique id identifying the source of this resource.
   */
  @visibility("read")
  sourceUniqueId?: string;

  /**
   * If createOption is Upload, this is the size of the contents of the upload including the VHD footer. This value should be between 20972032 (20 MiB + 512 bytes for the VHD footer) and 35183298347520 bytes (32 TiB + 512 bytes for the VHD footer).
   */
  uploadSizeBytes?: int64;

  /**
   * Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096. 4096 is the default.
   */
  logicalSectorSize?: int32;

  /**
   * If createOption is ImportSecure, this is the URI of a blob to be imported into VM guest state.
   */
  securityDataUri?: string;

  /**
   * Set this flag to true to get a boost on the performance target of the disk deployed, see here on the respective performance target. This flag can only be set on disk creation time and cannot be disabled after enabled.
   */
  performancePlus?: boolean;

  /**
   * Required if createOption is CopyFromSanSnapshot. This is the ARM id of the source elastic san volume snapshot.
   */
  elasticSanResourceId?: string;
}

/**
 * The source image used for creating the disk.
 */
model ImageDiskReference {
  /**
   * A relative uri containing either a Platform Image Repository, user image, or Azure Compute Gallery image reference.
   */
  id?: string;

  /**
   * A relative uri containing a direct shared Azure Compute Gallery image reference.
   */
  sharedGalleryImageId?: string;

  /**
   * A relative uri containing a community Azure Compute Gallery image reference.
   */
  communityGalleryImageId?: string;

  /**
   * If the disk is created from an image's data disk, this is an index that indicates which of the data disks in the image to use. For OS disks, this field is null.
   */
  lun?: int32;
}

/**
 * Encryption settings for disk or snapshot
 */
model EncryptionSettingsCollection {
  /**
   * Set this flag to true and provide DiskEncryptionKey and optional KeyEncryptionKey to enable encryption. Set this flag to false and remove DiskEncryptionKey and KeyEncryptionKey to disable encryption. If EncryptionSettings is null in the request object, the existing settings remain unchanged.
   */
  enabled: boolean;

  /**
   * A collection of encryption settings, one for each disk volume.
   */
  encryptionSettings?: EncryptionSettingsElement[];

  /**
   * Describes what type of encryption is used for the disks. Once this field is set, it cannot be overwritten. '1.0' corresponds to Azure Disk Encryption with AAD app.'1.1' corresponds to Azure Disk Encryption.
   */
  encryptionSettingsVersion?: string;
}

/**
 * Encryption settings for one disk volume.
 */
model EncryptionSettingsElement {
  /**
   * Key Vault Secret Url and vault id of the disk encryption key
   */
  diskEncryptionKey?: KeyVaultAndSecretReference;

  /**
   * Key Vault Key Url and vault id of the key encryption key. KeyEncryptionKey is optional and when provided is used to unwrap the disk encryption key.
   */
  keyEncryptionKey?: KeyVaultAndKeyReference;
}

/**
 * Key Vault Secret Url and vault id of the encryption key
 */
model KeyVaultAndSecretReference {
  /**
   * Resource id of the KeyVault containing the key or secret
   */
  sourceVault: SourceVault;

  /**
   * Url pointing to a key or secret in KeyVault
   */
  secretUrl: string;
}

/**
 * The vault id is an Azure Resource Manager Resource id in the form /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}
 */
model SourceVault {
  /**
   * Resource Id
   */
  id?: string;
}

/**
 * Key Vault Key Url and vault id of KeK, KeK is optional and when provided is used to unwrap the encryptionKey
 */
model KeyVaultAndKeyReference {
  /**
   * Resource id of the KeyVault containing the key or secret
   */
  sourceVault: SourceVault;

  /**
   * Url pointing to a key or secret in KeyVault
   */
  keyUrl: string;
}

/**
 * Encryption at rest settings for disk or snapshot
 */
model Encryption {
  /**
   * ResourceId of the disk encryption set to use for enabling encryption at rest.
   */
  diskEncryptionSetId?: string;

  /**
   * The type of key used to encrypt the data of the disk.
   */
  type?: EncryptionType;
}

model ShareInfoElement {
  /**
   * A relative URI containing the ID of the VM that has the disk attached.
   */
  @visibility("read")
  vmUri?: string;
}

/**
 * Properties of the disk for which update is pending.
 */
model PropertyUpdatesInProgress {
  /**
   * The target performance tier of the disk if a tier change operation is in progress.
   */
  targetTier?: string;
}

/**
 * Contains the security related information for the resource.
 */
model DiskSecurityProfile {
  /**
   * Specifies the SecurityType of the VM. Applicable for OS disks only.
   */
  securityType?: DiskSecurityTypes;

  /**
   * ResourceId of the disk encryption set associated to Confidential VM supported disk encrypted with customer managed key
   */
  secureVMDiskEncryptionSetId?: string;
}

/**
 * Disk update resource.
 */
model DiskUpdate {
  /**
   * Disk resource update properties.
   */
  properties?: DiskUpdateProperties;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * The disks sku name. Can be Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, StandardSSD_ZRS, or PremiumV2_LRS.
   */
  sku?: DiskSku;
}

/**
 * Disk resource update properties.
 */
model DiskUpdateProperties {
  /**
   * the Operating System type.
   */
  osType?: OperatingSystemTypes;

  /**
   * If creationData.createOption is Empty, this field is mandatory and it indicates the size of the disk to create. If this field is present for updates or creation with other options, it indicates a resize. Resizes are only allowed if the disk is not attached to a running VM, and can only increase the disk's size.
   */
  diskSizeGB?: int32;

  /**
   * Encryption settings collection used be Azure Disk Encryption, can contain multiple encryption settings per disk or snapshot.
   */
  encryptionSettingsCollection?: EncryptionSettingsCollection;

  /**
   * The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes.
   */
  @encodedName("application/json", "diskIOPSReadWrite")
  diskIopsReadWrite?: int64;

  /**
   * The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10.
   */
  diskMBpsReadWrite?: int64;

  /**
   * The total number of IOPS that will be allowed across all VMs mounting the shared disk as ReadOnly. One operation can transfer between 4k and 256k bytes.
   */
  @encodedName("application/json", "diskIOPSReadOnly")
  diskIopsReadOnly?: int64;

  /**
   * The total throughput (MBps) that will be allowed across all VMs mounting the shared disk as ReadOnly. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10.
   */
  diskMBpsReadOnly?: int64;

  /**
   * The maximum number of VMs that can attach to the disk at the same time. Value greater than one indicates a disk that can be mounted on multiple VMs at the same time.
   */
  maxShares?: int32;

  /**
   * Encryption property can be used to encrypt data at rest with customer managed keys or platform managed keys.
   */
  encryption?: Encryption;

  /**
   * Policy for accessing the disk via network.
   */
  networkAccessPolicy?: NetworkAccessPolicy;

  /**
   * ARM id of the DiskAccess resource for using private endpoints on disks.
   */
  diskAccessId?: string;

  /**
   * Performance tier of the disk (e.g, P4, S10) as described here: https://azure.microsoft.com/en-us/pricing/details/managed-disks/. Does not apply to Ultra disks.
   */
  tier?: string;

  /**
   * Set to true to enable bursting beyond the provisioned performance target of the disk. Bursting is disabled by default. Does not apply to Ultra disks.
   */
  burstingEnabled?: boolean;

  /**
   * Purchase plan information to be added on the OS disk
   */
  purchasePlan?: DiskPurchasePlan;

  /**
   * List of supported capabilities to be added on the OS disk.
   */
  supportedCapabilities?: SupportedCapabilities;

  /**
   * Properties of the disk for which update is pending.
   */
  @visibility("read")
  propertyUpdatesInProgress?: PropertyUpdatesInProgress;

  /**
   * Indicates the OS on a disk supports hibernation.
   */
  supportsHibernation?: boolean;

  /**
   * Policy for controlling export on the disk.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * Additional authentication requirements when exporting or uploading to a disk or snapshot.
   */
  dataAccessAuthMode?: DataAccessAuthMode;

  /**
   * Setting this property to true improves reliability and performance of data disks that are frequently (more than 5 times a day) by detached from one virtual machine and attached to another. This property should not be set for disks that are not detached and attached frequently as it causes the disks to not align with the fault domain of the virtual machine.
   */
  optimizedForFrequentAttach?: boolean;
}

/**
 * Data used for requesting a SAS.
 */
model GrantAccessData {
  /**
   * The Access Level, accepted values include None, Read, Write.
   */
  access: AccessLevel;

  /**
   * Time duration in seconds until the SAS access expires.
   */
  durationInSeconds: int32;

  /**
   * Set this flag to true to get additional SAS for VM guest state
   */
  getSecureVMGuestStateSAS?: boolean;

  /**
   * Used to specify the file format when making request for SAS on a VHDX file format snapshot
   */
  fileFormat?: FileFormat;
}

/**
 * A disk access SAS uri.
 */
model AccessUri {
  /**
   * A SAS uri for accessing a disk.
   */
  @visibility("read")
  accessSAS?: string;

  /**
   * A SAS uri for accessing a VM guest state.
   */
  @visibility("read")
  securityDataAccessSAS?: string;
}

model DiskAccessProperties {
  /**
   * A readonly collection of private endpoint connections created on the disk. Currently only one endpoint connection is supported.
   */
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];

  /**
   * The disk access resource provisioning state.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The time when the disk access was created.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

/**
 * Properties of the PrivateEndpointConnectProperties.
 */
model PrivateEndpointConnectionProperties {
  /**
   * The resource of private end point.
   */
  @visibility("read")
  privateEndpoint?: PrivateEndpoint;

  /**
   * A collection of information about the state of the connection between DiskAccess and Virtual Network.
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
  actionsRequired?: string;
}

/**
 * Used for updating a disk access resource.
 */
model DiskAccessUpdate {
  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
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
model PrivateLinkResource {
  /**
   * Resource properties.
   */
  properties?: PrivateLinkResourceProperties;

  /**
   * private link resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * private link resource name
   */
  @visibility("read")
  name?: string;

  /**
   * private link resource type
   */
  @visibility("read")
  type?: string;
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
   * The private link resource DNS zone name.
   */
  requiredZoneNames?: string[];
}

/**
 * The managed identity for the disk encryption set. It should be given permission on the key vault before it can be used to encrypt disks.
 */
model EncryptionSetIdentity {
  /**
   * The type of Managed Identity used by the DiskEncryptionSet. Only SystemAssigned is supported for new creations. Disk Encryption Sets can be updated with Identity type None during migration of subscription to a new Azure Active Directory tenant; it will cause the encrypted resources to lose access to the keys.
   */
  type?: DiskEncryptionSetIdentityType;

  /**
   * The object id of the Managed Identity Resource. This will be sent to the RP from ARM via the x-ms-identity-principal-id header in the PUT request if the resource has a systemAssigned(implicit) identity
   */
  @visibility("read")
  principalId?: string;

  /**
   * The tenant id of the Managed Identity Resource. This will be sent to the RP from ARM via the x-ms-client-tenant-id header in the PUT request if the resource has a systemAssigned(implicit) identity
   */
  @visibility("read")
  tenantId?: string;

  /**
   * The list of user identities associated with the disk encryption set. The user identity dictionary key references will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  userAssignedIdentities?: Record<UserAssignedIdentitiesValue>;
}

model EncryptionSetProperties {
  /**
   * The type of key used to encrypt the data of the disk.
   */
  encryptionType?: DiskEncryptionSetType;

  /**
   * The key vault key which is currently used by this disk encryption set.
   */
  activeKey?: KeyForDiskEncryptionSet;

  /**
   * A readonly collection of key vault keys previously used by this disk encryption set while a key rotation is in progress. It will be empty if there is no ongoing key rotation.
   */
  @visibility("read")
  previousKeys?: KeyForDiskEncryptionSet[];

  /**
   * The disk encryption set provisioning state.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Set this flag to true to enable auto-updating of this disk encryption set to the latest key version.
   */
  rotationToLatestKeyVersionEnabled?: boolean;

  /**
   * The time when the active key of this disk encryption set was updated.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastKeyRotationTimestamp?: utcDateTime;

  /**
   * The error that was encountered during auto-key rotation. If an error is present, then auto-key rotation will not be attempted until the error on this disk encryption set is fixed.
   */
  @visibility("read")
  autoKeyRotationError?: ApiError;

  /**
   * Multi-tenant application client id to access key vault in a different tenant. Setting the value to 'None' will clear the property.
   */
  federatedClientId?: string;
}

/**
 * Key Vault Key Url to be used for server side encryption of Managed Disks and Snapshots
 */
model KeyForDiskEncryptionSet {
  /**
   * Resource id of the KeyVault containing the key or secret. This property is optional and cannot be used if the KeyVault subscription is not the same as the Disk Encryption Set subscription.
   */
  sourceVault?: SourceVault;

  /**
   * Fully versioned Key Url pointing to a key in KeyVault. Version segment of the Url is required regardless of rotationToLatestKeyVersionEnabled value.
   */
  keyUrl: string;
}

/**
 * disk encryption set update resource.
 */
model DiskEncryptionSetUpdate {
  /**
   * disk encryption set resource update properties.
   */
  properties?: DiskEncryptionSetUpdateProperties;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * The managed identity for the disk encryption set. It should be given permission on the key vault before it can be used to encrypt disks.
   */
  identity?: EncryptionSetIdentity;
}

/**
 * disk encryption set resource update properties.
 */
model DiskEncryptionSetUpdateProperties {
  /**
   * The type of key used to encrypt the data of the disk.
   */
  encryptionType?: DiskEncryptionSetType;

  /**
   * Key Vault Key Url to be used for server side encryption of Managed Disks and Snapshots
   */
  activeKey?: KeyForDiskEncryptionSet;

  /**
   * Set this flag to true to enable auto-updating of this disk encryption set to the latest key version.
   */
  rotationToLatestKeyVersionEnabled?: boolean;

  /**
   * Multi-tenant application client id to access key vault in a different tenant. Setting the value to 'None' will clear the property.
   */
  federatedClientId?: string;
}

/**
 * The List resources which are encrypted with the disk encryption set.
 */
model ResourceUriList is Azure.Core.Page<string>;

/**
 * Properties of an incremental disk restore point
 */
model DiskRestorePointProperties {
  /**
   * The timestamp of restorePoint creation
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  /**
   * arm id of source disk or source disk restore point.
   */
  @visibility("read")
  sourceResourceId?: string;

  /**
   * The Operating System type.
   */
  @visibility("read")
  osType?: OperatingSystemTypes;

  /**
   * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
   */
  hyperVGeneration?: HyperVGeneration;

  /**
   * Purchase plan information for the the image from which the OS disk was created.
   */
  purchasePlan?: DiskPurchasePlan;

  /**
   * List of supported capabilities for the image from which the OS disk was created.
   */
  supportedCapabilities?: SupportedCapabilities;

  /**
   * id of the backing snapshot's MIS family
   */
  @visibility("read")
  familyId?: string;

  /**
   * unique incarnation id of the source disk
   */
  @visibility("read")
  sourceUniqueId?: string;

  /**
   * Encryption property can be used to encrypt data at rest with customer managed keys or platform managed keys.
   */
  @visibility("read")
  encryption?: Encryption;

  /**
   * Indicates the OS on a disk supports hibernation.
   */
  supportsHibernation?: boolean;

  /**
   * Policy for accessing the disk via network.
   */
  networkAccessPolicy?: NetworkAccessPolicy;

  /**
   * Policy for controlling export on the disk.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * ARM id of the DiskAccess resource for using private endpoints on disks.
   */
  diskAccessId?: string;

  /**
   * Percentage complete for the background copy of disk restore point when source resource is from a different region.
   */
  completionPercent?: float32;

  /**
   * Replication state of disk restore point when source resource is from a different region.
   */
  @visibility("read")
  replicationState?: string;

  /**
   * Location of source disk or source disk restore point when source resource is from a different region.
   */
  @visibility("read")
  sourceResourceLocation?: string;

  /**
   * Contains the security related information for the resource.
   */
  securityProfile?: DiskSecurityProfile;
}

/**
 * The ProxyOnly Resource model definition.
 */
model ProxyOnlyResource {
  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;
}

/**
 * The snapshots sku name. Can be Standard_LRS, Premium_LRS, or Standard_ZRS. This is an optional parameter for incremental snapshot and the default behavior is the SKU will be set to the same sku as the previous snapshot
 */
model SnapshotSku {
  /**
   * The sku name.
   */
  name?: SnapshotStorageAccountTypes;

  /**
   * The sku tier.
   */
  @visibility("read")
  tier?: string;
}

/**
 * Snapshot resource properties.
 */
model SnapshotProperties {
  /**
   * The time when the snapshot was created.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;

  /**
   * The Operating System type.
   */
  osType?: OperatingSystemTypes;

  /**
   * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
   */
  hyperVGeneration?: HyperVGeneration;

  /**
   * Purchase plan information for the image from which the source disk for the snapshot was originally created.
   */
  purchasePlan?: DiskPurchasePlan;

  /**
   * List of supported capabilities for the image from which the source disk from the snapshot was originally created.
   */
  supportedCapabilities?: SupportedCapabilities;

  /**
   * Disk source information. CreationData information cannot be changed after the disk has been created.
   */
  creationData: CreationData;

  /**
   * If creationData.createOption is Empty, this field is mandatory and it indicates the size of the disk to create. If this field is present for updates or creation with other options, it indicates a resize. Resizes are only allowed if the disk is not attached to a running VM, and can only increase the disk's size.
   */
  diskSizeGB?: int32;

  /**
   * The size of the disk in bytes. This field is read only.
   */
  @visibility("read")
  diskSizeBytes?: int64;

  /**
   * The state of the snapshot.
   */
  @visibility("read")
  diskState?: DiskState;

  /**
   * Unique Guid identifying the resource.
   */
  @visibility("read")
  uniqueId?: string;

  /**
   * Encryption settings collection used be Azure Disk Encryption, can contain multiple encryption settings per disk or snapshot.
   */
  encryptionSettingsCollection?: EncryptionSettingsCollection;

  /**
   * The disk provisioning state.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Whether a snapshot is incremental. Incremental snapshots on the same disk occupy less space than full snapshots and can be diffed.
   */
  incremental?: boolean;

  /**
   * Incremental snapshots for a disk share an incremental snapshot family id. The Get Page Range Diff API can only be called on incremental snapshots with the same family id.
   */
  @visibility("read")
  incrementalSnapshotFamilyId?: string;

  /**
   * Encryption property can be used to encrypt data at rest with customer managed keys or platform managed keys.
   */
  encryption?: Encryption;

  /**
   * Policy for accessing the disk via network.
   */
  networkAccessPolicy?: NetworkAccessPolicy;

  /**
   * ARM id of the DiskAccess resource for using private endpoints on disks.
   */
  diskAccessId?: string;

  /**
   * Contains the security related information for the resource.
   */
  securityProfile?: DiskSecurityProfile;

  /**
   * Indicates the OS on a snapshot supports hibernation.
   */
  supportsHibernation?: boolean;

  /**
   * Policy for controlling export on the disk.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * Percentage complete for the background copy when a resource is created via the CopyStart operation.
   */
  completionPercent?: float32;

  /**
   * Indicates the error details if the background copy of a resource created via the CopyStart operation fails.
   */
  copyCompletionError?: CopyCompletionError;

  /**
   * Additional authentication requirements when exporting or uploading to a disk or snapshot.
   */
  dataAccessAuthMode?: DataAccessAuthMode;
}

/**
 * Indicates the error details if the background copy of a resource created via the CopyStart operation fails.
 */
model CopyCompletionError {
  /**
   * Indicates the error code if the background copy of a resource created via the CopyStart operation fails.
   */
  errorCode: CopyCompletionErrorReason;

  /**
   * Indicates the error message if the background copy of a resource created via the CopyStart operation fails.
   */
  errorMessage: string;
}

/**
 * Snapshot update resource.
 */
model SnapshotUpdate {
  /**
   * Snapshot resource update properties.
   */
  properties?: SnapshotUpdateProperties;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * The snapshots sku name. Can be Standard_LRS, Premium_LRS, or Standard_ZRS. This is an optional parameter for incremental snapshot and the default behavior is the SKU will be set to the same sku as the previous snapshot
   */
  sku?: SnapshotSku;
}

/**
 * Snapshot resource update properties.
 */
model SnapshotUpdateProperties {
  /**
   * the Operating System type.
   */
  osType?: OperatingSystemTypes;

  /**
   * If creationData.createOption is Empty, this field is mandatory and it indicates the size of the disk to create. If this field is present for updates or creation with other options, it indicates a resize. Resizes are only allowed if the disk is not attached to a running VM, and can only increase the disk's size.
   */
  diskSizeGB?: int32;

  /**
   * Encryption settings collection used be Azure Disk Encryption, can contain multiple encryption settings per disk or snapshot.
   */
  encryptionSettingsCollection?: EncryptionSettingsCollection;

  /**
   * Encryption property can be used to encrypt data at rest with customer managed keys or platform managed keys.
   */
  encryption?: Encryption;

  /**
   * Policy for accessing the disk via network.
   */
  networkAccessPolicy?: NetworkAccessPolicy;

  /**
   * ARM id of the DiskAccess resource for using private endpoints on disks.
   */
  diskAccessId?: string;

  /**
   * Indicates the OS on a snapshot supports hibernation.
   */
  supportsHibernation?: boolean;

  /**
   * Policy for controlling export on the disk.
   */
  publicNetworkAccess?: PublicNetworkAccess;

  /**
   * Additional authentication requirements when exporting or uploading to a disk or snapshot.
   */
  dataAccessAuthMode?: DataAccessAuthMode;

  /**
   * List of supported capabilities for the image from which the OS disk was created.
   */
  supportedCapabilities?: SupportedCapabilities;
}

/**
 * The List Resource Skus operation response.
 */
model ResourceSkusResult is Azure.Core.Page<ResourceSku>;

/**
 * Describes an available Compute SKU.
 */
model ResourceSku {
  /**
   * The type of resource the SKU applies to.
   */
  @visibility("read")
  resourceType?: string;

  /**
   * The name of SKU.
   */
  @visibility("read")
  name?: string;

  /**
   * Specifies the tier of virtual machines in a scale set.<br /><br /> Possible Values:<br /><br /> **Standard**<br /><br /> **Basic**
   */
  @visibility("read")
  tier?: string;

  /**
   * The Size of the SKU.
   */
  @visibility("read")
  size?: string;

  /**
   * The Family of this particular SKU.
   */
  @visibility("read")
  family?: string;

  /**
   * The Kind of resources that are supported in this SKU.
   */
  @visibility("read")
  kind?: string;

  /**
   * Specifies the number of virtual machines in the scale set.
   */
  @visibility("read")
  capacity?: ResourceSkuCapacity;

  /**
   * The set of locations that the SKU is available.
   */
  @visibility("read")
  locations?: string[];

  /**
   * A list of locations and availability zones in those locations where the SKU is available.
   */
  @visibility("read")
  locationInfo?: ResourceSkuLocationInfo[];

  /**
   * The api versions that support this SKU.
   */
  @visibility("read")
  apiVersions?: string[];

  /**
   * Metadata for retrieving price info.
   */
  @visibility("read")
  costs?: ResourceSkuCosts[];

  /**
   * A name value pair to describe the capability.
   */
  @visibility("read")
  capabilities?: ResourceSkuCapabilities[];

  /**
   * The restrictions because of which SKU cannot be used. This is empty if there are no restrictions.
   */
  @visibility("read")
  restrictions?: ResourceSkuRestrictions[];
}

/**
 * Describes scaling information of a SKU.
 */
model ResourceSkuCapacity {
  /**
   * The minimum capacity.
   */
  @visibility("read")
  minimum?: int64;

  /**
   * The maximum capacity that can be set.
   */
  @visibility("read")
  maximum?: int64;

  /**
   * The default capacity.
   */
  @visibility("read")
  default?: int64;

  /**
   * The scale type applicable to the sku.
   */
  @visibility("read")
  scaleType?: ResourceSkuCapacityScaleType;
}

/**
 * Describes an available Compute SKU Location Information.
 */
model ResourceSkuLocationInfo {
  /**
   * Location of the SKU
   */
  @visibility("read")
  location?: string;

  /**
   * List of availability zones where the SKU is supported.
   */
  @visibility("read")
  zones?: string[];

  /**
   * Details of capabilities available to a SKU in specific zones.
   */
  @visibility("read")
  zoneDetails?: ResourceSkuZoneDetails[];

  /**
   * The names of extended locations.
   */
  @visibility("read")
  extendedLocations?: string[];

  /**
   * The type of the extended location.
   */
  @visibility("read")
  type?: ExtendedLocationType;
}

/**
 * Describes The zonal capabilities of a SKU.
 */
model ResourceSkuZoneDetails {
  /**
   * The set of zones that the SKU is available in with the specified capabilities.
   */
  @visibility("read")
  name?: string[];

  /**
   * A list of capabilities that are available for the SKU in the specified list of zones.
   */
  @visibility("read")
  capabilities?: ResourceSkuCapabilities[];
}

/**
 * Describes The SKU capabilities object.
 */
model ResourceSkuCapabilities {
  /**
   * An invariant to describe the feature.
   */
  @visibility("read")
  name?: string;

  /**
   * An invariant if the feature is measured by quantity.
   */
  @visibility("read")
  value?: string;
}

/**
 * Describes metadata for retrieving price info.
 */
model ResourceSkuCosts {
  /**
   * Used for querying price from commerce.
   */
  @visibility("read")
  meterID?: string;

  /**
   * The multiplier is needed to extend the base metered cost.
   */
  @visibility("read")
  quantity?: int64;

  /**
   * An invariant to show the extended unit.
   */
  @visibility("read")
  extendedUnit?: string;
}

/**
 * Describes scaling information of a SKU.
 */
model ResourceSkuRestrictions {
  /**
   * The type of restrictions.
   */
  @visibility("read")
  type?: ResourceSkuRestrictionsType;

  /**
   * The value of restrictions. If the restriction type is set to location. This would be different locations where the SKU is restricted.
   */
  @visibility("read")
  values?: string[];

  /**
   * The information about the restriction where the SKU cannot be used.
   */
  @visibility("read")
  restrictionInfo?: ResourceSkuRestrictionInfo;

  /**
   * The reason for restriction.
   */
  @visibility("read")
  reasonCode?: ResourceSkuRestrictionsReasonCode;
}

/**
 * Describes an available Compute SKU Restriction Information.
 */
model ResourceSkuRestrictionInfo {
  /**
   * Locations where the SKU is restricted
   */
  @visibility("read")
  locations?: string[];

  /**
   * List of availability zones where the SKU is restricted.
   */
  @visibility("read")
  zones?: string[];
}

/**
 * Describes the properties of a Shared Image Gallery.
 */
model GalleryProperties {
  /**
   * The description of this Shared Image Gallery resource. This property is updatable.
   */
  description?: string;

  /**
   * Describes the gallery unique name.
   */
  identifier?: GalleryIdentifier;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  /**
   * Profile for gallery sharing to subscription or tenant
   */
  sharingProfile?: SharingProfile;

  /**
   * Contains information about the soft deletion policy of the gallery.
   */
  softDeletePolicy?: SoftDeletePolicy;

  /**
   * Sharing status of current gallery.
   */
  @visibility("read")
  sharingStatus?: SharingStatus;
}

/**
 * Describes the gallery unique name.
 */
model GalleryIdentifier {
  /**
   * The unique name of the Shared Image Gallery. This name is generated automatically by Azure.
   */
  @visibility("read")
  uniqueName?: string;
}

/**
 * Profile for gallery sharing to subscription or tenant
 */
model SharingProfile {
  /**
   * This property allows you to specify the permission of sharing gallery. <br><br> Possible values are: <br><br> **Private** <br><br> **Groups** <br><br> **Community**
   */
  permissions?: GallerySharingPermissionTypes;

  /**
   * A list of sharing profile groups.
   */
  @visibility("read")
  groups?: SharingProfileGroup[];

  /**
   * Information of community gallery if current gallery is shared to community.
   */
  communityGalleryInfo?: CommunityGalleryInfo;
}

/**
 * Group of the gallery sharing profile
 */
model SharingProfileGroup {
  /**
   * This property allows you to specify the type of sharing group. <br><br> Possible values are: <br><br> **Subscriptions** <br><br> **AADTenants**
   */
  type?: SharingProfileGroupTypes;

  /**
   * A list of subscription/tenant ids the gallery is aimed to be shared to.
   */
  ids?: string[];
}

/**
 * Information of community gallery if current gallery is shared to community
 */
model CommunityGalleryInfo {
  /**
   * The link to the publisher website. Visible to all users.
   */
  publisherUri?: string;

  /**
   * Community gallery publisher support email. The email address of the publisher. Visible to all users.
   */
  publisherContact?: string;

  /**
   * End-user license agreement for community gallery image.
   */
  eula?: string;

  /**
   * The prefix of the gallery name that will be displayed publicly. Visible to all users.
   */
  publicNamePrefix?: string;

  /**
   * Contains info about whether community gallery sharing is enabled.
   */
  @visibility("read")
  communityGalleryEnabled?: boolean;

  /**
   * Community gallery public name list.
   */
  @visibility("read")
  publicNames?: string[];
}

/**
 * Contains information about the soft deletion policy of the gallery.
 */
model SoftDeletePolicy {
  /**
   * Enables soft-deletion for resources in this gallery, allowing them to be recovered within retention time.
   */
  isSoftDeleteEnabled?: boolean;
}

/**
 * Sharing status of current gallery.
 */
model SharingStatus {
  /**
   * Aggregated sharing state of current gallery.
   */
  @visibility("read")
  aggregatedState?: SharingState;

  /**
   * Summary of all regional sharing status.
   */
  summary?: RegionalSharingStatus[];
}

/**
 * Gallery regional sharing status
 */
model RegionalSharingStatus {
  /**
   * Region name
   */
  region?: string;

  /**
   * Gallery sharing state in current region
   */
  @visibility("read")
  state?: SharingState;

  /**
   * Details of gallery regional sharing failure.
   */
  details?: string;
}

/**
 * Specifies information about the Shared Image Gallery that you want to update.
 */
model GalleryUpdate extends UpdateResourceDefinition {
  /**
   * Describes the properties of a Shared Image Gallery.
   */
  properties?: GalleryProperties;
}

/**
 * The Update Resource model definition.
 */
model UpdateResourceDefinition {
  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Describes the properties of a gallery image definition.
 */
model GalleryImageProperties {
  /**
   * The description of this gallery image definition resource. This property is updatable.
   */
  description?: string;

  /**
   * The Eula agreement for the gallery image definition.
   */
  eula?: string;

  /**
   * The privacy statement uri.
   */
  privacyStatementUri?: string;

  /**
   * The release note uri.
   */
  releaseNoteUri?: string;

  /**
   * This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**
   */
  osType: OperatingSystemTypes;

  /**
   * This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'.
   */
  osState: OperatingSystemStateTypes;

  /**
   * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
   */
  hyperVGeneration?: HyperVGeneration;

  /**
   * The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * This is the gallery image definition identifier.
   */
  identifier: GalleryImageIdentifier;

  /**
   * The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.
   */
  recommended?: RecommendedMachineConfiguration;

  /**
   * Describes the disallowed disk types.
   */
  disallowed?: Disallowed;

  /**
   * Describes the gallery image definition purchase plan. This is used by marketplace images.
   */
  purchasePlan?: ImagePurchasePlan;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  /**
   * A list of gallery image features.
   */
  features?: GalleryImageFeature[];

  /**
   * The architecture of the image. Applicable to OS disks only.
   */
  architecture?: Architecture;
}

/**
 * This is the gallery image definition identifier.
 */
model GalleryImageIdentifier {
  /**
   * The name of the gallery image definition publisher.
   */
  publisher: string;

  /**
   * The name of the gallery image definition offer.
   */
  offer: string;

  /**
   * The name of the gallery image definition SKU.
   */
  sku: string;
}

/**
 * The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.
 */
model RecommendedMachineConfiguration {
  /**
   * Describes the resource range.
   */
  vCPUs?: ResourceRange;

  /**
   * Describes the resource range.
   */
  memory?: ResourceRange;
}

/**
 * Describes the resource range.
 */
model ResourceRange {
  /**
   * The minimum number of the resource.
   */
  min?: int32;

  /**
   * The maximum number of the resource.
   */
  max?: int32;
}

/**
 * Describes the disallowed disk types.
 */
model Disallowed {
  /**
   * A list of disk types.
   */
  diskTypes?: string[];
}

/**
 * Describes the gallery image definition purchase plan. This is used by marketplace images.
 */
model ImagePurchasePlan {
  /**
   * The plan ID.
   */
  name?: string;

  /**
   * The publisher ID.
   */
  publisher?: string;

  /**
   * The product ID.
   */
  product?: string;
}

/**
 * A feature for gallery image.
 */
model GalleryImageFeature {
  /**
   * The name of the gallery image feature.
   */
  name?: string;

  /**
   * The value of the gallery image feature.
   */
  value?: string;
}

/**
 * Specifies information about the gallery image definition that you want to update.
 */
model GalleryImageUpdate extends UpdateResourceDefinition {
  /**
   * Describes the properties of a gallery image definition.
   */
  properties?: GalleryImageProperties;
}

/**
 * Describes the properties of a gallery image version.
 */
model GalleryImageVersionProperties {
  /**
   * The publishing profile of a gallery image Version.
   */
  publishingProfile?: GalleryImageVersionPublishingProfile;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  /**
   * This is the storage profile of a Gallery Image Version.
   */
  storageProfile: GalleryImageVersionStorageProfile;

  /**
   * This is the safety profile of the Gallery Image Version.
   */
  safetyProfile?: GalleryImageVersionSafetyProfile;

  /**
   * This is the replication status of the gallery image version.
   */
  @visibility("read")
  replicationStatus?: ReplicationStatus;
}

/**
 * The publishing profile of a gallery image Version.
 */
model GalleryImageVersionPublishingProfile
  extends GalleryArtifactPublishingProfileBase {}

/**
 * Describes the basic gallery artifact publishing profile.
 */
model GalleryArtifactPublishingProfileBase {
  /**
   * The target regions where the Image Version is going to be replicated to. This property is updatable.
   */
  targetRegions?: TargetRegion[];

  /**
   * The number of replicas of the Image Version to be created per region. This property would take effect for a region when regionalReplicaCount is not specified. This property is updatable.
   */
  replicaCount?: int32;

  /**
   * If set to true, Virtual Machines deployed from the latest version of the Image Definition won't use this Image Version.
   */
  excludeFromLatest?: boolean;

  /**
   * The timestamp for when the gallery image version is published.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  /**
   * The end of life date of the gallery image version. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * Specifies the storage account type to be used to store the image. This property is not updatable.
   */
  storageAccountType?: StorageAccountType;

  /**
   * Optional parameter which specifies the mode to be used for replication. This property is not updatable.
   */
  replicationMode?: ReplicationMode;

  /**
   * The target extended locations where the Image Version is going to be replicated to. This property is updatable.
   */
  targetExtendedLocations?: GalleryTargetExtendedLocation[];
}

/**
 * Describes the target region information.
 */
model TargetRegion {
  /**
   * The name of the region.
   */
  name: string;

  /**
   * The number of replicas of the Image Version to be created per region. This property is updatable.
   */
  regionalReplicaCount?: int32;

  /**
   * Specifies the storage account type to be used to store the image. This property is not updatable.
   */
  storageAccountType?: StorageAccountType;

  /**
   * Optional. Allows users to provide customer managed keys for encrypting the OS and data disks in the gallery artifact.
   */
  encryption?: EncryptionImages;

  /**
   * Contains the flag setting to hide an image when users specify version='latest'
   */
  excludeFromLatest?: boolean;
}

/**
 * Optional. Allows users to provide customer managed keys for encrypting the OS and data disks in the gallery artifact.
 */
model EncryptionImages {
  /**
   * Contains encryption settings for an OS disk image.
   */
  osDiskImage?: OSDiskImageEncryption;

  /**
   * A list of encryption specifications for data disk images.
   */
  dataDiskImages?: DataDiskImageEncryption[];
}

/**
 * Contains encryption settings for an OS disk image.
 */
model OSDiskImageEncryption extends DiskImageEncryption {
  /**
   * This property specifies the security profile of an OS disk image.
   */
  securityProfile?: OSDiskImageSecurityProfile;
}

/**
 * Contains security profile for an OS disk image.
 */
model OSDiskImageSecurityProfile {
  /**
   * confidential VM encryption types
   */
  confidentialVMEncryptionType?: ConfidentialVMEncryptionType;

  /**
   * secure VM disk encryption set id
   */
  secureVMDiskEncryptionSetId?: string;
}

/**
 * This is the disk image encryption base class.
 */
model DiskImageEncryption {
  /**
   * A relative URI containing the resource ID of the disk encryption set.
   */
  diskEncryptionSetId?: string;
}

/**
 * Contains encryption settings for a data disk image.
 */
model DataDiskImageEncryption extends DiskImageEncryption {
  /**
   * This property specifies the logical unit number of the data disk. This value is used to identify data disks within the Virtual Machine and therefore must be unique for each data disk attached to the Virtual Machine.
   */
  lun: int32;
}

model GalleryTargetExtendedLocation {
  /**
   * The name of the region.
   */
  name?: string;

  /**
   * The name of the extended location.
   */
  extendedLocation?: GalleryExtendedLocation;

  /**
   * The number of replicas of the Image Version to be created per extended location. This property is updatable.
   */
  extendedLocationReplicaCount?: int32;

  /**
   * Specifies the storage account type to be used to store the image. This property is not updatable.
   */
  storageAccountType?: EdgeZoneStorageAccountType;

  /**
   * Optional. Allows users to provide customer managed keys for encrypting the OS and data disks in the gallery artifact.
   */
  encryption?: EncryptionImages;
}

/**
 * The name of the extended location.
 */
model GalleryExtendedLocation {
  name?: string;

  /**
   * It is type of the extended location.
   */
  type?: GalleryExtendedLocationType;
}

/**
 * This is the storage profile of a Gallery Image Version.
 */
model GalleryImageVersionStorageProfile {
  /**
   * The source of the gallery artifact version.
   */
  source?: GalleryArtifactVersionFullSource;

  /**
   * This is the OS disk image.
   */
  osDiskImage?: GalleryOSDiskImage;

  /**
   * A list of data disk images.
   */
  dataDiskImages?: GalleryDataDiskImage[];
}

/**
 * The source of the gallery artifact version.
 */
model GalleryArtifactVersionFullSource extends GalleryArtifactVersionSource {
  /**
   * The resource Id of the source Community Gallery Image.  Only required when using Community Gallery Image as a source.
   */
  communityGalleryImageId?: string;
}

/**
 * The gallery artifact version source.
 */
model GalleryArtifactVersionSource {
  /**
   * The id of the gallery artifact version source. Can specify a disk uri, snapshot uri, user image or storage account resource.
   */
  id?: string;
}

/**
 * This is the OS disk image.
 */
model GalleryOSDiskImage extends GalleryDiskImage {}

/**
 * This is the disk image base class.
 */
model GalleryDiskImage {
  /**
   * This property indicates the size of the VHD to be created.
   */
  @visibility("read")
  sizeInGB?: int32;

  /**
   * The host caching of the disk. Valid values are 'None', 'ReadOnly', and 'ReadWrite'
   */
  hostCaching?: HostCaching;

  /**
   * The source for the disk image.
   */
  source?: GalleryDiskImageSource;
}

/**
 * The source for the disk image.
 */
model GalleryDiskImageSource extends GalleryArtifactVersionSource {
  /**
   * The uri of the gallery artifact version source. Currently used to specify vhd/blob source.
   */
  uri?: string;

  /**
   * The Storage Account Id that contains the vhd blob being used as a source for this artifact version.
   */
  storageAccountId?: string;
}

/**
 * This is the data disk image.
 */
model GalleryDataDiskImage extends GalleryDiskImage {
  /**
   * This property specifies the logical unit number of the data disk. This value is used to identify data disks within the Virtual Machine and therefore must be unique for each data disk attached to the Virtual Machine.
   */
  lun: int32;
}

/**
 * This is the safety profile of the Gallery Image Version.
 */
model GalleryImageVersionSafetyProfile
  extends GalleryArtifactSafetyProfileBase {
  /**
   * Indicates whether this image has been reported as violating Microsoft's policies.
   */
  @visibility("read")
  reportedForPolicyViolation?: boolean;

  /**
   * A list of Policy Violations that have been reported for this Gallery Image Version.
   */
  @visibility("read")
  policyViolations?: PolicyViolation[];
}

/**
 * A policy violation reported against a gallery artifact.
 */
model PolicyViolation {
  /**
   * Describes the nature of the policy violation.
   */
  category?: PolicyViolationCategory;

  /**
   * Describes specific details about why this policy violation was reported.
   */
  details?: string;
}

/**
 * This is the safety profile of the Gallery Artifact Version.
 */
model GalleryArtifactSafetyProfileBase {
  /**
   * Indicates whether or not removing this Gallery Image Version from replicated regions is allowed.
   */
  allowDeletionOfReplicatedLocations?: boolean;
}

/**
 * This is the replication status of the gallery image version.
 */
model ReplicationStatus {
  /**
   * This is the aggregated replication status based on all the regional replication status flags.
   */
  @visibility("read")
  aggregatedState?: AggregatedReplicationState;

  /**
   * This is a summary of replication status for each region.
   */
  @visibility("read")
  summary?: RegionalReplicationStatus[];
}

/**
 * This is the regional replication status.
 */
model RegionalReplicationStatus {
  /**
   * The region to which the gallery image version is being replicated to.
   */
  @visibility("read")
  region?: string;

  /**
   * This is the regional replication state.
   */
  @visibility("read")
  state?: ReplicationState;

  /**
   * The details of the replication status.
   */
  @visibility("read")
  details?: string;

  /**
   * It indicates progress of the replication job.
   */
  @visibility("read")
  progress?: int32;
}

/**
 * Specifies information about the gallery image version that you want to update.
 */
model GalleryImageVersionUpdate extends UpdateResourceDefinition {
  /**
   * Describes the properties of a gallery image version.
   */
  properties?: GalleryImageVersionProperties;
}

/**
 * Describes the properties of a gallery Application Definition.
 */
model GalleryApplicationProperties {
  /**
   * The description of this gallery Application Definition resource. This property is updatable.
   */
  description?: string;

  /**
   * The Eula agreement for the gallery Application Definition.
   */
  eula?: string;

  /**
   * The privacy statement uri.
   */
  privacyStatementUri?: string;

  /**
   * The release note uri.
   */
  releaseNoteUri?: string;

  /**
   * The end of life date of the gallery Application Definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * This property allows you to specify the supported type of the OS that application is built for. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**
   */
  supportedOSType: OperatingSystemTypes;

  /**
   * A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.
   */
  customActions?: GalleryApplicationCustomAction[];
}

/**
 * A custom action that can be performed with a Gallery Application Version.
 */
model GalleryApplicationCustomAction {
  /**
   * The name of the custom action.  Must be unique within the Gallery Application Version.
   */
  name: string;

  /**
   * The script to run when executing this custom action.
   */
  script: string;

  /**
   * Description to help the users understand what this custom action does.
   */
  description?: string;

  /**
   * The parameters that this custom action uses
   */
  parameters?: GalleryApplicationCustomActionParameter[];
}

/**
 * The definition of a parameter that can be passed to a custom action of a Gallery Application Version.
 */
model GalleryApplicationCustomActionParameter {
  /**
   * The name of the custom action.  Must be unique within the Gallery Application Version.
   */
  name: string;

  /**
   * Indicates whether this parameter must be passed when running the custom action.
   */
  required?: boolean;

  /**
   * Specifies the type of the custom action parameter. Possible values are: String, ConfigurationDataBlob or LogOutputBlob
   */
  type?: GalleryApplicationCustomActionParameterType;

  /**
   * The default value of the parameter.  Only applies to string types
   */
  defaultValue?: string;

  /**
   * A description to help users understand what this parameter means
   */
  description?: string;
}

/**
 * Specifies information about the gallery Application Definition that you want to update.
 */
model GalleryApplicationUpdate extends UpdateResourceDefinition {
  /**
   * Describes the properties of a gallery Application Definition.
   */
  properties?: GalleryApplicationProperties;
}

/**
 * Describes the properties of a gallery image version.
 */
model GalleryApplicationVersionProperties {
  /**
   * The publishing profile of a gallery image version.
   */
  publishingProfile: GalleryApplicationVersionPublishingProfile;

  /**
   * The safety profile of the Gallery Application Version.
   */
  safetyProfile?: GalleryApplicationVersionSafetyProfile;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: GalleryProvisioningState;

  /**
   * This is the replication status of the gallery image version.
   */
  @visibility("read")
  replicationStatus?: ReplicationStatus;
}

/**
 * The publishing profile of a gallery image version.
 */
model GalleryApplicationVersionPublishingProfile
  extends GalleryArtifactPublishingProfileBase {
  /**
   * The source image from which the Image Version is going to be created.
   */
  source: UserArtifactSource;

  manageActions?: UserArtifactManage;

  /**
   * Additional settings for the VM app that contains the target package and config file name when it is deployed to target VM or VM scale set.
   */
  settings?: UserArtifactSettings;

  /**
   * Optional. Additional settings to pass to the vm-application-manager extension. For advanced use only.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  advancedSettings?: Record<string>;

  /**
   * Optional. Whether or not this application reports health.
   */
  enableHealthCheck?: boolean;

  /**
   * A list of custom actions that can be performed with this Gallery Application Version.
   */
  customActions?: GalleryApplicationCustomAction[];
}

/**
 * The source image from which the Image Version is going to be created.
 */
model UserArtifactSource {
  /**
   * Required. The mediaLink of the artifact, must be a readable storage page blob.
   */
  mediaLink: string;

  /**
   * Optional. The defaultConfigurationLink of the artifact, must be a readable storage page blob.
   */
  defaultConfigurationLink?: string;
}

model UserArtifactManage {
  /**
   * Required. The path and arguments to install the gallery application. This is limited to 4096 characters.
   */
  install: string;

  /**
   * Required. The path and arguments to remove the gallery application. This is limited to 4096 characters.
   */
  remove: string;

  /**
   * Optional. The path and arguments to update the gallery application. If not present, then update operation will invoke remove command on the previous version and install command on the current version of the gallery application. This is limited to 4096 characters.
   */
  update?: string;
}

/**
 * Additional settings for the VM app that contains the target package and config file name when it is deployed to target VM or VM scale set.
 */
model UserArtifactSettings {
  /**
   * Optional. The name to assign the downloaded package file on the VM. This is limited to 4096 characters. If not specified, the package file will be named the same as the Gallery Application name.
   */
  packageFileName?: string;

  /**
   * Optional. The name to assign the downloaded config file on the VM. This is limited to 4096 characters. If not specified, the config file will be named the Gallery Application name appended with "_config".
   */
  configFileName?: string;
}

/**
 * The safety profile of the Gallery Application Version.
 */
model GalleryApplicationVersionSafetyProfile
  extends GalleryArtifactSafetyProfileBase {}

/**
 * Specifies information about the gallery Application Version that you want to update.
 */
model GalleryApplicationVersionUpdate extends UpdateResourceDefinition {
  /**
   * Describes the properties of a gallery image version.
   */
  properties?: GalleryApplicationVersionProperties;
}

/**
 * Specifies information about the gallery sharing profile update.
 */
model SharingUpdate {
  /**
   * This property allows you to specify the operation type of gallery sharing update. <br><br> Possible values are: <br><br> **Add** <br><br> **Remove** <br><br> **Reset**
   */
  operationType: SharingUpdateOperationTypes;

  /**
   * A list of sharing profile groups.
   */
  groups?: SharingProfileGroup[];
}

/**
 * Base information about the shared gallery resource in pir.
 */
model PirSharedGalleryResource extends PirResource {
  /**
   * The identifier information of shared gallery.
   */
  identifier?: SharedGalleryIdentifier;
}

/**
 * The identifier information of shared gallery.
 */
model SharedGalleryIdentifier {
  /**
   * The unique id of this shared gallery.
   */
  uniqueId?: string;
}

/**
 * The Resource model definition.
 */
model PirResource {
  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource location
   */
  @visibility("read")
  location?: string;
}

/**
 * Describes the properties of a gallery image definition.
 */
model SharedGalleryImageProperties {
  /**
   * This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**
   */
  osType: OperatingSystemTypes;

  /**
   * This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'.
   */
  osState: OperatingSystemStateTypes;

  /**
   * The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * This is the gallery image definition identifier.
   */
  identifier: GalleryImageIdentifier;

  /**
   * The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.
   */
  recommended?: RecommendedMachineConfiguration;

  /**
   * Describes the disallowed disk types.
   */
  disallowed?: Disallowed;

  /**
   * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
   */
  hyperVGeneration?: HyperVGeneration;

  /**
   * A list of gallery image features.
   */
  features?: GalleryImageFeature[];

  /**
   * Describes the gallery image definition purchase plan. This is used by marketplace images.
   */
  purchasePlan?: ImagePurchasePlan;

  /**
   * The architecture of the image. Applicable to OS disks only.
   */
  architecture?: Architecture;

  /**
   * Privacy statement uri for the current community gallery image.
   */
  privacyStatementUri?: string;

  /**
   * End-user license agreement for the current community gallery image.
   */
  eula?: string;
}

/**
 * Describes the properties of a gallery image version.
 */
model SharedGalleryImageVersionProperties {
  /**
   * The published date of the gallery image version Definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  /**
   * The end of life date of the gallery image version Definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * If set to true, Virtual Machines deployed from the latest version of the Image Definition won't use this Image Version.
   */
  excludeFromLatest?: boolean;

  /**
   * Describes the storage profile of the image version.
   */
  storageProfile?: SharedGalleryImageVersionStorageProfile;
}

/**
 * This is the storage profile of a Gallery Image Version.
 */
model SharedGalleryImageVersionStorageProfile {
  /**
   * This is the OS disk image.
   */
  osDiskImage?: SharedGalleryOSDiskImage;

  /**
   * A list of data disk images.
   */
  dataDiskImages?: SharedGalleryDataDiskImage[];
}

/**
 * This is the OS disk image.
 */
model SharedGalleryOSDiskImage extends SharedGalleryDiskImage {}

/**
 * This is the disk image base class.
 */
model SharedGalleryDiskImage {
  /**
   * This property indicates the size of the VHD to be created.
   */
  @visibility("read")
  diskSizeGB?: int32;

  /**
   * The host caching of the disk. Valid values are 'None', 'ReadOnly', and 'ReadWrite'
   */
  hostCaching?: SharedGalleryHostCaching;
}

/**
 * This is the data disk image.
 */
model SharedGalleryDataDiskImage extends SharedGalleryDiskImage {
  /**
   * This property specifies the logical unit number of the data disk. This value is used to identify data disks within the Virtual Machine and therefore must be unique for each data disk attached to the Virtual Machine.
   */
  lun: int32;
}

/**
 * Base information about the community gallery resource in pir.
 */
model PirCommunityGalleryResource {
  /**
   * Resource name
   */
  @visibility("read")
  name?: string;

  /**
   * Resource location
   */
  @visibility("read")
  location?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * The identifier information of community gallery.
   */
  identifier?: CommunityGalleryIdentifier;
}

/**
 * The identifier information of community gallery.
 */
model CommunityGalleryIdentifier {
  /**
   * The unique id of this community gallery.
   */
  uniqueId?: string;
}

/**
 * Describes the properties of a gallery image definition.
 */
model CommunityGalleryImageProperties {
  /**
   * This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**
   */
  osType: OperatingSystemTypes;

  /**
   * This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'.
   */
  osState: OperatingSystemStateTypes;

  /**
   * The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * This is the community gallery image definition identifier.
   */
  identifier: CommunityGalleryImageIdentifier;

  /**
   * The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.
   */
  recommended?: RecommendedMachineConfiguration;

  /**
   * Describes the disallowed disk types.
   */
  disallowed?: Disallowed;

  /**
   * The hypervisor generation of the Virtual Machine. Applicable to OS disks only.
   */
  hyperVGeneration?: HyperVGeneration;

  /**
   * A list of gallery image features.
   */
  features?: GalleryImageFeature[];

  /**
   * Describes the gallery image definition purchase plan. This is used by marketplace images.
   */
  purchasePlan?: ImagePurchasePlan;

  /**
   * The architecture of the image. Applicable to OS disks only.
   */
  architecture?: Architecture;

  /**
   * Privacy statement uri for the current community gallery image.
   */
  privacyStatementUri?: string;

  /**
   * End-user license agreement for the current community gallery image.
   */
  eula?: string;
}

/**
 * This is the community gallery image definition identifier.
 */
model CommunityGalleryImageIdentifier {
  /**
   * The name of the gallery image definition publisher.
   */
  publisher?: string;

  /**
   * The name of the gallery image definition offer.
   */
  offer?: string;

  /**
   * The name of the gallery image definition SKU.
   */
  sku?: string;
}

/**
 * Describes the properties of a gallery image version.
 */
model CommunityGalleryImageVersionProperties {
  /**
   * The published date of the gallery image version Definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  publishedDate?: utcDateTime;

  /**
   * The end of life date of the gallery image version Definition. This property can be used for decommissioning purposes. This property is updatable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endOfLifeDate?: utcDateTime;

  /**
   * If set to true, Virtual Machines deployed from the latest version of the Image Definition won't use this Image Version.
   */
  excludeFromLatest?: boolean;

  /**
   * Describes the storage profile of the image version.
   */
  storageProfile?: SharedGalleryImageVersionStorageProfile;
}

/**
 * The role instance SKU.
 */
model InstanceSku {
  /**
   * The sku name.
   */
  @visibility("read")
  name?: string;

  /**
   * The tier of the cloud service role instance.
   */
  @visibility("read")
  tier?: string;
}

/**
 * Role instance properties.
 */
model RoleInstanceProperties {
  /**
   * Describes the network profile for the role instance.
   */
  networkProfile?: RoleInstanceNetworkProfile;

  /**
   * The instance view of the role instance.
   */
  instanceView?: RoleInstanceInstanceView;
}

/**
 * Describes the network profile for the role instance.
 */
model RoleInstanceNetworkProfile {
  /**
   * Specifies the list of resource Ids for the network interfaces associated with the role instance.
   */
  @visibility("read")
  networkInterfaces?: SubResource[];
}

/**
 * The instance view of the role instance.
 */
model RoleInstanceInstanceView {
  /**
   * The Update Domain.
   */
  @visibility("read")
  platformUpdateDomain?: int32;

  /**
   * The Fault Domain.
   */
  @visibility("read")
  platformFaultDomain?: int32;

  /**
   * Specifies a unique identifier generated internally for the cloud service associated with this role instance. <br /><br /> NOTE: If you are using Azure Diagnostics extension, this property can be used as 'DeploymentId' for querying details.
   */
  @visibility("read")
  privateId?: string;

  @visibility("read")
  statuses?: ResourceInstanceViewStatus[];
}

/**
 * Instance view status.
 */
model ResourceInstanceViewStatus {
  /**
   * The status code.
   */
  @visibility("read")
  code?: string;

  /**
   * The short localizable label for the status.
   */
  @visibility("read")
  displayStatus?: string;

  /**
   * The detailed status message, including for alerts and error messages.
   */
  @visibility("read")
  message?: string;

  /**
   * The time of the status.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  time?: utcDateTime;

  /**
   * The level code.
   */
  level?: StatusLevelTypes;
}

/**
 * Describes the cloud service role sku.
 */
model CloudServiceRoleSku {
  /**
   * The sku name. NOTE: If the new SKU is not supported on the hardware the cloud service is currently on, you need to delete and recreate the cloud service or move back to the old sku.
   */
  name?: string;

  /**
   * Specifies the tier of the cloud service. Possible Values are <br /><br /> **Standard** <br /><br /> **Basic**
   */
  tier?: string;

  /**
   * Specifies the number of role instances in the cloud service.
   */
  capacity?: int64;
}

/**
 * The cloud service role properties.
 */
model CloudServiceRoleProperties {
  /**
   * Specifies the ID which uniquely identifies a cloud service role.
   */
  @visibility("read")
  uniqueId?: string;
}

/**
 * Cloud service properties
 */
model CloudServiceProperties {
  /**
   * Specifies a URL that refers to the location of the service package in the Blob service. The service package URL can be Shared Access Signature (SAS) URI from any storage account.
   * This is a write-only property and is not returned in GET calls.
   */
  packageUrl?: string;

  /**
   * Specifies the XML service configuration (.cscfg) for the cloud service.
   */
  configuration?: string;

  /**
   * Specifies a URL that refers to the location of the service configuration in the Blob service. The service package URL  can be Shared Access Signature (SAS) URI from any storage account.
   * This is a write-only property and is not returned in GET calls.
   */
  configurationUrl?: string;

  /**
   * (Optional) Indicates whether to start the cloud service immediately after it is created. The default value is `true`.
   * If false, the service model is still deployed, but the code is not run immediately. Instead, the service is PoweredOff until you call Start, at which time the service will be started. A deployed service still incurs charges, even if it is poweredoff.
   */
  startCloudService?: boolean;

  /**
   * (Optional) Indicates whether the role sku properties (roleProfile.roles.sku) specified in the model/template should override the role instance count and vm size specified in the .cscfg and .csdef respectively.
   * The default value is `false`.
   */
  allowModelOverride?: boolean;

  /**
   * Update mode for the cloud service. Role instances are allocated to update domains when the service is deployed. Updates can be initiated manually in each update domain or initiated automatically in all update domains.
   * Possible Values are <br /><br />**Auto**<br /><br />**Manual** <br /><br />**Simultaneous**<br /><br />
   * If not specified, the default value is Auto. If set to Manual, PUT UpdateDomain must be called to apply the update. If set to Auto, the update is automatically applied to each update domain in sequence.
   */
  upgradeMode?: CloudServiceUpgradeMode;

  /**
   * Describes the role profile for the cloud service.
   */
  roleProfile?: CloudServiceRoleProfile;

  /**
   * Describes the OS profile for the cloud service.
   */
  osProfile?: CloudServiceOsProfile;

  /**
   * Network Profile for the cloud service.
   */
  networkProfile?: CloudServiceNetworkProfile;

  /**
   * Describes a cloud service extension profile.
   */
  extensionProfile?: CloudServiceExtensionProfile;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * The unique identifier for the cloud service.
   */
  @visibility("read")
  uniqueId?: string;
}

/**
 * Describes the role profile for the cloud service.
 */
model CloudServiceRoleProfile {
  /**
   * List of roles for the cloud service.
   */
  roles?: CloudServiceRoleProfileProperties[];
}

/**
 * Describes the role properties.
 */
model CloudServiceRoleProfileProperties {
  /**
   * Resource name.
   */
  name?: string;

  /**
   * Describes the cloud service role sku.
   */
  sku?: CloudServiceRoleSku;
}

/**
 * Describes the OS profile for the cloud service.
 */
model CloudServiceOsProfile {
  /**
   * Specifies set of certificates that should be installed onto the role instances.
   */
  secrets?: CloudServiceVaultSecretGroup[];
}

/**
 * Describes a set of certificates which are all in the same Key Vault.
 */
model CloudServiceVaultSecretGroup {
  /**
   * The relative URL of the Key Vault containing all of the certificates in VaultCertificates.
   */
  sourceVault?: SubResource;

  /**
   * The list of key vault references in SourceVault which contain certificates.
   */
  vaultCertificates?: CloudServiceVaultCertificate[];
}

/**
 * Describes a single certificate reference in a Key Vault, and where the certificate should reside on the role instance.
 */
model CloudServiceVaultCertificate {
  /**
   * This is the URL of a certificate that has been uploaded to Key Vault as a secret.
   */
  certificateUrl?: string;
}

/**
 * Network Profile for the cloud service.
 */
model CloudServiceNetworkProfile {
  /**
   * List of Load balancer configurations. Cloud service can have up to two load balancer configurations, corresponding to a Public Load Balancer and an Internal Load Balancer.
   */
  loadBalancerConfigurations?: LoadBalancerConfiguration[];

  /**
   * Slot type for the cloud service.
   * Possible values are <br /><br />**Production**<br /><br />**Staging**<br /><br />
   * If not specified, the default value is Production.
   */
  slotType?: CloudServiceSlotType;

  /**
   * The id reference of the cloud service containing the target IP with which the subject cloud service can perform a swap. This property cannot be updated once it is set. The swappable cloud service referred by this id must be present otherwise an error will be thrown.
   */
  swappableCloudService?: SubResource;
}

/**
 * Describes the load balancer configuration.
 */
model LoadBalancerConfiguration {
  /**
   * Resource Id
   */
  id?: string;

  /**
   * The name of the Load balancer
   */
  name: string;

  /**
   * Properties of the load balancer configuration.
   */
  properties: LoadBalancerConfigurationProperties;
}

/**
 * Describes the properties of the load balancer configuration.
 */
model LoadBalancerConfigurationProperties {
  /**
   * Specifies the frontend IP to be used for the load balancer. Only IPv4 frontend IP address is supported. Each load balancer configuration must have exactly one frontend IP configuration.
   */
  frontendIpConfigurations: LoadBalancerFrontendIpConfiguration[];
}

/**
 * Specifies the frontend IP to be used for the load balancer. Only IPv4 frontend IP address is supported. Each load balancer configuration must have exactly one frontend IP configuration.
 */
model LoadBalancerFrontendIpConfiguration {
  /**
   * The name of the resource that is unique within the set of frontend IP configurations used by the load balancer. This name can be used to access the resource.
   */
  name: string;

  /**
   * Properties of load balancer frontend ip configuration.
   */
  properties: LoadBalancerFrontendIpConfigurationProperties;
}

/**
 * Describes a cloud service IP Configuration
 */
model LoadBalancerFrontendIpConfigurationProperties {
  /**
   * The reference to the public ip address resource.
   */
  publicIPAddress?: SubResource;

  /**
   * The reference to the virtual network subnet resource.
   */
  subnet?: SubResource;

  /**
   * The virtual network private IP address of the IP configuration.
   */
  privateIPAddress?: string;
}

/**
 * Describes a cloud service extension profile.
 */
model CloudServiceExtensionProfile {
  /**
   * List of extensions for the cloud service.
   */
  extensions?: Extension[];
}

/**
 * Describes a cloud service Extension.
 */
model Extension {
  /**
   * The name of the extension.
   */
  name?: string;

  /**
   * Extension Properties.
   */
  properties?: CloudServiceExtensionProperties;
}

/**
 * Extension Properties.
 */
model CloudServiceExtensionProperties {
  /**
   * The name of the extension handler publisher.
   */
  publisher?: string;

  /**
   * Specifies the type of the extension.
   */
  type?: string;

  /**
   * Specifies the version of the extension. Specifies the version of the extension. If this element is not specified or an asterisk (*) is used as the value, the latest version of the extension is used. If the value is specified with a major version number and an asterisk as the minor version number (X.), the latest minor version of the specified major version is selected. If a major version number and a minor version number are specified (X.Y), the specific extension version is selected. If a version is specified, an auto-upgrade is performed on the role instance.
   */
  typeHandlerVersion?: string;

  /**
   * Explicitly specify whether platform can automatically upgrade typeHandlerVersion to higher minor versions when they become available.
   */
  autoUpgradeMinorVersion?: boolean;

  /**
   * Public settings for the extension. For JSON extensions, this is the JSON settings for the extension. For XML Extension (like RDP), this is the XML setting for the extension.
   */
  settings?: Record<unknown>;

  /**
   * Protected settings for the extension which are encrypted before sent to the role instance.
   */
  protectedSettings?: Record<unknown>;

  /**
   * Protected settings for the extension, referenced using KeyVault which are encrypted before sent to the role instance.
   */
  protectedSettingsFromKeyVault?: CloudServiceVaultAndSecretReference;

  /**
   * Tag to force apply the provided public and protected settings.
   * Changing the tag value allows for re-running the extension without changing any of the public or protected settings.
   * If forceUpdateTag is not changed, updates to public or protected settings would still be applied by the handler.
   * If neither forceUpdateTag nor any of public or protected settings change, extension would flow to the role instance with the same sequence-number, and
   * it is up to handler implementation whether to re-run it or not
   */
  forceUpdateTag?: string;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * Optional list of roles to apply this extension. If property is not specified or '*' is specified, extension is applied to all roles in the cloud service.
   */
  rolesAppliedTo?: string[];
}

/**
 * Protected settings for the extension, referenced using KeyVault which are encrypted before sent to the role instance.
 */
model CloudServiceVaultAndSecretReference {
  /**
   * The ARM Resource ID of the Key Vault
   */
  sourceVault?: SubResource;

  /**
   * Secret URL which contains the protected settings of the extension
   */
  secretUrl?: string;
}

model CloudServiceUpdate {
  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * InstanceView of CloudService as a whole
 */
model CloudServiceInstanceView {
  /**
   * Instance view statuses.
   */
  roleInstance?: InstanceViewStatusesSummary;

  /**
   * The version of the SDK that was used to generate the package for the cloud service.
   */
  @visibility("read")
  sdkVersion?: string;

  /**
   * Specifies a list of unique identifiers generated internally for the cloud service. <br /><br /> NOTE: If you are using Azure Diagnostics extension, this property can be used as 'DeploymentId' for querying details.
   */
  @visibility("read")
  privateIds?: string[];

  @visibility("read")
  statuses?: ResourceInstanceViewStatus[];
}

/**
 * Instance view statuses.
 */
model InstanceViewStatusesSummary {
  /**
   * The summary.
   */
  @visibility("read")
  statusesSummary?: StatusCodeCount[];
}

/**
 * The status code and count of the cloud service instance view statuses
 */
model StatusCodeCount {
  /**
   * The instance view status code
   */
  @visibility("read")
  code?: string;

  /**
   * Number of instances having this status code
   */
  @visibility("read")
  count?: int32;
}

/**
 * Specifies a list of role instances from the cloud service.
 */
model RoleInstances {
  /**
   * List of cloud service role instance names. Value of '*' will signify all role instances of the cloud service.
   */
  roleInstances: string[];
}

/**
 * Defines an update domain for the cloud service.
 */
model UpdateDomain {
  /**
   * Resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource Name
   */
  @visibility("read")
  name?: string;
}

/**
 * The list operation result.
 */
model UpdateDomainListResult is Azure.Core.Page<UpdateDomain>;

/**
 * OS version properties.
 */
model OSVersionProperties {
  /**
   * The family of this OS version.
   */
  @visibility("read")
  family?: string;

  /**
   * The family label of this OS version.
   */
  @visibility("read")
  familyLabel?: string;

  /**
   * The OS version.
   */
  @visibility("read")
  version?: string;

  /**
   * The OS version label.
   */
  @visibility("read")
  label?: string;

  /**
   * Specifies whether this is the default OS version for its family.
   */
  @visibility("read")
  isDefault?: boolean;

  /**
   * Specifies whether this OS version is active.
   */
  @visibility("read")
  isActive?: boolean;
}

/**
 * OS family properties.
 */
model OSFamilyProperties {
  /**
   * The OS family name.
   */
  @visibility("read")
  name?: string;

  /**
   * The OS family label.
   */
  @visibility("read")
  label?: string;

  /**
   * List of OS versions belonging to this family.
   */
  @visibility("read")
  versions?: OSVersionPropertiesBase[];
}

/**
 * Configuration view of an OS version.
 */
model OSVersionPropertiesBase {
  /**
   * The OS version.
   */
  @visibility("read")
  version?: string;

  /**
   * The OS version label.
   */
  @visibility("read")
  label?: string;

  /**
   * Specifies whether this is the default OS version for its family.
   */
  @visibility("read")
  isDefault?: boolean;

  /**
   * Specifies whether this OS version is active.
   */
  @visibility("read")
  isActive?: boolean;
}

/**
 * The source image from which the Image Version is going to be created.
 */
model GalleryArtifactSource {
  /**
   * The managed artifact.
   */
  managedImage: ManagedArtifact;
}

/**
 * The managed artifact.
 */
model ManagedArtifact {
  /**
   * The managed artifact id.
   */
  id: string;
}

/**
 * The gallery image version with latest version in a particular region.
 */
model LatestGalleryImageVersion {
  /**
   * The name of the latest version in the region.
   */
  latestVersionName?: string;

  /**
   * region of the Gallery Image Version.
   */
  location?: string;
}
