import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * The Private Endpoint Connection resource.
 */
@parentResource(Workspace)
model PrivateEndpointConnection
  is Azure.ResourceManager.TrackedResource<PrivateEndpointConnectionProperties> {
  ...ResourceNameParameter<
    Resource = PrivateEndpointConnection,
    KeyName = "privateEndpointConnectionName",
    SegmentName = "privateEndpointConnections",
    NamePattern = ""
  >;
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface PrivateEndpointConnections {
  /**
   * Called by end-users to get a PE connection.
   */
  get is ArmResourceRead<PrivateEndpointConnection>;

  /**
   * Called by end-users to approve or reject a PE connection.
   * This method must validate and forward the call to NRP.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<PrivateEndpointConnection>;

  /**
   * Called by end-users to delete a PE connection.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<PrivateEndpointConnection>;

  /**
   * Called by end-users to get all PE connections.
   */
  list is ArmResourceListByParent<PrivateEndpointConnection>;
}

@@doc(PrivateEndpointConnection.name, "NRP Private Endpoint Connection Name");
@@doc(PrivateEndpointConnection.properties,
  "Private endpoint connection properties."
);
@@doc(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "PrivateEndpointConnection object"
);
