import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a Virtual Machine Extension Image.")
@subscriptionResource
@locationResource
model VirtualMachineExtensionImage
  is TrackedResource<VirtualMachineExtensionImageProperties> {
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface VirtualMachineExtensionImages {
  @doc("Gets a virtual machine extension image.")
  get is ArmResourceRead<VirtualMachineExtensionImage>;
  @doc("Gets a list of virtual machine extension image types.")
  listTypes is ArmResourceListByParent<
    VirtualMachineExtensionImage,
    {
      @doc("The name of a supported Azure region.")
      @path
      location: string;

      @path
      publisherName: string;
    }
  >;
}
