import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachine.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a Virtual Machine run command.
 */
@parentResource(VirtualMachine)
model VirtualMachineRunCommand
  is TrackedResource<VirtualMachineRunCommandProperties> {
  /**
   * The name of the virtual machine run command.
   */
  @path
  @key("runCommandName")
  @segment("runCommands")
  name: string;
}

@armResourceOperations
interface VirtualMachineRunCommands {
  /**
   * The operation to get the run command.
   */
  getByVirtualMachine is ArmResourceRead<
    VirtualMachineRunCommand,
    {
      ...BaseParameters<VirtualMachineRunCommand>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    VirtualMachineRunCommand,
    VirtualMachineRunCommandUpdate
  >;

  /**
   * The operation to delete the run command.
   */
  delete is ArmResourceDeleteAsync<VirtualMachineRunCommand>;

  /**
   * The operation to get all run commands of a Virtual Machine.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineRunCommands_ListByVirtualMachine")
  listByVirtualMachine is ArmResourceListByParent<
    VirtualMachineRunCommand,
    {
      ...BaseParameters<VirtualMachineRunCommand>;

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
      ...BaseParameters<VirtualMachineRunCommand>;

      /**
       * The location upon which run commands is queried.
       */
      @pattern("^[-\\w\\._]+$")
      @path
      location: string;
    }
  >;
}

@@projectedName(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "json",
  "runCommand"
);
@@extension(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "runCommand"
);
@@doc(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine RunCommand operation."
);
@@projectedName(VirtualMachineRunCommands.update::parameters.properties,
  "json",
  "runCommand"
);
@@extension(VirtualMachineRunCommands.update::parameters.properties,
  "x-ms-client-name",
  "runCommand"
);
@@doc(VirtualMachineRunCommands.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine RunCommand operation."
);
