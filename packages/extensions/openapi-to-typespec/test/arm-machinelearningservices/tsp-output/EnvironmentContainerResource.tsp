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
model EnvironmentContainerResource is ProxyResource<EnvironmentContainer> {
  @doc("Container name. This is case-sensitive.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @path
  @key("environmentName")
  @segment("environments")
  name: string;
}

@armResourceOperations
interface RegistryEnvironmentContainers {
  @doc("Get container.")
  get is ArmResourceRead<EnvironmentContainerResource>;
  @doc("Create or update container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<EnvironmentContainerResource>;
  @doc("Delete container.")
  delete is ArmResourceDeleteAsync<EnvironmentContainerResource>;
  @doc("List environment containers.")
  list is ArmResourceListByParent<
    EnvironmentContainerResource,
    {
      ...BaseParameters<EnvironmentContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}
