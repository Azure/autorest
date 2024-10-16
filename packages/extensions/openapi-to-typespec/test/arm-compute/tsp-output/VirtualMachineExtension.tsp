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
 * Describes a Virtual Machine Extension.
 */
@parentResource(VirtualMachine)
model VirtualMachineExtension
  is Azure.ResourceManager.TrackedResource<VirtualMachineExtensionProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachineExtension,
    KeyName = "vmExtensionName",
    SegmentName = "extensions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface VirtualMachineExtensions {
  /**
   * The operation to get the extension.
   */
  get is ArmResourceRead<
    VirtualMachineExtension,
    Parameters = {
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
  @parameterVisibility
  update is ArmCustomPatchAsync<
    VirtualMachineExtension,
    VirtualMachineExtensionUpdate
  >;

  /**
   * The operation to delete the extension.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<VirtualMachineExtension>;

  /**
   * The operation to get all extensions of a Virtual Machine.
   */
  list is ArmResourceListByParent<
    VirtualMachineExtension,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    },
    Response = VirtualMachineExtensionsListResult
  >;
}

@@doc(VirtualMachineExtension.name,
  "The name of the virtual machine extension."
);
@@doc(VirtualMachineExtension.properties,
  "Describes the properties of a Virtual Machine Extension."
);
@@doc(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine Extension operation."
);
@@doc(VirtualMachineExtensions.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine Extension operation."
);
