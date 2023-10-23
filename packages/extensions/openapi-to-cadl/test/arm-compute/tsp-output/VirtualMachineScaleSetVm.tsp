import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a virtual machine scale set virtual machine.")
@parentResource(VirtualMachineScaleSet)
model VirtualMachineScaleSetVm
  is TrackedResource<VirtualMachineScaleSetVMProperties> {
  @doc("The instance ID of the virtual machine.")
  @path
  @key("instanceId")
  @segment("virtualMachines")
  name: string;
}

@armResourceOperations
interface VirtualMachineScaleSetVms {
  @doc("Gets a virtual machine from a VM scale set.")
  get is ArmResourceRead<VirtualMachineScaleSetVm>;
  @doc("Updates a virtual machine of a VM scale set.")
  update is ArmResourceCreateOrUpdateAsync<VirtualMachineScaleSetVm>;
  @doc("Deletes a virtual machine from a VM scale set.")
  delete is ArmResourceDeleteAsync<VirtualMachineScaleSetVm>;
  @doc("Gets a list of all virtual machines in a VM scale sets.")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVm,
    {
      @doc("The name of the VM scale set.")
      @path
      virtualMachineScaleSetName: string;

      @doc("""
The filter to apply to the operation. Allowed values are
'startswith(instanceView/statuses/code, 'PowerState') eq true',
'properties/latestModelApplied eq true', 'properties/latestModelApplied eq
false'.
""")
      @query("$filter")
      $filter?: string;

      @doc("The list parameters. Allowed values are 'instanceView', 'instanceView/statuses'.")
      @query("$select")
      $select?: string;

      @doc("""
The expand expression to apply to the operation. Allowed values are
'instanceView'.
""")
      @query("$expand")
      $expand?: string;
    }
  >;
  @doc("""
Reimages (upgrade the operating system) a specific virtual machine in a VM
scale set.
""")
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSetVm,
    VirtualMachineScaleSetVMReimageParameters,
    {}
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Allows you to re-image all the disks ( including data disks ) in the a VM scale
set instance. This operation is only supported for managed disks.
""")
  reimageAll is ArmResourceActionAsync<VirtualMachineScaleSetVm, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Deallocates a specific virtual machine in a VM scale set. Shuts down the
virtual machine and releases the compute resources it uses. You are not billed
for the compute resources of this virtual machine once it is deallocated.
""")
  deallocate is ArmResourceActionAsync<VirtualMachineScaleSetVm, {}, {}>;
  @doc("""
Power off (stop) a virtual machine in a VM scale set. Note that resources are
still attached and you are getting charged for the resources. Instead, use
deallocate to release resources and avoid charges.
""")
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSetVm,
    {
      @doc("""
The parameter to request non-graceful VM shutdown. True value for this flag
indicates non-graceful shutdown whereas false indicates otherwise. Default
value for this flag is false if not specified
""")
      @query("skipShutdown")
      skipShutdown?: boolean;
    },
    {}
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Restarts a virtual machine in a VM scale set.")
  restart is ArmResourceActionAsync<VirtualMachineScaleSetVm, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Starts a virtual machine in a VM scale set.")
  start is ArmResourceActionAsync<VirtualMachineScaleSetVm, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Shuts down the virtual machine in the virtual machine scale set, moves it to a
new node, and powers it back on.
""")
  redeploy is ArmResourceActionAsync<VirtualMachineScaleSetVm, {}, {}>;
  @doc("""
The operation to retrieve SAS URIs of boot diagnostic logs for a virtual
machine in a VM scale set.
""")
  retrieveBootDiagnosticsData is ArmResourceActionSync<
    VirtualMachineScaleSetVm,
    {
      @doc("""
Expiration duration in minutes for the SAS URIs with a value between 1 to 1440
minutes. **Note:** If not specified, SAS URIs will be generated with a default
expiration duration of 120 minutes.
""")
      @query("sasUriExpirationTimeInMinutes")
      sasUriExpirationTimeInMinutes?: int32;
    },
    RetrieveBootDiagnosticsDataResult
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Performs maintenance on a virtual machine in a VM scale set.")
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSetVm,
    {},
    {}
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
The operation to simulate the eviction of spot virtual machine in a VM scale
set.
""")
  simulateEviction is ArmResourceActionNoContentSync<
    VirtualMachineScaleSetVm,
    {}
  >;
  @doc("Run command on a virtual machine in a VM scale set.")
  runCommand is ArmResourceActionAsync<
    VirtualMachineScaleSetVm,
    RunCommandInput,
    RunCommandResult
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
}
