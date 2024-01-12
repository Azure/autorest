import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Describes a virtual machine scale set virtual machine.")
@parentResource(VirtualMachineScaleSet)
model VirtualMachineScaleSetVM
  is TrackedResource<VirtualMachineScaleSetVMProperties> {
  @doc("The instance ID of the virtual machine.")
  @path
  @key("instanceId")
  @segment("virtualMachines")
  name: string;

  @doc("The virtual machine instance ID.")
  @visibility("read")
  instanceId?: string;

  @doc("The virtual machine child extension resources.")
  @visibility("read")
  resources?: VirtualMachineExtension[];

  @doc("The virtual machine zones.")
  @visibility("read")
  zones?: string[];

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourcePlan;
}

@armResourceOperations
interface VirtualMachineScaleSetVMS {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a virtual machine from a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_Get")
  get is ArmResourceRead<
    VirtualMachineScaleSetVM,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The expand expression to apply on the operation. 'InstanceView' will retrieve the instance view of the virtual machine. 'UserData' will retrieve the UserData of the virtual machine.")
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates a virtual machine of a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_Update")
  update is ArmResourceCreateOrUpdateAsync<
    VirtualMachineScaleSetVM,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set where the extension should be create or updated.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes a virtual machine from a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_Delete")
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSetVM,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("Optional parameter to force delete a virtual machine from a VM scale set. (Feature in Preview)")
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a list of all virtual machines in a VM scale sets.")
  @operationId("VirtualMachineScaleSetVMs_List")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVM,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The filter to apply to the operation. Allowed values are 'startswith(instanceView/statuses/code, 'PowerState') eq true', 'properties/latestModelApplied eq true', 'properties/latestModelApplied eq false'.")
      @query("$filter")
      $filter?: string;

      @doc("The list parameters. Allowed values are 'instanceView', 'instanceView/statuses'.")
      @query("$select")
      $select?: string;

      @doc("The expand expression to apply to the operation. Allowed values are 'instanceView'.")
      @query("$expand")
      $expand?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_Reimage")
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    VirtualMachineScaleSetVMReimageParameters,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.")
  @operationId("VirtualMachineScaleSetVMs_ReimageAll")
  reimageAll is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.")
  @operationId("VirtualMachineScaleSetVMs_Deallocate")
  deallocate is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.")
  @operationId("VirtualMachineScaleSetVMs_PowerOff")
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified")
      @query("skipShutdown")
      skipShutdown?: boolean;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Restarts a virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_Restart")
  restart is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Starts a virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_Start")
  start is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.")
  @operationId("VirtualMachineScaleSetVMs_Redeploy")
  redeploy is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to retrieve SAS URIs of boot diagnostic logs for a virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_RetrieveBootDiagnosticsData")
  retrieveBootDiagnosticsData is ArmResourceActionSync<
    VirtualMachineScaleSetVM,
    void,
    RetrieveBootDiagnosticsDataResult,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("Expiration duration in minutes for the SAS URIs with a value between 1 to 1440 minutes. **Note:** If not specified, SAS URIs will be generated with a default expiration duration of 120 minutes.")
      @query("sasUriExpirationTimeInMinutes")
      sasUriExpirationTimeInMinutes?: int32;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Performs maintenance on a virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_PerformMaintenance")
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to simulate the eviction of spot virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_SimulateEviction")
  simulateEviction is ArmResourceActionNoContentSync<
    VirtualMachineScaleSetVM,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Run command on a virtual machine in a VM scale set.")
  @operationId("VirtualMachineScaleSetVMs_RunCommand")
  runCommand is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    RunCommandInput,
    RunCommandResult,
    {
      ...BaseParameters<VirtualMachineScaleSetVM>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMs_GetInstanceView")
  @doc("Gets the status of a virtual machine from a VM scale set.")
  // FIXME: VirtualMachineScaleSetVMs_GetInstanceView could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualMachines/{instanceId}/instanceView")
  @get
  getInstanceView is Azure.Core.Foundations.Operation<
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

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetVMInstanceView
  >;
}

@@projectedName(VirtualMachineScaleSetVMS.update::parameters.resource,
  "json",
  "parameters"
);
@@extension(VirtualMachineScaleSetVMS.update::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachineScaleSetVMS.update::parameters.resource,
  "Parameters supplied to the Update Virtual Machine Scale Sets VM operation."
);
@@projectedName(VirtualMachineScaleSetVMS.reimage::parameters.body,
  "json",
  "vmScaleSetVMReimageInput"
);
@@extension(VirtualMachineScaleSetVMS.reimage::parameters.body,
  "x-ms-client-name",
  "vmScaleSetVMReimageInput"
);
@@doc(VirtualMachineScaleSetVMS.reimage::parameters.body,
  "Parameters for the Reimaging Virtual machine in ScaleSet."
);
@@projectedName(VirtualMachineScaleSetVMS.runCommand::parameters.body,
  "json",
  "parameters"
);
@@extension(VirtualMachineScaleSetVMS.runCommand::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachineScaleSetVMS.runCommand::parameters.body,
  "Parameters supplied to the Run command operation."
);
