import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace Compute;

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

enum ProximityPlacementGroupType {
  Standard,
  Ultra,
}

enum OperatingSystemType {
  Windows,
  Linux,
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
enum ResourceIdentityType {
  SystemAssigned,
  UserAssigned,
  `SystemAssigned, UserAssigned`,
  None,
}
@Azure.Core.fixed
enum StatusLevelTypes {
  Info,
  Warning,
  Error,
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
  @doc("Generalized image. Needs to be provisioned during deployment time.")
  Generalized,
  @doc("Specialized image. Contains already provisioned OS Disk.") Specialized,
}
@Azure.Core.fixed
enum IntervalInMins {
  ThreeMins,
  FiveMins,
  ThirtyMins,
  SixtyMins,
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

@doc("The List Virtual Machine operation response.")
model VirtualMachineScaleSetListResult
  is Azure.Core.Page<VirtualMachineScaleSet>;

@doc("Describes a Virtual Machine Scale Set.")
model VirtualMachineScaleSet {
  ...Resource;

  @doc("The virtual machine scale set sku.")
  sku?: Sku;

  @doc("""
Specifies information about the marketplace image used to create the virtual
machine. This element is only used for marketplace images. Before you can use a
marketplace image from an API, you must enable the image for programmatic use. 
In the Azure portal, find the marketplace image that you want to use and then
click **Want to deploy programmatically, Get Started ->**. Enter any required
information and then click **Save**.
""")
  plan?: Plan;

  @doc("Describes the properties of a Virtual Machine Scale Set.")
  properties?: VirtualMachineScaleSetProperties;

  @doc("The identity of the virtual machine scale set, if configured.")
  identity?: VirtualMachineScaleSetIdentity;

  @doc("""
The virtual machine scale set zones. NOTE: Availability zones can only be set
when you create the scale set
""")
  zones?: string[];

  @doc("The extended location of the Virtual Machine Scale Set.")
  extendedLocation?: ExtendedLocation;
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
machine scale set should be assigned to. <br><br>Minimum api-version:
2018-04-01.
""")
  proximityPlacementGroup?: SubResource;

  @doc("""
Specifies information about the dedicated host group that the virtual machine
scale set resides in. <br><br>Minimum api-version: 2020-06-01.
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
Specifies the time at which the Virtual Machine Scale Set resource was
created.<br><br>Minimum api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
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
}

@doc("The configuration parameters used for performing automatic OS upgrade.")
model AutomaticOSUpgradePolicy {
  @doc("""
Indicates whether OS upgrades should automatically be applied to scale set
instances in a rolling fashion when a newer version of the OS image becomes
available. Default value is false. <br><br> If this is set to true for Windows
based scale sets,
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

  @doc("""
Specifies the boot diagnostic settings state. <br><br>Minimum api-version:
2015-06-15.
""")
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
Specifies the priority for the virtual machines in the scale set.
<br><br>Minimum api-version: 2017-10-30-preview
""")
  priority?: VirtualMachinePriorityTypes;

  @doc("""
Specifies the eviction policy for the Azure Spot virtual machine and Azure Spot
scale set. <br><br>For Azure Spot virtual machines, both 'Deallocate' and
'Delete' are supported and the minimum api-version is 2019-03-01. <br><br>For
Azure Spot scale sets, both 'Deallocate' and 'Delete' are supported and the
minimum api-version is 2017-10-30-preview.
""")
  evictionPolicy?: VirtualMachineEvictionPolicyTypes;

  @doc("""
Specifies the billing related details of a Azure Spot VMSS. <br><br>Minimum
api-version: 2019-03-01.
""")
  billingProfile?: BillingProfile;

  @doc("Specifies Scheduled Event related configurations.")
  scheduledEventsProfile?: ScheduledEventsProfile;

  @doc("""
UserData for the virtual machines in the scale set, which must be base-64
encoded. Customer should not pass any secrets in here. <br><br>Minimum
api-version: 2021-03-01
""")
  userData?: string;

  @doc("""
Specifies the capacity reservation related details of a scale set.
<br><br>Minimum api-version: 2021-04-01.
""")
  capacityReservation?: CapacityReservationProfile;

  @doc("Specifies the gallery applications that should be made available to the VM/VMSS")
  applicationProfile?: ApplicationProfile;

  @doc("""
Specifies the hardware profile related details of a scale set. <br><br>Minimum
api-version: 2021-11-01.
""")
  hardwareProfile?: VirtualMachineScaleSetHardwareProfile;
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
The maximum length of the binary array is 65535 bytes. <br><br> For using
cloud-init for your VM, see [Using cloud-init to customize a Linux VM during
creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init)
""")
  customData?: string;

  @doc("Specifies Windows operating system settings on the virtual machine.")
  windowsConfiguration?: WindowsConfiguration;

  @doc("""
Specifies the Linux operating system settings on the virtual machine.
<br><br>For a list of supported Linux distributions, see [Linux on
Azure-Endorsed
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
scale set. <br><br>This may only be set to False when no extensions are present
on the virtual machine scale set.
""")
  allowExtensionOperations?: boolean;
}

@doc("Specifies Windows operating system settings on the virtual machine.")
model WindowsConfiguration {
  @doc("""
Indicates whether virtual machine agent should be provisioned on the virtual
machine. <br><br> When this property is not specified in the request body,
default behavior is to set it to true.  This will ensure that VM Agent is
installed on the VM so that extensions can be added to the VM later.
""")
  provisionVMAgent?: boolean;

  @doc("""
Indicates whether Automatic Updates is enabled for the Windows virtual machine.
Default value is true. <br><br> For virtual machine scale sets, this property
can be updated and updates will take effect on OS reprovisioning.
""")
  enableAutomaticUpdates?: boolean;

  @doc("""
Specifies the time zone of the virtual machine. e.g. \"Pacific Standard Time\".
<br><br> Possible values can be
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
}

@doc("Describes Windows Remote Management configuration of the VM")
model WinRMConfiguration {
  @doc("The list of Windows Remote Management listeners")
  listeners?: WinRMListener[];
}

@doc("Describes Protocol and thumbprint of Windows Remote Management listener")
model WinRMListener {
  @doc("""
Specifies the protocol of WinRM listener. <br><br> Possible values are:
<br>**http** <br><br> **https**
""")
  protocol?: ProtocolTypes;

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
}

@doc("""
Specifies the Linux operating system settings on the virtual machine.
<br><br>For a list of supported Linux distributions, see [Linux on
Azure-Endorsed
Distributions](https://docs.microsoft.com/azure/virtual-machines/linux/endorsed-distros).
""")
model LinuxConfiguration {
  @doc("Specifies whether password authentication should be disabled.")
  disablePasswordAuthentication?: boolean;

  @doc("Specifies the ssh key configuration for a Linux OS.")
  ssh?: SshConfiguration;

  @doc("""
Indicates whether virtual machine agent should be provisioned on the virtual
machine. <br><br> When this property is not specified in the request body,
default behavior is to set it to true.  This will ensure that VM Agent is
installed on the VM so that extensions can be added to the VM later.
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
key needs to be at least 2048-bit and in ssh-rsa format. <br><br> For creating
ssh keys, see [Create SSH keys on Linux and Mac for Linux VMs in
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
implicitly in the LocalMachine account. <br><br>For Linux VMs, the certificate
file is placed under the /var/lib/waagent directory, with the file name
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
machines in the scale set. <br><br> For more information about disks, see
[About disks and VHDs for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  osDisk?: VirtualMachineScaleSetOSDisk;

  @doc("""
Specifies the parameters that are used to add data disks to the virtual
machines in the scale set. <br><br> For more information about disks, see
[About disks and VHDs for Azure virtual
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
Specifies the caching requirements. <br><br> Possible values are: <br><br>
**None** <br><br> **ReadOnly** <br><br> **ReadWrite** <br><br> Default: **None
for Standard storage. ReadOnly for Premium storage**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("""
Specifies how the virtual machines in the scale set should be created.<br><br>
The only allowed value is: **FromImage** \\u2013 This value is used when you
are using an image to create the virtual machine. If you are using a platform
image, you also use the imageReference element described above. If you are
using a marketplace image, you  also use the plan element previously described.
""")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the ephemeral disk Settings for the operating system disk used by the
virtual machine scale set.
""")
  diffDiskSettings?: DiffDiskSettings;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. <br><br>
diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be
larger than 1023
""")
  diskSizeGB?: int32;

  @doc("""
This property allows you to specify the type of the OS that is included in the
disk if creating a VM from user-image or a specialized VHD. <br><br> Possible
values are: <br><br> **Windows** <br><br> **Linux**
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
operating system disk. <br><br> NOTE: The ephemeral disk settings can only be
specified for managed disk.
""")
model DiffDiskSettings {
  @doc("Specifies the ephemeral disk settings for operating system disk.")
  option?: DiffDiskOptions;

  @doc("""
Specifies the ephemeral disk placement for operating system disk.<br><br>
Possible values are: <br><br> **CacheDisk** <br><br> **ResourceDisk** <br><br>
Default: **CacheDisk** if one is configured for the VM size otherwise
**ResourceDisk** is used.<br><br> Refer to VM size documentation for Windows VM
at https://docs.microsoft.com/azure/virtual-machines/windows/sizes and Linux VM
at https://docs.microsoft.com/azure/virtual-machines/linux/sizes to check which
VM sizes exposes a cache disk.
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
that can be specified for disk. <br><br> NOTE: The disk encryption set resource
id can only be specified for managed disk. Please refer
https://aka.ms/mdssewithcmkoverview for more details.
""")
model DiskEncryptionSetParameters {
  ...SubResource;
}

@doc("""
Specifies the security profile settings for the managed disk. <br><br> NOTE: It
can only be set for Confidential VMs
""")
model VMDiskSecurityProfile {
  @doc("""
Specifies the EncryptionType of the managed disk. <br> It is set to
DiskWithVMGuestState for encryption of the managed disk along with VMGuestState
blob, and VMGuestStateOnly for encryption of just the VMGuestState blob.
<br><br> NOTE: It can be set for only Confidential VMs.
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
Specifies the caching requirements. <br><br> Possible values are: <br><br>
**None** <br><br> **ReadOnly** <br><br> **ReadWrite** <br><br> Default: **None
for Standard storage. ReadOnly for Premium storage**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("The create option.")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. <br><br>
diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be
larger than 1023
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
  ...SubResource;

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
}

@doc("Describes a virtual machines scale sets network configuration's DNS settings.")
model VirtualMachineScaleSetNetworkConfigurationDnsSettings {
  @doc("List of DNS servers IP addresses")
  dnsServers?: string[];
}

@doc("Describes a virtual machine scale set network profile's IP configuration.")
model VirtualMachineScaleSetIPConfiguration {
  ...SubResource;

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
the virtual machine. <br><br>Minimum api-version: 2020-12-01
""")
  uefiSettings?: UefiSettings;

  @doc("""
This property can be used by user in the request to enable or disable the Host
Encryption for the virtual machine or virtual machine scale set. This will
enable the encryption for all the disks including Resource/Temp disk at host
itself. <br><br> Default: The Encryption at host will be disabled unless this
property is set to true for the resource.
""")
  encryptionAtHost?: boolean;

  @doc("""
Specifies the SecurityType of the virtual machine. It has to be set to any
specified value to enable UefiSettings. <br><br> Default: UefiSettings will not
be enabled unless this property is set.
""")
  securityType?: SecurityTypes;
}

@doc("""
Specifies the security settings like secure boot and vTPM used while creating
the virtual machine. <br><br>Minimum api-version: 2020-12-01
""")
model UefiSettings {
  @doc("""
Specifies whether secure boot should be enabled on the virtual machine.
<br><br>Minimum api-version: 2020-12-01
""")
  secureBootEnabled?: boolean;

  @doc("""
Specifies whether vTPM should be enabled on the virtual machine.
<br><br>Minimum api-version: 2020-12-01
""")
  vTpmEnabled?: boolean;
}

@doc("""
Specifies the boot diagnostic settings state. <br><br>Minimum api-version:
2015-06-15.
""")
model DiagnosticsProfile {
  @doc("""
Boot Diagnostics is a debugging feature which allows you to view Console Output
and Screenshot to diagnose VM status. <br>**NOTE**: If storageUri is being
specified then ensure that the storage account is in the same region and
subscription as the VM. <br><br> You can easily view the output of your console
log. <br><br> Azure also enables you to see a screenshot of the VM from the
hypervisor.
""")
  bootDiagnostics?: BootDiagnostics;
}

@doc("""
Boot Diagnostics is a debugging feature which allows you to view Console Output
and Screenshot to diagnose VM status. <br><br> You can easily view the output
of your console log. <br><br> Azure also enables you to see a screenshot of the
VM from the hypervisor.
""")
model BootDiagnostics {
  @doc("Whether boot diagnostics should be enabled on the Virtual Machine.")
  enabled?: boolean;

  @doc("""
Uri of the storage account to use for placing the console output and
screenshot. <br><br>If storageUri is not specified while enabling boot
diagnostics, managed storage will be used.
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
<br><br> Minimum api-version: 2020-06-01
""")
  extensionsTimeBudget?: string;
}

@doc("Describes a Virtual Machine Scale Set Extension.")
model VirtualMachineScaleSetExtension {
  ...SubResourceReadOnly;

  @doc("The name of the extension.")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Describes the properties of a Virtual Machine Scale Set Extension.")
  properties?: VirtualMachineScaleSetExtensionProperties;
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
  settings?: unknown;

  @doc("""
The extension can contain either protectedSettings or
protectedSettingsFromKeyVault or no protected settings at all.
""")
  protectedSettings?: unknown;

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
Specifies the billing related details of a Azure Spot VM or VMSS.
<br><br>Minimum api-version: 2019-03-01.
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
Minimum api-version: 2021-11-01. <br><br> Please follow the instructions in [VM
Customization](https://aka.ms/vmcustomization) for more details.
""")
  vmSizeProperties?: VMSizeProperties;
}

@doc("Specifies VM Size Property settings on the virtual machine.")
model VMSizeProperties {
  @doc("""
Specifies the number of vCPUs available for the VM. <br><br> When this property
is not specified in the request body the default behavior is to set it to the
value of vCPUs available for that VM size exposed in api response of [List all
available virtual machine sizes in a
region](https://docs.microsoft.com/en-us/rest/api/compute/resource-skus/list) .
""")
  vCPUsAvailable?: int32;

  @doc("""
Specifies the vCPU to physical core ratio. <br><br> When this property is not
specified in the request body the default behavior is set to the value of
vCPUsPerCore for the VM Size exposed in api response of [List all available
virtual machine sizes in a
region](https://docs.microsoft.com/en-us/rest/api/compute/resource-skus/list)
<br><br> Setting this property to 1 also means that hyper-threading is
disabled.
""")
  vCPUsPerCore?: int32;
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
<br><br> With this property customer can enable or disable automatic restore of
the evicted Spot VMSS VM instances opportunistically based on capacity
availability and pricing constraint.
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
set with flexible orchestration mode. <br><br>With this property the customer
is able to specify the base number of regular priority VMs created as the VMSS
flex instance scales out and the split between Spot and Regular priority VMs
after this base target has been reached.
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

@doc("The Resource model definition.")
model Resource {
  @doc("Resource Id")
  @visibility("read")
  id?: string;

  @doc("Resource name")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Resource location")
  location: string;

  @doc("Resource tags")
  tags?: Record<string>;
}

@doc("Describes a Virtual Machine Scale Set.")
model VirtualMachineScaleSetUpdate {
  ...UpdateResource;

  @doc("The virtual machine scale set sku.")
  sku?: Sku;

  @doc("""
The purchase plan when deploying a virtual machine scale set from VM
Marketplace images.
""")
  plan?: Plan;

  @doc("Describes the properties of a Virtual Machine Scale Set.")
  properties?: VirtualMachineScaleSetUpdateProperties;

  @doc("The identity of the virtual machine scale set, if configured.")
  identity?: VirtualMachineScaleSetIdentity;
}

@doc("Describes the properties of a Virtual Machine Scale Set.")
model VirtualMachineScaleSetUpdateProperties {
  @doc("The upgrade policy.")
  upgradePolicy?: UpgradePolicy;

  @doc("Policy for automatic repairs.")
  automaticRepairsPolicy?: AutomaticRepairsPolicy;

  @doc("The virtual machine profile.")
  virtualMachineProfile?: VirtualMachineScaleSetUpdateVMProfile;

  @doc("Specifies whether the Virtual Machine Scale Set should be overprovisioned.")
  overprovision?: boolean;

  @doc("""
When Overprovision is enabled, extensions are launched only on the requested
number of VMs which are finally kept. This property will hence ensure that the
extensions do not run on the extra overprovisioned VMs.
""")
  doNotRunExtensionsOnOverprovisionedVMs?: boolean;

  @doc("""
When true this limits the scale set to a single placement group, of max size
100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified
to false. However, if singlePlacementGroup is false, it may not be modified to
true.
""")
  singlePlacementGroup?: boolean;

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

  @doc("""
Specifies information about the proximity placement group that the virtual
machine scale set should be assigned to. <br><br>Minimum api-version:
2018-04-01.
""")
  proximityPlacementGroup?: SubResource;
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
Specifies the billing related details of a Azure Spot VMSS. <br><br>Minimum
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
Specifies the hardware profile related details of a scale set. <br><br>Minimum
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
  ...SubResource;

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
}

@doc("""
Describes a virtual machine scale set network profile's IP configuration. NOTE:
The subnet of a scale set may be modified as long as the original subnet and
the new subnet are in the same virtual network
""")
model VirtualMachineScaleSetUpdateIPConfiguration {
  ...SubResource;

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

@doc("Summary for an orchestration service of a virtual machine scale set.")
model OrchestrationServiceSummary {
  @doc("The name of the service.")
  @visibility("read")
  serviceName?: OrchestrationServiceNames;

  @doc("The current state of the service.")
  @visibility("read")
  serviceState?: OrchestrationServiceState;
}

@doc("Describes a Virtual Machine Scale Set Extension.")
model VirtualMachineScaleSetExtensionUpdate {
  ...SubResourceReadOnly;

  @doc("The name of the extension.")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Describes the properties of a Virtual Machine Scale Set Extension.")
  properties?: VirtualMachineScaleSetExtensionProperties;
}

@doc("The List VM scale set extension operation response.")
model VirtualMachineScaleSetExtensionListResult
  is Azure.Core.Page<VirtualMachineScaleSetExtension>;

@doc("The List Virtual Machine operation response.")
model VirtualMachineScaleSetListWithLinkResult
  is Azure.Core.Page<VirtualMachineScaleSet>;

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
}

@doc("The status of the latest virtual machine scale set rolling upgrade.")
model RollingUpgradeStatusInfo {
  ...Resource;

  @doc("The status of the latest virtual machine scale set rolling upgrade.")
  properties?: RollingUpgradeStatusInfoProperties;
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

@doc("Describes a VMSS VM Extension.")
model VirtualMachineScaleSetVMExtension {
  ...SubResourceReadOnly;

  @doc("The name of the extension.")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Describes the properties of a Virtual Machine Extension.")
  properties?: VirtualMachineExtensionProperties;
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
  settings?: unknown;

  @doc("""
The extension can contain either protectedSettings or
protectedSettingsFromKeyVault or no protected settings at all.
""")
  protectedSettings?: unknown;

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

@doc("Describes a VMSS VM Extension.")
model VirtualMachineScaleSetVMExtensionUpdate {
  ...SubResourceReadOnly;

  @doc("The name of the extension.")
  @visibility("read")
  name?: string;

  @doc("Resource type")
  @visibility("read")
  type?: string;

  @doc("Describes the properties of a Virtual Machine Extension.")
  properties?: VirtualMachineExtensionUpdateProperties;
}

@doc("Describes the properties of a Virtual Machine Extension.")
model VirtualMachineExtensionUpdateProperties {
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
  settings?: unknown;

  @doc("""
The extension can contain either protectedSettings or
protectedSettingsFromKeyVault or no protected settings at all.
""")
  protectedSettings?: unknown;

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

@doc("The List VMSS VM Extension operation response")
model VirtualMachineScaleSetVMExtensionsListResult {
  @doc("The list of VMSS VM extensions")
  value?: VirtualMachineScaleSetVMExtension[];
}

@doc("Describes a virtual machine scale set virtual machine.")
model VirtualMachineScaleSetVM {
  ...Resource;

  @doc("The virtual machine instance ID.")
  @visibility("read")
  instanceId?: string;

  @doc("The virtual machine SKU.")
  @visibility("read")
  sku?: Sku;

  @doc("Describes the properties of a virtual machine scale set virtual machine.")
  properties?: VirtualMachineScaleSetVMProperties;

  @doc("""
Specifies information about the marketplace image used to create the virtual
machine. This element is only used for marketplace images. Before you can use a
marketplace image from an API, you must enable the image for programmatic use. 
In the Azure portal, find the marketplace image that you want to use and then
click **Want to deploy programmatically, Get Started ->**. Enter any required
information and then click **Save**.
""")
  plan?: Plan;

  @doc("The virtual machine child extension resources.")
  @visibility("read")
  resources?: VirtualMachineExtension[];

  @doc("The virtual machine zones.")
  @visibility("read")
  zones?: string[];

  @doc("The identity of the virtual machine, if configured.")
  identity?: VirtualMachineIdentity;
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

  @doc("""
Specifies the boot diagnostic settings state. <br><br>Minimum api-version:
2015-06-15.
""")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Virtual machines specified in the same availability set
are allocated to different nodes to maximize availability. For more information
about availability sets, see [Availability sets
overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview).
<br><br> For more information on Azure planned maintenance, see [Maintenance
and updates for Virtual Machines in
Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates)
<br><br> Currently, a VM can only be added to availability set at creation
time. An existing VM cannot be added to an availability set.
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
and Screenshot to diagnose VM status. <br><br> You can easily view the output
of your console log. <br><br> Azure also enables you to see a screenshot of the
VM from the hypervisor.
""")
  bootDiagnostics?: BootDiagnosticsInstanceView;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];

  @doc("""
Resource id of the dedicated host, on which the virtual machine is allocated
through automatic placement, when the virtual machine is associated with a
dedicated host group that has automatic placement enabled. <br><br>Minimum
api-version: 2020-06-01.
""")
  @visibility("read")
  assignedHost?: string;

  @doc("""
The placement group in which the VM is running. If the VM is deallocated it
will not have a placementGroupId.
""")
  placementGroupId?: string;
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
The console screenshot blob URI. <br><br>NOTE: This will **not** be set if boot
diagnostics is currently enabled with managed storage.
""")
  @visibility("read")
  consoleScreenshotBlobUri?: string;

  @doc("""
The serial console log blob Uri. <br><br>NOTE: This will **not** be set if boot
diagnostics is currently enabled with managed storage.
""")
  @visibility("read")
  serialConsoleLogBlobUri?: string;

  @doc("""
The boot diagnostics status information for the VM. <br><br> NOTE: It will be
set only if there are errors encountered in enabling boot diagnostics.
""")
  @visibility("read")
  status?: InstanceViewStatus;
}

@doc("Specifies the hardware settings for the virtual machine.")
model HardwareProfile {
  @doc("""
Specifies the size of the virtual machine. <br><br> The enum data type is
currently deprecated and will be removed by December 23rd 2023. <br><br>
Recommended way to get the list of available sizes is using these APIs:
<br><br> [List all available virtual machine sizes in an availability
set](https://docs.microsoft.com/rest/api/compute/availabilitysets/listavailablesizes)
<br><br> [List all available virtual machine sizes in a region](
https://docs.microsoft.com/rest/api/compute/resourceskus/list) <br><br> [List
all available virtual machine sizes for
resizing](https://docs.microsoft.com/rest/api/compute/virtualmachines/listavailablesizes).
For more information about virtual machine sizes, see [Sizes for virtual
machines](https://docs.microsoft.com/azure/virtual-machines/sizes). <br><br>
The available VM sizes depend on region and availability set.
""")
  vmSize?: VirtualMachineSizeTypes;

  @doc("""
Specifies the properties for customizing the size of the virtual machine.
Minimum api-version: 2021-07-01. <br><br> This feature is still in preview mode
and is not supported for VirtualMachineScaleSet. <br><br> Please follow the
instructions in [VM Customization](https://aka.ms/vmcustomization) for more
details.
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
machine. <br><br> For more information about disks, see [About disks and VHDs
for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  osDisk?: OSDisk;

  @doc("""
Specifies the parameters that are used to add a data disk to a virtual machine.
<br><br> For more information about disks, see [About disks and VHDs for Azure
virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
  dataDisks?: DataDisk[];

  @doc("""
Specifies the disk controller type configured for the VM. <br><br>NOTE: This
property will be set to the default disk controller type if not specified
provided virtual machine is being created as a hyperVGeneration: V2 based on
the capabilities of the operating system disk and VM size from the the
specified minimum api version. <br>You need to deallocate the VM before
updating its disk controller type unless you are updating the VM size in the VM
configuration which implicitly deallocates and reallocates the VM. <br><br>
Minimum api-version: 2022-08-01
""")
  diskControllerType?: DiskControllerTypes;
}

@doc("""
Specifies information about the operating system disk used by the virtual
machine. <br><br> For more information about disks, see [About disks and VHDs
for Azure virtual
machines](https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview).
""")
model OSDisk {
  @doc("""
This property allows you to specify the type of the OS that is included in the
disk if creating a VM from user-image or a specialized VHD. <br><br> Possible
values are: <br><br> **Windows** <br><br> **Linux**
""")
  osType?: OperatingSystemTypes;

  @doc("""
Specifies the encryption settings for the OS Disk. <br><br> Minimum
api-version: 2015-06-15
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
Specifies the caching requirements. <br><br> Possible values are: <br><br>
**None** <br><br> **ReadOnly** <br><br> **ReadWrite** <br><br> Default:
**None** for Standard storage. **ReadOnly** for Premium storage.
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
Specifies how the virtual machine should be created.<br><br> Possible values
are:<br><br> **Attach** \\u2013 This value is used when you are using a
specialized disk to create the virtual machine.<br><br> **FromImage** \\u2013
This value is used when you are using an image to create the virtual machine.
If you are using a platform image, you also use the imageReference element
described above. If you are using a marketplace image, you  also use the plan
element previously described.
""")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. <br><br>
diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be
larger than 1023
""")
  diskSizeGB?: int32;

  @doc("The managed disk parameters.")
  managedDisk?: ManagedDiskParameters;

  @doc("""
Specifies whether OS Disk should be deleted or detached upon VM deletion.
<br><br> Possible values: <br><br> **Delete** If this value is used, the OS
disk is deleted when VM is deleted.<br><br> **Detach** If this value is used,
the os disk is retained after VM is deleted. <br><br> The default value is set
to **detach**. For an ephemeral OS Disk, the default value is set to
**Delete**. User cannot change the delete option for ephemeral OS Disk.
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
Specifies the caching requirements. <br><br> Possible values are: <br><br>
**None** <br><br> **ReadOnly** <br><br> **ReadWrite** <br><br> Default: **None
for Standard storage. ReadOnly for Premium storage**
""")
  caching?: CachingTypes;

  @doc("Specifies whether writeAccelerator should be enabled or disabled on the disk.")
  writeAcceleratorEnabled?: boolean;

  @doc("""
Specifies how the virtual machine should be created.<br><br> Possible values
are:<br><br> **Attach** \\u2013 This value is used when you are using a
specialized disk to create the virtual machine.<br><br> **FromImage** \\u2013
This value is used when you are using an image to create the virtual machine.
If you are using a platform image, you also use the imageReference element
described above. If you are using a marketplace image, you  also use the plan
element previously described.
""")
  createOption: DiskCreateOptionTypes;

  @doc("""
Specifies the size of an empty data disk in gigabytes. This element can be used
to overwrite the size of the disk in a virtual machine image. <br><br>
diskSizeGB is the number of bytes x 1024^3 for the disk and the value cannot be
larger than 1023
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
values: **ForceDetach**. <br><br> detachOption: **ForceDetach** is applicable
only for managed data disks. If a previous detachment attempt of the data disk
did not complete due to an unexpected failure from the virtual machine and the
disk is still not released then use force-detach as a last resort option to
detach the disk forcibly from the VM. All writes might not have been flushed
when using this detach behavior. <br><br> This feature is still in preview mode
and is not supported for VirtualMachineScaleSet. To force-detach a data disk
update toBeDetached to 'true' along with setting detachOption: 'ForceDetach'.
""")
  detachOption?: DiskDetachOptionTypes;

  @doc("""
Specifies whether data disk should be deleted or detached upon VM
deletion.<br><br> Possible values: <br><br> **Delete** If this value is used,
the data disk is deleted when VM is deleted.<br><br> **Detach** If this value
is used, the data disk is retained after VM is deleted.<br><br> The default
value is set to **detach**
""")
  deleteOption?: DiskDeleteOptionTypes;
}

@doc("""
Specifies the operating system settings for the virtual machine. Some of the
settings cannot be changed once VM is provisioned.
""")
model OSProfile {
  @doc("""
Specifies the host OS name of the virtual machine. <br><br> This name cannot be
updated after the VM is created. <br><br> **Max-length (Windows):** 15
characters <br><br> **Max-length (Linux):** 64 characters. <br><br> For naming
conventions and restrictions see [Azure infrastructure services implementation
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
The maximum length of the binary array is 65535 bytes. <br><br> **Note: Do not
pass any secrets or passwords in customData property** <br><br> This property
cannot be updated after the VM is created. <br><br> customData is passed to the
VM to be saved as a file, for more information see [Custom Data on Azure
VMs](https://azure.microsoft.com/blog/custom-data-and-cloud-init-on-windows-azure/)
<br><br> For using cloud-init for your Linux VM, see [Using cloud-init to
customize a Linux VM during
creation](https://docs.microsoft.com/azure/virtual-machines/linux/using-cloud-init)
""")
  customData?: string;

  @doc("Specifies Windows operating system settings on the virtual machine.")
  windowsConfiguration?: WindowsConfiguration;

  @doc("""
Specifies the Linux operating system settings on the virtual machine.
<br><br>For a list of supported Linux distributions, see [Linux on
Azure-Endorsed
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
machine. <br><br>This may only be set to False when no extensions are present
on the virtual machine.
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

@doc("Describes a Virtual Machine Extension.")
model VirtualMachineExtension {
  ...ResourceWithOptionalLocation;

  @doc("Describes the properties of a Virtual Machine Extension.")
  properties?: VirtualMachineExtensionProperties;
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

@doc("The List Virtual Machine Scale Set VMs operation response.")
model VirtualMachineScaleSetVMListResult
  is Azure.Core.Page<VirtualMachineScaleSetVM>;

@doc("The SAS URIs of the console screenshot and serial log blobs.")
model RetrieveBootDiagnosticsDataResult {
  @doc("The console screenshot blob URI")
  @visibility("read")
  consoleScreenshotBlobUri?: string;

  @doc("The serial console log blob URI.")
  @visibility("read")
  serialConsoleLogBlobUri?: string;
}

@doc("Describes a Virtual Machine Extension.")
model VirtualMachineExtensionUpdate {
  ...UpdateResource;

  @doc("Describes the properties of a Virtual Machine Extension.")
  properties?: VirtualMachineExtensionUpdateProperties;
}

@doc("The List Extension operation response")
model VirtualMachineExtensionsListResult {
  @doc("The list of extensions")
  value?: VirtualMachineExtension[];
}

@doc("The List Virtual Machine operation response.")
model VirtualMachineListResult is Azure.Core.Page<VirtualMachine>;

@doc("Describes a Virtual Machine.")
model VirtualMachine {
  ...Resource;

  @doc("""
Specifies information about the marketplace image used to create the virtual
machine. This element is only used for marketplace images. Before you can use a
marketplace image from an API, you must enable the image for programmatic use. 
In the Azure portal, find the marketplace image that you want to use and then
click **Want to deploy programmatically, Get Started ->**. Enter any required
information and then click **Save**.
""")
  plan?: Plan;

  @doc("Describes the properties of a Virtual Machine.")
  properties?: VirtualMachineProperties;

  @doc("The virtual machine child extension resources.")
  @visibility("read")
  resources?: VirtualMachineExtension[];

  @doc("The identity of the virtual machine, if configured.")
  identity?: VirtualMachineIdentity;

  @doc("The virtual machine zones.")
  zones?: string[];

  @doc("The extended location of the Virtual Machine.")
  extendedLocation?: ExtendedLocation;
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

  @doc("""
Specifies the boot diagnostic settings state. <br><br>Minimum api-version:
2015-06-15.
""")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Virtual machines specified in the same availability set
are allocated to different nodes to maximize availability. For more information
about availability sets, see [Availability sets
overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview).
<br><br> For more information on Azure planned maintenance, see [Maintenance
and updates for Virtual Machines in
Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates)
<br><br> Currently, a VM can only be added to availability set at creation
time. The availability set to which the VM is being added should be under the
same resource group as the availability set resource. An existing VM cannot be
added to an availability set. <br><br>This property cannot exist along with a
non-null properties.virtualMachineScaleSet reference.
""")
  availabilitySet?: SubResource;

  @doc("""
Specifies information about the virtual machine scale set that the virtual
machine should be assigned to. Virtual machines specified in the same virtual
machine scale set are allocated to different nodes to maximize availability.
Currently, a VM can only be added to virtual machine scale set at creation
time. An existing VM cannot be added to a virtual machine scale set.
<br><br>This property cannot exist along with a non-null
properties.availabilitySet reference. <br><br>Minimum api‐version: 2019‐03‐01
""")
  virtualMachineScaleSet?: SubResource;

  @doc("""
Specifies information about the proximity placement group that the virtual
machine should be assigned to. <br><br>Minimum api-version: 2018-04-01.
""")
  proximityPlacementGroup?: SubResource;

  @doc("""
Specifies the priority for the virtual machine. <br><br>Minimum api-version:
2019-03-01
""")
  priority?: VirtualMachinePriorityTypes;

  @doc("""
Specifies the eviction policy for the Azure Spot virtual machine and Azure Spot
scale set. <br><br>For Azure Spot virtual machines, both 'Deallocate' and
'Delete' are supported and the minimum api-version is 2019-03-01. <br><br>For
Azure Spot scale sets, both 'Deallocate' and 'Delete' are supported and the
minimum api-version is 2017-10-30-preview.
""")
  evictionPolicy?: VirtualMachineEvictionPolicyTypes;

  @doc("""
Specifies the billing related details of a Azure Spot virtual machine.
<br><br>Minimum api-version: 2019-03-01.
""")
  billingProfile?: BillingProfile;

  @doc("""
Specifies information about the dedicated host that the virtual machine resides
in. <br><br>Minimum api-version: 2018-10-01.
""")
  host?: SubResource;

  @doc("""
Specifies information about the dedicated host group that the virtual machine
resides in. <br><br>Minimum api-version: 2020-06-01. <br><br>NOTE: User cannot
specify both host and hostGroup properties.
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
<br><br> Minimum api-version: 2020-06-01
""")
  extensionsTimeBudget?: string;

  @doc("""
Specifies the scale set logical fault domain into which the Virtual Machine
will be created. By default, the Virtual Machine will by automatically assigned
to a fault domain that best maintains balance across available fault
domains.<br><li>This is applicable only if the 'virtualMachineScaleSet'
property of this Virtual Machine is set.<li>The Virtual Machine Scale Set that
is referenced, must have 'platformFaultDomainCount' &gt; 1.<li>This property
cannot be updated once the Virtual Machine is created.<li>Fault domain
assignment can be viewed in the Virtual Machine Instance View.<br><br>Minimum
api‐version: 2020‐12‐01
""")
  platformFaultDomain?: int32;

  @doc("Specifies Scheduled Event related configurations.")
  scheduledEventsProfile?: ScheduledEventsProfile;

  @doc("""
UserData for the VM, which must be base-64 encoded. Customer should not pass
any secrets in here. <br><br>Minimum api-version: 2021-03-01
""")
  userData?: string;

  @doc("""
Specifies information about the capacity reservation that is used to allocate
virtual machine. <br><br>Minimum api-version: 2021-04-01.
""")
  capacityReservation?: CapacityReservationProfile;

  @doc("Specifies the gallery applications that should be made available to the VM/VMSS")
  applicationProfile?: ApplicationProfile;

  @doc("""
Specifies the time at which the Virtual Machine resource was
created.<br><br>Minimum api-version: 2021-11-01.
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
and Screenshot to diagnose VM status. <br><br> You can easily view the output
of your console log. <br><br> Azure also enables you to see a screenshot of the
VM from the hypervisor.
""")
  bootDiagnostics?: BootDiagnosticsInstanceView;

  @doc("""
Resource id of the dedicated host, on which the virtual machine is allocated
through automatic placement, when the virtual machine is associated with a
dedicated host group that has automatic placement enabled. <br><br>Minimum
api-version: 2020-06-01.
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
  parameters?: unknown;

  @doc("a list of resource items of the captured virtual machine")
  @visibility("read")
  resources?: unknown[];
}

@doc("Describes a Virtual Machine Update.")
model VirtualMachineUpdate {
  ...UpdateResource;

  @doc("""
Specifies information about the marketplace image used to create the virtual
machine. This element is only used for marketplace images. Before you can use a
marketplace image from an API, you must enable the image for programmatic use. 
In the Azure portal, find the marketplace image that you want to use and then
click **Want to deploy programmatically, Get Started ->**. Enter any required
information and then click **Save**.
""")
  plan?: Plan;

  @doc("Describes the properties of a Virtual Machine.")
  properties?: VirtualMachineProperties;

  @doc("The identity of the virtual machine, if configured.")
  identity?: VirtualMachineIdentity;

  @doc("The virtual machine zones.")
  zones?: string[];
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
  maximumDuration?: string;

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

@doc("Describes a Virtual Machine Extension Image.")
model VirtualMachineExtensionImage {
  ...Resource;

  @doc("Describes the properties of a Virtual Machine Extension Image.")
  properties?: VirtualMachineExtensionImageProperties;
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

@doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Virtual machines specified in the same availability set
are allocated to different nodes to maximize availability. For more information
about availability sets, see [Availability sets
overview](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview).
<br><br> For more information on Azure planned maintenance, see [Maintenance
and updates for Virtual Machines in
Azure](https://docs.microsoft.com/azure/virtual-machines/maintenance-and-updates)
<br><br> Currently, a VM can only be added to availability set at creation
time. An existing VM cannot be added to an availability set.
""")
model AvailabilitySet {
  ...Resource;

  @doc("The instance view of a resource.")
  properties?: AvailabilitySetProperties;

  @doc("""
Sku of the availability set, only name is required to be set. See
AvailabilitySetSkuTypes for possible set of values. Use 'Aligned' for virtual
machines with managed disks and 'Classic' for virtual machines with unmanaged
disks. Default value is 'Classic'.
""")
  sku?: Sku;
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
set should be assigned to. <br><br>Minimum api-version: 2018-04-01.
""")
  proximityPlacementGroup?: SubResource;

  @doc("The resource status information.")
  @visibility("read")
  statuses?: InstanceViewStatus[];
}

@doc("""
Specifies information about the availability set that the virtual machine
should be assigned to. Only tags may be updated.
""")
model AvailabilitySetUpdate {
  ...UpdateResource;

  @doc("The instance view of a resource.")
  properties?: AvailabilitySetProperties;

  @doc("Sku of the availability set")
  sku?: Sku;
}

@doc("The List Availability Set operation response.")
model AvailabilitySetListResult is Azure.Core.Page<AvailabilitySet>;

@doc("Specifies information about the proximity placement group.")
model ProximityPlacementGroup {
  ...Resource;

  @doc("Describes the properties of a Proximity Placement Group.")
  properties?: ProximityPlacementGroupProperties;

  @doc("""
Specifies the Availability Zone where virtual machine, virtual machine scale
set or availability set associated with the  proximity placement group can be
created.
""")
  zones?: string[];
}

@doc("Describes the properties of a Proximity Placement Group.")
model ProximityPlacementGroupProperties {
  @doc("""
Specifies the type of the proximity placement group. <br><br> Possible values
are: <br><br> **Standard** : Co-locate resources within an Azure region or
Availability Zone. <br><br> **Ultra** : For future use.
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

@doc("The List Proximity Placement Group operation response.")
model ProximityPlacementGroupListResult
  is Azure.Core.Page<ProximityPlacementGroup>;

@doc("""
Specifies information about the dedicated host group that the dedicated hosts
should be assigned to. <br><br> Currently, a dedicated host can only be added
to a dedicated host group at creation time. An existing dedicated host cannot
be added to another dedicated host group.
""")
model DedicatedHostGroup {
  ...Resource;

  @doc("Dedicated Host Group Properties.")
  properties?: DedicatedHostGroupProperties;

  @doc("""
Availability Zone to use for this host group. Only single zone is supported.
The zone can be assigned only during creation. If not provided, the group
supports all zones in the region. If provided, enforces each host in the group
to be in the same zone.
""")
  zones?: string[];
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
host group. The value is defaulted to 'false' when not provided.
<br><br>Minimum api-version: 2020-06-01.
""")
  supportAutomaticPlacement?: boolean;

  @doc("""
Enables or disables a capability on the dedicated host group.<br><br>Minimum
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
Enables or disables a capability on the dedicated host group.<br><br>Minimum
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
for more details on Ultra SSD feature. <br><br>NOTE: The ultraSSDEnabled
setting can only be enabled for Host Groups that are created as zonal.
<br><br>Minimum api-version: 2022-03-01.
""")
  ultraSSDEnabled?: boolean;
}

@doc("""
Specifies information about the dedicated host group that the dedicated host
should be assigned to. Only tags may be updated.
""")
model DedicatedHostGroupUpdate {
  ...UpdateResource;

  @doc("Dedicated Host Group Properties.")
  properties?: DedicatedHostGroupProperties;

  @doc("""
Availability Zone to use for this host group. Only single zone is supported.
The zone can be assigned only during creation. If not provided, the group
supports all zones in the region. If provided, enforces each host in the group
to be in the same zone.
""")
  zones?: string[];
}

@doc("The List Dedicated Host Group with resource group response.")
model DedicatedHostGroupListResult is Azure.Core.Page<DedicatedHostGroup>;

@doc("Specifies information about the Dedicated host.")
model DedicatedHost {
  ...Resource;

  @doc("Properties of the dedicated host.")
  properties?: DedicatedHostProperties;

  @doc("""
SKU of the dedicated host for Hardware Generation and VM family. Only name is
required to be set. List Microsoft.Compute SKUs for a list of possible values.
""")
  sku: Sku;
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
A unique id generated and assigned to the dedicated host by the platform.
<br><br> Does not change throughout the lifetime of the host.
""")
  @visibility("read")
  hostId?: string;

  @doc("A list of references to all virtual machines in the Dedicated Host.")
  @visibility("read")
  virtualMachines?: SubResourceReadOnly[];

  @doc("""
Specifies the software license type that will be applied to the VMs deployed on
the dedicated host. <br><br> Possible values are: <br><br> **None** <br><br>
**Windows_Server_Hybrid** <br><br> **Windows_Server_Perpetual** <br><br>
Default: **None**
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
Specifies the time at which the Dedicated Host resource was
created.<br><br>Minimum api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("""
Specifies information about the dedicated host. Only tags, autoReplaceOnFailure
and licenseType may be updated.
""")
model DedicatedHostUpdate {
  ...UpdateResource;

  @doc("Properties of the dedicated host.")
  properties?: DedicatedHostProperties;
}

@doc("The list dedicated host operation response.")
model DedicatedHostListResult is Azure.Core.Page<DedicatedHost>;

@doc("The list SSH public keys operation response.")
model SshPublicKeysGroupListResult is Azure.Core.Page<SshPublicKeyResource>;

@doc("Specifies information about the SSH public key.")
model SshPublicKeyResource {
  ...Resource;

  @doc("Properties of the SSH public key.")
  properties?: SshPublicKeyResourceProperties;
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

@doc("Specifies information about the SSH public key.")
model SshPublicKeyUpdateResource {
  ...UpdateResource;

  @doc("Properties of the SSH public key.")
  properties?: SshPublicKeyResourceProperties;
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

@doc("""
The source user image virtual hard disk. The virtual hard disk will be copied
before being attached to the virtual machine. If SourceImage is provided, the
destination virtual hard drive must not exist.
""")
model Image {
  ...Resource;

  @doc("Describes the properties of an Image.")
  properties?: ImageProperties;

  @doc("The extended location of the Image.")
  extendedLocation?: ExtendedLocation;
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
disk if creating a VM from a custom image. <br><br> Possible values are:
<br><br> **Windows** <br><br> **Linux**
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
Specifies the caching requirements. <br><br> Possible values are: <br><br>
**None** <br><br> **ReadOnly** <br><br> **ReadWrite** <br><br> Default: **None
for Standard storage. ReadOnly for Premium storage**
""")
  caching?: CachingTypes;

  @doc("""
Specifies the size of empty data disks in gigabytes. This element can be used
to overwrite the name of the disk in a virtual machine image. <br><br> This
value cannot be larger than 1023 GB
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

@doc("The source user image virtual hard disk. Only tags may be updated.")
model ImageUpdate {
  ...UpdateResource;

  @doc("Describes the properties of an Image.")
  properties?: ImageProperties;
}

@doc("The List Image operation response.")
model ImageListResult is Azure.Core.Page<Image>;

@doc("Create or update Restore Point collection parameters.")
model RestorePointCollection {
  ...Resource;

  @doc("The restore point collection properties.")
  properties?: RestorePointCollectionProperties;
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

@doc("Restore Point details.")
model RestorePoint {
  ...ProxyResource;

  @doc("The restore point properties.")
  properties?: RestorePointProperties;
}

@doc("The restore point properties.")
model RestorePointProperties {
  @doc("""
List of disk resource ids that the customer wishes to exclude from the restore
point. If no disks are specified, all disks will be included.
""")
  excludeDisks?: ApiEntityReference[];

  @doc("Gets the details of the VM captured at the time of the restore point creation.")
  @visibility("read")
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
  hardwareProfile?: HardwareProfile;

  @doc("Gets the storage profile.")
  storageProfile?: RestorePointSourceVMStorageProfile;

  @doc("Gets the OS profile.")
  osProfile?: OSProfile;

  @doc("Gets the diagnostics profile.")
  diagnosticsProfile?: DiagnosticsProfile;

  @doc("Gets the license type, which is for bring your own license scenario.")
  licenseType?: string;

  @doc("Gets the virtual machine unique id.")
  vmId?: string;

  @doc("Gets the security profile.")
  securityProfile?: SecurityProfile;

  @doc("Location of the VM from which the restore point was created.")
  location?: string;
}

@doc("Describes the storage profile.")
model RestorePointSourceVMStorageProfile {
  @doc("Gets the OS disk of the VM captured at the time of the restore point creation.")
  osDisk?: RestorePointSourceVmosDisk;

  @doc("""
Gets the data disks of the VM captured at the time of the restore point
creation.
""")
  dataDisks?: RestorePointSourceVMDataDisk[];
}

@doc("Describes an Operating System disk.")
model RestorePointSourceVmosDisk {
  @doc("Gets the Operating System type.")
  osType?: OperatingSystemType;

  @doc("Gets the disk encryption settings.")
  encryptionSettings?: DiskEncryptionSettings;

  @doc("Gets the disk name.")
  name?: string;

  @doc("Gets the caching type.")
  caching?: CachingTypes;

  @doc("Gets the disk size in GB.")
  diskSizeGB?: int32;

  @doc("Gets the managed disk details")
  managedDisk?: ManagedDiskParameters;

  @doc("Gets the disk restore point Id.")
  diskRestorePoint?: ApiEntityReference;
}

@doc("Describes a data disk.")
model RestorePointSourceVMDataDisk {
  @doc("Gets the logical unit number.")
  lun?: int32;

  @doc("Gets the disk name.")
  name?: string;

  @doc("Gets the caching type.")
  caching?: CachingTypes;

  @doc("""
Gets the initial disk size in GB for blank data disks, and the new desired size
for existing OS and Data disks.
""")
  diskSizeGB?: int32;

  @doc("Gets the managed disk details")
  managedDisk?: ManagedDiskParameters;

  @doc("Gets the disk restore point Id.")
  diskRestorePoint?: ApiEntityReference;
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

@doc("""
The resource model definition for an Azure Resource Manager proxy resource. It
will not have tags and a location
""")
model ProxyResource {
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

@doc("Update Restore Point collection parameters.")
model RestorePointCollectionUpdate {
  ...UpdateResource;

  @doc("The restore point collection properties.")
  properties?: RestorePointCollectionProperties;
}

@doc("The List restore point collection operation response.")
model RestorePointCollectionListResult
  is Azure.Core.Page<RestorePointCollection>;

@doc("""
Specifies information about the capacity reservation group that the capacity
reservations should be assigned to. <br><br> Currently, a capacity reservation
can only be added to a capacity reservation group at creation time. An existing
capacity reservation cannot be added or moved to another capacity reservation
group.
""")
model CapacityReservationGroup {
  ...Resource;

  @doc("capacity reservation group Properties.")
  properties?: CapacityReservationGroupProperties;

  @doc("""
Availability Zones to use for this capacity reservation group. The zones can be
assigned only during creation. If not provided, the group supports only
regional resources in the region. If provided, enforces each capacity
reservation in the group to be in one of the zones.
""")
  zones?: string[];
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
successfully and for which the customer is getting billed.<br><br>Minimum
api-version: 2022-08-01.
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

@doc("""
Specifies information about the capacity reservation group. Only tags can be
updated.
""")
model CapacityReservationGroupUpdate {
  ...UpdateResource;

  @doc("capacity reservation group Properties.")
  properties?: CapacityReservationGroupProperties;
}

@doc("The List capacity reservation group with resource group response.")
model CapacityReservationGroupListResult
  is Azure.Core.Page<CapacityReservationGroup>;

@doc("Specifies information about the capacity reservation.")
model CapacityReservation {
  ...Resource;

  @doc("Properties of the Capacity reservation.")
  properties?: CapacityReservationProperties;

  @doc("""
SKU of the resource for which capacity needs be reserved. The SKU name and
capacity is required to be set. Currently VM Skus with the capability called
'CapacityReservationSupported' set to true are supported. Refer to List
Microsoft.Compute SKUs in a region
(https://docs.microsoft.com/rest/api/compute/resourceskus/list) for supported
values.
""")
  sku: Sku;

  @doc("""
Availability Zone to use for this capacity reservation. The zone has to be
single value and also should be part for the list of zones specified during the
capacity reservation group creation. The zone can be assigned only during
creation. If not provided, the reservation supports only non-zonal deployments.
If provided, enforces VM/VMSS using this capacity reservation to be in same
zone.
""")
  zones?: string[];
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
for requested VM size.<br>NOTE: The fault domain count specified for a resource
(like virtual machines scale set) must be less than or equal to this value if
it deploys using capacity reservation.<br><br>Minimum api-version: 2022-08-01.
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
Specifies the time at which the Capacity Reservation resource was
created.<br><br>Minimum api-version: 2021-11-01.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timeCreated?: utcDateTime;
}

@doc("""
Specifies information about the capacity reservation. Only tags and
sku.capacity can be updated.
""")
model CapacityReservationUpdate {
  ...UpdateResource;

  @doc("Properties of the Capacity reservation.")
  properties?: CapacityReservationProperties;

  @doc("""
SKU of the resource for which capacity needs be reserved. The SKU name and
capacity is required to be set. Currently VM Skus with the capability called
'CapacityReservationSupported' set to true are supported. Refer to List
Microsoft.Compute SKUs in a region
(https://docs.microsoft.com/rest/api/compute/resourceskus/list) for supported
values.
""")
  sku?: Sku;
}

@doc("The list capacity reservation operation response.")
model CapacityReservationListResult is Azure.Core.Page<CapacityReservation>;

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

@doc("The List Virtual Machine operation response.")
model RunCommandListResult is Azure.Core.Page<RunCommandDocumentBase>;

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

@doc("Describes a Virtual Machine run command.")
model VirtualMachineRunCommand {
  ...Resource;

  @doc("Describes the properties of a Virtual Machine run command.")
  properties?: VirtualMachineRunCommandProperties;
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

  @doc("Specifies the Azure storage blob where script output stream will be uploaded.")
  outputBlobUri?: string;

  @doc("Specifies the Azure storage blob where script error stream will be uploaded.")
  errorBlobUri?: string;

  @doc("The provisioning state, which only appears in the response.")
  @visibility("read")
  provisioningState?: string;

  @doc("The virtual machine run command instance view.")
  @visibility("read")
  instanceView?: VirtualMachineRunCommandInstanceView;
}

@doc("Describes the script sources for run command.")
model VirtualMachineRunCommandScriptSource {
  @doc("Specifies the script content to be executed on the VM.")
  script?: string;

  @doc("Specifies the script download location.")
  scriptUri?: string;

  @doc("Specifies a commandId of predefined built-in script.")
  commandId?: string;
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

@doc("Describes a Virtual Machine run command.")
model VirtualMachineRunCommandUpdate {
  ...UpdateResource;

  @doc("Describes the properties of a Virtual Machine run command.")
  properties?: VirtualMachineRunCommandProperties;
}

@doc("The List run command operation response")
model VirtualMachineRunCommandsListResult
  is Azure.Core.Page<VirtualMachineRunCommand>;
