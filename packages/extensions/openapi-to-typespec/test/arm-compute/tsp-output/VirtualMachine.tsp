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
model VirtualMachine
  is Azure.ResourceManager.TrackedResource<VirtualMachineProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachine,
    KeyName = "vmName",
    SegmentName = "virtualMachines",
    NamePattern = ""
  >;

  /**
   * Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.  In the Azure portal, find the marketplace image that you want to use and then click **Want to deploy programmatically, Get Started ->**. Enter any required information and then click **Save**.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  plan?: Plan;

  /**
   * The virtual machine child extension resources.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility("read")
  resources?: VirtualMachineExtension[];

  /**
   * The identity of the virtual machine, if configured.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: VirtualMachineIdentity;

  ...Azure.ResourceManager.AvailabilityZonesProperty;

  /**
   * The extended location of the Virtual Machine.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface VirtualMachines {
  /**
   * Retrieves information about the model view or the instance view of a virtual machine.
   */
  get is ArmResourceRead<
    VirtualMachine,
    Parameters = {
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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    VirtualMachine,
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * The operation to update a virtual machine.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<
    VirtualMachine,
    PatchModel = VirtualMachineUpdate,
    Response = ArmResponse<VirtualMachine>
  >;

  /**
   * The operation to delete a virtual machine.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    VirtualMachine,
    Parameters = {
      /**
       * Optional parameter to force delete virtual machines.
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    },
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
   */
  list is ArmResourceListByParent<
    VirtualMachine,
    Parameters = {
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
   * Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
   */
  listAll is ArmListBySubscription<
    VirtualMachine,
    Parameters = {
      /**
       * statusOnly=true enables fetching run time status of all Virtual Machines in the subscription.
       */
      @query("statusOnly")
      statusOnly?: string;

      /**
       * The system query option to filter VMs returned in the response. Allowed value is 'virtualMachineScaleSet/id' eq /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmssName}'
       */
      @query("$filter")
      $filter?: string;

      /**
       * The expand expression to apply on operation. 'instanceView' enables fetching run time status of all Virtual Machines, this can only be specified if a valid $filter option is specified
       */
      @query("$expand")
      $expand?: ExpandTypesForListVMs;
    }
  >;

  /**
   * Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
   */
  capture is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineCaptureParameters,
    ArmResponse<VirtualMachineCaptureResult>
  >;

  /**
   * Retrieves information about the run-time state of a virtual machine.
   */
  @get
  instanceView is ArmResourceActionSync<
    VirtualMachine,
    void,
    ArmResponse<VirtualMachineInstanceView>
  >;

  /**
   * Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
   */
  convertToManagedDisks is ArmResourceActionAsync<
    VirtualMachine,
    void,
    OkResponse
  >;

  /**
   * Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
   */
  deallocate is ArmResourceActionAsync<
    VirtualMachine,
    void,
    OkResponse,
    Parameters = {
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
  generalize is ArmResourceActionSync<VirtualMachine, void, OkResponse>;

  /**
   * Lists all available virtual machine sizes to which the specified virtual machine can be resized.
   */
  @get
  @action("vmSizes")
  listAvailableSizes is ArmResourceActionSync<
    VirtualMachine,
    void,
    ArmResponse<VirtualMachineSizeListResult>
  >;

  /**
   * The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
   */
  powerOff is ArmResourceActionAsync<
    VirtualMachine,
    void,
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
   * The operation to reapply a virtual machine's state.
   */
  reapply is ArmResourceActionAsync<VirtualMachine, void, OkResponse>;

  /**
   * The operation to restart a virtual machine.
   */
  restart is ArmResourceActionAsync<VirtualMachine, void, OkResponse>;

  /**
   * The operation to start a virtual machine.
   */
  start is ArmResourceActionAsync<VirtualMachine, void, OkResponse>;

  /**
   * Shuts down the virtual machine, moves it to a new node, and powers it back on.
   */
  redeploy is ArmResourceActionAsync<VirtualMachine, void, OkResponse>;

  /**
   * Reimages (upgrade the operating system) a virtual machine which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state. NOTE: The retaining of old OS disk depends on the value of deleteOption of OS disk. If deleteOption is detach, the old OS disk will be preserved after reimage. If deleteOption is delete, the old OS disk will be deleted after reimage. The deleteOption of the OS disk should be updated accordingly before performing the reimage.
   */
  reimage is ArmResourceActionAsync<
    VirtualMachine,
    {
      /**
       * Parameters supplied to the Reimage Virtual Machine operation.
       */
      @bodyRoot
      parameters?: VirtualMachineReimageParameters;
    },
    OkResponse
  >;

  /**
   * The operation to retrieve SAS URIs for a virtual machine's boot diagnostic logs.
   */
  retrieveBootDiagnosticsData is ArmResourceActionSync<
    VirtualMachine,
    void,
    ArmResponse<RetrieveBootDiagnosticsDataResult>,
    Parameters = {
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
  performMaintenance is ArmResourceActionAsync<
    VirtualMachine,
    void,
    OkResponse
  >;

  /**
   * The operation to simulate the eviction of spot virtual machine.
   */
  simulateEviction is ArmResourceActionSync<
    VirtualMachine,
    void,
    NoContentResponse
  >;

  /**
   * Assess patches on the VM.
   */
  assessPatches is ArmResourceActionAsync<
    VirtualMachine,
    void,
    ArmResponse<VirtualMachineAssessPatchesResult>
  >;

  /**
   * Installs patches on the VM.
   */
  installPatches is ArmResourceActionAsync<
    VirtualMachine,
    VirtualMachineInstallPatchesParameters,
    ArmResponse<VirtualMachineInstallPatchesResult>
  >;

  /**
   * Run command on the VM.
   */
  runCommand is ArmResourceActionAsync<
    VirtualMachine,
    RunCommandInput,
    ArmResponse<RunCommandResult & {
      @header
      contentType: "application/json" | "text/json";
    }>
  >;
}

@@doc(VirtualMachine.name, "The name of the virtual machine.");
@@doc(VirtualMachine.properties,
  "Describes the properties of a Virtual Machine."
);
@@doc(VirtualMachines.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine operation."
);
@@doc(VirtualMachines.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine operation."
);
@@doc(VirtualMachines.capture::parameters.body,
  "Parameters supplied to the Capture Virtual Machine operation."
);
@@doc(VirtualMachines.installPatches::parameters.body,
  "Input for InstallPatches as directly received by the API"
);
@@doc(VirtualMachines.runCommand::parameters.body,
  "Parameters supplied to the Run command operation."
);
