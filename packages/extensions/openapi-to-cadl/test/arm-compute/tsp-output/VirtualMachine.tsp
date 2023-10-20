import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a Virtual Machine.")
model VirtualMachine is TrackedResource<VirtualMachineProperties> {
  @doc("The name of the virtual machine.")
  @path
  @key("vmName")
  @segment("virtualMachines")
  name: string;
}

@armResourceOperations
interface VirtualMachines {
  @doc("""
Retrieves information about the model view or the instance view of a virtual
machine.
""")
  get is ArmResourceRead<VirtualMachine>;
  @doc("""
The operation to create or update a virtual machine. Please note some
properties can be set only during virtual machine creation.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<VirtualMachine>;
  @doc("The operation to update a virtual machine.")
  update is ArmResourcePatchAsync<VirtualMachine, VirtualMachineProperties>;
  @doc("The operation to delete a virtual machine.")
  delete is ArmResourceDeleteAsync<VirtualMachine>;
  @doc("""
Lists all of the virtual machines in the specified resource group. Use the
nextLink property in the response to get the next page of virtual machines.
""")
  list is ArmResourceListByParent<
    VirtualMachine,
    {
      @doc("""
The system query option to filter VMs returned in the response. Allowed value
is 'virtualMachineScaleSet/id' eq
/subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmssName}'
""")
      @query("$filter")
      $filter?: string;

      @doc("""
The expand expression to apply on operation. 'instanceView' enables fetching
run time status of all Virtual Machines, this can only be specified if a valid
$filter option is specified
""")
      @query("$expand")
      $expand?: ExpandTypeForListVMs;
    }
  >;
  @doc("""
Gets all the virtual machines under the specified subscription for the
specified location.
""")
  listByLocation is ArmResourceListAtScope<
    VirtualMachine,
    LocationScope<VirtualMachine>
  >;
  @doc("""
Lists all of the virtual machines in the specified subscription. Use the
nextLink property in the response to get the next page of virtual machines.
""")
  listAll is ArmListBySubscription<VirtualMachine>;
  @doc("""
Captures the VM by copying virtual hard disks of the VM and outputs a template
that can be used to create similar VMs.
""")
  capture is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineCaptureParameters,
    VirtualMachineCaptureResult
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Converts virtual machine disks from blob-based to managed disks. Virtual
machine must be stop-deallocated before invoking this operation.
""")
  convertToManagedDisks is ArmResourceActionAsync<VirtualMachine, {}, {}>;
  @doc("""
Shuts down the virtual machine and releases the compute resources. You are not
billed for the compute resources that this virtual machine uses.
""")
  deallocate is ArmResourceActionAsync<
    VirtualMachine,
    {
      @doc("Optional parameter to hibernate a virtual machine. (Feature in Preview)")
      @query("hibernate")
      hibernate?: boolean;
    },
    {}
  >;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("""
Sets the OS state of the virtual machine to generalized. It is recommended to
sysprep the virtual machine before performing this operation. For Windows,
please refer to [Create a managed image of a generalized VM in
Azure](https://docs.microsoft.com/azure/virtual-machines/windows/capture-image-resource).
For Linux, please refer to [How to create an image of a virtual machine or
VHD](https://docs.microsoft.com/azure/virtual-machines/linux/capture-image).
""")
  generalize is ArmResourceActionSync<VirtualMachine, {}, {}>;
  @doc("""
The operation to power off (stop) a virtual machine. The virtual machine can be
restarted with the same provisioned resources. You are still charged for this
virtual machine.
""")
  powerOff is ArmResourceActionAsync<
    VirtualMachine,
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
  @doc("The operation to reapply a virtual machine's state.")
  reapply is ArmResourceActionAsync<VirtualMachine, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("The operation to restart a virtual machine.")
  restart is ArmResourceActionAsync<VirtualMachine, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("The operation to start a virtual machine.")
  start is ArmResourceActionAsync<VirtualMachine, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Shuts down the virtual machine, moves it to a new node, and powers it back on.")
  redeploy is ArmResourceActionAsync<VirtualMachine, {}, {}>;
  @doc("""
Reimages (upgrade the operating system) a virtual machine which don't have a
ephemeral OS disk, for virtual machines who have a ephemeral OS disk the
virtual machine is reset to initial state. NOTE: The retaining of old OS disk
depends on the value of deleteOption of OS disk. If deleteOption is detach, the
old OS disk will be preserved after reimage. If deleteOption is delete, the old
OS disk will be deleted after reimage. The deleteOption of the OS disk should
be updated accordingly before performing the reimage.
""")
  reimage is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineReimageParameters,
    {}
  >;
  @doc("The operation to retrieve SAS URIs for a virtual machine's boot diagnostic logs.")
  retrieveBootDiagnosticsData is ArmResourceActionSync<
    VirtualMachine,
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
  @doc("The operation to perform maintenance on a virtual machine.")
  performMaintenance is ArmResourceActionAsync<VirtualMachine, {}, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("The operation to simulate the eviction of spot virtual machine.")
  simulateEviction is ArmResourceActionNoContentSync<VirtualMachine, {}>;
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Assess patches on the VM.")
  assessPatches is ArmResourceActionAsync<
    VirtualMachine,
    {},
    VirtualMachineAssessPatchesResult
  >;
  @doc("Installs patches on the VM.")
  installPatches is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineInstallPatchesParameters,
    VirtualMachineInstallPatchesResult
  >;
  @doc("Run command on the VM.")
  runCommand is ArmResourceActionAsync<
    VirtualMachine,
    RunCommandInput,
    RunCommandResult
  >;
}
