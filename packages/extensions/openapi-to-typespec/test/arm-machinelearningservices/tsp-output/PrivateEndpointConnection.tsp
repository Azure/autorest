import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("The Private Endpoint Connection resource.")
@parentResource(Workspace)
model PrivateEndpointConnection
  is TrackedResource<PrivateEndpointConnectionProperties> {
  @doc("NRP Private Endpoint Connection Name")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface PrivateEndpointConnections {
  @doc("Called by end-users to get a PE connection.")
  get is ArmResourceRead<PrivateEndpointConnection>;

  @doc("""
Called by end-users to approve or reject a PE connection.
This method must validate and forward the call to NRP.
""")
  createOrUpdate is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  @doc("Called by end-users to delete a PE connection.")
  delete is ArmResourceDeleteSync<PrivateEndpointConnection>;

  @doc("Called by end-users to get all PE connections.")
  list is ArmResourceListByParent<PrivateEndpointConnection>;
}
