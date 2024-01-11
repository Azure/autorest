import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./VirtualMachine.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Describes a Virtual Machine Extension.")
@parentResource(VirtualMachine)
model VirtualMachineExtension
  is TrackedResource<VirtualMachineExtensionProperties> {
  @doc("The name of the virtual machine extension.")
  @path
  @key("vmExtensionName")
  @segment("extensions")
  name: string;
}

@armResourceOperations
interface VirtualMachineExtensions {
  @doc("The operation to get the extension.")
  get is ArmResourceRead<
    VirtualMachineExtension,
    {
      ...BaseParameters<VirtualMachineExtension>;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;
    }
  >;

  @doc("The operation to create or update the extension.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<VirtualMachineExtension>;

  @doc("The operation to update the extension.")
  update is ArmCustomPatchAsync<
    VirtualMachineExtension,
    VirtualMachineExtensionUpdate
  >;

  @doc("The operation to delete the extension.")
  delete is ArmResourceDeleteAsync<VirtualMachineExtension>;

  @doc("The operation to get all extensions of a Virtual Machine.")
  list is ArmResourceListByParent<
    VirtualMachineExtension,
    {
      ...BaseParameters<VirtualMachineExtension>;

      @doc("The expand expression to apply on the operation.")
      @query("$expand")
      $expand?: string;
    }
  >;
}
