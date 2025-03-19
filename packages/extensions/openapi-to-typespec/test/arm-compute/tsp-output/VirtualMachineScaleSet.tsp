import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a Virtual Machine Scale Set.
 */
model VirtualMachineScaleSet
  is Azure.ResourceManager.TrackedResource<VirtualMachineScaleSetProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachineScaleSet,
    KeyName = "vmScaleSetName",
    SegmentName = "virtualMachineScaleSets",
    NamePattern = ""
  >;

  /**
   * The virtual machine scale set sku.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku?: Sku;

  /**
   * Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.  In the Azure portal, find the marketplace image that you want to use and then click **Want to deploy programmatically, Get Started ->**. Enter any required information and then click **Save**.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  plan?: Plan;

  /**
   * The identity of the virtual machine scale set, if configured.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: VirtualMachineScaleSetIdentity;

  ...Azure.ResourceManager.AvailabilityZonesProperty;

  /**
   * The extended location of the Virtual Machine Scale Set.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface VirtualMachineScaleSets {
  /**
   * Display information about a virtual machine scale set.
   */
  get is ArmResourceRead<
    VirtualMachineScaleSet,
    Parameters = {
      /**
       * The expand expression to apply on the operation. 'UserData' retrieves the UserData property of the VM scale set that was provided by the user during the VM scale set Create/Update operation
       */
      @query("$expand")
      $expand?: ExpandTypesForGetVMScaleSets;
    }
  >;

  /**
   * Create or update a VM scale set.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    VirtualMachineScaleSet,
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Update a VM scale set.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSet,
    PatchModel = VirtualMachineScaleSetUpdate,
    Response = ArmResponse<VirtualMachineScaleSet>
  >;

  /**
   * Deletes a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    VirtualMachineScaleSet,
    Parameters = {
      /**
       * Optional parameter to force delete a VM scale set. (Feature in Preview)
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    },
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Gets a list of all VM scale sets under a resource group.
   */
  list is ArmResourceListByParent<VirtualMachineScaleSet>;

  /**
   * Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
   */
  listAll is ArmListBySubscription<
    VirtualMachineScaleSet,
    Response = ArmResponse<VirtualMachineScaleSetListWithLinkResult>
  >;

  /**
   * Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
   */
  deallocate is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse,
    Parameters = {
      /**
       * Optional parameter to hibernate a virtual machine from the VM scale set. (This feature is available for VMSS with Flexible OrchestrationMode only)
       */
      @query("hibernate")
      hibernate?: boolean;
    }
  >;

  /**
   * Deletes virtual machines in a VM scale set.
   */
  @action("delete")
  deleteInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    OkResponse,
    Parameters = {
      /**
       * Optional parameter to force delete virtual machines from the VM scale set. (Feature in Preview)
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;

  /**
   * Gets the status of a VM scale set instance.
   */
  @get
  @action("instanceView")
  getInstanceView is ArmResourceActionSync<
    VirtualMachineScaleSet,
    void,
    ArmResponse<VirtualMachineScaleSetInstanceView>
  >;

  /**
   * Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
   */
  @get
  @action("skus")
  listSkus is ArmResourceActionSync<
    VirtualMachineScaleSet,
    void,
    ArmResponse<VirtualMachineScaleSetListSkusResult>
  >;

  /**
   * Gets list of OS upgrades on a VM scale set instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("osUpgradeHistory")
  @operationId("VirtualMachineScaleSets_GetOSUpgradeHistory")
  getOSUpgradeHistory is ArmResourceActionSync<
    VirtualMachineScaleSet,
    void,
    ArmResponse<VirtualMachineScaleSetListOSUpgradeHistory>
  >;

  /**
   * Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
   */
  @action("poweroff")
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse,
    Parameters = {
      /**
       * The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
       */
      @query("skipShutdown")
      skipShutdown?: boolean;
    }
  >;

  /**
   * Restarts one or more virtual machines in a VM scale set.
   */
  restart is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse
  >;

  /**
   * Starts one or more virtual machines in a VM scale set.
   */
  start is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse
  >;

  /**
   * Reapplies the Virtual Machine Scale Set Virtual Machine Profile to the Virtual Machine Instances
   */
  reapply is ArmResourceActionAsync<VirtualMachineScaleSet, void, OkResponse>;

  /**
   * Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
   */
  redeploy is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse
  >;

  /**
   * Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
   */
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse
  >;

  /**
   * Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
   */
  @action("manualupgrade")
  updateInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    OkResponse
  >;

  /**
   * Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
   */
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * Parameters for Reimaging VM ScaleSet.
       */
      @bodyRoot
      vmScaleSetReimageInput?: VirtualMachineScaleSetReimageParameters;
    },
    OkResponse
  >;

  /**
   * Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
   */
  @action("reimageall")
  reimageAll is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    {
      /**
       * A list of virtual machine instance IDs from the VM scale set.
       */
      @bodyRoot
      vmInstanceIDs?: VirtualMachineScaleSetVMInstanceIDs;
    },
    OkResponse
  >;

  /**
   * Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
   */
  forceRecoveryServiceFabricPlatformUpdateDomainWalk is ArmResourceActionSync<
    VirtualMachineScaleSet,
    void,
    ArmResponse<RecoveryWalkResponse>,
    Parameters = {
      /**
       * The platform update domain for which a manual recovery walk is requested
       */
      @query("platformUpdateDomain")
      platformUpdateDomain: int32;

      /**
       * The zone in which the manual recovery walk is requested for cross zone virtual machine scale set
       */
      @query("zone")
      zone?: string;

      /**
       * The placement group id for which the manual recovery walk is requested.
       */
      @query("placementGroupId")
      placementGroupId?: string;
    }
  >;

  /**
   * Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
   */
  convertToSinglePlacementGroup is ArmResourceActionSync<
    VirtualMachineScaleSet,
    VMScaleSetConvertToSinglePlacementGroupInput,
    OkResponse
  >;

  /**
   * Changes ServiceState property for a given service
   */
  setOrchestrationServiceState is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    OrchestrationServiceStateInput,
    OkResponse
  >;

  /**
   * Cancels the current virtual machine scale set rolling upgrade.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetRollingUpgrades_Cancel")
  cancel is ArmResourceActionAsync<VirtualMachineScaleSet, void, OkResponse>;

  /**
   * Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("osRollingUpgrade")
  @operationId("VirtualMachineScaleSetRollingUpgrades_StartOSUpgrade")
  startOSUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    OkResponse
  >;

  /**
   * Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("extensionRollingUpgrade")
  @operationId("VirtualMachineScaleSetRollingUpgrades_StartExtensionUpgrade")
  startExtensionUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    OkResponse
  >;
}

@@doc(VirtualMachineScaleSet.name, "The name of the VM scale set.");
@@doc(VirtualMachineScaleSet.properties,
  "Describes the properties of a Virtual Machine Scale Set."
);
@@doc(VirtualMachineScaleSets.createOrUpdate::parameters.resource,
  "The scale set object."
);
@@doc(VirtualMachineScaleSets.update::parameters.properties,
  "The scale set object."
);
@@doc(VirtualMachineScaleSets.deleteInstances::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@doc(VirtualMachineScaleSets.updateInstances::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@doc(VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body,
  "The input object for ConvertToSinglePlacementGroup API."
);
@@doc(VirtualMachineScaleSets.setOrchestrationServiceState::parameters.body,
  "The input object for SetOrchestrationServiceState API."
);
