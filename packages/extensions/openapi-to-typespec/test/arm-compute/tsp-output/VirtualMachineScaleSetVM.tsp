import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a virtual machine scale set virtual machine.
 */
@parentResource(VirtualMachineScaleSet)
model VirtualMachineScaleSetVM
  is Azure.ResourceManager.TrackedResource<VirtualMachineScaleSetVMProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachineScaleSetVM,
    KeyName = "instanceId",
    SegmentName = "virtualMachines",
    NamePattern = ""
  >;

  /**
   * The virtual machine instance ID.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility("read")
  instanceId?: string;

  /**
   * The virtual machine SKU.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility("read")
  sku?: Sku;

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
   * The virtual machine zones.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility("read")
  zones?: string[];

  /**
   * The identity of the virtual machine, if configured.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: VirtualMachineIdentity;
}

@armResourceOperations
interface VirtualMachineScaleSetVMS {
  /**
   * Gets a virtual machine from a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_Get")
  get is ArmResourceRead<
    VirtualMachineScaleSetVM,
    Parameters = {
      /**
       * The expand expression to apply on the operation. 'InstanceView' will retrieve the instance view of the virtual machine. 'UserData' will retrieve the UserData of the virtual machine.
       */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /**
   * Updates a virtual machine of a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMs_Update")
  update is ArmResourceCreateOrReplaceAsync<
    VirtualMachineScaleSetVM,
    Response = ArmResourceUpdatedResponse<VirtualMachineScaleSetVM> | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: VirtualMachineScaleSetVM;
    }),
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Deletes a virtual machine from a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMs_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    VirtualMachineScaleSetVM,
    Parameters = {
      /**
       * Optional parameter to force delete a virtual machine from a VM scale set. (Feature in Preview)
       */
      @query("forceDeletion")
      forceDeletion?: boolean;
    },
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Gets a list of all virtual machines in a VM scale sets.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_List")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVM,
    Parameters = {
      /**
       * The name of the VM scale set.
       */
      @path
      virtualMachineScaleSetName: string;

      /**
       * The filter to apply to the operation. Allowed values are 'startswith(instanceView/statuses/code, 'PowerState') eq true', 'properties/latestModelApplied eq true', 'properties/latestModelApplied eq false'.
       */
      @query("$filter")
      $filter?: string;

      /**
       * The list parameters. Allowed values are 'instanceView', 'instanceView/statuses'.
       */
      @query("$select")
      $select?: string;

      /**
       * The expand expression to apply to the operation. Allowed values are 'instanceView'.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_Reimage")
  reimage is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    {
      /**
       * Parameters for the Reimaging Virtual machine in ScaleSet.
       */
      @bodyRoot
      vmScaleSetVMReimageInput?: VirtualMachineScaleSetVMReimageParameters;
    },
    OkResponse
  >;

  /**
   * Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("reimageall")
  @operationId("VirtualMachineScaleSetVMs_ReimageAll")
  reimageAll is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    OkResponse
  >;

  /**
   * Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_Deallocate")
  deallocate is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    OkResponse
  >;

  /**
   * Gets the status of a virtual machine from a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("instanceView")
  @operationId("VirtualMachineScaleSetVMs_GetInstanceView")
  getInstanceView is ArmResourceActionSync<
    VirtualMachineScaleSetVM,
    void,
    ArmResponse<VirtualMachineScaleSetVMInstanceView>
  >;

  /**
   * Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("poweroff")
  @operationId("VirtualMachineScaleSetVMs_PowerOff")
  powerOff is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
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
   * Restarts a virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_Restart")
  restart is ArmResourceActionAsync<VirtualMachineScaleSetVM, void, OkResponse>;

  /**
   * Starts a virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_Start")
  start is ArmResourceActionAsync<VirtualMachineScaleSetVM, void, OkResponse>;

  /**
   * Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_Redeploy")
  redeploy is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    OkResponse
  >;

  /**
   * The operation to retrieve SAS URIs of boot diagnostic logs for a virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_RetrieveBootDiagnosticsData")
  retrieveBootDiagnosticsData is ArmResourceActionSync<
    VirtualMachineScaleSetVM,
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
   * Performs maintenance on a virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_PerformMaintenance")
  performMaintenance is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    void,
    OkResponse
  >;

  /**
   * The operation to simulate the eviction of spot virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_SimulateEviction")
  simulateEviction is ArmResourceActionSync<
    VirtualMachineScaleSetVM,
    void,
    NoContentResponse
  >;

  /**
   * Run command on a virtual machine in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMs_RunCommand")
  runCommand is ArmResourceActionAsync<
    VirtualMachineScaleSetVM,
    RunCommandInput,
    ArmResponse<RunCommandResult & {
      @header
      contentType: "application/json" | "text/json";
    }>
  >;
}

@@doc(VirtualMachineScaleSetVM.name, "The instance ID of the virtual machine.");
@@doc(VirtualMachineScaleSetVM.properties,
  "Describes the properties of a virtual machine scale set virtual machine."
);
@@doc(VirtualMachineScaleSetVMS.update::parameters.resource,
  "Parameters supplied to the Update Virtual Machine Scale Sets VM operation."
);
@@doc(VirtualMachineScaleSetVMS.runCommand::parameters.body,
  "Parameters supplied to the Run command operation."
);
