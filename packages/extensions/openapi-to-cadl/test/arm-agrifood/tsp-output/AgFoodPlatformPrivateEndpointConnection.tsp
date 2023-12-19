import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./FarmBeat.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("The Private Endpoint Connection resource.")
@parentResource(FarmBeat)
model AgFoodPlatformPrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("Private endpoint connection name.")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface AgFoodPlatformPrivateEndpointConnections {
  @doc("Get Private endpoint connection object.")
  get is ArmResourceRead<AgFoodPlatformPrivateEndpointConnection>;
  @doc("Approves or Rejects a Private endpoint connection request.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<AgFoodPlatformPrivateEndpointConnection>;
  @doc("Delete Private endpoint connection request.")
  delete is ArmResourceDeleteAsync<AgFoodPlatformPrivateEndpointConnection>;
  @doc("Get list of Private endpoint connections.")
  listByResource is ArmResourceListByParent<AgFoodPlatformPrivateEndpointConnection>;
}
