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
model DataContainerResource is ProxyResource<DataContainer> {
  @doc("Container name.")
  @key("name")
  @segment("data")
  name: string;
}

@armResourceOperations
@projectedName("client", "RegistryDataContainers")
interface DataContainerResources_RegistryDataContainers {
  @doc("Get container.")
  get is ArmResourceRead<DataContainerResource>;

  @doc("Create or update container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DataContainerResource>;

  @doc("Delete container.")
  delete is ArmResourceDeleteAsync<DataContainerResource>;

  @doc("List Data containers.")
  list is ArmResourceListByParent<
    DataContainerResource,
    {
      ...BaseParameters<DataContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}
