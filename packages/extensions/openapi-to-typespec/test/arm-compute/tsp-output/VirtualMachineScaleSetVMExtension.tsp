import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSetVM.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a VMSS VM Extension.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(VirtualMachineScaleSetVM)
@includeInapplicableMetadataInPayload(false)
model VirtualMachineScaleSetVMExtension extends SubResourceReadOnly {
  /**
   * The name of the virtual machine extension.
   */
  @path
  @key("vmExtensionName")
  @segment("extensions")
  @visibility("read")
  name: string;

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

  /**
   * Describes the properties of a Virtual Machine Extension.
   */
  @extension("x-ms-client-flatten", true)
  properties?: VirtualMachineExtensionProperties;
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
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * The operation to update the VMSS VM extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("VirtualMachineScaleSetVMExtensions_Update")
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetVMExtension,
    VirtualMachineScaleSetVMExtensionUpdate,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * The operation to delete the VMSS VM extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMExtensions_Delete")
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;
    }
  >;

  /**
   * The operation to get all extensions of an instance in Virtual Machine Scaleset.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineScaleSetVMExtensions_List")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      /**
       * The name of the VM scale set.
       */
      @path
      vmScaleSetName: string;

      /**
       * The expand expression to apply on the operation.
       */
      @query("$expand")
      $expand?: string;
    }
  >;
}

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
