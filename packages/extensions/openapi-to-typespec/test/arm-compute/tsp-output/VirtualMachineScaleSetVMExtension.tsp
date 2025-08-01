import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSetVM.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a VMSS VM Extension.
 */
@parentResource(VirtualMachineScaleSetVM)
model VirtualMachineScaleSetVMExtension
  is Azure.ResourceManager.ProxyResource<VirtualMachineExtensionProperties> {
  ...ResourceNameParameter<
    Resource = VirtualMachineScaleSetVMExtension,
    KeyName = "vmExtensionName",
    SegmentName = "extensions",
    NamePattern = ""
  >;

  /**
   * The location of the extension.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read, Lifecycle.Create)
  location?: string;
}

@armResourceOperations
interface VirtualMachineScaleSetVMExtensions {
  /**
   * The operation to get the VMSS VM extension.
   */
  get is ArmResourceRead<
    VirtualMachineScaleSetVMExtension,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;

  /**
   * The operation to create or update the VMSS VM extension.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    VirtualMachineScaleSetVMExtension,
    LroHeaders = ArmLroLocationHeader<FinalResult = VirtualMachineScaleSetVMExtension> &
      Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * The operation to update the VMSS VM extension.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetVMExtension,
    PatchModel = VirtualMachineScaleSetVMExtensionUpdate,
    Response = ArmResponse<VirtualMachineScaleSetVMExtension>
  >;

  /**
   * The operation to delete the VMSS VM extension.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    VirtualMachineScaleSetVMExtension,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * The operation to get all extensions of an instance in Virtual Machine Scaleset.
   */
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVMExtension,
    Parameters = {
      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    },
    Response = ArmResponse<VirtualMachineScaleSetVMExtensionsListResult>
  >;
}

@@doc(VirtualMachineScaleSetVMExtension.name,
  "The name of the virtual machine extension."
);
@@doc(VirtualMachineScaleSetVMExtension.properties,
  "Describes the properties of a Virtual Machine Extension."
);
@@doc(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine Extension operation."
);
@@doc(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine Extension operation."
);
