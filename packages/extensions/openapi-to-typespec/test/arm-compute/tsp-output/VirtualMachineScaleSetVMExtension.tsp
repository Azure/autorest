import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSetVM.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Describes a VMSS VM Extension.")
@parentResource(VirtualMachineScaleSetVM)
model VirtualMachineScaleSetVMExtension
  is ProxyResource<VirtualMachineExtensionProperties> {
  @doc("The name of the virtual machine extension.")
  @key("vmExtensionName")
  @segment("extensions")
  name: string;
}

@armResourceOperations
interface VirtualMachineScaleSetVMExtensions {
  @doc("The operation to get the VMSS VM extension.")
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

  @doc("The operation to create or update the VMSS VM extension.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  @doc("The operation to update the VMSS VM extension.")
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

  @doc("The operation to delete the VMSS VM extension.")
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSetVMExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetVMExtension>;

      @doc("The name of the VM scale set.")
      @path
      vmScaleSetName: string;
    }
  >;

  @doc("The operation to get all extensions of an instance in Virtual Machine Scaleset.")
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
