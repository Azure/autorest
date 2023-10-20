import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a Virtual Machine Scale Set.")
model VirtualMachineScaleSet
  is TrackedResource<VirtualMachineScaleSetProperties> {
  @doc("The name of the VM scale set.")
  @path
  @key("vmScaleSetName")
  @segment("virtualMachineScaleSets")
  name: string;
}

@armResourceOperations
interface VirtualMachineScaleSets {
  @doc("Display information about a virtual machine scale set.")
  get is ArmResourceRead<VirtualMachineScaleSet>;
  @doc("Create or update a VM scale set.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<VirtualMachineScaleSet>;
  @doc("Update a VM scale set.")
  update is ArmResourcePatchAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetUpdateProperties
  >;
  @doc("Deletes a VM scale set.")
  delete is ArmResourceDeleteAsync<VirtualMachineScaleSet>;
  @doc("Gets a list of all VM scale sets under a resource group.")
  list is ArmResourceListByParent<VirtualMachineScaleSet>;
  @doc("""
Gets all the VM scale sets under the specified subscription for the specified
location.
""")
  listByLocation is ArmResourceListAtScope<
    VirtualMachineScaleSet,
    LocationScope<VirtualMachineScaleSet>
  >;
  @doc("""
Gets a list of all VM Scale Sets in the subscription, regardless of the
associated resource group. Use nextLink property in the response to get the
next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM
Scale Sets.
""")
  listAll is ArmListBySubscription<VirtualMachineScaleSet>;
  @doc("""
Deallocates specific virtual machines in a VM scale set. Shuts down the virtual
machines and releases the compute resources. You are not billed for the compute
resources that this virtual machine scale set deallocates.
""")
  deallocate is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      @doc("""
Optional parameter to hibernate a virtual machine from the VM scale set. (This
feature is available for VMSS with Flexible OrchestrationMode only)
""")
      @query("hibernate")
      hibernate?: boolean;
      ...VirtualMachineScaleSetVMInstanceIDs;
    },
    {}
  >;
  @doc("Deletes virtual machines in a VM scale set.")
  deleteInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      @doc("""
Optional parameter to force delete virtual machines from the VM scale set.
(Feature in Preview)
""")
      @query("forceDeletion")
      forceDeletion?: boolean;
      ...VirtualMachineScaleSetVMInstanceRequiredIDs;
    },
    {}
  >;
  @doc("""
Power off (stop) one or more virtual machines in a VM scale set. Note that
resources are still attached and you are getting charged for the resources.
Instead, use deallocate to release resources and avoid charges.
""")
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      @doc("""
The parameter to request non-graceful VM shutdown. True value for this flag
indicates non-graceful shutdown whereas false indicates otherwise. Default
value for this flag is false if not specified
""")
      @query("skipShutdown")
      skipShutdown?: boolean;
      ...VirtualMachineScaleSetVMInstanceIDs;
    },
    {}
  >;
  @doc("Restarts one or more virtual machines in a VM scale set.")
  restart is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    {}
  >;
  @doc("Starts one or more virtual machines in a VM scale set.")
  start is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    {}
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Reapplies the Virtual Machine Scale Set Virtual Machine Profile to the Virtual
Machine Instances
""")
  reapply is ArmResourceActionAsync<VirtualMachineScaleSet, {}, {}>;
  @doc("""
Shuts down all the virtual machines in the virtual machine scale set, moves
them to a new node, and powers them back on.
""")
  redeploy is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    {}
  >;
  @doc("""
Perform maintenance on one or more virtual machines in a VM scale set.
Operation on instances which are not eligible for perform maintenance will be
failed. Please refer to best practices for more details:
https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
""")
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    {}
  >;
  @doc("""
Upgrades one or more virtual machines to the latest SKU set in the VM scale set
model.
""")
  updateInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    {}
  >;
  @doc("""
Reimages (upgrade the operating system) one or more virtual machines in a VM
scale set which don't have a ephemeral OS disk, for virtual machines who have a
ephemeral OS disk the virtual machine is reset to initial state.
""")
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetReimageParameters,
    {}
  >;
  @doc("""
Reimages all the disks ( including data disks ) in the virtual machines in a VM
scale set. This operation is only supported for managed disks.
""")
  reimageAll is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    {}
  >;
  @doc("""
Manual platform update domain walk to update virtual machines in a service
fabric virtual machine scale set.
""")
  forceRecoveryServiceFabricPlatformUpdateDomainWalk is ArmResourceActionSync<
    VirtualMachineScaleSet,
    {
      @doc("The platform update domain for which a manual recovery walk is requested")
      @query("platformUpdateDomain")
      platformUpdateDomain: int32;

      @doc("""
The zone in which the manual recovery walk is requested for cross zone virtual
machine scale set
""")
      @query("zone")
      zone?: string;

      @doc("The placement group id for which the manual recovery walk is requested.")
      @query("placementGroupId")
      placementGroupId?: string;
    },
    RecoveryWalkResponse
  >;
  @doc("""
Converts SinglePlacementGroup property to false for a existing virtual machine
scale set.
""")
  convertToSinglePlacementGroup is ArmResourceActionSync<
    VirtualMachineScaleSet,
    VMScaleSetConvertToSinglePlacementGroupInput,
    {}
  >;
  @doc("Changes ServiceState property for a given service")
  setOrchestrationServiceState is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    OrchestrationServiceStateInput,
    {}
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Cancels the current virtual machine scale set rolling upgrade.")
  cancel is ArmResourceActionAsync<VirtualMachineScaleSet, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Starts a rolling upgrade to move all virtual machine scale set instances to the
latest available Platform Image OS version. Instances which are already running
the latest available OS version are not affected.
""")
  startOSUpgrade is ArmResourceActionAsync<VirtualMachineScaleSet, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Starts a rolling upgrade to move all extensions for all virtual machine scale
set instances to the latest available extension version. Instances which are
already running the latest extension versions are not affected.
""")
  startExtensionUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {},
    {}
  >;
}
