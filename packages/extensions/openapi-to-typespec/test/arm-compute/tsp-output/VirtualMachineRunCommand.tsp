import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachine.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a Virtual Machine run command.
 */
@parentResource(VirtualMachine)
model VirtualMachineRunCommand
  is Azure.ResourceManager.TrackedResource<VirtualMachineRunCommandProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachineRunCommand,
    KeyName = "runCommandName",
    SegmentName = "runCommands",
    NamePattern = ""
  >;
}

@armResourceOperations
interface VirtualMachineRunCommandOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = VirtualMachine,
          KeyName = "vmName",
          SegmentName = "virtualMachines",
          NamePattern = ""
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = VirtualMachineRunCommand,
        KeyName = "runCommandName",
        SegmentName = "runCommands",
        NamePattern = ""
      >>
    > {}

@armResourceOperations
interface VirtualMachineRunCommands {
  /**
   * The operation to get the run command.
   */
  getByVirtualMachine is VirtualMachineRunCommandOps.Read<
    VirtualMachineRunCommand,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    },
    Response = ArmResponse<VirtualMachineRunCommand & {
      @header
      contentType: "application/json" | "text/json";
    }>
  >;

  /**
   * The operation to create or update the run command.
   */
  createOrUpdate is VirtualMachineRunCommandOps.CreateOrUpdateAsync<
    VirtualMachineRunCommand,
    Response = ArmResourceUpdatedResponse<VirtualMachineRunCommand & {
      @header
      contentType: "application/json" | "text/json";
    }> | ArmResourceCreatedResponse<
      VirtualMachineRunCommand & {
        @header
        contentType: "application/json" | "text/json";
      },
      ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
    >
  >;

  /**
   * The operation to update the run command.
   */
  @parameterVisibility
  update is VirtualMachineRunCommandOps.CustomPatchAsync<
    VirtualMachineRunCommand,
    PatchModel = VirtualMachineRunCommandUpdate,
    Response = ArmResponse<VirtualMachineRunCommand & {
      @header
      contentType: "application/json" | "text/json";
    }>
  >;

  /**
   * The operation to delete the run command.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is VirtualMachineRunCommandOps.DeleteWithoutOkAsync<
    VirtualMachineRunCommand,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * The operation to get all run commands of a Virtual Machine.
   */
  listByVirtualMachine is VirtualMachineRunCommandOps.List<
    VirtualMachineRunCommand,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;
}
@armResourceOperations
interface VirtualMachineScaleSetVMRunCommandOps
  extends Azure.ResourceManager.Legacy.LegacyOperations<
      {
        ...ApiVersionParameter,
        ...SubscriptionIdParameter,
        ...ResourceGroupParameter,
        ...Azure.ResourceManager.Legacy.Provider,
        ...KeysOf<ResourceNameParameter<
          Resource = VirtualMachineScaleSet,
          KeyName = "vmScaleSetName",
          SegmentName = "virtualMachineScaleSets",
          NamePattern = ""
        >>,
        ...KeysOf<ResourceNameParameter<
          Resource = VirtualMachineScaleSetVM,
          KeyName = "instanceId",
          SegmentName = "virtualMachines",
          NamePattern = ""
        >>,
      },
      KeysOf<ResourceNameParameter<
        Resource = VirtualMachineRunCommand,
        KeyName = "runCommandName",
        SegmentName = "runCommands",
        NamePattern = ""
      >>
    > {}

@armResourceOperations
interface VirtualMachineScaleSetVMRunCommands {
  /**
   * The operation to get the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_Get")
  get is VirtualMachineScaleSetVMRunCommandOps.Read<
    VirtualMachineRunCommand,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    },
    Response = ArmResponse<VirtualMachineRunCommand & {
      @header
      contentType: "application/json" | "text/json";
    }>
  >;

  /**
   * The operation to create or update the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_CreateOrUpdate")
  createOrUpdate is VirtualMachineScaleSetVMRunCommandOps.CreateOrUpdateAsync<
    VirtualMachineRunCommand,
    Response = ArmResourceUpdatedResponse<VirtualMachineRunCommand & {
      @header
      contentType: "application/json" | "text/json";
    }> | ArmResourceCreatedResponse<
      VirtualMachineRunCommand & {
        @header
        contentType: "application/json" | "text/json";
      },
      ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
    >
  >;

  /**
   * The operation to update the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("VirtualMachineScaleSetVMRunCommands_Update")
  update is VirtualMachineScaleSetVMRunCommandOps.CustomPatchAsync<
    VirtualMachineRunCommand,
    PatchModel = VirtualMachineRunCommandUpdate,
    Response = ArmResponse<VirtualMachineRunCommand & {
      @header
      contentType: "application/json" | "text/json";
    }>
  >;

  /**
   * The operation to delete the VMSS VM run command.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMRunCommands_Delete")
  delete is VirtualMachineScaleSetVMRunCommandOps.DeleteWithoutOkAsync<
    VirtualMachineRunCommand,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * The operation to get all run commands of an instance in Virtual Machine Scaleset.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("VirtualMachineScaleSetVMRunCommands_List")
  list is VirtualMachineScaleSetVMRunCommandOps.List<
    VirtualMachineRunCommand,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;
}

@@doc(VirtualMachineRunCommand.name,
  "The name of the virtual machine run command."
);
@@doc(VirtualMachineRunCommand.properties,
  "Describes the properties of a Virtual Machine run command."
);
@@doc(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine RunCommand operation."
);
@@doc(VirtualMachineRunCommands.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine RunCommand operation."
);
@@doc(VirtualMachineScaleSetVMRunCommands.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine RunCommand operation."
);
@@doc(VirtualMachineScaleSetVMRunCommands.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine RunCommand operation."
);
