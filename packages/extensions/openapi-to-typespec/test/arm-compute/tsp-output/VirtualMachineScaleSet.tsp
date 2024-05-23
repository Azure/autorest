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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model VirtualMachineScaleSet extends Resource {
  ...ResourceNameParameter<
    Resource = VirtualMachineScaleSet,
    KeyName = "vmScaleSetName",
    SegmentName = "virtualMachineScaleSets",
    NamePattern = ""
  >;

  /**
   * The virtual machine scale set sku.
   */
  sku?: Sku;

  /**
   * Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.  In the Azure portal, find the marketplace image that you want to use and then click **Want to deploy programmatically, Get Started ->**. Enter any required information and then click **Save**.
   */
  plan?: Plan;

  /**
   * The identity of the virtual machine scale set, if configured.
   */
  identity?: VirtualMachineScaleSetIdentity;

  /**
   * The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set
   */
  zones?: string[];

  /**
   * The extended location of the Virtual Machine Scale Set.
   */
  extendedLocation?: ExtendedLocation;

  /**
   * Describes the properties of a Virtual Machine Scale Set.
   */
  @extension("x-ms-client-flatten", true)
  properties?: VirtualMachineScaleSetProperties;
}

@armResourceOperations
interface VirtualMachineScaleSets {
  /**
   * Display information about a virtual machine scale set.
   */
  get is ArmResourceRead<
    VirtualMachineScaleSet,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

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
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set to create or update.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Update a VM scale set.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetUpdate,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set to create or update.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Deletes a VM scale set.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSet,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * Optional parameter to force delete a VM scale set. (Feature in Preview)
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;

  /**
   * Gets a list of all VM scale sets under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSets_List")
  list is ArmResourceListByParent<VirtualMachineScaleSet>;

  /**
   * Gets all the VM scale sets under the specified subscription for the specified location.
   */
  listByLocation is ArmResourceListAtScope<
    VirtualMachineScaleSet,
    LocationScope<VirtualMachineScaleSet>,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;
      ...LocationResourceParameter;
    }
  >;

  /**
   * Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
   */
  listAll is ArmListBySubscription<VirtualMachineScaleSet>;

  /**
   * Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
   */
  deallocate is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

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
  deleteInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * Optional parameter to force delete virtual machines from the VM scale set. (Feature in Preview)
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;

  /**
   * Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
   */
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

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
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Starts one or more virtual machines in a VM scale set.
   */
  start is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Reapplies the Virtual Machine Scale Set Virtual Machine Profile to the Virtual Machine Instances
   */
  reapply is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
   */
  redeploy is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
   */
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
   */
  updateInstances is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceRequiredIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
   */
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetReimageParameters,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
   */
  reimageAll is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    VirtualMachineScaleSetVMInstanceIDs,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
   */
  forceRecoveryServiceFabricPlatformUpdateDomainWalk is ArmResourceActionSync<
    VirtualMachineScaleSet,
    void,
    RecoveryWalkResponse,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

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
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the virtual machine scale set to create or update.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Changes ServiceState property for a given service
   */
  setOrchestrationServiceState is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    OrchestrationServiceStateInput,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the virtual machine scale set to create or update.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Cancels the current virtual machine scale set rolling upgrade.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetRollingUpgrades_Cancel")
  cancel is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetRollingUpgrades_StartOSUpgrade")
  startOSUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetRollingUpgrades_StartExtensionUpgrade")
  startExtensionUpgrade is ArmResourceActionAsync<
    VirtualMachineScaleSet,
    void,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSet>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * Gets the status of a VM scale set instance.
   */
  // FIXME: VirtualMachineScaleSets_GetInstanceView could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView")
  @get
  getInstanceView(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineScaleSetInstanceView> | ErrorResponse;

  /**
   * Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
   */
  // FIXME: VirtualMachineScaleSets_ListSkus could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus")
  @get
  listSkus(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineScaleSetListSkusResult> | ErrorResponse;

  /**
   * Gets list of OS upgrades on a VM scale set instance.
   */
  // FIXME: VirtualMachineScaleSets_GetOSUpgradeHistory could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSets_GetOSUpgradeHistory")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory")
  @get
  getOSUpgradeHistory(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the VM scale set.
     */
    @path
    vmScaleSetName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineScaleSetListOSUpgradeHistory> | ErrorResponse;
}

@@doc(VirtualMachineScaleSet.name, "The name of the VM scale set.");
@@encodedName(VirtualMachineScaleSets.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(VirtualMachineScaleSets.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachineScaleSets.createOrUpdate::parameters.resource,
  "The scale set object."
);
@@encodedName(VirtualMachineScaleSets.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(VirtualMachineScaleSets.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachineScaleSets.update::parameters.properties,
  "The scale set object."
);
@@encodedName(VirtualMachineScaleSets.deallocate::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.deallocate::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.deallocate::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.deleteInstances::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.deleteInstances::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.deleteInstances::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.powerOff::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.powerOff::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.powerOff::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.restart::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.restart::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.restart::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.start::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.start::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.start::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.redeploy::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.redeploy::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.redeploy::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.performMaintenance::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.performMaintenance::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.performMaintenance::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.updateInstances::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.updateInstances::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.updateInstances::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.reimage::parameters.body,
  "application/json",
  "vmScaleSetReimageInput"
);
@@extension(VirtualMachineScaleSets.reimage::parameters.body,
  "x-ms-client-name",
  "vmScaleSetReimageInput"
);
@@doc(VirtualMachineScaleSets.reimage::parameters.body,
  "Parameters for Reimaging VM ScaleSet."
);
@@encodedName(VirtualMachineScaleSets.reimageAll::parameters.body,
  "application/json",
  "vmInstanceIDs"
);
@@extension(VirtualMachineScaleSets.reimageAll::parameters.body,
  "x-ms-client-name",
  "vmInstanceIDs"
);
@@doc(VirtualMachineScaleSets.reimageAll::parameters.body,
  "A list of virtual machine instance IDs from the VM scale set."
);
@@encodedName(VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body,
  "application/json",
  "parameters"
);
@@extension(VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body,
  "The input object for ConvertToSinglePlacementGroup API."
);
@@encodedName(VirtualMachineScaleSets.setOrchestrationServiceState::parameters.body,
  "application/json",
  "parameters"
);
@@extension(VirtualMachineScaleSets.setOrchestrationServiceState::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachineScaleSets.setOrchestrationServiceState::parameters.body,
  "The input object for SetOrchestrationServiceState API."
);
