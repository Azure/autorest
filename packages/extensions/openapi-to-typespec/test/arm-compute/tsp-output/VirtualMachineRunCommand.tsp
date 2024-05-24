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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(VirtualMachine)
@includeInapplicableMetadataInPayload(false)
model VirtualMachineRunCommand extends Resource {
  ...ResourceNameParameter<
    Resource = VirtualMachineRunCommand,
    KeyName = "runCommandName",
    SegmentName = "runCommands",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a Virtual Machine run command.
   */
  @extension("x-ms-client-flatten", true)
  properties?: VirtualMachineRunCommandProperties;
}

@armResourceOperations
interface VirtualMachineRunCommands {
  /**
   * The operation to get the run command.
   */
  getByVirtualMachine is ArmResourceRead<
    VirtualMachineRunCommand,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineRunCommand>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * The operation to create or update the run command.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<VirtualMachineRunCommand>;

  /**
   * The operation to update the run command.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<
    VirtualMachineRunCommand,
    VirtualMachineRunCommandUpdate
  >;

  /**
   * The operation to delete the run command.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<VirtualMachineRunCommand>;

  /**
   * The operation to get all run commands of a Virtual Machine.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineRunCommands_ListByVirtualMachine")
  listByVirtualMachine is ArmResourceListByParent<
    VirtualMachineRunCommand,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineRunCommand>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * Lists all available run commands for a subscription in a location.
   */
  list is ArmResourceListAtScope<
    VirtualMachineRunCommand,
    LocationScope<VirtualMachineRunCommand>,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineRunCommand>;
      ...LocationResourceParameter;
    }
  >;
}

@@doc(VirtualMachineRunCommand.name,
  "The name of the virtual machine run command."
);
@@encodedName(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "application/json",
  "runCommand"
);
@@extension(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "runCommand"
);
@@doc(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine RunCommand operation."
);
@@encodedName(VirtualMachineRunCommands.update::parameters.properties,
  "application/json",
  "runCommand"
);
@@extension(VirtualMachineRunCommands.update::parameters.properties,
  "x-ms-client-name",
  "runCommand"
);
@@doc(VirtualMachineRunCommands.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine RunCommand operation."
);
