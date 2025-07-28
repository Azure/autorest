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
}

@armResourceOperations
interface VirtualMachineScaleSetExtensions {
  /**
   * The operation to get the extension.
   */
  get is ArmResourceRead<
    VirtualMachineScaleSetExtension,
    Parameters = {
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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    VirtualMachineScaleSetExtension,
    LroHeaders = ArmLroLocationHeader<FinalResult = VirtualMachineScaleSetExtension> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * The operation to update an extension.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetExtension,
    PatchModel = VirtualMachineScaleSetExtensionUpdate,
    Response = ArmResponse<VirtualMachineScaleSetExtension> | ArmResourceCreatedResponse<VirtualMachineScaleSetExtension>
  >;

  /**
   * The operation to delete the extension.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    VirtualMachineScaleSetExtension,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Gets a list of all extensions in a VM scale set.
   */
  list is ArmResourceListByParent<VirtualMachineScaleSetExtension>;
}

@@doc(VirtualMachineScaleSetExtension.name,
  "The name of the VM scale set extension."
);
@@doc(VirtualMachineScaleSetExtension.properties,
  "Describes the properties of a Virtual Machine Scale Set Extension."
);
@@doc(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create VM scale set Extension operation."
);
@@doc(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "Parameters supplied to the Update VM scale set Extension operation."
);
