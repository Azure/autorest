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
model ModelContainerResource is ProxyResource<ModelContainer> {
  @doc("Container name. This is case-sensitive.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @key("modelName")
  @segment("models")
  name: string;
}

@armResourceOperations
interface RegistryModelContainers {
  @doc("Get container.")
  get is ArmResourceRead<ModelContainerResource>;
  @doc("Create or update model container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ModelContainerResource>;
  @doc("Delete container.")
  delete is ArmResourceDeleteAsync<ModelContainerResource>;
  @doc("List model containers.")
  list is ArmResourceListByParent<
    ModelContainerResource,
    {
      ...BaseParameters<ModelContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}
