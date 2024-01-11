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
@doc("Describes a VMSS VM Extension.")
@parentResource(VirtualMachineScaleSetVM)
model VirtualMachineScaleSetVMExtension
  is ProxyResource<VirtualMachineExtensionProperties> {
  @doc("The name of the virtual machine extension.")
  @path
  @key("vmExtensionName")
  @segment("extensions")
  name: string;
}

@armResourceOperations
interface VirtualMachineScaleSetVMExtensions {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to get the VMSS VM extension.")
  @operationId("VirtualMachineScaleSetVMExtensions_Get")
  get is ArmResourceRead<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to create or update the VMSS VM extension.")
  @operationId("VirtualMachineScaleSetVMExtensions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to update the VMSS VM extension.")
  @operationId("VirtualMachineScaleSetVMExtensions_Update")
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetVMExtension,
    VirtualMachineScaleSetVMExtensionUpdate,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to delete the VMSS VM extension.")
  @operationId("VirtualMachineScaleSetVMExtensions_Delete")
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("The operation to get all extensions of an instance in Virtual Machine Scaleset.")
  @operationId("VirtualMachineScaleSetVMExtensions_List")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;
    }
  >;
}
