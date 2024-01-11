import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
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
  get is ArmResourceRead<
    VirtualMachineScaleSetExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetExtension>;

      @doc("The name of the VM scale set containing the extension.")
      @path
      vmScaleSetName: string;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;
    }
  >;

  @doc("The operation to create or update an extension.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    VirtualMachineScaleSetExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetExtension>;

      @doc("The name of the VM scale set where the extension should be create or updated.")
      @path
      vmScaleSetName: string;
    }
  >;

  @doc("The operation to update an extension.")
  update is ArmCustomPatchAsync<
    VirtualMachineScaleSetExtension,
    VirtualMachineScaleSetExtensionUpdate,
    {
      ...BaseParameters<VirtualMachineScaleSetExtension>;

      @doc("The name of the VM scale set where the extension should be updated.")
      @path
      vmScaleSetName: string;
    }
  >;

  @doc("The operation to delete the extension.")
  delete is ArmResourceDeleteAsync<
    VirtualMachineScaleSetExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetExtension>;

      @doc("The name of the VM scale set where the extension should be deleted.")
      @path
      vmScaleSetName: string;
    }
  >;

  @doc("Gets a list of all extensions in a VM scale set.")
  list is ArmResourceListByParent<
    VirtualMachineScaleSetExtension,
    {
      ...BaseParameters<VirtualMachineScaleSetExtension>;

      @doc("The name of the VM scale set containing the extension.")
      @path
      vmScaleSetName: string;
    }
  >;
}
