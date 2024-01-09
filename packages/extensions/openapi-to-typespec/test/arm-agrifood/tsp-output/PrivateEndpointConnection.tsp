import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("The private endpoint connection resource.")
@parentResource(DataManagerForAgriculture)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("Private endpoint connection name.")
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnections {
  @doc("Get Private endpoint connection object.")
  get is ArmResourceRead<PrivateEndpointConnection>;

  @doc("Approves or Rejects a Private endpoint connection request.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  @doc("Delete Private endpoint connection request.")
  delete is ArmResourceDeleteAsync<PrivateEndpointConnection>;

  @doc("Get list of Private endpoint connections.")
  listByResource is ArmResourceListByParent<PrivateEndpointConnection>;
}
