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
 * Describes a Virtual Machine Scale Set Extension.
 */
@parentResource(VirtualMachineScaleSet)
model VirtualMachineScaleSetExtension
  is Azure.ResourceManager.ProxyResource<VirtualMachineScaleSetExtensionProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachineScaleSetExtension,
    KeyName = "vmssExtensionName",
    SegmentName = "extensions",
    NamePattern = ""
  >;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;
}

@armResourceOperations
interface VirtualMachineScaleSetExtensions {
  /**
   * The operation to get the extension.
   */
  get is ArmResourceRead<
    VirtualMachineScaleSetExtension,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSetExtension>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * The operation to create or update an extension.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<VirtualMachineScaleSetExtension>;

  /**
   * The operation to update an extension.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetExtension,
    VirtualMachineScaleSetExtensionUpdate
  >;

  /**
   * The operation to delete the extension.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<VirtualMachineScaleSetExtension>;

  /**
   * Gets a list of all extensions in a VM scale set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetExtensions_List")
  list is ArmResourceListByParent<VirtualMachineScaleSetExtension>;
}

@@doc(VirtualMachineScaleSetExtension.name,
  "The name of the VM scale set extension."
);
@@doc(VirtualMachineScaleSetExtension.properties,
  "Describes the properties of a Virtual Machine Scale Set Extension."
);
@@encodedName(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "application/json",
  "extensionParameters"
);
@@extension(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "extensionParameters"
);
@@doc(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create VM scale set Extension operation."
);
@@encodedName(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "application/json",
  "extensionParameters"
);
@@extension(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "x-ms-client-name",
  "extensionParameters"
);
@@doc(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "Parameters supplied to the Update VM scale set Extension operation."
);
