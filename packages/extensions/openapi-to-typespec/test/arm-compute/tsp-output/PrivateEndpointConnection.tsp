import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DiskAccess.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("The Private Endpoint Connection resource.")
@parentResource(DiskAccess)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("The name of the private endpoint connection.")
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface DiskAccesses {
  @doc("Gets information about a private endpoint connection under a disk access resource.")
  getAPrivateEndpointConnection is ArmResourceRead<PrivateEndpointConnection>;
  @doc("Approve or reject a private endpoint connection under disk access resource, this can't be used to create a new private endpoint connection.")
  updateAPrivateEndpointConnection is ArmResourceCreateOrUpdateAsync<PrivateEndpointConnection>;
  @doc("Deletes a private endpoint connection under a disk access resource.")
  deleteAPrivateEndpointConnection is ArmResourceDeleteAsync<PrivateEndpointConnection>;
  @doc("List information about private endpoint connections under a disk access resource")
  listPrivateEndpointConnections is ArmResourceListByParent<PrivateEndpointConnection>;
}
