import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Describes a Virtual Machine Scale Set.")
model VirtualMachineScaleSet
  is TrackedResource<VirtualMachineScaleSetProperties> {
  @doc("The name of the VM scale set.")
  @key("vmScaleSetName")
  @segment("virtualMachineScaleSets")
  name: string;

  @doc("The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set")
  zones?: string[];

  @doc("The extended location of the Virtual Machine Scale Set.")
  extendedLocation?: ExtendedLocation;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourcePlan;
}

@armResourceOperations
interface VirtualMachineScaleSets {
  @doc("Display information about a virtual machine scale set.")
  get is ArmResourceRead<
    VirtualMachineScaleSet,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The expand expression to apply on the operation. 'UserData' retrieves the UserData property of the VM scale set that was provided by the user during the VM scale set Create/Update operation")
      @query("$expand")
      $expand?: ExpandTypesForGetVMScaleSets;
    }
  >;
  @doc("Create or update a VM scale set.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    VirtualMachineScaleSet,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set to create or update.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Update a VM scale set.")
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetUpdate,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set to create or update.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Deletes a VM scale set.")
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSet,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("Optional parameter to force delete a VM scale set. (Feature in Preview)")
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;
  @doc("Gets a list of all VM scale sets under a resource group.")
  list is ArmResourceListByParent<VirtualMachineScaleSet>;
  @doc("Gets all the VM scale sets under the specified subscription for the specified location.")
  listByLocation is ArmResourceListAtScope<
    VirtualMachineScaleSet,
    LocationScope<VirtualMachineScaleSet>,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The location for which VM scale sets under the subscription are queried.")
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;
    }
  >;
  @doc("Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.")
  listAll is ArmListBySubscription<VirtualMachineScaleSet>;
  @doc("Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.")
  deallocate is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("Optional parameter to hibernate a virtual machine from the VM scale set. (This feature is available for VMSS with Flexible OrchestrationMode only)")
      @query("hibernate")
      hibernate?: boolean;
    }
  >;
  @doc("Deletes virtual machines in a VM scale set.")
  deleteInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("Optional parameter to force delete virtual machines from the VM scale set. (Feature in Preview)")
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;
  @doc("Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.")
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified")
      @query("skipShutdown")
      skipShutdown?: boolean;
    }
  >;
  @doc("Restarts one or more virtual machines in a VM scale set.")
  restart is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Starts one or more virtual machines in a VM scale set.")
  start is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Reapplies the Virtual Machine Scale Set Virtual Machine Profile to the Virtual Machine Instances")
  reapply is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.")
  redeploy is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications")
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.")
  updateInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.")
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetReimageParameters,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.")
  reimageAll is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.")
  forceRecoveryServiceFabricPlatformUpdateDomainWalk is ArmResourceActionSync<
    VirtualMachineScaleSet,
    void,
    RecoveryWalkResponse,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The platform update domain for which a manual recovery walk is requested")
      @query("platformUpdateDomain")
      platformUpdateDomain: int32;

      @doc("The zone in which the manual recovery walk is requested for cross zone virtual machine scale set")
      @query("zone")
      zone?: string;

      @doc("The placement group id for which the manual recovery walk is requested.")
      @query("placementGroupId")
      placementGroupId?: string;
    }
  >;
  @doc("Converts SinglePlacementGroup property to false for a existing virtual machine scale set.")
  convertToSinglePlacementGroup is ArmResourceActionSync<
    VirtualMachineScaleSet,
    VMScaleSetConvertToSinglePlacementGroupInput,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the virtual machine scale set to create or update.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Changes ServiceState property for a given service")
  setOrchestrationServiceState is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    OrchestrationServiceStateInput,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the virtual machine scale set to create or update.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Gets the status of a VM scale set instance.")
  // FIXME: VirtualMachineScaleSets_GetInstanceView could not be converted to a resource operation
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

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetInstanceView
  >;

  @doc("Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.")
  // FIXME: VirtualMachineScaleSets_ListSkus could not be converted to a resource operation
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

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListSkusResult
  >;

  @doc("Gets list of OS upgrades on a VM scale set instance.")
  // FIXME: VirtualMachineScaleSets_GetOSUpgradeHistory could not be converted to a resource operation
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

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    VirtualMachineScaleSetListOSUpgradeHistory
  >;
}

@armResourceOperations
@projectedName("client", "VirtualMachineScaleSetRollingUpgrades")
interface VirtualMachineScaleSets_VirtualMachineScaleSetRollingUpgrades {
  @doc("Cancels the current virtual machine scale set rolling upgrade.")
  cancel is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.")
  startOSUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
  @doc("Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.")
  startExtensionUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...BaseParameters<VirtualMachineScaleSet>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;
}
