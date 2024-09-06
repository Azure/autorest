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
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * The location of the extension.
   */
  @visibility("read", "create")
  location?: string;
}

@armResourceOperations
interface VirtualMachineScaleSetVMExtensions {
  /**
   * The operation to get the VMSS VM extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMExtensions_Get")
  get is ArmResourceRead<
    VirtualMachineScaleSetVMExtension,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSetVMExtension>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMExtensions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<VirtualMachineScaleSetVMExtension>;

  /**
   * The operation to update the VMSS VM extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("VirtualMachineScaleSetVMExtensions_Update")
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetVMExtension,
    VirtualMachineScaleSetVMExtensionUpdate
  >;

  /**
   * The operation to delete the VMSS VM extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMExtensions_Delete")
  delete is ArmResourceDeleteAsync<VirtualMachineScaleSetVMExtension>;

  /**
   * The operation to get all extensions of an instance in Virtual Machine Scaleset.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMExtensions_List")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVMExtension,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<VirtualMachineScaleSetVMExtension>;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;
}

@@doc(VirtualMachineScaleSetVMExtension.name,
  "The name of the virtual machine extension."
);
@@doc(VirtualMachineScaleSetVMExtension.properties,
  "Describes the properties of a Virtual Machine Extension."
);
@@encodedName(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "application/json",
  "extensionParameters"
);
@@extension(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "extensionParameters"
);
@@doc(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Virtual Machine Extension operation."
);
@@encodedName(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "application/json",
  "extensionParameters"
);
@@extension(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "x-ms-client-name",
  "extensionParameters"
);
@@doc(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "Parameters supplied to the Update Virtual Machine Extension operation."
);
