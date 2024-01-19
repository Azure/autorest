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
 * Describes a Virtual Machine Extension.
 */
@parentResource(VirtualMachine)
model VirtualMachineExtension
  is TrackedResource<VirtualMachineExtensionProperties> {
  /**
   * The name of the virtual machine extension.
   */
  @path
  @key("vmExtensionName")
  @segment("extensions")
  name: string;
}

@armResourceOperations
interface VirtualMachineExtensions {
  /**
   * The operation to get the extension.
   */
  get is ArmResourceRead<
    VirtualMachineExtension,
    {
      ...BaseParameters<VirtualMachineExtension>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * The operation to create or update the extension.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<VirtualMachineExtension>;

  /**
   * The operation to update the extension.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    VirtualMachineExtension,
    VirtualMachineExtensionUpdate
  >;

  /**
   * The operation to delete the extension.
   */
  delete is ArmResourceDeleteAsync<VirtualMachineExtension>;

  /**
   * The operation to get all extensions of a Virtual Machine.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineExtensions_List")
  list is ArmResourceListByParent<
    VirtualMachineExtension,
    {
      ...BaseParameters<VirtualMachineExtension>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;
}

@@projectedName(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "json",
  "extensionParameters"
);
@@extension(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "extensionParameters"
);
@@doc(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine Extension operation."
);
@@projectedName(VirtualMachineExtensions.update::parameters.properties,
  "json",
  "extensionParameters"
);
@@extension(VirtualMachineExtensions.update::parameters.properties,
  "x-ms-client-name",
  "extensionParameters"
);
@@doc(VirtualMachineExtensions.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine Extension operation."
);
