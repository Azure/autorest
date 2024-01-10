import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DiskAccess.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("The Private Endpoint Connection resource.")
@parentResource(DiskAccess)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  @doc("The name of the private endpoint connection.")
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnections {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets information about a private endpoint connection under a disk access resource.")
  @operationId("DiskAccesses_GetAPrivateEndpointConnection")
  getAPrivateEndpointConnection is ArmResourceRead<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Approve or reject a private endpoint connection under disk access resource, this can't be used to create a new private endpoint connection.")
  @operationId("DiskAccesses_UpdateAPrivateEndpointConnection")
  updateAPrivateEndpointConnection is ArmResourceCreateOrUpdateAsync<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes a private endpoint connection under a disk access resource.")
  @operationId("DiskAccesses_DeleteAPrivateEndpointConnection")
  deleteAPrivateEndpointConnection is ArmResourceDeleteAsync<PrivateEndpointConnection>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List information about private endpoint connections under a disk access resource")
  @operationId("DiskAccesses_ListPrivateEndpointConnections")
  listPrivateEndpointConnections is ArmResourceListByParent<PrivateEndpointConnection>;
}
