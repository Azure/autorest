import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Compute;

interface OperationsOperations {
  @doc("Gets a list of compute operations.")
  @route("/providers/Microsoft.Compute/operations")
  @get
  List is Azure.Core.Foundations.Operation<{}, ComputeOperationListResult>;
}

interface UsageOperations {
  @doc("""
Gets, for the specified location, the current compute resource usage
information as well as the limits for compute resources under the subscription.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The location for which resource usage is queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    ListUsagesResult
  >;
}

interface VirtualMachineSizesOperations {
  @doc("""
This API is deprecated. Use [Resources
Skus](https://docs.microsoft.com/rest/api/compute/resourceskus/list)
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

interface VirtualMachineScaleSetsOperations {
  @doc("""
Gets all the VM scale sets under the specified subscription for the specified
location.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachineScaleSets")
  @get
  ListByLocation is Azure.Core.Foundations.Operation<
    {
      @doc("The location for which VM scale sets under the subscription are queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListResult
  >;

  @doc("Create or update a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set to create or update.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The scale set object.")
      @body
      parameters: VirtualMachineScaleSet;
    },
    VirtualMachineScaleSet
  >;

  @doc("Update a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set to create or update.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The scale set object.")
      @body
      parameters: VirtualMachineScaleSetUpdate;
    },
    VirtualMachineScaleSet
  >;

  @doc("Deletes a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("Optional parameter to force delete a VM scale set. (Feature in Preview)")
      @query
      forceDeletion: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Display information about a virtual machine scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("""
The expand expression to apply on the operation. 'UserData' retrieves the
UserData property of the VM scale set that was provided by the user during the
VM scale set Create/Update operation
""")
      @query
      $expand: ExpandTypesForGetVMScaleSets;
    },
    VirtualMachineScaleSet
  >;

  @doc("""
Deallocates specific virtual machines in a VM scale set. Shuts down the virtual
machines and releases the compute resources. You are not billed for the compute
resources that this virtual machine scale set deallocates.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate")
  @post
  Deallocate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("Deletes virtual machines in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete")
  @post
  DeleteInstances is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Optional parameter to force delete virtual machines from the VM scale set.
(Feature in Preview)
""")
      @query
      forceDeletion: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceRequiredIDs;
    },
    void
  >;

  @doc("Gets the status of a VM scale set instance.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView")
  @get
  GetInstanceView is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetInstanceView
  >;

  @doc("Gets a list of all VM scale sets under a resource group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListResult
  >;

  @doc("""
Gets a list of all VM Scale Sets in the subscription, regardless of the
associated resource group. Use nextLink property in the response to get the
next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM
Scale Sets.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets")
  @get
  ListAll is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListWithLinkResult
  >;

  @doc("""
Gets a list of SKUs available for your VM scale set, including the minimum and
maximum VM instances allowed for each SKU.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus")
  @get
  ListSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListSkusResult
  >;

  @doc("Gets list of OS upgrades on a VM scale set instance.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory")
  @get
  GetOSUpgradeHistory is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListOSUpgradeHistory
  >;

  @doc("""
Power off (stop) one or more virtual machines in a VM scale set. Note that
resources are still attached and you are getting charged for the resources.
Instead, use deallocate to release resources and avoid charges.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff")
  @post
  PowerOff is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
The parameter to request non-graceful VM shutdown. True value for this flag
indicates non-graceful shutdown whereas false indicates otherwise. Default
value for this flag is false if not specified
""")
      @query
      skipShutdown: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("Restarts one or more virtual machines in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart")
  @post
  Restart is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("Starts one or more virtual machines in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start")
  @post
  Start is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("""
Shuts down all the virtual machines in the virtual machine scale set, moves
them to a new node, and powers them back on.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy")
  @post
  Redeploy is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("""
Perform maintenance on one or more virtual machines in a VM scale set.
Operation on instances which are not eligible for perform maintenance will be
failed. Please refer to best practices for more details:
https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance")
  @post
  PerformMaintenance is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("""
Upgrades one or more virtual machines to the latest SKU set in the VM scale set
model.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade")
  @post
  UpdateInstances is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceRequiredIDs;
    },
    void
  >;

  @doc("""
Reimages (upgrade the operating system) one or more virtual machines in a VM
scale set which don't have a ephemeral OS disk, for virtual machines who have a
ephemeral OS disk the virtual machine is reset to initial state.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage")
  @post
  Reimage is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters for Reimaging VM ScaleSet.")
      @body
      vmScaleSetReimageInput: VirtualMachineScaleSetReimageParameters;
    },
    void
  >;

  @doc("""
Reimages all the disks ( including data disks ) in the virtual machines in a VM
scale set. This operation is only supported for managed disks.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall")
  @post
  ReimageAll is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("A list of virtual machine instance IDs from the VM scale set.")
      @body
      vmInstanceIDs: VirtualMachineScaleSetVMInstanceIDs;
    },
    void
  >;

  @doc("""
Manual platform update domain walk to update virtual machines in a service
fabric virtual machine scale set.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk")
  @post
  ForceRecoveryServiceFabricPlatformUpdateDomainWalk is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The platform update domain for which a manual recovery walk is requested")
      @query
      platformUpdateDomain: int32;

      @doc("""
The zone in which the manual recovery walk is requested for cross zone virtual
machine scale set
""")
      @query
      zone: string;

      @doc("The placement group id for which the manual recovery walk is requested.")
      @query
      placementGroupId: string;
    },
    RecoveryWalkResponse
  >;

  @doc("""
Converts SinglePlacementGroup property to false for a existing virtual machine
scale set.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/convertToSinglePlacementGroup")
  @post
  ConvertToSinglePlacementGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine scale set to create or update.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The input object for ConvertToSinglePlacementGroup API.")
      @body
      parameters: VMScaleSetConvertToSinglePlacementGroupInput;
    },
    void
  >;

  @doc("Changes ServiceState property for a given service")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/setOrchestrationServiceState")
  @post
  SetOrchestrationServiceState is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine scale set to create or update.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The input object for SetOrchestrationServiceState API.")
      @body
      parameters: OrchestrationServiceStateInput;
    },
    void
  >;
}

interface VirtualMachineScaleSetExtensionsOperations {
  @doc("The operation to create or update an extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set where the extension should be create or updated.")
      @path
      vmScaleSetName: string;

      @doc("The name of the VM scale set extension.")
      @path
      vmssExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create VM scale set Extension operation.")
      @body
      extensionParameters: VirtualMachineScaleSetExtension;
    },
    VirtualMachineScaleSetExtension
  >;

  @doc("The operation to update an extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set where the extension should be updated.")
      @path
      vmScaleSetName: string;

      @doc("The name of the VM scale set extension.")
      @path
      vmssExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update VM scale set Extension operation.")
      @body
      extensionParameters: VirtualMachineScaleSetExtensionUpdate;
    },
    VirtualMachineScaleSetExtension
  >;

  @doc("The operation to delete the extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set where the extension should be deleted.")
      @path
      vmScaleSetName: string;

      @doc("The name of the VM scale set extension.")
      @path
      vmssExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to get the extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set containing the extension.")
      @path
      vmScaleSetName: string;

      @doc("The name of the VM scale set extension.")
      @path
      vmssExtensionName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetExtension
  >;

  @doc("Gets a list of all extensions in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set containing the extension.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetExtensionListResult
  >;
}

interface VirtualMachineScaleSetRollingUpgradesOperations {
  @doc("Cancels the current virtual machine scale set rolling upgrade.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel")
  @post
  Cancel is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Starts a rolling upgrade to move all virtual machine scale set instances to the
latest available Platform Image OS version. Instances which are already running
the latest available OS version are not affected.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade")
  @post
  StartOSUpgrade is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Starts a rolling upgrade to move all extensions for all virtual machine scale
set instances to the latest available extension version. Instances which are
already running the latest extension versions are not affected.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensionRollingUpgrade")
  @post
  StartExtensionUpgrade is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets the status of the latest virtual machine scale set rolling upgrade.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest")
  @get
  GetLatest is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    RollingUpgradeStatusInfo
  >;
}

interface VirtualMachineScaleSetVMExtensionsOperations {
  @doc("The operation to create or update the VMSS VM extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/extensions/{vmExtensionName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Virtual Machine Extension operation.")
      @body
      extensionParameters: VirtualMachineScaleSetVMExtension;
    },
    VirtualMachineScaleSetVMExtension
  >;

  @doc("The operation to update the VMSS VM extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/extensions/{vmExtensionName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Virtual Machine Extension operation.")
      @body
      extensionParameters: VirtualMachineScaleSetVMExtensionUpdate;
    },
    VirtualMachineScaleSetVMExtension
  >;

  @doc("The operation to delete the VMSS VM extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/extensions/{vmExtensionName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to get the VMSS VM extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/extensions/{vmExtensionName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetVMExtension
  >;

  @doc("The operation to get all extensions of an instance in Virtual Machine Scaleset.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/extensions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetVMExtensionsListResult
  >;
}

interface VirtualMachineScaleSetVMsOperations {
  @doc("""
Reimages (upgrade the operating system) a specific virtual machine in a VM
scale set.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/reimage")
  @post
  Reimage is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters for the Reimaging Virtual machine in ScaleSet.")
      @body
      vmScaleSetVMReimageInput: VirtualMachineScaleSetVMReimageParameters;
    },
    void
  >;

  @doc("""
Allows you to re-image all the disks ( including data disks ) in the a VM scale
set instance. This operation is only supported for managed disks.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/reimageall")
  @post
  ReimageAll is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Deallocates a specific virtual machine in a VM scale set. Shuts down the
virtual machine and releases the compute resources it uses. You are not billed
for the compute resources of this virtual machine once it is deallocated.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/deallocate")
  @post
  Deallocate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Updates a virtual machine of a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}")
  @put
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set where the extension should be create or updated.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Virtual Machine Scale Sets VM operation.")
      @body
      parameters: VirtualMachineScaleSetVM;
    },
    VirtualMachineScaleSetVM
  >;

  @doc("Deletes a virtual machine from a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Optional parameter to force delete a virtual machine from a VM scale set.
(Feature in Preview)
""")
      @query
      forceDeletion: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a virtual machine from a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' will retrieve
the instance view of the virtual machine. 'UserData' will retrieve the UserData
of the virtual machine.
""")
      @query
      $expand: InstanceViewTypes;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetVM
  >;

  @doc("Gets the status of a virtual machine from a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/instanceView")
  @get
  GetInstanceView is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetVMInstanceView
  >;

  @doc("Gets a list of all virtual machines in a VM scale sets.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      virtualMachineScaleSetName: string;

      @doc("""
The filter to apply to the operation. Allowed values are
'startswith(instanceView/statuses/code, 'PowerState') eq true',
'properties/latestModelApplied eq true', 'properties/latestModelApplied eq
false'.
""")
      @query
      $filter: string;

      @doc("The list parameters. Allowed values are 'instanceView', 'instanceView/statuses'.")
      @query
      $select: string;

      @doc("""
The expand expression to apply to the operation. Allowed values are
'instanceView'.
""")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetVMListResult
  >;

  @doc("""
Power off (stop) a virtual machine in a VM scale set. Note that resources are
still attached and you are getting charged for the resources. Instead, use
deallocate to release resources and avoid charges.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff")
  @post
  PowerOff is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
The parameter to request non-graceful VM shutdown. True value for this flag
indicates non-graceful shutdown whereas false indicates otherwise. Default
value for this flag is false if not specified
""")
      @query
      skipShutdown: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Restarts a virtual machine in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart")
  @post
  Restart is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Starts a virtual machine in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start")
  @post
  Start is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Shuts down the virtual machine in the virtual machine scale set, moves it to a
new node, and powers it back on.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy")
  @post
  Redeploy is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
The operation to retrieve SAS URIs of boot diagnostic logs for a virtual
machine in a VM scale set.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/retrieveBootDiagnosticsData")
  @post
  RetrieveBootDiagnosticsData is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Expiration duration in minutes for the SAS URIs with a value between 1 to 1440
minutes. <br><br>NOTE: If not specified, SAS URIs will be generated with a
default expiration duration of 120 minutes.
""")
      @query
      sasUriExpirationTimeInMinutes: int32;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    RetrieveBootDiagnosticsDataResult
  >;

  @doc("Performs maintenance on a virtual machine in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance")
  @post
  PerformMaintenance is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
The operation to simulate the eviction of spot virtual machine in a VM scale
set.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/simulateEviction")
  @post
  SimulateEviction is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Run command on a virtual machine in a VM scale set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/runCommand")
  @post
  RunCommand is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Run command operation.")
      @body
      parameters: RunCommandInput;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    RunCommandResult | void
  >;
}

interface VirtualMachineExtensionsOperations {
  @doc("The operation to create or update the extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
The name of the virtual machine where the extension should be created or
updated.
""")
      @path
      vmName: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Virtual Machine Extension operation.")
      @body
      extensionParameters: VirtualMachineExtension;
    },
    VirtualMachineExtension
  >;

  @doc("The operation to update the extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine where the extension should be updated.")
      @path
      vmName: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Virtual Machine Extension operation.")
      @body
      extensionParameters: VirtualMachineExtensionUpdate;
    },
    VirtualMachineExtension
  >;

  @doc("The operation to delete the extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine where the extension should be deleted.")
      @path
      vmName: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to get the extension.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine containing the extension.")
      @path
      vmName: string;

      @doc("The name of the virtual machine extension.")
      @path
      vmExtensionName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineExtension
  >;

  @doc("The operation to get all extensions of a Virtual Machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine containing the extension.")
      @path
      vmName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineExtensionsListResult
  >;
}

interface VirtualMachinesOperations {
  @doc("""
Gets all the virtual machines under the specified subscription for the
specified location.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines")
  @get
  ListByLocation is Azure.Core.Foundations.Operation<
    {
      @doc("The location for which virtual machines under the subscription are queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineListResult
  >;

  @doc("""
Captures the VM by copying virtual hard disks of the VM and outputs a template
that can be used to create similar VMs.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture")
  @post
  Capture is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Capture Virtual Machine operation.")
      @body
      parameters: VirtualMachineCaptureParameters;
    },
    VirtualMachineCaptureResult | void
  >;

  @doc("""
The operation to create or update a virtual machine. Please note some
properties can be set only during virtual machine creation.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Virtual Machine operation.")
      @body
      parameters: VirtualMachine;
    },
    VirtualMachine
  >;

  @doc("The operation to update a virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Virtual Machine operation.")
      @body
      parameters: VirtualMachineUpdate;
    },
    VirtualMachine
  >;

  @doc("The operation to delete a virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("Optional parameter to force delete virtual machines.")
      @query
      forceDeletion: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Retrieves information about the model view or the instance view of a virtual
machine.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' retrieves a
snapshot of the runtime properties of the virtual machine that is managed by
the platform and can change outside of control plane operations. 'UserData'
retrieves the UserData property as part of the VM model view that was provided
by the user during the VM Create/Update operation.
""")
      @query
      $expand: InstanceViewTypes;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachine
  >;

  @doc("Retrieves information about the run-time state of a virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView")
  @get
  InstanceView is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineInstanceView
  >;

  @doc("""
Converts virtual machine disks from blob-based to managed disks. Virtual
machine must be stop-deallocated before invoking this operation.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks")
  @post
  ConvertToManagedDisks is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Shuts down the virtual machine and releases the compute resources. You are not
billed for the compute resources that this virtual machine uses.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate")
  @post
  Deallocate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("Optional parameter to hibernate a virtual machine. (Feature in Preview)")
      @query
      hibernate: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Sets the OS state of the virtual machine to generalized. It is recommended to
sysprep the virtual machine before performing this operation. <br>For Windows,
please refer to [Create a managed image of a generalized VM in
Azure](https://docs.microsoft.com/azure/virtual-machines/windows/capture-image-resource).<br>For
Linux, please refer to [How to create an image of a virtual machine or
VHD](https://docs.microsoft.com/azure/virtual-machines/linux/capture-image).
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize")
  @post
  Generalize is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Lists all of the virtual machines in the specified resource group. Use the
nextLink property in the response to get the next page of virtual machines.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
The system query option to filter VMs returned in the response. Allowed value
is 'virtualMachineScaleSet/id' eq
/subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmssName}'
""")
      @query
      $filter: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineListResult
  >;

  @doc("""
Lists all of the virtual machines in the specified subscription. Use the
nextLink property in the response to get the next page of virtual machines.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines")
  @get
  ListAll is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("""
statusOnly=true enables fetching run time status of all Virtual Machines in the
subscription.
""")
      @query
      statusOnly: string;

      @doc("""
The system query option to filter VMs returned in the response. Allowed value
is 'virtualMachineScaleSet/id' eq
/subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmssName}'
""")
      @query
      $filter: string;
    },
    VirtualMachineListResult
  >;

  @doc("""
Lists all available virtual machine sizes to which the specified virtual
machine can be resized.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes")
  @get
  ListAvailableSizes is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;

  @doc("""
The operation to power off (stop) a virtual machine. The virtual machine can be
restarted with the same provisioned resources. You are still charged for this
virtual machine.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff")
  @post
  PowerOff is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
The parameter to request non-graceful VM shutdown. True value for this flag
indicates non-graceful shutdown whereas false indicates otherwise. Default
value for this flag is false if not specified
""")
      @query
      skipShutdown: boolean;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to reapply a virtual machine's state.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/reapply")
  @post
  Reapply is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to restart a virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart")
  @post
  Restart is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to start a virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start")
  @post
  Start is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Shuts down the virtual machine, moves it to a new node, and powers it back on.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy")
  @post
  Redeploy is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Reimages the virtual machine which has an ephemeral OS disk back to its initial
state.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/reimage")
  @post
  Reimage is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Reimage Virtual Machine operation.")
      @body
      parameters: VirtualMachineReimageParameters;
    },
    void
  >;

  @doc("The operation to retrieve SAS URIs for a virtual machine's boot diagnostic logs.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/retrieveBootDiagnosticsData")
  @post
  RetrieveBootDiagnosticsData is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Expiration duration in minutes for the SAS URIs with a value between 1 to 1440
minutes. <br><br>NOTE: If not specified, SAS URIs will be generated with a
default expiration duration of 120 minutes.
""")
      @query
      sasUriExpirationTimeInMinutes: int32;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    RetrieveBootDiagnosticsDataResult
  >;

  @doc("The operation to perform maintenance on a virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance")
  @post
  PerformMaintenance is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation to simulate the eviction of spot virtual machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/simulateEviction")
  @post
  SimulateEviction is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Assess patches on the VM.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/assessPatches")
  @post
  AssessPatches is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineAssessPatchesResult | void
  >;

  @doc("Installs patches on the VM.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/installPatches")
  @post
  InstallPatches is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Input for InstallPatches as directly received by the API")
      @body
      installPatchesInput: VirtualMachineInstallPatchesParameters;
    },
    VirtualMachineInstallPatchesResult | void
  >;

  @doc("Run command on the VM.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/runCommand")
  @post
  RunCommand is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine.")
      @path
      vmName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Run command operation.")
      @body
      parameters: RunCommandInput;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    RunCommandResult | void
  >;
}

interface VirtualMachineImagesOperations {
  @doc("Gets a virtual machine image.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("A valid image SKU version.")
      @path
      version: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineImage
  >;

  @doc("""
Gets a list of all virtual machine image versions for the specified location,
publisher, offer, and SKU.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;
      @query $top: int32;
      @query $orderby: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Gets a list of virtual machine image offers for the specified location and
publisher.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  ListOffers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Gets a list of virtual machine image publishers for the specified Azure
location.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers")
  @get
  ListPublishers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Gets a list of virtual machine image SKUs for the specified location,
publisher, and offer.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  ListSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of all virtual machine image versions for the specified edge zone")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/vmimages")
  @get
  ListByEdgeZone is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VmImagesInEdgeZoneListResult
  >;
}

interface VirtualMachineImagesEdgeZoneOperations {
  @doc("Gets a virtual machine image in an edge zone.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("A valid image SKU version.")
      @path
      version: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineImage
  >;

  @doc("""
Gets a list of all virtual machine image versions for the specified location,
edge zone, publisher, offer, and SKU.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("A valid image SKU.")
      @path
      skus: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
An integer value specifying the number of images to return that matches
supplied values.
""")
      @query
      $top: int32;

      @doc("Specifies the order of the results returned. Formatted as an OData query.")
      @query
      $orderby: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Gets a list of virtual machine image offers for the specified location, edge
zone and publisher.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers")
  @get
  ListOffers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Gets a list of virtual machine image publishers for the specified Azure
location and edge zone.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers")
  @get
  ListPublishers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("""
Gets a list of virtual machine image SKUs for the specified location, edge
zone, publisher, and offer.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/edgeZones/{edgeZone}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus")
  @get
  ListSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @doc("The name of the edge zone.")
      @path
      edgeZone: string;

      @doc("A valid image publisher.")
      @path
      publisherName: string;

      @doc("A valid image publisher offer.")
      @path
      offer: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface VirtualMachineExtensionImagesOperations {
  @doc("Gets a virtual machine extension image.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;
      @path publisherName: string;
      @path type: string;
      @path version: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineExtensionImage
  >;

  @doc("Gets a list of virtual machine extension image types.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types")
  @get
  ListTypes is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;
      @path publisherName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets a list of virtual machine extension image versions.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions")
  @get
  ListVersions is Azure.Core.Foundations.Operation<
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;
      @path publisherName: string;
      @path type: string;

      @doc("The filter to apply on the operation.")
      @query
      $filter: string;
      @query $top: int32;
      @query $orderby: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface AvailabilitySetsOperations {
  @doc("Create or update an availability set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the availability set.")
      @path
      availabilitySetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Availability Set operation.")
      @body
      parameters: AvailabilitySet;
    },
    AvailabilitySet
  >;

  @doc("Update an availability set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the availability set.")
      @path
      availabilitySetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Availability Set operation.")
      @body
      parameters: AvailabilitySetUpdate;
    },
    AvailabilitySet
  >;

  @doc("Delete an availability set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the availability set.")
      @path
      availabilitySetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Retrieves information about an availability set.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the availability set.")
      @path
      availabilitySetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    AvailabilitySet
  >;

  @doc("Lists all availability sets in a subscription.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/availabilitySets")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("""
The expand expression to apply to the operation. Allowed values are
'instanceView'.
""")
      @query
      $expand: string;
    },
    AvailabilitySetListResult
  >;

  @doc("Lists all availability sets in a resource group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    AvailabilitySetListResult
  >;

  @doc("""
Lists all available virtual machine sizes that can be used to create a new
virtual machine in an existing availability set.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes")
  @get
  ListAvailableSizes is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the availability set.")
      @path
      availabilitySetName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    VirtualMachineSizeListResult
  >;
}

interface ProximityPlacementGroupsOperations {
  @doc("Create or update a proximity placement group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the proximity placement group.")
      @path
      proximityPlacementGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Proximity Placement Group operation.")
      @body
      parameters: ProximityPlacementGroup;
    },
    ProximityPlacementGroup
  >;

  @doc("Update a proximity placement group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the proximity placement group.")
      @path
      proximityPlacementGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Proximity Placement Group operation.")
      @body
      parameters: ProximityPlacementGroupUpdate;
    },
    ProximityPlacementGroup
  >;

  @doc("Delete a proximity placement group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the proximity placement group.")
      @path
      proximityPlacementGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Retrieves information about a proximity placement group .")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the proximity placement group.")
      @path
      proximityPlacementGroupName: string;

      @doc("""
includeColocationStatus=true enables fetching the colocation status of all the
resources in the proximity placement group.
""")
      @query
      includeColocationStatus: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    ProximityPlacementGroup
  >;

  @doc("Lists all proximity placement groups in a subscription.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/proximityPlacementGroups")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    ProximityPlacementGroupListResult
  >;

  @doc("Lists all proximity placement groups in a resource group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups")
  @get
  ListByResourceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    ProximityPlacementGroupListResult
  >;
}

interface DedicatedHostGroupsOperations {
  @doc("""
Create or update a dedicated host group. For details of Dedicated Host and
Dedicated Host Groups please see [Dedicated Host Documentation]
(https://go.microsoft.com/fwlink/?linkid=2082596)
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Dedicated Host Group.")
      @body
      parameters: DedicatedHostGroup;
    },
    DedicatedHostGroup
  >;

  @doc("Update an dedicated host group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Dedicated Host Group operation.")
      @body
      parameters: DedicatedHostGroupUpdate;
    },
    DedicatedHostGroup
  >;

  @doc("Delete a dedicated host group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Retrieves information about a dedicated host group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' will retrieve
the list of instance views of the dedicated hosts under the dedicated host
group. 'UserData' is not supported for dedicated host group.
""")
      @query
      $expand: InstanceViewTypes;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    DedicatedHostGroup
  >;

  @doc("""
Lists all of the dedicated host groups in the specified resource group. Use the
nextLink property in the response to get the next page of dedicated host
groups.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups")
  @get
  ListByResourceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    DedicatedHostGroupListResult
  >;

  @doc("""
Lists all of the dedicated host groups in the subscription. Use the nextLink
property in the response to get the next page of dedicated host groups.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/hostGroups")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    DedicatedHostGroupListResult
  >;
}

interface DedicatedHostsOperations {
  @doc("Create or update a dedicated host .")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("The name of the dedicated host .")
      @path
      hostName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Dedicated Host.")
      @body
      parameters: DedicatedHost;
    },
    DedicatedHost
  >;

  @doc("Update an dedicated host .")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("The name of the dedicated host .")
      @path
      hostName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Dedicated Host operation.")
      @body
      parameters: DedicatedHostUpdate;
    },
    DedicatedHost
  >;

  @doc("Delete a dedicated host.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("The name of the dedicated host.")
      @path
      hostName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Retrieves information about a dedicated host.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("The name of the dedicated host.")
      @path
      hostName: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' will retrieve
the list of instance views of the dedicated host. 'UserData' is not supported
for dedicated host.
""")
      @query
      $expand: InstanceViewTypes;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    DedicatedHost
  >;

  @doc("""
Lists all of the dedicated hosts in the specified dedicated host group. Use the
nextLink property in the response to get the next page of dedicated hosts.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts")
  @get
  ListByHostGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    DedicatedHostListResult
  >;

  @doc("""
Restart the dedicated host. The operation will complete successfully once the
dedicated host has restarted and is running. To determine the health of VMs
deployed on the dedicated host after the restart check the Resource Health
Center in the Azure Portal. Please refer to
https://docs.microsoft.com/azure/service-health/resource-health-overview for
more details.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}/restart")
  @post
  Restart is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the dedicated host group.")
      @path
      hostGroupName: string;

      @doc("The name of the dedicated host.")
      @path
      hostName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;
}

interface SshPublicKeysOperations {
  @doc("""
Lists all of the SSH public keys in the subscription. Use the nextLink property
in the response to get the next page of SSH public keys.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/sshPublicKeys")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    SshPublicKeysGroupListResult
  >;

  @doc("""
Lists all of the SSH public keys in the specified resource group. Use the
nextLink property in the response to get the next page of SSH public keys.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/sshPublicKeys")
  @get
  ListByResourceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    SshPublicKeysGroupListResult
  >;

  @doc("Creates a new SSH public key resource.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{sshPublicKeyName}")
  @put
  Create is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the SSH public key.")
      @path
      sshPublicKeyName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to create the SSH public key.")
      @body
      parameters: SshPublicKeyResource;
    },
    SshPublicKeyResource
  >;

  @doc("Updates a new SSH public key resource.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{sshPublicKeyName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the SSH public key.")
      @path
      sshPublicKeyName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to update the SSH public key.")
      @body
      parameters: SshPublicKeyUpdateResource;
    },
    SshPublicKeyResource
  >;

  @doc("Delete an SSH public key.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{sshPublicKeyName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the SSH public key.")
      @path
      sshPublicKeyName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Retrieves information about an SSH public key.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{sshPublicKeyName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the SSH public key.")
      @path
      sshPublicKeyName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    SshPublicKeyResource
  >;

  @doc("""
Generates and returns a public/private key pair and populates the SSH public
key resource with the public key. The length of the key will be 3072 bits. This
operation can only be performed once per SSH public key resource.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/sshPublicKeys/{sshPublicKeyName}/generateKeyPair")
  @post
  GenerateKeyPair is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the SSH public key.")
      @path
      sshPublicKeyName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    SshPublicKeyGenerateKeyPairResult
  >;
}

interface ImagesOperations {
  @doc("Create or update an image.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the image.")
      @path
      imageName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Image operation.")
      @body
      parameters: Image;
    },
    Image
  >;

  @doc("Update an image.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the image.")
      @path
      imageName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Image operation.")
      @body
      parameters: ImageUpdate;
    },
    Image
  >;

  @doc("Deletes an Image.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the image.")
      @path
      imageName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("Gets an image.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the image.")
      @path
      imageName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    Image
  >;

  @doc("Gets the list of images under a resource group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images")
  @get
  ListByResourceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    ImageListResult
  >;

  @doc("""
Gets the list of Images in the subscription. Use nextLink property in the
response to get the next page of Images. Do this till nextLink is null to fetch
all the Images.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    ImageListResult
  >;
}

interface RestorePointCollectionsOperations {
  @doc("""
The operation to create or update the restore point collection. Please refer to
https://aka.ms/RestorePoints for more details. When updating a restore point
collection, only tags may be modified.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;

      @doc("Parameters supplied to the Create or Update restore point collection operation.")
      @body
      parameters: RestorePointCollection;
    },
    RestorePointCollection
  >;

  @doc("The operation to update the restore point collection.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;

      @doc("Parameters supplied to the Update restore point collection operation.")
      @body
      parameters: RestorePointCollectionUpdate;
    },
    RestorePointCollection
  >;

  @doc("""
The operation to delete the restore point collection. This operation will also
delete all the contained restore points.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the Restore Point Collection.")
      @path
      restorePointCollectionName: string;
    },
    void
  >;

  @doc("The operation to get the restore point collection.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;

      @doc("""
The expand expression to apply on the operation. If expand=restorePoints,
server will return all contained restore points in the restorePointCollection.
""")
      @query
      $expand: RestorePointCollectionExpandOptions;
    },
    RestorePointCollection
  >;

  @doc("Gets the list of restore point collections in a resource group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;
    },
    RestorePointCollectionListResult
  >;

  @doc("""
Gets the list of restore point collections in the subscription. Use nextLink
property in the response to get the next page of restore point collections. Do
this till nextLink is not null to fetch all the restore point collections.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/restorePointCollections")
  @get
  ListAll is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    RestorePointCollectionListResult
  >;
}

interface RestorePointsOperations {
  @doc("""
The operation to create the restore point. Updating properties of an existing
restore point is not allowed
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}/restorePoints/{restorePointName}")
  @put
  Create is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;

      @doc("The name of the restore point.")
      @path
      restorePointName: string;

      @doc("Parameters supplied to the Create restore point operation.")
      @body
      parameters: RestorePoint;
    },
    RestorePoint
  >;

  @doc("The operation to delete the restore point.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}/restorePoints/{restorePointName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the Restore Point Collection.")
      @path
      restorePointCollectionName: string;

      @doc("The name of the restore point.")
      @path
      restorePointName: string;
    },
    void
  >;

  @doc("The operation to get the restore point.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/restorePointCollections/{restorePointCollectionName}/restorePoints/{restorePointName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;

      @doc("The name of the restore point.")
      @path
      restorePointName: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' retrieves
information about the run-time state of a restore point.
""")
      @query
      $expand: RestorePointExpandOptions;
    },
    RestorePoint
  >;
}

interface CapacityReservationGroupsOperations {
  @doc("""
The operation to create or update a capacity reservation group. When updating a
capacity reservation group, only tags may be modified. Please refer to
https://aka.ms/CapacityReservation for more details.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create capacity reservation Group.")
      @body
      parameters: CapacityReservationGroup;
    },
    CapacityReservationGroup
  >;

  @doc("""
The operation to update a capacity reservation group. When updating a capacity
reservation group, only tags may be modified.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update capacity reservation Group operation.")
      @body
      parameters: CapacityReservationGroupUpdate;
    },
    CapacityReservationGroup
  >;

  @doc("""
The operation to delete a capacity reservation group. This operation is allowed
only if all the associated resources are disassociated from the reservation
group and all capacity reservations under the reservation group have also been
deleted. Please refer to https://aka.ms/CapacityReservation for more details.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation that retrieves information about a capacity reservation group.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' will retrieve
the list of instance views of the capacity reservations under the capacity
reservation group which is a snapshot of the runtime properties of a capacity
reservation that is managed by the platform and can change outside of control
plane operations.
""")
      @query
      $expand: CapacityReservationGroupInstanceViewTypes;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    CapacityReservationGroup
  >;

  @doc("""
Lists all of the capacity reservation groups in the specified resource group.
Use the nextLink property in the response to get the next page of capacity
reservation groups.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups")
  @get
  ListByResourceGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("""
The expand expression to apply on the operation. Based on the expand param(s)
specified we return Virtual Machine or ScaleSet VM Instance or both resource
Ids which are associated to capacity reservation group in the response.
""")
      @query
      $expand: ExpandTypesForGetCapacityReservationGroups;
    },
    CapacityReservationGroupListResult
  >;

  @doc("""
Lists all of the capacity reservation groups in the subscription. Use the
nextLink property in the response to get the next page of capacity reservation
groups.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/capacityReservationGroups")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("""
The expand expression to apply on the operation. Based on the expand param(s)
specified we return Virtual Machine or ScaleSet VM Instance or both resource
Ids which are associated to capacity reservation group in the response.
""")
      @query
      $expand: ExpandTypesForGetCapacityReservationGroups;
    },
    CapacityReservationGroupListResult
  >;
}

interface CapacityReservationsOperations {
  @doc("""
The operation to create or update a capacity reservation. Please note some
properties can be set only during capacity reservation creation. Please refer
to https://aka.ms/CapacityReservation for more details.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}/capacityReservations/{capacityReservationName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("The name of the capacity reservation.")
      @path
      capacityReservationName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create capacity reservation.")
      @body
      parameters: CapacityReservation;
    },
    CapacityReservation
  >;

  @doc("The operation to update a capacity reservation.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}/capacityReservations/{capacityReservationName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("The name of the capacity reservation.")
      @path
      capacityReservationName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update capacity reservation operation.")
      @body
      parameters: CapacityReservationUpdate;
    },
    CapacityReservation | void
  >;

  @doc("""
The operation to delete a capacity reservation. This operation is allowed only
when all the associated resources are disassociated from the capacity
reservation. Please refer to https://aka.ms/CapacityReservation for more
details.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}/capacityReservations/{capacityReservationName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("The name of the capacity reservation.")
      @path
      capacityReservationName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    void
  >;

  @doc("The operation that retrieves information about the capacity reservation.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}/capacityReservations/{capacityReservationName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("The name of the capacity reservation.")
      @path
      capacityReservationName: string;

      @doc("""
The expand expression to apply on the operation. 'InstanceView' retrieves a
snapshot of the runtime properties of the capacity reservation that is managed
by the platform and can change outside of control plane operations.
""")
      @query
      $expand: CapacityReservationInstanceViewTypes;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    CapacityReservation
  >;

  @doc("""
Lists all of the capacity reservations in the specified capacity reservation
group. Use the nextLink property in the response to get the next page of
capacity reservations.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/capacityReservationGroups/{capacityReservationGroupName}/capacityReservations")
  @get
  ListByCapacityReservationGroup is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the capacity reservation group.")
      @path
      capacityReservationGroupName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;
    },
    CapacityReservationListResult
  >;
}

interface LogAnalyticsOperations {
  @doc("""
Export logs that show Api requests made by this subscription in the given time
window to show throttling activities.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval")
  @post
  ExportRequestRateByInterval is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the LogAnalytics getRequestRateByInterval Api.")
      @body
      parameters: RequestRateByIntervalInput;
    },
    LogAnalyticsOperationResult | void
  >;

  @doc("""
Export logs that show total throttled Api requests for this subscription in the
given time window.
""")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests")
  @post
  ExportThrottledRequests is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which virtual-machine-sizes is queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the LogAnalytics getThrottledRequests Api.")
      @body
      parameters: ThrottledRequestsInput;
    },
    LogAnalyticsOperationResult | void
  >;
}

interface VirtualMachineRunCommandsOperations {
  @doc("Lists all available run commands for a subscription in a location.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/runCommands")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which run commands is queried.")
      @path
      location: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    RunCommandListResult
  >;

  @doc("Gets specific run command for a subscription in a location.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/runCommands/{commandId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The location upon which run commands is queried.")
      @path
      location: string;

      @doc("The command id.")
      @path
      commandId: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    RunCommandDocument
  >;

  @doc("The operation to create or update the run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/runCommands/{runCommandName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("""
The name of the virtual machine where the run command should be created or
updated.
""")
      @path
      vmName: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Virtual Machine RunCommand operation.")
      @body
      runCommand: VirtualMachineRunCommand;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to update the run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/runCommands/{runCommandName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine where the run command should be updated.")
      @path
      vmName: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Virtual Machine RunCommand operation.")
      @body
      runCommand: VirtualMachineRunCommandUpdate;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to delete the run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/runCommands/{runCommandName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine where the run command should be deleted.")
      @path
      vmName: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    void
  >;

  @doc("The operation to get the run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/runCommands/{runCommandName}")
  @get
  GetByVirtualMachine is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine containing the run command.")
      @path
      vmName: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to get all run commands of a Virtual Machine.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/runCommands")
  @get
  ListByVirtualMachine is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the virtual machine containing the run command.")
      @path
      vmName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommandsListResult
  >;
}

interface VirtualMachineScaleSetVMRunCommandsOperations {
  @doc("The operation to create or update the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @put
  CreateOrUpdate is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Create Virtual Machine RunCommand operation.")
      @body
      runCommand: VirtualMachineRunCommand;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to update the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @patch
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Parameters supplied to the Update Virtual Machine RunCommand operation.")
      @body
      runCommand: VirtualMachineRunCommandUpdate;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("The operation to delete the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    void
  >;

  @doc("The operation to get the VMSS VM run command.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands/{runCommandName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The name of the virtual machine run command.")
      @path
      runCommandName: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommand
  >;

  @doc("""
The operation to get all run commands of an instance in Virtual Machine
Scaleset.
""")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/runCommands")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The instance ID of the virtual machine.")
      @path
      instanceId: string;

      @doc("The expand expression to apply on the operation.")
      @query
      $expand: string;

      @doc("""
Subscription credentials which uniquely identify Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.
""")
      @path
      subscriptionId: string;

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    VirtualMachineRunCommandsListResult
  >;
}
