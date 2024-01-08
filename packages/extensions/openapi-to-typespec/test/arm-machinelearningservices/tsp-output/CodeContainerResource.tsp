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
model CodeContainerResource is ProxyResource<CodeContainer> {
  @doc("Container name.")
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
  @key("codeName")
  @segment("codes")
  name: string;
}

@armResourceOperations
@projectedName("client", "RegistryCodeContainers")
interface CodeContainerResources_RegistryCodeContainers {
  @doc("Get Code container.")
  get is ArmResourceRead<CodeContainerResource>;
  @doc("Create or update Code container.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CodeContainerResource>;
  @doc("Delete Code container.")
  delete is ArmResourceDeleteAsync<CodeContainerResource>;
  @doc("List containers.")
  list is ArmResourceListByParent<
    CodeContainerResource,
    {
      ...BaseParameters<CodeContainerResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
}
