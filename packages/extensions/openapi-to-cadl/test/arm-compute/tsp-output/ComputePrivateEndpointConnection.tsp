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
model ComputePrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("The name of the private endpoint connection.")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface DiskAccesses {
  @doc("""
Gets information about a private endpoint connection under a disk access
resource.
""")
  getAPrivateEndpointConnection is ArmResourceRead<ComputePrivateEndpointConnection>;
  @doc("""
Approve or reject a private endpoint connection under disk access resource,
this can't be used to create a new private endpoint connection.
""")
  updateAPrivateEndpointConnection is ArmResourceCreateOrUpdateAsync<ComputePrivateEndpointConnection>;
  @doc("Deletes a private endpoint connection under a disk access resource.")
  deleteAPrivateEndpointConnection is ArmResourceDeleteAsync<ComputePrivateEndpointConnection>;
  @doc("List information about private endpoint connections under a disk access resource")
  listPrivateEndpointConnections is ArmResourceListByParent<ComputePrivateEndpointConnection>;
}
