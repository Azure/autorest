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
/**
 * The Private Endpoint Connection resource.
 */
@parentResource(DiskAccess)
model PrivateEndpointConnection
  is ProxyResource<PrivateEndpointConnectionProperties> {
  /**
   * The name of the private endpoint connection.
   */
  @path
  @key("privateEndpointConnectionName")
  @segment("privateEndpointConnections")
  name: string;
}

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Gets information about a private endpoint connection under a disk access resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskAccesses_GetAPrivateEndpointConnection")
  getAPrivateEndpointConnection is ArmResourceRead<PrivateEndpointConnection>;

  /**
   * Approve or reject a private endpoint connection under disk access resource, this can't be used to create a new private endpoint connection.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskAccesses_UpdateAPrivateEndpointConnection")
  updateAPrivateEndpointConnection is ArmResourceCreateOrReplaceAsync<PrivateEndpointConnection>;

  /**
   * Deletes a private endpoint connection under a disk access resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskAccesses_DeleteAPrivateEndpointConnection")
  deleteAPrivateEndpointConnection is ArmResourceDeleteAsync<PrivateEndpointConnection>;

  /**
   * List information about private endpoint connections under a disk access resource
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskAccesses_ListPrivateEndpointConnections")
  listPrivateEndpointConnections is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@projectedName(PrivateEndpointConnections.updateAPrivateEndpointConnection::parameters.resource,
  "json",
  "privateEndpointConnection"
);
@@extension(PrivateEndpointConnections.updateAPrivateEndpointConnection::parameters.resource,
  "x-ms-client-name",
  "privateEndpointConnection"
);
@@doc(PrivateEndpointConnections.updateAPrivateEndpointConnection::parameters.resource,
  "private endpoint connection object supplied in the body of the Put private endpoint connection operation."
);
