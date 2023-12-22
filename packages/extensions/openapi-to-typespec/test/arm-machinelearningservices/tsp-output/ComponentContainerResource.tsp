import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Registry.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(Registry)
model ComponentContainerResource is ProxyResource<ComponentContainer> {
  @doc("Container name.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("componentName")
  @segment("components")
  name: string;
}

@armResourceOperations
interface RegistryComponentContainers {
  @doc("Get container.")
  get is ArmResourceRead<ComponentContainerResource>;
  @doc("Create or update container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ComponentContainerResource>;
  @doc("Delete container.")
  delete is ArmResourceDeleteAsync<ComponentContainerResource>;
  @doc("List containers.")
  list is ArmResourceListByParent<
    ComponentContainerResource,
    {
      ...BaseParameters<ComponentContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
}
