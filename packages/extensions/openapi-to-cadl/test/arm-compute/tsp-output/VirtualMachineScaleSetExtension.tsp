import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a Virtual Machine Scale Set Extension.")
@parentResource(VirtualMachineScaleSet)
model VirtualMachineScaleSetExtension
  is ProxyResource<VirtualMachineScaleSetExtensionProperties> {
  @doc("The name of the VM scale set extension.")
  @path
  @key("vmssExtensionName")
  @segment("extensions")
  name: string;
}

@armResourceOperations
interface VirtualMachineScaleSetExtensions {
  @doc("The operation to get the extension.")
  get is ArmResourceRead<VirtualMachineScaleSetExtension>;
  @doc("The operation to create or update an extension.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<VirtualMachineScaleSetExtension>;
  @doc("The operation to update an extension.")
  update is ArmResourcePatchAsync<
    VirtualMachineScaleSetExtension,
    VirtualMachineScaleSetExtensionProperties
  >;
  @doc("The operation to delete the extension.")
  delete is ArmResourceDeleteAsync<VirtualMachineScaleSetExtension>;
  @doc("Gets a list of all extensions in a VM scale set.")
  list is ArmResourceListByParent<VirtualMachineScaleSetExtension>;
}
