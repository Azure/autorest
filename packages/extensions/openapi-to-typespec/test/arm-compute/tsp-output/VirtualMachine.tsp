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
 * Describes a Virtual Machine.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model VirtualMachine extends Resource {
  ...ResourceNameParameter<
    Resource = VirtualMachine,
    KeyName = "vmName",
    SegmentName = "virtualMachines",
    NamePattern = ""
  >;

  /**
   * Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.  In the Azure portal, find the marketplace image that you want to use and then click **Want to deploy programmatically, Get Started ->**. Enter any required information and then click **Save**.
   */
  plan?: Plan;

  /**
   * The virtual machine child extension resources.
   */
  @visibility("read")
  resources?: VirtualMachineExtension[];

  /**
   * The identity of the virtual machine, if configured.
   */
  identity?: VirtualMachineIdentity;

  /**
   * The virtual machine zones.
   */
  zones?: string[];

  /**
   * The extended location of the Virtual Machine.
   */
  extendedLocation?: ExtendedLocation;

  /**
   * Describes the properties of a Virtual Machine.
   */
  @extension("x-ms-client-flatten", true)
  properties?: VirtualMachineProperties;
}

@armResourceOperations
interface VirtualMachines {
  /**
   * Retrieves information about the model view or the instance view of a virtual machine.
   */
  get is ArmResourceRead<
    VirtualMachine,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;

      /**
       * The expand expression to apply on the operation. 'InstanceView' retrieves a snapshot of the runtime properties of the virtual machine that is managed by the platform and can change outside of control plane operations. 'UserData' retrieves the UserData property as part of the VM model view that was provided by the user during the VM Create/Update operation.
       */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /**
   * The operation to create or update a virtual machine. Please note some properties can be set only during virtual machine creation.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<VirtualMachine>;

  /**
   * The operation to update a virtual machine.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<VirtualMachine, VirtualMachineUpdate>;

  /**
   * The operation to delete a virtual machine.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<
    VirtualMachine,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;

      /**
       * Optional parameter to force delete virtual machines.
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    }
  >;

  /**
   * Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachines_List")
  list is ArmResourceListByParent<
    VirtualMachine,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;

      /**
       * The system query option to filter VMs returned in the response. Allowed value is 'virtualMachineScaleSet/id' eq /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmssName}'
       */
      @query("$filter")
      $filter?: string;

      /**
       * The expand expression to apply on operation. 'instanceView' enables fetching run time status of all Virtual Machines, this can only be specified if a valid $filter option is specified
       */
      @query("$expand")
      $expand?: ExpandTypeForListVMs;
    }
  >;

  /**
   * Gets all the virtual machines under the specified subscription for the specified location.
   */
  listByLocation is ArmResourceListAtScope<
    VirtualMachine,
    LocationScope<VirtualMachine>,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;
      ...LocationResourceParameter;
    }
  >;

  /**
   * Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
   */
  listAll is ArmListBySubscription<VirtualMachine>;

  /**
   * Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
   */
  capture is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineCaptureParameters,
    VirtualMachineCaptureResult
  >;

  /**
   * Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
   */
  convertToManagedDisks is ArmResourceActionAsync<VirtualMachine, void, void>;

  /**
   * Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
   */
  deallocate is ArmResourceActionAsync<
    VirtualMachine,
    void,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;

      /**
       * Optional parameter to hibernate a virtual machine. (Feature in Preview)
       */
      @query("hibernate")
      hibernate?: boolean;
    }
  >;

  /**
   * Sets the OS state of the virtual machine to generalized. It is recommended to sysprep the virtual machine before performing this operation. For Windows, please refer to [Create a managed image of a generalized VM in Azure](https://docs.microsoft.com/azure/virtual-machines/windows/capture-image-resource). For Linux, please refer to [How to create an image of a virtual machine or VHD](https://docs.microsoft.com/azure/virtual-machines/linux/capture-image).
   */
  generalize is ArmResourceActionSync<VirtualMachine, void, void>;

  /**
   * The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
   */
  powerOff is ArmResourceActionAsync<
    VirtualMachine,
    void,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;

      /**
       * The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
       */
      @query("skipShutdown")
      skipShutdown?: boolean;
    }
  >;

  /**
   * The operation to reapply a virtual machine's state.
   */
  reapply is ArmResourceActionAsync<VirtualMachine, void, void>;

  /**
   * The operation to restart a virtual machine.
   */
  restart is ArmResourceActionAsync<VirtualMachine, void, void>;

  /**
   * The operation to start a virtual machine.
   */
  start is ArmResourceActionAsync<VirtualMachine, void, void>;

  /**
   * Shuts down the virtual machine, moves it to a new node, and powers it back on.
   */
  redeploy is ArmResourceActionAsync<VirtualMachine, void, void>;

  /**
   * Reimages (upgrade the operating system) a virtual machine which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state. NOTE: The retaining of old OS disk depends on the value of deleteOption of OS disk. If deleteOption is detach, the old OS disk will be preserved after reimage. If deleteOption is delete, the old OS disk will be deleted after reimage. The deleteOption of the OS disk should be updated accordingly before performing the reimage.
   */
  reimage is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineReimageParameters,
    void
  >;

  /**
   * The operation to retrieve SAS URIs for a virtual machine's boot diagnostic logs.
   */
  retrieveBootDiagnosticsData is ArmResourceActionSync<
    VirtualMachine,
    void,
    RetrieveBootDiagnosticsDataResult,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachine>;

      /**
       * Expiration duration in minutes for the SAS URIs with a value between 1 to 1440 minutes. **Note:** If not specified, SAS URIs will be generated with a default expiration duration of 120 minutes.
       */
      @query("sasUriExpirationTimeInMinutes")
      sasUriExpirationTimeInMinutes?: int32;
    }
  >;

  /**
   * The operation to perform maintenance on a virtual machine.
   */
  performMaintenance is ArmResourceActionAsync<VirtualMachine, void, void>;

  /**
   * The operation to simulate the eviction of spot virtual machine.
   */
  simulateEviction is ArmResourceActionNoContentSync<VirtualMachine, void>;

  /**
   * Assess patches on the VM.
   */
  assessPatches is ArmResourceActionAsync<
    VirtualMachine,
    void,
    VirtualMachineAssessPatchesResult
  >;

  /**
   * Installs patches on the VM.
   */
  installPatches is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineInstallPatchesParameters,
    VirtualMachineInstallPatchesResult
  >;

  /**
   * Run command on the VM.
   */
  runCommand is ArmResourceActionAsync<
    VirtualMachine,
    RunCommandInput,
    RunCommandResult
  >;

  /**
   * Retrieves information about the run-time state of a virtual machine.
   */
  // FIXME: VirtualMachines_InstanceView could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView")
  @get
  instanceView(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the virtual machine.
     */
    @path
    vmName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineInstanceView> | ErrorResponse;

  /**
   * Lists all available virtual machine sizes to which the specified virtual machine can be resized.
   */
  // FIXME: VirtualMachines_ListAvailableSizes could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes")
  @get
  listAvailableSizes(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the virtual machine.
     */
    @path
    vmName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<VirtualMachineSizeListResult> | ErrorResponse;
}

@@doc(VirtualMachine.name, "The name of the virtual machine.");
@@encodedName(VirtualMachines.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(VirtualMachines.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachines.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine operation."
);
@@encodedName(VirtualMachines.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(VirtualMachines.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachines.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine operation."
);
@@encodedName(VirtualMachines.capture::parameters.body,
  "application/json",
  "parameters"
);
@@extension(VirtualMachines.capture::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachines.capture::parameters.body,
  "Parameters supplied to the Capture Virtual Machine operation."
);
@@encodedName(VirtualMachines.reimage::parameters.body,
  "application/json",
  "parameters"
);
@@extension(VirtualMachines.reimage::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachines.reimage::parameters.body,
  "Parameters supplied to the Reimage Virtual Machine operation."
);
@@encodedName(VirtualMachines.installPatches::parameters.body,
  "application/json",
  "installPatchesInput"
);
@@extension(VirtualMachines.installPatches::parameters.body,
  "x-ms-client-name",
  "installPatchesInput"
);
@@doc(VirtualMachines.installPatches::parameters.body,
  "Input for InstallPatches as directly received by the API"
);
@@encodedName(VirtualMachines.runCommand::parameters.body,
  "application/json",
  "parameters"
);
@@extension(VirtualMachines.runCommand::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(VirtualMachines.runCommand::parameters.body,
  "Parameters supplied to the Run command operation."
);
